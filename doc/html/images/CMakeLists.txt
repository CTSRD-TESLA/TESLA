find_package(Dot)

file(COPY
	conditional.png
	strict.png
	workflow.png
	DESTINATION ${HTML_BINDIR}/images)

if( DEFINED DOT_EXECUTABLE )
	set(Y "66")
	set(N  "00")
	set(ALPHA "66")

	set(red    "${Y}${N}${N}")
	set(green  "${N}${Y}${N}")
	set(blue   "${N}${N}${Y}")
	set(purple "${Y}${N}${Y}")

	foreach(colour red green blue purple)
		set(c "#${${colour}}")
		set(${colour} "color = \"${c}${ALPHA}\", fontcolor = \"${c}\"")
	endforeach()

	configure_file(example-deps.dot.in example-deps.dot)

	add_custom_command(
		OUTPUT example-deps.png
		DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/example-deps.dot
		COMMAND ${DOT_EXECUTABLE} -Tpng
			example-deps.dot
			-o ${HTML_BINDIR}/images/example-deps.png
	)

	add_custom_target(example-deps DEPENDS example-deps.png)
	add_dependencies(doc example-deps)
endif()

install(DIRECTORY ${HTML_BINDIR}/images DESTINATION ${HTML_OUTPUT})
