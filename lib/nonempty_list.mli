(* This file is part of the composite library *)
(** {1 Nonempty lists}

    Nonempty_list adds a type for lists that are never empty.*)

type 'a nonempty_list = 'a * 'a list
(** A nonempty list *)

type 'a t = 'a nonempty_list
(** An alias for [nonempty_list] *)

val of_list : 'a list -> 'a nonempty_list
(** Return a {!nonempty_list} with the elements of the input [list]. It
    is an error to call this function with an empty list. *)

val of_seq : 'a Seq.t -> 'a nonempty_list
(** Return a {!nonempty_list} with the elements of the input sequence.
    It is an error to call this function with an empty sequence. *)

val hd : 'a nonempty_list -> 'a
(** Return the first element of the nonempty list.*)

val tl : 'a nonempty_list -> 'a nonempty_list
(** Return the reset of the elements of a [nonempty_lit] *)

val cons : 'a -> 'a nonempty_list -> 'a nonempty_list
(** Return a [nonempty_list] equivalent to the second argument
    with the first argument pushed onto the front of it.*)

val append : 'a nonempty_list -> 'a nonempty_list -> 'a nonempty_list
(** Return a [nonempty_list] equivalent to the second argument
    appended to the first argument *)

val rev_append : 'a * 'a list -> 'a * 'a list -> 'a * 'a list
(** Append the second argument to the reverse of the first argument *)

val rev : 'a * 'a list -> 'a * 'a list
(** Return the reverse of the input list *)

val length : 'a * 'b list -> int
(** Return the number of elements in the input list *)

(** {3 Functor operators} *)

val fmap : ('a -> 'b) -> 'a t -> 'b t
(** Functorial mapping. *)

val ( <$> ) : ('a -> 'b) -> 'a nonempty_list -> 'b nonempty_list
(** Infix functorial mapping operator. *)

(** {3 Applicative functor operators} *)

val pure : 'a -> 'a nonempty_list
(** Return a list with the input as its only element. [pure] is the
    unit constructor for [nonempty_list]. *)

val product : 'a nonempty_list -> 'b nonempty_list -> ('a * 'b) nonempty_list
(** Applicative product. *)

val fapply : ('a -> 'b) nonempty_list -> 'a nonempty_list -> 'b nonempty_list
(** Applicative mapping *)

val ( <*> ) : ('a -> 'b) nonempty_list -> 'a nonempty_list -> 'b nonempty_list
(** Infix applicative mapping operator *)

(** {3 Monad operators} *)

val return : 'a -> 'a nonempty_list
(** Return a list with the input as its only element. [return] is an
    alias for [pure] *)

val bind : 'a nonempty_list -> ('a -> 'b nonempty_list) -> 'b nonempty_list
(** Monadic binding function. *)

val ( >>= ) : 'a nonempty_list -> ('a -> 'b nonempty_list) -> 'b nonempty_list
(** Infix monad binding operator. *)

val flatmap : ('a -> 'b nonempty_list) -> 'a nonempty_list -> 'b nonempty_list
(** Monadic mapping function. *)

val ( =<< ) : ('a -> 'b nonempty_list) -> 'a nonempty_list -> 'b nonempty_list
(** Infix flatmap operator. *)

val join : 'a nonempty_list nonempty_list -> 'a nonempty_list
(** Concatenate the elements of the [nonempty_list]. *)

val ( >=> ) :
  ('a -> 'b nonempty_list) -> ('b -> 'c nonempty_list) -> 'a -> 'c nonempty_list
(** Left-to-right composition of monad constructors. *)

val ( <=< ) :
  ('b -> 'c nonempty_list) -> ('a -> 'b nonempty_list) -> 'a -> 'c nonempty_list
(** Right-to-left composition of monad constructors *)

(** {3 Comonad operators} *)

val extract : 'a t -> 'a
(** The unit comonad destructor. *)

val extend : ('a t -> 'b) -> 'a t -> 'b t
(** Extend the comonad destructor over the input list *)

val duplicate : 'a t -> 'a t t
(** Duplicate the comonad context *)

val wcompose : ('b t -> 'c) -> ('a t -> 'b) -> 'a t -> 'c
(** Right-to-left composition of comonad destructors. *)

val ( =<= ) : ('b t -> 'c) -> ('a t -> 'b) -> 'a t -> 'c
(** Right-to-left composition of comonad destructors. *)

val ( =>= ) : ('a t -> 'b) -> ('b t -> 'c) -> 'a t -> 'c
(** Left-to-right composition of comonad destructors. *)

(** {3 Binding syntax} *)

val ( let* ) : 'a nonempty_list -> ('a -> 'b nonempty_list) -> 'b nonempty_list
val ( let+ ) : 'a nonempty_list -> ('a -> 'b) -> 'b nonempty_list
val ( and+ ) : 'a nonempty_list -> 'b nonempty_list -> ('a * 'b) nonempty_list
