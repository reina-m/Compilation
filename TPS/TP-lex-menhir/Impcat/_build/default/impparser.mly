%{

  open Imp

%}

(* Liste de lexèmes *)
(* À COMPLÉTER *)
%token <int> INT
%token <string> IDENT
%token PLUS STAR
%token LPAR RPAR BEGIN END
%token SEMI
%token FUNCTION PRINT
%token EOF

(* Priorités *)
(* À COMPLÉTER *)
%left PLUS
%left STAR

(* Point d'entrée *)
%start program
%type <Imp.program> program

%%

(* Règles *)
(* À COMPLÉTER *)

program:
| (* À COMPLÉTER *) functions=list(fun_def) EOF 
    { {globals=[] (* À MODIFIER *) ; functions} }
;

fun_def:
| FUNCTION name=IDENT LPAR (* À COMPLÉTER *) RPAR
    BEGIN (* À COMPLÉTER *) code=list(instr) END
    { {name; code; params=[] (* À MODIFIER *) ; locals=[] (* À MODIFIER *)} }
;

instr:
| PRINT LPAR e=expr RPAR SEMI { Print(e) }
(* À COMPLÉTER *)
;

expr:
| n=INT { Int n }
| e1=expr op=binop e2=expr { Binop(op, e1, e2) }
(* À COMPLÉTER *)
;

%inline binop:
| PLUS { Add }
| STAR { Mul }
(* À COMPLÉTER *)
;
