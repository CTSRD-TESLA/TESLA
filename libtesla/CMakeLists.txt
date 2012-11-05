cmake_minimum_required(VERSION 2.6)
project(libtesla)

# Set -D DEBUG on debug builds, rather than the CMake default of setting
# -D NDEBUG for release builds and assuming debug mode otherwise.
set_directory_properties(PROPERTIES COMPILE_DEFINITIONS_DEBUG DEBUG)

# Also enable trivial-ish assertions when compiling in debug mode.
set_directory_properties(PROPERTIES COMPILE_DEFINITIONS_DEBUG ASSERTS)


set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Werror")

include_directories("../include")

add_subdirectory(src)
add_subdirectory(test)

