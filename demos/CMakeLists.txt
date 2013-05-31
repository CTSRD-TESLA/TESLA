add_custom_target(run-demos
	COMMAND
		llvm-lit ${LIT_OPTIONS} ${CMAKE_CURRENT_SOURCE_DIR}
		--param=build_dir=${CMAKE_BINARY_DIR}
		--param=source_dir=${CMAKE_SOURCE_DIR}
		--param=output_dir=${CMAKE_BINARY_DIR}
		${LIT_EXTRA}
	COMMENT "Checking TESLA demos")

add_dependencies(run-demos
	tesla-analyse
	tesla-cat
	tesla-get-triple
	tesla-graph
	tesla-instrument
)
