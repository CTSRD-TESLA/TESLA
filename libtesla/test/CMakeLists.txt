# Tests must be compiled in debug mode; there's little point in a test that
# can't fire any of its assertions!
#
# This doesn't change any requirements on libraries the tests link against.
set(CMAKE_BUILD_TYPE Debug)

# We use execinfo here for detailed failure information (e.g. backtraces).
#
# This is only required on FreeBSD, as both Mac OS X and Linux include
# backtrace functions in libSystem / libc.
if( ${CMAKE_SYSTEM_NAME} MATCHES FreeBSD )
	find_package(ExecInfo REQUIRED)
	include_directories(${EXECINFO_INCLUDE_DIRS})

	set(LIT_EXTRA
		--param=extra_include_dirs=${EXECINFO_INCLUDE_DIRS}
		--param=extra_libs=${EXECINFO_LIBRARY})
endif( ${CMAKE_SYSTEM_NAME} MATCHES FreeBSD )

# Provide access to internal headers.
include_directories(../src)

set(TESTS
	match
	lookup
	store
	update
)

# Ignore "unused parameter 'int argc'" warnings in test programs.
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-unused-parameter")

foreach(test ${TESTS})
	add_executable(${test} ${test}.c)
	target_link_libraries(${test} tesla)

	if( ${CMAKE_SYSTEM_NAME} MATCHES FreeBSD )
		target_link_libraries(${test} ${EXECINFO_LIBRARY})
	endif( ${CMAKE_SYSTEM_NAME} MATCHES FreeBSD )
endforeach(test)


add_custom_target(libtesla-test
	COMMAND
		llvm-lit -qv ${CMAKE_CURRENT_SOURCE_DIR}
		--param=build_dir=${CMAKE_BINARY_DIR}
		--param=source_dir=${CMAKE_SOURCE_DIR}
		${LIT_EXTRA}
	COMMENT "Testing libtesla")

add_dependencies(libtesla-test tesla)

