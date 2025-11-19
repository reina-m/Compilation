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
| /* empty */                               { [] }
| ps=separated_nonempty_list(COMMA, varstyp) trail=option(COMMA)
    { let _ = trail in List.flatten ps }
;

// ⟨type_retour⟩ ::= ⟨type⟩ | ( ⟨type⟩+, ,? )
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
