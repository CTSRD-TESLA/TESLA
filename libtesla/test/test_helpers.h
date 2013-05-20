#include <execinfo.h>
#include <signal.h>
#include <stdlib.h>

#ifdef NDEBUG
#error NDEBUG set but tests only work properly in debug mode
#endif

#define check(op) do { \
	int tesla_error = op; \
	if (tesla_error != TESLA_SUCCESS) { \
		print_backtrace(); \
		errx(1, "error at %s:%i in " #op ": %s", \
		     __FILE__, __LINE__, tesla_strerror(tesla_error)); \
	} \
} while(0)


void	print_backtrace(void);
void	install_default_signal_handler(void);

static void
signal_handler(int sig)
{
	fprintf(stderr, "Signal %d:\n", sig);
	print_backtrace();
	exit(1);
}

void
print_backtrace()
{
	void *array[10];
	size_t size = backtrace(array, 10);

	backtrace_symbols_fd(array, size, 2);
}

void
install_default_signal_handler()
{
	signal(11, signal_handler);
}

