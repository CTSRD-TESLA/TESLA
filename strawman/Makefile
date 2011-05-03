.DEFAULT: all
.PHONY: all clean

CC = ../kernel/tesla-clang -DTESLA_INCLUDE_ASSERTIONS
LD = ../kernel/tesla-clang

CFLAGS = -g -Wall -I ..

UNITS = caller syscalls _instrumentation
OBJ = $(UNITS:=.o)


all: test

clean:
	rm -f test *.bc *.ll *.o *.c-tesla.h

test: $(OBJ)
	$(LD) -o $@ $^

syscalls.o: ../tesla/tesla.h


# LLVM IR for inspection
all: syscalls.ll
syscalls.ll: syscalls.c
	$(CC) $(CFLAGS) -emit-llvm -o $@ -S $^


# Clang-generated declarations of instrumentation
syscalls.o: instrumentation.spec
_instrumentation.o: syscalls.c-tesla.h
syscalls.c-tesla.h: syscalls.o

