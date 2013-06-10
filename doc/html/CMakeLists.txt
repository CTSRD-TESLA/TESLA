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
# Header and footer that fit within the ucampas world.
#
function(header outvar title)
	set(${outvar}
"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\">

<head>
<title>${title}</title>
<link rel=\"stylesheet\" type=\"text/css\" href=\"tesla.css\"/>
</head>

<body>
<h1 class=\"title\">${title}</h1>"
	PARENT_SCOPE)
endfunction()

function(footer outvar)
	set(${outvar}
"</body>
</html>"
	PARENT_SCOPE)
endfunction()

#
# Static HTML content:
#
configure_file(tesla.css ${HTML_BINDIR}/tesla.css)
install(FILES tesla.css DESTINATION ${HTML_OUTPUT})

add_subdirectory(images)

set(HTML
  "index -> Temporally Enhanced Security Logic Assertions (TESLA)"
  "build -> Building TESLA"
  "workflow -> TESLA workflow"
  "environment -> Build environment"
  "freebsd -> Building FreeBSD with TESLA"
  "programming -> Programming with TESLA"
)
foreach(page ${HTML})
	string(REPLACE " -> " ";" metadata ${page})
	list(GET metadata 0 base)
	list(GET metadata 1 title)

	header(HEADER ${title})
	footer(FOOTER)

	set(INPUT "${base}.html")
	set(OUTPUT "${HTML_BINDIR}/${base}-b.html")

	configure_file(${INPUT} ${OUTPUT})
	set(HTML_TARGETS "${HTML_TARGETS} ${INPUT}")
	set(UCAMPAS_FILES ${UCAMPAS_FILES} ${OUTPUT})

	# If this isn't index.html, add it to ucampas' config file.
	if( NOT "${base}" STREQUAL "index" )
		set(UCONFIG_FILES "${UCONFIG_FILES} ${base}.html,")
	endif()

	install(FILES ${HTML_BINDIR}/${base}-b.html DESTINATION ${HTML_OUTPUT})
endforeach()

#
# If we have a local instance of UCampas, use it to generate HTML previews.
#
if( DEFINED UCAMPAS_EXECUTABLE )
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
