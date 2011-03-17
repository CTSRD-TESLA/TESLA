#ifndef	SYSCALLS_H
#define	SYSCALLS_H

#include <sys/types.h>

/* actions which can be performed in a syscall */
#define	NOOP		0
#define	CHECK_ONLY	1
#define	CHECK_ASSERT	2
#define	BADCHECK_ASSERT	3
#define	ASSERT_ONLY	4
#define	WRONG_VNODE	5
#define	LASTRULE	6
#define	TWOPASS		7
#define	DOUBLECRED	8
#define	DOUBLEVNODE	9

/* simulate a syscall */
int	syscall(int action);

struct thread;
struct syscall_args;
int	syscallenter(struct thread *td, struct syscall_args *sa);
void	syscallret(struct thread *td, int error, struct syscall_args *sa);

#endif	/* SYSCALLS_H */
