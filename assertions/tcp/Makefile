SPLC ?= ../../cfa/splc
TESLA_CLANG ?= ../../kernel/tesla-clang

OPTLEVEL ?= -O0

CFLAGS=-Wall -g -I../.. -I. $(OPTLEVEL)

TESLALIBS=                                      \
	../../libtesla/tesla_state.o            \
	../../libtesla/tesla_state_global.o     \
	../../libtesla/tesla_state_perthread.o  \
	../../libtesla/tesla_util.o

.PHONY: all clean pdf micro
all: test

pdf: tcpc.pdf 

%_assertion.o: %_assertion.c %_defs.h
	$(CC) -c $(CFLAGS) -o $@ $<

%_defs.h %_automata.c %.spec: %.spl $(SPLC) Makefile
	$(SPLC) -t tesla -s $* $<

tcpc-all.dot: tcpc.spl $(SPLC) Makefile
	$(SPLC) -t dot $* $<

tcpc-all.dot.pdf: tcpc-all.dot
	dot -Tpdf -O $<

tcpc.pdf: tcpc-all.dot.pdf
	cp $< $@

%_automata.o: %_automata.c %_defs.h
	$(CC) -c $(CFLAGS) -o $@ $<

test.o: test.c tcpc_defs.h
	cp instrumentation.spec.in instrumentation.spec
	$(TESLA_CLANG) -c $(CFLAGS) -o test.o test.c

test: test.o tcpc_assertion.o tcpc_automata.o ${TESLALIBS}
	$(CC) -o $@ $^ -lpthread

instr_gcc.o: instr.c tcpc_defs.h
	$(CC) -c $(CFLAGS) -o $@ $<

gcc_stub.o: gcc_stub.c
	$(CC) -c $(CFLAGS) -o $@ $<

clang_stub.o: clang_stub.c
	$(TESLA_CLANG) -c $(CFLAGS) -o $@ $<

instr_clang_instr.o: instr.c tcpc_defs.h instrumentation.spec.in
	cp instrumentation.spec.in instrumentation.spec
	$(TESLA_CLANG) -c $(CFLAGS) -o $@ $<

instr_clang_noinstr.o: instr.c tcpc_defs.h instrumentation.spec.in
	rm -f instrumentation.spec
	$(TESLA_CLANG) -c $(CFLAGS) -o $@ $<

instr_gcc: instr_gcc.o gcc_stub.o
	$(CC) $(CFLAGS) -o $@ $^	

instr_clang_instr_tesla: instr.c tcpc_assertion.o tcpc_automata.o $(TESLALIBS)
	cp instrumentation.spec.in instrumentation.spec
	$(TESLA_CLANG) $(CFLAGS) -o $@ $^

instr_clang_instr_faketesla: instr.c tcpc_dummy_assertion.o $(TESLALIBS)
	cp instrumentation.spec.in instrumentation.spec
	$(TESLA_CLANG) $(CFLAGS) -o $@ $^

instr_clang_noinstr: instr_clang_noinstr.o clang_stub.o
	rm -f instrumentation.spec
	$(TESLA_CLANG) $(CFLAGS) -o $@ $^

micro: instr_gcc instr_clang_instr_tesla instr_clang_instr_faketesla instr_clang_noinstr
	@ :

clean:
	rm -f test *.o
