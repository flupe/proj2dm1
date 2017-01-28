[http://perso.ens-lyon.fr/daniel.hirschkoff/P2/docs/dm.pdf](school assignment)

## dependencies

### system dependencies
`dot` and `gv` are used to display tree graphs.

```
apt-get install dot gv
```

### ocaml dependencies

```
opam install ocamlfind ocamlgraph
```

## todo
- remove parametric type `'a t` from `MakeVisitor` functor.
- eventually get rid of `gv`, improve `dot` format generation.

## notes
- usage:
  - compile : `make`
  - run : `./tests.native`
- beginner part: done
- intermediate part:
  1. generalized tree: done, unfortunately I can't make it happen without using a parametric type `'a t` for the `Visitor` module (an abstract type `t` would be preferable)
  2. uniform size definition: done
  3. tree rendering: done

