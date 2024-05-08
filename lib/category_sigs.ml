(** A signature for a a module with the complete specification of the methods
    required for the category protocol. *)
module type Basic_category = sig
 type ('a, 'b) t
 val id : ('a, 'a) t
 val compose : ('b, 'c) t -> ('a, 'b) t -> ('a, 'c) t
end

(** S signature for the complete category module. *)
module type Category = sig
  include Basic_category
  val ( << ) : ('b, 'c) t -> ('a, 'b) t -> ('a, 'c) t
  val ( >> ) : ('a, 'b) t -> ('b, 'c) t -> ('a, 'c) t
end
