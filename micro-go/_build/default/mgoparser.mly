%{

  open Lexing
  open Mgoast

  exception Error

%}

%token <int64> INT
%token <string> IDENT
%token <string> STRING
%token PACKAGE IMPORT TYPE STRUCT FUNC VAR RETURN FOR IF ELSE NEW
%token TRUE FALSE NIL
%token BOOL STRING1 MAIN INT1 // (2.2)
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

bloc:
| BEGIN END { [] }
;

expr:
| e = expr_desc {  { eloc = $startpos, $endpos; edesc = e } }
;

args_opt: // ⟨expr⟩⋆
|            { [] }
// exprs séparés par des , 
| es=separated_nonempty_list(COMMA, expr) trail=option(COMMA) // autorise , avant )
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
| pkg=ident DOT meth=ident LPAR args=args_opt RPAR
    { if pkg.id = "fmt" && meth.id = "Print"
      then Print(args)
      else raise Error }
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
