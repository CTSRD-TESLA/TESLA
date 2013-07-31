.PHONY: all clean

# The location of TESLA outputs (binaries, libraries, etc.).
# Only needed when we don't install TESLA to /usr/local.
TESLA_SOURCE_DIR?=../..
TESLA_BUILD_DIR?=${TESLA_SOURCE_DIR}/build

CC=		clang
LINK=		clang
TESLA=		tesla

CFLAGS+=	-Wall -g -ggdb -I ${TESLA_SOURCE_DIR}/include
LDFLAGS+=	-L ${TESLA_BUILD_DIR}/libtesla/src -l tesla


all: instrcost

clean:
	rm -f instrcost *.ll *.tesla

instrcost: main.instr.ll
	${LINK} ${LDFLAGS} -o instrcost main.instr.ll

main.instr.ll: main.ll main.tesla
	${TESLA} instrument -S -tesla-manifest main.tesla -o main.instr.ll main.ll

main.tesla: main.c
	${TESLA} analyse -o main.tesla main.c -- ${CFLAGS}
#	# temporary workaround for ClangTool irritant:
	sed -i.backup "s@`pwd`/@@" main.tesla && rm main.tesla.backup

main.ll: main.c
	${CC} ${CFLAGS} -c -S -emit-llvm -o main.ll main.c
