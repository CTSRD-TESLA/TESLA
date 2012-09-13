cmake_minimum_required(VERSION 2.6)
project(TESLA)

find_package(LLVM)

include(AddLLVM)

add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})
link_directories(${LLVM_LIBRARY_DIRS})

set(CMAKE_CXX_FLAGS "-fno-rtti -Wno-c++11-extensions")

include_directories(common)

add_subdirectory(analyser)
add_subdirectory(common)
add_subdirectory(instrumenter)

