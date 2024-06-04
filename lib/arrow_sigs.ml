(** A signature for a module with the complete specification of the methods required
    for the arrow protocol. *)
module type Basic_arrow = sig
  include Category_sigs.Category

  val arr : ('a -> 'b) -> ('a, 'b) t
  val first : ('a, 'b) t -> ('a * 'c, 'b * 'c) t
  val second : ('c, 'd) t -> ('a * 'c, 'a * 'd) t
  val split : ('a, 'b) t -> ('c, 'd) t -> ('a * 'c, 'b * 'd) t
  val fanout : ('a, 'b) t -> ('a, 'd) t -> ('a, 'b * 'd) t
end

(** Signature for a minimal arrow requiring derivation of the
    remaining `Basic_arrow` methods from the `first` method. *)
module type Minimal_arrow_first = sig
  include Category_sigs.Category

  val arr : ('a -> 'b) -> ('a, 'b) t
  val first : ('a, 'b) t -> ('a * 'c, 'b * 'c) t
end

(** The signature of a module with  minimal definitions for
    deriving the remaining arrow operators from [split] using
    [Arrow_of_minimal_arrow_split_with_basic_category]. *)
module type Minimal_arrow_split_with_basic_category = sig
  include Category_sigs.Basic_category

  val arr : ('a -> 'b) -> ('a, 'b) t
  val split : ('a, 'b) t -> ('c, 'd) t -> ('a * 'c, 'b * 'd) t
end

(** The signature of a module with  minimal definitions for
    deriving the remaining arrow operators from [first] with
    [Arrow_of_minimal_arrow_first_with_basic_category]. *)
module type Minimal_arrow_first_with_basic_category = sig
  include Category_sigs.Basic_category

  val arr : ('a -> 'b) -> ('a, 'b) t
  val first : ('a, 'b) t -> ('a * 'c, 'b * 'c) t
end

(** Signature for a minimal arrow requiring derivation of the
    remaining `Basic_arrow` methods from the `split` method. *)
module type Minimal_arrow_split = sig
  include Category_sigs.Category

  val arr : ('a -> 'b) -> ('a, 'b) t
  val split : ('a, 'b) t -> ('c, 'd) t -> ('a * 'c, 'b * 'd) t
end

(** A signature for a complete arrow module *)
module type Arrow = sig
  include Basic_arrow

  val ( <<< ) : ('b, 'c) t -> ('a, 'b) t -> ('a, 'c) t
  val ( >>> ) : ('a, 'b) t -> ('b, 'c) t -> ('a, 'c) t
  val ( *** ) : ('a, 'b) t -> ('c, 'd) t -> ('a * 'c, 'b * 'd) t
  val ( &&& ) : ('a, 'b) t -> ('a, 'd) t -> ('a, 'b * 'd) t
end
