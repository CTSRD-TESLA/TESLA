# - Find libc++
# Find libc++ if installed
#
# This module defines the following variables:
#     LIBCXX_FOUND         - whether or not we found libc++
#     LIBCXX_INCLUDE_DIR   - the include directory where C++ headers live
#     LIBCXX_INCLUDE_DIRS  - include dirs for libc++ and (no) dependencies
#

find_library(LIBCXX_LIBRARY c++)
set(LIBCXX_LIBRARIES "${LIBCXX_LIBRARY}")

# On Mac OS X, the headers are in a slightly unusual place (e.g. /usr/lib/c++).
if (${CMAKE_SYSTEM_NAME} MATCHES Darwin)
  find_path(LIBCXX_PREFIX lib/c++/v1/string REQUIRED
    DOC "container for versioned libc++ include directories"
    PATHS ${CMAKE_SYSTEM_PREFIX_PATH}
  )

  if (LIBCXX_PREFIX)
    set(LIBCXX_INCLUDE_DIR "${LIBCXX_PREFIX}/lib/c++/v1"
      CACHE STRING "Include directory for libc++ headers")
  endif ()
endif ()

set(LIBCXX_INCLUDE_DIRS "${LIBCXX_INCLUDE_DIR}")

include (FindPackageHandleStandardArgs)
find_package_handle_standard_args(LIBCXX DEFAULT_MSG
  LIBCXX_LIBRARY
  LIBCXX_INCLUDE_DIR
)

mark_as_advanced (LIBCXX_INCLUDE_DIR)

