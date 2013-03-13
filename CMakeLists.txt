cmake_minimum_required(VERSION 2.6)

project(TESLA)

set(CMAKE_MODULE_PATH
  ${CMAKE_MODULE_PATH}
  "${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules")

# Always build with all warnings and with warning=>error
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wstrict-prototypes -Werror")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Werror")

# Default to libc++ if installed.
find_package(LibCXX)

set(USE_LIBCXX ${LIBCXX_FOUND} CACHE BOOL "Use libc++ when building TESLA")
if (USE_LIBCXX)
  message(STATUS "Using libc++")
else ()
  message(STATUS "Using the default system STL implementation")
endif ()

if (USE_LIBCXX)
  set(CMAKE_CXX_LINK_FLAGS "${CMAKE_CXX_LINK_FLAGS} -stdlib=libc++")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++")

  include_directories(${LIBCXX_INCLUDE_DIRS})
endif ()

# Set -D DEBUG on debug builds, in addition to the CMake default of setting
# -D NDEBUG for release builds and assuming debug mode otherwise.
set_directory_properties(PROPERTIES COMPILE_DEFINITIONS_DEBUG DEBUG)

include_directories("${CMAKE_SOURCE_DIR}/include")

add_subdirectory(libtesla)
add_subdirectory(tesla)
add_subdirectory(scripts)

# A top-level 'test' target to drive all tests of TESLA subdirectories.
add_custom_target(test ALL DEPENDS libtesla-test tesla-test)

