
enum syscall_t {
	abort,
	open,
	read,
	write,
	close
};

/** Our model of a system call. */
int	syscall(enum syscall_t s, void *arg);


#include "types.h"

#include "capability.h"
#include "errno.h"
#include "fcntl.h"
#include "file.h"
#include "namei.h"
#include "proc.h"
#include "sdt.h"
#include "systm.h"
#include "vnode.h"

struct auditinfo;
struct auditinfo_addr;
struct proc;

#include "audit.h"
#include "mac_framework.h"
#include "mac_policy.h"

#include <tesla-macros.h>

extern struct thread *curthread;
#define	MAXPATHLEN	1024

int
kern_open(struct thread *td, char *path, enum uio_seg pathseg, int flags,
    int mode);

int
kern_openat(struct thread *td, int fd, char *path, enum uio_seg pathseg,
    int flags, int mode);

fo_rdwr_t	vn_write;
