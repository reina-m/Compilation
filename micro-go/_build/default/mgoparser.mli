
(* The type of tokens. *)

type token = 
  | VAR
  | TYPE
  | TRUE
  | STRUCT
  | STRING1
  | STRING of (string)
  | STAR
  | SEMI
  | RPAR
  | RETURN
  | PLUS
  | PACKAGE
  | OR
  | NOT
  | NIL
  | NEW
  | NEQ
  | MOD
  | MINUS
  | MAIN
  | LT
  | LPAR
  | LE
  | INT1
  | INT of (int64)
  | INCR
  | IMPORT
  | IF
  | IDENT of (string)
  | GT
  | GE
  | FUNC
  | FOR
  | FALSE
  | EQ
  | EOF
  | END
  | ELSE
  | DOT
  | DIV
  | DEFINE
  | DECR
  | COMMA
  | BOOL
  | BEGIN
  | ASSIGN
  | AND

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val prog: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Mgoast.program)
