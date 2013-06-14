#
# The ucampas tool converts bare HTML to the UCam house style.
#
find_package(UCampas)

#
# Allow the user to specify the build location of HTML output.
#
# This is useful for e.g. building HTML content into a larger website
# located in a Subversion repository.
#
if( NOT DEFINED HTML_BINDIR )
	set(HTML_BINDIR ${CMAKE_CURRENT_BINARY_DIR}
		CACHE PATH "HTML staging dir")
	message("-- HTML will be built in ${HTML_BINDIR}")
endif()

#
# Build a complete HTML file, ready for ucampas.
#
function(build_html_file output base title)
	set(tmpdir "${CMAKE_CURRENT_BINARY_DIR}/CMakeTmp")
	set(header "${tmpdir}/header-${base}.html")
	set(footer "${tmpdir}/footer.html")

	set(input "${CMAKE_CURRENT_SOURCE_DIR}/${base}.html")
	concatenate(${output} ${header} ${input} ${footer})

	file(WRITE ${header}
"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\">

<head>
<title>${title}</title>
<link rel=\"stylesheet\" type=\"text/css\" href=\"tesla.css\"/>
</head>

<body>
<h1 class=\"title\">${title}</h1>")

	file(WRITE ${footer} "</body></html>")
endfunction()

#
# Static HTML content:
#
copy(tesla.css ${HTML_BINDIR}/tesla.css)
install(FILES tesla.css DESTINATION ${HTML_OUTPUT})

add_subdirectory(images)

set(HTML
  "index -> Temporally Enhanced Security Logic Assertions (TESLA)"
  "build -> Getting started"
  "workflow -> Workflow"
  "environment -> Build environment"
  "freebsd -> Building FreeBSD"
  "programming -> Assertions and automata"
  "demos -> Demos"
)
foreach(page ${HTML})
	string(REPLACE " -> " ";" metadata ${page})
	list(GET metadata 0 base)
	list(GET metadata 1 title)

	set(OUTPUT "${HTML_BINDIR}/${base}-b.html")
	build_html_file(${OUTPUT} ${base} ${title})

	set(UCAMPAS_FILES ${UCAMPAS_FILES} ${OUTPUT})

	# If this isn't index.html, add it to ucampas' config file.
	if( NOT "${base}" STREQUAL "index" )
		set(UCONFIG_FILES "${UCONFIG_FILES} ${base}.html,")
	endif()

	install(FILES ${HTML_BINDIR}/${base}-b.html DESTINATION ${HTML_OUTPUT})
endforeach()

add_custom_target(html DEPENDS
	${HTML_BINDIR}/tesla.css
)

add_dependencies(doc html)

#
# If we have a local instance of UCampas, use it to generate HTML previews.
#
if( UCAMPAS_EXECUTABLE )
	add_custom_command(
		OUTPUT ${HTML_BINDIR}/index.html
		DEPENDS ${UCAMPAS_FILES}
		COMMAND ${UCAMPAS_EXECUTABLE} -q -r ${HTML_BINDIR}
		COMMENT "Processing HTML documentation with ucampas"
	)

	add_custom_target(html-preview DEPENDS ${HTML_BINDIR}/index.html)
	add_dependencies(doc html-preview)
endif()

#
# Describe the HTML files to ucampas.
#
configure_file(uconfig.txt ${HTML_BINDIR}/uconfig.txt)
install(FILES ${HTML_BINDIR}/uconfig.txt DESTINATION ${HTML_OUTPUT})
