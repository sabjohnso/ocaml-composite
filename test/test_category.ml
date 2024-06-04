open Composite

let test_function_composition () =
  let sqr x = x * x and twc x = x + x and add1 x = x + 1 in
  let open Function in
  Alcotest.(check int) "right-to-left" (compose sqr twc 3) 36;
  Alcotest.(check int) "right-to-left operator" ((sqr << twc) 3) 36;
  Alcotest.(check int) "left-to-right operator" ((twc >> sqr) 3) 36;
  Alcotest.(check int)
    "left-to-right associative"
    ((sqr << twc << add1) 3)
    ((sqr << (twc << add1)) 3);
  Alcotest.(check int)
    "right-to-left associative"
    ((sqr >> twc >> add1) 3)
    ((sqr >> (twc >> add1)) 3)

let test_function_identity () =
  let add1 x = x + 1 in
  let open Function in
  Alcotest.(check int) "right-to-left left identity" ((add1 << id) 3) (add1 3);
  Alcotest.(check int) "right-to-left right identity" ((id << add1) 3) (add1 3);
  Alcotest.(check int) "left--right left identity" ((add1 >> id) 3) (add1 3);
  Alcotest.(check int) "left-to-right right identity" ((id >> add1) 3) (add1 3)

let test_composition =
  [ ("function composition", `Quick, test_function_composition) ]

let test_identity = [ ("function identity", `Quick, test_function_identity) ]

let () =
  Alcotest.run "Category Test"
    [ ("composition", test_composition); ("identity", test_identity) ]
