#!/bin/sh

BUILD_DIR=${BUILD_DIR:-build}

args() {
  for flag in "$@"; do
    case "$flag" in
      --no-update)
        NOUPDATE=1
        ;;
      --use-libc++)
        LIBCPP=1
        ;;
      *)
        echo Unknown parameter $flag
        exit 1
    esac
    shift
  done
}
args "$@"

LIBCPP_CXX_FLAGS="-std=c++11 -stdlib=libc++"
CXXFLAGS="${CXXFLAGS} ${LIBCPP:+$LIBCPP_CXX_FLAGS}"

# Default to Clang.
if [ "$CC" == "gcc" ]; then
	CXX=g++
else
	CC=clang
	CXX=clang++
    CFLAGS="${CFLAGS} -fcolor-diagnostics"
    CXXFLAGS="${CXXFLAGS} -fcolor-diagnostics"
fi

# Use the 'ninja' build tool by default, but allow 'make' for the non-ninja.
if [ "$MAKE" == "make" ]; then
	GENERATOR="Unix Makefiles"
else
	MAKE="ninja"
	GENERATOR="Ninja"
fi

# If we don't have an LLVM directory, go get one. If we do, update it.
if [ ! -d llvm ]; then
  git clone http://github.com/CTSRD-TESLA/llvm.git
  cd llvm/tools
  git clone http://github.com/CTSRD-TESLA/clang
  cd ../../
elif [ -z "$NOUPDATE" ]; then
  cd llvm
  git pull
  cd tools/clang
  git pull
  cd ../../..
fi

# Build out of tree.
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

if [ -f CMakeCache.txt ]; then
	# CMake has already been run. No need to explicitly run it again: its
	# previously-generated makefiles will take care of that if needed.
	:
else
	cmake -G "$GENERATOR" \
		-D CMAKE_C_COMPILER=${CC} -D CMAKE_CXX_COMPILER=${CXX} \
        -D CMAKE_C_FLAGS="${CFLAGS}" -D CMAKE_CXX_FLAGS="${CXXFLAGS}" \
		../llvm
fi

echo "Build with $MAKE..."
$MAKE
