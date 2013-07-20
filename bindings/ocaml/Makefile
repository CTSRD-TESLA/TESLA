all:
	ocamlbuild -classic-display -use-ocamlfind -tag annot -pkg ctypes.foreign,ctypes.top -tag short_paths test_internal.native test_external.native tesla.docdir/index.html

run: all
	env OCAMLRUNPARAM=b TESLA_DEBUG=1 DYLD_LIBRARY_PATH=../../libtesla ./_build/test_internal.native
	env OCAMLRUNPARAM=b TESLA_DEBUG=1 DYLD_LIBRARY_PATH=../../libtesla ./_build/test_external.native

clean:
	ocamlbuild -clean
