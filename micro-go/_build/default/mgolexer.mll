{

  open Lexing
  open Mgoparser

  exception Error of string

  let keyword_or_ident =
  let h = Hashtbl.create 17 in
  List.iter (fun (s, k) -> Hashtbl.add h s k)
    [ "package",    PACKAGE;
      "import",     IMPORT;
      "type",       TYPE;      
      "struct",     STRUCT;
      "func",       FUNC;
      "var",        VAR;
      "new",        NEW;
      "return",     RETURN;
      "for",        FOR;
      "if",         IF;
      "else",       ELSE;
      "int",        INT1;
      "bool",       BOOL;
      "string",     STRING1;
      "true",       TRUE;
      "false",      FALSE;
      "nil",        NIL;
      "main",       MAIN;
    ] ;
  fun s ->
    try  Hashtbl.find h s
    with Not_found -> IDENT(s)
        
}

let digit = ['0'-'9']
let number = digit+
let alpha = ['a'-'z' 'A'-'Z' '_']
let ident = alpha (alpha | digit)*
  
rule token = parse
  | ['\n']            { new_line lexbuf; token lexbuf }
  | [' ' '\t' '\r']+  { token lexbuf }

  | "/*"              { comment lexbuf; token lexbuf }
  | "//" [^'\n']*        { token lexbuf }

  | '"' ("[^\"\n]")* '"' as s {
    STRING(String.sub s 1 (String.length s - 2))
}
  | number as n  { try INT(Int64.of_string n) 
                   with _ -> raise (Error "literal constant too large") }
  | ident as id  { keyword_or_ident id }

  | ";"  { SEMI }
  | "("  { LPAR }
  | ")"  { RPAR }
  | "{"  { BEGIN }
  | "}"  { END }
  | "*"  { STAR }
  | ","  { COMMA }
  | "."  { DOT }
  | "+"  { PLUS }
  | "-"  { MINUS }
  | "/"  { DIV }
  | "%"  { MOD }
  | "==" { EQ }
  | "!=" { NEQ }
  | "<=" { LE }
  | "<"  { LT }
  | ">=" { GE }
  | ">"  { GT }
  | "&&" { AND }
  | "||" { OR }
  | "!"  { NOT }
  | ":=" { DEFINE }
  | "="  { ASSIGN }
  | "++" { INCR }
  | "--" { DECR }


  | _    { raise (Error ("unknown character : " ^ lexeme lexbuf)) }
  | eof  { EOF }

and comment = parse
  | '\n' { new_line lexbuf; comment lexbuf }
  | "*/" { () }
  | _    { comment lexbuf }
  | eof  { raise (Error "unterminated comment") }
