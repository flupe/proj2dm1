open Visited

let physical_size tree =
  let storage = VisitedNodes.create () in
  let rec count = function
    | Leaf -> 0
    | Node(_, g, d) as node ->
       if VisitedNodes.lookup node storage then 0
       else 1 + count g + count d
  in
  count tree
