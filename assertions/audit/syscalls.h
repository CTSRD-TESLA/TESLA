#ifndef	SYSCALLS_H
#define	SYSCALLS_H

#include <sys/types.h>

#include "tesla.h"

/* actions which can be performed in a syscall */
#define	NOOP	0
#define	SUBMIT	1
#define	ASSERT	2

/* simulate a syscall */
int	syscall(size_t len, ...);

#endif	/* SYSCALLS_H */
