#include <stdarg.h>

#include "syscalls.h"

void audit_submit() {}

void
helper_which_asserts()
{
	// TODO: this is cheating... fixme.
	audit_event_assertion();
}

int
syscall(size_t len, ...)
{
	va_list args;
	va_start(args, len);

	for (size_t i = 0; i < len; i++) {
		int action = va_arg(args, int);
		switch(action) {
			case SUBMIT:
				audit_submit();
				break;

			case ASSERT:
				helper_which_asserts();
				break;
		}
	}
	va_end(args);

	return 0;
}
