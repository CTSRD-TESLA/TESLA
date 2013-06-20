/*-
 * Copyright (c) 1989, 1993
 *	The Regents of the University of California.  All rights reserved.
 * (c) UNIX System Laboratories, Inc.
 * All or some portions of this file are derived from material licensed
 * to the University of California by American Telephone and Telegraph
 * Co. or Unix System Laboratories, Inc. and are reproduced herein with
 * the permission of UNIX System Laboratories, Inc.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 4. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 *	@(#)vfs_syscalls.c	8.13 (Berkeley) 4/15/94
 */

#include "demo.h"

#include <stdio.h>

#if 0
#include <sys/cdefs.h>
__FBSDID("$FreeBSD$");

#include "opt_capsicum.h"
#include "opt_compat.h"
#include "opt_kdtrace.h"
#include "opt_ktrace.h"

#include <sys/param.h>
#include <sys/systm.h>
#include <sys/bio.h>
#include <sys/buf.h>
#include <sys/capability.h>
#include <sys/disk.h>
#include <sys/sysent.h>
#include <sys/malloc.h>
#include <sys/mount.h>
#include <sys/mutex.h>
#include <sys/sysproto.h>
#include <sys/namei.h>
#include <sys/filedesc.h>
#include <sys/kernel.h>
#include <sys/fcntl.h>
#include <sys/file.h>
#include <sys/filio.h>
#include <sys/limits.h>
#include <sys/linker.h>
#include <sys/sdt.h>
#include <sys/stat.h>
#include <sys/sx.h>
#include <sys/unistd.h>
#include <sys/vnode.h>
#include <sys/priv.h>
#include <sys/proc.h>
#include <sys/dirent.h>
#include <sys/jail.h>
#include <sys/syscallsubr.h>
#include <sys/sysctl.h>
#ifdef KTRACE
#include <sys/ktrace.h>
#endif

#include <machine/stdarg.h>

#include <security/audit/audit.h>
#include <security/mac/mac_framework.h>

#include <vm/vm.h>
#include <vm/vm_object.h>
#include <vm/vm_page.h>
#include <vm/uma.h>

#include <ufs/ufs/quota.h>

MALLOC_DEFINE(M_FADVISE, "fadvise", "posix_fadvise(2) information");

SDT_PROVIDER_DEFINE(vfs);
SDT_PROBE_DEFINE(vfs, , stat, mode, mode);
SDT_PROBE_ARGTYPE(vfs, , stat, mode, 0, "char *");
SDT_PROBE_ARGTYPE(vfs, , stat, mode, 1, "int");
SDT_PROBE_DEFINE(vfs, , stat, reg, reg);
SDT_PROBE_ARGTYPE(vfs, , stat, reg, 0, "char *");
SDT_PROBE_ARGTYPE(vfs, , stat, reg, 1, "int");

static int chroot_refuse_vdir_fds(struct filedesc *fdp);
static int getutimes(const struct timeval *, enum uio_seg, struct timespec *);
static int setfflags(struct thread *td, struct vnode *, int);
static int setutimes(struct thread *td, struct vnode *,
    const struct timespec *, int, int);
static int vn_access(struct vnode *vp, int user_flags, struct ucred *cred,
    struct thread *td);

/*
 * The module initialization routine for POSIX asynchronous I/O will
 * set this to the version of AIO that it implements.  (Zero means
 * that it is not implemented.)  This value is used here by pathconf()
 * and in kern_descrip.c by fpathconf().
 */
int async_io_version;

#ifdef DEBUG
static int syncprt = 0;
SYSCTL_INT(_debug, OID_AUTO, syncprt, CTLFLAG_RW, &syncprt, 0, "");
#endif


/*
 * Sync each mounted filesystem.
 */
#ifndef _SYS_SYSPROTO_H_
struct sync_args {
	int     dummy;
};
#endif
/* ARGSUSED */
int
sys_sync(td, uap)
	struct thread *td;
	struct sync_args *uap;
{
	struct mount *mp, *nmp;
	int save;

	mtx_lock(&mountlist_mtx);
	for (mp = TAILQ_FIRST(&mountlist); mp != NULL; mp = nmp) {
		if (vfs_busy(mp, MBF_NOWAIT | MBF_MNTLSTLOCK)) {
			nmp = TAILQ_NEXT(mp, mnt_list);
			continue;
		}
		if ((mp->mnt_flag & MNT_RDONLY) == 0 &&
		    vn_start_write(NULL, &mp, V_NOWAIT) == 0) {
			save = curthread_pflags_set(TDP_SYNCIO);
			vfs_msync(mp, MNT_NOWAIT);
			VFS_SYNC(mp, MNT_NOWAIT);
			curthread_pflags_restore(save);
			vn_finished_write(mp);
		}
		mtx_lock(&mountlist_mtx);
		nmp = TAILQ_NEXT(mp, mnt_list);
		vfs_unbusy(mp);
	}
	mtx_unlock(&mountlist_mtx);
	return (0);
}

/*
 * Change filesystem quotas.
 */
#ifndef _SYS_SYSPROTO_H_
struct quotactl_args {
	char *path;
	int cmd;
	int uid;
	caddr_t arg;
};
#endif
int
sys_quotactl(td, uap)
	struct thread *td;
	register struct quotactl_args /* {
		char *path;
		int cmd;
		int uid;
		caddr_t arg;
	} */ *uap;
{
	struct mount *mp;
	int error;
	struct nameidata nd;

	AUDIT_ARG_CMD(uap->cmd);
	AUDIT_ARG_UID(uap->uid);
	if (!prison_allow(td->td_ucred, PR_ALLOW_QUOTAS))
		return (EPERM);
	NDINIT(&nd, LOOKUP, FOLLOW | LOCKLEAF | AUDITVNODE1,
	   UIO_USERSPACE, uap->path, td);
	if ((error = namei(&nd)) != 0)
		return (error);
	NDFREE(&nd, NDF_ONLY_PNBUF);
	mp = nd.ni_vp->v_mount;
	vfs_ref(mp);
	vput(nd.ni_vp);
	error = vfs_busy(mp, 0);
	vfs_rel(mp);
	if (error)
		return (error);
	error = VFS_QUOTACTL(mp, uap->cmd, uap->uid, uap->arg);

	/*
	 * Since quota on operation typically needs to open quota
	 * file, the Q_QUOTAON handler needs to unbusy the mount point
	 * before calling into namei.  Otherwise, unmount might be
	 * started between two vfs_busy() invocations (first is our,
	 * second is from mount point cross-walk code in lookup()),
	 * causing deadlock.
	 *
	 * Require that Q_QUOTAON handles the vfs_busy() reference on
	 * its own, always returning with ubusied mount point.
	 */
	if ((uap->cmd >> SUBCMDSHIFT) != Q_QUOTAON)
		vfs_unbusy(mp);
	return (error);
}

/*
 * Used by statfs conversion routines to scale the block size up if
 * necessary so that all of the block counts are <= 'max_size'.  Note
 * that 'max_size' should be a bitmask, i.e. 2^n - 1 for some non-zero
 * value of 'n'.
 */
void
statfs_scale_blocks(struct statfs *sf, long max_size)
{
	uint64_t count;
	int shift;

	KASSERT(powerof2(max_size + 1), ("%s: invalid max_size", __func__));

	/*
	 * Attempt to scale the block counts to give a more accurate
	 * overview to userland of the ratio of free space to used
	 * space.  To do this, find the largest block count and compute
	 * a divisor that lets it fit into a signed integer <= max_size.
	 */
	if (sf->f_bavail < 0)
		count = -sf->f_bavail;
	else
		count = sf->f_bavail;
	count = MAX(sf->f_blocks, MAX(sf->f_bfree, count));
	if (count <= max_size)
		return;

	count >>= flsl(max_size);
	shift = 0;
	while (count > 0) {
		shift++;
		count >>=1;
	}

	sf->f_bsize <<= shift;
	sf->f_blocks >>= shift;
	sf->f_bfree >>= shift;
	sf->f_bavail >>= shift;
}

/*
 * Get filesystem statistics.
 */
#ifndef _SYS_SYSPROTO_H_
struct statfs_args {
	char *path;
	struct statfs *buf;
};
#endif
int
sys_statfs(td, uap)
	struct thread *td;
	register struct statfs_args /* {
		char *path;
		struct statfs *buf;
	} */ *uap;
{
	struct statfs sf;
	int error;

	error = kern_statfs(td, uap->path, UIO_USERSPACE, &sf);
	if (error == 0)
		error = copyout(&sf, uap->buf, sizeof(sf));
	return (error);
}

int
kern_statfs(struct thread *td, char *path, enum uio_seg pathseg,
    struct statfs *buf)
{
	struct mount *mp;
	struct statfs *sp, sb;
	int error;
	struct nameidata nd;

	NDINIT(&nd, LOOKUP, FOLLOW | LOCKSHARED | LOCKLEAF |
	    AUDITVNODE1, pathseg, path, td);
	error = namei(&nd);
	if (error)
		return (error);
	mp = nd.ni_vp->v_mount;
	vfs_ref(mp);
	NDFREE(&nd, NDF_ONLY_PNBUF);
	vput(nd.ni_vp);
	error = vfs_busy(mp, 0);
	vfs_rel(mp);
	if (error)
		return (error);
#ifdef MAC
	error = mac_mount_check_stat(td->td_ucred, mp);
	if (error)
		goto out;
#endif
	/*
	 * Set these in case the underlying filesystem fails to do so.
	 */
	sp = &mp->mnt_stat;
	sp->f_version = STATFS_VERSION;
	sp->f_namemax = NAME_MAX;
	sp->f_flags = mp->mnt_flag & MNT_VISFLAGMASK;
	error = VFS_STATFS(mp, sp);
	if (error)
		goto out;
	if (priv_check(td, PRIV_VFS_GENERATION)) {
		bcopy(sp, &sb, sizeof(sb));
		sb.f_fsid.val[0] = sb.f_fsid.val[1] = 0;
		prison_enforce_statfs(td->td_ucred, mp, &sb);
		sp = &sb;
	}
	*buf = *sp;
out:
	vfs_unbusy(mp);
	return (error);
}

/*
 * Get filesystem statistics.
 */
#ifndef _SYS_SYSPROTO_H_
struct fstatfs_args {
	int fd;
	struct statfs *buf;
};
#endif
int
sys_fstatfs(td, uap)
	struct thread *td;
	register struct fstatfs_args /* {
		int fd;
		struct statfs *buf;
	} */ *uap;
{
	struct statfs sf;
	int error;

	error = kern_fstatfs(td, uap->fd, &sf);
	if (error == 0)
		error = copyout(&sf, uap->buf, sizeof(sf));
	return (error);
}

int
kern_fstatfs(struct thread *td, int fd, struct statfs *buf)
{
	struct file *fp;
	struct mount *mp;
	struct statfs *sp, sb;
	struct vnode *vp;
	int error;

	AUDIT_ARG_FD(fd);
	error = getvnode(td->td_proc->p_fd, fd, CAP_FSTATFS, &fp);
	if (error)
		return (error);
	vp = fp->f_vnode;
	vn_lock(vp, LK_SHARED | LK_RETRY);
#ifdef AUDIT
	AUDIT_ARG_VNODE1(vp);
#endif
	mp = vp->v_mount;
	if (mp)
		vfs_ref(mp);
	VOP_UNLOCK(vp, 0);
	fdrop(fp, td);
	if (mp == NULL) {
		error = EBADF;
		goto out;
	}
	error = vfs_busy(mp, 0);
	vfs_rel(mp);
	if (error)
		return (error);
#ifdef MAC
	error = mac_mount_check_stat(td->td_ucred, mp);
	if (error)
		goto out;
#endif
	/*
	 * Set these in case the underlying filesystem fails to do so.
	 */
	sp = &mp->mnt_stat;
	sp->f_version = STATFS_VERSION;
	sp->f_namemax = NAME_MAX;
	sp->f_flags = mp->mnt_flag & MNT_VISFLAGMASK;
	error = VFS_STATFS(mp, sp);
	if (error)
		goto out;
	if (priv_check(td, PRIV_VFS_GENERATION)) {
		bcopy(sp, &sb, sizeof(sb));
		sb.f_fsid.val[0] = sb.f_fsid.val[1] = 0;
		prison_enforce_statfs(td->td_ucred, mp, &sb);
		sp = &sb;
	}
	*buf = *sp;
out:
	if (mp)
		vfs_unbusy(mp);
	return (error);
}

/*
 * Get statistics on all filesystems.
 */
#ifndef _SYS_SYSPROTO_H_
struct getfsstat_args {
	struct statfs *buf;
	long bufsize;
	int flags;
};
#endif
int
sys_getfsstat(td, uap)
	struct thread *td;
	register struct getfsstat_args /* {
		struct statfs *buf;
		long bufsize;
		int flags;
	} */ *uap;
{

	return (kern_getfsstat(td, &uap->buf, uap->bufsize, UIO_USERSPACE,
	    uap->flags));
}

/*
 * If (bufsize > 0 && bufseg == UIO_SYSSPACE)
 * 	The caller is responsible for freeing memory which will be allocated
 *	in '*buf'.
 */
int
kern_getfsstat(struct thread *td, struct statfs **buf, size_t bufsize,
    enum uio_seg bufseg, int flags)
{
	struct mount *mp, *nmp;
	struct statfs *sfsp, *sp, sb;
	size_t count, maxcount;
	int error;

	maxcount = bufsize / sizeof(struct statfs);
	if (bufsize == 0)
		sfsp = NULL;
	else if (bufseg == UIO_USERSPACE)
		sfsp = *buf;
	else /* if (bufseg == UIO_SYSSPACE) */ {
		count = 0;
		mtx_lock(&mountlist_mtx);
		TAILQ_FOREACH(mp, &mountlist, mnt_list) {
			count++;
		}
		mtx_unlock(&mountlist_mtx);
		if (maxcount > count)
			maxcount = count;
		sfsp = *buf = malloc(maxcount * sizeof(struct statfs), M_TEMP,
		    M_WAITOK);
	}
	count = 0;
	mtx_lock(&mountlist_mtx);
	for (mp = TAILQ_FIRST(&mountlist); mp != NULL; mp = nmp) {
		if (prison_canseemount(td->td_ucred, mp) != 0) {
			nmp = TAILQ_NEXT(mp, mnt_list);
			continue;
		}
#ifdef MAC
		if (mac_mount_check_stat(td->td_ucred, mp) != 0) {
			nmp = TAILQ_NEXT(mp, mnt_list);
			continue;
		}
#endif
		if (vfs_busy(mp, MBF_NOWAIT | MBF_MNTLSTLOCK)) {
			nmp = TAILQ_NEXT(mp, mnt_list);
			continue;
		}
		if (sfsp && count < maxcount) {
			sp = &mp->mnt_stat;
			/*
			 * Set these in case the underlying filesystem
			 * fails to do so.
			 */
			sp->f_version = STATFS_VERSION;
			sp->f_namemax = NAME_MAX;
			sp->f_flags = mp->mnt_flag & MNT_VISFLAGMASK;
			/*
			 * If MNT_NOWAIT or MNT_LAZY is specified, do not
			 * refresh the fsstat cache. MNT_NOWAIT or MNT_LAZY
			 * overrides MNT_WAIT.
			 */
			if (((flags & (MNT_LAZY|MNT_NOWAIT)) == 0 ||
			    (flags & MNT_WAIT)) &&
			    (error = VFS_STATFS(mp, sp))) {
				mtx_lock(&mountlist_mtx);
				nmp = TAILQ_NEXT(mp, mnt_list);
				vfs_unbusy(mp);
				continue;
			}
			if (priv_check(td, PRIV_VFS_GENERATION)) {
				bcopy(sp, &sb, sizeof(sb));
				sb.f_fsid.val[0] = sb.f_fsid.val[1] = 0;
				prison_enforce_statfs(td->td_ucred, mp, &sb);
				sp = &sb;
			}
			if (bufseg == UIO_SYSSPACE)
				bcopy(sp, sfsp, sizeof(*sp));
			else /* if (bufseg == UIO_USERSPACE) */ {
				error = copyout(sp, sfsp, sizeof(*sp));
				if (error) {
					vfs_unbusy(mp);
					return (error);
				}
			}
			sfsp++;
		}
		count++;
		mtx_lock(&mountlist_mtx);
		nmp = TAILQ_NEXT(mp, mnt_list);
		vfs_unbusy(mp);
	}
	mtx_unlock(&mountlist_mtx);
	if (sfsp && count > maxcount)
		td->td_retval[0] = maxcount;
	else
		td->td_retval[0] = count;
	return (0);
}

#ifdef COMPAT_FREEBSD4
/*
 * Get old format filesystem statistics.
 */
static void cvtstatfs(struct statfs *, struct ostatfs *);

#ifndef _SYS_SYSPROTO_H_
struct freebsd4_statfs_args {
	char *path;
	struct ostatfs *buf;
};
#endif
int
freebsd4_statfs(td, uap)
	struct thread *td;
	struct freebsd4_statfs_args /* {
		char *path;
		struct ostatfs *buf;
	} */ *uap;
{
	struct ostatfs osb;
	struct statfs sf;
	int error;

	error = kern_statfs(td, uap->path, UIO_USERSPACE, &sf);
	if (error)
		return (error);
	cvtstatfs(&sf, &osb);
	return (copyout(&osb, uap->buf, sizeof(osb)));
}

/*
 * Get filesystem statistics.
 */
#ifndef _SYS_SYSPROTO_H_
struct freebsd4_fstatfs_args {
	int fd;
	struct ostatfs *buf;
};
#endif
int
freebsd4_fstatfs(td, uap)
	struct thread *td;
	struct freebsd4_fstatfs_args /* {
		int fd;
		struct ostatfs *buf;
	} */ *uap;
{
	struct ostatfs osb;
	struct statfs sf;
	int error;

	error = kern_fstatfs(td, uap->fd, &sf);
	if (error)
		return (error);
	cvtstatfs(&sf, &osb);
	return (copyout(&osb, uap->buf, sizeof(osb)));
}

/*
 * Get statistics on all filesystems.
 */
#ifndef _SYS_SYSPROTO_H_
struct freebsd4_getfsstat_args {
	struct ostatfs *buf;
	long bufsize;
	int flags;
};
#endif
int
freebsd4_getfsstat(td, uap)
	struct thread *td;
	register struct freebsd4_getfsstat_args /* {
		struct ostatfs *buf;
		long bufsize;
		int flags;
	} */ *uap;
{
	struct statfs *buf, *sp;
	struct ostatfs osb;
	size_t count, size;
	int error;

	count = uap->bufsize / sizeof(struct ostatfs);
	size = count * sizeof(struct statfs);
	error = kern_getfsstat(td, &buf, size, UIO_SYSSPACE, uap->flags);
	if (size > 0) {
		count = td->td_retval[0];
		sp = buf;
		while (count > 0 && error == 0) {
			cvtstatfs(sp, &osb);
			error = copyout(&osb, uap->buf, sizeof(osb));
			sp++;
			uap->buf++;
			count--;
		}
		free(buf, M_TEMP);
	}
	return (error);
}

/*
 * Implement fstatfs() for (NFS) file handles.
 */
#ifndef _SYS_SYSPROTO_H_
struct freebsd4_fhstatfs_args {
	struct fhandle *u_fhp;
	struct ostatfs *buf;
};
#endif
int
freebsd4_fhstatfs(td, uap)
	struct thread *td;
	struct freebsd4_fhstatfs_args /* {
		struct fhandle *u_fhp;
		struct ostatfs *buf;
	} */ *uap;
{
	struct ostatfs osb;
	struct statfs sf;
	fhandle_t fh;
	int error;

	error = copyin(uap->u_fhp, &fh, sizeof(fhandle_t));
	if (error)
		return (error);
	error = kern_fhstatfs(td, fh, &sf);
	if (error)
		return (error);
	cvtstatfs(&sf, &osb);
	return (copyout(&osb, uap->buf, sizeof(osb)));
}

/*
 * Convert a new format statfs structure to an old format statfs structure.
 */
static void
cvtstatfs(nsp, osp)
	struct statfs *nsp;
	struct ostatfs *osp;
{

	statfs_scale_blocks(nsp, LONG_MAX);
	bzero(osp, sizeof(*osp));
	osp->f_bsize = nsp->f_bsize;
	osp->f_iosize = MIN(nsp->f_iosize, LONG_MAX);
	osp->f_blocks = nsp->f_blocks;
	osp->f_bfree = nsp->f_bfree;
	osp->f_bavail = nsp->f_bavail;
	osp->f_files = MIN(nsp->f_files, LONG_MAX);
	osp->f_ffree = MIN(nsp->f_ffree, LONG_MAX);
	osp->f_owner = nsp->f_owner;
	osp->f_type = nsp->f_type;
	osp->f_flags = nsp->f_flags;
	osp->f_syncwrites = MIN(nsp->f_syncwrites, LONG_MAX);
	osp->f_asyncwrites = MIN(nsp->f_asyncwrites, LONG_MAX);
	osp->f_syncreads = MIN(nsp->f_syncreads, LONG_MAX);
	osp->f_asyncreads = MIN(nsp->f_asyncreads, LONG_MAX);
	strlcpy(osp->f_fstypename, nsp->f_fstypename,
	    MIN(MFSNAMELEN, OMFSNAMELEN));
	strlcpy(osp->f_mntonname, nsp->f_mntonname,
	    MIN(MNAMELEN, OMNAMELEN));
	strlcpy(osp->f_mntfromname, nsp->f_mntfromname,
	    MIN(MNAMELEN, OMNAMELEN));
	osp->f_fsid = nsp->f_fsid;
}
#endif /* COMPAT_FREEBSD4 */

/*
 * Change current working directory to a given file descriptor.
 */
#ifndef _SYS_SYSPROTO_H_
struct fchdir_args {
	int	fd;
};
#endif
int
sys_fchdir(td, uap)
	struct thread *td;
	struct fchdir_args /* {
		int fd;
	} */ *uap;
{
	register struct filedesc *fdp = td->td_proc->p_fd;
	struct vnode *vp, *tdp, *vpold;
	struct mount *mp;
	struct file *fp;
	int error;

	AUDIT_ARG_FD(uap->fd);
	if ((error = getvnode(fdp, uap->fd, CAP_FCHDIR, &fp)) != 0)
		return (error);
	vp = fp->f_vnode;
	VREF(vp);
	fdrop(fp, td);
	vn_lock(vp, LK_SHARED | LK_RETRY);
	AUDIT_ARG_VNODE1(vp);
	error = change_dir(vp, td);
	while (!error && (mp = vp->v_mountedhere) != NULL) {
		if (vfs_busy(mp, 0))
			continue;
		error = VFS_ROOT(mp, LK_SHARED, &tdp);
		vfs_unbusy(mp);
		if (error)
			break;
		vput(vp);
		vp = tdp;
	}
	if (error) {
		vput(vp);
		return (error);
	}
	VOP_UNLOCK(vp, 0);
	FILEDESC_XLOCK(fdp);
	vpold = fdp->fd_cdir;
	fdp->fd_cdir = vp;
	FILEDESC_XUNLOCK(fdp);
	vrele(vpold);
	return (0);
}

/*
 * Change current working directory (``.'').
 */
#ifndef _SYS_SYSPROTO_H_
struct chdir_args {
	char	*path;
};
#endif
int
sys_chdir(td, uap)
	struct thread *td;
	struct chdir_args /* {
		char *path;
	} */ *uap;
{

	return (kern_chdir(td, uap->path, UIO_USERSPACE));
}

int
kern_chdir(struct thread *td, char *path, enum uio_seg pathseg)
{
	register struct filedesc *fdp = td->td_proc->p_fd;
	int error;
	struct nameidata nd;
	struct vnode *vp;

	NDINIT(&nd, LOOKUP, FOLLOW | LOCKSHARED | LOCKLEAF | AUDITVNODE1,
	    pathseg, path, td);
	if ((error = namei(&nd)) != 0)
		return (error);
	if ((error = change_dir(nd.ni_vp, td)) != 0) {
		vput(nd.ni_vp);
		NDFREE(&nd, NDF_ONLY_PNBUF);
		return (error);
	}
	VOP_UNLOCK(nd.ni_vp, 0);
	NDFREE(&nd, NDF_ONLY_PNBUF);
	FILEDESC_XLOCK(fdp);
	vp = fdp->fd_cdir;
	fdp->fd_cdir = nd.ni_vp;
	FILEDESC_XUNLOCK(fdp);
	vrele(vp);
	return (0);
}

/*
 * Helper function for raised chroot(2) security function:  Refuse if
 * any filedescriptors are open directories.
 */
static int
chroot_refuse_vdir_fds(fdp)
	struct filedesc *fdp;
{
	struct vnode *vp;
	struct file *fp;
	int fd;

	FILEDESC_LOCK_ASSERT(fdp);

	for (fd = 0; fd < fdp->fd_nfiles ; fd++) {
		fp = fget_locked(fdp, fd);
		if (fp == NULL)
			continue;
		if (fp->f_type == DTYPE_VNODE) {
			vp = fp->f_vnode;
			if (vp->v_type == VDIR)
				return (EPERM);
		}
	}
	return (0);
}

/*
 * This sysctl determines if we will allow a process to chroot(2) if it
 * has a directory open:
 *	0: disallowed for all processes.
 *	1: allowed for processes that were not already chroot(2)'ed.
 *	2: allowed for all processes.
 */

static int chroot_allow_open_directories = 1;

SYSCTL_INT(_kern, OID_AUTO, chroot_allow_open_directories, CTLFLAG_RW,
     &chroot_allow_open_directories, 0,
     "Allow a process to chroot(2) if it has a directory open");

/*
 * Change notion of root (``/'') directory.
 */
#ifndef _SYS_SYSPROTO_H_
struct chroot_args {
	char	*path;
};
#endif
int
sys_chroot(td, uap)
	struct thread *td;
	struct chroot_args /* {
		char *path;
	} */ *uap;
{
	int error;
	struct nameidata nd;

	error = priv_check(td, PRIV_VFS_CHROOT);
	if (error)
		return (error);
	NDINIT(&nd, LOOKUP, FOLLOW | LOCKSHARED | LOCKLEAF |
	    AUDITVNODE1, UIO_USERSPACE, uap->path, td);
	error = namei(&nd);
	if (error)
		goto error;
	if ((error = change_dir(nd.ni_vp, td)) != 0)
		goto e_vunlock;
#ifdef MAC
	if ((error = mac_vnode_check_chroot(td->td_ucred, nd.ni_vp)))
		goto e_vunlock;
#endif
	VOP_UNLOCK(nd.ni_vp, 0);
	error = change_root(nd.ni_vp, td);
	vrele(nd.ni_vp);
	NDFREE(&nd, NDF_ONLY_PNBUF);
	return (error);
e_vunlock:
	vput(nd.ni_vp);
error:
	NDFREE(&nd, NDF_ONLY_PNBUF);
	return (error);
}

/*
 * Common routine for chroot and chdir.  Callers must provide a locked vnode
 * instance.
 */
int
change_dir(vp, td)
	struct vnode *vp;
	struct thread *td;
{
	int error;

	ASSERT_VOP_LOCKED(vp, "change_dir(): vp not locked");
	if (vp->v_type != VDIR)
		return (ENOTDIR);
#ifdef MAC
	error = mac_vnode_check_chdir(td->td_ucred, vp);
	if (error)
		return (error);
#endif
	error = VOP_ACCESS(vp, VEXEC, td->td_ucred, td);
	return (error);
}

/*
 * Common routine for kern_chroot() and jail_attach().  The caller is
 * responsible for invoking priv_check() and mac_vnode_check_chroot() to
 * authorize this operation.
 */
int
change_root(vp, td)
	struct vnode *vp;
	struct thread *td;
{
	struct filedesc *fdp;
	struct vnode *oldvp;
	int error;

	fdp = td->td_proc->p_fd;
	FILEDESC_XLOCK(fdp);
	if (chroot_allow_open_directories == 0 ||
	    (chroot_allow_open_directories == 1 && fdp->fd_rdir != rootvnode)) {
		error = chroot_refuse_vdir_fds(fdp);
		if (error) {
			FILEDESC_XUNLOCK(fdp);
			return (error);
		}
	}
	oldvp = fdp->fd_rdir;
	fdp->fd_rdir = vp;
	VREF(fdp->fd_rdir);
	if (!fdp->fd_jdir) {
		fdp->fd_jdir = vp;
		VREF(fdp->fd_jdir);
	}
	FILEDESC_XUNLOCK(fdp);
	vrele(oldvp);
	return (0);
}

static __inline cap_rights_t
flags_to_rights(int flags)
{
	cap_rights_t rights = 0;

	if (flags & O_EXEC) {
		rights |= CAP_FEXECVE;
	} else {
		switch ((flags & O_ACCMODE)) {
		case O_RDONLY:
			rights |= CAP_READ;
			break;
		case O_RDWR:
			rights |= CAP_READ;
			/* FALLTHROUGH */
		case O_WRONLY:
			rights |= CAP_WRITE;
			break;
		}
	}

	if (flags & O_CREAT)
		rights |= CAP_CREATE;

	if (flags & O_TRUNC)
		rights |= CAP_FTRUNCATE;

	if ((flags & O_EXLOCK) || (flags & O_SHLOCK))
		rights |= CAP_FLOCK;

	return (rights);
}
#endif

/*
 * Check permissions, allocate an open file structure, and call the device
 * open routine if any.
 */
#ifndef _SYS_SYSPROTO_H_
struct open_args {
	char	*path;
	int	flags;
	int	mode;
};
#endif
int
sys_open(td, uap)
	struct thread *td;
	register struct open_args /* {
		char *path;
		int flags;
		int mode;
	} */ *uap;
{

	return (kern_open(td, uap->path, UIO_USERSPACE, uap->flags, uap->mode));
}

#ifndef _SYS_SYSPROTO_H_
struct openat_args {
	int	fd;
	char	*path;
	int	flag;
	int	mode;
};
#endif
int
sys_openat(struct thread *td, struct openat_args *uap)
{

	return (kern_openat(td, uap->fd, uap->path, UIO_USERSPACE, uap->flag,
	    uap->mode));
}

int
kern_open(struct thread *td, char *path, enum uio_seg pathseg, int flags,
    int mode)
{
#ifdef AUDIT
#ifdef TESLA
	TESLA_WITHIN(syscall, eventually(
		called(audit_arg_upath1(td, ANY(int), ANY(ptr)))
	));
#endif
#endif

	printf("-- opening '%s'...\n", path);
	return (kern_openat(td, AT_FDCWD, path, pathseg, flags, mode));
}

int
kern_openat(struct thread *td, int fd, char *path, enum uio_seg pathseg,
    int flags, int mode)
{
	struct file *fp = NULL;
	int cmode = 0;
	int error;
	struct nameidata nd;
	cap_rights_t rights_needed = CAP_LOOKUP;

#if 0
	AUDIT_ARG_FFLAGS(flags);
	AUDIT_ARG_MODE(mode);
	/* XXX: audit dirfd */
	rights_needed |= flags_to_rights(flags);
	/*
	 * Only one of the O_EXEC, O_RDONLY, O_WRONLY and O_RDWR flags
	 * may be specified.
	 */
	if (flags & O_EXEC) {
		if (flags & O_ACCMODE)
			return (EINVAL);
	} else if ((flags & O_ACCMODE) == O_ACCMODE) {
		return (EINVAL);
	} else {
		flags = FFLAGS(flags);
	}

	/*
	 * Allocate the file descriptor, but don't install a descriptor yet.
	 */
	error = falloc_noinstall(td, &fp);
	if (error)
		return (error);
	/*
	 * An extra reference on `fp' has been held for us by
	 * falloc_noinstall().
	 */
	/* Set the flags early so the finit in devfs can pick them up. */
	fp->f_flag = flags & FMASK;
	cmode = ((mode &~ fdp->fd_cmask) & ALLPERMS) &~ S_ISTXT;
#endif
	NDINIT_ATRIGHTS(&nd, LOOKUP, FOLLOW | AUDITVNODE1, pathseg,
	    path, fd, rights_needed, td);
	td->td_dupfd = -1;		/* XXX check for fdopen */
	error = vn_open(&nd, &flags, cmode, fp);
#if 0
	if (error) {
		/*
		 * If the vn_open replaced the method vector, something
		 * wonderous happened deep below and we just pass it up
		 * pretending we know what we do.
		 */
		if (error == ENXIO && fp->f_ops != &badfileops)
			goto success;

		/*
		 * Handle special fdopen() case. bleh.
		 *
		 * Don't do this for relative (capability) lookups; we don't
		 * understand exactly what would happen, and we don't think
		 * that it ever should.
		 */
		if (nd.ni_strictrelative == 0 &&
		    (error == ENODEV || error == ENXIO) &&
		    td->td_dupfd >= 0) {
			error = dupfdopen(td, fdp, td->td_dupfd, flags, error,
			    &indx);
			if (error == 0)
				goto success;
		}

		if (error == ERESTART)
			error = EINTR;
		goto bad_unlocked;
	}
	td->td_dupfd = 0;
	NDFREE(&nd, NDF_ONLY_PNBUF);
	vp = nd.ni_vp;

	/*
	 * Store the vnode, for any f_type. Typically, the vnode use
	 * count is decremented by direct call to vn_closefile() for
	 * files that switched type in the cdevsw fdopen() method.
	 */
	fp->f_vnode = vp;
	/*
	 * If the file wasn't claimed by devfs bind it to the normal
	 * vnode operations here.
	 */
	if (fp->f_ops == &badfileops) {
		KASSERT(vp->v_type != VFIFO, ("Unexpected fifo."));
		fp->f_seqcount = 1;
		finit(fp, (flags & FMASK) | (fp->f_flag & FHASLOCK), DTYPE_VNODE,
		    vp, &vnops);
	}

	VOP_UNLOCK(vp, 0);
	if (flags & O_TRUNC) {
		error = fo_truncate(fp, 0, td->td_ucred, td);
		if (error)
			goto bad;
	}
success:
	/*
	 * If we haven't already installed the FD (for dupfdopen), do so now.
	 */
	if (indx == -1) {
#ifdef CAPABILITIES
		if (nd.ni_strictrelative == 1) {
			/*
			 * We are doing a strict relative lookup; wrap the
			 * result in a capability.
			 */
			if ((error = kern_capwrap(td, fp, nd.ni_baserights,
			    &indx)) != 0)
				goto bad_unlocked;
		} else
#endif
			if ((error = finstall(td, fp, &indx, flags)) != 0)
				goto bad_unlocked;

	}

	/*
	 * Release our private reference, leaving the one associated with
	 * the descriptor table intact.
	 */
	fdrop(fp, td);
	td->td_retval[0] = indx;
	return (0);
bad:
bad_unlocked:
	KASSERT(indx == -1, ("indx=%d, should be -1", indx));
	fdrop(fp, td);
	return (error);
#endif
	return (error);
}
