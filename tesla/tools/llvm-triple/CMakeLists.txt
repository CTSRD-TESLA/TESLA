add_llvm_executable(llvm-triple llvm-triple.cpp)
install(TARGETS llvm-triple DESTINATION bin)

# Get the LLVM target triple (used by XFAIL in unit tests).
add_custom_command(TARGET llvm-triple POST_BUILD
	COMMAND llvm-triple
		| sh -c 'read T\; echo config.target_triple=\\"$$T\\"'
		> ${CMAKE_BINARY_DIR}/lit.site.cfg
	COMMENT "Checking host's LLVM triple..."
)
