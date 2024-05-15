type 'a type_proxy = Tproxy

module Derived_monad : Functor_sigs.Monad with type 'a t = 'a type_proxy =
    Functor.Monad_of_minimal_monad_bind (
        struct
          type 'a t = 'a type_proxy
          let pure : 'a -> 'a t = (fun _ -> Tproxy)
          let bind : 'a t -> ('a -> 'b t) -> 'b t = (fun _  _ -> Tproxy)
        end
      )
include Derived_monad
