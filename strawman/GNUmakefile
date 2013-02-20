.PHONY: clean run-tesla tesla
.SUFFIXES: .c .dot .ll .pdf .tesla

# Hold onto all LLVM IR files for manual inspection.
.PRECIOUS: %.ll %.instr.ll

.SILENT:

BUILD_DIR?=../build

ANALYSE=${BUILD_DIR}/tesla/analyser/tesla-analyse
INSTRUMENT= ${BUILD_DIR}/tesla/instrumenter/tesla-instrument -S -verify-each
TOOLS=${BUILD_DIR}/tesla/tools
GRAPH=${TOOLS}/graph/tesla-graph
LIBS=-L ${BUILD_DIR}/libtesla/src -l tesla

TRIPLE=$(shell ${TOOLS}/llvm-triple/llvm-triple)

CC=clang
LINK=clang
LLC=llc -mtriple=${TRIPLE} -filetype=obj

DIFF=$(shell which colordiff || echo "diff")
VERBOSE?=false

CFLAGS=-Wall -Werror \
	-D REVISION="\"$(shell ./revision.sh)\"" \
	-I ../include/tesla -D TESLA

BIN=demo
DOTFILE=tesla.dot
EXAMPLE=example

C=example support main
TESLA=$(patsubst %,%.tesla,$C)

IR=handcoded

INSTR=$(patsubst %,%.instr,$C ${IR})
INSTRUMENTED_IR=$(patsubst %,%.ll,${INSTR})

OBJ=$(patsubst %,%.o,${INSTR})

all: tesla tesla.dot ${BIN}

clean:
	rm -f ${BIN} $(patsubst %,%.ll,$C ${INSTR}) ${OBJ} ${DOTFILE} *.tesla

tesla:
	cd ${BUILD_DIR} && ninja

run-tesla: analyse instrument

analyse: tesla
	${MAKE} VERBOSE=true example.tesla

instrument: tesla
	${MAKE} VERBOSE=true ${INSTRUMENTED_IR}

.tesla: ${TESLA}
	@echo "[CAT]     $^ > $@"
	cat $^ > $@
	# temporary workaround for ClangTool irritant:
	sed -i.backup "s@`pwd`/@@" .tesla && rm .tesla.backup

# Optional PDF-ification of the .dot file.
.dot.pdf:
	@echo "[DOT]     $^ > $@"
	dot -Tpdf -o $@ $<

# Graph the .tesla file.
${DOTFILE}: .tesla
	@echo "[GRAPH]   $^ > $@"
	${GRAPH} -d -o $@ $<

# Build the demo application.
${BIN}: ${OBJ}
	@echo "[LINK]    $^ > $@"
	${LINK} $^ ${LIBS} -o $@

# Run the TESLA analyser over C code.
.c.tesla: tesla
	@echo "[TESLA]   $^ > $@"
	${ANALYSE} $< -o $@ -- ${CFLAGS} || rm -f $@
	${VERBOSE} && echo && echo "===== TESLA analysis of $<: =====" \
	            && cat $@ && echo "===== end of TESLA analysis =====" \
	            || exit 0

# Instrument LLVM IR using TESLA.
%.instr.ll: %.ll .tesla
	@echo "[TESLA]   $^ > $@"
	${INSTRUMENT} -tesla-manifest .tesla $< -o $@
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

