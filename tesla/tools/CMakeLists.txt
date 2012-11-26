find_package(Protobuf REQUIRED)
include_directories(${CMAKE_CURRENT_BINARY_DIR} ${PROTOBUF_INCLUDE_DIRS})

protobuf_generate_cpp(PROTO_SRCS PROTO_HDRS tesla.proto)

add_llvm_executable(read-manifest read-manifest.cpp)

target_link_libraries(read-manifest TeslaCommon)

