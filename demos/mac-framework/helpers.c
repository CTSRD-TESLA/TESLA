#include "mac-demo.h"
#include <stdio.h>

struct thread *curthread = (struct thread*) 0x42;

/*
 * no-op implementations of some important functions.
 */

void
audit_arg_upath1(struct thread *td, int dirfd, char *upath)
{
	printf("-- auditing path '%s' (in thread 0x%d)\n", upath, (int) td);
}

void
audit_arg_upath2(struct thread *td, int dirfd, char *upath)
{
	printf("-- auditing path '%s' (in thread 0x%d)\n", upath, (int) td);
}
