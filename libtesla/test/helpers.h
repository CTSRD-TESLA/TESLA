
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

void	install_default_signal_handler();
void	print_backtrace();

