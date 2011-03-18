SPLC ?= ../../cfa/splc

CFLAGS=-Wall -g -I../.. -I. -pthread
TESLALIBS=                                      \
	../../libtesla/tesla_state.o            \
	../../libtesla/tesla_state_global.o     \
	../../libtesla/tesla_state_perthread.o  \
	../../libtesla/tesla_util.o

.PHONY: all clean pdf
all: libteslassh.a libfaketeslassh.a

pdf: ssh.pdf 

ssh_assertion.o: ssh_assertion.c ssh_defs.h ssh_kex_defs.h
	$(CC) -c $(CFLAGS) -o $@ $<

%_fakeassertion.o: %_fakeassertion.c
	$(CC) -c $(CFLAGS) -o $@ $<
	
%_defs.h %_automata.c %.spec: %.spl $(SPLC) Makefile
	$(SPLC) -t tesla -s $* $<

%-all.dot: %.spl $(SPLC) Makefile
	$(SPLC) -t dot $<

%-all.dot.pdf: %-all.dot
	dot -Tpdf -O $<

%.pdf: %-all.dot.pdf
	cp $< $@

%_automata.o: %_automata.c %_defs.h
	$(CC) -c $(CFLAGS) -o $@ $<

libteslassh.a: $(TESLALIBS) ssh_automata.o ssh_assertion.o ssh_kex_automata.o
	ar rvc $@ $^

libfaketeslassh.a: $(TESLALIBS) ssh_fakeassertion.o
	ar rvc $@ $^
	
test.o: test.c ssh_defs.h
	$(CC) -c $(CFLAGS) -o test.o test.c

test: test.o ssh_assertion.o ssh_automata.o ${TESLALIBS}
	$(CC) -o $@ $^ -lpthread

clean:
	rm -f test *.o
