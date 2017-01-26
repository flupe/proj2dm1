open Visited

let t1 = Node(0, Node(0, Leaf, Leaf), Node(0, Leaf, Leaf))

let t2 =
  let t' = Node(0, Leaf, Leaf) in
  Node(0, t', t')

let t3 =
  let t' = Node(0, Leaf, Leaf) in
  Node(0, Node(0, t', Leaf), Node(0, Leaf, t'))

let rec structural_size = function
  | Leaf -> 0
  | Node(_, g, d) -> 1 + structural_size g + structural_size d

let () =
  print_int @@ structural_size t3;
  print_newline ();
  print_int @@ Physize.physical_size t3;
  print_newline ();
