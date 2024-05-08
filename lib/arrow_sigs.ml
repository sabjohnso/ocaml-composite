(** A signature for a module with the complete specification of the methods required
    for the arrow protocol. *)
module type Basic_arrow = sig  
  include Category_sigs.Category
  val arr    : ('a -> 'b) -> ('a, 'b) t
  val first  : ('a, 'b) t -> ('a * 'c, 'b * 'c) t
  val second : ('c, 'd) t -> ('a * 'c, 'a * 'd) t
  val split  : ('a, 'b) t -> ('c, 'd) t -> ('a * 'c, 'b * 'd) t
  val fanout : ('a, 'b) t -> ('a, 'd) t -> ('a, 'b * 'd) t
end

(** Signature for a minimal arrow requiring derivation of the
    remaining `Basic_arrow` methods from the `first` method.
 *)
module type Minimal_arrow_first = sig
  include Category_sigs.Category
  val arr    : ('a -> 'b) -> ('a, 'b) t
  val first  : ('a, 'b) t -> ('a * 'c, 'b * 'c) t
end

(** Signature for a minimal arrow requiring derivation of the
    remaining `Basic_arrow` methods from the `split` method.
 *)
module type Minimal_arrow_split = sig
  include Category_sigs.Category
  val arr    : ('a -> 'b) -> ('a, 'b) t
  val split  : ('a, 'b) t -> ('c, 'd) t -> ('a * 'c, 'b * 'd) t
end

(** A signature for the complete arrow module *)
module type Arrow = sig
  include Basic_arrow
  val ( <<< ) : ('b, 'c)t -> ('a, 'b) t -> ('a, 'c) t
  val ( >>> ) : ('a, 'b) t -> ('b, 'c) t -> ('a, 'c) t
  val ( *** ) : ('a, 'b) t -> ('c, 'd) t -> ('a * 'c, 'b * 'd) t
  val ( &&&)  : ('a, 'b) t -> ('a, 'd) t -> ('a, 'b * 'd) t
end

