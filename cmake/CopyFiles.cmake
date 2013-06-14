#
# Copy a file from the source directory to somewhere else.
#
function(copy in out)
	set(in_abs "${CMAKE_CURRENT_SOURCE_DIR}/${in}")
	add_custom_command(OUTPUT ${out}
		DEPENDS ${in_abs}
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${in_abs} ${out}
		COMMENT "Copying ${in}"
	)
endfunction()
