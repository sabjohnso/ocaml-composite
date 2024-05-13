open Composite
open Alcotest

type 'a identity = Identity of 'a
let identity_testable (type a) (base_testable : a testable) : a identity testable =
  let module M = struct
      type t = a identity
      let pp fmt (Identity x) = pp base_testable fmt x
      let equal (Identity x) (Identity y) = equal base_testable x y
    end in
  (module M :  TESTABLE with type t = M.t)


let test_functor_derivation =
  (fun () ->
    let module M  =
      Functor.Functor_of_basic_functor (
          struct
            type 'a t = 'a identity
            let fmap f (Identity x) = Identity (f x)
          end) in
    let open M in
    Alcotest.(check (identity_testable int))
      "infix map operator <$>"
      (Identity 9)
      ((fun x -> x * x) <$> Identity 3);
    ())

let test_applicative_derivation_fapply =
  (fun () ->
    let module M =
      Functor.Applicative_of_minimal_applicative_fapply (
          struct
            type 'a t = 'a identity
            let pure x = Identity x
            let fapply mf mx = match (mf, mx) with
              | Identity f, Identity x -> Identity (f x)
          end) in
    let open M in
    Alcotest.(check (identity_testable int))
      "pure"
      (Identity 3)
      (pure 3);
    Alcotest.(check (identity_testable (pair int string)))
      "product"
      (Identity (3, "purple"))
      (product (Identity 3) (Identity "purple"));

    Alcotest.(check (identity_testable int))
      "fapply"
      (Identity 7)
      (fapply (fmap (+) (Identity 3)) (Identity 4));

    Alcotest.(check (identity_testable int))
      "<*> (infix fapply)"
      (Identity 7)
      ((pure (+)) <*> Identity 3 <*> Identity 4);
    ())

let test_applicative_derivation_product =
  (fun () ->
    let module M =
      Functor.Applicative_of_minimal_applicative_product (
          struct
            type 'a t = 'a identity
            let fmap f (Identity x) = Identity (f x)
            let pure x = Identity x
            let product (Identity x) (Identity y) = Identity (x, y)
          end) in
    let open M in
    Alcotest.(check (identity_testable int))
      "pure"
      (Identity 3)
      (pure 3);
    Alcotest.(check (identity_testable (pair int string)))
      "product"
      (Identity (3, "purple"))
      (product (Identity 3) (Identity "purple"));

    Alcotest.(check (identity_testable int))
      "fapply"
      (Identity 7)
      (fapply (fmap (+) (Identity 3)) (Identity 4));

    Alcotest.(check (identity_testable int))
      "<*> (infix fapply)"
      (Identity 7)
      ((pure (+)) <*> Identity 3 <*> Identity 4);
    ())


let test_monad_derivation_from_bind =
  (fun () ->
    let module M =
      Functor.Monad_of_minimal_monad_bind (
          struct
            type 'a t = 'a identity
            let pure x = Identity x
            let bind (Identity x) f = f x
          end) in
    let open M in
    Alcotest.(check (identity_testable string))
      "fmap"
      (Identity "3")
      (fmap Int.to_string (Identity 3));
    Alcotest.(check (identity_testable string))
      "<$> (infix fmap)"
      (Identity "3")
      (Int.to_string <$> (Identity 3));
    Alcotest.(check (identity_testable int))
      "pure"
      (Identity 3)
      (pure 3);
    Alcotest.(check (identity_testable (pair int string)))
      "product"
      (Identity (3, "spoon"))
      (product (Identity 3) (Identity "spoon"));
    Alcotest.(check (identity_testable int))
      "fapply"
      (Identity 7)
      (fapply ((+) <$> (Identity 3)) (Identity 4));
    Alcotest.(check (identity_testable int))
      "<*> (infix fapply)"
      (Identity 7)
      ((pure (+)) <*> (Identity 3) <*> (Identity 4));
    Alcotest.(check (identity_testable int))
      "<*> (infix fapply)"
      (Identity 7)
      ((pure (+)) <*> (Identity 3) <*> (Identity 4));
     Alcotest.(check (identity_testable int))
      "return"
      (Identity 3)
      (return 3);
     Alcotest.(check (identity_testable int))
      "bind"
      (Identity 7)
      (bind (Identity 3) (fun x ->
           (bind (Identity 4) (fun y ->
                return (x + y)))));
     Alcotest.(check (identity_testable int))
      "flatmap"
      (Identity 7)
      (flatmap  (fun x -> (flatmap  (fun y -> return (x + y)) (Identity 4))) (Identity 3));
     Alcotest.(check (identity_testable int))
      ">>= (infix bind)"
      (Identity 7)
      (Identity 3 >>= (fun x ->
         Identity 4 >>= (fun y -> return (x + y))));
     Alcotest.(check (identity_testable int))
      ">>= (infix flatmap)"
      (Identity 7)
      ((fun x -> ((fun y -> return (x + y)) =<< Identity 4)) =<< Identity 3);
     Alcotest.(check (identity_testable int))
      "join"
      (Identity 3)
      (join (Identity (Identity 3)));
     Alcotest.(check (identity_testable int))
       "applicative binding"
       (Identity 7)
       (let+ x = (Identity 3)
        and+ y = (Identity 4) in
        x + y);
     Alcotest.(check (identity_testable int))
       "monadic binding"
       (Identity 7)
       (let* x = (Identity 3) in
        let* y = (Identity 4) in
        return (x + y));
     ())

let test_monad_derivation_from_join =
  (fun () ->
    let module M =
      Functor.Monad_of_minimal_monad_join (
          struct
            type 'a t = 'a identity
            let fmap f (Identity x) =  Identity (f x)
            let pure x = Identity x
            let join (Identity (Identity x)) = Identity x
          end) in
    let open M in
    Alcotest.(check (identity_testable string))
      "fmap"
      (Identity "3")
      (fmap Int.to_string (Identity 3));
    Alcotest.(check (identity_testable string))
      "<$> (infix fmap)"
      (Identity "3")
      (Int.to_string <$> (Identity 3));
    Alcotest.(check (identity_testable int))
      "pure"
      (Identity 3)
      (pure 3);
    Alcotest.(check (identity_testable (pair int string)))
      "product"
      (Identity (3, "spoon"))
      (product (Identity 3) (Identity "spoon"));
    Alcotest.(check (identity_testable int))
      "fapply"
      (Identity 7)
      (fapply ((+) <$> (Identity 3)) (Identity 4));
    Alcotest.(check (identity_testable int))
      "<*> (infix fapply)"
      (Identity 7)
      ((pure (+)) <*> (Identity 3) <*> (Identity 4));
    Alcotest.(check (identity_testable int))
      "<*> (infix fapply)"
      (Identity 7)
      ((pure (+)) <*> (Identity 3) <*> (Identity 4));
    Alcotest.(check (identity_testable int))
      "return"
      (Identity 3)
      (return 3);
    Alcotest.(check (identity_testable int))
      "bind"
      (Identity 7)
      (bind (Identity 3) (fun x ->
           (bind (Identity 4) (fun y ->
                return (x + y)))));
    Alcotest.(check (identity_testable int))
      "flatmap"
      (Identity 7)
      (flatmap  (fun x -> (flatmap  (fun y -> return (x + y)) (Identity 4))) (Identity 3));
    Alcotest.(check (identity_testable int))
      ">>= (infix bind)"
      (Identity 7)
      (Identity 3 >>= (fun x ->
         Identity 4 >>= (fun y -> return (x + y))));
    Alcotest.(check (identity_testable int))
      ">>= (infix flatmap)"
      (Identity 7)
      ((fun x -> ((fun y -> return (x + y)) =<< Identity 4)) =<< Identity 3);
    Alcotest.(check (identity_testable int))
      "join"
      (Identity 3)
      (join (Identity (Identity 3)));
    Alcotest.(check (identity_testable int))
      "applicative binding"
      (Identity 7)
      (let+ x = (Identity 3)
       and+ y = (Identity 4) in
       x + y);
    Alcotest.(check (identity_testable int))
      "monadic binding"
      (Identity 7)
      (let* x = (Identity 3) in
       let* y = (Identity 4) in
       return (x + y));
    ())

let test_comonad_derivation_from_extend =
  (fun () -> ())

let test_comonad_derivation_from_duplicate =
  (fun () -> ())

let test_trivial_derivation =
  (fun () ->
    let module M =
      Functor.Trivial_of_minimal_trivial (
          struct
            type 'a t = 'a identity
            let wrap x = Identity x
            let unwrap (Identity x) = x
          end) in
    let open M in

    Alcotest.(check (identity_testable int))
      "fmap"
      (Identity 9)
      (fmap (fun x -> x*x) (Identity 3));

    Alcotest.(check (identity_testable int))
      "<$> (infix fmap)"
      (Identity 9)
      ((fun x -> x*x) <$> (Identity 3));

    Alcotest.(check (identity_testable int))
      "pure"
      (Identity 3)
      (pure 3);

    Alcotest.(check int)
      "extract"
      3
      (extract (Identity 3));

    Alcotest.(check (identity_testable int))
      "extend"
      (Identity 9)
      (extend (fun wx -> extract wx * extract wx) (Identity 3));

    Alcotest.(check (identity_testable (identity_testable int)))
      "duplicate"
      (Identity (Identity 3))
      (duplicate (Identity 3));

    Alcotest.(check (identity_testable int))
      "monadic binding"
      (Identity 7)
      (let* x = (Identity 3) in
       let* y = (Identity 4) in
       (return (x + y)));

    Alcotest.(check (identity_testable int))
      "applicative binding"
      (Identity 7)
      (let+ x = (Identity 3)
       and+ y = (Identity 4) in
       x + y);

    Alcotest.(check (identity_testable (identity_testable int)))
      "functorial mapping"
      (Identity (Identity 7))
      (let+ x = (Identity 3) in
       let+ y = (Identity 4) in
       x + y);
    ())


let test_functor = [
    ("functor derivation", `Quick, test_functor_derivation)
  ]

let test_applicative = [
    "applictive derivation from fapply", `Quick, test_applicative_derivation_fapply;
    "applictive derivation from product", `Quick, test_applicative_derivation_product
  ]

let test_monad = [
    "monad derivation from bind", `Quick, test_monad_derivation_from_bind;
    "monad derivation from join", `Quick, test_monad_derivation_from_join
  ]

let test_comonad = [
    "comonad derivation from extend", `Quick, test_comonad_derivation_from_extend;
    "comonad derivation from duplicate", `Quick, test_comonad_derivation_from_duplicate
  ]

let test_trivial = [
    "trivial derivation from bind", `Quick, test_trivial_derivation
  ]

let () =
  Alcotest.run "Category Test" [
      "functor", test_functor;
      "applicative", test_applicative;
      "monad", test_monad;
      "comonad", test_comonad;
      "trivial", test_trivial
    ]
