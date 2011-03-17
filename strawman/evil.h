#ifdef DO_WEIRD_THINGS

#define WEIRD_C_THING(x) __extension__ \
({	\
	int foo = 42; \
	foo += 2 * x; \
	foo;	\
})

#else	/* DO_WEIRD_THINGS */

#define WEIRD_C_THING(x) x

#endif	/* DO_WEIRD_THINGS */

