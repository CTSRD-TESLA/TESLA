cmake_minimum_required(VERSION 2.6)
project(TESLA)

find_package(LLVM REQUIRED)

include(AddLLVM)

add_definitions(${LLVM_DEFINITIONS})
add_definitions(-fvisibility-inlines-hidden)
include_directories(${LLVM_INCLUDE_DIRS})
link_directories(${LLVM_LIBRARY_DIRS})

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

