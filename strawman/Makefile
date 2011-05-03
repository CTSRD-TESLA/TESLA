.DEFAULT: all
.PHONY: all clean

CC = ../kernel/tesla-clang -DTESLA_INCLUDE_ASSERTIONS
LD = ../kernel/tesla-clang

CFLAGS = -g -Wall -I ..

UNITS = caller syscalls generated
## Include if not using automatically generated instrumentation
#   _instrumentation

OBJ = $(UNITS:=.o)


all: test

clean:
	rm -f test *.bc *.ll *.o *.c-tesla.h

## On every build, if generated.spec has been changed, copy it
## to instrumentation.spec but if generated.spec does not exist,
## create an empty file 
instrumentation.spec:
	if [ -e generated.spec -a -e $@ ] \
            && ! cmp -s generated.spec $@; then \
          echo generated.spec has changed, copying to $@; \
          cp generated.spec $@; \
        elif [ ! -e $@ ]; then \
          echo generated.spec and $@ do not exist, creating blank $@; \
          touch $@; \
        fi
## Force this to be run even if instrumentation.spec exists
.PHONY: instrumentation.spec

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

