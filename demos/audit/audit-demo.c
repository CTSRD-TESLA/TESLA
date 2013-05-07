#include "demo.h"

static void abort2(void);

int
main(int argc, char *argv[])
{
	return syscall();
}

int
syscall()
{
	int there_is_a_fatal_error = 1;

	if (there_is_a_fatal_error)
		abort2();

	return 0;
}

static void
abort2()
{
	struct uio *uio = NULL;
	struct ucred *user_credential = NULL;
	int error = 0;

	/*
	 * Arguments to pass to namei:
	 */
	struct nameidata nd;
	nd.ni_dirp = "/path/to/coredump";

	struct componentname *c = &nd.ni_cnd;
	c->cn_thread = curthread;

	/*
	 * ERROR: neglected to tell namei() to audit its arguments!
	 */
	c->cn_flags = 0;//AUDITVNODE1;

	error = namei(&nd);
	if (error != 0)
		return;

	struct file f;
	f.f_vnode = nd.ni_vp;

	vn_write(&f, uio, user_credential, 0, curthread);
}
