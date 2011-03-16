CC=clang
LD=clang

CFLAGS=-Wall -g -I../.. \
	-Xclang -load -Xclang llvmlib/TeslaInstrumenter.so \
	-Xclang -add-plugin -Xclang tesla \
	-Xclang -plugin-arg-tesla -Xclang instrumentation.spec

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

test: test.o audit_assertion.o audit_automata.o syscalls.o ${TESLALIBS}
	${LD} -o $@ $+ -lpthread
clean:
	rm -f test *.o *.bc *.ll

