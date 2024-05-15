type 'a type_proxy = Tproxy
type 'a t = 'a type_proxy
val return : 'a -> 'a type_proxy
val bind : 'a type_proxy -> ('a -> 'b type_proxy) -> 'b type_proxy
val flatmap : ('a -> 'b type_proxy) -> 'a type_proxy -> 'b type_proxy
val join : 'a type_proxy type_proxy -> 'a type_proxy
val product : 'a type_proxy -> 'b type_proxy -> ('a * 'b) type_proxy
val pure : 'a -> 'a type_proxy
val fapply : ('a -> 'b) type_proxy -> 'a type_proxy -> 'b type_proxy
val fmap : ('a -> 'b) -> 'a type_proxy -> 'b type_proxy
val ( <$> ) : ('a -> 'b) -> 'a type_proxy -> 'b type_proxy
val ( >>= ) : 'a type_proxy -> ('a -> 'b type_proxy) -> 'b type_proxy
val ( =<< ) : ('a -> 'b type_proxy) -> 'a type_proxy -> 'b type_proxy
val ( >=> ) :
  ('a -> 'b type_proxy) -> ('b -> 'c type_proxy) -> 'a -> 'c type_proxy
val ( <=< ) :
  ('b -> 'c type_proxy) -> ('a -> 'b type_proxy) -> 'a -> 'c type_proxy
val ( <*> ) : ('a -> 'b) type_proxy -> 'a type_proxy -> 'b type_proxy
val ( let* ) : 'a type_proxy -> ('a -> 'b type_proxy) -> 'b type_proxy
val ( let+ ) : 'a type_proxy -> ('a -> 'b) -> 'b type_proxy
val ( and+ ) : 'a type_proxy -> 'b type_proxy -> ('a * 'b) type_proxy
