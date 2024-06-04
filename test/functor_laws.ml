open Composite

(** Test the functor identity and composition laws for a module
    implementing a functor:

    Identity:  fmap id = id
    Composition: fmap (f << g) = fmap f << fmap g *)
module Make (M : Functor_sigs.Functor) = struct
  include M

  let ( << ) f g x = f (g x)
  let id x = x

  let check_identity mx =
    Alcotest.(check bool) "Functor identity law" true (fmap id mx = mx)

  let check_composition f g mx =
    Alcotest.(check bool)
      "Functor composition law" true
      (fmap (f << g) mx = fmap f @@ fmap g mx)
end
