cmake_minimum_required(VERSION 2.6)

find_package(LLVM)

include(AddLLVM)

add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})
link_directories(${LLVM_LIBRARY_DIRS})

add_llvm_loadable_module(TeslaInstrumenter
	Instrumentation.cpp
	TeslaInstrumenter.cpp
)

