open Mgoast
open Mips

(* informations d'environnement pour les variables locales et paramètres *)
type var_info = { offset : int; typ : typ option }

let new_label =
  let cpt = ref (-1) in
  fun () -> incr cpt; Printf.sprintf "_label_%i" !cpt

let current_ctx : builder option ref = ref None
let current_env : (string, var_info) Hashtbl.t ref = ref (Hashtbl.create 17)
let current_return_types : typ list ref = ref []
let current_return_buffer_offset : int option ref = ref None
let struct_offsets : (string * string, int) Hashtbl.t = Hashtbl.create 17
let struct_sizes : (string, int) Hashtbl.t = Hashtbl.create 17
let struct_fields : (string, (ident * typ) list) Hashtbl.t = Hashtbl.create 17
let fun_ret_types : (string, typ list) Hashtbl.t = Hashtbl.create 17

let get_ctx () =
  match !current_ctx with
  | Some b -> b
  | None -> failwith "compile: builder not initialised"

let find_binding name =
  let env = !current_env in
  match Hashtbl.find_opt env name with
  | Some b -> b
  | None -> failwith ("variable inconnue: " ^ name)

let lookup_offset name = (find_binding name).offset

let lookup_type name = (find_binding name).typ

let function_return_types fname =
  match Hashtbl.find_opt fun_ret_types fname with
  | Some r -> r
  | None -> failwith ("fonction inconnue: " ^ fname)

let call_return_count fname =
  List.length (function_return_types fname)

let expr_value_count e =
  match e.edesc with
  | Call (fn, _) -> call_return_count fn.id
  | _ -> 1

let total_value_count exprs =
  List.fold_left (fun acc e -> acc + expr_value_count e) 0 exprs

let rec infer_expr_type e =
  match e.edesc with
  | Int _ -> Some TInt
  | Bool _ -> Some TBool
  | String _ -> Some TString
  | Nil -> None
  | Var id -> lookup_type id.id
  | New s -> Some (TStruct s)
  | Dot (expr, field) ->
      (match infer_expr_type expr with
       | Some (TStruct s) ->
           (match Hashtbl.find_opt struct_fields s with
            | Some fields ->
                (match List.find_opt (fun (fid, _) -> fid.id = field.id) fields with
                 | Some (_, ftyp) -> Some ftyp
                 | None -> None)
            | None -> None)
       | _ -> None)
  | Call (fn, _) ->
      (match Hashtbl.find_opt fun_ret_types fn.id with
       | Some (ret :: _) -> Some ret
       | _ -> None)
  | Unop (_, _) -> Some TInt
  | Binop (_, _, _) -> Some TInt
  | Print _ -> None

let field_offset struct_name field_name =
  match Hashtbl.find_opt struct_offsets (struct_name, field_name) with
  | Some o -> o
  | None -> failwith ("champ " ^ field_name ^ " inconnu dans struct " ^ struct_name)

let rec tr_expr e = match e.edesc with
  | Int n -> li t0 (Int64.to_int n)
  | String s ->
      let lbl = string_const (get_ctx ()) s in
      la t0 lbl
  | Var id ->
      let offset = lookup_offset id.id in
      lw t0 offset fp
  | Unop (Opp, e1) ->
      tr_expr e1 @@ sub t0 zero t0
  | Unop (Not, e1) ->
      tr_expr e1 @@ seq t0 t0 zero
  | Binop (bop, e1, e2) ->
      let op = match bop with
        | Add -> add | Sub -> sub | Mul -> mul
        | Div -> (fun x _ z -> div_ x z @@ mflo x)
        | Rem -> (fun x _ z -> div_ x z @@ mfhi x)
        | Lt -> slt
        | Gt -> (fun x y z -> slt x z y)
        | Le -> (fun dst left right -> slt dst right left @@ seq dst dst zero)
        | Ge -> (fun dst left right -> slt dst left right @@ seq dst dst zero)
        | Eq -> seq | Neq -> sne
        | And -> and_ | Or -> or_
      in
      tr_expr e2
      @@ push t0
      @@ tr_expr e1
      @@ pop t1
      @@ op t0 t0 t1
  | Bool b -> li t0 (if b then 1 else 0)
  | Nil -> li t0 0
  | Call (fn, args) ->
      let returns = function_return_types fn.id in
      (match returns with
       | [] -> failwith "appel sans valeur utilisé comme expression"
       | [_] -> call_expr fn.id args
       | _ -> failwith "appel multivalué utilisé comme expression")
  | Print args ->
      let rec emit = function
        | [] -> nop
        | a :: q ->
            (match a.edesc with
             | Bool _ -> tr_expr a @@ jal "print_bool"
             | String _ -> tr_expr a @@ jal "print_string"
             | _ -> tr_expr a @@ jal "print_int")
            @@ emit q
      in
      emit args
  | New s ->
      let size =
        match Hashtbl.find_opt struct_sizes s with
        | Some sz -> sz
        | None -> failwith ("struct inconnue: " ^ s)
      in
      li a0 size @@ li v0 9 @@ syscall @@ move t0 v0
  | Dot (expr, field) ->
      let struct_name =
        match infer_expr_type expr with
        | Some (TStruct name) -> name
        | _ -> failwith "dot sur type non struct"
      in
      let offset = field_offset struct_name field.id in
      tr_expr expr @@ lw t0 offset t0

(* cours §9.1 — protocole d'appel standard : arguments empilés droite→gauche, retour dans $t0 *)
and call_expr fname args =
  let rec push_args = function
    | [] -> nop
    | a :: q -> push_args q @@ tr_expr a @@ push t0
  in
  let argc = List.length args in
  push_args args
  @@ jal fname
  @@ (if argc = 0 then nop else addi sp sp (4 * argc))

and push_arg_codes codes =
  match codes with
  | [] -> nop
  | code :: rest -> push_arg_codes rest @@ code @@ push t0

and call_store_multi fname args base_reg offset =
  let pointer_code =
    if offset = 0 then move t0 base_reg else addi t0 base_reg offset
  in
  let arg_codes = List.map tr_expr args in
  let codes = arg_codes @ [pointer_code] in
  let argc = List.length codes in
  push_arg_codes codes
  @@ jal fname
  @@ (if argc = 0 then nop else addi sp sp (4 * argc))

and call_stmt fname args =
  let returns = function_return_types fname in
  match returns with
  | [] ->
      let argc = List.length args in
      let rec push_args = function
        | [] -> nop
        | a :: q -> push_args q @@ tr_expr a @@ push t0
      in
      push_args args
      @@ jal fname
      @@ (if argc = 0 then nop else addi sp sp (4 * argc))
  | [_] ->
      call_expr fname args
  | _ ->
      let ret_count = List.length returns in
      let alloc = addi sp sp (-4 * ret_count) @@ move t3 sp in
      alloc
      @@ call_store_multi fname args t3 0
      @@ addi sp sp (4 * ret_count)

and store_expr base_reg offset e =
  match e.edesc with
  | Call (fn, args) ->
      let returns = function_return_types fn.id in
      let ret_count = List.length returns in
      (match ret_count with
       | 0 -> failwith "appel sans valeur dans une expression multiple"
       | 1 -> call_expr fn.id args @@ sw t0 offset base_reg
       | _ -> call_store_multi fn.id args base_reg offset)
  | _ ->
      tr_expr e @@ sw t0 offset base_reg

(* stocke les valeurs calculées dans un tampon fourni (cours §9.1, convention d'appel étendue) *)
and store_values base_reg offset exprs =
  match exprs with
  | [] -> nop
  | e :: rest ->
      let arity = expr_value_count e in
      store_expr base_reg offset e
      @@ store_values base_reg (offset + 4 * arity) rest

and assign_from_buffer base_reg index lhs =
  match lhs with
  | [] -> nop
  | dest :: rest ->
      let load = lw t0 (index * 4) base_reg in
      let store =
        match dest.edesc with
        | Var id ->
            let off = lookup_offset id.id in
            sw t0 off fp
        | Dot (record, field) ->
            let struct_name =
              match infer_expr_type record with
              | Some (TStruct name) -> name
              | _ -> failwith "affectation sur champ non struct"
            in
            let off = field_offset struct_name field.id in
            push t0
            @@ tr_expr record
            @@ pop t1
            @@ sw t1 off t0
        | _ -> failwith "cible d'affectation non gérée"
      in
      load @@ store @@ assign_from_buffer base_reg (index + 1) rest

and tr_seq = function
  | [] -> nop
  | [i] -> tr_instr i
  | i :: s -> tr_instr i @@ tr_seq s

and tr_instr i = match i.idesc with
  | If (c, s1, s2) ->
      let else_label = new_label () in
      let end_label = new_label () in
      tr_expr c
      @@ beqz t0 else_label
      @@ tr_seq s1
      @@ b end_label
      @@ label else_label
      @@ tr_seq s2
      @@ label end_label
  | For (c, s) ->
      let test_label = new_label () in
      let end_label = new_label () in
      label test_label
      @@ tr_expr c
      @@ beqz t0 end_label
      @@ tr_seq s
      @@ b test_label
      @@ label end_label
  | Return el ->
      let returns = !current_return_types in
      let ret_count = List.length returns in
      let code =
        match ret_count with
        | 0 ->
            if el <> [] then failwith "return: valeurs inattendues";
            nop
        | 1 ->
            (match el with
             | [] -> failwith "return: valeur manquante"
             | [e] -> tr_expr e
             | _ -> failwith "return: trop de valeurs")
        | _ ->
            let produced = total_value_count el in
            if produced <> ret_count then
              failwith "return: nombre de valeurs incohérent"
            else
              (match !current_return_buffer_offset with
               | None -> failwith "return: buffer absent"
               | Some off ->
                   lw t3 off fp
                   @@ store_values t3 0 el)
      in
      code
      @@ move sp fp
      @@ pop fp
      @@ pop ra
      @@ jr ra
  | Expr e ->
      (match e.edesc with
       | Call (fn, args) -> call_stmt fn.id args
       | _ -> tr_expr e)
  | Set (lhs, rhs) ->
      let total = total_value_count rhs in
      if total <> List.length lhs then
        failwith "affectation: nombre de valeurs incohérent"
      else
        let alloc =
          if total = 0 then nop else addi sp sp (-4 * total) @@ move t2 sp
        in
        let release =
          if total = 0 then nop else addi sp sp (4 * total)
        in
        alloc
        @@ store_values t2 0 rhs
        @@ assign_from_buffer t2 0 lhs
        @@ release
  | Inc e ->
      (match e.edesc with
       | Var id ->
           let off = lookup_offset id.id in
           lw t0 off fp @@ addi t0 t0 1 @@ sw t0 off fp
       | _ -> failwith "inc sur non-var")
  | Dec e ->
      (match e.edesc with
       | Var id ->
           let off = lookup_offset id.id in
           lw t0 off fp @@ addi t0 t0 (-1) @@ sw t0 off fp
       | _ -> failwith "dec sur non-var")
  | Block s -> tr_seq s
  | Vars (_, _, init_seq) -> tr_seq init_seq

(* cours §9.3 — les variables locales sont stockées à des offsets négatifs par rapport à $fp *)
let rec alloc_vars_seq env acc = function
  | [] -> acc
  | i :: q ->
      let after_i = alloc_vars_instr env acc i in
      alloc_vars_seq env after_i q

and alloc_vars_instr env acc i =
  match i.idesc with
  | Vars (ids, typ_opt, init_seq) ->
      let typ = match typ_opt with Some t -> Some t | None -> None in
      let next = List.fold_left (fun ofs id ->
          let new_ofs = ofs + 4 in
          Hashtbl.replace env id.id { offset = -new_ofs; typ };
          new_ofs) acc ids
      in
      alloc_vars_seq env next init_seq
  | If (_, s1, s2) ->
      let after_s1 = alloc_vars_seq env acc s1 in
      alloc_vars_seq env after_s1 s2
  | For (_, s) -> alloc_vars_seq env acc s
  | Block s -> alloc_vars_seq env acc s
  | _ -> acc

(* cours §9.3 — on alloue l'enregistrement d'activation en parcourant le corps *)
let alloc_activation_record df =
  let env = Hashtbl.create 17 in
  let param_offset = ref 8 in
  List.iter (fun (id, typ) ->
      Hashtbl.replace env id.id { offset = !param_offset; typ = Some typ };
      param_offset := !param_offset + 4) df.params;
  let ret_buf =
    if List.length df.return > 1 then begin
      let off = !param_offset in
      Hashtbl.replace env "__retbuf" { offset = off; typ = None };
      param_offset := !param_offset + 4;
      Some off
    end else None
  in
  let locals_size = alloc_vars_seq env 0 df.body in
  (env, locals_size, ret_buf)

(* cours §9.1 — prologue standard : sauvegarde $ra/$fp, déplacement de $fp, espace pour les locaux *)
let prologue locals_size =
  push ra
  @@ push fp
  @@ move fp sp
  @@ (if locals_size = 0 then nop else addi sp sp (-locals_size))

let epilogue =
  move sp fp
  @@ pop fp
  @@ pop ra
  @@ jr ra

let tr_fun df =
  let env, locals_size, ret_buf = alloc_activation_record df in
  current_env := env;
  current_return_types := df.return;
  current_return_buffer_offset := ret_buf;
  label df.fname.id
  @@ prologue locals_size
  @@ tr_seq df.body
  @@ epilogue

let rec tr_ldecl = function
  | Fun df :: p -> tr_fun df @@ tr_ldecl p
  | _ :: p -> tr_ldecl p
  | [] -> nop

let runtime =
  label "_start" @@ jal "main" @@ li v0 10 @@ syscall

let runtime_helpers b =
  let true_lbl = string_const b "true" in
  let false_lbl = string_const b "false" in
  let false_branch = new_label () in
  label "print_int"
  @@ move a0 t0 @@ li v0 1 @@ syscall @@ jr ra
  @@ label "print_string"
  @@ move a0 t0 @@ li v0 4 @@ syscall @@ jr ra
  @@ label "print_bool"
  @@ beqz t0 false_branch
  @@ la a0 true_lbl @@ li v0 4 @@ syscall @@ jr ra
  @@ label false_branch
  @@ la a0 false_lbl @@ li v0 4 @@ syscall @@ jr ra

let tr_prog p =
  let b = create () in
  current_ctx := Some b;
  Hashtbl.reset struct_offsets;
  Hashtbl.reset struct_sizes;
  Hashtbl.reset struct_fields;
  Hashtbl.reset fun_ret_types;
  List.iter (fun decl ->
      match decl with
      | Struct s ->
          Hashtbl.replace struct_fields s.sname.id s.fields;
          let size = List.length s.fields * 4 in
          Hashtbl.replace struct_sizes s.sname.id size;
          let rec add_offsets offset = function
            | [] -> ()
            | (fname, _) :: rest ->
                Hashtbl.replace struct_offsets (s.sname.id, fname.id) offset;
                add_offsets (offset + 4) rest
          in
          add_offsets 0 s.fields
      | Fun f -> Hashtbl.replace fun_ret_types f.fname.id f.return) p;
  let helpers = runtime_helpers b in
  emit_text b (helpers @@ runtime @@ tr_ldecl p);
  current_ctx := None;
  to_program b
