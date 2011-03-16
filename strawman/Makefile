.DEFAULT: all
.PHONY: all clean


TESLA = -load lib/TeslaInstrumenter.so -add-plugin tesla -plugin-arg-tesla strawman.spec
TESLA_PASSTHROUGH = $(TESLA:%=-Xclang %)

CC = clang
CXX = clang++
CFLAGS = -g -Wall $(TESLA_PASSTHROUGH)

LD = clang

UNITS = caller syscalls _instrumentation
OBJ = $(UNITS:=.o)


all: test

clean:
	rm -f test *.bc *.ll *.o *.c-tesla.h

test: $(OBJ)
	$(LD) -o $@ $^


# LLVM IR for inspection
all: syscalls.ll
syscalls.ll: syscalls.c
	$(CC) -emit-llvm -o $@ -S $^


# Clang-generated declarations of instrumentation
_instrumentation.o: syscalls.c-tesla.h
syscalls.c-tesla.h: syscalls.o

