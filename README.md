[school assignment](http://perso.ens-lyon.fr/daniel.hirschkoff/P2/docs/dm.pdf)

## dependencies

### system dependencies
`dot` is used to display tree graphs.

```
apt-get install dot
```

### ocaml dependencies

`ocamldot` is used to create a dot representation of a tree. I chose `ocamldot` rather than `ocamlgraph` because it is lighter and offers more flexibility (drawbacks: quite verbose and hasn't been updated since 2012 (!), yet it seems to work fine).

*a previous implementation of the drawing routine using `ocamlgraph` can be found in the git history of this repo.*
```
opam install ocamlfind ocamldot
```

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

