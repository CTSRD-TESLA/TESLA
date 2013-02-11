Getting started with TESLA
================================================================================

Step 0: Get some pre-requisites.
--------------------------------------------------------------------------------
Install git, cmake, ninja (or make if you prefer) and a compiler.

If you're using CMake on a Mac, be aware that the default Homebrew-provided
version does not support Ninja file generation. This is easy to fix, though:
$ brew install cmake --enable-ninja

You will also need the Google Protocol Buffers library, which is available as a
binary package for at least:

 - FreeBSD (`pkg install protobuf` / `pkg_add -r protobuf`)
 - Mac OS X w/Homebrew (`brew install protobuf`)
 - Ubuntu (`apt-get install protobuf-dev`)
 - Fedora (`yum install protobuf`)


Step 1: Build and install a recent version of LLVM and Clang.
--------------------------------------------------------------------------------
You can install it wherever you like (see the use of PREFIX below), but you
must install it somewhere so that llvm-config will work correctly.
Note that the default compiler that ships with e.g. XCode is not enough: we
need recent LLVM and Clang libraries to link against.

$ cd somewhere/to/stash/1GB/of/LLVM
$ git clone http://llvm.org/git/llvm.git
Cloning into 'llvm'...
remote: Counting objects: 715099, done.
remote: Compressing objects: 100% (137115/137115), done.
remote: Total 715099 (delta 582823), reused 704650 (delta 574123)
Receiving objects: 100% (715099/715099), 114.45 MiB | 1.11 MiB/s, done.
Resolving deltas: 100% (582823/582823), done.
Checking out files: 100% (10285/10285), done.

$ cd llvm/tools
$ git clone http://llvm.org/git/clang.git
Cloning into 'clang'...
remote: Counting objects: 385592, done.
[...]

$ cd ../..
$ mkdir build
$ cd build
$ cmake -DCMAKE_BUILD_TYPE=Release -G Ninja ../llvm
-- The C compiler identification is [...]
-- Check for working C compiler using: Ninja
-- Check for working C compiler using: Ninja -- works
[...]
-- Generating done
-- Build files have been written to: /home/jonathan/LLVM/build

$ ninja install
[1932/1932] Install the project...
-- Install configuration: "Release"
-- Installing: /usr/local/include
-- Installing: /usr/local/include/llvm-c
[...]

$ llvm-config --cxxflags                 # Make sure everything's working


Step 2: Build TESLA
--------------------------------------------------------------------------------
$ git clone https://github.com/CTSRD-TESLA/TESLA.git
$ Cloning into 'TESLA'...
remote: Counting objects: 3138, done.
[...]

$ make
-- The C compiler identification is [...]
[...]
-- Build files have been written to: [...]
[46/46] Linking CXX executable tesla/analyser/tesla-analyser


Step 4: Run TESLA
--------------------------------------------------------------------------------
Try running TESLA on the supplied 'strawman' example.

$ cd strawman
$ make run-tesla

