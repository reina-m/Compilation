
module MenhirBasics = struct
  
  exception Error
  
  let _eRR =
    fun _s ->
      raise Error
  
  type token = 
    | RPAR
    | LPAR
    | ID
    | EOF
    | COMMA
  
end

include MenhirBasics

type ('s, 'r) _menhir_state = 
  | MenhirState00 : ('s, _menhir_box_prog) _menhir_state
    (** State 00.
        Stack shape : .
        Start symbol: prog. *)

  | MenhirState01 : (('s, _menhir_box_prog) _menhir_cell1_LPAR, _menhir_box_prog) _menhir_state
    (** State 01.
        Stack shape : LPAR.
        Start symbol: prog. *)

  | MenhirState02 : (('s, _menhir_box_prog) _menhir_cell1_ID, _menhir_box_prog) _menhir_state
    (** State 02.
        Stack shape : ID.
        Start symbol: prog. *)

  | MenhirState05 : (('s, _menhir_box_prog) _menhir_cell1_simple_expr, _menhir_box_prog) _menhir_state
    (** State 05.
        Stack shape : simple_expr.
        Start symbol: prog. *)

  | MenhirState15 : (('s, _menhir_box_prog) _menhir_cell1_expr, _menhir_box_prog) _menhir_state
    (** State 15.
        Stack shape : expr.
        Start symbol: prog. *)


and ('s, 'r) _menhir_cell1_expr = 
  | MenhirCell1_expr of 's * ('s, 'r) _menhir_state * (unit)

and ('s, 'r) _menhir_cell1_simple_expr = 
  | MenhirCell1_simple_expr of 's * ('s, 'r) _menhir_state * (unit)

and ('s, 'r) _menhir_cell1_ID = 
  | MenhirCell1_ID of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_LPAR = 
  | MenhirCell1_LPAR of 's * ('s, 'r) _menhir_state

and _menhir_box_prog = 
  | MenhirBox_prog of (unit) [@@unboxed]

let _menhir_action_01 =
  fun () ->
    (
# 10 "fcall.mly"
              ()
# 69 "fcall.ml"
     : (unit))

let _menhir_action_02 =
  fun () ->
    (
# 11 "fcall.mly"
                                ()
# 77 "fcall.ml"
     : (unit))

let _menhir_action_03 =
  fun () ->
    (
# 12 "fcall.mly"
           ()
# 85 "fcall.ml"
     : (unit))

let _menhir_action_04 =
  fun () ->
    (
# 145 "<standard.mly>"
    ( [] )
# 93 "fcall.ml"
     : (unit list))

let _menhir_action_05 =
  fun x ->
    (
# 148 "<standard.mly>"
    ( x )
# 101 "fcall.ml"
     : (unit list))

let _menhir_action_06 =
  fun x ->
    (
# 228 "<standard.mly>"
    ( [ x ] )
# 109 "fcall.ml"
     : (unit list))

let _menhir_action_07 =
  fun x xs ->
    (
# 231 "<standard.mly>"
    ( x :: xs )
# 117 "fcall.ml"
     : (unit list))

let _menhir_action_08 =
  fun () ->
    (
# 6 "fcall.mly"
           ()
# 125 "fcall.ml"
     : (unit))

let _menhir_action_09 =
  fun x ->
    (
# 250 "<standard.mly>"
    ( [ x ] )
# 133 "fcall.ml"
     : (unit list))

let _menhir_action_10 =
  fun x xs ->
    (
# 253 "<standard.mly>"
    ( x :: xs )
# 141 "fcall.ml"
     : (unit list))

let _menhir_action_11 =
  fun () ->
    (
# 16 "fcall.mly"
     ()
# 149 "fcall.ml"
     : (unit))

let _menhir_action_12 =
  fun () ->
    (
# 17 "fcall.mly"
                 ()
# 157 "fcall.ml"
     : (unit))

let _menhir_action_13 =
  fun () ->
    (
# 18 "fcall.mly"
        ()
# 165 "fcall.ml"
     : (unit))

let _menhir_action_14 =
  fun xs ->
    let _2 = 
# 241 "<standard.mly>"
    ( xs )
# 173 "fcall.ml"
     in
    (
# 22 "fcall.mly"
                                        ()
# 178 "fcall.ml"
     : (unit))

let _menhir_print_token : token -> string =
  fun _tok ->
    match _tok with
    | COMMA ->
        "COMMA"
    | EOF ->
        "EOF"
    | ID ->
        "ID"
    | LPAR ->
        "LPAR"
    | RPAR ->
        "RPAR"

let _menhir_fail : unit -> 'a =
  fun () ->
    Printf.eprintf "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

include struct
  
  [@@@ocaml.warning "-4-37"]
  
  let _menhir_run_19 : type  ttv_stack. ttv_stack -> _ -> _menhir_box_prog =
    fun _menhir_stack _tok ->
      match (_tok : MenhirBasics.token) with
      | EOF ->
          let _v = _menhir_action_08 () in
          MenhirBox_prog _v
      | _ ->
          _eRR ()
  
  let rec _menhir_run_01 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_LPAR (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState01 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | LPAR ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | ID ->
          _menhir_run_02 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | RPAR ->
          let _v = _menhir_action_04 () in
          _menhir_goto_loption_separated_nonempty_list_COMMA_expr__ _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _eRR ()
  
  and _menhir_run_02 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | LPAR ->
          let _menhir_stack = MenhirCell1_ID (_menhir_stack, _menhir_s) in
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState02
      | ID ->
          let _menhir_stack = MenhirCell1_ID (_menhir_stack, _menhir_s) in
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState02
      | COMMA | EOF | RPAR ->
          let _v = _menhir_action_11 () in
          _menhir_goto_simple_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_03 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_11 () in
      _menhir_goto_simple_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_simple_expr : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState00 ->
          _menhir_run_09 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
      | MenhirState15 ->
          _menhir_run_09 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
      | MenhirState01 ->
          _menhir_run_09 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
      | MenhirState05 ->
          _menhir_run_05 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState02 ->
          _menhir_run_05 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_09 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok ->
      let _v = _menhir_action_01 () in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_expr : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState00 ->
          _menhir_run_19 _menhir_stack _tok
      | MenhirState15 ->
          _menhir_run_17 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState01 ->
          _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_17 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_expr as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | COMMA ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_15 _menhir_stack _menhir_lexbuf _menhir_lexer
      | RPAR ->
          let x = _v in
          let _v = _menhir_action_09 x in
          _menhir_goto_separated_nonempty_list_COMMA_expr_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_15 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_expr -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState15 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | LPAR ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | ID ->
          _menhir_run_02 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_goto_separated_nonempty_list_COMMA_expr_ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState15 ->
          _menhir_run_16 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState01 ->
          _menhir_run_10 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_16 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_expr -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_expr (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_10 x xs in
      _menhir_goto_separated_nonempty_list_COMMA_expr_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_run_10 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_LPAR -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let x = _v in
      let _v = _menhir_action_05 x in
      _menhir_goto_loption_separated_nonempty_list_COMMA_expr__ _menhir_stack _menhir_lexbuf _menhir_lexer _v
  
  and _menhir_goto_loption_separated_nonempty_list_COMMA_expr__ : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_LPAR -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell1_LPAR (_menhir_stack, _menhir_s) = _menhir_stack in
      let xs = _v in
      let _ = _menhir_action_14 xs in
      _menhir_goto_tuple _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
  
  and _menhir_goto_tuple : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok ->
      match _menhir_s with
      | MenhirState00 ->
          _menhir_run_06 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
      | MenhirState15 ->
          _menhir_run_06 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
      | MenhirState01 ->
          _menhir_run_06 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
      | MenhirState05 ->
          _menhir_run_06 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
      | MenhirState02 ->
          _menhir_run_04 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
  
  and _menhir_run_06 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok ->
      let _v = _menhir_action_13 () in
      _menhir_goto_simple_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_04 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_ID as 'stack) -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | COMMA | EOF | RPAR ->
          let MenhirCell1_ID (_menhir_stack, _menhir_s) = _menhir_stack in
          let _v = _menhir_action_03 () in
          _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | ID | LPAR ->
          let _v = _menhir_action_13 () in
          _menhir_goto_simple_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_13 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_LPAR as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | RPAR ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_LPAR (_menhir_stack, _menhir_s) = _menhir_stack in
          let _v = _menhir_action_12 () in
          _menhir_goto_simple_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | COMMA ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_15 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_05 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | LPAR ->
          let _menhir_stack = MenhirCell1_simple_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState05
      | ID ->
          let _menhir_stack = MenhirCell1_simple_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState05
      | COMMA | EOF | RPAR ->
          let x = _v in
          let _v = _menhir_action_06 x in
          _menhir_goto_nonempty_list_simple_expr_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_nonempty_list_simple_expr_ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState02 ->
          _menhir_run_08 _menhir_stack _menhir_lexbuf _menhir_lexer _tok
      | MenhirState05 ->
          _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_08 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_ID -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _tok ->
      let MenhirCell1_ID (_menhir_stack, _menhir_s) = _menhir_stack in
      let _v = _menhir_action_02 () in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_07 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_simple_expr -> _ -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_simple_expr (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_07 x xs in
      _menhir_goto_nonempty_list_simple_expr_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  let _menhir_run_00 : type  ttv_stack. ttv_stack -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState00 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | LPAR ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | ID ->
          _menhir_run_02 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
end

let prog =
  fun _menhir_lexer _menhir_lexbuf ->
    let _menhir_stack = () in
    let MenhirBox_prog v = _menhir_run_00 _menhir_stack _menhir_lexbuf _menhir_lexer in
    v
