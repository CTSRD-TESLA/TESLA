OCAMLMAKEFILE = OCamlMakefile
 
SOURCES = spl_utils.mli spl_utils.ml spl_location.ml spl_syntaxtree.ml \
	spl_parser.mli spl_lexer.ml spl_parser.ml spl_typechecker.mli \
	spl_typechecker.ml spl_cfg.ml spl_optimiser.mli \
	spl_optimiser.ml spl_dot.ml spl_tesla.ml spl_promela.ml spl_ocaml.ml \
	splc.ml
RESULT = splc
TRASH = spl_parser.output spl_parser.ml spl_lexer.ml
ANNOTATE = yes
LIBS= str

.PHONY: all native bytecode
all: bytecode
bytecode: dc

include $(OCAMLMAKEFILE)
