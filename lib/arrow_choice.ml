open Arrow_choice_sigs

module Basic_arrow_choice_of_minimal_arrow_choice_choose (M : Minimal_arrow_choice_choose) = struct
  include M
  let choose_left f = choose f id
  let choose_right g = choose id g
  let fanin f g =
    choose f g >>>
      arr (function
          | Either.Left x -> x
          | Either.Right y -> y)
end

module Basic_arrow_choice_of_minimal_arrow_choice_choose_left
         (M : Minimal_arrow_choice_choose_left) = struct
  include M
  let choose_right g =
    arr (function | Either.Left x -> Either.Right x
                  | Either.Right y -> Either.Left y)
    >>> choose_left g
    >>> arr (function | Either.Left x -> Either.Right x
                      | Either.Right y -> Either.Left y)

  let choose f g = choose_left f >>> choose_right g

  let fanin f g =
    choose f g >>>
      arr (function
          | Either.Left x -> x
          | Either.Right y -> y)
end

module Arrow_choice_of_basic_arrow_choice (M : Basic_arrow_choice) = struct
  include M
  let ( +++ ) = choose
  let ( ||| ) = fanin
end

module Arrow_choice_of_minimal_arrow_choice_choose (M : Minimal_arrow_choice_choose) = struct
  module Derived_arrow_choice =
    Arrow_choice_of_basic_arrow_choice (
        struct
          module Temp = Basic_arrow_choice_of_minimal_arrow_choice_choose (M)
          include Temp
          include M
      end)
  include Derived_arrow_choice
end
           



module Arrow_choice_of_minimal_arrow_choice_choose_split (M : Minimal_arrow_choice_choose_split) =
  struct
    module Derived_arrow_choice_ =
      Arrow_choice_of_minimal_arrow_choice_choose (
        struct
          module Temp = Arrow.Arrow_of_minimal_arrow_split_with_basic_category (M)
          include Temp
          include M
        end)
    include Derived_arrow_choice_
  end


        
module Arrow_choice_of_minimal_arrow_choice_choose_first (M : Minimal_arrow_choice_choose_first) =
  struct
    module Derived_arrow_choice_ =
      Arrow_choice_of_minimal_arrow_choice_choose (
        struct
          module Temp = Arrow.Arrow_of_minimal_arrow_first_with_basic_category (M)
          include Temp
          include M
        end)
    include Derived_arrow_choice_
  end
