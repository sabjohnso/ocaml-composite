(* This file is part of the composite library *)
(**
   {1 Nonempty lists}

   Nonempty_list adds a type for lists that are never empty.*)


type 'a nonempty_list = 'a * 'a list
(** A nonempty list *)

(** An alias for [nonempty_list] *)
type 'a t = 'a nonempty_list

(** Return a {!nonempty_list} with the elements of the input [list]. It
    is an error to call this function with an empty list. *)
val of_list : 'a list -> 'a nonempty_list

(** Return a {!nonempty_list} with the elements of the input sequence.
    It is an error to call this function with an empty sequence. *)
val of_seq : 'a Seq.t -> 'a nonempty_list

(** Return the first element of the nonempty list.*)
val hd : 'a nonempty_list -> 'a

(** Return the reset of the elements of a [nonempty_lit] *)
val tl : 'a nonempty_list -> 'a nonempty_list

(** Return a [nonempty_list] equivalent to the second argument
    with the first argument pushed onto the front of it.*)
val cons : 'a -> 'a nonempty_list -> 'a nonempty_list

(** Return a [nonempty_list] equivalent to the second argument
    appended to the first argument *)
val append : 'a nonempty_list -> 'a nonempty_list -> 'a nonempty_list

(** Append the second argument to the reverse of the first argument *)
val rev_append : 'a * 'a list -> 'a * 'a list -> 'a * 'a list

(** Return the reverse of the input list *)
val rev : 'a * 'a list -> 'a * 'a list

(** Return the number of elements in the input list *)
val length : 'a * 'b list -> int

(** {3 Functor operators} *)

(** Functorial mapping. *)
val fmap : ('a -> 'b) -> 'a t -> 'b t

(** Infix functorial mapping operator. *)
val ( <$> ) : ('a -> 'b) -> 'a nonempty_list -> 'b nonempty_list

(** {3 Applicative functor operators} *)

(** Return a list with the input as its only element. [pure] is the
    unit constructor for [nonempty_list]. *)
val pure : 'a -> 'a nonempty_list

(** Applicative product. *)
val product :
  'a nonempty_list -> 'b nonempty_list -> ('a * 'b) nonempty_list

(** Applicative mapping *)
val fapply :
  ('a -> 'b) nonempty_list -> 'a nonempty_list -> 'b nonempty_list

(** Infix applicative mapping operator *)
val ( <*> ) :
  ('a -> 'b) nonempty_list -> 'a nonempty_list -> 'b nonempty_list

(** {3 Monad operators} *)

(** Return a list with the input as its only element. [return] is an
    alias for [pure] *)
val return : 'a -> 'a nonempty_list

(** Monadic binding function. *)
val bind :
  'a nonempty_list -> ('a -> 'b nonempty_list) -> 'b nonempty_list

(** Infix monad binding operator. *)
val ( >>= ) :
  'a nonempty_list -> ('a -> 'b nonempty_list) -> 'b nonempty_list

(** Monadic mapping function. *)
val flatmap :
  ('a -> 'b nonempty_list) -> 'a nonempty_list -> 'b nonempty_list

(** Infix flatmap operator. *)
val ( =<< ) :
  ('a -> 'b nonempty_list) -> 'a nonempty_list -> 'b nonempty_list

(** Concatenate the elements of the [nonempty_list]. *)
val join : 'a nonempty_list nonempty_list -> 'a nonempty_list

(** Left-to-right composition of monad constructors. *)
val ( >=> ) :
  ('a -> 'b nonempty_list) ->
  ('b -> 'c nonempty_list) -> 'a -> 'c nonempty_list

(** Right-to-left composition of monad constructors *)
val ( <=< ) :
  ('b -> 'c nonempty_list) ->
  ('a -> 'b nonempty_list) ->
  'a -> 'c nonempty_list


(** {3 Comonad operators} *)

(** The unit comonad destructor. *)
val extract : 'a t -> 'a

(** Extend the comonad destructor over the input list *)
val extend : ('a t -> 'b) -> 'a t -> 'b t

(** Duplicate the comonad context *)
val duplicate : 'a t -> 'a t t

(** Right-to-left composition of comonad destructors. *)
val wcompose : ('b t -> 'c) -> ('a t -> 'b) -> 'a t -> 'c

(** Right-to-left composition of comonad destructors. *)
val ( =<= ) : ('b t -> 'c) -> ('a t -> 'b) -> 'a t -> 'c

(** Left-to-right composition of comonad destructors. *)
val ( =>= ) : ('a t -> 'b) -> ('b t -> 'c) -> 'a t -> 'c


(** {3 Binding syntax} *)

val ( let* ) :
  'a nonempty_list -> ('a -> 'b nonempty_list) -> 'b nonempty_list

val ( let+ ) : 'a nonempty_list -> ('a -> 'b) -> 'b nonempty_list

val ( and+ ) :
  'a nonempty_list -> 'b nonempty_list -> ('a * 'b) nonempty_list
