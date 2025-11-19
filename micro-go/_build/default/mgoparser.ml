
module MenhirBasics = struct
  
  exception Error
  
  let _eRR =
    fun _s ->
      raise Error
  
  type token = 
    | VAR
    | TYPE
    | TRUE
    | STRUCT
    | STRING1
    | STRING of (
# 12 "mgoparser.mly"
       (string)
# 20 "mgoparser.ml"
  )
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
    | INT of (
# 10 "mgoparser.mly"
       (int64)
# 43 "mgoparser.ml"
  )
    | INCR
    | IMPORT
    | IF
    | IDENT of (
# 11 "mgoparser.mly"
       (string)
# 51 "mgoparser.ml"
  )
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
  
end

include MenhirBasics

# 1 "mgoparser.mly"
  

  open Lexing
  open Mgoast

  exception Error


# 85 "mgoparser.ml"

type ('s, 'r) _menhir_state = 
  | MenhirState03 : ('s _menhir_cell0_IDENT, _menhir_box_prog) _menhir_state
    (** State 03.
        Stack shape : IDENT.
        Start symbol: prog. *)

  | MenhirState04 : (('s, _menhir_box_prog) _menhir_cell1_TYPE, _menhir_box_prog) _menhir_state
    (** State 04.
        Stack shape : TYPE.
        Start symbol: prog. *)

  | MenhirState08 : ((('s, _menhir_box_prog) _menhir_cell1_TYPE, _menhir_box_prog) _menhir_cell1_ident, _menhir_box_prog) _menhir_state
    (** State 08.
        Stack shape : TYPE ident.
        Start symbol: prog. *)

  | MenhirState10 : (('s, _menhir_box_prog) _menhir_cell1_varstyp, _menhir_box_prog) _menhir_state
    (** State 10.
        Stack shape : varstyp.
        Start symbol: prog. *)

  | MenhirState11 : (('s, _menhir_box_prog) _menhir_cell1_idents1, _menhir_box_prog) _menhir_state
    (** State 11.
        Stack shape : idents1.
        Start symbol: prog. *)

  | MenhirState19 : (('s, _menhir_box_prog) _menhir_cell1_ident, _menhir_box_prog) _menhir_state
    (** State 19.
        Stack shape : ident.
        Start symbol: prog. *)

  | MenhirState29 : (('s _menhir_cell0_IDENT, _menhir_box_prog) _menhir_cell1_IMPORT _menhir_cell0_STRING, _menhir_box_prog) _menhir_state
    (** State 29.
        Stack shape : IDENT IMPORT STRING.
        Start symbol: prog. *)

  | MenhirState30 : (('s, _menhir_box_prog) _menhir_cell1_FUNC, _menhir_box_prog) _menhir_state
    (** State 30.
        Stack shape : FUNC.
        Start symbol: prog. *)

  | MenhirState32 : ((('s, _menhir_box_prog) _menhir_cell1_FUNC, _menhir_box_prog) _menhir_cell1_ident, _menhir_box_prog) _menhir_state
    (** State 32.
        Stack shape : FUNC ident.
        Start symbol: prog. *)

  | MenhirState34 : (('s, _menhir_box_prog) _menhir_cell1_varstyp, _menhir_box_prog) _menhir_state
    (** State 34.
        Stack shape : varstyp.
        Start symbol: prog. *)

  | MenhirState36 : (((('s, _menhir_box_prog) _menhir_cell1_FUNC, _menhir_box_prog) _menhir_cell1_ident, _menhir_box_prog) _menhir_cell1_separated_nonempty_list_COMMA_varstyp_, _menhir_box_prog) _menhir_state
    (** State 36.
        Stack shape : FUNC ident separated_nonempty_list(COMMA,varstyp).
        Start symbol: prog. *)

  | MenhirState40 : (((('s, _menhir_box_prog) _menhir_cell1_FUNC, _menhir_box_prog) _menhir_cell1_ident, _menhir_box_prog) _menhir_cell1_params_opt, _menhir_box_prog) _menhir_state
    (** State 40.
        Stack shape : FUNC ident params_opt.
        Start symbol: prog. *)

  | MenhirState41 : ((((('s, _menhir_box_prog) _menhir_cell1_FUNC, _menhir_box_prog) _menhir_cell1_ident, _menhir_box_prog) _menhir_cell1_params_opt, _menhir_box_prog) _menhir_cell1_LPAR, _menhir_box_prog) _menhir_state
    (** State 41.
        Stack shape : FUNC ident params_opt LPAR.
        Start symbol: prog. *)

  | MenhirState42 : (((((('s, _menhir_box_prog) _menhir_cell1_FUNC, _menhir_box_prog) _menhir_cell1_ident, _menhir_box_prog) _menhir_cell1_params_opt, _menhir_box_prog) _menhir_cell1_LPAR, _menhir_box_prog) _menhir_cell1_separated_nonempty_list_COMMA_mgotype_, _menhir_box_prog) _menhir_state
    (** State 42.
        Stack shape : FUNC ident params_opt LPAR separated_nonempty_list(COMMA,mgotype).
        Start symbol: prog. *)

  | MenhirState46 : (('s, _menhir_box_prog) _menhir_cell1_mgotype, _menhir_box_prog) _menhir_state
    (** State 46.
        Stack shape : mgotype.
        Start symbol: prog. *)

  | MenhirState56 : (('s, _menhir_box_prog) _menhir_cell1_decl, _menhir_box_prog) _menhir_state
    (** State 56.
        Stack shape : decl.
        Start symbol: prog. *)


and ('s, 'r) _menhir_cell1_decl = 
  | MenhirCell1_decl of 's * ('s, 'r) _menhir_state * (Mgoast.decl)

and ('s, 'r) _menhir_cell1_ident = 
  | MenhirCell1_ident of 's * ('s, 'r) _menhir_state * (Mgoast.ident)

and ('s, 'r) _menhir_cell1_idents1 = 
  | MenhirCell1_idents1 of 's * ('s, 'r) _menhir_state * (Mgoast.ident list)

and ('s, 'r) _menhir_cell1_mgotype = 
  | MenhirCell1_mgotype of 's * ('s, 'r) _menhir_state * (Mgoast.typ)

and ('s, 'r) _menhir_cell1_params_opt = 
  | MenhirCell1_params_opt of 's * ('s, 'r) _menhir_state * ((Mgoast.ident * Mgoast.typ) list)

and ('s, 'r) _menhir_cell1_return_opt = 
  | MenhirCell1_return_opt of 's * ('s, 'r) _menhir_state * (Mgoast.typ list)

and ('s, 'r) _menhir_cell1_separated_nonempty_list_COMMA_mgotype_ = 
  | MenhirCell1_separated_nonempty_list_COMMA_mgotype_ of 's * ('s, 'r) _menhir_state * (Mgoast.typ list)

and ('s, 'r) _menhir_cell1_separated_nonempty_list_COMMA_varstyp_ = 
  | MenhirCell1_separated_nonempty_list_COMMA_varstyp_ of 's * ('s, 'r) _menhir_state * ((Mgoast.ident * Mgoast.typ) list list)

and ('s, 'r) _menhir_cell1_varstyp = 
  | MenhirCell1_varstyp of 's * ('s, 'r) _menhir_state * ((Mgoast.ident * Mgoast.typ) list)

and ('s, 'r) _menhir_cell1_FUNC = 
  | MenhirCell1_FUNC of 's * ('s, 'r) _menhir_state

and 's _menhir_cell0_IDENT = 
  | MenhirCell0_IDENT of 's * (
# 11 "mgoparser.mly"
       (string)
# 203 "mgoparser.ml"
) * Lexing.position * Lexing.position

and ('s, 'r) _menhir_cell1_IMPORT = 
  | MenhirCell1_IMPORT of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_LPAR = 
  | MenhirCell1_LPAR of 's * ('s, 'r) _menhir_state

and 's _menhir_cell0_STRING = 
  | MenhirCell0_STRING of 's * (
# 12 "mgoparser.mly"
       (string)
# 216 "mgoparser.ml"
)

and ('s, 'r) _menhir_cell1_TYPE = 
  | MenhirCell1_TYPE of 's * ('s, 'r) _menhir_state

and _menhir_box_prog = 
  | MenhirBox_prog of (Mgoast.program) [@@unboxed]

let _menhir_action_01 =
  fun () ->
    (
# 95 "mgoparser.mly"
            ( [] )
# 230 "mgoparser.ml"
     : (Mgoast.seq))

let _menhir_action_02 =
  fun fl id ->
    (
# 53 "mgoparser.mly"
  ( Struct { sname = id; fields = List.flatten fl } )
# 238 "mgoparser.ml"
     : (Mgoast.decl))

let _menhir_action_03 =
  fun b fname pl ret ->
    (
# 56 "mgoparser.mly"
  ( Fun { fname = fname; params = pl; return = ret; body = b } )
# 246 "mgoparser.ml"
     : (Mgoast.decl))

let _menhir_action_04 =
  fun opt xt ->
    (
# 67 "mgoparser.mly"
                                           ( let _ = opt in [xt] )
# 254 "mgoparser.ml"
     : ((Mgoast.ident * Mgoast.typ) list list))

let _menhir_action_05 =
  fun xt xtl ->
    (
# 68 "mgoparser.mly"
                                           ( xt :: xtl )
# 262 "mgoparser.ml"
     : ((Mgoast.ident * Mgoast.typ) list list))

let _menhir_action_06 =
  fun _endpos_id_ _startpos_id_ id ->
    let _endpos = _endpos_id_ in
    let _startpos = _startpos_id_ in
    (
# 47 "mgoparser.mly"
             ( { loc = _startpos, _endpos; id = id } )
# 272 "mgoparser.ml"
     : (Mgoast.ident))

let _menhir_action_07 =
  fun x ->
    (
# 76 "mgoparser.mly"
                              ( [x] )
# 280 "mgoparser.ml"
     : (Mgoast.ident list))

let _menhir_action_08 =
  fun x xs ->
    (
# 77 "mgoparser.mly"
                              ( x :: xs )
# 288 "mgoparser.ml"
     : (Mgoast.ident list))

let _menhir_action_09 =
  fun () ->
    (
# 216 "<standard.mly>"
    ( [] )
# 296 "mgoparser.ml"
     : (Mgoast.decl list))

let _menhir_action_10 =
  fun x xs ->
    (
# 219 "<standard.mly>"
    ( x :: xs )
# 304 "mgoparser.ml"
     : (Mgoast.decl list))

let _menhir_action_11 =
  fun () ->
    (
# 145 "<standard.mly>"
    ( [] )
# 312 "mgoparser.ml"
     : ((Mgoast.ident * Mgoast.typ) list list))

let _menhir_action_12 =
  fun x ->
    (
# 148 "<standard.mly>"
    ( x )
# 320 "mgoparser.ml"
     : ((Mgoast.ident * Mgoast.typ) list list))

let _menhir_action_13 =
  fun () ->
    (
# 60 "mgoparser.mly"
            ( TInt )
# 328 "mgoparser.ml"
     : (Mgoast.typ))

let _menhir_action_14 =
  fun () ->
    (
# 61 "mgoparser.mly"
               ( TBool )
# 336 "mgoparser.ml"
     : (Mgoast.typ))

let _menhir_action_15 =
  fun () ->
    (
# 62 "mgoparser.mly"
               ( TString )
# 344 "mgoparser.ml"
     : (Mgoast.typ))

let _menhir_action_16 =
  fun s ->
    (
# 63 "mgoparser.mly"
                 ( TStruct(s) )
# 352 "mgoparser.ml"
     : (Mgoast.typ))

let _menhir_action_17 =
  fun () ->
    (
# 111 "<standard.mly>"
    ( None )
# 360 "mgoparser.ml"
     : (unit option))

let _menhir_action_18 =
  fun x ->
    (
# 114 "<standard.mly>"
    ( Some x )
# 368 "mgoparser.ml"
     : (unit option))

let _menhir_action_19 =
  fun () ->
    (
# 111 "<standard.mly>"
    ( None )
# 376 "mgoparser.ml"
     : (unit option))

let _menhir_action_20 =
  fun x ->
    (
# 114 "<standard.mly>"
    ( Some x )
# 384 "mgoparser.ml"
     : (unit option))

let _menhir_action_21 =
  fun () ->
    (
# 81 "mgoparser.mly"
                                            ( [] )
# 392 "mgoparser.ml"
     : ((Mgoast.ident * Mgoast.typ) list))

let _menhir_action_22 =
  fun ps trail ->
    (
# 83 "mgoparser.mly"
    ( let _ = trail in List.flatten ps )
# 400 "mgoparser.ml"
     : ((Mgoast.ident * Mgoast.typ) list))

let _menhir_action_23 =
  fun decls main ->
    (
# 40 "mgoparser.mly"
    ( if main="main" then (false, decls) else raise Error)
# 408 "mgoparser.ml"
     : (Mgoast.program))

let _menhir_action_24 =
  fun decls fmt main ->
    (
# 42 "mgoparser.mly"
    ( if main="main" && fmt = "fmt" then (true, decls) else raise Error)
# 416 "mgoparser.ml"
     : (Mgoast.program))

let _menhir_action_25 =
  fun () ->
    (
# 88 "mgoparser.mly"
                                            ( [] )
# 424 "mgoparser.ml"
     : (Mgoast.typ list))

let _menhir_action_26 =
  fun t ->
    (
# 89 "mgoparser.mly"
                                            ( [t] )
# 432 "mgoparser.ml"
     : (Mgoast.typ list))

let _menhir_action_27 =
  fun trail ts ->
    (
# 91 "mgoparser.mly"
    ( let _ = trail in ts )
# 440 "mgoparser.ml"
     : (Mgoast.typ list))

let _menhir_action_28 =
  fun x ->
    (
# 250 "<standard.mly>"
    ( [ x ] )
# 448 "mgoparser.ml"
     : (Mgoast.typ list))

let _menhir_action_29 =
  fun x xs ->
    (
# 253 "<standard.mly>"
    ( x :: xs )
# 456 "mgoparser.ml"
     : (Mgoast.typ list))

let _menhir_action_30 =
  fun x ->
    (
# 250 "<standard.mly>"
    ( [ x ] )
# 464 "mgoparser.ml"
     : ((Mgoast.ident * Mgoast.typ) list list))

let _menhir_action_31 =
  fun x xs ->
    (
# 253 "<standard.mly>"
    ( x :: xs )
# 472 "mgoparser.ml"
     : ((Mgoast.ident * Mgoast.typ) list list))

let _menhir_action_32 =
  fun ids t ->
    (
# 72 "mgoparser.mly"
                                         ( List.map (fun x -> (x, t)) ids )
# 480 "mgoparser.ml"
     : ((Mgoast.ident * Mgoast.typ) list))

let _menhir_print_token : token -> string =
  fun _tok ->
    match _tok with
    | AND ->
        "AND"
    | ASSIGN ->
        "ASSIGN"
    | BEGIN ->
        "BEGIN"
    | BOOL ->
        "BOOL"
    | COMMA ->
        "COMMA"
    | DECR ->
        "DECR"
    | DEFINE ->
        "DEFINE"
    | DIV ->
        "DIV"
    | DOT ->
        "DOT"
    | ELSE ->
        "ELSE"
    | END ->
        "END"
    | EOF ->
        "EOF"
    | EQ ->
        "EQ"
    | FALSE ->
        "FALSE"
    | FOR ->
        "FOR"
    | FUNC ->
        "FUNC"
    | GE ->
        "GE"
    | GT ->
        "GT"
    | IDENT _ ->
        "IDENT"
    | IF ->
        "IF"
    | IMPORT ->
        "IMPORT"
    | INCR ->
        "INCR"
    | INT _ ->
        "INT"
    | INT1 ->
        "INT1"
    | LE ->
        "LE"
    | LPAR ->
        "LPAR"
    | LT ->
        "LT"
    | MAIN ->
        "MAIN"
    | MINUS ->
        "MINUS"
    | MOD ->
        "MOD"
    | NEQ ->
        "NEQ"
    | NEW ->
        "NEW"
    | NIL ->
        "NIL"
    | NOT ->
        "NOT"
    | OR ->
        "OR"
    | PACKAGE ->
        "PACKAGE"
    | PLUS ->
        "PLUS"
    | RETURN ->
        "RETURN"
    | RPAR ->
        "RPAR"
    | SEMI ->
        "SEMI"
    | STAR ->
        "STAR"
    | STRING _ ->
        "STRING"
    | STRING1 ->
        "STRING1"
    | STRUCT ->
        "STRUCT"
    | TRUE ->
        "TRUE"
    | TYPE ->
        "TYPE"
    | VAR ->
        "VAR"

let _menhir_fail : unit -> 'a =
  fun () ->
    Printf.eprintf "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

include struct
  
  [@@@ocaml.warning "-4-37"]
  
  let _menhir_goto_prog : type  ttv_stack. ttv_stack -> _ -> _menhir_box_prog =
    fun _menhir_stack _v ->
      MenhirBox_prog _v
  
  let _menhir_run_58 : type  ttv_stack. ttv_stack _menhir_cell0_IDENT -> _ -> _menhir_box_prog =
    fun _menhir_stack _v ->
      let MenhirCell0_IDENT (_menhir_stack, main, _, _) = _menhir_stack in
      let decls = _v in
      let _v = _menhir_action_23 decls main in
      _menhir_goto_prog _menhir_stack _v
  
  let _menhir_run_54 : type  ttv_stack. (ttv_stack _menhir_cell0_IDENT, _menhir_box_prog) _menhir_cell1_IMPORT _menhir_cell0_STRING -> _ -> _menhir_box_prog =
    fun _menhir_stack _v ->
      let MenhirCell0_STRING (_menhir_stack, fmt) = _menhir_stack in
      let MenhirCell1_IMPORT (_menhir_stack, _) = _menhir_stack in
      let MenhirCell0_IDENT (_menhir_stack, main, _, _) = _menhir_stack in
      let decls = _v in
      let _v = _menhir_action_24 decls fmt main in
      _menhir_goto_prog _menhir_stack _v
  
  let rec _menhir_run_57 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_decl -> _ -> _menhir_box_prog =
    fun _menhir_stack _v ->
      let MenhirCell1_decl (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_10 x xs in
      _menhir_goto_list_decl_ _menhir_stack _v _menhir_s
  
  and _menhir_goto_list_decl_ : type  ttv_stack. ttv_stack -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _v _menhir_s ->
      match _menhir_s with
      | MenhirState03 ->
          _menhir_run_58 _menhir_stack _v
      | MenhirState56 ->
          _menhir_run_57 _menhir_stack _v
      | MenhirState29 ->
          _menhir_run_54 _menhir_stack _v
      | _ ->
          _menhir_fail ()
  
  let rec _menhir_run_04 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_TYPE (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState04 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IDENT _v ->
          _menhir_run_05 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_05 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let (_endpos_id_, _startpos_id_, id) = (_endpos, _startpos, _v) in
      let _v = _menhir_action_06 _endpos_id_ _startpos_id_ id in
      _menhir_goto_ident _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_ident : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState30 ->
          _menhir_run_31 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState32 ->
          _menhir_run_18 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState34 ->
          _menhir_run_18 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState08 ->
          _menhir_run_18 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState19 ->
          _menhir_run_18 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState10 ->
          _menhir_run_18 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState04 ->
          _menhir_run_06 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_31 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_FUNC as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_ident (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | LPAR ->
          let _menhir_s = MenhirState32 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | IDENT _v ->
              _menhir_run_05 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | RPAR ->
              let _v = _menhir_action_21 () in
              _menhir_goto_params_opt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_goto_params_opt : type  ttv_stack. (((ttv_stack, _menhir_box_prog) _menhir_cell1_FUNC, _menhir_box_prog) _menhir_cell1_ident as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_params_opt (_menhir_stack, _menhir_s, _v) in
      let _menhir_s = MenhirState40 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | STRING1 ->
          _menhir_run_12 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | STAR ->
          _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAR ->
          let _menhir_stack = MenhirCell1_LPAR (_menhir_stack, _menhir_s) in
          let _menhir_s = MenhirState41 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | STRING1 ->
              _menhir_run_12 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | STAR ->
              _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | INT1 ->
              _menhir_run_15 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | BOOL ->
              _menhir_run_16 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | INT1 ->
          _menhir_run_15 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | BOOL ->
          _menhir_run_16 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | BEGIN ->
          let _v = _menhir_action_25 () in
          _menhir_goto_return_opt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_12 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_15 () in
      _menhir_goto_mgotype _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_mgotype : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState40 ->
          _menhir_run_53 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState46 ->
          _menhir_run_45 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState41 ->
          _menhir_run_45 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState11 ->
          _menhir_run_17 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_53 : type  ttv_stack. ((((ttv_stack, _menhir_box_prog) _menhir_cell1_FUNC, _menhir_box_prog) _menhir_cell1_ident, _menhir_box_prog) _menhir_cell1_params_opt as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let t = _v in
      let _v = _menhir_action_26 t in
      _menhir_goto_return_opt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_return_opt : type  ttv_stack. ((((ttv_stack, _menhir_box_prog) _menhir_cell1_FUNC, _menhir_box_prog) _menhir_cell1_ident, _menhir_box_prog) _menhir_cell1_params_opt as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_return_opt (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | BEGIN ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | END ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let _v = _menhir_action_01 () in
              (match (_tok : MenhirBasics.token) with
              | SEMI ->
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  let MenhirCell1_return_opt (_menhir_stack, _, ret) = _menhir_stack in
                  let MenhirCell1_params_opt (_menhir_stack, _, pl) = _menhir_stack in
                  let MenhirCell1_ident (_menhir_stack, _, fname) = _menhir_stack in
                  let MenhirCell1_FUNC (_menhir_stack, _menhir_s) = _menhir_stack in
                  let b = _v in
                  let _v = _menhir_action_03 b fname pl ret in
                  _menhir_goto_decl _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_goto_decl : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_decl (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | TYPE ->
          _menhir_run_04 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState56
      | FUNC ->
          _menhir_run_30 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState56
      | EOF ->
          let _v_0 = _menhir_action_09 () in
          _menhir_run_57 _menhir_stack _v_0
      | _ ->
          _eRR ()
  
  and _menhir_run_30 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_FUNC (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState30 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IDENT _v ->
          _menhir_run_05 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_45 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | COMMA ->
          let _menhir_stack = MenhirCell1_mgotype (_menhir_stack, _menhir_s, _v) in
          let _menhir_s = MenhirState46 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | STRING1 ->
              _menhir_run_12 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | STAR ->
              _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | INT1 ->
              _menhir_run_15 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | BOOL ->
              _menhir_run_16 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | RPAR ->
          let x = _v in
          let _v = _menhir_action_28 x in
          _menhir_goto_separated_nonempty_list_COMMA_mgotype_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_13 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IDENT _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let s = _v in
          let _v = _menhir_action_16 s in
          _menhir_goto_mgotype _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_15 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_13 () in
      _menhir_goto_mgotype _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_16 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_14 () in
      _menhir_goto_mgotype _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_separated_nonempty_list_COMMA_mgotype_ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState46 ->
          _menhir_run_47 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState41 ->
          _menhir_run_42 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_47 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_mgotype -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_mgotype (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_29 x xs in
      _menhir_goto_separated_nonempty_list_COMMA_mgotype_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_run_42 : type  ttv_stack. (((((ttv_stack, _menhir_box_prog) _menhir_cell1_FUNC, _menhir_box_prog) _menhir_cell1_ident, _menhir_box_prog) _menhir_cell1_params_opt, _menhir_box_prog) _menhir_cell1_LPAR as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_separated_nonempty_list_COMMA_mgotype_ (_menhir_stack, _menhir_s, _v) in
      let _v_0 = _menhir_action_17 () in
      let _v = _v_0 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell1_separated_nonempty_list_COMMA_mgotype_ (_menhir_stack, _, ts) = _menhir_stack in
      let MenhirCell1_LPAR (_menhir_stack, _menhir_s) = _menhir_stack in
      let trail = _v in
      let _v = _menhir_action_27 trail ts in
      _menhir_goto_return_opt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_17 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_idents1 -> _ -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_idents1 (_menhir_stack, _menhir_s, ids) = _menhir_stack in
      let t = _v in
      let _v = _menhir_action_32 ids t in
      _menhir_goto_varstyp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_varstyp : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState34 ->
          _menhir_run_33 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState32 ->
          _menhir_run_33 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState10 ->
          _menhir_run_09 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState08 ->
          _menhir_run_09 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_33 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | COMMA ->
          let _menhir_stack = MenhirCell1_varstyp (_menhir_stack, _menhir_s, _v) in
          let _menhir_s = MenhirState34 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | IDENT _v ->
              _menhir_run_05 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | RPAR ->
          let x = _v in
          let _v = _menhir_action_30 x in
          _menhir_goto_separated_nonempty_list_COMMA_varstyp_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_goto_separated_nonempty_list_COMMA_varstyp_ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState32 ->
          _menhir_run_36 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MenhirState34 ->
          _menhir_run_35 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_36 : type  ttv_stack. (((ttv_stack, _menhir_box_prog) _menhir_cell1_FUNC, _menhir_box_prog) _menhir_cell1_ident as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_separated_nonempty_list_COMMA_varstyp_ (_menhir_stack, _menhir_s, _v) in
      let _v_0 = _menhir_action_17 () in
      let _v = _v_0 in
      let MenhirCell1_separated_nonempty_list_COMMA_varstyp_ (_menhir_stack, _menhir_s, ps) = _menhir_stack in
      let trail = _v in
      let _v = _menhir_action_22 ps trail in
      _menhir_goto_params_opt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_run_35 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_varstyp -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_varstyp (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_31 x xs in
      _menhir_goto_separated_nonempty_list_COMMA_varstyp_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_run_09 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_varstyp (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | SEMI ->
          let _menhir_s = MenhirState10 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | IDENT _v ->
              _menhir_run_05 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | END ->
              let x = () in
              let _v = _menhir_action_20 x in
              _menhir_goto_option_SEMI_ _menhir_stack _menhir_lexbuf _menhir_lexer _v
          | _ ->
              _eRR ())
      | END ->
          let _v = _menhir_action_19 () in
          _menhir_goto_option_SEMI_ _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _eRR ()
  
  and _menhir_goto_option_SEMI_ : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_varstyp -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_varstyp (_menhir_stack, _menhir_s, xt) = _menhir_stack in
      let opt = _v in
      let _v = _menhir_action_04 opt xt in
      _menhir_goto_fields _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_goto_fields : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState08 ->
          _menhir_run_26 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState10 ->
          _menhir_run_21 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_26 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_TYPE, _menhir_box_prog) _menhir_cell1_ident -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let x = _v in
      let _v = _menhir_action_12 x in
      _menhir_goto_loption_fields_ _menhir_stack _menhir_lexbuf _menhir_lexer _v
  
  and _menhir_goto_loption_fields_ : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_TYPE, _menhir_box_prog) _menhir_cell1_ident -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | SEMI ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_ident (_menhir_stack, _, id) = _menhir_stack in
          let MenhirCell1_TYPE (_menhir_stack, _menhir_s) = _menhir_stack in
          let fl = _v in
          let _v = _menhir_action_02 fl id in
          _menhir_goto_decl _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_21 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_varstyp -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_varstyp (_menhir_stack, _menhir_s, xt) = _menhir_stack in
      let xtl = _v in
      let _v = _menhir_action_05 xt xtl in
      _menhir_goto_fields _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_run_18 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | COMMA ->
          let _menhir_stack = MenhirCell1_ident (_menhir_stack, _menhir_s, _v) in
          let _menhir_s = MenhirState19 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | IDENT _v ->
              _menhir_run_05 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | BOOL | INT1 | STAR | STRING1 ->
          let x = _v in
          let _v = _menhir_action_07 x in
          _menhir_goto_idents1 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_goto_idents1 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState19 ->
          _menhir_run_20 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState32 ->
          _menhir_run_11 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState34 ->
          _menhir_run_11 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState08 ->
          _menhir_run_11 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState10 ->
          _menhir_run_11 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_20 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_ident -> _ -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_ident (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_08 x xs in
      _menhir_goto_idents1 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_11 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_idents1 (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | STRING1 ->
          _menhir_run_12 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState11
      | STAR ->
          _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState11
      | INT1 ->
          _menhir_run_15 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState11
      | BOOL ->
          _menhir_run_16 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState11
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_06 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_TYPE as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_ident (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | STRUCT ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | BEGIN ->
              let _menhir_s = MenhirState08 in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | IDENT _v ->
                  _menhir_run_05 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | END ->
                  let _v = _menhir_action_11 () in
                  _menhir_goto_loption_fields_ _menhir_stack _menhir_lexbuf _menhir_lexer _v
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  let _menhir_run_00 : type  ttv_stack. ttv_stack -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | PACKAGE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | IDENT _v ->
              let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
              let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
              let _menhir_stack = MenhirCell0_IDENT (_menhir_stack, _v, _startpos, _endpos) in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | SEMI ->
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  (match (_tok : MenhirBasics.token) with
                  | TYPE ->
                      _menhir_run_04 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState03
                  | IMPORT ->
                      let _menhir_stack = MenhirCell1_IMPORT (_menhir_stack, MenhirState03) in
                      let _tok = _menhir_lexer _menhir_lexbuf in
                      (match (_tok : MenhirBasics.token) with
                      | STRING _v_0 ->
                          let _menhir_stack = MenhirCell0_STRING (_menhir_stack, _v_0) in
                          let _tok = _menhir_lexer _menhir_lexbuf in
                          (match (_tok : MenhirBasics.token) with
                          | SEMI ->
                              let _tok = _menhir_lexer _menhir_lexbuf in
                              (match (_tok : MenhirBasics.token) with
                              | TYPE ->
                                  _menhir_run_04 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState29
                              | FUNC ->
                                  _menhir_run_30 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState29
                              | EOF ->
                                  let _v_1 = _menhir_action_09 () in
                                  _menhir_run_54 _menhir_stack _v_1
                              | _ ->
                                  _eRR ())
                          | _ ->
                              _eRR ())
                      | _ ->
                          _eRR ())
                  | FUNC ->
                      _menhir_run_30 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState03
                  | EOF ->
                      let _v_2 = _menhir_action_09 () in
                      _menhir_run_58 _menhir_stack _v_2
                  | _ ->
                      _eRR ())
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
end

let prog =
  fun _menhir_lexer _menhir_lexbuf ->
    let _menhir_stack = () in
    let MenhirBox_prog v = _menhir_run_00 _menhir_stack _menhir_lexbuf _menhir_lexer in
    v
