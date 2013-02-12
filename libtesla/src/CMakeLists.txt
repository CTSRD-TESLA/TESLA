find_package(Threads REQUIRED)

add_library(tesla SHARED
	debug.c
	state.c
	state-global.c
	state-perthread.c
	store.c
	update.c
	util.c
)

target_link_libraries(tesla ${CMAKE_THREAD_LIBS_INIT})

install(TARGETS tesla DESTINATION lib)

