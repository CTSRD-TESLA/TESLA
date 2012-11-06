.PHONY: clean run-tesla tesla
.SUFFIXES: .c .ll .tesla

# Hold onto all LLVM IR files for manual inspection.
.PRECIOUS: %.ll %.instr.ll

.SILENT:

BUILD_DIR=../build
ANALYSER=${BUILD_DIR}/tesla/analyser/tesla-analyser
INSTRUMENTER= \
	opt -S \
		-load ${BUILD_DIR}/tesla/instrumenter/TeslaInstrumenter.dylib \
		-tesla-callee -tesla-caller -tesla-asserts

CC=clang -D TESLA -D REVISION="\"$(shell ./revision.sh)\""
LINK=clang

DIFF=$(shell which colordiff || echo "diff")
VERBOSE?=false

CFLAGS=-I ../include/tesla

BIN=demo
EXAMPLE=example

C=example support main tesla-hack
TESLA=$(patsubst %,%.tesla,$C)

IR=handcoded

INSTR=$(patsubst %,%.instr,$C ${IR})
INSTRUMENTED_IR=$(patsubst %,%.ll,${INSTR})

OBJ=$(patsubst %,%.o,${INSTR})

PARSE=${CC} -fsyntax-only ${CFLAGS}

all: tesla ${BIN}

clean:
	rm -f ${BIN} $(patsubst %,%.ll,$C ${INSTR}) ${OBJ} *.tesla

tesla:
	cd ${BUILD_DIR} && ninja

run-tesla: analyse instrument

analyse: tesla
	${MAKE} VERBOSE=true example.tesla

instrument: tesla
	${MAKE} VERBOSE=true ${INSTRUMENTED_IR}

.tesla: ${TESLA}
	@echo "[CAT]   $^ > $@"
	cat $^ > $@

# Build the demo application.
${BIN}: ${OBJ}
	@echo "[LINK]  $^ > $@"
	${LINK} $^ -o $@

# Run the TESLA analyser over C code.
.c.tesla:
	@echo "[TESLA] $^ > $@"
	${ANALYSER} $< -o $@ -- ${PARSE} -D TESLA_ANALYSIS
	${VERBOSE} && echo && echo "===== TESLA analysis of $<: =====" \
	            && cat $@ && echo "===== end of TESLA analysis =====" \
	            || exit 0

# Instrument LLVM IR using TESLA.
%.instr.ll: %.ll .tesla
	@echo "[TESLA] $^ > $@"
	${INSTRUMENTER} -tesla-manifest .tesla $< -o $@
	# We *expect* diff to produce an output!
	${VERBOSE} && ${DIFF} -u $< $@ || exit 0

# Compile C code to LLVM IR.
.c.ll:
	@echo "[CC]    $^ > $@"
	${CC} ${CFLAGS} -S -emit-llvm $< -o $@

# Compile IR to object code.
.ll.o:
	@echo "[LLC]   $^ > $@"
	${CC} -c $< -o $@

