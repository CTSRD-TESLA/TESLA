# Dependency tracking: protobuf_generate_cpp() only sort-of works across dirs.
protobuf_generate_cpp(PROTO_SRCS PROTO_HDRS tesla.proto)

# Add Clang include directories.
include_directories(
	"${LLVM_SRC}/tools/clang/include"
	"${LLVM_OBJ}/tools/clang/include")


#
# The TESLA analyser executable:
#
add_llvm_executable(tesla-analyse
	Automata.cpp
	Expressions.cpp
	Events.cpp
	Helpers.cpp
	References.cpp
	Tool.cpp
)
target_link_libraries(tesla-analyse TeslaProto)
install(TARGETS tesla-analyse DESTINATION bin)


#
# Link against Clang and LLVM libraries:
#

# Clang doesn't provide an equivalent to llvm_map_components_to_libraries().
foreach(i
	Analysis AST ASTMatchers Basic Driver Edit Frontend Lex Parse
	Sema Serialization Tooling
)
	target_link_libraries(tesla-analyse clang${i})
endforeach(i)

# Simply using add_llvm_executable() by itself isn't enough: that doesn't
# link the executable against some important libraries like LLVMSupport.
#
# Instead, we need to pass in ${LLVM_LIBS} explicitly.
target_link_libraries(tesla-analyse ${LLVM_LIBS})

