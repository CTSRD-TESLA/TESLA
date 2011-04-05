SSH automata assertions
=======================

Pre-requisites
--------------
Build ../../libtesla, and ../../cfa (see documentation in those
directories).
A SSH server running on localhost: for running performance experiment
ocaml, R, ps2pdf: for processing results and generating graphs

Building
--------
Build libteslassh.a and libfaketeslassh.a:
$ make

Using libteslassh.a and libfaketeslassh.a, build OpenSSH:
$ ./build_openssh
If there is a problem with differing versions of the OpenSSL header files
and library, this ./configure check can be disabled:
$ CONFIGFLAGS=--without-openssl-header-check ./build_openssh.sh

Running the test
----------------
Make sure that the following command runs successfully and requires no
user input:
$ dd count=1024 bs=1024 if=/dev/zero 2>> /dev/null | ssh \
  localhost "cat > /dev/zero"
You may need to run this twice (to put localhost in known_hosts), start
a SSH server on localhost, and/or add your public key to
~/.ssh/authorized_keys.

Run the tests
$ ./run_test.sh
Results will be placed in results/res_*

Process the results
-------------------
Parse the results and generate graph:
$ make sshperf.pdf
