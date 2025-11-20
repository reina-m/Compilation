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
    ] ;
  fun s ->
    try  Hashtbl.find h s
    with Not_found -> IDENT(s)

  (* partie bonus : point virgule automatique
  ⟨ident⟩ | ⟨entier⟩ | ⟨chaîne⟩ | true | false | nil
  | return | ++ | -- | ) | } *)

  let insert_semi = ref false (* variable globale pour savoir si on doit insérer un ; automatique au prochain \n *)

  (* fonction qui met insert_semi à true si le dernier token est dans l'ensemble donné par le sujet *)
  let mark token =
    insert_semi :=
      (match token with
       | IDENT _ | INT _ | STRING _
       | TRUE | FALSE | NIL
       | RETURN | INCR | DECR
       | RPAR | END -> true
       | _ -> false);
    token

  let unmark token =
    insert_semi := false;
    token
  (*  remet le flag à false quand on émet un token qui termine déjà l’instruction (exemple ;) *)
}

let digit = ['0'-'9']
let number = digit+
let alpha = ['a'-'z' 'A'-'Z' '_']
let ident = alpha (alpha | digit)*
  
rule token = parse
  | ['\n']            {
    new_line lexbuf;
    if !insert_semi then unmark SEMI else token lexbuf }
  | [' ' '\t' '\r']+  { token lexbuf }

  | "/*"              { comment lexbuf; token lexbuf }
  | "//" [^'\n']*        { token lexbuf }

  | '"' ([^ '"' '\n'])* '"' as s {
    mark (STRING(String.sub s 1 (String.length s - 2)))
}
  | number as n  { try mark (INT(Int64.of_string n)) 
                   with _ -> raise (Error "literal constant too large") }
  | ident as id  { mark (keyword_or_ident id) }

  | ";"  { unmark SEMI }
  | "("  { unmark LPAR }
  | ")"  { mark RPAR } (* ) fait partie des tokens qui insèrent un ; automatique *)
  | "{"  { unmark BEGIN }
  | "}"  { mark END } (* } fait partie des tokens qui insèrent un ; automatique *)
  | "*"  { unmark STAR }
  | ","  { unmark COMMA }
  | "."  { unmark DOT }
  | "+"  { unmark PLUS }
  | "-"  { unmark MINUS }
  | "/"  { unmark DIV }
  | "%"  { unmark MOD }
  | "==" { unmark EQ }
  | "!=" { unmark NEQ }
  | "<=" { unmark LE }
  | "<"  { unmark LT }
  | ">=" { unmark GE }
  | ">"  { unmark GT }
  | "&&" { unmark AND }
  | "||" { unmark OR }
  | "!"  { unmark NOT }
  | ":=" { unmark DEFINE }
  | "="  { unmark ASSIGN }
  | "++" { mark INCR } (* ++ fait partie des tokens qui insèrent un ; automatique *)
  | "--" { mark DECR } (* -- fait partie des tokens qui insèrent un ; automatique *)


  | _    { raise (Error ("unknown character : " ^ lexeme lexbuf)) }
  | eof  {
    if !insert_semi then unmark SEMI else EOF }

and comment = parse
  | '\n' { new_line lexbuf; comment lexbuf }
  | "*/" { () }
  | _    { comment lexbuf }
  | eof  { raise (Error "unterminated comment") }
