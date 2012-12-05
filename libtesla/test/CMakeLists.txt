# Tests must be compiled in debug mode; there's little point in a test that
# can't fire any of its assertions!
#
# This doesn't change any requirements on libraries the tests link against.
set(CMAKE_BUILD_TYPE Debug)

set(TESTS
	fork
	match
	lookup
	store
)

set(OBJ helpers)

foreach(test ${TESTS})
	add_executable(${test} ${test}.c ${OBJ}.c)
	target_link_libraries(${test} tesla)

	if( ${CMAKE_SYSTEM_NAME} MATCHES FreeBSD )
		target_link_libraries(${test} execinfo)
	endif( ${CMAKE_SYSTEM_NAME} MATCHES FreeBSD )
endforeach(test)

