find_package(Protobuf REQUIRED)
include_directories(${CMAKE_CURRENT_BINARY_DIR} ${PROTOBUF_INCLUDE_DIRS})

protobuf_generate_cpp(PROTO_SRCS PROTO_HDRS tesla.proto)

add_llvm_loadable_module(TeslaInstrumenter
	Instrumentation.cpp
	TeslaInstrumenter.cpp
)

target_link_libraries(TeslaInstrumenter
	LLVMSupport
	TeslaProto
)

