cmake_minimum_required(VERSION 2.6)
project(TESLA)

#
# TESLA uses some C++11 extensions like 'auto', but doesn't require a
# C++11-compliant standard library.
#
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-c++11-extensions")


#
# Protocol buffers:
#
find_package(Protobuf REQUIRED)
include_directories(${PROTOBUF_INCLUDE_DIRS})

# Declare the existence of protobuf-generated files (the actual generation is
# described in the 'common' subdirectory, but we must declare them here).
protobuf_generate_cpp(PROTO_SRCS PROTO_HDRS tesla.proto)


#
# LLVM configuration
#
find_package(LLVM REQUIRED)
include(AddLLVM)

add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})
link_directories(${LLVM_LIBRARY_DIRS})

# LLVM libraries that we need:
llvm_map_components_to_libraries(LLVM_LIBS bitreader)
set(LLVM_LINK_COMPONENTS ${LLVM_TARGETS_TO_BUILD})

# Work out of the LLVM source/build trees if LLVM is not installed.
exec_program(llvm-config ARGS --src-root OUTPUT_VARIABLE LLVM_SRC)
exec_program(llvm-config ARGS --obj-root OUTPUT_VARIABLE LLVM_OBJ)
include_directories("${LLVM_SRC}/include" "${LLVM_OBJ}/include")
link_directories("${LLVM_OBJ}/lib/")

# Use LLVM's CFLAGS and CXXFLAGS, but filter out optimisations and -DNDEBUG.
exec_program(llvm-config ARGS --cflags   OUTPUT_VARIABLE LLVM_C)
exec_program(llvm-config ARGS --cxxflags OUTPUT_VARIABLE LLVM_CXX)
string(REGEX REPLACE "(.*)-O[0-9] -DNDEBUG(.*)" "\\1\\2" LLVM_C ${LLVM_C})
string(REGEX REPLACE "(.*)-O[0-9] -DNDEBUG(.*)" "\\1\\2" LLVM_CXX ${LLVM_CXX})
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${LLVM_C}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${LLVM_CXX_FLAGS}")

# Important CXXFLAGS that llvm-config --cxxflags doesn't give us:
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-rtti")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-nested-anon-types")


#
# Finally, actually specify the TESLA subdirectories:
#
include_directories(common)
include_directories("${CMAKE_CURRENT_BINARY_DIR}/common")

add_subdirectory(analyser)
add_subdirectory(common)
add_subdirectory(instrumenter)
add_subdirectory(tools)

