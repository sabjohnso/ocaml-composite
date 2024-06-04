module type Comparable = sig
  type t

  val compare : t -> t -> int
end

module Make (Key : Comparable) = struct
  type key = Key.t
  type 'a t = (key * 'a) list

  let new_alist : 'a t = []

  let rec has_key key = function
    | (k, _) :: more_pairs when Key.compare k key = -1 -> has_key key more_pairs
    | (k, _) :: _ when Key.compare k key = 0 -> true
    | (k, _) :: _ when Key.compare k key = 1 -> false
    | _ -> false

  let set key value alist =
    let rec recur previous_pairs = function
      | (k, v) :: more_pairs -> (
          match Key.compare k key with
          | -1 -> recur ((k, v) :: previous_pairs) more_pairs
          | 0 -> List.rev_append previous_pairs ((key, value) :: more_pairs)
          | 1 ->
              List.rev_append previous_pairs
                ((key, value) :: (k, v) :: more_pairs)
          | _ -> raise Exn.Unreachable)
      | [] -> List.rev_append previous_pairs [ (key, value) ]
    in
    recur [] alist

  let get target_key =
    let rec recur = function
      | (current_key, value) :: next -> (
          match Key.compare current_key target_key with
          | -1 -> recur next
          | 0 -> Some value
          | 1 -> None
          | _ -> raise Exn.Unreachable)
      | [] -> None
    in
    recur

  let remove target_key alist =
    let rec recur prev = function
      | (current_key, value) :: next -> (
          match Key.compare current_key target_key with
          | -1 -> recur ((current_key, value) :: prev) next
          | 0 -> List.rev_append prev next
          | 1 -> alist
          | _ -> raise Exn.Unreachable)
      | [] -> alist
    in
    recur alist
end
