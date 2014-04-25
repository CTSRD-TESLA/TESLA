# We need to use configure_file() rather than file(COPY) because we want to
# rename the script.
configure_file(highlight-transitions
	${CMAKE_BINARY_DIR}/tesla/tesla-highlight COPYONLY)

install(PROGRAMS ${CMAKE_BINARY_DIR}/tesla/tesla-highlight DESTINATION bin)
install(PROGRAMS tesla DESTINATION bin)
