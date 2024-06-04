type expr =
  | Var of int
  | B of bool
  | I of int
  | F of float
  | Sym of string
  | Str of string
  | Cons of expr * expr
  | Nil

let rec equal e1 e2 =
  match (e1, e2) with
  | Var i, Var j -> i = j
  | B i, B j -> i = j
  | I i, I j -> i = j
  | F i, F j -> i = j
  | Sym s1, Sym s2 -> s1 = s2
  | Str s1, Str s2 -> s1 = s2
  | Cons (h1, t1), Cons (h2, t2) -> equal h1 h2 && equal t1 t2
  | Nil, Nil -> true
  | _, _ -> false

exception Cyclic

module Table = Alist.Make (Int)

type 'a table = 'a Table.t
type state = { table : expr table; counter : int }
type states = state list

let empty_state = [ { table = Table.new_alist; counter = 0 } ]

let rec walk_table = function
  | Var key -> (
      fun table ->
        match Table.get key table with
        | Some e -> walk_table e table
        | None -> Var key)
  | e -> fun _ -> e

let walk e { table; counter = _ } = walk_table e table

let extend_state key e { table; counter } =
  if not (Table.has_key key table) then
    { table = Table.set key e table; counter }
  else raise Cyclic

let new_var { table; counter } =
  let counter = counter + 1 in
  (Var counter, { table; counter })

let rec unify e1 e2 state =
  let e1 = walk e1 state and e2 = walk e2 state in
  match (e1, e2) with
  | e1, e2 when equal e1 e2 -> Some state
  | Var key, e -> Some (extend_state key e state)
  | e, Var key -> Some (extend_state key e state)
  | Cons (h1, t1), Cons (h2, t2) -> (
      match unify h1 h2 state with
      | Some state -> unify t1 t2 state
      | None -> None)
  | _, _ -> None

let equiv e1 e2 state =
  match unify e1 e2 state with Some state -> [ state ] | None -> []

let call_fresh f state =
  let var, state = new_var state in
  f var state
