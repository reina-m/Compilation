open Mgoast
open Mips

let new_label =
  let cpt = ref (-1) in
  fun () -> incr cpt; Printf.sprintf "_label_%i" !cpt

let current_ctx : builder option ref = ref None
let current_env : (string * int) list ref = ref []
let current_locals = ref 0
let struct_fields : (string, (ident * typ) list) Hashtbl.t = Hashtbl.create 17
let struct_offsets : (string * string, int) Hashtbl.t = Hashtbl.create 17

let get_ctx () =
  match !current_ctx with
  | Some b -> b
  | None -> failwith "compile: builder not initialised"

let lookup id =
  try List.assoc id !current_env
  with Not_found -> failwith ("var inconnue: " ^ id)

(* compute field offset for a struct *)
let get_field_offset struct_name field_name =
  try Hashtbl.find struct_offsets (struct_name, field_name)
  with Not_found -> failwith ("field " ^ field_name ^ " not found in struct " ^ struct_name)

(* struct size in bytes *)
let get_struct_size struct_name =
  try
    let fields = Hashtbl.find struct_fields struct_name in
    List.length fields * 4  (* each field is 4 bytes *)
  with Not_found -> failwith ("struct " ^ struct_name ^ " not defined")

(* le résultat de l'expression est dans le registre $t0,
   la pile est utilisée pour les valeurs intermédiaires *)
let rec tr_expr e = match e.edesc with
  | Int(n)  -> li t0 (Int64.to_int n)   (* on supposera que les constantes entières
                                           sont représentables sur 32 bits *)
  | String(s) ->
      let lbl = string_const (get_ctx ()) s in
      la t0 lbl
  | Var(id) ->
      let off = lookup id.id in
      lw t0 off sp
  | Unop(Opp, e1) ->
      tr_expr e1
      @@ sub t0 zero t0
  | Unop(Not, e1) ->
      tr_expr e1
      @@ seq t0 t0 zero
  | Binop(bop, e1, e2) ->
    let op = match bop with
      | Add -> add
      | Sub -> sub
      | Mul -> mul
      | Div -> (fun x y z -> div_ x z @@ mflo x)
      | Rem -> (fun x y z -> div_ x z @@ mfhi x)
      | Lt  -> slt
      | Gt  -> (fun x y z -> slt x z y)
      | Le  -> (fun x y z -> slt x z y @@ seq x x zero)
      | Ge  -> (fun x y z -> slt x x z @@ seq x x zero)
      | Eq  -> seq
      | Neq -> sne
      | And -> and_
      | Or  -> or_
    in
    tr_expr e2
    @@ push t0
    @@ tr_expr e1
    @@ pop t1
    @@ op t0 t0 t1
  | Call(fn, args) ->
      let rec push_args = function
        | [] -> nop
        | a :: q -> push_args q @@ tr_expr a @@ push t0
      in
      let rec pop_args = function
        | [] -> nop
        | _ :: q -> pop t1 @@ pop_args q
      in
      push_args args
      @@ jal fn.id
      @@ pop_args args
  | Print args ->
      let rec emit = function
        | [] -> nop
        | a :: q ->
            (match a.edesc with
             | Int _ | Binop _ | Unop _ | Var _ | Call _ ->
                 tr_expr a
                 @@ jal "print_int"
             | Bool _ ->
                 tr_expr a
                 @@ jal "print_bool"
             | String _ ->
                 tr_expr a
                 @@ jal "print_string"
             | _ ->
                 tr_expr a
                 @@ jal "print_int")  (* default to int *)
            @@ emit q
      in
      emit args
  | Bool(b) ->
      li t0 (if b then 1 else 0)
  | Nil ->
      li t0 0
  | New(struct_name) ->
      (* allocation sur le tas avec taille correcte *)
      let size = get_struct_size struct_name in
      li a0 size
      @@ li v0 9
      @@ syscall
      @@ move t0 v0
  | Dot(e, field) ->
      (* accès à un champ avec offset correct *)
      (match e.edesc with
       | Var id ->
           let struct_type = (try
             (match List.assoc id.id !current_env with _ -> "")
           with _ -> "")
           in
           tr_expr e
           @@ lw t0 (get_field_offset struct_type field.id) t0
       | _ ->
           tr_expr e
           @@ lw t0 0 t0)  (* fallback to first field *)


let rec tr_seq = function
  | []   -> nop
  | [i]  -> tr_instr i
  | i::s -> tr_instr i @@ tr_seq s

and tr_instr i = match i.idesc with 
  | If(c, s1, s2) ->
    let then_label = new_label()
    and end_label = new_label()
    in
    tr_expr c
    @@ bnez t0 then_label
    @@ tr_seq s2
    @@ b end_label
    @@ label then_label
    @@ tr_seq s1
    @@ label end_label

  | For(c, s) ->
    let test_label = new_label()
    and code_label = new_label()
    in
    b test_label
    @@ label code_label
    @@ tr_seq s
    @@ label test_label
    @@ tr_expr c
    @@ bnez t0 code_label
  | Return el ->
    (match el with
     | [] -> nop
     | [e] -> tr_expr e
     | _ -> failwith "retours multiples non gérés")
    @@ addi sp sp (!current_locals) (* désalloue les locaux *)
    @@ pop ra
    @@ jr ra
  | Expr e ->
    tr_expr e
  | Set (lhs, rhs) ->
      (match lhs, rhs with
       | [e1], [e2] ->
           (match e1.edesc with
            | Var id ->
                let off = lookup id.id in
                tr_expr e2 @@ sw t0 off sp
            | _ -> failwith "affectation complexe non gérée")
       | _ -> failwith "affectation multiple non gérée")
  | Inc e ->
      (match e.edesc with
       | Var id ->
           let off = lookup id.id in
           lw t0 off sp @@ addi t0 t0 1 @@ sw t0 off sp
       | _ -> failwith "inc sur non-var")
  | Dec e ->
      (match e.edesc with
       | Var id ->
           let off = lookup id.id in
           lw t0 off sp @@ addi t0 t0 (-1) @@ sw t0 off sp
       | _ -> failwith "dec sur non-var")
  | Block s ->
      tr_seq s
  | Vars(ids, _typ_opt, init_seq) ->
      let n = List.length ids in
      current_locals := !current_locals + n * 4;
      let rec bind_vars offset = function
        | [] -> []
        | id :: q -> (id.id, offset) :: bind_vars (offset + 4) q
      in
      current_env := (bind_vars (4) (List.rev ids)) @ !current_env;
      tr_seq init_seq

let tr_fun df =
  let rec bind_params ofs = function
    | [] -> []
    | (id, _) :: q -> (id.id, ofs) :: bind_params (ofs + 4) q
  in
  current_env := bind_params 4 df.params;
  current_locals := 0;
       label df.fname.id
    @@ push ra
    @@ tr_seq df.body
    @@ addi sp sp (!current_locals)
    @@ pop ra
    @@ jr ra

let rec tr_ldecl = function
    Fun df::p -> tr_fun df @@ tr_ldecl p
  | _ :: p -> tr_ldecl p
  | [] -> nop

let runtime_helpers b =
  let lbl_true  = string_const b "true" in
  let lbl_false = string_const b "false" in
     label "print_int"
  @@ move a0 t0
  @@ li v0 1
  @@ syscall
  @@ jr ra
  @@ label "print_string"
  @@ move a0 t0
  @@ li v0 4
  @@ syscall
  @@ jr ra
  @@ label "print_bool"
  @@ beqz t0 lbl_false
  @@ la a0 lbl_true
  @@ li v0 4
  @@ syscall
  @@ jr ra
  @@ label lbl_false
  @@ la a0 lbl_false
  @@ li v0 4
  @@ syscall
  @@ jr ra

let runtime =
     label "_start"
  @@ jal "main"
  @@ li v0 10
  @@ syscall

let tr_prog p =
  let b = create () in
  current_ctx := Some b;
  
  (* initialize struct field information *)
  List.iter (fun decl ->
    match decl with
    | Struct s ->
        Hashtbl.add struct_fields s.sname.id s.fields;
        (* precompute field offsets *)
        let rec set_offsets offset = function
          | [] -> ()
          | (field_name, _field_typ) :: rest ->
              Hashtbl.add struct_offsets (s.sname.id, field_name.id) offset;
              set_offsets (offset + 4) rest
        in
        set_offsets 0 s.fields
    | Fun _ -> ()) p;
  
  let helpers = runtime_helpers b in
  emit_text b (helpers @@ runtime @@ tr_ldecl p);
  current_ctx := None;
  to_program b
