# Dependency tracking: protobuf_generate_cpp() only sort-of works across dirs.
protobuf_generate_cpp(PROTO_SRCS PROTO_HDRS tesla.proto)

set(LLVM_LINK_COMPONENTS ${LLVM_TARGETS_TO_BUILD}
	asmparser
	bitreader
	bitwriter
)

add_llvm_executable(tesla-instrument
	instrument.cpp
	Annotations.cpp
	Assertion.cpp
	Callee.cpp
	Caller.cpp
  EventTranslator.cpp
	FieldReference.cpp
  InstrContext.cpp
	Instrumentation.cpp
  TranslationFn.cpp
)

target_link_libraries(tesla-instrument
	TeslaCommon
)

include_directories("${CMAKE_SOURCE_DIR}/../include")

install(TARGETS tesla-instrument DESTINATION bin)

