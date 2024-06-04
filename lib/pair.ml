type ('a, 'b) pair = 'a * 'b
type ('a, 'b) t = ('a, 'b) pair

let pair x y = (x, y)
let fst (x, _) = x
let snd (_, y) = y

module type Type_provider = sig
  type t
end

module Make_comonad (E : Type_provider) = struct
  type env = E.t

  module Derived_comonad_ = Functor.Comonad_of_minimal_comonad_extend (struct
    type 'a t = ('a, env) pair

    let extract = fst
    let extend f (a, e) = (f (a, e), e)
  end)

  include Derived_comonad_
end
