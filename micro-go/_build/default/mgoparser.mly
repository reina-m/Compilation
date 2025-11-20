%{

  open Lexing
  open Mgoast

  exception Error

  (* fonctions utilitaires pour construire des nœuds de l'AST avec leur position *)
  let mk_i loc idesc = { idesc; iloc = loc }
  let mk_var id = { edesc = Var id; eloc = id.loc }
  let mk_bool loc b = { edesc = Bool b; eloc = loc }
  (* on autorise x, y := f() mais pas (a[i]:= 3) par exemple 
  ident+ := expr+
  *)
  let only_vars el =
    List.map (fun e ->
        match e.edesc with
        | Var id -> id
        | _ -> raise Error) el

%}

%token <int64> INT
%token <string> IDENT
%token <string> STRING
%token PACKAGE IMPORT TYPE STRUCT FUNC VAR RETURN FOR IF ELSE NEW
%token TRUE FALSE NIL
%token BOOL STRING1 INT1 // (2.2)
%token LPAR RPAR BEGIN END SEMI COMMA DOT
%token STAR PLUS MINUS DIV MOD
%token EQ NEQ LT LE GT GE
%token AND OR NOT
%token DEFINE ASSIGN INCR DECR
%token EOF

(* voir les tables d'associativité dans le sujet *)
%left OR
%left AND
%nonassoc EQ NEQ LT LE GT GE
%left PLUS MINUS
%left STAR DIV MOD
%right UMINUS UNOT
%left DOT

%start prog
%type <Mgoast.program> prog

%%

// un fichier commence par package main, éventuellement suivi de l'import "fmt" (2.2)
prog:
| PACKAGE main=IDENT SEMI decls=list(decl) EOF
    { if main="main" then (false, decls) else raise Error}
| PACKAGE main=IDENT SEMI IMPORT fmt=STRING SEMI decls=list(decl) EOF
    { if main="main" && fmt = "fmt" then (true, decls) else raise Error}
;

// position dans le code source des identifiants
ident:
  id = IDENT { { loc = $startpos, $endpos; id = id } }
;

decl: // ⟨decl⟩ ::= ⟨structure⟩ | ⟨fonction⟩
// ⟨structure⟩ ::= type ⟨ident⟩ struct { (⟨vars⟩;)⋆⟨vars⟩? } ;
 TYPE id=ident STRUCT BEGIN groups=field_groups END SEMI
  { Struct { sname = id; fields = List.flatten groups } } 
// ⟨fonction⟩ ::= func ⟨ident⟩ ( (⟨vars⟩,)⋆⟨vars⟩? ) ⟨type_retour⟩? ⟨bloc⟩ ;
| FUNC fname=ident LPAR pl=params_opt RPAR ret=return_opt b=bloc SEMI
  { Fun { fname = fname; params = pl; return = ret; body = b } }
;

mgotype:
  | INT1    { TInt }
  | BOOL       { TBool }
  | STRING1    { TString }
  | STAR s=IDENT { TStruct(s) }
;

field_groups:
|                                           { [] }
| vs=varstyp rest=field_groups_tail         { vs :: rest }
; // (ident * mgotype) list list

field_groups_tail:
| SEMI rest=field_groups                    { rest }
|                                           { [] }
;

varstyp: // ⟨vars⟩ ::= ⟨ident⟩+, ⟨type⟩ (groupe d'identifiants du même type e.g. quo int ou quo, rem int)
  |  ids=idents1 t=mgotype               { List.map (fun x -> (x, t)) ids }
; // (ident * mgotype) list

idents1:
| x=ident                     { [x] }
| x=ident COMMA xs=idents1    { x :: xs }
;

var_type_opt:
|                                 { None }
| t=mgotype                      { Some t }
;

var_init_opt:
|                                 { None }
| ASSIGN rhs=expr_list1           { Some rhs }
;

instr_simple_opt:
|                                 { None }
| i=instr_simple                  { Some i }
;

params_opt:
|                                           { [] }
| lst=param_list                            { lst }
;

param_list:
| vs=varstyp rest=param_tail                { vs @ rest }
;

param_tail:
| COMMA rest=param_list                     { rest }
| COMMA                                     { [] }
|                                           { [] }
;

// ⟨type_retour⟩ ::= ⟨type⟩ | ( ⟨type⟩+, ,? )
return_opt:
|                                           { [] }
| t=mgotype                                 { [t] }
| LPAR ts=ret_type_list RPAR                { ts }
;

ret_type_list:
| t=mgotype rest=ret_type_tail              { t :: rest }
;

ret_type_tail:
| COMMA rest=ret_type_list                  { rest }
| COMMA                                     { [] }
|                                           { [] }
;

bloc: // ⟨bloc⟩ ::= begin (⟨instr⟩; )⋆ ⟨instr⟩? ;? end
| BEGIN instrs=seq END { instrs }
;

seq:
|                                           { [] }
| i=instr rest=seq_tail                     { i :: rest }
;

seq_tail:
| SEMI rest=seq                             { rest }
|                                           { [] }
;

/* ⟨instr⟩ ::= ⟨instr_simple⟩
            | ⟨bloc⟩
            | ⟨instr_if⟩
            | var ⟨ident⟩+, ⟨type⟩? (:= ⟨expr⟩+ )?
            | return ⟨expr⟩* 
            | for ⟨bloc⟩
            | for ⟨expr⟩ ⟨bloc⟩
            | for ⟨instr_simple⟩? ; ⟨expr⟩ ; ⟨instr_simple⟩? ⟨bloc⟩
*/

instr:
| s=instr_simple                      { s }
| b=bloc                              { mk_i ($startpos, $endpos) (Block b) }
| i=instr_if                          { i }
| VAR ids=idents1 typ=var_type_opt init=var_init_opt
    {
      let loc = ($startpos, $endpos) in
      let init_seq =
        match init with
        | None -> []
        | Some rhs ->
            let lhs = List.map mk_var ids in
            let assign = mk_i loc (Set (lhs, rhs)) in
            [assign]
      in
      mk_i loc (Vars (ids, typ, init_seq))
    }
| RETURN es=expr_list_opt
    { mk_i ($startpos, $endpos) (Return es) }
| FOR b=bloc
    {
      let loc = ($startpos, $endpos) in
      mk_i loc (For (mk_bool loc true, b))
    }
| FOR cond=expr b=bloc
    { mk_i ($startpos, $endpos) (For (cond, b)) }
| FOR init=instr_simple_opt SEMI cond=expr SEMI post=instr_simple_opt body=bloc
    {
      let loc = ($startpos, $endpos) in
      let loop_body =
        match post with
        | None -> body
        | Some p -> body @ [p]
      in
      let loop_instr = mk_i loc (For (cond, loop_body)) in
      let prefix =
        match init with
        | None -> []
        | Some i -> [i]
      in
      mk_i loc (Block (prefix @ [loop_instr]))
    }
;

/* IF cond th
IF cond th ELSE block
IF cond th ELSE instr_if
*/ 

instr_if:
| IF cond=expr th=bloc
    { mk_i ($startpos, $endpos) (If (cond, th, [])) }
| IF cond=expr th=bloc ELSE el=bloc
    { mk_i ($startpos, $endpos) (If (cond, th, el)) }
| IF cond=expr th=bloc ELSE alt=instr_if
    { mk_i ($startpos, $endpos) (If (cond, th, [alt])) }
;

/*⟨instr_simple⟩ ::= ⟨expr⟩
                 | ⟨expr⟩ (++ | --)
                 | ⟨expr⟩+ = ⟨expr⟩+
                 | ident+ := expr+
*/

instr_simple:
| e=expr
    { mk_i ($startpos, $endpos) (Expr e) }
| e=expr INCR
    { mk_i ($startpos, $endpos) (Inc e) }
| e=expr DECR
    { mk_i ($startpos, $endpos) (Dec e) }
| lhs=expr_list1 ASSIGN rhs=expr_list1
    { mk_i ($startpos, $endpos) (Set (lhs, rhs)) }
| lhs=expr_list1 DEFINE rhs=expr_list1
    {
      let ids = only_vars lhs in
      let lhs_exprs = List.map mk_var ids in
      mk_i ($startpos, $endpos) (Set (lhs_exprs, rhs))
    }
;

// ⟨expr⟩+
expr_list1:
| e=expr rest=expr_list_tail               { e :: rest }
;

// pour le retour de fonction
expr_list_opt:
|                                           { [] }
| es=expr_list1                             { es }
;

expr_list_tail:
| COMMA rest=expr_list1                     { rest }
| COMMA                                     { [] }
|                                           { [] }
;

expr:
| e = expr_desc {  { eloc = $startpos, $endpos; edesc = e } }
;

// pour l'argument des fonctions
args_opt:
|            { [] }
| es=expr_list1 { es }
;

/* ⟨expr⟩ ::= ⟨entier⟩ | ⟨chaîne⟩ | true | false | nil
          | ( ⟨expr⟩ )
          | ⟨ident⟩
          | ⟨expr⟩ . ⟨ident⟩
          | ⟨ident⟩ ( ⟨expr⟩⋆, )
          | fmt.Print ( ⟨expr⟩⋆, )
          | ! ⟨expr⟩ | - ⟨expr⟩
          | ⟨expr⟩ ⟨op⟩ ⟨expr⟩ */

expr_desc:
| n=INT                       { Int(n) }
| s=STRING                    { String(s) }
| TRUE                        { Bool(true) }
| FALSE                       { Bool(false) }
| NIL                         { Nil }
| NEW LPAR s=IDENT RPAR       { New(s) } // new(S) crée une nouvelle structure
| LPAR e=expr RPAR            { e.edesc }
| x=ident                     { Var(x) }
| e=expr DOT field=ident      { Dot(e, field) }
| fn=ident LPAR args=args_opt RPAR
    { Call(fn, args) } // appel classique
| target=expr DOT meth=ident LPAR args=args_opt RPAR
    {
      match target.edesc with
      | Var pkg when pkg.id = "fmt" && meth.id = "Print" -> Print(args)
      | _ -> raise Error
    }
| MINUS e=expr %prec UMINUS   { Unop(Opp, e) }
| NOT e=expr %prec UNOT       { Unop(Not, e) }
| e1=expr PLUS e2=expr        { Binop(Add, e1, e2) }
| e1=expr MINUS e2=expr       { Binop(Sub, e1, e2) }
| e1=expr STAR e2=expr        { Binop(Mul, e1, e2) }
| e1=expr DIV e2=expr         { Binop(Div, e1, e2) }
| e1=expr MOD e2=expr         { Binop(Rem, e1, e2) }
| e1=expr EQ e2=expr          { Binop(Eq, e1, e2) }
| e1=expr NEQ e2=expr         { Binop(Neq, e1, e2) }
| e1=expr LT e2=expr          { Binop(Lt, e1, e2) }
| e1=expr LE e2=expr          { Binop(Le, e1, e2) }
| e1=expr GT e2=expr          { Binop(Gt, e1, e2) }
| e1=expr GE e2=expr          { Binop(Ge, e1, e2) }
| e1=expr AND e2=expr         { Binop(And, e1, e2) }
| e1=expr OR e2=expr          { Binop(Or, e1, e2) }
;
