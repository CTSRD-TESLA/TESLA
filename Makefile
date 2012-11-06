.PHONY: build clean cmake

build: cmake
	cd build && ninja

clean:
	(cd build && ninja -t clean) || rm -rf build
	rm -rf doxygen

cmake: build/CMakeCache.txt

doc: Doxyfile
	mkdir -p doxygen
	doxygen $?

build/CMakeCache.txt: CMakeLists.txt
	mkdir -p build
	cd build && cmake \
		-G Ninja \
		-DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
		-DCMAKE_BUILD_TYPE=Debug \
		..

