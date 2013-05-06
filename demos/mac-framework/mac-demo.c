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
	int error = 0;

	struct nameidata nd;
	nd.ni_dirp = "/path/to/something";

	/*
	 * Arguments to pass to namei:
	 */
	struct componentname *c = &nd.ni_cnd;
	c->cn_thread = curthread;
	c->cn_flags = 0;

	error = namei(&nd);
	if (error != 0)
		return (error);

	struct file f;
	f.f_vnode = nd.ni_vp;

	return vn_write(&f, NULL, NULL, 0, curthread);
}
