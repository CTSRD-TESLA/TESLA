CC=/home/robert/ctsrd/ctsrd/tesla/trunk/build/Debug+Asserts/bin/clang
LD=/home/robert/ctsrd/ctsrd/tesla/trunk/build/Debug+Asserts/bin/clang
CLANGLIB=/home/robert/ctsrd/ctsrd/tesla/trunk/build/Debug+Asserts/lib/libTeslaInstrumenter.so

CFLAGS=-Wall -g -I../..				\
	-Xclang -load -Xclang ${CLANGLIB}	\
	-Xclang -add-plugin -Xclang tesla	\
	-Xclang -plugin-arg-tesla -Xclang instrumentation.spec

TESLALIBS=					\
	../../libtesla/tesla_state.o		\
	../../libtesla/tesla_state_global.o	\
	../../libtesla/tesla_state_perthread.o	\
	../../libtesla/tesla_util.o

all: test

test: test.o mwc_assertion.o mwc_automata.o syscalls.o ${TESLALIBS}
	${LD} -o $@ $+ -lpthread

clean:
	rm -f test *.o *.bc *.ll
