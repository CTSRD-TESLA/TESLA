.DEFAULT: all
.PHONY: all clean

CC = ../kernel/tesla-clang -DTESLA_INCLUDE_ASSERTIONS
LD = ../kernel/tesla-clang

CFLAGS = -g -Wall -I ..

UNITS = instrumentation caller syscalls
## Include if not using automatically generated instrumentation
#   _instrumentation

OBJ = $(UNITS:=.o)


all: instrumentation
	## First create or copy instrumentation.c/.spec if needed
	## then actually build the application. We need to do this
	## in a new make instance, as otherwise make won't realize
	## that instrumentation.c was created after it started
	make -C . test

clean:
	rm -f test *.bc *.ll *.o *.c-tesla.h \
	  generated.c generated.spec instrumentation.spec \
	  instrumentation.c

## Create $(1) from $(2), if ($2) exists and is different from $(1),
## but if neither $(1) nor $(2) exist, create $(1) from a blank file
copy_changed_file = \
	if [ -e $(2) -a -e $(1) ] \
            && ! cmp -s $(2) $(1); then \
          echo $(2) has changed, copying to $(1); \
          cp $(2) $(1); \
        elif [ ! -e $(1) ]; then \
          echo $(2) and $(1) do not exist, creating blank $(1); \
          touch $(1); \
        fi

## On every build, if generated.spec/.c has been changed, copy it
## to instrumentation.spec/.c but if generated.spec/.c does not exist,
## create an empty file 
instrumentation:
	$(call copy_changed_file,instrumentation.spec,generated.spec)
	$(call copy_changed_file,instrumentation.c,generated.c)
## Force this to be run even if instrumentation.spec exists
.PHONY: instrumentation

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

