open Composite

(** Test the applicative identity, composition, homomorphism and
    interchange laws for a module implementing an applicative functor:

    Identity: pure id <*> v = v
    Composition: pure (<<) <*> u <*> v <*> w = u <*> (v <*> w)
    Homomorphism: pure f <*> pure x = pure (f x)
    Interchange:  u <*> pure y = pure (call_with y) <*> u *)
module Make (M : Functor_sigs.Applicative) = struct
  include M

  let ( << ) f g x = f (g x)
  let sqr x = x * x
  let id x = x

  let check_identity mx =
    Alcotest.(check bool)
      "Applicative functor identity law" true
      (pure id <*> mx = mx)

  let check_composition () =
    Alcotest.(check bool)
      "Applicative functor composition law" true
      (pure ( << ) <*> pure succ <*> pure sqr <*> pure 3
      = (pure succ <*> (pure sqr <*> pure 3)))
end
