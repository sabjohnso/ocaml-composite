open Composite

(* let sqr x = x*x *)
(* let twc x = x+x *)
let add1 x = x+1

let test_function_fanin =
  let open Either in
  let open Function in
  (fun () ->
    Alcotest.(check string)
      "function fanin"
      "3"
      ((fanin Int.to_string (String.cat "abc")) (Left 3));
    Alcotest.(check string)
      "function fanin with infix"
      "3"
      ((Int.to_string ||| (String.cat "abc")) (Left 3));
    Alcotest.(check string)
      "function fanin from right"
      "abcdef"
      ((fanin Int.to_string (String.cat "abc")) (Right "def"));
    Alcotest.(check string)
      "function fanin with infix from right"
      "abcdef"
      ((Int.to_string ||| (String.cat "abc")) (Right "def"));
    ())

let test_function_choose =
  let open Either in
  let open Function in
  (fun () ->
    Alcotest.(check string)
      "function choose"
      "4"
      (((choose add1 (String.cat "abc")) >>> (Int.to_string ||| id))
         (Left 3));
    Alcotest.(check string)
      "function choose"
      "4"
      (((add1 +++ (String.cat "abc")) >>> (Int.to_string ||| id)) (Left 3));
    ())

let test_function_choose_left =
  let open Either in
  let open Function in
  (fun () ->
    Alcotest.(check string)
      "function choose left"
      "4"
      (((choose_left add1) >>> (Int.to_string ||| id))
         (Left 3));
     Alcotest.(check string)
      "function choose left of right"
      "abc"
      (((choose_left add1) >>> (Int.to_string ||| id))
         (Right "abc"));   
     ())

let test_function_choose_right =
  let open Either in
  let open Function in
  (fun () ->
    Alcotest.(check string)
      "function choose right"
      "4"
      (((choose_right add1) >>> (id ||| Int.to_string))
         (Right 3));
     Alcotest.(check string)
      "function choose right of left"
      "abc"
      (((choose_right add1) >>> (id ||| Int.to_string))
         (Left "abc"));   
  ())





let test_choose = [
    "function choose", `Quick, test_function_choose
  ]
let test_choose_left = [
    "function choose left", `Quick, test_function_choose_left
  ]
let test_choose_right = [
    "function choose right", `Quick, test_function_choose_right
  ]
let test_fanin = [
    "function fanin", `Quick, test_function_fanin
  ]

let () =
  Alcotest.run "Arrow Test" [
      "arrow choice choose", test_choose;
      "arrow choice choose left", test_choose_left;
      "arrow choice choose right", test_choose_right;
      "arrow choice fanin", test_fanin;
    ]
