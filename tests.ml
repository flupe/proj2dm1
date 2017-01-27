open Visited


(* structural tree *)
module STree =
struct
  let eq a b = false
end

(* physical tree *)
module PTree =
struct
  let rec eq = (==)
end

(* topological tree *)
module TTree =
struct
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
  let t' = Node(0, Leaf, Leaf) in
  Node(0, Node(0, t', Leaf), Node(0, Leaf, t'))

module SSize = Physize.MakeSize(STree)
module PSize = Physize.MakeSize(PTree)
module TSize = Physize.MakeSize(TTree)

(* ================================= *)

let () =
  print_int @@ SSize.size t3;
  print_newline ();
  print_int @@ PSize.size t3;
  print_newline ();
