%token ID LPAR RPAR COMMA EOF
%start <unit> prog
%%

prog:
| expr EOF {}
;

expr:
| simple_expr {}
| ID nonempty_list(simple_expr) {}
| ID tuple {}
;

simple_expr:
| ID {}
| LPAR expr RPAR {}
| tuple {}
;

tuple:
| LPAR separated_list(COMMA, expr) RPAR {}
;
