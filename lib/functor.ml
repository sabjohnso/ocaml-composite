open Functor_sigs

module Functor_of_basic_functor (M : Basic_functor) = struct
  include M
  let ( <$> ) = fmap
end

module Applicative_of_basic_applicative (M : Basic_applicative) = struct
  module Derived_functor_ = Functor_of_basic_functor (M)
  include Derived_functor_
  include M
  let fapply mf mx = fmap (fun (f, x) -> (f x)) (product mf mx)
  let ( <*> ) = fapply
end

module Applicative_of_minimal_applicative_fapply (M : Minimal_applicative_fapply) = struct
  module Derived_functor_ =
    Functor_of_basic_functor(
        struct
          include M
          let fmap f mx = fapply (pure f) mx
        end
      )  
  include Derived_functor_
  include M
  let ( <*> ) = fapply
  let product ma mb = (fmap (fun x y -> (x, y)) ma  <*> mb)
end

module Applicative_of_minimal_applicative_product (M : Minimal_applicative_product) = struct
  module Derived_functor_ = Functor_of_basic_functor (M)
  include Derived_functor_
  include M
  let fapply mf mx = (fun (f, x) -> f x) <$> product mf mx
  let ( <*> ) = fapply
end

module Monad_of_basic_monad (M : Basic_monad) = struct
  module Derived_applicative = Applicative_of_basic_applicative (M)
  include Derived_applicative
  include M
  let return = pure
  let flatmap f mx = bind mx f
  let ( >>= ) = bind
  let ( =<< ) = flatmap
  let ( <=< ) f g mx = bind (bind mx g) f
  let ( >=> ) g f = f <=< g
  
  let ( let* ) mx f = bind mx f
  let ( let+ ) mx f= fmap f mx
  let ( and+ ) = product
end

module Basic_monad_of_minimal_monad_bind (M : Minimal_monad_bind) = struct
  include M
  module Derived_applicative_ =
    Applicative_of_minimal_applicative_fapply (
        struct
          include M
          let fapply mf mx = bind mf (fun f -> bind mx (fun x -> pure (f x)))
        end)
  
  include Derived_applicative_
  let join mmx = bind mmx (fun mx -> mx)
end

module Basic_monad_of_minimal_monad_join (M : Minimal_monad_join) = struct
  include M
  module Derived_applicative_ =
    Applicative_of_minimal_applicative_product(
        struct
          include M
          let product mx my = join (fmap (fun x -> (fmap (fun y -> (x, y)) my)) mx)
        end
      )
  include Derived_applicative_
  let bind mx f = join (fmap f mx)
end

module Monad_of_minimal_monad_bind (M : Minimal_monad_bind) = struct
  include M
  module Derived_monad_ = Monad_of_basic_monad (Basic_monad_of_minimal_monad_bind (M))
  include Derived_monad_
end

module Monad_of_minimal_monad_join (M : Minimal_monad_join) = struct
  include M
  module Derived_monad_ = Monad_of_basic_monad (Basic_monad_of_minimal_monad_join (M))
  include Derived_monad_
end

module Trivial_of_minimal_trivial (M : Minimal_trivial) = struct
  include M
  module Derived_monad__ =
    Monad_of_minimal_monad_join (
        struct
          include M
          let fmap f mx = wrap (f (unwrap mx))
          let pure x = wrap x
          let join mmx = unwrap mmx
        end)
  include Derived_monad__
  let extract = unwrap
  let duplicate  = wrap
  let extend f wx = wrap (f wx)
end