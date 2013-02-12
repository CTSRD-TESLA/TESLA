cmake_minimum_required(VERSION 2.6)
project(TESLA)

find_package(LLVM REQUIRED)

include(AddLLVM)

add_definitions(${LLVM_DEFINITIONS})
add_definitions(-fvisibility-inlines-hidden)
include_directories(${LLVM_INCLUDE_DIRS})
link_directories(${LLVM_LIBRARY_DIRS})

# The LLVM CMake files are a little bit broken; see:
#   http://lists.cs.uiuc.edu/pipermail/llvmdev/2012-July/051545.html
#   http://lists.cs.uiuc.edu/pipermail/llvmdev/2012-July/051546.html
#
# Until these issues are resolved, we can't just pass 'all' to
# llvm_map_components_to_libraries(). Instead, we pass this long list of LLVM
# components, obtained by running 'llvm-config --components' and dropping
# 'all' and 'all-targets' from the output.
llvm_map_components_to_libraries(LLVM_LIBS
	analysis archive arm armasmparser armcodegen armdesc armdisassembler arminfo asmparser asmprinter bitreader bitwriter codegen core cppbackend cppbackendcodegen cppbackendinfo debuginfo engine executionengine hexagon hexagonasmprinter hexagoncodegen hexagondesc hexagoninfo instcombine instrumentation interpreter ipa ipo jit linker mblaze mblazeasmparser mblazeasmprinter mblazecodegen mblazedesc mblazedisassembler mblazeinfo mc mcdisassembler mcjit mcparser mips mipsasmparser mipsasmprinter mipscodegen mipsdesc mipsdisassembler mipsinfo msp430 msp430asmprinter msp430codegen msp430desc msp430info native nativecodegen nvptx nvptxasmprinter nvptxcodegen nvptxdesc nvptxinfo object powerpc powerpcasmprinter powerpccodegen powerpcdesc powerpcinfo runtimedyld scalaropts selectiondag sparc sparccodegen sparcdesc sparcinfo support tablegen target transformutils vectorize x86 x86asmparser x86asmprinter x86codegen x86desc x86disassembler x86info x86utils xcore xcorecodegen xcoredesc xcoreinfo
)

find_package(Protobuf REQUIRED)
include_directories(${PROTOBUF_INCLUDE_DIRS})

protobuf_generate_cpp(PROTO_SRCS PROTO_HDRS tesla.proto)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-rtti -Wno-c++11-extensions")
set(LLVM_LINK_COMPONENTS ${LLVM_TARGETS_TO_BUILD})

include_directories(common)
include_directories("${CMAKE_CURRENT_BINARY_DIR}/common")

add_subdirectory(analyser)
add_subdirectory(common)
add_subdirectory(instrumenter)
add_subdirectory(tools)

