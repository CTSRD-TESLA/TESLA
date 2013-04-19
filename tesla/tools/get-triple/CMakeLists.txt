add_llvm_executable(tesla-get-triple get-triple.cpp)
install(TARGETS tesla-get-triple DESTINATION bin)

# Get the LLVM target triple (used by XFAIL in unit tests).
add_custom_command(TARGET tesla-get-triple POST_BUILD
	COMMAND tesla-get-triple
		| sh -c 'read T\; echo config.target_triple=\\"$$T\\"'
		> ${CMAKE_BINARY_DIR}/lit.site.cfg
	COMMENT "Checking host's LLVM triple..."
)
