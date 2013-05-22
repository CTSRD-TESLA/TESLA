/*-
 * Copyright (c) 1982, 1986, 1989, 1993
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
 *	@(#)vfs_vnops.c	8.2 (Berkeley) 1/21/94
 */

#include <sys/cdefs.h>
__FBSDID("$FreeBSD$");

#include "demo.h"

#include <stdio.h>
#include <tesla-macros.h>

int
vn_open(ndp, flagp, cmode, fp)
	struct nameidata *ndp;
	int *flagp, cmode;
	struct file *fp;
{
	struct thread *td = ndp->ni_cnd.cn_thread;

	return (vn_open_cred(ndp, flagp, cmode, 0, td->td_ucred, fp));
}

/*
 * Common code for vnode open operations via a name lookup.
 * Lookup the vnode and invoke VOP_CREATE if needed.
 * Check permissions, and call the VOP_OPEN or VOP_CREATE routine.
 *
 * Note that this does NOT free nameidata for the successful case,
 * due to the NDINIT being done elsewhere.
 */
int
vn_open_cred(struct nameidata *ndp, int *flagp, int cmode, u_int vn_open_flags,
    struct ucred *cred, struct file *fp)
{
	struct vnode *vp;
	struct mount *mp;
	struct thread *td = ndp->ni_cnd.cn_thread;
	struct vattr vat;
	struct vattr *vap = &vat;
	int fmode, error;

#if 0
restart:
#endif
	fmode = *flagp;
	if (fmode & O_CREAT) {
		ndp->ni_cnd.cn_nameiop = CREATE;
		ndp->ni_cnd.cn_flags = ISOPEN | LOCKPARENT | LOCKLEAF;
		if ((fmode & O_EXCL) == 0 && (fmode & O_NOFOLLOW) == 0)
			ndp->ni_cnd.cn_flags |= FOLLOW;
		if (!(vn_open_flags & VN_OPEN_NOAUDIT))
			ndp->ni_cnd.cn_flags |= AUDITVNODE1;
		if (vn_open_flags & VN_OPEN_NOCAPCHECK)
			ndp->ni_cnd.cn_flags |= NOCAPCHECK;
#if 0
		bwillwrite();
#endif
		if ((error = namei(ndp)) != 0)
			return (error);
		if (ndp->ni_vp == NULL) {
			VATTR_NULL(vap);
			vap->va_type = VREG;
			vap->va_mode = cmode;
			if (fmode & O_EXCL)
				vap->va_vaflags |= VA_EXCLUSIVE;
			if (vn_start_write(ndp->ni_dvp, &mp, V_NOWAIT) != 0) {
				NDFREE(ndp, NDF_ONLY_PNBUF);
				vput(ndp->ni_dvp);
#if 0
				if ((error = vn_start_write(NULL, &mp,
				    V_XSLEEP | PCATCH)) != 0)
					return (error);
				goto restart;
#endif
			}
#ifdef MAC
			error = mac_vnode_check_create(cred, ndp->ni_dvp,
			    &ndp->ni_cnd, vap);
			if (error == 0)
#endif
			{
#if 0
				error = VOP_CREATE(ndp->ni_dvp, &ndp->ni_vp,
						   &ndp->ni_cnd, vap);
#endif
			}
			vput(ndp->ni_dvp);
			vn_finished_write(mp);
			if (error) {
				NDFREE(ndp, NDF_ONLY_PNBUF);
				return (error);
			}
			fmode &= ~O_TRUNC;
			vp = ndp->ni_vp;
		} else {
			if (ndp->ni_dvp == ndp->ni_vp)
				vrele(ndp->ni_dvp);
			else
				vput(ndp->ni_dvp);
			ndp->ni_dvp = NULL;
			vp = ndp->ni_vp;
			if (fmode & O_EXCL) {
				error = EEXIST;
				goto bad;
			}
			fmode &= ~O_CREAT;
		}
	} else {
		ndp->ni_cnd.cn_nameiop = LOOKUP;
		ndp->ni_cnd.cn_flags = ISOPEN |
		    ((fmode & O_NOFOLLOW) ? NOFOLLOW : FOLLOW) | LOCKLEAF;
		if (!(fmode & FWRITE))
			ndp->ni_cnd.cn_flags |= LOCKSHARED;
#if 0
		if (!(vn_open_flags & VN_OPEN_NOAUDIT))
			ndp->ni_cnd.cn_flags |= AUDITVNODE1;
#endif
		if (vn_open_flags & VN_OPEN_NOCAPCHECK)
			ndp->ni_cnd.cn_flags |= NOCAPCHECK;
		if ((error = namei(ndp)) != 0)
			return (error);
		vp = ndp->ni_vp;
	}
	error = vn_open_vnode(vp, fmode, cred, td, fp);
	if (error)
		goto bad;
	*flagp = fmode;
	return (0);
bad:
	NDFREE(ndp, NDF_ONLY_PNBUF);
	vput(vp);
	*flagp = fmode;
	ndp->ni_vp = NULL;
	return (error);
}

#if 0
/*
 * File table vnode read routine.
 */
static int
vn_read(fp, uio, active_cred, flags, td)
	struct file *fp;
	struct uio *uio;
	struct ucred *active_cred;
	int flags;
	struct thread *td;
{
	struct vnode *vp;
	struct mtx *mtxp;
	int error, ioflag;
	int advice;
	off_t offset, start, end;

	KASSERT(uio->uio_td == td, ("uio_td %p is not td %p",
	    uio->uio_td, td));
	KASSERT(flags & FOF_OFFSET, ("No FOF_OFFSET"));
	vp = fp->f_vnode;
	ioflag = 0;
	if (fp->f_flag & FNONBLOCK)
		ioflag |= IO_NDELAY;
	if (fp->f_flag & O_DIRECT)
		ioflag |= IO_DIRECT;
	advice = get_advice(fp, uio);
	vn_lock(vp, LK_SHARED | LK_RETRY);

	switch (advice) {
	case POSIX_FADV_NORMAL:
	case POSIX_FADV_SEQUENTIAL:
	case POSIX_FADV_NOREUSE:
		ioflag |= sequential_heuristic(uio, fp);
		break;
	case POSIX_FADV_RANDOM:
		/* Disable read-ahead for random I/O. */
		break;
	}
	offset = uio->uio_offset;

#ifdef MAC
	error = mac_vnode_check_read(active_cred, fp->f_cred, vp);
	if (error == 0)
#endif
		error = VOP_READ(vp, uio, ioflag, fp->f_cred);
	fp->f_nextoff = uio->uio_offset;
	VOP_UNLOCK(vp, 0);
	if (error == 0 && advice == POSIX_FADV_NOREUSE &&
	    offset != uio->uio_offset) {
		/*
		 * Use POSIX_FADV_DONTNEED to flush clean pages and
		 * buffers for the backing file after a
		 * POSIX_FADV_NOREUSE read(2).  To optimize the common
		 * case of using POSIX_FADV_NOREUSE with sequential
		 * access, track the previous implicit DONTNEED
		 * request and grow this request to include the
		 * current read(2) in addition to the previous
		 * DONTNEED.  With purely sequential access this will
		 * cause the DONTNEED requests to continously grow to
		 * cover all of the previously read regions of the
		 * file.  This allows filesystem blocks that are
		 * accessed by multiple calls to read(2) to be flushed
		 * once the last read(2) finishes.
		 */
		start = offset;
		end = uio->uio_offset - 1;
		mtxp = mtx_pool_find(mtxpool_sleep, fp);
		mtx_lock(mtxp);
		if (fp->f_advice != NULL &&
		    fp->f_advice->fa_advice == POSIX_FADV_NOREUSE) {
			if (start != 0 && fp->f_advice->fa_prevend + 1 == start)
				start = fp->f_advice->fa_prevstart;
			else if (fp->f_advice->fa_prevstart != 0 &&
			    fp->f_advice->fa_prevstart == end + 1)
				end = fp->f_advice->fa_prevend;
			fp->f_advice->fa_prevstart = start;
			fp->f_advice->fa_prevend = end;
		}
		mtx_unlock(mtxp);
		error = VOP_ADVISE(vp, start, end, POSIX_FADV_DONTNEED);
	}
	return (error);
}
#endif

/*
 * File table vnode write routine.
 */
int
vn_write(fp, uio, active_cred, flags, td)
	struct file *fp;
	struct uio *uio;
	struct ucred *active_cred;
	int flags;
	struct thread *td;
{
	KASSERT(uio->uio_td == td, ("uio_td %p is not td %p",
	    uio->uio_td, td));
	KASSERT(flags & FOF_OFFSET, ("No FOF_OFFSET"));

	struct vnode *vp = fp->f_vnode;
	int error;

	/*
	 * interpret flags, etc.
	 */
#ifdef TESLA
	TESLA_WITHIN(syscall, eventually(
		called(audit_arg_upath1, td, ANY(int), ANY(ptr))
	));
#endif

#ifdef MAC
	error = mac_vnode_check_write(active_cred, fp->f_cred, vp);
	if (error == 0)
#endif
		/*
		 * actually do the write!
		 */
		printf("-- writing to vnode with tag '%s'\n", vp->v_tag);

	return (error);
}
