
(* The type of tokens. *)

type token = 
  | STAR
  | SEMI
  | RPAR
  | PRINT
  | PLUS
  | LPAR
  | INT of (int)
  | IDENT of (string)
  | FUNCTION
  | EOF
  | END
  | BEGIN

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val program: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Imp.program)
