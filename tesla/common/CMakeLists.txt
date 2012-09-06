cmake_minimum_required(VERSION 2.6)

find_package(LLVM)

include(AddLLVM)

add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})
link_directories(${LLVM_LIBRARY_DIRS})

add_library(Tesla Tesla.cpp Events.cpp References.cpp yaml.cpp)
target_link_libraries(Tesla c++) # LLVMSupport)

add_library(TeslaClang clang/Clang.cpp clang/References.cpp)
target_link_libraries(TeslaClang Tesla)

