%{

  open Lexing
  open Mgoast

  exception Error

%}

%token <int64> INT
%token <string> IDENT
%token <string> STRING
%token PACKAGE IMPORT TYPE STRUCT FUNC VAR RETURN FOR IF ELSE
%token TRUE FALSE NIL
%token BOOL STRING1 MAIN INT1
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

prog:
| PACKAGE main=IDENT SEMI decls=list(decl) EOF
    { if main="main" then (false, decls) else raise Error}
| PACKAGE main=IDENT SEMI IMPORT fmt=STRING SEMI decls=list(decl) EOF
    { if main="main" && fmt = "fmt" then (true, decls) else raise Error}
;

ident:
  id = IDENT { { loc = $startpos, $endpos; id = id } }
;

decl:
 TYPE id=ident STRUCT BEGIN fl=loption(fields) END SEMI
  { Struct { sname = id; fields = List.flatten fl } }
| FUNC fname=ident LPAR pl=params_opt RPAR ret=return_opt b=bloc SEMI
  { Fun { fname = fname; params = pl; return = ret; body = b } }
;

mgotype:
  | INT1    { TInt }
  | BOOL       { TBool }
  | STRING1    { TString }
  | STAR s=IDENT { TStruct(s) }
;

fields:
| xt=varstyp opt=option(SEMI)              { let _ = opt in [xt] }
| xt=varstyp SEMI xtl = fields             { xt :: xtl }
;

varstyp:
  |  ids=idents1 t=mgotype               { List.map (fun x -> (x, t)) ids }
;

idents1:
| x=ident                     { [x] }
| x=ident COMMA xs=idents1    { x :: xs }
;

params_opt:
| /* empty */                               { [] }
| ps=separated_nonempty_list(COMMA, varstyp) trail=option(COMMA)
    { let _ = trail in List.flatten ps }
;

return_opt:
| /* empty */                               { [] }
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

expr_desc:
| n=INT { Int(n) }
;
