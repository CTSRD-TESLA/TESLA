CFLAGS=-Wall -g -I../..
TESLALIBS=					\
	../../libtesla/tesla_state.o		\
	../../libtesla/tesla_state_global.o	\
	../../libtesla/tesla_state_perthread.o	\
	../../libtesla/tesla_util.o

all: test

mwc_assertion.o: mwc_assertion.c
	gcc -c ${CFLAGS} -o mwc_assertion.o mwc_assertion.c
mwc_automata.o: mwc_automata.c
	gcc -c ${CFLAGS} -o mwc_automata.o mwc_automata.c
	gcc -c ${CFLAGS} -o test.o test.c
test.o: test.c
	gcc -c ${CFLAGS} -o test.o test.c
test: test.o mwc_assertion.o mwc_automata.o ${TESLALIBS}
	gcc -o test test.o mwc_assertion.o mwc_automata.o ${TESLALIBS}
clean:
	rm -f test test.o mwc_assertion.o mwc_automata.o

