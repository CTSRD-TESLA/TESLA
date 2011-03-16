CC=clang
LD=clang

TESLA = -load llvmlib/TeslaInstrumenter.so -add-plugin tesla \
	-plugin-arg-tesla instrumentation.spec
TESLA_PASSTHROUGH = $(TESLA:%=-Xclang %)

CFLAGS=-Wall -g -I../.. $(TESLA_PASSTHROUGH)

TESLALIBS=					\
	../../libtesla/tesla_state.o		\
	../../libtesla/tesla_state_global.o	\
	../../libtesla/tesla_state_perthread.o	\
	../../libtesla/tesla_util.o

all: test

test: test.o audit_assertion.o audit_automata.o syscalls.o ${TESLALIBS}
	${LD} -o $@ $+ -lpthread
clean:
	rm -f test *.o *.bc *.ll

