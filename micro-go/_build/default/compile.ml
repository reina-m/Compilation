open Mgoast
open Mips

(* 9.3 : accès aux variables locales via fp *)
type var_info = { offset : int; typ : typ option }

(* 4.1 + p 157 : la traduction des instructions nécessite la génération de nouvelles étiquettes pour les sauts *)
let new_label =
  let cpt = ref (-1) in
  fun () -> incr cpt; Printf.sprintf "_label_%i" !cpt

(* contexte de construction du code *)
let current_ctx : builder option ref = ref None
let current_env : (string, var_info) Hashtbl.t ref = ref (Hashtbl.create 17) (* 9.3 : allocation du tableau d'activation *)
(* pour le support des retours multiples + les structures allouées sur le tas + signature des appels *)
let current_return_types : typ list ref = ref []
let struct_offsets : (string * string, int) Hashtbl.t = Hashtbl.create 17
let struct_sizes : (string, int) Hashtbl.t = Hashtbl.create 17
let struct_fields : (string, (ident * typ) list) Hashtbl.t = Hashtbl.create 17
let fun_ret_types : (string, typ list) Hashtbl.t = Hashtbl.create 17

let get_ctx () =
  match !current_ctx with
  | Some b -> b
  | None -> failwith "compile: builder not initialised"

(* accès à l'environnement courant *)
let find_binding x =
  let env = !current_env in
  match Hashtbl.find_opt env x with
  | Some b -> b
  | None -> { offset = 0; typ = None }

(* raccourcis pour accéder au binding *)
let offset x = (find_binding x).offset
let typ x = (find_binding x).typ

(* récupère les types de retour d'une fonction *)
let ret_types f =
  match Hashtbl.find_opt fun_ret_types f with
  | Some r -> r
  | None -> []

let arity f = List.length (ret_types f)

(* typechecker garantit validité; inférence minimale pour dispatch Print *)
let infer_expr_type e =
  match e.edesc with
  | Bool _ -> Some TBool
  | String _ -> Some TString
  | Var id -> typ id.id
  | _ -> Some TInt

(* 9.4 : p.156 - 157, résultat dans $t0*)
let rec tr_expr e = match e.edesc with
  | Int n -> li t0 (Int64.to_int n)
  | String s ->
      let lbl = string_const (get_ctx ()) s in
      la t0 lbl
  | Var id ->
      let off = offset id.id in
      lw t0 off fp
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
      let c = arity fn.id in
      if c = 1 then call_expr fn.id args else nop
  | Print args ->
      (* fmt.Print par type *)
      let rec aux = function
        | [] -> nop
        | a :: q ->
            (match a.edesc with
             | Bool _ -> tr_expr a @@ jal "print_bool"
             | String _ -> tr_expr a @@ jal "print_string"
             | _ -> tr_expr a @@ jal "print_int")
            @@ aux q
      in
      aux args
  | New s ->
    (* sujet 2 : allocation sur le tas syscall 9*)
      let size =
        match Hashtbl.find_opt struct_sizes s with
        | Some sz -> sz
        | None -> 0
      in
      li a0 size @@ li v0 9 @@ syscall @@ move t0 v0
  | Dot (expr, field) ->
    (*accès champ via offset *)
      let struct_name =
        match infer_expr_type expr with
        | Some (TStruct name) -> name
        | _ -> ""
      in
      let off = match Hashtbl.find_opt struct_offsets (struct_name, field.id) with
        | Some o -> o
        | None -> 0
      in
      tr_expr expr @@ lw t0 off t0

(* 9.1 :  protocole d'appel standard *)
and call_expr fname args =
  let rec push_args = function
    | [] -> nop
    | a :: q -> push_args q @@ tr_expr a @@ push t0
  in
  let argc = List.length args in
  push_args args
  @@ jal fname
  @@ (if argc = 0 then nop else addi sp sp (4 * argc))

and call_stmt fname args =
  call_expr fname args

(* enregistre $t0 dans une destination lhs via sw *)
and store_lhs dest =
  match dest.edesc with
  | Var id ->
      let off = offset id.id in
      sw t0 off fp
  | Dot (record, field) ->
      let struct_name =
        match infer_expr_type record with
        | Some (TStruct name) -> name
        | _ -> ""
      in
      let off = match Hashtbl.find_opt struct_offsets (struct_name, field.id) with
        | Some o -> o
        | None -> 0
      in
      push t0
      @@ tr_expr record
      @@ pop t1
      @@ sw t1 off t0
  | _ -> nop

(* p 158 *)
and tr_seq = function
  | [] -> nop
  | [i] -> tr_instr i
  | i :: s -> tr_instr i @@ tr_seq s

(* p158*)
and tr_instr i = match i.idesc with
  (* même raisonnement à chaque fois il faut juste tout traiter *)
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
    (* là il faut gérer les retours multiples via tuple sur heap (deuxième méthode) *)
      let returns = !current_return_types in
      let ret_count = List.length returns in
      let code =
        match ret_count with
        | 0 -> nop
        | 1 ->
            (* expression retournée directement dans $t0 *)
            (match el with
             | [e] -> tr_expr e
             | _ -> nop)  (* typechecker garantit exactement 1 valeur *)
        | _ ->
            (* construction d'un tuple sur le tas *)
            let size = 4 * ret_count in
            li a0 size
            @@ li v0 9
            @@ syscall
            @@ move t0 v0
            @@ move t3 t0
            @@ (let rec store_vals offset = function
                | [] -> nop
                | e :: rest ->
                    (match e.edesc with
                     | Call (fn, args) ->
                         let rc = arity fn.id in
                         (match rc with
                          | 0 -> nop
                          | 1 ->
                              call_expr fn.id args
                              @@ sw t0 offset t3
                              @@ store_vals (offset + 4) rest
                          | _ ->
                              let rec copy_tuple i =
                                if i = rc then nop
                                else
                                  let dst_off = offset + (4 * i) in
                                  lw t1 (4 * i) t0
                                  @@ sw t1 dst_off t3
                                  @@ copy_tuple (i + 1)
                              in
                              call_expr fn.id args
                              @@ copy_tuple 0
                              @@ store_vals (offset + 4 * rc) rest)
                     | _ ->
                         tr_expr e
                         @@ sw t0 offset t3
                         @@ store_vals (offset + 4) rest)
                in
                store_vals 0 el)
            @@ move t0 t3
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
      (* assignation multiple via tuple *)
      (match rhs with
       | [ { edesc = Call (fn, args) ; _ } ] when arity fn.id > 1 ->
           (* typechecker garantit ret_count = List.length lhs *)
           call_expr fn.id args
           @@ move t3 t0
           @@ (let rec assign_vals index = function
               | [] -> nop
               | dest :: rest ->
                   lw t0 (index * 4) t3
                   @@ store_lhs dest
                   @@ assign_vals (index + 1) rest
               in
               assign_vals 0 lhs)
       | _ ->
           (* assignation simple *)
           let rec push_rhs = function
             | [] -> nop
             | e :: rest -> push_rhs rest @@ tr_expr e @@ push t0
           in
           let rec assign_lhs = function
             | [] -> nop
             | dest :: rest -> pop t0 @@ store_lhs dest @@ assign_lhs rest
           in
           push_rhs rhs @@ assign_lhs lhs)
  | Inc e ->
      (match e.edesc with
       | Var id ->
           let off = offset id.id in
           lw t0 off fp @@ addi t0 t0 1 @@ sw t0 off fp
       | _ -> nop)  (* typechecker garantit que c'est une Var *)
  | Dec e ->
      (match e.edesc with
       | Var id ->
           let off = offset id.id in
           lw t0 off fp @@ addi t0 t0 (-1) @@ sw t0 off fp
       | _ -> nop)  (* typechecker garantit que c'est une Var *)
  | Block s -> tr_seq s
  | Vars (_, _, init_seq) -> tr_seq init_seq

(* 9.3 : allocation des variables locales dans le tableau d'activation *)
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
          (* nouvelle variable à offset -(ofs + 4) par rapport à fp *)
          let new_ofs = ofs + 4 in
          Hashtbl.replace env id.id { offset = -new_ofs; typ };
          new_ofs) acc ids
      in
      alloc_vars_seq env next init_seq
  | If (_, s1, s2) ->
      (* alloue dans les deux branches *)
      let after_s1 = alloc_vars_seq env acc s1 in
      alloc_vars_seq env after_s1 s2
  | For (_, s) -> alloc_vars_seq env acc s
  | Block s -> alloc_vars_seq env acc s
  | _ -> acc

(* initialise l'environnement pour une fonction*)
let alloc_activation_record df =
  let env = Hashtbl.create 17 in
  let param_offset = ref 8 in
  List.iter (fun (id, typ) ->
      Hashtbl.replace env id.id { offset = !param_offset; typ = Some typ };
      param_offset := !param_offset + 4) df.params;
  let locals_size = alloc_vars_seq env 0 df.body in
  (env, locals_size)

(* début d'une fonction *)
let begin_ locals_size =
  push ra
  @@ push fp
  @@ move fp sp
  @@ (if locals_size = 0 then nop else addi sp sp (-locals_size))

(* fin d'une fonction *)
let end_ =
  move sp fp
  @@ pop fp
  @@ pop ra
  @@ jr ra

(* début, corps, fin de la fonction (tout en un)*)
let tr_fun df =
  let env, size = alloc_activation_record df in
  current_env := env;
  current_return_types := df.return;
  label df.fname.id
  @@ begin_ size
  @@ tr_seq df.body
  @@ end_

(* compilation des déclarations *)
let rec tr_ldecl = function
  | Fun df :: p -> tr_fun df @@ tr_ldecl p
  | _ :: p -> tr_ldecl p
  | [] -> nop

(* syscall 10 poyr exit*)
let runtime =
  label "_start" @@ jal "main" @@ li v0 10 @@ syscall

(*pour fmt.print *)
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

(*compilation d u programme complet *)
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
