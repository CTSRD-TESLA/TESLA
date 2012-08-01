.PHONY: check-syntax run-tesla tesla

BUILD_DIR=../build
TESLA=${BUILD_DIR}/bin/tesla
EXAMPLE=example.c

CC=clang -D TESLA
PARSE=${CC} -fsyntax-only

all: ${TESLA} check-syntax

tesla:
	cd ${BUILD_DIR} && ninja

check-syntax: ${EXAMPLE}
	${PARSE} ${EXAMPLE}

run-tesla: tesla check-syntax
	${TESLA} ${EXAMPLE} -- ${PARSE}

