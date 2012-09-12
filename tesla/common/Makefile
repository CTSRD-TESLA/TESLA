all: build

build: cmake
	ninja

clean:
	ninja -t clean

distclean:
	rm -rf CMakeCache.txt CMakeFiles *.cmake *.ninja .ninja_log *.o *.d *.a

cmake: CMakeCache.txt

doc:
	cd ../.. && ${MAKE} doc

CMakeCache.txt: CMakeLists.txt
	cmake \
		-G Ninja \
		-DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
		-DCMAKE_CXX_FLAGS="-Wno-c++11-extensions" \
		.

