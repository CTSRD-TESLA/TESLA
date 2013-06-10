.SUFFIXES: .c .dot .ll .pdf .tesla
.DEFAULT: all
#.SILENT:

BASE=openssl-api
.PRECIOUS: ${BASE}.dot

CC=clang

CFLAGS	+= -Wall -g -ggdb -I ${TESLA_SOURCE_DIR}/include
LDFLAGS	+= -L ${TESLA_BUILD_DIR}/libtesla/src -l crypto -l ssl -l tesla

RESOURCE_DIR=-resource-dir `llvm-config --libdir`/clang/3.3


all: ${BASE}

clean:
	rm -f ${BASE} *.dot *.ll *.o *.tesla *.pdf


#
# Normal C workflow:
#
${BASE}: ${BASE}.instr.o
	${CC} ${LDFLAGS} $< -o $@

.c.ll:
	${CC} -S -emit-llvm ${CFLAGS} $< -o $@

.ll.o:
	llc -filetype=obj $< -o $@


#
# TESLA-specific rules:
#

# TESLA analysis (C -> TESLA IR)
.c.tesla:
	tesla analyse $< -o $@ -- ${CFLAGS} ${RESOURCE_DIR}
	sed -i.backup "s@`pwd`/@@" $@ && rm $@.backup

# Pretty visualisation (TELSA IR -> GraphViz)
.tesla.dot:
	tesla graph $< -o $@

# TESLA instrumentation (LLVM IR --TESLA IR--> instrumented LLVM IR)
${BASE}.instr.ll: ${BASE}.ll ${BASE}.tesla
	tesla instrument -S $< -tesla-manifest ${BASE}.tesla -o $@


#
# Other non-TESLA-specific rules:
#

# Pretty visualisation (GraphViz -> PDF)
.dot.pdf:
	dot -Tpdf $< -o $@

