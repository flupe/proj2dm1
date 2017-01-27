open Visited

module type Size = sig
  val size : 'a tree -> int
end

module type TreeEq = sig
  val eq : 'a tree -> 'a tree -> bool
end

module MakeSize (T: TreeEq) : Size = struct

  module VisitedNodes = MakeVisitor(struct
    type 'a t = 'a tree
    let eq = T.eq
  end)

  let size tree =
    let storage = VisitedNodes.create () in
    let rec count = function
      | Leaf -> 0
      | Node(_, g, d) as node ->
         if VisitedNodes.lookup node storage then 0
         else 1 + count g + count d
    in
    count tree

end

