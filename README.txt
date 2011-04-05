Getting started
===============

Pre-requisites
--------------
Install git, gcc, g++, cmake, make

Build clang and LLVM
--------------------
$ ./build_clang.sh 

This will check out clang and LLVM if needed. Building will take
a while (a couple of hours on my laptop).

Build strawman
--------------
$ cd strawman
$ make

Test strawman
-------------
$ ./test