#!/bin/bash
set -e

TRIES=10
SIZE="50k 100k 150k 200k 250k 300k 350k 400k 450k 500k 550k 600k 650k 700k 750k 800k 850k 900k 950k 1000k"
RESULTS="results"
SSH_FLAGS=

function run_test {
  SSH=$1
  OUT=$2
  rm -f ${OUT}
  echo start: ${SSH} to ${OUT} 
  for i in `jot ${TRIES}`; do
    for sz in ${SIZE}; do
      echo -n "${i}:${sz} "
      OFILE="${OUT}.${sz}"
      dd count=1024 bs=${sz} if=/dev/zero 2>> ${OFILE} | ${SSH} ${SSH_FLAGS} localhost "cat > /dev/zero"
    done
  done
  echo done
}

run_test ./openssh-5.8p1-with-clang-tesla/ssh ${RESULTS}/res_clang_tesla
run_test ./openssh-5.8p1-with-clang-faketesla/ssh ${RESULTS}/res_clang_notesla
run_test ./openssh-5.8p1-with-gcc/ssh ${RESULTS}/res_gcc_notesla
