add_custom_target(tesla-test
	COMMAND
		llvm-lit ${LIT_OPTIONS} ${CMAKE_CURRENT_SOURCE_DIR}
		--param=build_dir=${CMAKE_BINARY_DIR}
		--param=source_dir=${CMAKE_SOURCE_DIR}
		--param=output_dir=${CMAKE_BINARY_DIR}
		${LIT_EXTRA}
	COMMENT "Testing TESLA")

add_dependencies(tesla-test
	tesla-analyse
	tesla-cat
	tesla-get-triple
	tesla-instrument
	tesla-print
)
