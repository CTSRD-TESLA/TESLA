.SUFFIXES: .c .dot .ll .pdf .tesla
.DEFAULT: all
#.SILENT:

BASE=openssl-api
.PRECIOUS: ${BASE}.dot

CC?=clang
LLC?=llc

CFLAGS	+= -Wall -I ${TESLA_SOURCE_DIR}/include
LDFLAGS	+= -L ${TESLA_BUILD_DIR}/libtesla/src -l crypto -l ssl -l tesla

CLANG_VERSION=`${CLANG} --version | grep version | awk '{ print $$3 }'`
RESOURCE_DIR=-resource-dir `llvm-config --libdir`/clang/${CLANG_VERSION}


all: ${BASE}

clean:
	rm -f ${BASE} *.dot *.ll *.o *.tesla *.pdf


#
# Normal C workflow:
#
${BASE}: ${BASE}.instr.o
	${CC} ${LDFLAGS} ${BASE}.instr.o -o $@

.c.ll:
	${CC} -S -emit-llvm ${CFLAGS} $< -o $@

.ll.o:
	${LLC} -filetype=obj $< -o $@


#
# TESLA-specific rules:
#

# TESLA analysis (C -> TESLA IR)
.c.tesla:
	tesla analyse -S $< -o $@ -- ${CFLAGS} ${RESOURCE_DIR}
	sed -i.backup "s@`pwd`/@@" $@ && rm $@.backup

# Pretty visualisation (TELSA IR -> GraphViz)
.tesla.dot:
	tesla graph $< -o $@

# TESLA instrumentation (LLVM IR --TESLA IR--> instrumented LLVM IR)
${BASE}.instr.ll: ${BASE}.ll ${BASE}.tesla
	tesla instrument -S ${BASE}.ll -tesla-manifest ${BASE}.tesla -o $@


#
# Other non-TESLA-specific rules:
#

# Pretty visualisation (GraphViz -> PDF)
.dot.pdf:
	dot -Tpdf $< -o $@

