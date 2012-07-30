.PHONY: build clean test

BUILD_DIR=../build
TESLA=${BUILD_DIR}/bin/tesla
EXAMPLE=example.c

build:
	cd ${BUILD_DIR} && ninja

tesla: build
	${TESLA} ${EXAMPLE} -- clang -D TESLA -fsyntax-only

