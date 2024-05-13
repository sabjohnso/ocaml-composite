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
