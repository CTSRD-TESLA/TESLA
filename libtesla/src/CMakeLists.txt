set(CMAKE_THREAD_PREFER_PTHREAD)
include(FindThreads)

add_library(tesla SHARED
	debug.c
	key.c
	state.c
	state-global.c
	state-perthread.c
	store.c
	tesla_dtrace.c
	tesla_notification.c
	update.c
	util.c
)

target_link_libraries(tesla ${CMAKE_THREAD_LIBS_INIT})


install(TARGETS tesla DESTINATION lib)

