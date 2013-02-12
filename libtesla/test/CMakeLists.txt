# Tests must be compiled in debug mode; there's little point in a test that
# can't fire any of its assertions!
#
# This doesn't change any requirements on libraries the tests link against.
set(CMAKE_BUILD_TYPE Debug)

# We use execinfo here for detailed failure information (e.g. backtraces).
find_package(ExecInfo REQUIRED)
include_directories(${EXECINFO_INCLUDE_DIRS})

# Provide access to internal headers.
include_directories(../src)

set(TESTS
	match
	lookup
	store
	update
)

set(OBJ helpers)

foreach(test ${TESTS})
	add_executable(${test} ${test}.c ${OBJ}.c)
	target_link_libraries(${test} tesla)

	if( ${CMAKE_SYSTEM_NAME} MATCHES FreeBSD )
		target_link_libraries(${test} ${EXECINFO_LIBRARY})
	endif( ${CMAKE_SYSTEM_NAME} MATCHES FreeBSD )
endforeach(test)

