open Composite

let sqr x = x*x
let twc x = x+x
let add1 x = x+1

let test_function_composition =
  let open Function in
  (fun () ->
    Alcotest.(check int) "right-to-left" (compose sqr twc 3) 36;
    Alcotest.(check int) "right-to-left operator lifted"  (((arr sqr) <<< (arr twc)) 3) 36;
    Alcotest.(check int) "left-to-right operator lifted" (((arr twc) >>> (arr sqr)) 3) 36;
    Alcotest.(check int) "right-to-left operator" ((sqr <<< twc) 3) 36;
    Alcotest.(check int) "left-to-right operator" ((twc >>> sqr) 3) 36;
    Alcotest.(check int) "left-to-right associative" (((sqr <<< twc) <<< add1) 3) ((sqr <<< (twc <<< add1)) 3);
    Alcotest.(check int) "right-to-left associative" (((sqr >>> twc) >>> add1) 3) ((sqr >>> (twc >>> add1)) 3);
    ())

let test_function_identity =  
  let open Function in
  (fun () ->
    Alcotest.(check int) "right-to-left left identity" ((add1 << id) 3) (add1 3);
    Alcotest.(check int) "right-to-left right identity" ((id << add1) 3) (add1 3);
    Alcotest.(check int) "left--right left identity" ((add1 >> id) 3) (add1 3);
    Alcotest.(check int) "left-to-right right identity" ((id >> add1) 3) (add1 3);
  ())
  
let test_function_arr =
  let open Function in
  (fun () ->
    Alcotest.(check int) "arr" ((arr sqr) 3) (sqr 3);
    ())

let test_function_first =
  let open Function in
  (fun () ->
    Alcotest.(check (pair int string)) "first" (4, "a new care") ((first (arr add1)) (3, "a new care"));
    ())

let test_function_second =
  let open Function in
  (fun () ->
    Alcotest.(check (pair string int)) "second" ("a new care", 4) ((second (arr add1)) ("a new care", 3));
    ())

let test_function_split =
  let open Function in
  (fun () ->
    Alcotest.(check (pair int string))
      "split"
      (4, "a new car")
      ((split (arr add1) (arr (String.cat "a new "))) (3, "car"));
    Alcotest.(check (pair int string))
      "split without liftinga"
      (4, "a new car")
      ((split add1 (String.cat "a new ")) (3, "car"));
    Alcotest.(check (pair int string))
      "split with infix"
      (4, "a new car")
      ((add1 *** (String.cat "a new ")) (3, "car"));
    ())

let test_function_fanout =
  let open Function in
  (fun () ->
    Alcotest.(check (pair int string))
      "fanout"
      (4, "3")
      ((fanout (arr add1) (arr Int.to_string)) 3);
    Alcotest.(check (pair int string))
      "fanout without lifting"
      ((fanout (arr add1) (arr Int.to_string)) 3)
      ((fanout add1 Int.to_string) 3);
    Alcotest.(check (pair int string))
      "fanout with infix"
      ((fanout (arr add1) (arr Int.to_string)) 3)
      ((add1 &&& Int.to_string) 3);    
    ())

let test_composition = [
    ("function composition", `Quick, test_function_composition)
  ]

let test_identity = [
    ("function identity", `Quick, test_function_identity)
  ]

let test_arr = [
    ("function arr", `Quick, test_function_arr)
  ]

let test_first = [
    ("function first", `Quick, test_function_first)
  ]

let test_second = [
    ("function second", `Quick, test_function_second)
  ]

let test_split = [
     ("function split", `Quick, test_function_split)
  ]

let test_fanout = [
     ("function fanout", `Quick, test_function_fanout)
  ]

let () =
  Alcotest.run "Arrow Test" [
      "arrow composition", test_composition;
      "arrow identity", test_identity;
      "arrow arr", test_arr;
      "arrow first", test_first;
      "arrow second", test_second;
      "arrow split", test_split;
      "arrow fanout", test_fanout
    ]


