cmake_minimum_required(VERSION 2.6)
project(TESLA)

find_package(LLVM REQUIRED)

include(AddLLVM)

add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})
link_directories(${LLVM_LIBRARY_DIRS})

find_package(Protobuf REQUIRED)
include_directories("." ${CMAKE_CURRENT_BINARY_DIR} ${PROTOBUF_INCLUDE_DIRS})

protobuf_generate_cpp(PROTO_SRCS PROTO_HDRS tesla.proto)
add_library(TeslaProto ${PROTO_SRCS} ${PROTO_HDRS})
target_link_libraries(TeslaProto ${PROTOBUF_LIBRARY})

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-rtti -Wno-c++11-extensions")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wstrict-prototypes -Werror")

add_subdirectory(analyser)
add_subdirectory(instrumenter)

