# Dependency tracking: protobuf_generate_cpp() only sort-of works across dirs.
protobuf_generate_cpp(PROTO_SRCS PROTO_HDRS tesla.proto)

set(LLVM_LINK_COMPONENTS ${LLVM_TARGETS_TO_BUILD})

add_subdirectory(read-manifest)

