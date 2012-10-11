# Dependency tracking: protobuf_generate_cpp() only sort-of works across dirs.
protobuf_generate_cpp(PROTO_SRCS PROTO_HDRS tesla.proto)

add_llvm_loadable_module(TeslaInstrumenter
	Assertion.cpp
	Callee.cpp
	Caller.cpp
	Instrumentation.cpp
)

target_link_libraries(TeslaInstrumenter
	LLVMSupport
	TeslaCommon
)

