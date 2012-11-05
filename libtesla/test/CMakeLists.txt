set(TESTS
	fork
	match
	lookup
)

foreach(test ${TESTS})
	add_executable(${test} ${test}.c)
	target_link_libraries(${test} tesla)
endforeach(test)

