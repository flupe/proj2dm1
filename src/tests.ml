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

module SSize = Physize.MakeSize(STree)
module PSize = Physize.MakeSize(PTree)
module TSize = Physize.MakeSize(TTree)
module SPSize = Physize.MakeSetSize(PTree)

let structural_size = SSize.size
let physical_size = PSize.size
let physical_set_size = SPSize.size

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

(* returns true with probability p *)
let event p =
  Random.float 1.0 < p

(* picks a tree uniformly in the tree list *)
let take_random trees =
  let rec aux k mem = function
    | h :: t ->
      let mem' = if event (1.0 /. k) then h else mem
      in aux (k +. 1.0) mem' t
    | _ -> mem
  in aux 1.0 Leaf trees

(* returns a random tree *)
(* note that the depth parameter only guaranties termination,
    it has limited effect over the final depth *)
let generate_tree depth =
  let rec sub_tree depth acc =
    if event 0.8 then
      aux depth acc
    else
      take_random acc, acc

  and aux depth acc =
    if depth = 0 then Leaf, acc
    else begin
      let left, acc' = sub_tree (depth - 1) acc in
      let right, acc'' = sub_tree (depth - 1) acc' in
      let node = Node(depth, left, right) in
      node, node :: acc''
    end
  in let tree, _ = aux depth []
  in tree

let random_trees n p =
  let rec aux acc n =
    if n = 0 then acc
    else aux (generate_tree p :: acc) (n - 1)
  in aux [] n

let random_tree_depth = ref (-1)
let run_size_tests = ref false
let run_perf_tests = ref false

let set_depth n =
  random_tree_depth := n

let () = begin
  let speclist = [
    ("-r", Arg.Int (set_depth), "Displays a random tree with given depth parameter");
    ("-b", Arg.Set (run_size_tests), "Toggles the execution of size comparisons over random trees");
    ("-p", Arg.Set (run_perf_tests), "Runs performance comparison of Hashtbl vs Lists")
  ] in
  let msg = "PROJ2/DM1 -- options available :"
  in Arg.parse speclist print_endline msg;
  Random.self_init ();

  (* runs several size calculations *)
  if !run_size_tests then begin
    let trees = random_trees 20 7 in
    List.iter (fun tree -> begin
      print_string "structural size: ";
      print_endline @@ string_of_int @@ structural_size tree;
      print_string "physical size: ";
      print_endline @@ string_of_int @@ physical_size tree;
      print_string "set physical size: ";
      print_endline @@ string_of_int @@ physical_set_size tree;
      print_endline "---";
        end) trees
  end;

  (* runs performance tests *)
  if !run_perf_tests then begin
    let trees = random_trees 5000 7 in
    let _ = print_string "yop" in
    let start = Unix.gettimeofday () in begin
      List.iter (fun tree -> ignore @@ physical_size tree) trees;
      let delta1 = Unix.gettimeofday () -. start in
      let start = Unix.gettimeofday () in
      let _ = List.iter (fun tree -> ignore @@ physical_set_size tree) trees in
      let delta2 = Unix.gettimeofday () -. start in begin
        print_endline "200 calculations ---";
        print_string "physical_size with lists: ";
        print_endline @@ string_of_float delta1;
        print_string "physical_size with Hashtbl: ";
        print_endline @@ string_of_float delta2;
        end
    end
  end;

  (* displays a random tree *)
  if !random_tree_depth >= 0 then
    let tree = generate_tree 9 in begin
      print_string "structural size: ";
      print_endline @@ string_of_int @@ structural_size tree;

      print_string "physical size: ";
      print_endline @@ string_of_int @@ physical_size tree;
      Dessine.affiche tree
    end
end
