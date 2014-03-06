.SUFFIXES: .c .dot .instrll .instro .ll .pdf .tesla
.DEFAULT: all
#.SILENT:

BASE=audit-demo
.PRECIOUS: ${BASE}.dot

CC?=clang

CFLAGS	+= -D _KERNEL -D AUDIT -D MAC -D __BSD_VISIBLE \
	-Wall -Werror \
	-g -ggdb \
	-I include -I ${TESLA_SOURCE_DIR}/include

LDFLAGS	+= -L ${TESLA_BUILD_DIR}/libtesla/src -l crypto -l ssl -l tesla

LLC?=llc
LLVM_CONFIG?=llvm-config

# TODO: do some string substitution to derive .tesla file names
OBJ=	\
	${BASE}.instro \
	helpers.instro \
	mac_framework.instro \
	mac_vfs.instro \
	vfs_lookup.instro \
	vfs_syscalls.instro \
	vfs_vnops.instro

TESLA_FILES=	\
	vfs_lookup.tesla \
	vfs_syscalls.tesla \
	vfs_vnops.tesla

CLANG_VERSION=`${CLANG} --version | grep version | awk '{ print $$3 }'`
RESOURCE_DIR=-resource-dir `${LLVM_CONFIG} --libdir`/clang/${CLANG_VERSION}


all: ${BASE}.tesla ${BASE}

clean:
	rm -f ${BASE} *.dot *.instrll *.instro *.ll *.o *.tesla *.pdf


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
${BASE}.tesla: ${TESLA_FILES}
	tesla cat ${TESLA_FILES} -o $@
	# temporary workaround for ClangTool irritant:
	sed -i.backup "s@`pwd`/@@" ${BASE}.tesla && rm ${BASE}.tesla.backup

# Pretty visualisation (TELSA IR -> GraphViz)
.tesla.dot:
	tesla graph $< -o $@

# TESLA instrumentation (LLVM IR --TESLA IR--> instrumented LLVM IR)
.ll.instrll:
	tesla instrument -S $< -tesla-manifest ${BASE}.tesla -o $@


#
# Other non-TESLA-specific rules:
#

# Pretty visualisation (GraphViz -> PDF)
.dot.pdf:
	dot -Tpdf $< -o $@

