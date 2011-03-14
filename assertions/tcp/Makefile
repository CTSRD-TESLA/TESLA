SPLC ?= ../../cfa/splc

CFLAGS=-Wall -g -I../.. -I.
TESLALIBS=                                      \
	../../libtesla/tesla_state.o            \
	../../libtesla/tesla_state_global.o     \
	../../libtesla/tesla_state_perthread.o  \
	../../libtesla/tesla_util.o

.PHONY: all clean
all: test

%_assertion.o: %_assertion.c %_defs.h
	$(CC) -c $(CFLAGS) -o $@ $<

%_defs.h %_automata.c %.spec: %.spl $(SPLC) Makefile
	$(SPLC) -t tesla -s $* $<

%_automata.o: %_automata.c %_defs.h
	$(CC) -c $(CFLAGS) -o $@ $<

test.o: test.c tcpc_defs.h
	$(CC) -c $(CFLAGS) -o test.o test.c

test: test.o tcpc_assertion.o tcpc_automata.o ${TESLALIBS}
	$(CC) -o $@ $^ -lpthread

clean:
	rm -f test *.o tcpc_defs.h
