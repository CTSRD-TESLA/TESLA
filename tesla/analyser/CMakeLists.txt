# Dependency tracking: protobuf_generate_cpp() only sort-of works across dirs.
protobuf_generate_cpp(PROTO_SRCS PROTO_HDRS tesla.proto)

add_llvm_executable(tesla
	Automata.cpp
	Expressions.cpp
	Events.cpp
	Helpers.cpp
	References.cpp
	Tool.cpp
)
target_link_libraries(tesla TeslaProto)

# Link this executable against the Clang and LLVM libraries:

# 1. Clang doesn't provide an equivalent to llvm_map_components_to_libraries().
foreach(i
	Analysis AST ASTMatchers Basic Driver Edit Frontend Lex Parse
	Sema Serialization Tooling
)
	target_link_libraries(tesla clang${i})
endforeach(i)


# 2. The LLVM CMake files are a little bit broken; see:
#   http://lists.cs.uiuc.edu/pipermail/llvmdev/2012-July/051545.html
#   http://lists.cs.uiuc.edu/pipermail/llvmdev/2012-July/051546.html
#
# Until these issues are resolved, we can't just pass 'all' to
# llvm_map_components_to_libraries(). Instead, we pass this long list of LLVM
# components, obtained by running 'llvm-config --components' and dropping
# 'all' and 'all-targets' from the output.
llvm_map_components_to_libraries(LLVM_LIBS
	analysis archive arm armasmparser armcodegen armdesc armdisassembler arminfo asmparser asmprinter bitreader bitwriter cellspu cellspucodegen cellspudesc cellspuinfo codegen core cppbackend cppbackendcodegen cppbackendinfo debuginfo engine executionengine hexagon hexagonasmprinter hexagoncodegen hexagondesc hexagoninfo instcombine instrumentation interpreter ipa ipo jit linker mblaze mblazeasmparser mblazeasmprinter mblazecodegen mblazedesc mblazedisassembler mblazeinfo mc mcdisassembler mcjit mcparser mips mipsasmparser mipsasmprinter mipscodegen mipsdesc mipsdisassembler mipsinfo msp430 msp430asmprinter msp430codegen msp430desc msp430info native nativecodegen nvptx nvptxasmprinter nvptxcodegen nvptxdesc nvptxinfo object powerpc powerpcasmprinter powerpccodegen powerpcdesc powerpcinfo runtimedyld scalaropts selectiondag sparc sparccodegen sparcdesc sparcinfo support tablegen target transformutils vectorize x86 x86asmparser x86asmprinter x86codegen x86desc x86disassembler x86info x86utils xcore xcorecodegen xcoredesc xcoreinfo
)

# Simply using add_llvm_executable() by itself isn't enough: that doesn't
# link the executable against some important libraries like LLVMSupport.
#
# Instead, we need to pass in ${LLVM_LIBS} explicitly.
target_link_libraries(tesla ${LLVM_LIBS})

