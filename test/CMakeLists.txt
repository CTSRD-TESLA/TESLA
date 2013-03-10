add_custom_target(tesla-test
	COMMAND
		llvm-lit -v
		${CMAKE_SOURCE_DIR}/test
		--param=build_dir=${CMAKE_BINARY_DIR}
		--param=source_dir=${CMAKE_SOURCE_DIR}
	COMMENT "Testing TESLA")

add_dependencies(tesla-test tesla-analyse tesla-instrument)

