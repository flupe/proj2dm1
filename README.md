[school assignment](http://perso.ens-lyon.fr/daniel.hirschkoff/P2/docs/dm.pdf)

## dependencies

### system dependencies
`dot` is used to display tree graphs.

```
apt-get install dot
```

### ocaml dependencies

`ocamldot` is used to create a dot representation of a tree. I chose `ocamldot` rather than `ocamlgraph` because it is lighter and offers more flexibility (drawbacks: quite verbose and hasn't been updated since 2012 (!), yet it seems to work fine). *(also didn't want to work with strings concatenation but in the end it would have been easier)*.

*a previous implementation of the drawing routine using `ocamlgraph` can be found in the git history of this repo.*
```
opam install ocamlfind ocamldot
```

## usage
- compile with : `make`
- run with : `./tests.native`

The resulting program offers several options that can be seen with `./tests.native --help`.

```
PROJ2/DM1 -- options available :
  -r Displays a random tree with given depth parameter
  -b Toggles the execution of size comparisons over random trees
  -help  Display this list of options
  --help  Display this list of options
```

Example :
- `./tests.native -r 9`
- `./tests.native -b`

## todo
- remove parametric type `'a t` from `MakeVisitor` functor.
- rewrite `tests.ml`, ideally allowing for cmd args.

## notes
- usage:
  - compile : `make`
  - run : `./tests.native`
- beginner part: done
- intermediate part:
  1. generalized tree: done, unfortunately I can't make it happen without using a parametric type `'a t` for the `Visitor` module (an abstract type `t` would be preferable)
  2. uniform size definition: done
  3. tree rendering: done
- advanced part: (im sorry)

### 07/02/2017 update
One solution for the abstract/parametric type issue could be to use a (recent?) feature of ocaml :
```ocaml
let size (type a) (t : a tree) =
  (* we know have access to the type of the tree *)
  let t = [] : a list in
  (* ideally I would like to create the VisitedNodes module here, with type a tree
     (which is not parametric!), but apparently I can't create modules inside functions
   *)
  ()
```
