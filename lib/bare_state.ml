(** A bare state monad*)

open Pair

type ('s, 'a) stateful = 's -> ('a, 's) pair

module Make (S : Sigs.Type_provider) = struct
  type state = S.t

  let run s f = f s

  let eval s mx =
    let x, _ = run s mx in
    x

  let exec s mx =
    let _, s = run s mx in
    s

  module Derived_monad__ :
    Functor_sigs.Monad with type 'a t = (S.t, 'a) stateful =
  Functor.Monad_of_minimal_monad_bind (struct
    type state = S.t
    type 'a t = (state, 'a) stateful

    let pure = pair

    let bind mx f s =
      let x, s = run s mx in
      run s (f x)
  end)

  include Derived_monad__

  let get s = run s (return s)
  let select f = fmap f
  let put s _ = run s (return ())
  let modify f s = run (f s) (return ())
end
