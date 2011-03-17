#include <stdarg.h>
#include <stdlib.h>

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
	TESLA_ASSERT(syscall) {
		eventually(audit_submit());
	}
}

int
syscallenter(struct thread *td, struct syscall_args *sa)
{

	return (0);
}

void
syscallret(struct thread *td, int error, struct syscall_args *sa)
{

}

int
syscall(size_t len, ...)
{
	va_list args;
	va_start(args, len);

	syscallenter(NULL, NULL);
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
	syscallret(NULL, 0, NULL);
	return (0);
}
