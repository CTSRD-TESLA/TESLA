.PHONY: build clean cmake test
.SILENT:

all: build test
	cd strawman && ${MAKE}

build: cmake
	cd build && ninja

clean:
	(cd build && ninja -t clean) || rm -rf build
	rm -rf doxygen

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
		-DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
		-DCMAKE_BUILD_TYPE=Debug \
		..

