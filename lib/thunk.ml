type 'a thunk = unit -> 'a

module Derived_trivial_ = Functor.Trivial_of_minimal_trivial (struct
  type 'a t = 'a thunk

  let wrap x () = x
  let unwrap mx = mx ()
end)

include Derived_trivial_
