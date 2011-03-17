CFLAGS=-g -Wall -I..
ALL=tesla_state.o tesla_state_global.o tesla_state_perthread.o \
    tesla_registration.o tesla_util.o

all: ${ALL}

tesla_state.o: tesla_state.c
	gcc -c ${CFLAGS} -o tesla_state.o tesla_state.c
tesla_state_global.o: tesla_state_global.c
	gcc -c ${CFLAGS} -o tesla_state_global.o tesla_state_global.c
tesla_state_perthread.o: tesla_state_perthread.c
	gcc -c ${CFLAGS} -o tesla_state_perthread.o tesla_state_perthread.c
tesla_registration.o: tesla_registration.c
	gcc -c ${CFLAGS} -o tesla_registration.o tesla_registration.c
tesla_util.o: tesla_util.c
	gcc -c ${CFLAGS} -o tesla_util.o tesla_util.c

clean:
	rm -f ${ALL}

