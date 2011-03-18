#!/bin/bash
set -e

TRIES=10
SSH_FLAGS=
TIME=/usr/bin/time

function run_test {
  SSH=$1
  OUT=$2
  rm -f ${OUT}
  for i in `jot ${TRIES}`; do
    dd count=1024 bs=1m if=/dev/zero 2>> ${OUT} | ${SSH} ${SSH_FLAGS} localhost "cat > /dev/zero"
  done
}

run_test ./openssh-5.8p1-with-clang-tesla/ssh clang_tesla
run_test ./openssh-5.8p1-with-clang-notesla/ssh clang_notesla
run_test ./openssh-5.8p1-with-gcc/ssh gcc_notesla
