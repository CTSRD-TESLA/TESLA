.SUFFIXES: .c .dot .ll .pdf .tesla

ANALYSE=	tesla analyse
CAT=		tesla cat
INSTRUMENT=	tesla instrument -S -verify-each
GRAPH=		tesla print

#CFLAGS+=	-D TESLA
LIBS+=		-l tesla
GRAPH_FLAGS?=	-d

TESLA_ALLFILES=	.tesla ${TESLA_FILES} ${TESLA_IR} ${TESLA_OBJS}
TESLA_FILES=	${SRCS:.c=.tesla}
TESLA_IR=	${SRCS:.c=.instr.ll} ${IR:.ll=.instr.ll}
TESLA_OBJS=	${TESLA_IR:.ll=.o}

# Replace normal OBJS with TESLA-instrumented versions.
OBJS=		${TESLA_OBJS}

.tesla: ${TESLA_FILES}
	${CAT} $^ -o $@
	# temporary workaround for ClangTool irritant:
	sed -i.backup "s@`pwd`/@@" .tesla && rm .tesla.backup

# Run the TESLA analyser over C code.
.c.tesla:
	${ANALYSE} $< -o $@ -- ${CFLAGS}

# Instrument LLVM IR using TESLA.
%.instr.ll: %.ll .tesla
	${INSTRUMENT} -tesla-manifest .tesla $< -o $@

# Graph the .tesla file.
tesla.dot: .tesla
	${GRAPH} -o $@ ${GRAPH_FLAGS} $<

# Optional PDF-ification of the .dot file.
.dot.pdf:
	dot -Tpdf -o $@ $<

