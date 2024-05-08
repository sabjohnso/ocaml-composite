open Category_sigs

(** A module deriving the category infix operators float a `Basic_category`
    module to produce a `Category` module. *)
module Category_of_basic_category(M : Basic_category) : Category = struct
  include M
  let ( << ) = compose
  let ( >> ) g f = compose f g
end
