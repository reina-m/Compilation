open Mgoast
open Mips

let new_label =
  let cpt = ref (-1) in
  fun () -> incr cpt; Printf.sprintf "_label_%i" !cpt

let current_ctx : builder option ref = ref None

let get_ctx () =
  match !current_ctx with
  | Some b -> b
  | None -> failwith "compile: builder not initialised"

(* le résultat de l'expression est dans le registre $t0,
   la pile est utilisée pour les valeurs intermédiaires *)
let rec tr_expr e = match e.edesc with
  | Int(n)  -> li t0 (Int64.to_int n)   (* on supposera que les constantes entières
                                           sont représentables sur 32 bits *)
  | String(s) ->
      let lbl = string_const (get_ctx ()) s in
      la t0 lbl
  | Var(id) -> failwith "A compléter"
  | Binop(bop, e1, e2) ->
    let op = match bop with
      | Add -> add
      | Mul -> mul
      | Lt  -> slt
      | And -> and_
      | _ -> failwith "A compléter"
    in
    tr_expr e2
    @@ push t0
    @@ tr_expr e1
    @@ pop t1
    @@ op t0 t0 t1
  | _ -> failwith "A compléter"


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
    @@ jr ra
  | Expr e ->
    tr_expr e
  | _ -> failwith "A compléter"

let tr_fun df =
       label df.fname.id
    @@ tr_seq df.body

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
  let helpers = runtime_helpers b in
  emit_text b (helpers @@ runtime @@ tr_ldecl p);
  current_ctx := None;
  to_program b
