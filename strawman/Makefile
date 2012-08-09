.PHONY: check-syntax clean run-tesla tesla

TESLA_DIR=../tesla
ANALYSER=${TESLA_DIR}/analyser/tesla
INSTRUMENTER= \
	opt -S -load ${TESLA_DIR}/instrumenter/TeslaInstrumenter.dylib -tesla

CC=clang -D TESLA
CFLAGS=-I ../include/tesla

EXAMPLE=example

PARSE=${CC} -fsyntax-only ${CFLAGS}

all: tesla check-syntax

clean:
	rm -f *.ll *.tesla

clean:
	rm -f *.ll

tesla:
	cd ${TESLA_DIR} && ${MAKE}

check-syntax: ${EXAMPLE}.c
	${PARSE} $<

run-tesla: analyse instrument
analyse: tesla ${EXAMPLE}.tesla
instrument: tesla ${EXAMPLE}.ll ${EXAMPLE}.instr.ll

# Run the TESLA analyser over C code.
%.tesla: %.c
	${ANALYSER} $< -- ${PARSE} > $@
	cat $@

# Instrument LLVM IR using TESLA.
%.instr.ll: %.ll
	${INSTRUMENTER} $< -o $@
	# We *expect* diff to produce an output!
	diff -u example.ll example.instr.ll && exit 1 || exit 0

# Compile C code to LLVM IR.
%.ll: %.c
	${CC} ${CFLAGS} -S -emit-llvm $< -o $@

