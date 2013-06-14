function(concatenate output) # inputs in ${ARGN}
	add_custom_command(
		OUTPUT ${output}
		DEPENDS ${ARGN}
		COMMAND cat ${ARGN} > ${output}
		COMMENT "Concatenating ${output}"
	)
endfunction()
