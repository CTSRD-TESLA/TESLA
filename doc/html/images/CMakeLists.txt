file(COPY
	conditional.png
	strict.png
	DESTINATION ${HTML_BINDIR}/images)

install(DIRECTORY ${HTML_BINDIR}/images DESTINATION ${HTML_OUTPUT})
