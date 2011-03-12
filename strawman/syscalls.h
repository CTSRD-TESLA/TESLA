#include "types.h"

#define	true	1
#define	false	0

#define	SYSCALL_FOO 1

#define	AUDIT_FOO	1

int check_auth(struct User *u, const char *filename);
void audit_submit(int event, const void *data);

int syscall(int id, const void *args);
int foo(struct User *user, const char *filename);

