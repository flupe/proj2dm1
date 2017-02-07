open Visited
open Odot

let (=>) name value =
  (Simple_id name, Some (Double_quoted_id value))

let leaf_style = [
  "shape" => "circle";
  "style" => "filled";
  "color" => "lightgrey";
  "width" => ".3";
  "label" => ""
]

let node_style = [
  "width" => ".55"
]

(* a variant of the VisitedNodes module
   avec une liste associative pour contenir les noeuds du graphe
   associés aux noeuds de l'arbre *)
module Memory = struct
  type 'a t = ('a tree * node_id) list ref
  let create () = ref []
  (* val lookup : 'a t -> 'a tree -> node_id option *)
  let lookup storage tree =
    let rec search = function
      | (t, node) :: q -> if t == tree then Some node else search q
      | _ -> None
    in
    search !storage

  (* insère une nouvelle valeur dans la structure *)
  let add storage tree vertex =
    storage := (tree, vertex) :: !storage
end

(* display a Odot.graph inside a pdf viewer *)
let display graph = begin
  print_file "/tmp/graph.dot" graph;
  ignore @@ Sys.command "dot -Tpdf /tmp/graph.dot -o /tmp/graph.pdf";
  ignore @@ Sys.command "xdg-open /tmp/graph.pdf"
end

(* affiche un int tree à l'écran *)
let affiche tree =
  (* création du graphe vide *)
  let tree_graph : graph = {
    strict = false;
    kind = Digraph;
    id = None;
    stmt_list = []
  }
  in
  let storage = Memory.create () in
  let count = ref 0 in

  let new_node params =
    let id = dblq_node_id (string_of_int !count) in
    begin
      incr count;
      (id, Stmt_node (id, params))
    end
  in

  let new_edge id1 id2 =
    Stmt_edge ((Edge_node_id id1), [Edge_node_id id2], [])
  in

  let rec build = function
    | Leaf ->
      let id, node = new_node leaf_style in begin
        tree_graph.stmt_list <- node :: tree_graph.stmt_list;
        id
      end

    | Node(x, g, d) as node ->
      match Memory.lookup storage node with
        | Some id -> id
        | None ->
          let id, n = new_node (("label" => string_of_int x) :: node_style) in
          let l_child = build g in
          let r_child = build d in begin
            tree_graph.stmt_list <- (new_edge id l_child) :: tree_graph.stmt_list;
            tree_graph.stmt_list <- (new_edge id r_child) :: tree_graph.stmt_list;
            tree_graph.stmt_list <- n :: tree_graph.stmt_list;
            Memory.add storage node id;
            id
          end
  in
  let _ = build tree in
  display tree_graph
