.PHONY: clean run-tesla tesla

# Hold onto all LLVM IR files for manual inspection.
.PRECIOUS: %.ll

TESLA_DIR=../tesla
ANALYSER=${TESLA_DIR}/analyser/tesla
INSTRUMENTER= \
	opt -S \
		-load ${TESLA_DIR}/instrumenter/TeslaInstrumenter.dylib \
		-tesla-callee -tesla-caller -tesla-asserts

CC=clang -D TESLA -D REVISION="\"$(shell ./revision.sh)\""
LINK=clang

DIFF=$(shell which colordiff || echo "diff")
VERBOSE?=false

CFLAGS=-I ../include/tesla

BIN=demo
EXAMPLE=example

C=example support main tesla-hack
IR=handcoded

INSTR=$(patsubst %,%.instr,$C ${IR})
INSTRUMENTED_IR=$(patsubst %,%.ll,${INSTR})

OBJ=$(patsubst %,%.o,${INSTR})

PARSE=${CC} -fsyntax-only ${CFLAGS}

all: tesla ${BIN}

clean:
	rm -f ${BIN} $(patsubst %,%.ll,$C ${INSTR}) ${OBJ} *.tesla

tesla:
	cd ${TESLA_DIR} && ${MAKE}

run-tesla:
	VERBOSE=true ${MAKE} analyse instrument

analyse: tesla example.tesla
instrument: tesla ${INSTRUMENTED_IR}

# Build the demo application.
${BIN}: ${OBJ}
	@echo "[LINK]  $^ > $@"
	@${LINK} $^ -o $@

# Run the TESLA analyser over C code.
%.tesla: %.c
	@echo "[TESLA] $^ > $@"
	@${ANALYSER} $< -- ${PARSE} -D TESLA_ANALYSIS > $@
	@${VERBOSE} && cat $@

# Instrument LLVM IR using TESLA.
%.instr.ll: %.ll
	@echo "[TESLA] $^ > $@"
	@${INSTRUMENTER} $< -o $@
	@# We *expect* diff to produce an output!
	@${VERBOSE} && ${DIFF} -u $< $@ || exit 0

# Compile C code to LLVM IR.
%.ll: %.c
	@echo "[CC]    $^ > $@"
	@${CC} ${CFLAGS} -S -emit-llvm $< -o $@

# Compile IR to object code.
%.o: %.ll
	@echo "[LLC]   $^ > $@"
	@${CC} -c $< -o $@

