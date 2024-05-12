module Function_basic_category = struct
  type ('a, 'b) t = 'a -> 'b
  let id x = x
  let compose f g x = f (g x)
end

module Function_category : Category_sigs.Category with type ('a, 'b) t = 'a -> 'b =
  Category.Category_of_basic_category (Function_basic_category)

module Function_minimal_arrow_split = struct
  include Function_category
  let arr f = f
  let split f g (x, y) = (f x, g y)
end

module Function_basic_arrow : Arrow_sigs.Basic_arrow with type ('a, 'b) t = 'a -> 'b =
  Arrow.Basic_arrow_of_minimal_arrow_split (Function_minimal_arrow_split)

module Function_arrow : Arrow_sigs.Arrow with type ('a, 'b) t = 'a -> 'b =
  Arrow.Arrow_of_basic_arrow (Function_basic_arrow)

include Function_arrow

module Function_minimal_arrow_choice_choose = struct
  include Function_arrow
  let choose f g = fun mx -> 
    let open Either in
    match mx with
    | Left x -> Left (f x)
    | Right y -> Right (g y)
end

module Function_basic_arrow_choice
       : Arrow_choice_sigs.Basic_arrow_choice with type ('a, 'b) t = 'a -> 'b =
  Arrow_choice.Basic_arrow_choice_of_minimal_arrow_choice_choose (
      Function_minimal_arrow_choice_choose
    )

module Function_arrow_choice : Arrow_choice_sigs.Arrow_choice with type ('a, 'b) t = 'a -> 'b =
  Arrow_choice.Arrow_choice_of_basic_arrow_choice (Function_basic_arrow_choice)

include Function_arrow_choice
