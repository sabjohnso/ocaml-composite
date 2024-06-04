type 'a thunk = unit -> 'a

val wrap : 'a -> 'a thunk
val unwrap : 'a thunk -> 'a
val ( <$> ) : ('a -> 'b) -> 'a thunk -> 'b thunk
val fapply : ('a -> 'b) thunk -> 'a thunk -> 'b thunk
val ( <*> ) : ('a -> 'b) thunk -> 'a thunk -> 'b thunk

type 'a t = 'a thunk

val fmap : ('a -> 'b) -> 'a thunk -> 'b thunk
val pure : 'a -> 'a thunk
val product : 'a thunk -> 'b thunk -> ('a * 'b) thunk
val bind : 'a thunk -> ('a -> 'b thunk) -> 'b thunk
val join : 'a thunk thunk -> 'a thunk
val return : 'a -> 'a thunk
val flatmap : ('a -> 'b thunk) -> 'a thunk -> 'b thunk
val ( >>= ) : 'a thunk -> ('a -> 'b thunk) -> 'b thunk
val ( =<< ) : ('a -> 'b thunk) -> 'a thunk -> 'b thunk
val ( <=< ) : ('a -> 'b thunk) -> ('c -> 'a thunk) -> 'c -> 'b thunk
val ( >=> ) : ('a -> 'b thunk) -> ('b -> 'c thunk) -> 'a -> 'c thunk
val ( let* ) : 'a thunk -> ('a -> 'b thunk) -> 'b thunk
val ( let+ ) : 'a thunk -> ('a -> 'b) -> 'b thunk
val ( and+ ) : 'a thunk -> 'b thunk -> ('a * 'b) thunk
val extract : 'a thunk -> 'a
val duplicate : 'a -> 'a thunk
val extend : ('a -> 'b) -> 'a -> 'b thunk
