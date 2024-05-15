module Function_arrow_choice : Arrow_choice_sigs.Arrow_choice with type ('a, 'b) t = 'a-> 'b =
  Arrow_choice.Arrow_choice_of_minimal_arrow_choice_choose_split(
      struct
        type ('a, 'b) t = 'a -> 'b
        let id x = x
        let compose f g x = f (g x)
        let arr f = f
        let split f g (x, y) = (f x, g y)
        let choose f g = fun mx ->
          let open Either in
          match mx with
          | Left x -> Left (f x)
          | Right y -> Right (g y)
      end)
include Function_arrow_choice

module type Environment_type = sig
  type t
end

module Make_monad (E : Environment_type) = struct
  module Derived_monad : Functor_sigs.Monad with type 'a t = E.t -> 'a =
    Functor.Monad_of_minimal_monad_bind (
        struct
          type 'a t = E.t -> 'a
          let pure x = fun _ -> x
          let bind mx f = fun e -> (f (mx e)) e
        end
      )
  include Derived_monad
  let ask = fun e -> e
  let asks f = fun e -> f e
  let local f mx = fun e -> mx (f e)
end
