IDENT=`uname -i`
RUNS=1
RESULTS_DIR=`pwd`/results
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
