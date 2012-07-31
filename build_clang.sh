#!/bin/sh
# Build our patched LLVM/CLANG
# Run from ctsrd.svn/tesla/trunk

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

mkdir -p build
cd build

# For now, we need to disable C++11 warnings with CLANG_CXX_FLAGS.
#
# Once compilers catch up in all of the bootstrap environments that we care
# about, we can just enable C++11 ("-std=c++11 -stdlib=libc++"). In the
# meantime, we can just disable warnings and use the most obvious bits of
# C++11, like auto type inference.
cmake -GNinja \
	-DCLANG_BUILD_EXAMPLES=true \
	-DCLANG_CXX_FLAGS="-Wno-c++11-extensions" \
	../llvm
ninja
