add_library(tesla SHARED
	debug.c
	state.c
	state-global.c
	state-perthread.c
	store.c
	update.c
	util.c
)

if( ${CMAKE_SYSTEM_NAME} MATCHES FreeBSD )
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -pthread")
endif( ${CMAKE_SYSTEM_NAME} MATCHES FreeBSD )

install(TARGETS tesla DESTINATION lib)

