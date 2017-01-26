type 'a tree = Node of 'a * 'a tree * 'a tree | Leaf

module type VisitedNodes =
sig
  (* the structure where nodes are stored *)
  type 'a t
  val create : unit -> 'a t
  (* when the answer is "false", the structure is extended *)
  val lookup : 'a tree -> 'a t -> bool
  val tolist :  'a t -> 'a tree list
end

(* strict equality (aka in memory) *)
let rec find tree = function
  | h :: t -> h == tree || find tree t
  | _ -> false

module VisitedNodes =
struct
  (* we need the structure to be mutable for `lookup` *)
  type 'a t = 'a tree list ref

  let create () = ref []

  let lookup tree t =
    if find tree !t then true
    else begin
      t := tree :: !t;
      false
    end

  let tolist t = !t
end

