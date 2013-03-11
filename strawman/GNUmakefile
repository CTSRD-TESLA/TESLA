.PHONY: clean tesla
.SUFFIXES: .c .dot .ll .pdf .tesla

# The location of TESLA outputs (binaries, libraries, etc.).
# Only needed when we don't install TESLA to /usr/local.
BUILD_DIR?=../build

# For our demo handcoded LLVM IR, we need to assign an arch-vendor-OS triple.
# Normal consumers don't need to do this.
TRIPLE:=	$(shell ${BUILD_DIR}/tesla/tools/llvm-triple/llvm-triple)
LLC=llc -mtriple=${TRIPLE} -filetype=obj

CC=		clang
LINK=		clang

REVISION:=	$(shell ./revision.sh)
CFLAGS+=	-Wall -D TESLA -D REVISION="${REVISION}" \
		-Wno-deprecated-declarations	# DES_set_key() is deprecated
LIBS+=		-l crypto -l tesla

BIN=		demo

# tesla.mk will create OBJS for instrumented .o files from SRCS and IR.
SRCS=	crypto.c example.c support.c main.c
IR=	handcoded.ll


all: tesla tesla.dot ${BIN}

clean:
	rm -f ${BIN} ${SRCS:.c=.ll} ${OBJS} ${TESLA_ALLFILES}

tesla:
	cd ${BUILD_DIR} && ninja


#
# Include TESLA build rules from tesla.mk (with some preparation):
#

# Just in case TESLA isn't installed to /usr/local:
CFLAGS+=	-I ../include
LIBS+=		-L ${BUILD_DIR}/libtesla/src

# For some reason, setting PATH interoperates poorly with the Bourne shell (sh):
# if we set it to ../build/foo:../build:bar:${PATH}, tesla.mk can only run
# tools in ../build/foo.
#
# Again, none of this is necessary when TESLA is installed in /usr/local.
SHELL:=bash
PATH:=	${BUILD_DIR}/tesla/analyser:${BUILD_DIR}/tesla/instrumenter:${BUILD_DIR}/tesla/tools/graph:${PATH}

include tesla.mk

# Hold onto all LLVM IR files for manual inspection.
# Just for TESLA development: real consumers don't need to do this.
.PRECIOUS: ${TESLA_IR}


# Poor man's dependency tracking.
example.tesla: example.c tcp.h


#
# Finally, normal suffix rules:
#

# Compile C code to LLVM IR.
.c.ll:
	${CC} ${CFLAGS} -S -emit-llvm $< -o $@

# Compile IR to object code.
.ll.o:
	${LLC} $< -o $@

# Build the demo application.
${BIN}: ${OBJS}
	${LINK} -o $@ ${OBJS} ${LIBS}

