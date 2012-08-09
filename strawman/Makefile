.PHONY: clean run-tesla tesla

TESLA_DIR=../tesla
ANALYSER=${TESLA_DIR}/analyser/tesla
INSTRUMENTER= \
	opt -S -load ${TESLA_DIR}/instrumenter/TeslaInstrumenter.dylib -tesla

CC=clang -D TESLA -D REVISION="\"$(shell ./revision.sh)\""
CFLAGS=-I ../include/tesla

EXAMPLE=example

PARSE=${CC} -fsyntax-only ${CFLAGS}

all: tesla demo

clean:
	rm -f *.ll *.tesla

tesla:
	cd ${TESLA_DIR} && ${MAKE}

demo: main.o support.o tesla-hack.o example.instr.o
	${CC} $^ -o $@

run-tesla: analyse instrument
analyse: tesla example.tesla
instrument: tesla example.ll example.instr.ll

# Run the TESLA analyser over C code.
%.tesla: %.c
	${ANALYSER} $< -- ${PARSE} > $@
	cat $@

# Instrument LLVM IR using TESLA.
%.instr.ll: %.ll
	${INSTRUMENTER} $< -o $@
	# We *expect* diff to produce an output!
	diff -u $< $@ && exit 1 || exit 0

# Compile C code to LLVM IR.
%.ll: %.c
	${CC} ${CFLAGS} -S -emit-llvm $< -o $@

# Compile IR to object code.
%.o: %.ll
	${CC} -c ${CFLAGS} $< -o $@

