CC=../../kernel/tesla-clang
LD=../../kernel/tesla-clang
CLANGLIB=${HOME}/llvmlib/libTeslaInstrumenter.so

CFLAGS=-Wall -g -I../..

TESLALIBS=					\
	../../libtesla/tesla_state.o		\
	../../libtesla/tesla_state_global.o	\
	../../libtesla/tesla_state_perthread.o	\
	../../libtesla/tesla_util.o

all: test

test: test.o mwc_assertion.o mwc_automata.o syscalls.o ${TESLALIBS}
	${LD} -o $@ $+ -lpthread

clean:
	rm -f test *.o *.bc *.ll *.c-tesla.h

mwc_assertion.o: syscalls.c-tesla.h
syscalls.c-tesla.h: syscalls.o
