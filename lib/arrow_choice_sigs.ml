(** A signature for a complete specification of the methods required
    for the arrow choice protocol.
 *)
module type Basic_arrow_choice = sig
  include Arrow_sigs.Arrow
  val choose       : ('a, 'b) t -> ('c, 'd) t -> (('a, 'c) Either.t, ('b, 'd) Either.t) t
  val choose_left  : ('a, 'b) t -> (('a, 'c) Either.t, ('b, 'c) Either.t) t
  val choose_right : ('c, 'd) t -> (('a, 'c) Either.t, ('a, 'd) Either.t) t
  val fanin        : ('a, 'b) t -> ('c, 'b) t -> (('a, 'c) Either.t, 'b) t
end

(** Signature for a minimal arrow choice module requiring derivation of the
    remaining `Basic_arrow_choice` methods from the `choose` method
 *)
module type Minimal_arrow_choice_choose = sig
  include Arrow_sigs.Arrow
  val choose       : ('a, 'b) t -> ('c, 'd) t -> (('a, 'c) Either.t, ('b, 'd) Either.t) t
end

(** Signature for a minimal arrow choice module requiring derivation of the
    remaining `Basic_arrow_choice` methods from the `choose_left` method
 *)
module type Minimal_arrow_choice_choose_left = sig
  include Arrow_sigs.Arrow
  val choose_left  : ('a, 'b) t -> (('a, 'c) Either.t, ('b, 'c) Either.t) t
end

(** A signature for the complete arrow choice module *)
module type Arrow_choice = sig
  include Basic_arrow_choice
  val ( +++ ) : ('a, 'b) t -> ('c, 'd) t -> (('a, 'c) Either.t, ('b, 'd) Either.t) t
  val ( ||| ) : ('a, 'b) t -> ('c, 'b) t -> (('a, 'c) Either.t, 'b) t
end

module type Minimal_arrow_choice_choose_split = sig
  include Arrow_sigs.Minimal_arrow_split_with_basic_category
  val choose : ('a, 'b) t -> ('c, 'd) t -> (('a, 'c) Either.t, ('b, 'd) Either.t) t
end

module type Minimal_arrow_choice_choose_first = sig
  include Arrow_sigs.Minimal_arrow_first_with_basic_category
  val choose : ('a, 'b) t -> ('c, 'd) t -> (('a, 'c) Either.t, ('b, 'd) Either.t) t
end
