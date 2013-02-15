Getting started with TESLA
================================================================================

Detailed build instructions for TESLA can be found at:
http://www.cl.cam.ac.uk/research/security/ctsrd/tesla.html

For the impatient, however...


Step 0: Get some pre-requisites.
--------------------------------------------------------------------------------
Install Git, Subversion, Ninja, CMake (with Ninja support), a C++ compiler and the Google Protocol Buffers library (C++ version).

If you're using CMake on a Mac, be aware that the default Homebrew-provided
version does not support Ninja file generation. This is easy to fix, though:
$ brew install cmake --enable-ninja


Step 1: Build and install a recent version of LLVM and Clang.
--------------------------------------------------------------------------------
$ cd somewhere/to/stash/1GB/of/LLVM
$ svn co http://llvm.org/svn/llvm-project/llvm/trunk llvm
[...]
 U   llvm
Checked out revision 175226.

$ cd llvm/tools
$ svn co http://llvm.org/svn/llvm-project/cfe/trunk clang
[...]
A    clang/LICENSE.TXT
 U   clang
Checked out revision 175226.

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

$ cmake -D CMAKE_BUILD_TYPE=Release .    # if you feel adventurous
$ ninja
[1932/1932] Linking CXX executable bin/c-index-test

$ export PATH=/path/to/LLVM/build/bin:$PATH
$ llvm-config --src-root                 # should point to LLVM source


Step 2: Build TESLA
--------------------------------------------------------------------------------
$ git clone https://github.com/CTSRD-TESLA/TESLA.git tesla
Cloning into 'TESLA'...
remote: Counting objects: 3138, done.
[...]

$ cd tesla
$ mkdir build
$ cmake -G Ninja -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ ..
-- The C compiler identification is Clang 3.3.0
-- Check for working C compiler using: Ninja
-- Check for working C compiler using: Ninja -- works
-- Detecting C compiler ABI info
[...]
-- Found PROTOBUF: /usr/local/lib/libprotobuf.so
-- Configuring done
-- Generating done
-- Build files have been written to: /home/jonathan/TESLA/build

$ ccmake . # nice UI for further configuration, or else:
$ cmake -D USE_LIBCXX=false .  # if you have libc++ but didn't link LLVM against it
$ cmake -D CMAKE_C_FLAGS=-fcolor-diagnostics .       # optional but nice
$ cmake -D CMAKE_CXX_FLAGS=-fcolor-diagnostics .     # optional but nice

$ ninja
[48/48] Linking CXX executable tesla/instrumenter/tesla-instrument

$ cd ..
$ ./run-tests
[... possibly-verbose output from debug-mode tests ...]
Passed 4/4 tests


Step 4: Run TESLA
--------------------------------------------------------------------------------
$ cd strawman
$ export LD_LIBRARY_PATH=../build/libtesla/src   # or 'ninja install' in ../build
$ make && ./demo
TESLA demo application; version 3454895 (dirty)

Calling the 'example_syscall' function...
[CALR] example_syscall 0x7fff5b7ab7a8 0 0
[CALE] example_syscall 0x7fff5b7ab7a8 0 0
[RETE] security_check 0x7fff5b7ab7a8 0x104456020 0 0
[RETR] security_check 0x7fff5b7ab7a8 0x104456020 0 0
[RETE] some_helper 0 0
[RETR] some_helper 0 0
[CALR] void_helper 0x104456020
[CALE] void_helper 0x104456020
[RETE] void_helper 0x104456020
[RETR] void_helper 0x104456020
[NOW]  automaton 0 71655456 0
[RETE] example_syscall 0x7fff5b7ab7a8 0 0 0
[RETR] example_syscall 0x7fff5b7ab7a8 0 0 0
'example_syscall' returned 0


This just shows that the 'demo' application runs normally. If, however, you comment out line 78 of example.c (which calls the security_check() function):

 --- a/strawman/example.c
+++ b/strawman/example.c
@@ -75,7 +75,7 @@ example_syscall(struct credential *cred, int index, int op)
        int error;
        struct object *o = objects + index;

-       if ((error = security_check(cred, o, op))) return error;
+//     if ((error = security_check(cred, o, op))) return error;
        some_helper(op);
        void_helper(o);
        perform_operation(op, o);

... you should see an error when you run the 'demo' application:

 $ make && ./demo
TESLA demo application; version 3454895 (dirty)

Calling the 'example_syscall' function...
[...]
[NOW]  automaton 0 245383200 0
demo: tesla_assert_failed: unable to move 'example.c:42#0' 2->3: current state is 1
This shows that, when we reach the assertion site for automaton 0, we detect that a transition (the security_check event) was missed!

