module Make (F : Functor_sigs.Functor) = struct
  type 'a free = Pure of 'a | Adorned of 'a free F.t

  let pure_ x = Pure x
  let free_lift fx = Adorned (F.fmap pure_ fx)

  module Derived_monad : Functor_sigs.Monad with type 'a t = 'a free =
  Functor.Monad_of_minimal_monad_bind (struct
    type 'a t = 'a free

    let pure = pure_

    let rec bind mfx g =
      match mfx with
      | Pure x -> g x
      | Adorned fx -> Adorned (F.fmap (fun mfx -> bind mfx g) fx)
  end)

  include Derived_monad
end
