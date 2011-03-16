#include <errno.h>
#include <stdio.h>

#include <tesla/tesla.h>

#include "syscalls.h"

#define VFS_LOCK_GIANT(MP) __extension__                                \
({                                                                      \
        int _locked;                                                    \
        struct mount *_mp;                                              \
        _mp = (MP);                                                     \
        if (VFS_NEEDSGIANT_(_mp)) {                                     \
                mtx_lock(&Giant);                                       \
                _locked = 1;                                            \
        } else                                                          \
                _locked = 0;                                            \
        _locked;                                                        \
})

#define WEIRD_C_THING(x) __extension__ \
({	\
	int foo = 42; \
	foo += 2 * x; \
	foo;	\
})

static int super_error = 0;

int helper(struct User *user, const char *filename)
{
	TESLA {
		previously(returned(check_auth(user, filename), 0))
		|| eventually(assigned(super_error, -1));
	};

	int y = WEIRD_C_THING(12);

	return EIO;
}

int
foo(struct User *user, const char *filename)
{
	static int seq = 0;
	int err;

	err = check_auth(user, filename);
	if (err) {
		/* We ought to return; let TESLA catch this. */
	}

	err = helper(user, filename);
	if (err) return err;
	
	/* Only submit audit record every second attempt. */
	if ((++seq % 2) == 0)
		audit_submit(AUDIT_FOO, filename);

	return 0;
}


int auth_attempt = 0;
int check_auth(struct User *u, const char *filename)
{
	u->id += 1;

	/* Disallow every third attempt. */
	if ((++auth_attempt % 2) == 0) {
		printf("%s %c %s is NOT allowed to access %s\n",
		       u->name->first, u->name->initial, u->name->last, filename);
		return EPERM;
	}

	return 0;
}

void audit_submit(int event, const void *data)
{
}


int
syscall(int id, const void *args)
{
	struct Name username;
	username.first = "Jonathan";
	username.initial = 'R';
	username.last = "Anderson";

	struct User user;

	int magic = 42;
	user.id = ++magic;
	user.id = ++magic;
	user.generation = 0;

	// Do something slightly tricky.
	{
		struct Name *uname_ptr;
		uname_ptr = (user.name = &username);
	}

	int err = ENOSYS;
	switch (id)
	{
		case SYSCALL_FOO:
			err = foo(&user, (const char*) args);
	}

	errno = err;
	return err;
}

