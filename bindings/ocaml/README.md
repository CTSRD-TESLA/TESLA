These TESLA bindings require:

* `libtesla.a` to be compiled in the `libtesla` directory, via the
  `Makefile.tesla` in the toplevel directory.

* The trunk `ocaml-ctypes`, which you can install via:

```
$ opam pin ctypes git://github.com/ocamllabs/ocaml-ctypes
$ opam install ctypes
```

Just do `make run` in this directory to build the library and run the
associated tests.
