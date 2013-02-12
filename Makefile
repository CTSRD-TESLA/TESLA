.PHONY: build clean cmake test
.SILENT:

# Variables that can be overriden with environment variables.
BUILD_TYPE?=Debug

CC?=clang
CXX?=clang++

CFLAGS?=-fcolor-diagnostics
CXXFLAGS?=-fcolor-diagnostics


all: build test
	cd strawman && ${MAKE}

build: cmake
	cd build && ninja

clean:
	(cd build && ninja -t clean) || rm -rf build
	rm -rf doxygen
	cd strawman && ${MAKE} clean

cmake: build/CMakeCache.txt

doc: Doxyfile
	mkdir -p doxygen
	doxygen $?

test: build
	./run-tests

build/CMakeCache.txt: CMakeLists.txt
	mkdir -p build
	cd build && cmake \
		-G Ninja \
		-DCMAKE_C_FLAGS="${CFLAGS}" \
		-DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
		-DCMAKE_C_COMPILER=${CC} -DCMAKE_CXX_COMPILER=${CXX} \
		-DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
		..

