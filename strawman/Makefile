.PHONY: clean run-tesla tesla
.SUFFIXES: .c .dot .ll .pdf .tesla

# Hold onto all LLVM IR files for manual inspection.
.PRECIOUS: %.ll %.instr.ll

.SILENT:

BUILD_TYPE?=Debug

BUILD_DIR=../${BUILD_TYPE}
ANALYSER=${BUILD_DIR}/tesla/analyser/tesla-analyser
INSTRUMENTER= ${BUILD_DIR}/tesla/instrumenter/tesla-instrument -S -verify-each
TOOLS=${BUILD_DIR}/tesla/tools
GRAPH=${TOOLS}/graph-manifest/graph-manifest
LIBS=-L ${BUILD_DIR}/libtesla/src -l tesla

TRIPLE=$(shell ${TOOLS}/get-triple/get-triple)

CC=clang
DOT=dot
LINK=clang
LLC=llc -mtriple=${TRIPLE} -filetype=obj

DIFF=$(shell which colordiff || echo "diff")
VERBOSE?=false

CFLAGS=-I ../include/tesla -D TESLA -D REVISION="\"$(shell ./revision.sh)\""

PDF=tesla.pdf
BIN=demo
DOTFILE=$(PDF:.pdf=.dot)
EXAMPLE=example

C=example support main
TESLA=$(patsubst %,%.tesla,$C)

IR=handcoded

INSTR=$(patsubst %,%.instr,$C ${IR})
INSTRUMENTED_IR=$(patsubst %,%.ll,${INSTR})

OBJ=$(patsubst %,%.o,${INSTR})

all: tesla ${PDF} ${BIN}

clean:
	rm -f ${PDF} ${BIN} $(patsubst %,%.ll,$C ${INSTR}) ${OBJ} *.tesla \
	${DOTFILE} *.pdf

tesla:
	cd .. && ${MAKE} Debug Release

run-tesla: analyse instrument

analyse: tesla
	${MAKE} VERBOSE=true example.tesla

instrument: tesla
	${MAKE} VERBOSE=true ${INSTRUMENTED_IR}

.tesla: ${TESLA}
	@echo "[CAT]     $^ > $@"
	cat $^ > $@

# Graph the .tesla file.
${DOTFILE}: .tesla
	@echo "[GRAPH]   $^ > $@"
	${GRAPH} -o $@ $<

# Build the demo application.
${BIN}: ${OBJ}
	@echo "[LINK]    $^ > $@"
	${LINK} $^ ${LIBS} -o $@

# Run the TESLA analyser over C code.
.c.tesla: tesla
	@echo "[TESLA]   $^ > $@"
	${ANALYSER} $< -o $@ -- ${CFLAGS} || rm -f $@
	${VERBOSE} && echo && echo "===== TESLA analysis of $<: =====" \
	            && cat $@ && echo "===== end of TESLA analysis =====" \
	            || exit 0

# Instrument LLVM IR using TESLA.
%.instr.ll: %.ll .tesla
	@echo "[TESLA]   $^ > $@"
	${INSTRUMENTER} -tesla-manifest .tesla $< -o $@
	# We *expect* diff to produce an output!
	${VERBOSE} && ${DIFF} -u $< $@ || exit 0

# Compile C code to LLVM IR.
.c.ll:
	@echo "[CC]      $^ > $@"
	${CC} ${CFLAGS} -S -emit-llvm $< -o $@

# Compile IR to object code.
.ll.o:
	@echo "[LLC]     $^ > $@"
	${LLC} $< -o $@

# Compile a GraphViz .dot file to PDF.
.dot.pdf:
	@echo "[DOT]     $^ > $@"
	${DOT} -Tpdf -O $<

