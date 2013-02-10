add_library(tesla SHARED
	debug.c
	state.c
	state-global.c
	state-perthread.c
	store.c
	update.c
	util.c
)

install(TARGETS tesla DESTINATION lib)

