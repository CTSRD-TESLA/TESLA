cmake_minimum_required(VERSION 2.6)

project(TESLA)

set(CMAKE_MODULE_PATH
  ${CMAKE_MODULE_PATH}
  "${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules")

# Always build with all warnings and with warning=>error
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wstrict-prototypes -Werror")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Werror")

find_library(LIBCXX c++)
set(DEFAULT_LIBCXX true)
if (NOT LIBCXX)
	set(DEFAULT_LIBCXX false)
endif ()

set(USE_LIBCXX ${DEFAULT_LIBCXX} CACHE BOOL "Use libc++ when building TESLA")
if (USE_LIBCXX)
	message(STATUS "Using libc++")
else ()
	message(STATUS "Using the default system STL implementation")
endif ()

if (USE_LIBCXX)
	set(CMAKE_CXX_LINK_FLAGS "${CMAKE_CXX_LINK_FLAGS} -stdlib=libc++")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++")
endif ()

# Set -D DEBUG on debug builds, in addition to the CMake default of setting
# -D NDEBUG for release builds and assuming debug mode otherwise.
set_directory_properties(PROPERTIES COMPILE_DEFINITIONS_DEBUG DEBUG)

include_directories("include")

add_subdirectory(libtesla)
add_subdirectory(tesla)

