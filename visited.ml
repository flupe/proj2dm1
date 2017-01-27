type 'a tree = Node of 'a * 'a tree * 'a tree | Leaf

(* signature describing modules exposing an equality function *)
module type Eq =
sig
  type 'a t
  val eq : 'a t -> 'a t  -> bool
end

module type Visitor =
sig
  type 'a t
  type 'a endpoint
  val create : unit -> 'a t
  val lookup : 'a endpoint -> 'a t -> bool
  val tolist : 'a t -> 'a endpoint list
end

module MakeVisitor (T: Eq) : (Visitor with type 'a endpoint = 'a T.t) =
struct
  (* we need the structure to be mutable for `lookup` *)
  type 'a t = 'a T.t list ref

  type 'a endpoint = 'a T.t

  let rec find elt = function
    | h :: t -> T.eq h elt || find elt t
    | _ -> false

  let create () = ref []

  let lookup elt t =
    if find elt !t then true
    else begin
      t := elt :: !t;
      false
    end

  let tolist t = !t
end
