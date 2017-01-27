all:
	ocamlbuild -use-ocamlfind -pkgs 'ocamlgraph' -yaccflag -v -lib unix src/tests.native

byte:
	ocamlbuild -yaccflag -v tests.byte

clean:
	ocamlbuild -clean
