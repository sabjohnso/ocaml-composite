open Arrow_choice_sigs

module Basic_arrow_choice_of_minimal_arrow_choice_choose (M : Minimal_arrow_choice_choose)
       : Basic_arrow_choice = struct
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
         (M : Minimal_arrow_choice_choose_left)
       : Basic_arrow_choice = struct
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

module Arrow_choice_of_basic_arrow_choice (M : Basic_arrow_choice) : Arrow_choice = struct
  include M
  let ( +++ ) = choose
  let ( ||| ) = fanin
end



