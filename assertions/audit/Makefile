CC=clang -cc1
LD=clang

CFLAGS=-Wall -g -I../.. \
	-load llvmlib/TeslaInstrumenter.so -add-plugin tesla \
	-plugin-arg-tesla instrumentation.spec

TESLALIBS=					\
	../../libtesla/tesla_state.o		\
	../../libtesla/tesla_state_global.o	\
	../../libtesla/tesla_state_perthread.o	\
	../../libtesla/tesla_util.o

all: test

%.bc: %.ll
	${CC} -emit-llvm $< -o $@

%.ll: %.c
	${CC} ${CFLAGS} -S -emit-llvm $< -o $@

test: test.bc audit_assertion.bc audit_automata.bc syscalls.bc ${TESLALIBS}
	${LD} -o $@ $+ -lpthread
clean:
	rm -f test *.o *.bc *.ll

