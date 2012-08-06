.PHONY: check-syntax run-tesla tesla

TESLA_DIR=../tesla
TESLA=${TESLA_DIR}/tesla
EXAMPLE=example.c

CC=clang -D TESLA
CFLAGS=-I ../include/tesla

PARSE=${CC} -fsyntax-only ${CFLAGS}

all: ${TESLA} check-syntax

tesla:
	cd ${TESLA_DIR} && make

check-syntax: ${EXAMPLE}
	${PARSE} ${EXAMPLE}

run-tesla: tesla check-syntax
	${TESLA} ${EXAMPLE} -- ${PARSE}

