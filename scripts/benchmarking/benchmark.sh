IDENT=`uname -i`
RUNS=10
RESULTS_DIR=`pwd`/results
if [ ! -d results]
	mkdir results
fi

# warm the disk cache
echo
echo Warming the disk cache for walkTree benchmark
sh walkTree.sh > /dev/null
echo Running walkTree benchmark..
for I in `seq ${RUNS}` ; do
	echo -n "$I..."
        time sh walkTree.sh 2>&1 | tail -1 >> ${RESULTS_DIR}/walkTree.${IDENT}.log
done
# warm the disk cache
echo
echo Warming the disk cache for uniqMan benchmark
sh uniqMan.sh > /dev/null
echo Running uniqMan benchmark..
for I in `seq ${RUNS}` ; do
	echo -n "$I..."
        time sh uniqMan.sh 2>&1 | tail -1 >> ${RESULTS_DIR}/uniqMan.${IDENT}.log
done
# warm the disk cache
echo
echo Warming the disk cache for quota benchmark
sh quota.sh > /dev/null
echo Running quota benchmark..
for I in `seq ${RUNS}` ; do
	echo -n "$I..."
        time sh quota.sh 2>&1 | tail -1 >> ${RESULTS_DIR}/quota.${IDENT}.log
done
cd llvm-3.3/Build
# warm the cache
echo
echo Warming the disk cache for LLVM benchmark
ninja  2>&1 >/dev/null
ninja  clean 2>&1 >/dev/null
echo Running LLVM benchmark...
# try building LLVM for benchmarking
for I in `seq ${RUNS}` ; do
	echo -n "$I..."
        time ninja  2>&1 | tail -1 >> ${RESULTS_DIR}/llvm_build.${IDENT}.log
        time ninja  clean 2>&1 | tail -1 >> ${RESULTS_DIR}/llvm_clean.${IDENT}.log
done
echo
if [ ! -d ports ] ; then
        echo Checking out the ports tree (should only need to be done once)
	# Check out the head revision at the time when we do the benchmarking
	# Revision hard-coded for reproducability
        svn co -r323526 http://svn.freebsd.org/ports/head ports
fi
echo Warming the disk cache for ports benchmark
export PORTSDIR=`pwd`
make index
rm INDEX-10
for I in `seq ${RUNS}` ; do
	echo -n "$I..."
        time make index 2>&1 | tail -1 >> ${RESULTS_DIR}/ports_index.${IDENT}.log
	rm INDEX-10
done
echo
echo Running lmbench tests
cd lmbench/scripts
OS=`./os`
CONFIG=`./config`
RESULTS=results/$OS/
BASE=../$RESULTS/`uname -n`

for I in `seq ${RUNS}` ; do
	echo -n "$I..."
	#./results
done
if [ ! -d ${RESULTS_DIR}/lmbench/${IDENT}/ ] ; then
	mkdir -p ${RESULTS_DIR}/lmbench/${IDENT}/
fi
mv ${BASE}* ${RESULTS_DIR}/lmbench/${IDENT}/
