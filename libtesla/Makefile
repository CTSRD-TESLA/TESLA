CFLAGS=-g -Wall -I..
ALL=tesla_state.o tesla_util.o

all: ${ALL}

tesla_state.o: tesla_state.c
	gcc -c ${CFLAGS} -o tesla_state.o tesla_state.c
tesla_util.o: tesla_util.c
	gcc -c ${CFLAGS} -o tesla_util.o tesla_util.c

clean:
	rm -f ${ALL}

