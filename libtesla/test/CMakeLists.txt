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
endforeach(test)

