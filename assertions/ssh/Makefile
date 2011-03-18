SPLC ?= ../../cfa/splc

CFLAGS=-Wall -g -I../.. -I. -pthread
TESLALIBS=                                      \
	../../libtesla/tesla_state.o            \
	../../libtesla/tesla_state_global.o     \
	../../libtesla/tesla_state_perthread.o  \
	../../libtesla/tesla_util.o

.PHONY: all clean pdf
all: libteslassh.a

pdf: ssh.pdf 

%_assertion.o: %_assertion.c %_defs.h
	$(CC) -c $(CFLAGS) -o $@ $<

%_defs.h %_automata.c %.spec: %.spl $(SPLC) Makefile
	$(SPLC) -t tesla -s $* $<

ssh-all.dot: ssh.spl $(SPLC) Makefile
	$(SPLC) -t dot $* $<

ssh-all.dot.pdf: ssh-all.dot
	dot -Tpdf -O $<

ssh.pdf: ssh-all.dot.pdf
	cp $< $@

%_automata.o: %_automata.c %_defs.h
	$(CC) -c $(CFLAGS) -o $@ $<

libteslassh.a: $(TESLALIBS) ssh_automata.o ssh_assertion.o
	ar rvc $@ $^
	
test.o: test.c ssh_defs.h
	$(CC) -c $(CFLAGS) -o test.o test.c

test: test.o ssh_assertion.o ssh_automata.o ${TESLALIBS}
	$(CC) -o $@ $^ -lpthread

clean:
	rm -f test *.o
