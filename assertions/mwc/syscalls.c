#include <errno.h>
#include <stdarg.h>
#include <stdlib.h>

#include <tesla/tesla.h>

#include "syscalls.h"

/* arguments to internal functions */
#define	ZERO	(void *)0
#define	ONE	(void *)1
#define	TWO	(void *)2
#define	THREE	(void *)3
#define	FOUR	(void *)4

/*
 * Hack to pass in the desired return value without modifying the signature of
 * mac_vnode_check_write().
 */
static int desired_return_value;

struct ucred;
struct vnode;
int
mac_vnode_check_write(struct ucred *active_cred, struct ucred *file_cred,
    struct vnode *vp)
{

	return (desired_return_value);
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

void
mws_assert(struct ucred *active_cred, struct ucred *file_cred,
    struct vnode *vp)
{
	TESLA_ASSERT(syscall) {
		previously(returned(mac_vnode_check_write(active_cred,
		    file_cred, vp), 0));
	}
}

int
syscall(int action)
{

	syscallenter(NULL, NULL);
	switch(action) {
	case NOOP:
		break;

	case CHECK_ONLY:
		desired_return_value = 0;
		(void)mac_vnode_check_write(ONE, ONE, ONE);
		break;

	case CHECK_ASSERT:
		desired_return_value = 0;
		(void)mac_vnode_check_write(ONE, ONE, ONE);
		mws_assert(ONE, ONE, ONE);
		break;

	case BADCHECK_ASSERT:
		desired_return_value = EPERM;
		(void)mac_vnode_check_write(ONE, ONE, ONE);
		mws_assert(ONE, ONE, ONE);
		break;

	case ASSERT_ONLY:
		mws_assert(ONE, ONE, ONE);
		break;

	case WRONG_VNODE:
		desired_return_value = 0;
		(void)mac_vnode_check_write(TWO, TWO, TWO);
		mws_assert(ONE, ONE, ONE);
		break;

	case LASTRULE:
		mws_assert(TWO, TWO, TWO);
		break;

	case TWOPASS:
		desired_return_value = 0;
		(void)mac_vnode_check_write(ONE, ONE, ONE);
		(void)mac_vnode_check_write(TWO, TWO, TWO);
		mws_assert(ONE, ONE, ONE);
		mws_assert(TWO, TWO, TWO);
		break;

	case DOUBLECRED:
		(void)mac_vnode_check_write(ONE, ONE, ONE);
		mws_assert(ONE, ONE, TWO);
		break;

	case DOUBLEVNODE:
		(void)mac_vnode_check_write(ONE, ONE, ONE);
		mws_assert(TWO, TWO, ONE);
		break;
	}
	syscallret(NULL, 0, NULL);
	return (0);
}
