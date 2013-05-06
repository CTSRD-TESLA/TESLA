#include "mac-demo.h"

#include "file.h"

int
main(int argc, char *argv[])
{
	return syscall();
}

int
syscall()
{
	struct uio *uio = NULL;
	struct ucred *user_credential = NULL;
	int error = 0;

	/*
	 * Arguments to pass to namei:
	 */
	struct nameidata nd;
	nd.ni_dirp = "/path/to/something";

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
