.PHONY: clean run-tesla tesla

TESLA_DIR=../tesla
ANALYSER=${TESLA_DIR}/analyser/tesla
INSTRUMENTER= \
	opt -S -load ${TESLA_DIR}/instrumenter/TeslaInstrumenter.dylib -tesla

CC=clang -D TESLA -D REVISION="\"$(shell ./revision.sh)\""
CFLAGS=-I ../include/tesla

BIN=demo
EXAMPLE=example
TO_INSTRUMENT=example support
INSTR=$(patsubst %,%.instr,${TO_INSTRUMENT})
IR=$(patsubst %,%.ll,main tesla-hack ${INSTR})
OBJ=$(patsubst %,%.o,main tesla-hack ${INSTR})

PARSE=${CC} -fsyntax-only ${CFLAGS}

all: tesla ${BIN}

clean:
	rm -f ${BIN} ${IR} ${OBJ} *.tesla

tesla:
	cd ${TESLA_DIR} && ${MAKE}

run-tesla: analyse instrument
analyse: tesla example.tesla
instrument: tesla ${TO_INSTRUMENT}

# Build the demo application.
${BIN}: ${OBJ}
	${CC} $^ -o $@

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

