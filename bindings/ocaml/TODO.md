# Ctypes

* check the ptr null() functions for correctness.
* is there a `uintptr_t` type?
* need a ptr to int64 to help with debugging asserts.

# Build

* need to link a `cmxa` or `cmx` to avoid the `dlopen` call,
  since thats the only way to embed the `cclib` in an OCaml lib.
