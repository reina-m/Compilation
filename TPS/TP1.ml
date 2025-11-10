open Base
let range a b = List.init (b - a) (fun i -> a + i);;

(*EXERCICE 1.1*)
let fact (n: int):int =
    let rec aux n acc =
        if n <= 1 then acc
        else aux (n - 1) (n * acc)
    in
    aux n 1
;;

let nb_bit_pos (n:int):int = 
    let rec aux n acc = 
        if n = 0 then acc
        else if n mod 2 = 1 then aux (n/2) (acc + 1)
        else aux (n / 2) acc
    in
    aux n 0
;;

let nb_bit_pos_prof (n:int):int = 
        if n = 0 then 0
        else
            let bit : int = n mod 2 in 
            bit * nb_bit_pos_prof (n / 2)
;;


(*EXERCICE 1.2*)
let rec fib (n : int):int =
    let rec aux (n : int) (a : int) (b : int) : int =
        if n = 0 then a
        else if n = 1 then b
        else aux (n - 1) b (a + b) (*a = b*)
    in
    aux n 0 1
;;

let _ = List.map fib (range 0 10);;

let x = fact 5
let y = nb_bit_pos 15
let z = fib 10


(*EXERCICE 1.3*)    
let palindrome (m:string):bool =
    let rec aux (i:int) (j:int) : bool =
        if i >= j then true
        else if m.[i] <> m.[j] then false
        else aux (i + 1) (j - 1)
    in
    aux 0 (String.length m - 1)
;;

let palindrome_prof (str:string):bool =
    let rec pal_between (s:int) (e:int):bool =
        s >= e || str.[s] = str.[e] && pal_between (s + 1) (e - 1)
    in
    let n : int = String.length str in
    pal_between 0 (n - 1)
;;

let compare (m1:string) (m2:string):bool = 
    let n1 = String.length m1 in
    let n2 = String.length m2 in
    let rec aux (i:int) (j:int) : bool =
        if i >= n1 then i >= len2 
        else if j >= n2 then false
        else if m1.[i] < m2.[j] then true 
        else if m1.[i] > m2.[j] then false
        else aux (i + 1) (j + 1)
    in
    aux 0 0

;;

let lexico_leq (m1:string) (m2:stirng) : bool = 
    let n1 : int = String.length m1 in
    let n2 : int = String.length m2 in
    let rec comp_from (i : int) : bool = 
        i >= n1 || 
        (i < n2 && 
            let c : int = Char.code m2.[i] - Char.code m1.[i] in
            (c > 0 || (c = 0 && comp_from (i + 1))))
    in
    comp_from 0
;;


let facteur (m1:string) (m2:string):bool = 
    let n1 = String.length m1 in
    let n2 = String.length m2 in
    let rec aux (i:int) (j:int) : bool =
        if j >= n2 then true
        else if i >= n1 then false
        else if m1.[i] = m2.[j] then aux (i + 1) (j + 1)
        else aux i (j + 1)
;;

let facteur_prof (m1:string) (m2:string):bool = 
    let n1 = String.length m1 in
    let n2 = String.length m2 in
    let rec facteur_from (i1:int) (i2:int) : bool =
        i1 >= n1 || 
        (i2 < n2 && 
            (m1.[i1] = m2.[i2] && facteur_from (i1 + 1) (i2 + 1) || 
            m1.[i1] <> m2.[i2] && facteur_from i1 (i2 + 1)))
    in
    let rec facteur_after (k:int) : bool =
        k < n2 && (facteur_from 0 k || facteur_after (k + 1))
    in
    if n1 = 0 then true else facteur_after 0
;;


(*EXERCICE 1.4*)
let split (l: 'a list): 'a list * 'a list =
    let len = List.length l in
    let mid = len / 2 in
    let rec aux lst n acc =
        match lst with 
        | [] -> (List.rev acc, [])
        | h :: t -> 
            if n = 0 then (List.rev acc, lst)
            else aux t (n-1) (h :: acc)
    in
    aux l mid []
;;

let split_prof (l: int list) : int list * int list = 
    let rec split_swap (l1 : int list) (l2 : int list ) (l0 : int list) : int list * int list =
        match l0 with
        | [] -> l1, l2
        | h :: t -> split_swap l2 (h :: l1) t
    in
    split_swap [] [] l
;;

let l = [1;2;3;4;5;6;7;8;9];;
let (l1, l2) = split l;;

let merge (l1 : 'a list) (l2 : 'a list) : 'a list =
    let rec aux l1 l2 acc =
        match (l1, l2) with
        | ([], _) -> List.rev_append acc l2 (*on ajoute le reste de la liste*)
        | (_, []) -> List.rev_append acc l1
        | (h1 :: t1, h2 :: t2) ->
            if h1 <= h2 then aux t1 l2 (h1 :: acc)
            else aux l1 t2 (h2 :: acc)
    in
    aux l1 l2 []
;;

let rec merge _prof (l1 : int list) (l2 : int list) : int list = 
    mztch l1, l2 with
    | [], l | l, [] -> l2
    | h1 :: t1, h2 :: t2 -> 
        if h1 < h2 then h1 :: merge_prof t1 l2
        else h2 :: merge_prof l1 t2
;;


let tri (l : 'a list) : 'a list =
    let rec aux lst =
        match lst with
        | [] -> []
        | [x] -> [x]
        | _ -> 
            let (left, right) = split lst in
            merge (aux left) (aux right)
    in
    aux l
;;

(*EXERCICE 1.5*)
let somme_carres (l:int list):int = 
    List.fold_left (fun acc x -> acc + (x * x)) 0 l
;;

let rec somme_carres_bis (l:int list):int = 
    match l with 
        | [] -> 0
        | h :: t -> h * h + somme_carres_bis t
;;

let find_opt (x:int) (l:int list):
    let rec aux lst = 
        match lst with 
        | [] -> None
        | h :: t -> if h = x then Some h else aux t
    in
    aux l
;;

(*EXERCICE 1.6*)
let l = List.map (fun x -> x) (range 0 100);;

let rev (l:'a list): 'a list = 
    let rec aux acc = function
        | [] -> acc
        | h :: t -> aux (h :: acc) t
    in
    aux [] l
;;

let map (l:'a list) (f:'a -> 'b): 'b list = 
    let rec aux acc = function
        | [] -> List.rev acc
        | h :: t -> aux ((f h) :: acc) t
    in
    aux [] l
;;

(*EXERCICE 1.7*)
type 'a seq = 
    | Elt of 'a 
    | Seq of 'a seq * 'a seq
;;

let (@@) x y = Seq (x, y);;

let hd (s: 'a seq): 'a = 
    match s with
    | Elt x -> x
    | Seq (s1, s2) -> hd s1
;;

let mem (s: 'a seq) (x: 'a): bool = 
    match s with
    | Elt y -> x = y
    | Seq (s1, s2) -> mem s1 x || mem s2 x

let tl (s: 'a seq): 'a seq option = 
    match s with
    | Elt _ -> None
    | Seq (s1, s2) -> Some (match s1 with
        | Elt _ -> s2
        | Seq (s11, s12) -> Seq (tl_exn s11, match tl s12 with
            | None -> s2
            | Some s12' -> Seq (s12', s2)))
;;

let rev (s: 'a seq): 'a seq = 
    let rec aux acc = function
        | Elt x -> Seq (Elt x, acc)
        | Seq (s1, s2) -> aux (aux acc s2) s1
    in
    aux (Elt (hd s)) s
;;

let map (s: 'a seq) (f: 'a -> 'b): 'b seq = 
    match s with
    | Elt x -> Elt (f x)
    | Seq (s1, s2) -> Seq (map s1 f, map s2 f)
;;

let fold_left (s: 'a seq) (f: 'b -> 'a -> 'b) (acc: 'b): 'b = 
    match s with
    | Elt x -> f acc x
    | Seq (s1, s2) -> fold_left s2 f (fold_left s1 f acc)
;;

let fold_right (s: 'a seq) (f: 'a -> 'b -> 'b) (acc: 'b): 'b = 
    match s with
    | Elt x -> f x acc
    | Seq (s1, s2) -> fold_right s1 f (fold_right s2 f acc)
;;

let seq2list (s: 'a seq): 'a list = 
    let rec aux acc = function
        | Elt x -> x :: acc
        | Seq (s1, s2) -> aux (aux acc s2) s1
    in
    List.rev (aux [] s)
;;

let find_opt x:'a seq -> 'a = 
    match s with
    | Elt y -> if x = y then Some y else None
    | Seq (s1, s2) -> (match find_opt x s1 with
        | Some y -> Some y
        | None -> find_opt x s2)
;;

let nth (s: 'a seq) (n: int): 'a option = 
    let rec aux s n =
        match s with
        | Elt x -> if n = 0 then Some x else None
        | Seq (s1, s2) -> 
            let len1 = seq_length s1 in
            if n < len1 then aux s1 n
            else aux s2 (n - len1)
    in
    aux s n
;;