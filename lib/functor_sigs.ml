module type Basic_functor = sig
  type 'a t
  val fmap : ('a -> 'b) -> 'a t -> 'b t
end

module type Functor = sig
  include Basic_functor
  val ( <$> ) : ('a -> 'b) -> 'a t -> 'b t
end

module type Minimal_applicative_fapply = sig
  type 'a t
  val pure : 'a -> 'a t
  val fapply : ('a -> 'b) t -> 'a t -> 'b t
end

module type Minimal_applicative_product = sig
  type 'a t
  val fmap : ('a -> 'b) -> 'a t -> 'b t
  val pure : 'a -> 'a t
  val product : 'a t -> 'b t -> ('a * 'b) t
end

module type Basic_applicative = sig
  include Basic_functor
  val pure : 'a -> 'a t
  val product : 'a t -> 'b t -> ('a * 'b) t
end

module type Applicative = sig
  include Basic_functor
  val pure : 'a -> 'a t
  val product : 'a t -> 'b t -> ('a * 'b) t
  val fapply : ('a -> 'b) t -> 'a t -> 'b t
  val ( <*> ) : ('a -> 'b) t -> 'a t -> 'b t
end

module type Minimal_monad_bind = sig
  type 'a t
  val pure : 'a -> 'a t
  val bind : 'a t -> ('a -> 'b t) -> 'b t
end

module type Minimal_monad_join = sig
  type 'a t
  val fmap : ('a -> 'b) -> 'a t -> 'b t
  val pure : 'a -> 'a t
  val join : ('a t) t -> 'a t
end

module type Basic_monad = sig
  include Basic_applicative
  val bind : 'a t -> ('a -> 'b t) -> 'b t
  val join : ('a t) t -> 'a t
end

module type Monad = sig
  type 'a t
  val return : 'a -> 'a t
  val bind : 'a t -> ('a -> 'b t) -> 'b t
  val flatmap : ('a -> 'b t) -> 'a t -> 'b t
  val join : ('a t) t -> 'a t
  val product : 'a t -> 'b t -> ('a * 'b) t
  val pure : 'a -> 'a t
  val fapply : ('a -> 'b) t -> 'a t -> 'b t
  val fmap : ('a -> 'b) -> 'a t -> 'b t
  val ( <$> ) : ('a -> 'b) -> 'a t -> 'b t
  val ( >>= ) : 'a t -> ('a -> 'b t) -> 'b t
  val ( =<< ) : ('a -> 'b t) -> 'a t -> 'b t
  val ( >=> ) : ('a -> 'b t) -> ('b -> 'c t) -> ('a -> 'c t)
  val ( <=< ) : ('b -> 'c t) -> ('a -> 'b t) -> ('a -> 'c t)
  val ( <*> ) : ('a -> 'b) t -> 'a t -> 'b t
  val ( let* ) : 'a t -> ('a -> 'b t) -> 'b t
  val ( let+ ) : 'a t -> ('a -> 'b) -> 'b t
  val ( and+ ) : 'a t -> 'b t -> ('a * 'b) t
end

module type Basic_comonad = sig
  include Basic_functor
  val extract : 'a t -> 'a
  val extend : ('a t -> 'b) -> 'a t -> 'b t
  val duplicate : 'a t -> ('a t) t
end

module type Minimal_comonad_duplicate = sig
  type 'a t
  val extract : 'a t -> 'a
  val duplicate : 'a t -> ('a t) t
end

module type Minimal_comonad_extend = sig
  type 'a t
  val extract : 'a t -> 'a
  val extend : ('a t -> 'b) -> 'a t -> 'b t
end

module type Comonad = sig
  include Basic_comonad
end


module type Minimal_trivial = sig
  type 'a t
  val wrap : 'a -> 'a t
  val unwrap : 'a t -> 'a
end

module type Trivial = sig
  include Monad
  val wrap : 'a -> 'a t
  val unwrap : 'a t -> 'a
  val extract : 'a t -> 'a
  val extend : ('a t -> 'b) -> 'a t -> 'b t
  val duplicate : 'a t -> ('a t) t
end

