CFLAGS=-Wall -g -I../..
TESLALIBS=../../libtesla/tesla_state.o ../../libtesla/tesla_util.o

all: test

audit_assertion.o: audit_assertion.c
	gcc -c ${CFLAGS} -o audit_assertion.o audit_assertion.c
audit_automata.o: audit_automata.c
	gcc -c ${CFLAGS} -o audit_automata.o audit_automata.c
	gcc -c ${CFLAGS} -o test.o test.c
test: test.o audit_assertion.o audit_automata.o
	gcc -o test test.c audit_assertion.o audit_automata.o ${TESLALIBS}
clean:
	rm -f test test.o audit_assertion.o audit_automata.o

