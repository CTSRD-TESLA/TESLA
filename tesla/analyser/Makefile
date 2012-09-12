#
# NOTE: this would all be simpler if Clang exposed a CMake module like LLVM.
#

CC=clang
CXX=clang++

# Clang and LLVM don't use C++ exceptions or run-time type information.
# Also, disable warnings about the use of C++11 features. This is a stop-gap
# until we properly enable C++11 support when building Clang/LLVM, which we
# can't do until http://llvm.org/bugs/show_bug.cgi?id=12501 is fixed.
CXXFLAGS= \
	-fno-exceptions -fno-rtti \
	-Wno-c++11-extensions \
	-I ../common \
	$(shell llvm-config --cxxflags)

LDFLAGS= \
	$(shell llvm-config --ldflags) \
	$(shell llvm-config --libs ) \
	-L ../common ${LIBS}

# Clang libraries (gathered by watching what CMake does elsewhere).
CLANG_LIBS= $(patsubst %,clang%, \
	Analysis AST Basic Driver Edit Frontend Lex Parse Sema Serialization Tooling)

LIBS=$(patsubst %,-l %,${CLANG_LIBS} Tesla TeslaClang)

.PHONY: all clean test

TESLA=tesla
TESLA_OBJ=$(patsubst %,%.o, tool)

all: ${TESLA}

-include $(TESLA_OBJ:.o=.o.d)

clean:
	rm -f ${TESLA} *.o *.d

test:
	cd ../strawman && ${MAKE} run-tesla

${TESLA}: ${TESLA_OBJ}
	${CXX} ${CXXFLAGS} ${LDFLAGS} $^ -o $@ ${LIBS}

%.o: %.cpp Makefile
	${CXX} ${CXXFLAGS} -MMD -MT $@ -MF $@.d -o $@ -c $<

