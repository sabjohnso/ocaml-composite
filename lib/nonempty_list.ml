type 'a nonempty_list = 'a * 'a list

exception Call_to_tl_with_one_element
exception Cannot_create_nonempty_list_from_an_empty_collection


let rec rev_append xs (y, ys) = match xs with
  | x1, x2 :: xs -> rev_append (x2, xs) (x1, y :: ys)
  | x, []        -> (x, y :: ys)

let rev (x1, xs) = match xs with
  | x2 :: xs -> rev_append (x2, xs) (x1, [])
  | []       -> (x1, [])


module Derived_monad : Functor_sigs.Monad with type 'a t = 'a nonempty_list =
  Functor.Monad_of_minimal_monad_bind (
      struct
        type 'a t = 'a nonempty_list
        let pure x = (x, [])
        let bind (x, xs) f =
          let rec loop accum = function
            | x :: xs -> loop  (rev_append (f x) accum) xs
            | [] -> rev accum
          in
          loop (rev (f x)) xs
      end
    )

include Derived_monad

module Derived_comonad : Functor_sigs.Comonad with type 'a t = 'a nonempty_list =
  Functor.Comonad_of_minimal_comonad_extend (
      struct
        type 'a t = 'a nonempty_list
        let extract (x, _) = x
        let extend f (x, xs) =
          let rec loop (y, ys) =
            (function
             | x :: xs -> loop ((f (x, xs), y :: ys)) xs
             | [] -> rev (y, ys))
          in loop (f (x, xs), []) xs
      end
    )
include Derived_comonad

let hd (x, _) = x
let tl (_, xs) = match xs with
  | x :: xs -> (x, xs)
  | []      -> raise Call_to_tl_with_one_element

let cons x (y, ys) = (x, y :: ys)

let append xs ys = rev_append (rev xs) ys

let length (_, xs) = 1 + List.length xs

let of_list = function
  | x :: xs -> (x, xs)
  | _       -> raise Cannot_create_nonempty_list_from_an_empty_collection

let of_seq xs = of_list @@ List.of_seq xs
