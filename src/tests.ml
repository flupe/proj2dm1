open Visited
open List

(* structural tree *)
module STree = struct
  let eq a b = false
end

(* physical tree *)
module PTree = struct
  let eq = (==)
end

(* topological tree *)
module TTree = struct
  let rec eq a b = match a, b with
    | Leaf, Leaf -> true
    | Node(x1, g1, d1), Node(x2, g2, d2) ->
       x1 = x2 && eq g1 g2 && eq d1 d2
    | _ -> false
end

(* ================================== *)



(* sample trees *)
let t1 = Node(0, Node(0, Leaf, Leaf), Node(0, Leaf, Leaf))

let t2 =
  let t' = Node(0, Leaf, Leaf) in
  Node(0, t', t')

let t3 =
  let t' = Node(1, Leaf, Leaf) in
  Node(2, Node(1, t', Leaf), Node(3, Leaf, t'))

let t4 =
  let t' = Node(1, Leaf, Leaf) in
  let t'' = Node(2, Leaf, Leaf) in
  Node(0, Node(4, t', t''), Node(3, t'', t'))

module SSize = Physize.MakeSize(STree)
module PSize = Physize.MakeSize(PTree)
module TSize = Physize.MakeSize(TTree)

let structural_size = SSize.size
let physical_size = PSize.size
let topological_size = TSize.size

let generate_trees depth =
  let rec aux depth (forced, none, all) =
    if depth = 0 then forced
    else begin
      let f =  fold_left (fun acc d -> fold_left (fun acc' o -> Node(depth, d, o) :: acc') acc all) [] forced
      in
      aux (depth - 1) (f, all, f @ all)
    end
  in aux depth ([Leaf], [], [Leaf])

(* ================================== *)

let () =
  (* generate all trees of depth 4 (+Leaf) *)
  let trees = generate_trees 4 in

  print_string "amount of 4-depth trees: ";
  print_endline @@ string_of_int @@ length trees;

  print_newline ();

  (* select one from the list *)
  let t = List.nth trees 75 in begin
    print_string "structural size: ";
    print_endline @@ string_of_int @@ structural_size t;

    print_string "physical size: ";
    print_endline @@ string_of_int @@ physical_size t;

    Dessine.affiche t
  end
