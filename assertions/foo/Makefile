# $Id$

SPLC?=		../../cfa/splc
TESLA_CLANG?=	../../kernel/tesla-clang

OPTLEVEL?=	-O0
CFLAGS=		-Wall -g -I../.. -I. $(OPTLEVEL) -save-temps

NAME=		foo
SPECNAME?=	$(NAME)

TESLALIBS=					\
	../../libtesla/tesla_state.o		\
	../../libtesla/tesla_state_global.o	\
	../../libtesla/tesla_state_perthread.o	\
	../../libtesla/tesla_util.o

.PHONY: all clean

all:	$(NAME)

%_defs.h %_automata.c %.spec: %.spl $(SPLC) Makefile
	$(SPLC) -t tesla -s $* $<
	# Fix file format for TESLAInstrumenter:
	sed -e 's/^\([^,]*\),\([^,]*\),\([^,]*\),.*/\1,struct \2,\3/g' < $(NAME).spec | sort | uniq > x.spec
	mv x.spec $(NAME).spec

%_assertion.o: %_assertion.c %_defs.h
	$(CC) -c $(CFLAGS) -o $@ $<

%_automata.o: %_automata.c %_defs.h
	$(CC) -c $(CFLAGS) -o $@ $<

$(NAME).o: $(NAME).c $(NAME)_defs.h
	env SPECNAME=$(SPECNAME) $(TESLA_CLANG) -c $(CFLAGS) -o $(NAME).o $(NAME).c

$(NAME): $(NAME).o $(NAME)_assertion.o $(NAME)_automata.o ${TESLALIBS}
	$(CC) -o $@ $^

clean:
	rm -f *.o *.a *_defs.h *_automata.c $(NAME).spec *.i *.s $(NAME)

distclean:	clean

