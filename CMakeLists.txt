cmake_minimum_required(VERSION 2.6)

# Always build with all warnings and with warning=>error
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wstrict-prototypes -Werror")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Werror")

# Set -D DEBUG on debug builds, rather than the CMake default of setting
# -D NDEBUG for release builds and assuming debug mode otherwise.
set_directory_properties(PROPERTIES COMPILE_DEFINITIONS_DEBUG DEBUG)

# Also enable trivial-ish assertions when compiling in debug mode.
set_directory_properties(PROPERTIES COMPILE_DEFINITIONS_DEBUG ASSERTS)

include_directories("include")

add_subdirectory(libtesla)
add_subdirectory(tesla)

