
module MenhirBasics = struct
  
  exception Error
  
  let _eRR =
    fun _s ->
      raise Error
  
  type token = 
    | STAR
    | SEMI
    | RPAR
    | PRINT
    | PLUS
    | LPAR
    | INT of (
# 9 "impparser.mly"
       (int)
# 21 "impparser.ml"
  )
    | IDENT of (
# 10 "impparser.mly"
       (string)
# 26 "impparser.ml"
  )
    | FUNCTION
    | EOF
    | END
    | BEGIN
  
end

include MenhirBasics

# 1 "impparser.mly"
  

  open Imp


# 43 "impparser.ml"

type ('s, 'r) _menhir_state = 
  | MenhirState00 : ('s, _menhir_box_program) _menhir_state
    (** State 00.
        Stack shape : .
        Start symbol: program. *)

  | MenhirState05 : (('s, _menhir_box_program) _menhir_cell1_FUNCTION _menhir_cell0_IDENT, _menhir_box_program) _menhir_state
    (** State 05.
        Stack shape : FUNCTION IDENT.
        Start symbol: program. *)

  | MenhirState07 : (('s, _menhir_box_program) _menhir_cell1_PRINT, _menhir_box_program) _menhir_state
    (** State 07.
        Stack shape : PRINT.
        Start symbol: program. *)

  | MenhirState10 : (('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 10.
        Stack shape : expr.
        Start symbol: program. *)

  | MenhirState14 : (('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 14.
        Stack shape : expr.
        Start symbol: program. *)

  | MenhirState18 : (('s, _menhir_box_program) _menhir_cell1_instr, _menhir_box_program) _menhir_state
    (** State 18.
        Stack shape : instr.
        Start symbol: program. *)

  | MenhirState23 : (('s, _menhir_box_program) _menhir_cell1_fun_def, _menhir_box_program) _menhir_state
    (** State 23.
        Stack shape : fun_def.
        Start symbol: program. *)


and ('s, 'r) _menhir_cell1_expr = 
  | MenhirCell1_expr of 's * ('s, 'r) _menhir_state * (Imp.expr)

and ('s, 'r) _menhir_cell1_fun_def = 
  | MenhirCell1_fun_def of 's * ('s, 'r) _menhir_state * (Imp.function_def)

and ('s, 'r) _menhir_cell1_instr = 
  | MenhirCell1_instr of 's * ('s, 'r) _menhir_state * (Imp.instr)

and ('s, 'r) _menhir_cell1_FUNCTION = 
  | MenhirCell1_FUNCTION of 's * ('s, 'r) _menhir_state

and 's _menhir_cell0_IDENT = 
  | MenhirCell0_IDENT of 's * (
# 10 "impparser.mly"
       (string)
# 98 "impparser.ml"
)

and ('s, 'r) _menhir_cell1_PRINT = 
  | MenhirCell1_PRINT of 's * ('s, 'r) _menhir_state

and _menhir_box_program = 
  | MenhirBox_program of (Imp.program) [@@unboxed]

let _menhir_action_01 =
  fun n ->
    (
# 48 "impparser.mly"
        ( Int n )
# 112 "impparser.ml"
     : (Imp.expr))

let _menhir_action_02 =
  fun e1 e2 ->
    let op = 
# 54 "impparser.mly"
       ( Add )
# 120 "impparser.ml"
     in
    (
# 49 "impparser.mly"
                           ( Binop(op, e1, e2) )
# 125 "impparser.ml"
     : (Imp.expr))

let _menhir_action_03 =
  fun e1 e2 ->
    let op = 
# 55 "impparser.mly"
       ( Mul )
# 133 "impparser.ml"
     in
    (
# 49 "impparser.mly"
                           ( Binop(op, e1, e2) )
# 138 "impparser.ml"
     : (Imp.expr))

let _menhir_action_04 =
  fun code name ->
    (
# 39 "impparser.mly"
    ( {name; code; params=[] (* À MODIFIER *) ; locals=[] (* À MODIFIER *)} )
# 146 "impparser.ml"
     : (Imp.function_def))

let _menhir_action_05 =
  fun e ->
    (
# 43 "impparser.mly"
                              ( Print(e) )
# 154 "impparser.ml"
     : (Imp.instr))

let _menhir_action_06 =
  fun () ->
    (
# 216 "<standard.mly>"
    ( [] )
# 162 "impparser.ml"
     : (Imp.function_def list))

let _menhir_action_07 =
  fun x xs ->
    (
# 219 "<standard.mly>"
    ( x :: xs )
# 170 "impparser.ml"
     : (Imp.function_def list))

let _menhir_action_08 =
  fun () ->
    (
# 216 "<standard.mly>"
    ( [] )
# 178 "impparser.ml"
     : (Imp.seq))

let _menhir_action_09 =
  fun x xs ->
    (
# 219 "<standard.mly>"
    ( x :: xs )
# 186 "impparser.ml"
     : (Imp.seq))

let _menhir_action_10 =
  fun functions ->
    (
# 33 "impparser.mly"
    ( {globals=[] (* À MODIFIER *) ; functions} )
# 194 "impparser.ml"
     : (Imp.program))

let _menhir_print_token : token -> string =
  fun _tok ->
    match _tok with
    | BEGIN ->
        "BEGIN"
    | END ->
        "END"
    | EOF ->
        "EOF"
    | FUNCTION ->
        "FUNCTION"
    | IDENT _ ->
        "IDENT"
    | INT _ ->
        "INT"
    | LPAR ->
        "LPAR"
    | PLUS ->
        "PLUS"
    | PRINT ->
        "PRINT"
    | RPAR ->
        "RPAR"
    | SEMI ->
        "SEMI"
    | STAR ->
        "STAR"

let _menhir_fail : unit -> 'a =
  fun () ->
    Printf.eprintf "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

include struct
  
  [@@@ocaml.warning "-4-37"]
  
  let _menhir_run_21 : type  ttv_stack. ttv_stack -> _ -> _menhir_box_program =
    fun _menhir_stack _v ->
      let functions = _v in
      let _v = _menhir_action_10 functions in
      MenhirBox_program _v
  
  let rec _menhir_run_24 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_fun_def -> _ -> _menhir_box_program =
    fun _menhir_stack _v ->
      let MenhirCell1_fun_def (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_07 x xs in
      _menhir_goto_list_fun_def_ _menhir_stack _v _menhir_s
  
  and _menhir_goto_list_fun_def_ : type  ttv_stack. ttv_stack -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _v _menhir_s ->
      match _menhir_s with
      | MenhirState23 ->
          _menhir_run_24 _menhir_stack _v
      | MenhirState00 ->
          _menhir_run_21 _menhir_stack _v
      | _ ->
          _menhir_fail ()
  
  let rec _menhir_run_01 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_FUNCTION (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IDENT _v ->
          let _menhir_stack = MenhirCell0_IDENT (_menhir_stack, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | LPAR ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | RPAR ->
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  (match (_tok : MenhirBasics.token) with
                  | BEGIN ->
                      let _tok = _menhir_lexer _menhir_lexbuf in
                      (match (_tok : MenhirBasics.token) with
                      | PRINT ->
                          _menhir_run_06 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState05
                      | END ->
                          let _v_0 = _menhir_action_08 () in
                          _menhir_run_16 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0
                      | _ ->
                          _eRR ())
                  | _ ->
                      _eRR ())
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_06 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_PRINT (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | LPAR ->
          let _menhir_s = MenhirState07 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | INT _v ->
              _menhir_run_08 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_08 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let n = _v in
      let _v = _menhir_action_01 n in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_expr : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState14 ->
          _menhir_run_15 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState10 ->
          _menhir_run_11 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState07 ->
          _menhir_run_09 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_15 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_expr as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | STAR ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_10 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUS | RPAR ->
          let MenhirCell1_expr (_menhir_stack, _menhir_s, e1) = _menhir_stack in
          let e2 = _v in
          let _v = _menhir_action_02 e1 e2 in
          _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_10 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_expr -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState10 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | INT _v ->
          _menhir_run_08 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_11 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_expr -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_expr (_menhir_stack, _menhir_s, e1) = _menhir_stack in
      let e2 = _v in
      let _v = _menhir_action_03 e1 e2 in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_09 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_PRINT as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | STAR ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_10 _menhir_stack _menhir_lexbuf _menhir_lexer
      | RPAR ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | SEMI ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let MenhirCell1_PRINT (_menhir_stack, _menhir_s) = _menhir_stack in
              let e = _v in
              let _v = _menhir_action_05 e in
              let _menhir_stack = MenhirCell1_instr (_menhir_stack, _menhir_s, _v) in
              (match (_tok : MenhirBasics.token) with
              | PRINT ->
                  _menhir_run_06 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState18
              | END ->
                  let _v_0 = _menhir_action_08 () in
                  _menhir_run_19 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | PLUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          let _menhir_s = MenhirState14 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | INT _v ->
              _menhir_run_08 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_19 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_instr -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_instr (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_09 x xs in
      _menhir_goto_list_instr_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_goto_list_instr_ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState18 ->
          _menhir_run_19 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState05 ->
          _menhir_run_16 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_16 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_FUNCTION _menhir_cell0_IDENT -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell0_IDENT (_menhir_stack, name) = _menhir_stack in
      let MenhirCell1_FUNCTION (_menhir_stack, _menhir_s) = _menhir_stack in
      let code = _v in
      let _v = _menhir_action_04 code name in
      let _menhir_stack = MenhirCell1_fun_def (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | FUNCTION ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState23
      | EOF ->
          let _v_0 = _menhir_action_06 () in
          _menhir_run_24 _menhir_stack _v_0
      | _ ->
          _eRR ()
  
  let _menhir_run_00 : type  ttv_stack. ttv_stack -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | FUNCTION ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState00
      | EOF ->
          let _v = _menhir_action_06 () in
          _menhir_run_21 _menhir_stack _v
      | _ ->
          _eRR ()
  
end

let program =
  fun _menhir_lexer _menhir_lexbuf ->
    let _menhir_stack = () in
    let MenhirBox_program v = _menhir_run_00 _menhir_stack _menhir_lexbuf _menhir_lexer in
    v
