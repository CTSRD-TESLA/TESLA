CFLAGS=-g -Wall -I ../../include
OBJ=tesla_state.o tesla_state_global.o tesla_state_perthread.o \
    tesla_registration.o tesla_util.o
ALL=libtesla.so ${OBJ}

all: ${ALL}

libtesla.so: ${OBJ}
	${CC} -shared -o libtesla.so ${OBJ}

tesla_state.o: tesla_state.c
	${CC} -c ${CFLAGS} -o tesla_state.o tesla_state.c
tesla_state_global.o: tesla_state_global.c
	${CC} -c ${CFLAGS} -o tesla_state_global.o tesla_state_global.c
tesla_state_perthread.o: tesla_state_perthread.c
	${CC} -c ${CFLAGS} -o tesla_state_perthread.o tesla_state_perthread.c
tesla_registration.o: tesla_registration.c
	${CC} -c ${CFLAGS} -o tesla_registration.o tesla_registration.c
tesla_util.o: tesla_util.c
	${CC} -c ${CFLAGS} -o tesla_util.o tesla_util.c

clean:
	rm -f ${ALL}

