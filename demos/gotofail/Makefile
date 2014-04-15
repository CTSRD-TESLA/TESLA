.SUFFIXES: .c .dot .instrll .instro .ll .pdf .tesla
.DEFAULT: all
#.SILENT:

BASE=goto-fail
.PRECIOUS: ${BASE}.dot

CC=clang

CFLAGS	+= -I include -I ${TESLA_SOURCE_DIR}/include

LDFLAGS	+= -L ${TESLA_BUILD_DIR}/libtesla/src -l crypto -l ssl -l tesla

LLC?=llc
LLVM_CONFIG?=llvm-config

# TODO: do some string substitution to derive .tesla file names
OBJ=	\
	${BASE}.instro \
	mocks.instro \
	sslKeyExchange.instro \

TESLA_FILES=	\
	${BASE}.tesla \
	mocks.tesla \
	sslKeyExchange.tesla \


CLANG_VERSION=`${CC} --version | grep version | awk '{ print $$3 }'`
RESOURCE_DIR=-resource-dir `${LLVM_CONFIG} --libdir`/clang/${CLANG_VERSION}


all: tesla.manifest ${BASE}

clean:
	rm -f ${BASE} *.dot *.instrll *.instro *.ll *.manifest *.o *.tesla *.pdf


#
# Normal C workflow:
#
${BASE}: ${OBJ}
	${CC} ${LDFLAGS} ${OBJ} -o $@

.c.ll:
	${CC} -S -emit-llvm ${CFLAGS} $< -o $@

.instrll.instro:
	${LLC} -filetype=obj $< -o $@


#
# TESLA-specific rules:
#

# TESLA analysis (C -> TESLA IR)
.c.tesla:
	tesla analyse $< -o $@ -- ${CFLAGS} ${RESOURCE_DIR}

# Combining several TESLA files
tesla.manifest: ${TESLA_FILES}
	tesla cat ${TESLA_FILES} -o $@
	# temporary workaround for ClangTool irritant:
	sed -i.backup "s@`pwd`/@@" tesla.manifest && rm tesla.manifest.backup

# Pretty visualisation (TELSA IR -> GraphViz)
.tesla.dot:
	tesla graph $< -o $@

# TESLA instrumentation (LLVM IR --TESLA IR--> instrumented LLVM IR)
.ll.instrll:
	tesla instrument -S $< -tesla-manifest tesla.manifest -o $@


#
# Other non-TESLA-specific rules:
#

# Pretty visualisation (GraphViz -> PDF)
.dot.pdf:
	dot -Tpdf $< -o $@

