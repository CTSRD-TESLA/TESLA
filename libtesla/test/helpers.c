#include <execinfo.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>

#include "helpers.h"


static void
signal_handler(int sig)
{
	fprintf(stderr, "Signal %d:\n", sig);
	print_backtrace();
	exit(1);
}

void
install_default_signal_handler()
{
	signal(11, signal_handler);
}

void
print_backtrace()
{
	void *array[10];
	size_t size = backtrace(array, 10);

	backtrace_symbols_fd(array, size, 2);
}

