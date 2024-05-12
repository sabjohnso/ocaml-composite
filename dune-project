(lang dune 3.12)

(name composite)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Author Name")

(maintainers "Maintainer Name")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name composite)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends ocaml dune re (alcotest :with-test))
 (tags (topics "composition" "arrow")))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
