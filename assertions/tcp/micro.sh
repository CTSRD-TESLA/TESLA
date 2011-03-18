#!/bin/sh
# Run micro benchmarks at -O0 -O1 -O2 and -O3

OPTLEVELS="0 1 2 3"
RUNS=50

rm -f micro.results
for o in ${OPTLEVELS}; do
	make clean
	make OPTLEVEL="-O${o}" micro
	for mode in instr_gcc instr_clang_instr_tesla instr_clang_instr_faketesla instr_clang_noinstr; do
		RES="${mode} ${o}"
		for run in `jot ${RUNS}`; do
			tm=`./${mode}`
			RES="${RES} ${tm}"
		done
		echo "${RES}" >> micro.results
	done
done
