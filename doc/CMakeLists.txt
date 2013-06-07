find_package(Doxygen)
find_package(GraphViz)
find_package(PythonInterp)

add_custom_target(doc ALL)

#
# Where we will install documentation.
#
if( "${HTML_OUTPUT}" STREQUAL "" )
	set(HTML_OUTPUT share/doc/tesla/html)
endif()
message("-- HTML documentation will be installed in ${HTML_OUTPUT}")

#
# Static HTML content.
#
add_subdirectory(html)


#
# Doxgyen-generated API documentation.
#
if( DOXYGEN_FOUND)
	message("-- Using Doxygen to generate API documentation")

	#
	# Staging locations for Doxygen output in the build directory.
	#
	if( "${DOXYGEN_HTML}" STREQUAL "" )
		set(DOXYGEN_HTML ${CMAKE_CURRENT_BINARY_DIR}/doxygen/html/api)
	endif()
	message("-- Doxygen HTML will be staged in ${DOXYGEN_HTML}")

	if( "${DOXYGEN_MAN}" STREQUAL "" )
		set(DOXYGEN_MAN ${CMAKE_CURRENT_BINARY_DIR}/doxygen/man)
	endif()
	message("-- Doxygen man pages will be staged in ${DOXYGEN_MAN}")

	set(DOXYGEN_MAN3 ${DOXYGEN_MAN}/man3)

	make_directory(${DOXYGEN_HTML})
	make_directory(${DOXYGEN_MAN})

	#
	# We use a Python script to convert .proto files into something that
	# Doxygen can understand
	#
	if( PYTHONINTERP_FOUND )
		set(PROTOBUF_FILTER ${CMAKE_CURRENT_SOURCE_DIR}/proto2cpp.py)
	else()
		message("-- Python not found; protobuf API docs unavailable")
		set(PROTOBUF_FILTER true)
	endif()

	configure_file(Doxyfile.in Doxyfile)
	configure_file(api.htaccess ${DOXYGEN_HTML}/.htaccess)

	add_custom_command(
		OUTPUT
			${DOXYGEN_HTML}/index.xhtml
			${DOXYGEN_MAN3}/tesla.3

		# In lieu of proper dependency checking, declare a dependency
		# on lots of stuff.
		DEPENDS
			${CMAKE_CURRENT_BINARY_DIR}/Doxyfile
			${CMAKE_SOURCE_DIR}/include/libtesla.h
			${CMAKE_SOURCE_DIR}/include/tesla.h
			${CMAKE_SOURCE_DIR}/include/tesla-macros.h
			${CMAKE_SOURCE_DIR}/tesla/common/tesla.proto
			tesla
			TeslaCommon

		COMMAND ${DOXYGEN_EXECUTABLE} Doxyfile
		COMMENT "Generating API documentation"
	)

	add_custom_target(api-docs DEPENDS
		${DOXYGEN_HTML}/index.xhtml
		${DOXYGEN_MAN3}/tesla.3
	)
	add_dependencies(doc api-docs)

	install(DIRECTORY ${DOXYGEN_HTML} DESTINATION ${HTML_OUTPUT})
	install(DIRECTORY ${DOXYGEN_MAN3} DESTINATION share/man)
else()
	message("-- Doxygen not found; not generating API documentation")
endif()
