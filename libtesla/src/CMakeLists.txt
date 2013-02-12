add_library(tesla SHARED
	debug.c
	state.c
	state-global.c
	state-perthread.c
	store.c
	update.c
	util.c
)

find_library(Threads REQUIRED)
if(CMAKE_USE_PTHREADS_INIT)
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CMAKE_THREAD_LIBS_INIT}")
endif(CMAKE_USE_PTHREADS_INIT)

install(TARGETS tesla DESTINATION lib)

