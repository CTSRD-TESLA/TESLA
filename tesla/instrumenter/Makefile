.PHONY: build clean cmake

build: cmake
	ninja

clean:
	rm -rf CMakeCache.txt CMakeFiles *.cmake *.ninja .ninja_log *.dylib *.so

cmake: CMakeCache.txt

CMakeCache.txt: CMakeLists.txt
	cmake \
		-G Ninja \
		-DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
		-DCMAKE_CXX_FLAGS="-Wno-c++11-extensions" \
		.

