cmake_minimum_required(VERSION 2.6)

# Always build with all warnings and with warning=>error
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wstrict-prototypes -Werror")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Werror")

# Set -D DEBUG on debug builds, in addition to the CMake default of setting
# -D NDEBUG for release builds and assuming debug mode otherwise.
set_directory_properties(PROPERTIES COMPILE_DEFINITIONS_DEBUG DEBUG)

include_directories("include")

# On FreeBSD, /usr/local/* is not used by default. In order to build LLVM
# with libxml2, iconv.h, etc., we must add /usr/local paths.
if( ${CMAKE_SYSTEM_NAME} MATCHES FreeBSD )
  include_directories("/usr/local/include")
  link_directories("/usr/local/lib")
endif( ${CMAKE_SYSTEM_NAME} MATCHES FreeBSD )

set(POSITION_INDEPENDENT_CODE OFF)

add_subdirectory(libtesla)
add_subdirectory(tesla)

