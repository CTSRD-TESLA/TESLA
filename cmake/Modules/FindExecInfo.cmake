if (EXECINFO_INCLUDE_DIRS)
  set (EXECINFO_FIND_QUIETLY TRUE)
endif (EXECINFO_INCLUDE_DIRS)

find_path (EXECINFO_INCLUDE_DIRS execinfo.h)
find_library (EXECINFO_LIBRARY NAMES execinfo)

include (FindPackageHandleStandardArgs)
find_package_handle_standard_args(EXECINFO DEFAULT_MSG
  EXECINFO_LIBRARY
  EXECINFO_INCLUDE_DIRS
)

mark_as_advanced (EXECINFO_LIBRARY EXECINFO_INCLUDE_DIRS)
