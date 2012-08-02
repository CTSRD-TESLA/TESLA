Getting started with TESLA
================================================================================

Step 0: Get some pre-requisites.
--------------------------------------------------------------------------------
Install git, cmake, ninja (or make if you prefer) and a compiler.

If you're using CMake on a Mac, be aware that the default Homebrew-provided
version does not support Ninja file generation. This is easy to fix, though:
$ brew install cmake --enable-ninja


Step 1: Build and install a recent version of LLVM and Clang.
--------------------------------------------------------------------------------
You can install it wherever you like (see the use of PREFIX below), but you
must install it somewhere so that llvm-config will work correctly.
Note that the default compiler that ships with e.g. XCode is not enough: we
need LLVM and Clang libraries to link against.

$ cd ../somewhere/to/stash/1GB/of/LLVM
$ PREFIX="/optional/install/prefix" ${TESLA}/scripts/build_clang.sh

This will check out clang and LLVM if needed. Building will take about a
half hour of CPU time. Next, install it and (if necessary) adjust your PATH:

$ cd build && ninja install              # Or 'make install' for non-ninja
$ export PATH=${LLVM_PREFIX}/bin:$PATH   # Only if you've customised PREFIX
$ llvm-config --cxxflags                 # Make sure everything's working


Step 2: Build TESLA
--------------------------------------------------------------------------------
$ cd ${TESLA}/tesla
$ make


Step 3: Run TESLA
--------------------------------------------------------------------------------
Try running TESLA on the supplied 'strawman' example.

$ cd strawman
$ make run-tesla

