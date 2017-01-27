open Visited
open Graph.Pack

(* WARNING : working but very very bad *)

module VisitedNodes = MakeVisitor(struct
    type 'a t = 'a tree * Digraph.V.t
    let eq (t1, _) (t2, _) = t1 == t2
end)

let affiche tree =
  let graph = Digraph.create () in
  let count = ref 0 in
  let storage = VisitedNodes.create () in

  let succ () =
    let v  = !count in begin
      incr count; v
    end
  in

  let rec find_saved_node t = function
    | (a, n) :: q -> if a == t then n else find_saved_node t q
    | _ -> failwith "ok"
  in

  let rec build = function
    | Leaf ->
      let leaf = Digraph.V.create (succ ()) in begin
        Digraph.add_vertex graph leaf;
        leaf
      end

    | Node(x, g, d) as node ->
      let node_vertex = Digraph.V.create (succ ()) in
      if VisitedNodes.lookup (node, node_vertex) storage then
        find_saved_node node (VisitedNodes.tolist storage)
      else
      let left_child = build g in
      let right_child = build d in begin
        Digraph.add_vertex graph node_vertex;
        Digraph.add_edge graph node_vertex left_child;
        Digraph.add_edge graph node_vertex right_child;
        node_vertex
      end

  in
  let _ = build tree in
  Digraph.display_with_gv graph

