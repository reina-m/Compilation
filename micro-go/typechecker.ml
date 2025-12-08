open Mgoast

exception Error of Mgoast.location * string
let error loc s = raise (Error (loc,s))

let type_error loc ty_actual ty_expected =
  error loc (Printf.sprintf "expected %s, got %s"
           (typ_to_string ty_expected) (typ_to_string ty_actual))

module Env = Map.Make(String)

type tenv = typ Env.t
type fenv = (typ list) * (typ list) Env.t
type senv = (ident * typ) list

let dummy = "_"
let dummy_pos = Lexing.dummy_pos
let dummy_loc = (dummy_pos, dummy_pos)

let add_env l tenv =
  List.fold_left (fun env (x, t) -> if x = dummy then env else Env.add x t env) tenv l

(* Pour formater une location *)
let string_of_location (start_pos, end_pos) =
  Printf.sprintf "File \"%s\", line %d, characters %d-%d"
    start_pos.Lexing.pos_fname
    start_pos.Lexing.pos_lnum
    (start_pos.Lexing.pos_cnum - start_pos.Lexing.pos_bol)
    (end_pos.Lexing.pos_cnum - end_pos.Lexing.pos_bol)

let prog (fmt, ld) =
  let (fenv, senv) =
    List.fold_left
      (fun (fenv, senv) d ->
         match d with 
         | Struct(s) -> (fenv, Env.add s.sname.id s.fields senv)
         | Fun(f) -> (Env.add f.fname.id f fenv, senv))
      (Env.empty, Env.empty) ld
  in
  
  let check_typ t = match t with
  | TInt | TBool | TString -> ()   
  | TStruct s ->
      if not (Env.mem s senv) then
        error dummy_loc ("unknown struct type " ^ s)
  in
  
  let check_fields lf =
    let seen = ref Env.empty in
    List.iter
      (fun (id, t) ->
         if Env.mem id.id !seen then
           error id.loc ("duplicate field name " ^ id.id);
         seen := Env.add id.id () !seen;
         check_typ t
      ) lf
  in
  
  (* BONUS : Variables pour tracer l'utilisation *)
  let used_vars = ref Env.empty in
  let declared_vars = ref Env.empty in
  
  let mark_as_used name =
    used_vars := Env.add name () !used_vars
  in
  
  let declare_var name loc =
    if name <> dummy then
      declared_vars := Env.add name loc !declared_vars
  in
  
  let rec check_expr e typ tenv =
    if e.edesc = Nil then failwith "case not implemented in check"
    else let typ_e = type_expr e tenv in
    if typ_e <> typ then type_error e.eloc typ_e typ
  
  and type_expr e tenv = 
    match e.edesc with
    | Int _ -> TInt
    | Bool _ -> TBool
    | String _ -> TString
    | Var x ->
        mark_as_used x.id;  (* BONUS : Marquer comme utilisé *)
        (try Env.find x.id tenv
         with Not_found -> error e.eloc ("unknown variable " ^ x.id))
    | Dot(e1, f) ->
        let t1 = type_expr e1 tenv in
        let struct_name =
          match t1 with
          | TStruct s -> s
          | _ -> error e.eloc "dot applied to non-struct"
        in
        let fields =
          try Env.find struct_name senv
          with Not_found -> error e.eloc ("unknown struct type " ^ struct_name)
        in
        (try
           let (_, t) = List.find (fun (id, _) -> id.id = f.id) fields in
           t
         with Not_found -> error e.eloc ("unknown field " ^ f.id))
    | Nil -> TStruct dummy
    | New s ->
        if not (Env.mem s senv) then error e.eloc ("unknown struct " ^ s);
        TStruct s
    | Unop(op, e1) ->
        let t = type_expr e1 tenv in
        (match op with
         | Opp -> if t = TInt then TInt else type_error e.eloc t TInt
         | Not -> if t = TBool then TBool else type_error e.eloc t TBool)
    | Binop(op, e1, e2) ->
        let t1 = type_expr e1 tenv in
        let t2 = type_expr e2 tenv in
        (match op with
         | Add | Sub | Mul | Div | Rem ->
             if t1 = TInt && t2 = TInt then TInt else type_error e.eloc t1 TInt
         | Eq | Neq | Lt | Le | Gt | Ge ->
             if t1 = TInt && t2 = TInt then TBool else type_error e.eloc t1 TInt
         | And | Or ->
             if t1 = TBool && t2 = TBool then TBool else type_error e.eloc t1 TBool)
    | Call(f, args) ->
        let fd =
          try Env.find f.id fenv
          with Not_found -> error e.eloc ("unknown function " ^ f.id)
        in
        let param_types = List.map snd fd.params in
        let return_types = fd.return in
        if List.length param_types <> List.length args then
          error e.eloc "wrong number of arguments";
        List.iter2 (fun t arg -> check_expr arg t tenv) param_types args;
        (match return_types with
         | [t] -> t
         | [] -> TInt
         | _ -> failwith "multiple return types not supported")
    | Print args ->
        (match args with
         | [{edesc = Call(f, call_args); eloc = call_loc}] ->
             let fd =
               try Env.find f.id fenv
               with Not_found -> error call_loc ("unknown function " ^ f.id)
             in
             let param_types = List.map snd fd.params in
             if List.length param_types <> List.length call_args then
               error call_loc "wrong number of arguments";
             List.iter2 (fun t arg -> check_expr arg t tenv) param_types call_args;
             TInt
         | _ ->
             List.iter (fun e -> ignore (type_expr e tenv)) args;
             TInt
        )
  in

  let rec check_instr i ret tenv = 
    match i.idesc with
    | Set(xs, es) ->
        (match es with
         | [{edesc = Call(f, args); eloc = call_loc}] ->
             let fd =
               try Env.find f.id fenv
               with Not_found -> error call_loc ("unknown function " ^ f.id)
             in
             let param_types = List.map snd fd.params in
             let return_types = fd.return in
             if List.length param_types <> List.length args then
               error call_loc "wrong number of arguments";
             List.iter2 (fun t arg -> check_expr arg t tenv) param_types args;
             if List.length xs <> List.length return_types then
               error i.iloc "wrong number of values in assignment";
             List.iter2 (fun x ty ->
               match x.edesc with
               | Var v ->
                   (try
                      let t_var = Env.find v.id tenv in
                      if ty <> t_var then type_error x.eloc ty t_var
                    with Not_found -> error x.eloc ("unknown variable " ^ v.id))
               | Dot(e1, field) ->
                   let t1 = type_expr e1 tenv in
                   (match t1 with
                    | TStruct s ->
                        let fields =
                          try Env.find s senv
                          with Not_found -> error x.eloc ("unknown struct type " ^ s)
                        in
                        (try
                           let (_, field_type) = List.find (fun (id, _) -> id.id = field.id) fields in
                           if ty <> field_type then
                             type_error x.eloc ty field_type
                         with Not_found -> error x.eloc ("unknown field " ^ field.id))
                    | _ -> error x.eloc "dot applied to non-struct in assignment")
               | _ -> error x.eloc "invalid lvalue"
             ) xs return_types
         | _ ->
             if List.length xs <> List.length es then
               error i.iloc "wrong number of values in assignment";
             List.iter2
               (fun x e ->
                  let t = type_expr e tenv in
                  match x.edesc with
                  | Var v ->
                      (try
                         let t_var = Env.find v.id tenv in
                         if t <> t_var then type_error i.iloc t t_var
                       with Not_found -> error i.iloc ("unknown variable " ^ v.id))
                  | Dot(e1, field) ->
                      let t1 = type_expr e1 tenv in
                      (match t1 with
                       | TStruct s ->
                           let fields =
                             try Env.find s senv
                             with Not_found -> error x.eloc ("unknown struct type " ^ s)
                           in
                           (try
                              let (_, field_type) = List.find (fun (id, _) -> id.id = field.id) fields in
                              if t <> field_type then
                                type_error x.eloc t field_type
                            with Not_found -> error x.eloc ("unknown field " ^ field.id))
                       | _ -> error x.eloc "dot applied to non-struct in assignment")
                  | _ -> error i.iloc "invalid lvalue")
               xs es
        );
        tenv
    | Inc e | Dec e ->
        check_expr e TInt tenv;
        tenv
    | If(e, s1, s2) ->
        check_expr e TBool tenv;
        let _ = check_seq s1 ret tenv in
        let _ = check_seq s2 ret tenv in
        tenv
    | For(e, s) ->
        check_expr e TBool tenv;
        let _ = check_seq s ret tenv in
        tenv
    | Block s ->
        let _ = check_seq s ret tenv in
        tenv
    | Vars(ids, topt, s) ->
        (* BONUS : Déclarer les variables *)
        List.iter (fun id -> declare_var id.id id.loc) ids;
        
        (match topt, s with
         | Some ty, _ ->
             check_typ ty;
             let env' = List.fold_left (fun env id -> 
               if id.id = dummy then env else Env.add id.id ty env
             ) tenv ids in
             let _ = check_seq s ret env' in
             env'
         | None, {idesc = Set(_, rhs); _} :: rest ->
             let types = 
               (match rhs with
                | [{edesc = Call(f, args); eloc = call_loc}] ->
                    let fd =
                      try Env.find f.id fenv
                      with Not_found -> error call_loc ("unknown function " ^ f.id)
                    in
                    let param_types = List.map snd fd.params in
                    let return_types = fd.return in
                    if List.length param_types <> List.length args then
                      error call_loc "wrong number of arguments";
                    List.iter2 (fun t arg -> check_expr arg t tenv) param_types args;
                    if List.length ids <> List.length return_types then
                      error i.iloc "wrong number of initializers";
                    return_types
                | [e] ->
                    if List.length ids <> 1 then
                      error i.iloc "wrong number of initializers";
                    if e.edesc = Nil then
                      error e.eloc "cannot use nil without explicit type";
                    [type_expr e tenv]
                | _ ->
                    if List.length ids <> List.length rhs then
                      error i.iloc "wrong number of initializers";
                    List.map (fun e -> 
                      if e.edesc = Nil then
                        error e.eloc "cannot use nil without explicit type";
                      type_expr e tenv
                    ) rhs
               )
             in
             let env' = List.fold_left2 (fun env id ty -> 
               if id.id = dummy then env else Env.add id.id ty env
             ) tenv ids types in
             let _ = check_seq rest ret env' in
             env'
         | None, _ ->
             error i.iloc "variable declaration without type requires initialization"
        )
    | Return el ->
        (match el with
         | [{edesc = Call(f, args); eloc = call_loc}] ->
             let fd =
               try Env.find f.id fenv
               with Not_found -> error call_loc ("unknown function " ^ f.id)
             in
             let param_types = List.map snd fd.params in
             let return_types = fd.return in
             if List.length param_types <> List.length args then
               error call_loc "wrong number of arguments";
             List.iter2 (fun t arg -> check_expr arg t tenv) param_types args;
             if List.length return_types <> List.length ret then
               error i.iloc "wrong number of return values";
             List.iter2 (fun rt expected ->
               if rt <> expected then
                 type_error call_loc rt expected
             ) return_types ret
         | _ ->
             if List.length el <> List.length ret then
               error i.iloc "wrong number of return values";
             List.iter2 (fun e t -> check_expr e t tenv) el ret
        );
        tenv
    | Expr e ->
        (match e.edesc with
         | Call(f, args) ->
             let fd =
               try Env.find f.id fenv
               with Not_found -> error e.eloc ("unknown function " ^ f.id)
             in
             let pts = List.map snd fd.params in
             if List.length pts <> List.length args then
               error e.eloc "wrong number of arguments";
             List.iter2 (fun t a -> check_expr a t tenv) pts args
         | _ ->
             ignore (type_expr e tenv));
        tenv

  and check_seq s ret tenv =
    List.fold_left (fun env i -> check_instr i ret env) tenv s
  in
  
  let check_function f = 
    (* BONUS : Réinitialiser pour chaque fonction *)
    used_vars := Env.empty;
    declared_vars := Env.empty;
    
    (* Les paramètres sont aussi des variables déclarées *)
    List.iter (fun (id, _) -> declare_var id.id id.loc) f.params;
    
    let params_as_strings = List.map (fun (id, t) -> (id.id, t)) f.params in
    let tenv_fun = add_env params_as_strings Env.empty in
    ignore (check_seq f.body f.return tenv_fun);
    
    (* BONUS : Vérifier les variables non utilisées *)
    Env.iter (fun name loc ->
      if not (Env.mem name !used_vars) then
        Printf.eprintf "Warning: %s: variable '%s' declared but not used\n"
          (string_of_location loc) name
    ) !declared_vars
  in
  
  Env.iter (fun _ lf -> check_fields lf) senv;
  Env.iter (fun _ fd -> check_function fd) fenv;

  (try
     let main_func = Env.find "main" fenv in
     if main_func.params <> [] then
       error main_func.fname.loc "main function must have no parameters";
     if main_func.return <> [] then
       error main_func.fname.loc "main function must have no return type"
   with Not_found ->
     error dummy_loc "missing main function"
  );
  
  (* 2. Vérifier la cohérence de import "fmt" avec fmt.Print *)
  (* Compter le nombre de fmt.Print dans tout le programme *)
  let print_count = ref 0 in
  
  let rec count_prints_expr e =
    match e.edesc with
    | Print _ -> incr print_count
    | Unop(_, e1) -> count_prints_expr e1
    | Binop(_, e1, e2) -> count_prints_expr e1; count_prints_expr e2
    | Dot(e1, _) -> count_prints_expr e1
    | Call(_, args) -> List.iter count_prints_expr args
    | _ -> ()
  in
  
  let rec count_prints_instr i =
    match i.idesc with
    | Set(xs, es) ->
        List.iter count_prints_expr xs;
        List.iter count_prints_expr es
    | Inc e | Dec e -> count_prints_expr e
    | If(e, s1, s2) ->
        count_prints_expr e;
        count_prints_seq s1;
        count_prints_seq s2
    | For(e, s) ->
        count_prints_expr e;
        count_prints_seq s
    | Block s -> count_prints_seq s
    | Vars(_, _, s) -> count_prints_seq s
    | Return el -> List.iter count_prints_expr el
    | Expr e -> count_prints_expr e
  
  and count_prints_seq s =
    List.iter count_prints_instr s
  in
  
  (* Compter dans toutes les fonctions *)
  Env.iter (fun _ fd -> count_prints_seq fd.body) fenv;
  
  (* Vérifier la cohérence *)
  let has_print = !print_count > 0 in
  if fmt && not has_print then
    error dummy_loc "import \"fmt\" declared but fmt.Print is never used";
  if not fmt && has_print then
    error dummy_loc "fmt.Print used but import \"fmt\" not declared";
  ld