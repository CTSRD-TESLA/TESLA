#include "demo.h"
#include <err.h>


int
main(int argc, char *argv[])
{
#ifdef AUDIT
	curthread->td_pflags = TDP_AUDITREC;
#endif

	int there_is_a_fatal_error = 1;

	if (there_is_a_fatal_error)
		return syscall(abort, "demo.core");

	return syscall(open, "/path/to/something");
}

int
syscall(enum syscall_t s, void *arg)
{
	switch (s) {
	case abort: {
		struct uio *uio = NULL;
		struct ucred *user_credential = NULL;
		int error = 0;

		/*
		 * Arguments to pass to namei:
		 */
		struct nameidata nd;
		nd.ni_dirp = arg;

		struct componentname *c = &nd.ni_cnd;
		c->cn_thread = curthread;

		/*
		 * ERROR: neglected to tell namei() to audit its arguments!
		 */
		c->cn_flags = 0;//AUDITVNODE1;

		error = namei(&nd);
		if (error != 0)
			return (error);

		struct file f;
		f.f_vnode = nd.ni_vp;

		return vn_write(&f, uio, user_credential, 0, curthread);
	}

	case open:
		return kern_open(curthread, arg, UIO_USERSPACE, 0, 0);

	default:
		err(-1, "unhandled system call ID %d", s);
	}
}
