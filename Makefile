all:
	ocamlbuild -yaccflag -v -lib unix tests.native

byte:
	ocamlbuild -yaccflag -v tests.byte

clean:
	ocamlbuild -clean