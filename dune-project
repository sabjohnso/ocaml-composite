(lang dune 3.12)

(name composite)

(generate_opam_files true)

(source
 (github sabjohnson/ocaml-composite))

(authors "Samuel B. Johnson")

(maintainers "Samuel B. Johnson")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name composite)
 (synopsis "An assortment of facilities for various forms of composition")
 (description "An assortment of facilities for various forms of composition ...")
 (depends ocaml dune re (alcotest :with-test))
 (tags (topics "composition" "arrow" "kleisli" "cokleisli" "monad" "applicative" "functor")))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
