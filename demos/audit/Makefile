.SUFFIXES: .c .dot .instrll .instro .ll .pdf .tesla
.DEFAULT: all
#.SILENT:

BASE=audit-demo
.PRECIOUS: ${BASE}.dot

CC=clang

CFLAGS	+= -D _KERNEL -D AUDIT -D MAC -D __BSD_VISIBLE \
	-Wall -Werror \
	-g -ggdb \
	-I include -I ${TESLA_SOURCE_DIR}/include

LDFLAGS	+= -L ${TESLA_BUILD_DIR}/libtesla/src -l crypto -l ssl -l tesla

OBJ=	\
	${BASE}.instro \
	helpers.instro \
	mac_framework.instro \
	mac_vfs.instro \
	vfs_lookup.instro \
	vfs_vnops.instro

RESOURCE_DIR=-resource-dir `llvm-config --libdir`/clang/3.3


all: ${BASE}.tesla ${BASE} ${BASE}.pdf

clean:
	rm -f ${BASE} *.dot *.instrll *.instro *.ll *.o *.tesla *.pdf


#
# Normal C workflow:
#
${BASE}: ${OBJ}
	${CC} ${LDFLAGS} $^ -o $@

.c.ll:
	${CC} -S -emit-llvm ${CFLAGS} $< -o $@

.instrll.instro:
	llc -filetype=obj $< -o $@


#
# TESLA-specific rules:
#

# TESLA analysis (C -> TESLA IR)
.c.tesla:
	tesla analyse $< -o $@ -- ${CFLAGS} ${RESOURCE_DIR}

# Combining several TESLA files
${BASE}.tesla: vfs_lookup.tesla vfs_vnops.tesla
	tesla cat $^ -o $@
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

