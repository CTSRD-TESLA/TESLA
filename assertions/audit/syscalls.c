#include <stdarg.h>
#include <tesla/tesla.h>

#include "syscalls.h"

int
audit_submit()
{
	return 0;
}

void
helper_which_asserts()
{
	TESLA_ASSERT {
		eventually(audit_submit());
	}
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
