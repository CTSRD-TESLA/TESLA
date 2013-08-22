# Tests must be compiled in debug mode; there's little point in a test that
# can't fire any of its assertions!
#
# This doesn't change any requirements on libraries the tests link against.
set(CMAKE_BUILD_TYPE Debug)

# Provide access to internal headers.
include_directories(../src)

set(TESTS
	actions.cpp
	match.cpp
	lookup.cpp
	repeat.cpp
	store.c
	update.cpp
)

# Ignore "unused parameter 'int argc'" warnings in test programs.
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-unused-parameter")

foreach(test ${TESTS})
	add_executable(${test}.test ${test})
	target_link_libraries(${test}.test tesla)

	if( ${CMAKE_SYSTEM_NAME} MATCHES FreeBSD )
		target_link_libraries(${test}.test ${EXECINFO_LIBRARY})
	endif( ${CMAKE_SYSTEM_NAME} MATCHES FreeBSD )
endforeach(test)


add_custom_target(libtesla-test
	COMMAND
		llvm-lit ${LIT_OPTIONS} ${CMAKE_CURRENT_SOURCE_DIR}
		--param=build_dir=${CMAKE_BINARY_DIR}
		--param=source_dir=${CMAKE_SOURCE_DIR}
		--param=output_dir=${CMAKE_BINARY_DIR}
		${LIT_EXTRA}
	COMMENT "Testing libtesla")

add_dependencies(libtesla-test tesla llvm-triple)
