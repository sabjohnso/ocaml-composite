type ('s, 'a) stateful = Stateful of ('s -> 'a * 's)

module type State_type = sig
  type t
end

module Make (S : State_type) = struct
  let run s (Stateful f) = f s
  module Derived_monad__ : Functor_sigs.Monad with type 'a t = (S.t, 'a) stateful =
    Functor.Monad_of_minimal_monad_bind (
        struct
          type 'a t = (S.t, 'a) stateful

          let pure x = Stateful (fun s -> (x, s))
          let bind mx f =
            Stateful
              (fun s -> let (x, s) = run s mx in
                        run s (f x))
        end
      )
  include Derived_monad__
  let get = Stateful (fun s -> run s (return s))
  let select f = fmap f
  let put s = Stateful (fun _ -> run s (return ()))
  let modify f = Stateful (fun s -> run (f s) (return ()))
end
