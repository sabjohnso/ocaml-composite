open Arrow_sigs


(** A module deriving the required arrow methods from a `Minimal_arrow_split`
    module to produce a `Basic_arrow` module. *)
module Basic_arrow_of_minimal_arrow_split (M : Minimal_arrow_split ) = struct
  include M
  let first  f   = split f id
  let second g   = split id g
  let fanout f g = arr (fun x -> (x, x)) >> split f g
end

(** A module deriving the required arrow methods from a `Minimal_arrow_first`
    module to produce a `Basic_arrow` module. *)
module Basic_arrow_of_minimal_arrow_first (M : Minimal_arrow_first ) = struct
  include M
  let second g   = arr (fun (x, y) -> (y, x)) >> first g >> arr (fun (x, y) -> (y, x))
  let split  f g = first f >> second g
  let fanout f g = arr (fun x -> (x, x)) >> split f g
end

(** A module deriving the arrow infix operators from a `Basic_arrow`
    module to produce a `Arrow` module. *)
module Arrow_of_basic_arrow (M : Basic_arrow)  = struct
  include M
  let ( <<< ) = ( << )
  let ( >>> ) = ( >> )
  let ( *** ) = split
  let ( &&& ) = fanout
end

module Arrow_of_minimal_arrow_split (M : Minimal_arrow_split) = struct
  module Derived_basic_arrow  = Basic_arrow_of_minimal_arrow_split (M)
  module Derived_arrow = Arrow_of_basic_arrow (Derived_basic_arrow)
  include Derived_arrow
end

module Arrow_of_minimal_arrow_first (M : Minimal_arrow_first) = struct
  module Derived_basic_arrow  = Basic_arrow_of_minimal_arrow_first (M)
  module Derived_arrow = Arrow_of_basic_arrow (Derived_basic_arrow)
  include Derived_arrow
end


module Arrow_of_minimal_arrow_split_with_basic_category (M : Minimal_arrow_split_with_basic_category)
  = struct
  module Derived_arrow__ =
    Arrow_of_minimal_arrow_split (
        struct
          module Temp = Category.Category_of_basic_category (M)
          include Temp
          include M
        end)
  include Derived_arrow__
  include M
end


module Arrow_of_minimal_arrow_first_with_basic_category (M : Minimal_arrow_first_with_basic_category)
  = struct
  module Derived_arrow_ =
    Arrow_of_minimal_arrow_first (
        struct
          module Temp = Category.Category_of_basic_category (M)
          include Temp
          include M
        end)

  include Derived_arrow_
end
