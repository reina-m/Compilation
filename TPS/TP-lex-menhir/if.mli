
(* The type of tokens. *)

type token = 
  | SEMI
  | IF
  | EOF
  | ELSE
  | COND
  | ATOM

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val prog: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (unit)
