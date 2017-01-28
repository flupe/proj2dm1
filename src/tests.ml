open Visited

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

module SSize = Physize.MakeSize(STree)
module PSize = Physize.MakeSize(PTree)
module TSize = Physize.MakeSize(TTree)

let structural_size = SSize.size
let physical_size = PSize.size
let topological_size = TSize.size

(* ================================== *)

let () =
  print_int @@ structural_size t1;
  print_newline ();
  print_int @@ physical_size t1;
  print_newline ();
  print_int @@ topological_size t1;
  print_newline ();

  Dessine.affiche t3
