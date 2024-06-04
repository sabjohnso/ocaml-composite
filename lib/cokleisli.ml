module Make (M : Functor_sigs.Comonad) = struct
  module Derived_arrow_choice__ =
  Arrow_choice.Arrow_choice_of_minimal_arrow_choice_choose_split (struct
    include M

    type ('a, 'b) t = 'a M.t -> 'b

    let id x = extract x
    let compose f g = f =<= g
    let arr f wx = f (extract wx)

    let split f g wxy =
      (f (fmap (fun (x, _) -> x) wxy), g (fmap (fun (_, y) -> y) wxy))

    let choose f g wmx =
      let open Either in
      extract
        (fmap
           (function
             | Left x -> Left (f (extend (fun _ -> x) wmx))
             | Right y -> Right (g (extend (fun _ -> y) wmx)))
           wmx)
  end)

  include Derived_arrow_choice__
end
