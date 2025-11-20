%{

  open Lexing
  open Mgoast

  exception Error

  (* fonctions utilitaires pour construire des nœuds de l'AST avec leur position *)
  let mk_instr loc idesc = { idesc; iloc = loc }
  let mk_var_expr id = { edesc = Var id; eloc = id.loc }
  let mk_bool_expr loc b = { edesc = Bool b; eloc = loc }

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
 TYPE id=ident STRUCT BEGIN fl=loption(fields) END SEMI // loption(X) = [X] | []
  { Struct { sname = id; fields = List.flatten fl } } 
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

fields: // liste de groupes separés par des ;
| xt=varstyp opt=option(SEMI)              { let _ = opt in [xt] }
| xt=varstyp SEMI xtl = fields             { xt :: xtl }
; // (ident * mgotype) list list

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
| ps=separated_nonempty_list(COMMA, varstyp) trail=option(COMMA)
    { let _ = trail in List.flatten ps }
;

// ⟨type_retour⟩ ::= ⟨type⟩ | ( ⟨type⟩+, ,? )
return_opt:
|                                           { [] }
| t=mgotype                                 { [t] }
| LPAR ts=separated_nonempty_list(COMMA, mgotype) trail=option(COMMA) RPAR
    { let _ = trail in ts }
;

bloc: // ⟨bloc⟩ ::= begin (⟨instr⟩; )⋆ ⟨instr⟩? ;? end
| BEGIN instrs=separated_list(SEMI, instr) trail=option(SEMI) END
    { let _ = trail in instrs }
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
| b=bloc                              { mk_instr ($startpos, $endpos) (Block b) }
| i=instr_if                          { i }
| VAR ids=idents1 typ=var_type_opt init=var_init_opt
    {
      let loc = ($startpos, $endpos) in
      let init_seq =
        match init with
        | None -> []
        | Some rhs ->
            let lhs = List.map mk_var_expr ids in
            let assign = mk_instr loc (Set (lhs, rhs)) in
            [assign]
      in
      mk_instr loc (Vars (ids, typ, init_seq))
    }
| RETURN es=expr_list_opt
    { mk_instr ($startpos, $endpos) (Return es) }
| FOR b=bloc
    {
      let loc = ($startpos, $endpos) in
      mk_instr loc (For (mk_bool_expr loc true, b))
    }
| FOR cond=expr b=bloc
    { mk_instr ($startpos, $endpos) (For (cond, b)) }
| FOR init=instr_simple_opt SEMI cond=expr SEMI post=instr_simple_opt body=bloc
    {
      let loc = ($startpos, $endpos) in
      let loop_body =
        match post with
        | None -> body
        | Some p -> body @ [p]
      in
      let loop_instr = mk_instr loc (For (cond, loop_body)) in
      let prefix =
        match init with
        | None -> []
        | Some i -> [i]
      in
      mk_instr loc (Block (prefix @ [loop_instr]))
    }
;

/* IF cond th
IF cond th ELSE block
IF cond th ELSE instr_if
*/ 

instr_if:
| IF cond=expr th=bloc
    { mk_instr ($startpos, $endpos) (If (cond, th, [])) }
| IF cond=expr th=bloc ELSE el=bloc
    { mk_instr ($startpos, $endpos) (If (cond, th, el)) }
| IF cond=expr th=bloc ELSE alt=instr_if
    { mk_instr ($startpos, $endpos) (If (cond, th, [alt])) }
;

/*⟨instr_simple⟩ ::= ⟨expr⟩
                 | ⟨expr⟩ (++ | --)
                 | ⟨expr⟩+ = ⟨expr⟩+
                 | ident+ := expr+
*/

instr_simple:
| e=expr
    { mk_instr ($startpos, $endpos) (Expr e) }
| e=expr INCR
    { mk_instr ($startpos, $endpos) (Inc e) }
| e=expr DECR
    { mk_instr ($startpos, $endpos) (Dec e) }
| lhs=expr_list1 ASSIGN rhs=expr_list1
    { mk_instr ($startpos, $endpos) (Set (lhs, rhs)) }
| ids=idents1 DEFINE rhs=expr_list1
    {
      let lhs = List.map mk_var_expr ids in
      mk_instr ($startpos, $endpos) (Set (lhs, rhs))
    }
;

// ⟨expr⟩+
expr_list1:
| es=separated_nonempty_list(COMMA, expr) { es }
;

// pour le retour de fonction
expr_list_opt:
|                                           { [] }
| es=expr_list1 trail=option(COMMA)         { let _ = trail in es }
;

expr:
| e = expr_desc {  { eloc = $startpos, $endpos; edesc = e } }
;

// pour l'argument des fonctions
args_opt:
|            { [] }
| es=expr_list1 trail=option(COMMA)
    { let _ = trail in es }
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
