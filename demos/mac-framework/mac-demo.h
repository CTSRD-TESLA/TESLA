#include "types.h"
#include "vnode.h"

int
vn_write(struct file *fp, struct uio *uio, struct ucred *active_cred,
	 int flags, struct thread *td);
