#!/bin/sh

# Default to Clang.
if [ "$CC" == "gcc" ]; then
	CXX=g++
else
	CC=clang
	CXX=clang++
fi

# Use the 'ninja' build tool by default, but allow 'make' for the non-ninja.
if [ "$MAKE" == "make" ]; then
	GENERATOR="-G 'Unix Makefiles'"
else
	MAKE="ninja"
	GENERATOR="-G Ninja"
fi

# If we don't have an LLVM directory, go get one. If we do, update it.
if [ ! -d llvm ]; then
  git clone http://github.com/CTSRD-TESLA/llvm.git
  cd llvm/tools
  git clone http://github.com/CTSRD-TESLA/clang
  cd ../../
elif [ "$1" != "--no-update" ]; then
  cd llvm
  git pull
  cd tools/clang
  git pull
  cd ../../..
fi

# Build out of tree.
mkdir -p build
cd build

if [ -f CMakeCache.txt ]; then
	# CMake has already been run. No need to explicitly run it again: its
	# previously-generated makefiles will take care of that if needed.
	:
else
	cmake $GENERATOR \
		-D CMAKE_C_COMPILER=${CC} -D CMAKE_CXX_COMPILER=${CXX} \
		../llvm
fi

echo "Build with $MAKE..."
$MAKE
