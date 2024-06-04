type 'a snooze = Pure of 'a | Zzz of (unit -> 'a)

let run = function Pure x -> x | Zzz thunk -> thunk ()

module Derived_monad : Functor_sigs.Monad with type 'a t = 'a snooze =
Functor.Monad_of_minimal_monad_bind (struct
  type 'a t = 'a snooze

  let pure x = Pure x

  let bind mx f =
    match mx with
    | Pure x -> Zzz (fun () -> run @@ f x)
    | Zzz thunk ->
        Zzz
          (fun () ->
            let x = thunk () in
            run @@ f x)
end)

include Derived_monad
