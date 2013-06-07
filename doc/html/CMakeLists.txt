#
# The ucampas tool converts bare HTML to the UCam house style.
#
set(UCAMPAS "/anfs/www/tools/bin/ucampas")

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
<h1>${title}</h1>"
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
configure_file(tesla.css tesla.css)
file(COPY images DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
install(FILES tesla.css DESTINATION ${HTML_OUTPUT})
install(DIRECTORY images DESTINATION ${HTML_OUTPUT})

set(HTML
  "index -> Temporally Enhanced Security Logic Assertions (TESLA)"
  "build -> Building TESLA"
  "freebsd -> Building FreeBSD with TESLA"
  "programming -> Programming with TESLA"
)
foreach(page ${HTML})
	string(REPLACE " -> " ";" metadata ${page})
	list(GET metadata 0 base)
	list(GET metadata 1 title)

	header(HEADER ${title})
	footer(FOOTER)

	configure_file(${base}.html ${base}-b.html)
	set(HTML_TARGETS "${HTML_TARGETS} ${base}.html")
	install(FILES ${base}-b.html DESTINATION ${HTML_OUTPUT})
endforeach()

#
# Create the ucampas build system.
#
configure_file(uconfig.txt uconfig.txt)
configure_file(Makefile.in Makefile)

install(FILES Makefile uconfig.txt DESTINATION ${HTML_OUTPUT})
