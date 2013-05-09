#include "demo.h"
#include <stdio.h>

struct thread the_thread;
struct thread *curthread = &the_thread;
struct vattr va_null;

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

void NDFREE(struct nameidata *np, const u_int flags)
{
}

void
vn_finished_write(struct mount *mp)
{
}

int
vn_open_vnode(struct vnode *vp, int fmode, struct ucred *cred,
	struct thread *td, struct file *fp)
{
	return 0;
}

int
vn_start_write(struct vnode *vp, struct mount **mpp, int flags)
{
	return 0;
}

void
vput(struct vnode *vp)
{
}

void
vrele(struct vnode *vp)
{
}
