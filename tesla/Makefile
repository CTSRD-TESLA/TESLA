.PHONY: build clean cmake

build: cmake
	cd build && ninja

clean:
	rm -rf build

cmake: build/CMakeCache.txt

doc:
	cd .. && ${MAKE} doc

build/CMakeCache.txt: CMakeLists.txt
	mkdir -p build
	cd build && cmake \
		-G Ninja \
		-DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
		..

