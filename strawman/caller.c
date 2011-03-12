#include <err.h>
#include <stdio.h>

#include "syscalls.h"

int main(int argc, char *argv[])
{
	char *filename = "/tmp/foo";
	if (argc > 1) filename = argv[1];

	printf("Calling 'foo' syscall...\n");

	int err = syscall(SYSCALL_FOO, filename);
	if (err) warn("Error in 'foo' syscall");
	else printf("'foo' syscall completed normally\n");

	return 0;
}

