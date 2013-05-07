#include "types.h"

#include "errno.h"
#include "file.h"
#include "namei.h"
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

int		syscall(void);
fo_rdwr_t	vn_write;
