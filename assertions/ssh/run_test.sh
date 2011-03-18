#!/bin/bash
set -e

TRIES=10
SSH_FLAGS=
TIME=/usr/bin/time

function run_test {
  SSH=$1
  OUT=$2
  rm -f ${OUT}
  echo start: ${SSH} to ${OUT} 
  for i in `jot ${TRIES}`; do
    echo -n .
    dd count=1024 bs=1k if=/dev/zero 2>> ${OUT} | ${SSH} ${SSH_FLAGS} localhost "cat > /dev/zero"
  done
  echo done
}

run_test ./openssh-5.8p1-with-clang-tesla/ssh res_clang_tesla
run_test ./openssh-5.8p1-with-clang-faketesla/ssh res_clang_notesla
run_test ./openssh-5.8p1-with-gcc/ssh res_gcc_notesla
