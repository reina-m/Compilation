
(* The type of tokens. *)

type token = 
  | RPAR
  | LPAR
  | ID
  | EOF
  | COMMA

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val prog: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (unit)
