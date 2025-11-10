
module MenhirBasics = struct
  
  exception Error
  
  let _eRR =
    fun _s ->
      raise Error
  
  type token = 
    | SEMI
    | IF
    | EOF
    | ELSE
    | COND
    | ATOM
  
end

include MenhirBasics

type ('s, 'r) _menhir_state = 
  | MenhirState00 : ('s, _menhir_box_prog) _menhir_state
    (** State 00.
        Stack shape : .
        Start symbol: prog. *)

  | MenhirState02 : (('s, _menhir_box_prog) _menhir_cell1_IF, _menhir_box_prog) _menhir_state
    (** State 02.
        Stack shape : IF.
        Start symbol: prog. *)

  | MenhirState05 : (('s, _menhir_box_prog) _menhir_cell1_seq, _menhir_box_prog) _menhir_state
    (** State 05.
        Stack shape : seq.
        Start symbol: prog. *)

  | MenhirState07 : ((('s, _menhir_box_prog) _menhir_cell1_IF, _menhir_box_prog) _menhir_cell1_seq, _menhir_box_prog) _menhir_state
    (** State 07.
        Stack shape : IF seq.
        Start symbol: prog. *)


and ('s, 'r) _menhir_cell1_seq = 
  | MenhirCell1_seq of 's * ('s, 'r) _menhir_state * (unit)

and ('s, 'r) _menhir_cell1_IF = 
  | MenhirCell1_IF of 's * ('s, 'r) _menhir_state

and _menhir_box_prog = 
  | MenhirBox_prog of (unit) [@@unboxed]

let _menhir_action_1 =
  fun () ->
    (
# 15 "if.mly"
       ()
# 59 "if.ml"
     : (unit))

let _menhir_action_2 =
  fun () ->
    (
# 16 "if.mly"
              ()
# 67 "if.ml"
     : (unit))

let _menhir_action_3 =
  fun () ->
    (
# 17 "if.mly"
                       ()
# 75 "if.ml"
     : (unit))

let _menhir_action_4 =
  fun () ->
    (
# 6 "if.mly"
          ()
# 83 "if.ml"
     : (unit))

let _menhir_action_5 =
  fun () ->
    (
# 10 "if.mly"
       ()
# 91 "if.ml"
     : (unit))

let _menhir_action_6 =
  fun () ->
    (
# 11 "if.mly"
                ()
# 99 "if.ml"
     : (unit))

let _menhir_print_token : token -> string =
  fun _tok ->
    match _tok with
    | ATOM ->
        "ATOM"
    | COND ->
        "COND"
    | ELSE ->
        "ELSE"
    | EOF ->
        "EOF"
    | IF ->
        "IF"
    | SEMI ->
        "SEMI"

let _menhir_fail : unit -> 'a =
  fun () ->
    Printf.eprintf "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

include struct
  
  [@@@ocaml.warning "-4-37"]
  
  let rec _menhir_run_01 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_IF (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | COND ->
          let _menhir_s = MenhirState02 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | IF ->
              _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | ATOM ->
              _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_03 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _ = _menhir_action_1 () in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
  
  and _menhir_goto_expr : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok ->
      match _menhir_s with
      | MenhirState00 ->
          _menhir_run_09 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
      | MenhirState02 ->
          _menhir_run_09 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
      | MenhirState07 ->
          _menhir_run_09 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
      | MenhirState05 ->
          _menhir_run_06 _menhir_stack _menhir_lexbuf _menhir_lexer _tok
  
  and _menhir_run_09 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok ->
      let _v = _menhir_action_5 () in
      _menhir_goto_seq _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_seq : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState00 ->
          _menhir_run_10 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState07 ->
          _menhir_run_08 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState02 ->
          _menhir_run_04 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_10 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | SEMI ->
          let _menhir_stack = MenhirCell1_seq (_menhir_stack, _menhir_s, _v) in
          _menhir_run_05 _menhir_stack _menhir_lexbuf _menhir_lexer
      | EOF ->
          let _v = _menhir_action_4 () in
          MenhirBox_prog _v
      | _ ->
          _eRR ()
  
  and _menhir_run_05 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_seq -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState05 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IF ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | ATOM ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_08 : type  ttv_stack. (((ttv_stack, _menhir_box_prog) _menhir_cell1_IF, _menhir_box_prog) _menhir_cell1_seq as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | SEMI ->
          let _menhir_stack = MenhirCell1_seq (_menhir_stack, _menhir_s, _v) in
          _menhir_run_05 _menhir_stack _menhir_lexbuf _menhir_lexer
      | ELSE | EOF ->
          let MenhirCell1_seq (_menhir_stack, _, _) = _menhir_stack in
          let MenhirCell1_IF (_menhir_stack, _menhir_s) = _menhir_stack in
          let _ = _menhir_action_3 () in
          _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_04 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_IF as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | SEMI ->
          let _menhir_stack = MenhirCell1_seq (_menhir_stack, _menhir_s, _v) in
          _menhir_run_05 _menhir_stack _menhir_lexbuf _menhir_lexer
      | ELSE ->
          let _menhir_stack = MenhirCell1_seq (_menhir_stack, _menhir_s, _v) in
          let _menhir_s = MenhirState07 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | IF ->
              _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | ATOM ->
              _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | EOF ->
          let MenhirCell1_IF (_menhir_stack, _menhir_s) = _menhir_stack in
          let _ = _menhir_action_2 () in
          _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_06 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_seq -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _tok ->
      let MenhirCell1_seq (_menhir_stack, _menhir_s, _) = _menhir_stack in
      let _v = _menhir_action_6 () in
      _menhir_goto_seq _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  let _menhir_run_00 : type  ttv_stack. ttv_stack -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState00 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IF ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | ATOM ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
end

let prog =
  fun _menhir_lexer _menhir_lexbuf ->
    let _menhir_stack = () in
    let MenhirBox_prog v = _menhir_run_00 _menhir_stack _menhir_lexbuf _menhir_lexer in
    v
