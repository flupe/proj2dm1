open Visited
open Graph.Pack

(* a variant of the VisitedNodes module *)
module Memory = struct
  type 'a t = ('a tree * Digraph.V.t) list ref

  let create () = ref []

  (* val lookup : 'a t -> 'a tree -> Digraph.V.t option *)
  let lookup storage tree =
    let rec search = function
      | (t, node) :: q -> if t == tree then Some node else search q
      | _ -> None
    in
    search !storage

  let add storage tree vertex =
    storage := (tree, vertex) :: !storage

end

let affiche tree =
  let graph = Digraph.create () in
  let storage = Memory.create () in
  let count = ref 0 in

  let succ () =
    let v = !count in begin
      incr count; v
    end
  in

  let rec build = function
    | Leaf ->
      let leaf = Digraph.V.create (succ ()) in begin
        Digraph.add_vertex graph leaf;
        leaf
      end

    | Node(x, g, d) as node ->
      match Memory.lookup storage node with
      | Some vertex -> vertex
      | None ->
        let vertex = Digraph.V.create (succ ()) in
        let left_child = build g in
        let right_child = build d in begin
          Digraph.add_vertex graph vertex;
          Digraph.add_edge graph vertex left_child;
          Digraph.add_edge graph vertex right_child;
          Memory.add storage node vertex;
          vertex
        end

  in
  let _ = build tree in
  Digraph.display_with_gv graph

