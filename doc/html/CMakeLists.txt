#
# The ucampas tool converts bare HTML to the UCam house style.
#
set(UCAMPAS "/anfs/www/tools/bin/ucampas")

#
# Header and footer that fit within the ucampas world.
#
set(HEADER "
<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\">

<head>
<title>${TITLE}</title>
<link rel=\"stylesheet\" type=\"text/css\" href=\"tesla.css\"/>
</head>

<body>
")

set(FOOTER "
</body>
</html>
")

#
# Static HTML content:
#
configure_file(tesla.css ucam/tesla.css)

set(HTML index build)
foreach(base ${HTML})
	configure_file(${base}.html ucam/${base}-b.html)
	set(HTML_TARGETS "${HTML_TARGETS} ${base}.html")
endforeach()

#
# Generate a Makefile that can be run on UCam servers.
#
configure_file(uconfig.txt ucam/uconfig.txt)
configure_file(Makefile.in ucam/Makefile)
