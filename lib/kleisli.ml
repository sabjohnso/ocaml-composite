
module Kleisli (M : Functor_sigs.Monad) = struct
  module Kleisli_arrow_choice  =
    Arrow_choice.Arrow_choice_of_minimal_arrow_choice_choose_split(
        struct
          include M
          type ('a, 'b) t = 'a -> 'b M.t
          let id x = return x
          let compose f g = f <=< g
          let arr f x = return (f x)
          let split f g (x, y) =
            product (f x) (g y)

          let choose f g = fun mx -> 
            let open Either in
            match mx with
            | Left x -> left <$> (f x)
            | Right y -> right <$> (g y)
        end)
  include Kleisli_arrow_choice
end
