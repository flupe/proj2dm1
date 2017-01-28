all:
	ocamlbuild -just-plugin
	ocamlbuild -use-ocamlfind -pkgs 'dot' -yaccflag -v -package unix src/tests.native

byte:
	ocamlbuild -yaccflag -v tests.byte

clean:
	ocamlbuild -clean
