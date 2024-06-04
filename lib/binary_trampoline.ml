type 'a trampoline =
  | Thunk of (unit -> 'a trampoline)
  | Cons of 'a * 'a trampoline
  | Nil

module Derived_monad_plus =
Functor.Monad_plus_of_minimal_monad_plus_bind (struct
  type 'a t = 'a trampoline

  let mzero = Nil
  let pure x = Cons (x, Nil)

  let rec mplus = function
    | Thunk thunk -> fun ys -> Thunk (fun () -> mplus ys (thunk ()))
    | Cons (x, xs) -> fun ys -> Cons (x, mplus xs ys)
    | Nil -> fun ys -> ys

  let rec bind = function
    | Thunk thunk -> fun f -> Thunk (fun () -> bind (thunk ()) f)
    | Cons (x, xs) -> fun f -> mplus (f x) (bind xs f)
    | Nil -> fun _ -> Nil
end)

include Derived_monad_plus
