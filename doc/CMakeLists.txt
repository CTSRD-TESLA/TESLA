find_package(Doxygen)
find_package(PythonInterp)

add_custom_target(doc ALL)

if( DOXYGEN_FOUND)
	message("-- Using Doxygen to generate API documentation")

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

	make_directory(api)

	configure_file(Doxyfile.in Doxyfile)
	configure_file(api.htaccess api/.htaccess)

	add_custom_command(
		OUTPUT api/html/index.xhtml

		# In lieu of proper dependency checking, declare a dependency
		# on lots of stuff.
		DEPENDS
			${CMAKE_CURRENT_BINARY_DIR}/Doxyfile
			${CMAKE_SOURCE_DIR}/include/libtesla.h
			${CMAKE_SOURCE_DIR}/include/tesla.h
			${CMAKE_SOURCE_DIR}/include/tesla-macros.h
			tesla
			tesla-analyse
			tesla-cat
			tesla-get-triple
			tesla-graph
			tesla-instrument

		COMMAND ${DOXYGEN_EXECUTABLE} Doxyfile
		COMMENT "Generating API documentation"
	)

	add_custom_target(api-docs DEPENDS api/html/index.xhtml)
	add_dependencies(doc api-docs)
else()
	message("-- Doxygen not found; not generating API documentation")
endif()
