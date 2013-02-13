.PHONY: build clean debug release test
.SILENT:

# Variables that can be overriden with environment variables.
CC?=clang
CXX?=clang++

CFLAGS?=-fcolor-diagnostics
CXXFLAGS?=-fcolor-diagnostics

CMAKE_FLAGS=-G Ninja \
	-DCMAKE_C_FLAGS="${CFLAGS}" \
	-DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
	-DCMAKE_C_COMPILER=${CC} -DCMAKE_CXX_COMPILER=${CXX}


all: build test
	cd strawman && ${MAKE}

build: debug release

clean:
	(cd Debug && ninja -t clean) || rm -rf Debug
	(cd Release && ninja -t clean) || rm -rf Release
	rm -rf doxygen
	cd strawman && ${MAKE} clean

debug: Debug/CMakeCache.txt
	cd Debug && ninja

release: Release/CMakeCache.txt
	cd Release && ninja

doc: Doxyfile
	mkdir -p doxygen
	doxygen $?

test: Debug Release
	BUILD_DIR=Debug ./run-tests
	BUILD_DIR=Release ./run-tests

Debug/CMakeCache.txt:
	mkdir -p Debug
	cd Debug && cmake ${CMAKE_FLAGS} -DCMAKE_BUILD_TYPE=Debug ..

Release/CMakeCache.txt:
	mkdir -p Release
	cd Release && cmake ${CMAKE_FLAGS} -DCMAKE_BUILD_TYPE=Release ..

