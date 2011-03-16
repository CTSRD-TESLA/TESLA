#!/bin/sh
# Build our patched LLVM/CLANG
# Run from ctsrd.svn/tesla/trunk

if [ ! -d llvm ]; then
  git clone http://github.com/trombonehero/llvm
  cd llvm/tools
  git clone http://github.com/trombonehero/clang
  cd ../../
else 
  cd llvm
  git pull
  cd tools/clang
  git pull
  cd ../../..
fi

mkdir -p build
cd build
cmake -j5 -DCLANG_BUILD_EXAMPLES=true ../llvm
make
