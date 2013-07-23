; ModuleID = '/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c'
; RUN: tesla instrument -S %s -tesla-manifest %p/Inputs/kern_prot.tesla -o %t
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-freebsd10.0"

module asm ".ident\09\22$FreeBSD: head/sys/kern/kern_prot.c 243022 2012-11-14 10:33:12Z bapt $\22"
module asm ".globl __start_set_pcpu"
module asm ".globl __stop_set_pcpu"
module asm ".globl __start_set_sysinit_set"
module asm ".globl __stop_set_sysinit_set"
module asm ".globl __start_set_sysuninit_set"
module asm ".globl __stop_set_sysuninit_set"
module asm ".globl __start_set_sysctl_set"
module asm ".globl __stop_set_sysctl_set"
module asm ".globl __start_set_sysctl_set"
module asm ".globl __stop_set_sysctl_set"
module asm ".globl __start_set_sysctl_set"
module asm ".globl __stop_set_sysctl_set"
module asm ".globl __start_set_sysctl_set"
module asm ".globl __stop_set_sysctl_set"
module asm ".globl __start_set_sysctl_set"
module asm ".globl __stop_set_sysctl_set"

%struct.sysinit = type { i32, i32, void (i8*)*, i8* }
%struct.sysctl_oid = type { %struct.sysctl_oid_list*, %struct.anon, i32, i32, i8*, i64, i8*, i32 (%struct.sysctl_oid*, i8*, i64, %struct.sysctl_req*)*, i8*, i32, i32, i8* }
%struct.sysctl_oid_list = type { %struct.sysctl_oid* }
%struct.anon = type { %struct.sysctl_oid* }
%struct.sysctl_req = type { %struct.thread*, i32, i8*, i64, i64, i32 (%struct.sysctl_req*, i8*, i64)*, i8*, i64, i64, i32 (%struct.sysctl_req*, i8*, i64)*, i64, i32 }
%struct.thread = type { %struct.mtx*, %struct.proc*, %struct.anon.41, %struct.anon.42, %struct.anon.43, %struct.anon.44, %struct.anon.45, %struct.cpuset*, %struct.seltd*, %struct.sleepqueue*, %struct.turnstile*, %struct.rl_q_entry*, %struct.umtx_q*, i32, %struct.sigqueue, i8, i32, i32, i32, i32, i32, i8*, i8*, i8, i8, i8, i8, i16, i16, i16, i16, %struct.turnstile*, i8*, %struct.anon.46, %struct.lock_list_entry*, i32, i32, %struct.ucred*, i32, i32, i32, i32, i32, %struct.rusage, %struct.rusage_ext, i64, i64, i32, i32, i32, i32, i32, %struct.__sigset, i32, %struct.sigaltstack, i32, i64, i32, [20 x i8], %struct.file*, i32, %struct.ksiginfo, i32, %struct.osd, %struct.vm_map_entry*, i32, i32, i32, i32, %struct.__sigset, i8, i8, i8, i8, i8, i8, %struct.pcb*, i32, [2 x i64], %struct.callout, %struct.trapframe*, %struct.vm_object*, i64, i32, i32, %struct.mdthread, %struct.td_sched*, %struct.kaudit_record*, [2 x %struct.lpohead], %struct.kdtrace_thread*, i32, %struct.vnet*, i8*, %struct.trapframe*, %struct.proc*, %struct.vm_page**, i32, %struct.tesla_store* }
%struct.mtx = type { %struct.lock_object, i64 }
%struct.lock_object = type { i8*, i32, i32, %struct.witness* }
%struct.witness = type opaque
%struct.proc = type { %struct.anon.0, %struct.anon.1, %struct.mtx, %struct.ucred*, %struct.filedesc*, %struct.filedesc_to_leader*, %struct.pstats*, %struct.plimit*, %struct.callout, %struct.sigacts*, i32, i32, i32, %struct.anon.18, %struct.anon.19, %struct.proc*, %struct.anon.20, %struct.anon.21, %struct.mtx, %struct.ksiginfo*, %struct.sigqueue, i32, %struct.vmspace*, i32, %struct.itimerval, %struct.rusage, %struct.rusage_ext, %struct.rusage_ext, i32, i32, i32, %struct.vnode*, %struct.ucred*, %struct.vnode*, i32, %struct.sigiolst, i32, i32, i64, i32, i32, i8, i8, %struct.nlminfo*, %struct.kaioinfo*, %struct.thread*, i32, %struct.thread*, i32, i32, %struct.itimers*, %struct.procdesc*, i32, i32, [20 x i8], %struct.pgrp*, %struct.sysentvec*, %struct.pargs*, i64, i8, i32, i16, %struct.knlist, i32, %struct.mdproc, %struct.callout, i16, %struct.proc*, %struct.proc*, i8*, %struct.label*, %struct.p_sched*, %struct.anon.37, %struct.anon.38, %struct.kdtrace_proc*, %struct.cv, %struct.cv, i64, %struct.racct*, i8, %struct.anon.39, %struct.anon.40 }
%struct.anon.0 = type { %struct.proc*, %struct.proc** }
%struct.anon.1 = type { %struct.thread*, %struct.thread** }
%struct.ucred = type { i32, i32, i32, i32, i32, i32, i32, %struct.uidinfo*, %struct.uidinfo*, %struct.prison*, %struct.loginclass*, i32, [2 x i8*], %struct.label*, %struct.auditinfo_addr, i32*, i32 }
%struct.uidinfo = type { %struct.anon.2, %struct.mtx, i64, i64, i64, i64, i32, i32, %struct.racct* }
%struct.anon.2 = type { %struct.uidinfo*, %struct.uidinfo** }
%struct.racct = type { [21 x i64], %struct.anon.3 }
%struct.anon.3 = type { %struct.rctl_rule_link* }
%struct.rctl_rule_link = type opaque
%struct.prison = type { %struct.anon.4, i32, i32, i32, i32, %struct.anon.5, %struct.anon.6, %struct.prison*, %struct.mtx, %struct.task, %struct.osd, %struct.cpuset*, %struct.vnet*, %struct.vnode*, i32, i32, %struct.in_addr*, %struct.in6_addr*, %struct.prison_racct*, [3 x i8*], i32, i32, i32, i32, i32, i32, [4 x i32], i64, [256 x i8], [1024 x i8], [256 x i8], [256 x i8], [64 x i8] }
%struct.anon.4 = type { %struct.prison*, %struct.prison** }
%struct.anon.5 = type { %struct.prison* }
%struct.anon.6 = type { %struct.prison*, %struct.prison** }
%struct.task = type { %struct.anon.7, i16, i16, void (i8*, i32)*, i8* }
%struct.anon.7 = type { %struct.task* }
%struct.osd = type { i32, i8**, %struct.anon.8 }
%struct.anon.8 = type { %struct.osd*, %struct.osd** }
%struct.cpuset = type { %struct._cpuset, i32, i32, i32, %struct.cpuset*, %struct.anon.9, %struct.anon.10, %struct.setlist }
%struct._cpuset = type { [1 x i64] }
%struct.anon.9 = type { %struct.cpuset*, %struct.cpuset** }
%struct.anon.10 = type { %struct.cpuset*, %struct.cpuset** }
%struct.setlist = type { %struct.cpuset* }
%struct.vnet = type { %struct.anon.11, i32, i32, i32, i8*, i64 }
%struct.anon.11 = type { %struct.vnet*, %struct.vnet** }
%struct.vnode = type opaque
%struct.in_addr = type { i32 }
%struct.in6_addr = type { %union.anon }
%union.anon = type { [4 x i32] }
%struct.prison_racct = type { %struct.anon.12, [256 x i8], i32, %struct.racct* }
%struct.anon.12 = type { %struct.prison_racct*, %struct.prison_racct** }
%struct.loginclass = type { %struct.anon.13, [33 x i8], i32, %struct.racct* }
%struct.anon.13 = type { %struct.loginclass*, %struct.loginclass** }
%struct.label = type opaque
%struct.auditinfo_addr = type { i32, %struct.au_mask, %struct.au_tid_addr, i32, i64 }
%struct.au_mask = type { i32, i32 }
%struct.au_tid_addr = type { i32, i32, [4 x i32] }
%struct.filedesc = type opaque
%struct.filedesc_to_leader = type opaque
%struct.pstats = type { %struct.rusage, [3 x %struct.itimerval], %struct.uprof, %struct.timeval }
%struct.rusage = type { %struct.timeval, %struct.timeval, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64 }
%struct.timeval = type { i64, i64 }
%struct.itimerval = type { %struct.timeval, %struct.timeval }
%struct.uprof = type { i8*, i64, i64, i64 }
%struct.plimit = type { [13 x %struct.rlimit], i32 }
%struct.rlimit = type { i64, i64 }
%struct.callout = type { %union.anon.14, i64, i64, i8*, void (i8*)*, %struct.lock_object*, i32, i32 }
%union.anon.14 = type { %struct.anon.15 }
%struct.anon.15 = type { %struct.callout*, %struct.callout** }
%struct.sigacts = type { [128 x void (i32)*], [128 x %struct.__sigset], %struct.__sigset, %struct.__sigset, %struct.__sigset, %struct.__sigset, %struct.__sigset, %struct.__sigset, %struct.__sigset, %struct.__sigset, %struct.__sigset, %struct.__sigset, i32, i32, %struct.mtx }
%struct.__sigset = type { [4 x i32] }
%struct.anon.18 = type { %struct.proc*, %struct.proc** }
%struct.anon.19 = type { %struct.proc*, %struct.proc** }
%struct.anon.20 = type { %struct.proc*, %struct.proc** }
%struct.anon.21 = type { %struct.proc* }
%struct.ksiginfo = type { %struct.anon.22, %struct.__siginfo, i32, %struct.sigqueue* }
%struct.anon.22 = type { %struct.ksiginfo*, %struct.ksiginfo** }
%struct.__siginfo = type { i32, i32, i32, i32, i32, i32, i8*, %union.sigval, %union.anon.23 }
%union.sigval = type { i8* }
%union.anon.23 = type { %struct.anon.28 }
%struct.anon.28 = type { i64, [7 x i32] }
%struct.sigqueue = type { %struct.__sigset, %struct.__sigset, %struct.anon.29, %struct.proc*, i32 }
%struct.anon.29 = type { %struct.ksiginfo*, %struct.ksiginfo** }
%struct.vmspace = type opaque
%struct.rusage_ext = type { i64, i64, i64, i64, i64, i64, i64 }
%struct.sigiolst = type { %struct.sigio* }
%struct.sigio = type { %union.anon.30, %struct.anon.31, %struct.sigio**, %struct.ucred*, i32 }
%union.anon.30 = type { %struct.proc* }
%struct.anon.31 = type { %struct.sigio* }
%struct.nlminfo = type opaque
%struct.kaioinfo = type opaque
%struct.itimers = type opaque
%struct.procdesc = type opaque
%struct.pgrp = type { %struct.anon.47, %struct.anon.48, %struct.session*, %struct.sigiolst, i32, i32, %struct.mtx }
%struct.anon.47 = type { %struct.pgrp*, %struct.pgrp** }
%struct.anon.48 = type { %struct.proc* }
%struct.session = type { i32, %struct.proc*, %struct.vnode*, %struct.cdev_priv*, %struct.tty*, i32, [40 x i8], %struct.mtx }
%struct.cdev_priv = type opaque
%struct.tty = type opaque
%struct.sysentvec = type opaque
%struct.pargs = type { i32, i32, [1 x i8] }
%struct.knlist = type { %struct.klist, void (i8*)*, void (i8*)*, void (i8*)*, void (i8*)*, i8* }
%struct.klist = type { %struct.knote* }
%struct.knote = type { %struct.anon.32, %struct.anon.33, %struct.knlist*, %struct.anon.34, %struct.kqueue*, %struct.kevent, i32, i32, i64, %union.anon.35, %struct.filterops*, i8*, i32 }
%struct.anon.32 = type { %struct.knote* }
%struct.anon.33 = type { %struct.knote* }
%struct.anon.34 = type { %struct.knote*, %struct.knote** }
%struct.kqueue = type opaque
%struct.kevent = type { i64, i16, i16, i32, i64, i8* }
%union.anon.35 = type { %struct.file* }
%struct.file = type { i8*, %struct.fileops*, %struct.ucred*, %struct.vnode*, i16, i16, i32, i32, i32, i64, %union.anon.36, i64, i8* }
%struct.fileops = type { i32 (%struct.file*, %struct.uio*, %struct.ucred*, i32, %struct.thread*)*, i32 (%struct.file*, %struct.uio*, %struct.ucred*, i32, %struct.thread*)*, i32 (%struct.file*, i64, %struct.ucred*, %struct.thread*)*, i32 (%struct.file*, i64, i8*, %struct.ucred*, %struct.thread*)*, i32 (%struct.file*, i32, %struct.ucred*, %struct.thread*)*, i32 (%struct.file*, %struct.knote*)*, i32 (%struct.file*, %struct.stat*, %struct.ucred*, %struct.thread*)*, i32 (%struct.file*, %struct.thread*)*, i32 (%struct.file*, i16, %struct.ucred*, %struct.thread*)*, i32 (%struct.file*, i32, i32, %struct.ucred*, %struct.thread*)*, i32 }
%struct.uio = type { %struct.iovec*, i32, i64, i64, i32, i32, %struct.thread* }
%struct.iovec = type { i8*, i64 }
%struct.stat = type opaque
%union.anon.36 = type { %struct.cdev_privdata* }
%struct.cdev_privdata = type opaque
%struct.filterops = type { i32, i32 (%struct.knote*)*, void (%struct.knote*)*, i32 (%struct.knote*, i64)*, void (%struct.knote*, %struct.kevent*, i64)* }
%struct.mdproc = type { %struct.proc_ldt*, %struct.system_segment_descriptor }
%struct.proc_ldt = type { i8*, i32 }
%struct.system_segment_descriptor = type <{ [16 x i8] }>
%struct.p_sched = type opaque
%struct.anon.37 = type { %struct.ktr_request*, %struct.ktr_request** }
%struct.ktr_request = type opaque
%struct.anon.38 = type { %struct.mqueue_notifier* }
%struct.mqueue_notifier = type opaque
%struct.kdtrace_proc = type opaque
%struct.cv = type { i8*, i32 }
%struct.anon.39 = type { %struct.proc*, %struct.proc** }
%struct.anon.40 = type { %struct.proc* }
%struct.anon.41 = type { %struct.thread*, %struct.thread** }
%struct.anon.42 = type { %struct.thread*, %struct.thread** }
%struct.anon.43 = type { %struct.thread*, %struct.thread** }
%struct.anon.44 = type { %struct.thread*, %struct.thread** }
%struct.anon.45 = type { %struct.thread*, %struct.thread** }
%struct.seltd = type opaque
%struct.sleepqueue = type opaque
%struct.turnstile = type opaque
%struct.rl_q_entry = type opaque
%struct.umtx_q = type opaque
%struct.anon.46 = type { %struct.turnstile* }
%struct.lock_list_entry = type opaque
%struct.sigaltstack = type { i8*, i64, i32 }
%struct.vm_map_entry = type opaque
%struct.pcb = type opaque
%struct.trapframe = type opaque
%struct.vm_object = type opaque
%struct.mdthread = type { i32, i64, i64 }
%struct.td_sched = type opaque
%struct.kaudit_record = type opaque
%struct.lpohead = type { %struct.lock_profile_object* }
%struct.lock_profile_object = type opaque
%struct.kdtrace_thread = type opaque
%struct.vm_page = type opaque
%struct.tesla_store = type opaque
%struct.malloc_type = type { %struct.malloc_type*, i64, i8*, i8* }
%struct.sx = type { %struct.lock_object, i64 }
%struct.getpid_args = type { i64 }
%struct.getppid_args = type { i64 }
%struct.getpgrp_args = type { i64 }
%struct.getpgid_args = type { [0 x i8], i32, [4 x i8] }
%struct.getsid_args = type { [0 x i8], i32, [4 x i8] }
%struct.getuid_args = type { i64 }
%struct.geteuid_args = type { i64 }
%struct.getgid_args = type { i64 }
%struct.getegid_args = type { i64 }
%struct.getgroups_args = type { [0 x i8], i32, [4 x i8], [0 x i8], i32*, [0 x i8] }
%struct.setsid_args = type { i64 }
%struct.setpgid_args = type { [0 x i8], i32, [4 x i8], [0 x i8], i32, [4 x i8] }
%struct.setuid_args = type { [0 x i8], i32, [4 x i8] }
%struct.__tesla_locality = type {}
%struct.seteuid_args = type { [0 x i8], i32, [4 x i8] }
%struct.setgid_args = type { [0 x i8], i32, [4 x i8] }
%struct.setegid_args = type { [0 x i8], i32, [4 x i8] }
%struct.setgroups_args = type { [0 x i8], i32, [4 x i8], [0 x i8], i32*, [0 x i8] }
%struct.setreuid_args = type { [0 x i8], i32, [4 x i8], [0 x i8], i32, [4 x i8] }
%struct.setregid_args = type { [0 x i8], i32, [4 x i8], [0 x i8], i32, [4 x i8] }
%struct.setresuid_args = type { [0 x i8], i32, [4 x i8], [0 x i8], i32, [4 x i8], [0 x i8], i32, [4 x i8] }
%struct.setresgid_args = type { [0 x i8], i32, [4 x i8], [0 x i8], i32, [4 x i8], [0 x i8], i32, [4 x i8] }
%struct.getresuid_args = type { [0 x i8], i32*, [0 x i8], [0 x i8], i32*, [0 x i8], [0 x i8], i32*, [0 x i8] }
%struct.getresgid_args = type { [0 x i8], i32*, [0 x i8], [0 x i8], i32*, [0 x i8], [0 x i8], i32*, [0 x i8] }
%struct.issetugid_args = type { i64 }
%struct.__setugid_args = type { [0 x i8], i32, [4 x i8] }
%struct.socket = type { i32, i16, i16, i16, i16, i32, i8*, %struct.vnet*, %struct.protosw*, %struct.socket*, %struct.anon.49, %struct.anon.50, %struct.anon.51, i16, i16, i16, i16, i16, %struct.sigio*, i64, %struct.anon.52, %struct.sockbuf, %struct.sockbuf, %struct.ucred*, %struct.label*, %struct.label*, i64, i8*, %struct.so_accf*, i32, i32 }
%struct.protosw = type opaque
%struct.anon.49 = type { %struct.socket*, %struct.socket** }
%struct.anon.50 = type { %struct.socket*, %struct.socket** }
%struct.anon.51 = type { %struct.socket*, %struct.socket** }
%struct.anon.52 = type { %struct.aiocblist*, %struct.aiocblist** }
%struct.aiocblist = type opaque
%struct.sockbuf = type { %struct.selinfo, %struct.mtx, %struct.sx, i16, %struct.mbuf*, %struct.mbuf*, %struct.mbuf*, %struct.mbuf*, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i32 (%struct.socket*, i8*, i32)*, i8* }
%struct.selinfo = type { %struct.selfdlist, %struct.knlist, %struct.mtx* }
%struct.selfdlist = type { %struct.selfd*, %struct.selfd** }
%struct.selfd = type opaque
%struct.mbuf = type opaque
%struct.so_accf = type { %struct.accept_filter*, i8*, i8* }
%struct.accept_filter = type { [16 x i8], i32 (%struct.socket*, i8*, i32)*, i8* (%struct.socket*, i8*)*, void (%struct.socket*)*, %struct.anon.53 }
%struct.anon.53 = type { %struct.accept_filter* }
%struct.inpcb = type { %struct.anon.54, %struct.anon.55, %struct.anon.56, i8*, %struct.inpcbinfo*, %struct.inpcbgroup*, %struct.anon.58, %struct.socket*, %struct.ucred*, i32, i32, i32, i8, i8, i8, i8, i32, i32, [5 x i8*], [6 x i32], %struct.in_conninfo, %struct.label*, %struct.inpcbpolicy*, %struct.anon.61, %struct.anon.62, %struct.anon.63, %struct.inpcbport*, i64, %struct.llentry*, %struct.rtentry*, %struct.rwlock }
%struct.anon.54 = type { %struct.inpcb*, %struct.inpcb** }
%struct.anon.55 = type { %struct.inpcb*, %struct.inpcb** }
%struct.anon.56 = type { %struct.inpcb*, %struct.inpcb** }
%struct.inpcbinfo = type { %struct.rwlock, %struct.inpcbhead*, i32, i64, i16, i16, i16, %struct.uma_zone*, %struct.inpcbgroup*, i32, i32, %struct.rwlock, %struct.inpcbhead*, i64, %struct.inpcbporthead*, i64, %struct.inpcbhead*, i64, %struct.vnet*, [2 x i8*] }
%struct.rwlock = type { %struct.lock_object, i64 }
%struct.inpcbhead = type { %struct.inpcb* }
%struct.uma_zone = type opaque
%struct.inpcbgroup = type { %struct.inpcbhead*, i64, i32, %struct.mtx, [72 x i8] }
%struct.inpcbporthead = type { %struct.inpcbport* }
%struct.inpcbport = type { %struct.anon.57, %struct.inpcbhead, i16 }
%struct.anon.57 = type { %struct.inpcbport*, %struct.inpcbport** }
%struct.anon.58 = type { %struct.inpcb*, %struct.inpcb** }
%struct.in_conninfo = type { i8, i8, i16, %struct.in_endpoints }
%struct.in_endpoints = type { i16, i16, %union.anon.59, %union.anon.60 }
%union.anon.59 = type { %struct.in_addr_4in6 }
%struct.in_addr_4in6 = type { [3 x i32], %struct.in_addr }
%union.anon.60 = type { %struct.in_addr_4in6 }
%struct.inpcbpolicy = type opaque
%struct.anon.61 = type { i8, %struct.mbuf*, %struct.ip_moptions* }
%struct.ip_moptions = type opaque
%struct.anon.62 = type { %struct.mbuf*, %struct.ip6_pktopts*, %struct.ip6_moptions*, %struct.icmp6_filter*, i32, i16 }
%struct.ip6_pktopts = type opaque
%struct.ip6_moptions = type opaque
%struct.icmp6_filter = type opaque
%struct.anon.63 = type { %struct.inpcb*, %struct.inpcb** }
%struct.llentry = type opaque
%struct.rtentry = type opaque
%struct.xucred = type { i32, i32, i16, [16 x i32], i8* }
%struct.getlogin_args = type { [0 x i8], i8*, [0 x i8], [0 x i8], i32, [4 x i8] }
%struct.setlogin_args = type { [0 x i8], i8*, [0 x i8] }

@M_CRED_init_sys_init = internal global %struct.sysinit { i32 25165824, i32 1, void (i8*)* @malloc_init, i8* bitcast ([1 x %struct.malloc_type]* @M_CRED to i8*) }, align 8
@__set_sysinit_set_sym_M_CRED_init_sys_init = internal constant i8* bitcast (%struct.sysinit* @M_CRED_init_sys_init to i8*), section "set_sysinit_set", align 8
@M_CRED_uninit_sys_uninit = internal global %struct.sysinit { i32 25165824, i32 268435455, void (i8*)* @malloc_uninit, i8* bitcast ([1 x %struct.malloc_type]* @M_CRED to i8*) }, align 8
@__set_sysuninit_set_sym_M_CRED_uninit_sys_uninit = internal constant i8* bitcast (%struct.sysinit* @M_CRED_uninit_sys_uninit to i8*), section "set_sysuninit_set", align 8
@sysctl___security_bsd = internal global %struct.sysctl_oid { %struct.sysctl_oid_list* @sysctl__security_children, %struct.anon zeroinitializer, i32 -1, i32 -1073741823, i8* bitcast (%struct.sysctl_oid_list* @sysctl__security_bsd_children to i8*), i64 0, i8* getelementptr inbounds ([4 x i8]* @.str19, i32 0, i32 0), i32 (%struct.sysctl_oid*, i8*, i64, %struct.sysctl_req*)* null, i8* getelementptr inbounds ([2 x i8]* @.str20, i32 0, i32 0), i32 0, i32 0, i8* getelementptr inbounds ([20 x i8]* @.str21, i32 0, i32 0) }, align 8
@__set_sysctl_set_sym_sysctl___security_bsd = internal constant i8* bitcast (%struct.sysctl_oid* @sysctl___security_bsd to i8*), section "set_sysctl_set", align 8
@.str = private unnamed_addr constant [66 x i8] c"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c\00", align 1
@M_TEMP = external global [1 x %struct.malloc_type]
@M_PGRP = external global [1 x %struct.malloc_type]
@M_SESSION = external global [1 x %struct.malloc_type]
@proctree_lock = external global %struct.sx
@.str1 = private unnamed_addr constant [35 x i8] c"setpgid failed and newpgrp is NULL\00", align 1
@ngroups_max = external global i32
@sysctl___security_bsd_see_other_uids = internal global %struct.sysctl_oid { %struct.sysctl_oid_list* @sysctl__security_bsd_children, %struct.anon zeroinitializer, i32 -1, i32 -1073479678, i8* bitcast (i32* @see_other_uids to i8*), i64 0, i8* getelementptr inbounds ([15 x i8]* @.str17, i32 0, i32 0), i32 (%struct.sysctl_oid*, i8*, i64, %struct.sysctl_req*)* @sysctl_handle_int, i8* getelementptr inbounds ([2 x i8]* @.str11, i32 0, i32 0), i32 0, i32 0, i8* getelementptr inbounds ([72 x i8]* @.str18, i32 0, i32 0) }, align 8
@__set_sysctl_set_sym_sysctl___security_bsd_see_other_uids = internal constant i8* bitcast (%struct.sysctl_oid* @sysctl___security_bsd_see_other_uids to i8*), section "set_sysctl_set", align 8
@sysctl___security_bsd_see_other_gids = internal global %struct.sysctl_oid { %struct.sysctl_oid_list* @sysctl__security_bsd_children, %struct.anon zeroinitializer, i32 -1, i32 -1073479678, i8* bitcast (i32* @see_other_gids to i8*), i64 0, i8* getelementptr inbounds ([15 x i8]* @.str15, i32 0, i32 0), i32 (%struct.sysctl_oid*, i8*, i64, %struct.sysctl_req*)* @sysctl_handle_int, i8* getelementptr inbounds ([2 x i8]* @.str11, i32 0, i32 0), i32 0, i32 0, i8* getelementptr inbounds ([72 x i8]* @.str16, i32 0, i32 0) }, align 8
@__set_sysctl_set_sym_sysctl___security_bsd_see_other_gids = internal constant i8* bitcast (%struct.sysctl_oid* @sysctl___security_bsd_see_other_gids to i8*), section "set_sysctl_set", align 8
@.str2 = private unnamed_addr constant [21 x i8] c"%s: td not curthread\00", align 1
@__func__.p_cansee = private unnamed_addr constant [9 x i8] c"p_cansee\00", align 1
@sysctl___security_bsd_conservative_signals = internal global %struct.sysctl_oid { %struct.sysctl_oid_list* @sysctl__security_bsd_children, %struct.anon zeroinitializer, i32 -1, i32 -1073479678, i8* bitcast (i32* @conservative_signals to i8*), i64 0, i8* getelementptr inbounds ([21 x i8]* @.str13, i32 0, i32 0), i32 (%struct.sysctl_oid*, i8*, i64, %struct.sysctl_req*)* @sysctl_handle_int, i8* getelementptr inbounds ([2 x i8]* @.str11, i32 0, i32 0), i32 0, i32 0, i8* getelementptr inbounds ([106 x i8]* @.str14, i32 0, i32 0) }, align 8
@__set_sysctl_set_sym_sysctl___security_bsd_conservative_signals = internal constant i8* bitcast (%struct.sysctl_oid* @sysctl___security_bsd_conservative_signals to i8*), section "set_sysctl_set", align 8
@conservative_signals = internal global i32 1, align 4
@__func__.p_cansignal = private unnamed_addr constant [12 x i8] c"p_cansignal\00", align 1
@__func__.p_cansched = private unnamed_addr constant [11 x i8] c"p_cansched\00", align 1
@sysctl___security_bsd_unprivileged_proc_debug = internal global %struct.sysctl_oid { %struct.sysctl_oid_list* @sysctl__security_bsd_children, %struct.anon zeroinitializer, i32 -1, i32 -1073479678, i8* bitcast (i32* @unprivileged_proc_debug to i8*), i64 0, i8* getelementptr inbounds ([24 x i8]* @.str10, i32 0, i32 0), i32 (%struct.sysctl_oid*, i8*, i64, %struct.sysctl_req*)* @sysctl_handle_int, i8* getelementptr inbounds ([2 x i8]* @.str11, i32 0, i32 0), i32 0, i32 0, i8* getelementptr inbounds ([60 x i8]* @.str12, i32 0, i32 0) }, align 8
@__set_sysctl_set_sym_sysctl___security_bsd_unprivileged_proc_debug = internal constant i8* bitcast (%struct.sysctl_oid* @sysctl___security_bsd_unprivileged_proc_debug to i8*), section "set_sysctl_set", align 8
@__func__.p_candebug = private unnamed_addr constant [11 x i8] c"p_candebug\00", align 1
@unprivileged_proc_debug = internal global i32 1, align 4
@initproc = external global %struct.proc*
@__func__.p_canwait = private unnamed_addr constant [10 x i8] c"p_canwait\00", align 1
@M_CRED = internal global [1 x %struct.malloc_type] [%struct.malloc_type { %struct.malloc_type* null, i64 877983977, i8* getelementptr inbounds ([5 x i8]* @.str9, i32 0, i32 0), i8* null }], align 16
@.str3 = private unnamed_addr constant [23 x i8] c"bad ucred refcount: %d\00", align 1
@.str4 = private unnamed_addr constant [28 x i8] c"dangling reference to ucred\00", align 1
@.str5 = private unnamed_addr constant [23 x i8] c"crcopy of shared ucred\00", align 1
@sysctl__security_bsd_children = common global %struct.sysctl_oid_list zeroinitializer, align 8
@.str6 = private unnamed_addr constant [24 x i8] c"cr_ngroups is too small\00", align 1
@.str7 = private unnamed_addr constant [21 x i8] c"negative refcount %p\00", align 1
@.str8 = private unnamed_addr constant [23 x i8] c"refcount %p overflowed\00", align 1
@.str9 = private unnamed_addr constant [5 x i8] c"cred\00", align 1
@.str10 = private unnamed_addr constant [24 x i8] c"unprivileged_proc_debug\00", align 1
@.str11 = private unnamed_addr constant [2 x i8] c"I\00", align 1
@.str12 = private unnamed_addr constant [60 x i8] c"Unprivileged processes may use process debugging facilities\00", align 1
@.str13 = private unnamed_addr constant [21 x i8] c"conservative_signals\00", align 1
@.str14 = private unnamed_addr constant [106 x i8] c"Unprivileged processes prevented from sending certain signals to processes whose credentials have changed\00", align 1
@see_other_gids = internal global i32 1, align 4
@see_other_uids = internal global i32 1, align 4
@.str15 = private unnamed_addr constant [15 x i8] c"see_other_gids\00", align 1
@.str16 = private unnamed_addr constant [72 x i8] c"Unprivileged processes may see subjects/objects with different real gid\00", align 1
@.str17 = private unnamed_addr constant [15 x i8] c"see_other_uids\00", align 1
@.str18 = private unnamed_addr constant [72 x i8] c"Unprivileged processes may see subjects/objects with different real uid\00", align 1
@sysctl__security_children = external global %struct.sysctl_oid_list
@.str19 = private unnamed_addr constant [4 x i8] c"bsd\00", align 1
@.str20 = private unnamed_addr constant [2 x i8] c"N\00", align 1
@.str21 = private unnamed_addr constant [20 x i8] c"BSD security policy\00", align 1
@llvm.used = appending global [7 x i8*] [i8* bitcast (i8** @__set_sysinit_set_sym_M_CRED_init_sys_init to i8*), i8* bitcast (i8** @__set_sysuninit_set_sym_M_CRED_uninit_sys_uninit to i8*), i8* bitcast (i8** @__set_sysctl_set_sym_sysctl___security_bsd to i8*), i8* bitcast (i8** @__set_sysctl_set_sym_sysctl___security_bsd_see_other_uids to i8*), i8* bitcast (i8** @__set_sysctl_set_sym_sysctl___security_bsd_see_other_gids to i8*), i8* bitcast (i8** @__set_sysctl_set_sym_sysctl___security_bsd_conservative_signals to i8*), i8* bitcast (i8** @__set_sysctl_set_sym_sysctl___security_bsd_unprivileged_proc_debug to i8*)], section "llvm.metadata"

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys_getpid(%struct.thread* %td, %struct.getpid_args* %uap) #0 {
entry:
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.getpid_args*, align 8
  %p = alloca %struct.proc*, align 8
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !2072), !dbg !2073
  store %struct.getpid_args* %uap, %struct.getpid_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.getpid_args** %uap.addr}, metadata !2074), !dbg !2073
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p}, metadata !2075), !dbg !2076
  %0 = load %struct.thread** %td.addr, align 8, !dbg !2076
  %td_proc = getelementptr inbounds %struct.thread* %0, i32 0, i32 1, !dbg !2076
  %1 = load %struct.proc** %td_proc, align 8, !dbg !2076
  store %struct.proc* %1, %struct.proc** %p, align 8, !dbg !2076
  %2 = load %struct.proc** %p, align 8, !dbg !2077
  %p_pid = getelementptr inbounds %struct.proc* %2, i32 0, i32 12, !dbg !2077
  %3 = load i32* %p_pid, align 4, !dbg !2077
  %conv = sext i32 %3 to i64, !dbg !2077
  %4 = load %struct.thread** %td.addr, align 8, !dbg !2077
  %td_retval = getelementptr inbounds %struct.thread* %4, i32 0, i32 78, !dbg !2077
  %arrayidx = getelementptr inbounds [2 x i64]* %td_retval, i32 0, i64 0, !dbg !2077
  store i64 %conv, i64* %arrayidx, align 8, !dbg !2077
  ret i32 0, !dbg !2078
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata) #1

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys_getppid(%struct.thread* %td, %struct.getppid_args* %uap) #0 {
entry:
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.getppid_args*, align 8
  %p = alloca %struct.proc*, align 8
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !2079), !dbg !2080
  store %struct.getppid_args* %uap, %struct.getppid_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.getppid_args** %uap.addr}, metadata !2081), !dbg !2080
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p}, metadata !2082), !dbg !2083
  %0 = load %struct.thread** %td.addr, align 8, !dbg !2083
  %td_proc = getelementptr inbounds %struct.thread* %0, i32 0, i32 1, !dbg !2083
  %1 = load %struct.proc** %td_proc, align 8, !dbg !2083
  store %struct.proc* %1, %struct.proc** %p, align 8, !dbg !2083
  %2 = load %struct.proc** %p, align 8, !dbg !2084
  %p_mtx = getelementptr inbounds %struct.proc* %2, i32 0, i32 18, !dbg !2084
  %mtx_lock = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !2084
  call void @__mtx_lock_flags(i64* %mtx_lock, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 128) #5, !dbg !2084
  %3 = load %struct.proc** %p, align 8, !dbg !2085
  %p_pptr = getelementptr inbounds %struct.proc* %3, i32 0, i32 15, !dbg !2085
  %4 = load %struct.proc** %p_pptr, align 8, !dbg !2085
  %p_pid = getelementptr inbounds %struct.proc* %4, i32 0, i32 12, !dbg !2085
  %5 = load i32* %p_pid, align 4, !dbg !2085
  %conv = sext i32 %5 to i64, !dbg !2085
  %6 = load %struct.thread** %td.addr, align 8, !dbg !2085
  %td_retval = getelementptr inbounds %struct.thread* %6, i32 0, i32 78, !dbg !2085
  %arrayidx = getelementptr inbounds [2 x i64]* %td_retval, i32 0, i64 0, !dbg !2085
  store i64 %conv, i64* %arrayidx, align 8, !dbg !2085
  %7 = load %struct.proc** %p, align 8, !dbg !2086
  %p_mtx1 = getelementptr inbounds %struct.proc* %7, i32 0, i32 18, !dbg !2086
  %mtx_lock2 = getelementptr inbounds %struct.mtx* %p_mtx1, i32 0, i32 1, !dbg !2086
  call void @__mtx_unlock_flags(i64* %mtx_lock2, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 130) #5, !dbg !2086
  ret i32 0, !dbg !2087
}

; Function Attrs: noimplicitfloat noredzone
declare void @__mtx_lock_flags(i64*, i32, i8*, i32) #2

; Function Attrs: noimplicitfloat noredzone
declare void @__mtx_unlock_flags(i64*, i32, i8*, i32) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys_getpgrp(%struct.thread* %td, %struct.getpgrp_args* %uap) #0 {
entry:
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.getpgrp_args*, align 8
  %p = alloca %struct.proc*, align 8
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !2088), !dbg !2089
  store %struct.getpgrp_args* %uap, %struct.getpgrp_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.getpgrp_args** %uap.addr}, metadata !2090), !dbg !2089
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p}, metadata !2091), !dbg !2092
  %0 = load %struct.thread** %td.addr, align 8, !dbg !2092
  %td_proc = getelementptr inbounds %struct.thread* %0, i32 0, i32 1, !dbg !2092
  %1 = load %struct.proc** %td_proc, align 8, !dbg !2092
  store %struct.proc* %1, %struct.proc** %p, align 8, !dbg !2092
  %2 = load %struct.proc** %p, align 8, !dbg !2093
  %p_mtx = getelementptr inbounds %struct.proc* %2, i32 0, i32 18, !dbg !2093
  %mtx_lock = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !2093
  call void @__mtx_lock_flags(i64* %mtx_lock, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 147) #5, !dbg !2093
  %3 = load %struct.proc** %p, align 8, !dbg !2094
  %p_pgrp = getelementptr inbounds %struct.proc* %3, i32 0, i32 55, !dbg !2094
  %4 = load %struct.pgrp** %p_pgrp, align 8, !dbg !2094
  %pg_id = getelementptr inbounds %struct.pgrp* %4, i32 0, i32 4, !dbg !2094
  %5 = load i32* %pg_id, align 4, !dbg !2094
  %conv = sext i32 %5 to i64, !dbg !2094
  %6 = load %struct.thread** %td.addr, align 8, !dbg !2094
  %td_retval = getelementptr inbounds %struct.thread* %6, i32 0, i32 78, !dbg !2094
  %arrayidx = getelementptr inbounds [2 x i64]* %td_retval, i32 0, i64 0, !dbg !2094
  store i64 %conv, i64* %arrayidx, align 8, !dbg !2094
  %7 = load %struct.proc** %p, align 8, !dbg !2095
  %p_mtx1 = getelementptr inbounds %struct.proc* %7, i32 0, i32 18, !dbg !2095
  %mtx_lock2 = getelementptr inbounds %struct.mtx* %p_mtx1, i32 0, i32 1, !dbg !2095
  call void @__mtx_unlock_flags(i64* %mtx_lock2, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 149) #5, !dbg !2095
  ret i32 0, !dbg !2096
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys_getpgid(%struct.thread* %td, %struct.getpgid_args* %uap) #0 {
entry:
  %retval = alloca i32, align 4
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.getpgid_args*, align 8
  %p = alloca %struct.proc*, align 8
  %error = alloca i32, align 4
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !2097), !dbg !2098
  store %struct.getpgid_args* %uap, %struct.getpgid_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.getpgid_args** %uap.addr}, metadata !2099), !dbg !2098
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p}, metadata !2100), !dbg !2101
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !2102), !dbg !2103
  %0 = load %struct.getpgid_args** %uap.addr, align 8, !dbg !2104
  %pid = getelementptr inbounds %struct.getpgid_args* %0, i32 0, i32 1, !dbg !2104
  %1 = load i32* %pid, align 4, !dbg !2104
  %cmp = icmp eq i32 %1, 0, !dbg !2104
  br i1 %cmp, label %if.then, label %if.else, !dbg !2104

if.then:                                          ; preds = %entry
  %2 = load %struct.thread** %td.addr, align 8, !dbg !2105
  %td_proc = getelementptr inbounds %struct.thread* %2, i32 0, i32 1, !dbg !2105
  %3 = load %struct.proc** %td_proc, align 8, !dbg !2105
  store %struct.proc* %3, %struct.proc** %p, align 8, !dbg !2105
  %4 = load %struct.proc** %p, align 8, !dbg !2107
  %p_mtx = getelementptr inbounds %struct.proc* %4, i32 0, i32 18, !dbg !2107
  %mtx_lock = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !2107
  call void @__mtx_lock_flags(i64* %mtx_lock, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 167) #5, !dbg !2107
  br label %if.end9, !dbg !2108

if.else:                                          ; preds = %entry
  %5 = load %struct.getpgid_args** %uap.addr, align 8, !dbg !2109
  %pid1 = getelementptr inbounds %struct.getpgid_args* %5, i32 0, i32 1, !dbg !2109
  %6 = load i32* %pid1, align 4, !dbg !2109
  %call = call %struct.proc* @pfind(i32 %6) #5, !dbg !2109
  store %struct.proc* %call, %struct.proc** %p, align 8, !dbg !2109
  %7 = load %struct.proc** %p, align 8, !dbg !2111
  %cmp2 = icmp eq %struct.proc* %7, null, !dbg !2111
  br i1 %cmp2, label %if.then3, label %if.end, !dbg !2111

if.then3:                                         ; preds = %if.else
  store i32 3, i32* %retval, !dbg !2112
  br label %return, !dbg !2112

if.end:                                           ; preds = %if.else
  %8 = load %struct.thread** %td.addr, align 8, !dbg !2113
  %9 = load %struct.proc** %p, align 8, !dbg !2113
  %call4 = call i32 @p_cansee(%struct.thread* %8, %struct.proc* %9) #5, !dbg !2113
  store i32 %call4, i32* %error, align 4, !dbg !2113
  %10 = load i32* %error, align 4, !dbg !2114
  %tobool = icmp ne i32 %10, 0, !dbg !2114
  br i1 %tobool, label %if.then5, label %if.end8, !dbg !2114

if.then5:                                         ; preds = %if.end
  %11 = load %struct.proc** %p, align 8, !dbg !2115
  %p_mtx6 = getelementptr inbounds %struct.proc* %11, i32 0, i32 18, !dbg !2115
  %mtx_lock7 = getelementptr inbounds %struct.mtx* %p_mtx6, i32 0, i32 1, !dbg !2115
  call void @__mtx_unlock_flags(i64* %mtx_lock7, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 174) #5, !dbg !2115
  %12 = load i32* %error, align 4, !dbg !2117
  store i32 %12, i32* %retval, !dbg !2117
  br label %return, !dbg !2117

if.end8:                                          ; preds = %if.end
  br label %if.end9

if.end9:                                          ; preds = %if.end8, %if.then
  %13 = load %struct.proc** %p, align 8, !dbg !2118
  %p_pgrp = getelementptr inbounds %struct.proc* %13, i32 0, i32 55, !dbg !2118
  %14 = load %struct.pgrp** %p_pgrp, align 8, !dbg !2118
  %pg_id = getelementptr inbounds %struct.pgrp* %14, i32 0, i32 4, !dbg !2118
  %15 = load i32* %pg_id, align 4, !dbg !2118
  %conv = sext i32 %15 to i64, !dbg !2118
  %16 = load %struct.thread** %td.addr, align 8, !dbg !2118
  %td_retval = getelementptr inbounds %struct.thread* %16, i32 0, i32 78, !dbg !2118
  %arrayidx = getelementptr inbounds [2 x i64]* %td_retval, i32 0, i64 0, !dbg !2118
  store i64 %conv, i64* %arrayidx, align 8, !dbg !2118
  %17 = load %struct.proc** %p, align 8, !dbg !2119
  %p_mtx10 = getelementptr inbounds %struct.proc* %17, i32 0, i32 18, !dbg !2119
  %mtx_lock11 = getelementptr inbounds %struct.mtx* %p_mtx10, i32 0, i32 1, !dbg !2119
  call void @__mtx_unlock_flags(i64* %mtx_lock11, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 179) #5, !dbg !2119
  store i32 0, i32* %retval, !dbg !2120
  br label %return, !dbg !2120

return:                                           ; preds = %if.end9, %if.then5, %if.then3
  %18 = load i32* %retval, !dbg !2121
  ret i32 %18, !dbg !2121
}

; Function Attrs: noimplicitfloat noredzone
declare %struct.proc* @pfind(i32) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @p_cansee(%struct.thread* %td, %struct.proc* %p) #0 {
entry:
  %td.addr = alloca %struct.thread*, align 8
  %p.addr = alloca %struct.proc*, align 8
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !2122), !dbg !2123
  store %struct.proc* %p, %struct.proc** %p.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p.addr}, metadata !2124), !dbg !2123
  br label %do.body, !dbg !2125

do.body:                                          ; preds = %entry
  %0 = load %struct.thread** %td.addr, align 8, !dbg !2126
  %call = call %struct.thread* @__curthread() #6, !dbg !2126
  %cmp = icmp eq %struct.thread* %0, %call, !dbg !2126
  %lnot = xor i1 %cmp, true, !dbg !2126
  %lnot.ext = zext i1 %lnot to i32, !dbg !2126
  %conv = sext i32 %lnot.ext to i64, !dbg !2126
  %expval = call i64 @llvm.expect.i64(i64 %conv, i64 0), !dbg !2126
  %tobool = icmp ne i64 %expval, 0, !dbg !2126
  br i1 %tobool, label %if.then, label %if.end, !dbg !2126

if.then:                                          ; preds = %do.body
  call void (i8*, ...)* @kassert_panic(i8* getelementptr inbounds ([21 x i8]* @.str2, i32 0, i32 0), i8* getelementptr inbounds ([9 x i8]* @__func__.p_cansee, i32 0, i32 0)) #5, !dbg !2126
  br label %if.end, !dbg !2126

if.end:                                           ; preds = %if.then, %do.body
  br label %do.end, !dbg !2126

do.end:                                           ; preds = %if.end
  %1 = load %struct.proc** %p.addr, align 8, !dbg !2128
  %p_mtx = getelementptr inbounds %struct.proc* %1, i32 0, i32 18, !dbg !2128
  %mtx_lock = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !2128
  call void @__mtx_assert(i64* %mtx_lock, i32 4, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 1434) #5, !dbg !2128
  %2 = load %struct.thread** %td.addr, align 8, !dbg !2129
  %td_ucred = getelementptr inbounds %struct.thread* %2, i32 0, i32 37, !dbg !2129
  %3 = load %struct.ucred** %td_ucred, align 8, !dbg !2129
  %4 = load %struct.proc** %p.addr, align 8, !dbg !2129
  %p_ucred = getelementptr inbounds %struct.proc* %4, i32 0, i32 3, !dbg !2129
  %5 = load %struct.ucred** %p_ucred, align 8, !dbg !2129
  %call1 = call i32 @cr_cansee(%struct.ucred* %3, %struct.ucred* %5) #5, !dbg !2129
  ret i32 %call1, !dbg !2129
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys_getsid(%struct.thread* %td, %struct.getsid_args* %uap) #0 {
entry:
  %retval = alloca i32, align 4
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.getsid_args*, align 8
  %p = alloca %struct.proc*, align 8
  %error = alloca i32, align 4
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !2130), !dbg !2131
  store %struct.getsid_args* %uap, %struct.getsid_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.getsid_args** %uap.addr}, metadata !2132), !dbg !2131
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p}, metadata !2133), !dbg !2134
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !2135), !dbg !2136
  %0 = load %struct.getsid_args** %uap.addr, align 8, !dbg !2137
  %pid = getelementptr inbounds %struct.getsid_args* %0, i32 0, i32 1, !dbg !2137
  %1 = load i32* %pid, align 4, !dbg !2137
  %cmp = icmp eq i32 %1, 0, !dbg !2137
  br i1 %cmp, label %if.then, label %if.else, !dbg !2137

if.then:                                          ; preds = %entry
  %2 = load %struct.thread** %td.addr, align 8, !dbg !2138
  %td_proc = getelementptr inbounds %struct.thread* %2, i32 0, i32 1, !dbg !2138
  %3 = load %struct.proc** %td_proc, align 8, !dbg !2138
  store %struct.proc* %3, %struct.proc** %p, align 8, !dbg !2138
  %4 = load %struct.proc** %p, align 8, !dbg !2140
  %p_mtx = getelementptr inbounds %struct.proc* %4, i32 0, i32 18, !dbg !2140
  %mtx_lock = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !2140
  call void @__mtx_lock_flags(i64* %mtx_lock, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 199) #5, !dbg !2140
  br label %if.end9, !dbg !2141

if.else:                                          ; preds = %entry
  %5 = load %struct.getsid_args** %uap.addr, align 8, !dbg !2142
  %pid1 = getelementptr inbounds %struct.getsid_args* %5, i32 0, i32 1, !dbg !2142
  %6 = load i32* %pid1, align 4, !dbg !2142
  %call = call %struct.proc* @pfind(i32 %6) #5, !dbg !2142
  store %struct.proc* %call, %struct.proc** %p, align 8, !dbg !2142
  %7 = load %struct.proc** %p, align 8, !dbg !2144
  %cmp2 = icmp eq %struct.proc* %7, null, !dbg !2144
  br i1 %cmp2, label %if.then3, label %if.end, !dbg !2144

if.then3:                                         ; preds = %if.else
  store i32 3, i32* %retval, !dbg !2145
  br label %return, !dbg !2145

if.end:                                           ; preds = %if.else
  %8 = load %struct.thread** %td.addr, align 8, !dbg !2146
  %9 = load %struct.proc** %p, align 8, !dbg !2146
  %call4 = call i32 @p_cansee(%struct.thread* %8, %struct.proc* %9) #5, !dbg !2146
  store i32 %call4, i32* %error, align 4, !dbg !2146
  %10 = load i32* %error, align 4, !dbg !2147
  %tobool = icmp ne i32 %10, 0, !dbg !2147
  br i1 %tobool, label %if.then5, label %if.end8, !dbg !2147

if.then5:                                         ; preds = %if.end
  %11 = load %struct.proc** %p, align 8, !dbg !2148
  %p_mtx6 = getelementptr inbounds %struct.proc* %11, i32 0, i32 18, !dbg !2148
  %mtx_lock7 = getelementptr inbounds %struct.mtx* %p_mtx6, i32 0, i32 1, !dbg !2148
  call void @__mtx_unlock_flags(i64* %mtx_lock7, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 206) #5, !dbg !2148
  %12 = load i32* %error, align 4, !dbg !2150
  store i32 %12, i32* %retval, !dbg !2150
  br label %return, !dbg !2150

if.end8:                                          ; preds = %if.end
  br label %if.end9

if.end9:                                          ; preds = %if.end8, %if.then
  %13 = load %struct.proc** %p, align 8, !dbg !2151
  %p_pgrp = getelementptr inbounds %struct.proc* %13, i32 0, i32 55, !dbg !2151
  %14 = load %struct.pgrp** %p_pgrp, align 8, !dbg !2151
  %pg_session = getelementptr inbounds %struct.pgrp* %14, i32 0, i32 2, !dbg !2151
  %15 = load %struct.session** %pg_session, align 8, !dbg !2151
  %s_sid = getelementptr inbounds %struct.session* %15, i32 0, i32 5, !dbg !2151
  %16 = load i32* %s_sid, align 4, !dbg !2151
  %conv = sext i32 %16 to i64, !dbg !2151
  %17 = load %struct.thread** %td.addr, align 8, !dbg !2151
  %td_retval = getelementptr inbounds %struct.thread* %17, i32 0, i32 78, !dbg !2151
  %arrayidx = getelementptr inbounds [2 x i64]* %td_retval, i32 0, i64 0, !dbg !2151
  store i64 %conv, i64* %arrayidx, align 8, !dbg !2151
  %18 = load %struct.proc** %p, align 8, !dbg !2152
  %p_mtx10 = getelementptr inbounds %struct.proc* %18, i32 0, i32 18, !dbg !2152
  %mtx_lock11 = getelementptr inbounds %struct.mtx* %p_mtx10, i32 0, i32 1, !dbg !2152
  call void @__mtx_unlock_flags(i64* %mtx_lock11, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 211) #5, !dbg !2152
  store i32 0, i32* %retval, !dbg !2153
  br label %return, !dbg !2153

return:                                           ; preds = %if.end9, %if.then5, %if.then3
  %19 = load i32* %retval, !dbg !2154
  ret i32 %19, !dbg !2154
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys_getuid(%struct.thread* %td, %struct.getuid_args* %uap) #0 {
entry:
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.getuid_args*, align 8
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !2155), !dbg !2156
  store %struct.getuid_args* %uap, %struct.getuid_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.getuid_args** %uap.addr}, metadata !2157), !dbg !2156
  %0 = load %struct.thread** %td.addr, align 8, !dbg !2158
  %td_ucred = getelementptr inbounds %struct.thread* %0, i32 0, i32 37, !dbg !2158
  %1 = load %struct.ucred** %td_ucred, align 8, !dbg !2158
  %cr_ruid = getelementptr inbounds %struct.ucred* %1, i32 0, i32 2, !dbg !2158
  %2 = load i32* %cr_ruid, align 4, !dbg !2158
  %conv = zext i32 %2 to i64, !dbg !2158
  %3 = load %struct.thread** %td.addr, align 8, !dbg !2158
  %td_retval = getelementptr inbounds %struct.thread* %3, i32 0, i32 78, !dbg !2158
  %arrayidx = getelementptr inbounds [2 x i64]* %td_retval, i32 0, i64 0, !dbg !2158
  store i64 %conv, i64* %arrayidx, align 8, !dbg !2158
  ret i32 0, !dbg !2159
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys_geteuid(%struct.thread* %td, %struct.geteuid_args* %uap) #0 {
entry:
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.geteuid_args*, align 8
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !2160), !dbg !2161
  store %struct.geteuid_args* %uap, %struct.geteuid_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.geteuid_args** %uap.addr}, metadata !2162), !dbg !2161
  %0 = load %struct.thread** %td.addr, align 8, !dbg !2163
  %td_ucred = getelementptr inbounds %struct.thread* %0, i32 0, i32 37, !dbg !2163
  %1 = load %struct.ucred** %td_ucred, align 8, !dbg !2163
  %cr_uid = getelementptr inbounds %struct.ucred* %1, i32 0, i32 1, !dbg !2163
  %2 = load i32* %cr_uid, align 4, !dbg !2163
  %conv = zext i32 %2 to i64, !dbg !2163
  %3 = load %struct.thread** %td.addr, align 8, !dbg !2163
  %td_retval = getelementptr inbounds %struct.thread* %3, i32 0, i32 78, !dbg !2163
  %arrayidx = getelementptr inbounds [2 x i64]* %td_retval, i32 0, i64 0, !dbg !2163
  store i64 %conv, i64* %arrayidx, align 8, !dbg !2163
  ret i32 0, !dbg !2164
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys_getgid(%struct.thread* %td, %struct.getgid_args* %uap) #0 {
entry:
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.getgid_args*, align 8
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !2165), !dbg !2166
  store %struct.getgid_args* %uap, %struct.getgid_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.getgid_args** %uap.addr}, metadata !2167), !dbg !2166
  %0 = load %struct.thread** %td.addr, align 8, !dbg !2168
  %td_ucred = getelementptr inbounds %struct.thread* %0, i32 0, i32 37, !dbg !2168
  %1 = load %struct.ucred** %td_ucred, align 8, !dbg !2168
  %cr_rgid = getelementptr inbounds %struct.ucred* %1, i32 0, i32 5, !dbg !2168
  %2 = load i32* %cr_rgid, align 4, !dbg !2168
  %conv = zext i32 %2 to i64, !dbg !2168
  %3 = load %struct.thread** %td.addr, align 8, !dbg !2168
  %td_retval = getelementptr inbounds %struct.thread* %3, i32 0, i32 78, !dbg !2168
  %arrayidx = getelementptr inbounds [2 x i64]* %td_retval, i32 0, i64 0, !dbg !2168
  store i64 %conv, i64* %arrayidx, align 8, !dbg !2168
  ret i32 0, !dbg !2169
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys_getegid(%struct.thread* %td, %struct.getegid_args* %uap) #0 {
entry:
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.getegid_args*, align 8
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !2170), !dbg !2171
  store %struct.getegid_args* %uap, %struct.getegid_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.getegid_args** %uap.addr}, metadata !2172), !dbg !2171
  %0 = load %struct.thread** %td.addr, align 8, !dbg !2173
  %td_ucred = getelementptr inbounds %struct.thread* %0, i32 0, i32 37, !dbg !2173
  %1 = load %struct.ucred** %td_ucred, align 8, !dbg !2173
  %cr_groups = getelementptr inbounds %struct.ucred* %1, i32 0, i32 15, !dbg !2173
  %2 = load i32** %cr_groups, align 8, !dbg !2173
  %arrayidx = getelementptr inbounds i32* %2, i64 0, !dbg !2173
  %3 = load i32* %arrayidx, align 4, !dbg !2173
  %conv = zext i32 %3 to i64, !dbg !2173
  %4 = load %struct.thread** %td.addr, align 8, !dbg !2173
  %td_retval = getelementptr inbounds %struct.thread* %4, i32 0, i32 78, !dbg !2173
  %arrayidx1 = getelementptr inbounds [2 x i64]* %td_retval, i32 0, i64 0, !dbg !2173
  store i64 %conv, i64* %arrayidx1, align 8, !dbg !2173
  ret i32 0, !dbg !2174
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys_getgroups(%struct.thread* %td, %struct.getgroups_args* %uap) #0 {
entry:
  %retval = alloca i32, align 4
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.getgroups_args*, align 8
  %groups = alloca i32*, align 8
  %ngrp = alloca i32, align 4
  %error = alloca i32, align 4
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !2175), !dbg !2176
  store %struct.getgroups_args* %uap, %struct.getgroups_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.getgroups_args** %uap.addr}, metadata !2177), !dbg !2176
  call void @llvm.dbg.declare(metadata !{i32** %groups}, metadata !2178), !dbg !2179
  call void @llvm.dbg.declare(metadata !{i32* %ngrp}, metadata !2180), !dbg !2181
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !2182), !dbg !2183
  %0 = load %struct.getgroups_args** %uap.addr, align 8, !dbg !2184
  %gidsetsize = getelementptr inbounds %struct.getgroups_args* %0, i32 0, i32 1, !dbg !2184
  %1 = load i32* %gidsetsize, align 4, !dbg !2184
  %2 = load %struct.thread** %td.addr, align 8, !dbg !2184
  %td_ucred = getelementptr inbounds %struct.thread* %2, i32 0, i32 37, !dbg !2184
  %3 = load %struct.ucred** %td_ucred, align 8, !dbg !2184
  %cr_ngroups = getelementptr inbounds %struct.ucred* %3, i32 0, i32 4, !dbg !2184
  %4 = load i32* %cr_ngroups, align 4, !dbg !2184
  %cmp = icmp ult i32 %1, %4, !dbg !2184
  br i1 %cmp, label %if.then, label %if.else4, !dbg !2184

if.then:                                          ; preds = %entry
  %5 = load %struct.getgroups_args** %uap.addr, align 8, !dbg !2185
  %gidsetsize1 = getelementptr inbounds %struct.getgroups_args* %5, i32 0, i32 1, !dbg !2185
  %6 = load i32* %gidsetsize1, align 4, !dbg !2185
  %cmp2 = icmp eq i32 %6, 0, !dbg !2185
  br i1 %cmp2, label %if.then3, label %if.else, !dbg !2185

if.then3:                                         ; preds = %if.then
  store i32 0, i32* %ngrp, align 4, !dbg !2187
  br label %if.end, !dbg !2187

if.else:                                          ; preds = %if.then
  store i32 22, i32* %retval, !dbg !2188
  br label %return, !dbg !2188

if.end:                                           ; preds = %if.then3
  br label %if.end7, !dbg !2189

if.else4:                                         ; preds = %entry
  %7 = load %struct.thread** %td.addr, align 8, !dbg !2190
  %td_ucred5 = getelementptr inbounds %struct.thread* %7, i32 0, i32 37, !dbg !2190
  %8 = load %struct.ucred** %td_ucred5, align 8, !dbg !2190
  %cr_ngroups6 = getelementptr inbounds %struct.ucred* %8, i32 0, i32 4, !dbg !2190
  %9 = load i32* %cr_ngroups6, align 4, !dbg !2190
  store i32 %9, i32* %ngrp, align 4, !dbg !2190
  br label %if.end7

if.end7:                                          ; preds = %if.else4, %if.end
  %10 = load i32* %ngrp, align 4, !dbg !2191
  %conv = zext i32 %10 to i64, !dbg !2191
  %mul = mul i64 %conv, 4, !dbg !2191
  %call = call noalias i8* @malloc(i64 %mul, %struct.malloc_type* getelementptr inbounds ([1 x %struct.malloc_type]* @M_TEMP, i32 0, i32 0), i32 2) #5, !dbg !2191
  %11 = bitcast i8* %call to i32*, !dbg !2191
  store i32* %11, i32** %groups, align 8, !dbg !2191
  %12 = load %struct.thread** %td.addr, align 8, !dbg !2192
  %13 = load i32** %groups, align 8, !dbg !2192
  %call8 = call i32 @kern_getgroups(%struct.thread* %12, i32* %ngrp, i32* %13) #5, !dbg !2192
  store i32 %call8, i32* %error, align 4, !dbg !2192
  %14 = load i32* %error, align 4, !dbg !2193
  %tobool = icmp ne i32 %14, 0, !dbg !2193
  br i1 %tobool, label %if.then9, label %if.end10, !dbg !2193

if.then9:                                         ; preds = %if.end7
  br label %out, !dbg !2194

if.end10:                                         ; preds = %if.end7
  %15 = load %struct.getgroups_args** %uap.addr, align 8, !dbg !2195
  %gidsetsize11 = getelementptr inbounds %struct.getgroups_args* %15, i32 0, i32 1, !dbg !2195
  %16 = load i32* %gidsetsize11, align 4, !dbg !2195
  %cmp12 = icmp ugt i32 %16, 0, !dbg !2195
  br i1 %cmp12, label %if.then14, label %if.end18, !dbg !2195

if.then14:                                        ; preds = %if.end10
  %17 = load i32** %groups, align 8, !dbg !2196
  %18 = bitcast i32* %17 to i8*, !dbg !2196
  %19 = load %struct.getgroups_args** %uap.addr, align 8, !dbg !2196
  %gidset = getelementptr inbounds %struct.getgroups_args* %19, i32 0, i32 4, !dbg !2196
  %20 = load i32** %gidset, align 8, !dbg !2196
  %21 = bitcast i32* %20 to i8*, !dbg !2196
  %22 = load i32* %ngrp, align 4, !dbg !2196
  %conv15 = zext i32 %22 to i64, !dbg !2196
  %mul16 = mul i64 %conv15, 4, !dbg !2196
  %call17 = call i32 @copyout(i8* %18, i8* %21, i64 %mul16) #5, !dbg !2196
  store i32 %call17, i32* %error, align 4, !dbg !2196
  br label %if.end18, !dbg !2196

if.end18:                                         ; preds = %if.then14, %if.end10
  %23 = load i32* %error, align 4, !dbg !2197
  %cmp19 = icmp eq i32 %23, 0, !dbg !2197
  br i1 %cmp19, label %if.then21, label %if.end23, !dbg !2197

if.then21:                                        ; preds = %if.end18
  %24 = load i32* %ngrp, align 4, !dbg !2198
  %conv22 = zext i32 %24 to i64, !dbg !2198
  %25 = load %struct.thread** %td.addr, align 8, !dbg !2198
  %td_retval = getelementptr inbounds %struct.thread* %25, i32 0, i32 78, !dbg !2198
  %arrayidx = getelementptr inbounds [2 x i64]* %td_retval, i32 0, i64 0, !dbg !2198
  store i64 %conv22, i64* %arrayidx, align 8, !dbg !2198
  br label %if.end23, !dbg !2198

if.end23:                                         ; preds = %if.then21, %if.end18
  br label %out, !dbg !2198

out:                                              ; preds = %if.end23, %if.then9
  %26 = load i32** %groups, align 8, !dbg !2199
  %27 = bitcast i32* %26 to i8*, !dbg !2199
  call void @free(i8* %27, %struct.malloc_type* getelementptr inbounds ([1 x %struct.malloc_type]* @M_TEMP, i32 0, i32 0)) #5, !dbg !2199
  %28 = load i32* %error, align 4, !dbg !2200
  store i32 %28, i32* %retval, !dbg !2200
  br label %return, !dbg !2200

return:                                           ; preds = %out, %if.else
  %29 = load i32* %retval, !dbg !2201
  ret i32 %29, !dbg !2201
}

; Function Attrs: noimplicitfloat noredzone
declare noalias i8* @malloc(i64, %struct.malloc_type*, i32) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @kern_getgroups(%struct.thread* %td, i32* %ngrp, i32* %groups) #0 {
entry:
  %retval = alloca i32, align 4
  %td.addr = alloca %struct.thread*, align 8
  %ngrp.addr = alloca i32*, align 8
  %groups.addr = alloca i32*, align 8
  %cred = alloca %struct.ucred*, align 8
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !2202), !dbg !2203
  store i32* %ngrp, i32** %ngrp.addr, align 8
  call void @llvm.dbg.declare(metadata !{i32** %ngrp.addr}, metadata !2204), !dbg !2203
  store i32* %groups, i32** %groups.addr, align 8
  call void @llvm.dbg.declare(metadata !{i32** %groups.addr}, metadata !2205), !dbg !2203
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %cred}, metadata !2206), !dbg !2207
  %0 = load %struct.thread** %td.addr, align 8, !dbg !2208
  %td_ucred = getelementptr inbounds %struct.thread* %0, i32 0, i32 37, !dbg !2208
  %1 = load %struct.ucred** %td_ucred, align 8, !dbg !2208
  store %struct.ucred* %1, %struct.ucred** %cred, align 8, !dbg !2208
  %2 = load i32** %ngrp.addr, align 8, !dbg !2209
  %3 = load i32* %2, align 4, !dbg !2209
  %cmp = icmp eq i32 %3, 0, !dbg !2209
  br i1 %cmp, label %if.then, label %if.end, !dbg !2209

if.then:                                          ; preds = %entry
  %4 = load %struct.ucred** %cred, align 8, !dbg !2210
  %cr_ngroups = getelementptr inbounds %struct.ucred* %4, i32 0, i32 4, !dbg !2210
  %5 = load i32* %cr_ngroups, align 4, !dbg !2210
  %6 = load i32** %ngrp.addr, align 8, !dbg !2210
  store i32 %5, i32* %6, align 4, !dbg !2210
  store i32 0, i32* %retval, !dbg !2212
  br label %return, !dbg !2212

if.end:                                           ; preds = %entry
  %7 = load i32** %ngrp.addr, align 8, !dbg !2213
  %8 = load i32* %7, align 4, !dbg !2213
  %9 = load %struct.ucred** %cred, align 8, !dbg !2213
  %cr_ngroups1 = getelementptr inbounds %struct.ucred* %9, i32 0, i32 4, !dbg !2213
  %10 = load i32* %cr_ngroups1, align 4, !dbg !2213
  %cmp2 = icmp ult i32 %8, %10, !dbg !2213
  br i1 %cmp2, label %if.then3, label %if.end4, !dbg !2213

if.then3:                                         ; preds = %if.end
  store i32 22, i32* %retval, !dbg !2214
  br label %return, !dbg !2214

if.end4:                                          ; preds = %if.end
  %11 = load %struct.ucred** %cred, align 8, !dbg !2215
  %cr_ngroups5 = getelementptr inbounds %struct.ucred* %11, i32 0, i32 4, !dbg !2215
  %12 = load i32* %cr_ngroups5, align 4, !dbg !2215
  %13 = load i32** %ngrp.addr, align 8, !dbg !2215
  store i32 %12, i32* %13, align 4, !dbg !2215
  %14 = load %struct.ucred** %cred, align 8, !dbg !2216
  %cr_groups = getelementptr inbounds %struct.ucred* %14, i32 0, i32 15, !dbg !2216
  %15 = load i32** %cr_groups, align 8, !dbg !2216
  %16 = bitcast i32* %15 to i8*, !dbg !2216
  %17 = load i32** %groups.addr, align 8, !dbg !2216
  %18 = bitcast i32* %17 to i8*, !dbg !2216
  %19 = load i32** %ngrp.addr, align 8, !dbg !2216
  %20 = load i32* %19, align 4, !dbg !2216
  %conv = zext i32 %20 to i64, !dbg !2216
  %mul = mul i64 %conv, 4, !dbg !2216
  call void @bcopy(i8* %16, i8* %18, i64 %mul) #5, !dbg !2216
  store i32 0, i32* %retval, !dbg !2217
  br label %return, !dbg !2217

return:                                           ; preds = %if.end4, %if.then3, %if.then
  %21 = load i32* %retval, !dbg !2217
  ret i32 %21, !dbg !2217
}

; Function Attrs: noimplicitfloat noredzone
declare i32 @copyout(i8*, i8*, i64) #2

; Function Attrs: noimplicitfloat noredzone
declare void @free(i8*, %struct.malloc_type*) #2

; Function Attrs: noimplicitfloat noredzone
declare void @bcopy(i8*, i8*, i64) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys_setsid(%struct.thread* %td, %struct.setsid_args* %uap) #0 {
entry:
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.setsid_args*, align 8
  %pgrp = alloca %struct.pgrp*, align 8
  %error = alloca i32, align 4
  %p = alloca %struct.proc*, align 8
  %newpgrp = alloca %struct.pgrp*, align 8
  %newsess = alloca %struct.session*, align 8
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !2218), !dbg !2219
  store %struct.setsid_args* %uap, %struct.setsid_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.setsid_args** %uap.addr}, metadata !2220), !dbg !2219
  call void @llvm.dbg.declare(metadata !{%struct.pgrp** %pgrp}, metadata !2221), !dbg !2222
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !2223), !dbg !2224
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p}, metadata !2225), !dbg !2226
  %0 = load %struct.thread** %td.addr, align 8, !dbg !2226
  %td_proc = getelementptr inbounds %struct.thread* %0, i32 0, i32 1, !dbg !2226
  %1 = load %struct.proc** %td_proc, align 8, !dbg !2226
  store %struct.proc* %1, %struct.proc** %p, align 8, !dbg !2226
  call void @llvm.dbg.declare(metadata !{%struct.pgrp** %newpgrp}, metadata !2227), !dbg !2228
  call void @llvm.dbg.declare(metadata !{%struct.session** %newsess}, metadata !2229), !dbg !2230
  store i32 0, i32* %error, align 4, !dbg !2231
  store %struct.pgrp* null, %struct.pgrp** %pgrp, align 8, !dbg !2232
  %call = call noalias i8* @malloc(i64 80, %struct.malloc_type* getelementptr inbounds ([1 x %struct.malloc_type]* @M_PGRP, i32 0, i32 0), i32 258) #5, !dbg !2233
  %2 = bitcast i8* %call to %struct.pgrp*, !dbg !2233
  store %struct.pgrp* %2, %struct.pgrp** %newpgrp, align 8, !dbg !2233
  %call1 = call noalias i8* @malloc(i64 120, %struct.malloc_type* getelementptr inbounds ([1 x %struct.malloc_type]* @M_SESSION, i32 0, i32 0), i32 258) #5, !dbg !2234
  %3 = bitcast i8* %call1 to %struct.session*, !dbg !2234
  store %struct.session* %3, %struct.session** %newsess, align 8, !dbg !2234
  %call2 = call i32 @_sx_xlock(%struct.sx* @proctree_lock, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 353) #5, !dbg !2235
  %4 = load %struct.proc** %p, align 8, !dbg !2236
  %p_pgrp = getelementptr inbounds %struct.proc* %4, i32 0, i32 55, !dbg !2236
  %5 = load %struct.pgrp** %p_pgrp, align 8, !dbg !2236
  %pg_id = getelementptr inbounds %struct.pgrp* %5, i32 0, i32 4, !dbg !2236
  %6 = load i32* %pg_id, align 4, !dbg !2236
  %7 = load %struct.proc** %p, align 8, !dbg !2236
  %p_pid = getelementptr inbounds %struct.proc* %7, i32 0, i32 12, !dbg !2236
  %8 = load i32* %p_pid, align 4, !dbg !2236
  %cmp = icmp eq i32 %6, %8, !dbg !2236
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !2236

lor.lhs.false:                                    ; preds = %entry
  %9 = load %struct.proc** %p, align 8, !dbg !2236
  %p_pid3 = getelementptr inbounds %struct.proc* %9, i32 0, i32 12, !dbg !2236
  %10 = load i32* %p_pid3, align 4, !dbg !2236
  %call4 = call %struct.pgrp* @pgfind(i32 %10) #5, !dbg !2236
  store %struct.pgrp* %call4, %struct.pgrp** %pgrp, align 8, !dbg !2236
  %cmp5 = icmp ne %struct.pgrp* %call4, null, !dbg !2236
  br i1 %cmp5, label %if.then, label %if.else, !dbg !2236

if.then:                                          ; preds = %lor.lhs.false, %entry
  %11 = load %struct.pgrp** %pgrp, align 8, !dbg !2237
  %cmp6 = icmp ne %struct.pgrp* %11, null, !dbg !2237
  br i1 %cmp6, label %if.then7, label %if.end, !dbg !2237

if.then7:                                         ; preds = %if.then
  %12 = load %struct.pgrp** %pgrp, align 8, !dbg !2239
  %pg_mtx = getelementptr inbounds %struct.pgrp* %12, i32 0, i32 6, !dbg !2239
  %mtx_lock = getelementptr inbounds %struct.mtx* %pg_mtx, i32 0, i32 1, !dbg !2239
  call void @__mtx_unlock_flags(i64* %mtx_lock, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 357) #5, !dbg !2239
  br label %if.end, !dbg !2239

if.end:                                           ; preds = %if.then7, %if.then
  store i32 1, i32* %error, align 4, !dbg !2240
  br label %if.end11, !dbg !2241

if.else:                                          ; preds = %lor.lhs.false
  %13 = load %struct.proc** %p, align 8, !dbg !2242
  %14 = load %struct.proc** %p, align 8, !dbg !2242
  %p_pid8 = getelementptr inbounds %struct.proc* %14, i32 0, i32 12, !dbg !2242
  %15 = load i32* %p_pid8, align 4, !dbg !2242
  %16 = load %struct.pgrp** %newpgrp, align 8, !dbg !2242
  %17 = load %struct.session** %newsess, align 8, !dbg !2242
  %call9 = call i32 @enterpgrp(%struct.proc* %13, i32 %15, %struct.pgrp* %16, %struct.session* %17) #5, !dbg !2242
  %18 = load %struct.proc** %p, align 8, !dbg !2244
  %p_pid10 = getelementptr inbounds %struct.proc* %18, i32 0, i32 12, !dbg !2244
  %19 = load i32* %p_pid10, align 4, !dbg !2244
  %conv = sext i32 %19 to i64, !dbg !2244
  %20 = load %struct.thread** %td.addr, align 8, !dbg !2244
  %td_retval = getelementptr inbounds %struct.thread* %20, i32 0, i32 78, !dbg !2244
  %arrayidx = getelementptr inbounds [2 x i64]* %td_retval, i32 0, i64 0, !dbg !2244
  store i64 %conv, i64* %arrayidx, align 8, !dbg !2244
  store %struct.pgrp* null, %struct.pgrp** %newpgrp, align 8, !dbg !2245
  store %struct.session* null, %struct.session** %newsess, align 8, !dbg !2246
  br label %if.end11

if.end11:                                         ; preds = %if.else, %if.end
  call void @_sx_xunlock(%struct.sx* @proctree_lock, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 366) #5, !dbg !2247
  %21 = load %struct.pgrp** %newpgrp, align 8, !dbg !2248
  %cmp12 = icmp ne %struct.pgrp* %21, null, !dbg !2248
  br i1 %cmp12, label %if.then14, label %if.end15, !dbg !2248

if.then14:                                        ; preds = %if.end11
  %22 = load %struct.pgrp** %newpgrp, align 8, !dbg !2249
  %23 = bitcast %struct.pgrp* %22 to i8*, !dbg !2249
  call void @free(i8* %23, %struct.malloc_type* getelementptr inbounds ([1 x %struct.malloc_type]* @M_PGRP, i32 0, i32 0)) #5, !dbg !2249
  br label %if.end15, !dbg !2249

if.end15:                                         ; preds = %if.then14, %if.end11
  %24 = load %struct.session** %newsess, align 8, !dbg !2250
  %cmp16 = icmp ne %struct.session* %24, null, !dbg !2250
  br i1 %cmp16, label %if.then18, label %if.end19, !dbg !2250

if.then18:                                        ; preds = %if.end15
  %25 = load %struct.session** %newsess, align 8, !dbg !2251
  %26 = bitcast %struct.session* %25 to i8*, !dbg !2251
  call void @free(i8* %26, %struct.malloc_type* getelementptr inbounds ([1 x %struct.malloc_type]* @M_SESSION, i32 0, i32 0)) #5, !dbg !2251
  br label %if.end19, !dbg !2251

if.end19:                                         ; preds = %if.then18, %if.end15
  %27 = load i32* %error, align 4, !dbg !2252
  ret i32 %27, !dbg !2252
}

; Function Attrs: noimplicitfloat noredzone
declare i32 @_sx_xlock(%struct.sx*, i32, i8*, i32) #2

; Function Attrs: noimplicitfloat noredzone
declare %struct.pgrp* @pgfind(i32) #2

; Function Attrs: noimplicitfloat noredzone
declare i32 @enterpgrp(%struct.proc*, i32, %struct.pgrp*, %struct.session*) #2

; Function Attrs: noimplicitfloat noredzone
declare void @_sx_xunlock(%struct.sx*, i8*, i32) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys_setpgid(%struct.thread* %td, %struct.setpgid_args* %uap) #0 {
entry:
  %retval = alloca i32, align 4
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.setpgid_args*, align 8
  %curp = alloca %struct.proc*, align 8
  %targp = alloca %struct.proc*, align 8
  %pgrp = alloca %struct.pgrp*, align 8
  %error = alloca i32, align 4
  %newpgrp = alloca %struct.pgrp*, align 8
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !2253), !dbg !2254
  store %struct.setpgid_args* %uap, %struct.setpgid_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.setpgid_args** %uap.addr}, metadata !2255), !dbg !2254
  call void @llvm.dbg.declare(metadata !{%struct.proc** %curp}, metadata !2256), !dbg !2257
  %0 = load %struct.thread** %td.addr, align 8, !dbg !2257
  %td_proc = getelementptr inbounds %struct.thread* %0, i32 0, i32 1, !dbg !2257
  %1 = load %struct.proc** %td_proc, align 8, !dbg !2257
  store %struct.proc* %1, %struct.proc** %curp, align 8, !dbg !2257
  call void @llvm.dbg.declare(metadata !{%struct.proc** %targp}, metadata !2258), !dbg !2259
  call void @llvm.dbg.declare(metadata !{%struct.pgrp** %pgrp}, metadata !2260), !dbg !2261
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !2262), !dbg !2263
  call void @llvm.dbg.declare(metadata !{%struct.pgrp** %newpgrp}, metadata !2264), !dbg !2265
  %2 = load %struct.setpgid_args** %uap.addr, align 8, !dbg !2266
  %pgid = getelementptr inbounds %struct.setpgid_args* %2, i32 0, i32 4, !dbg !2266
  %3 = load i32* %pgid, align 4, !dbg !2266
  %cmp = icmp slt i32 %3, 0, !dbg !2266
  br i1 %cmp, label %if.then, label %if.end, !dbg !2266

if.then:                                          ; preds = %entry
  store i32 22, i32* %retval, !dbg !2267
  br label %return, !dbg !2267

if.end:                                           ; preds = %entry
  store i32 0, i32* %error, align 4, !dbg !2268
  %call = call noalias i8* @malloc(i64 80, %struct.malloc_type* getelementptr inbounds ([1 x %struct.malloc_type]* @M_PGRP, i32 0, i32 0), i32 258) #5, !dbg !2269
  %4 = bitcast i8* %call to %struct.pgrp*, !dbg !2269
  store %struct.pgrp* %4, %struct.pgrp** %newpgrp, align 8, !dbg !2269
  %call1 = call i32 @_sx_xlock(%struct.sx* @proctree_lock, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 412) #5, !dbg !2270
  %5 = load %struct.setpgid_args** %uap.addr, align 8, !dbg !2271
  %pid = getelementptr inbounds %struct.setpgid_args* %5, i32 0, i32 1, !dbg !2271
  %6 = load i32* %pid, align 4, !dbg !2271
  %cmp2 = icmp ne i32 %6, 0, !dbg !2271
  br i1 %cmp2, label %land.lhs.true, label %if.else, !dbg !2271

land.lhs.true:                                    ; preds = %if.end
  %7 = load %struct.setpgid_args** %uap.addr, align 8, !dbg !2271
  %pid3 = getelementptr inbounds %struct.setpgid_args* %7, i32 0, i32 1, !dbg !2271
  %8 = load i32* %pid3, align 4, !dbg !2271
  %9 = load %struct.proc** %curp, align 8, !dbg !2271
  %p_pid = getelementptr inbounds %struct.proc* %9, i32 0, i32 12, !dbg !2271
  %10 = load i32* %p_pid, align 4, !dbg !2271
  %cmp4 = icmp ne i32 %8, %10, !dbg !2271
  br i1 %cmp4, label %if.then5, label %if.else, !dbg !2271

if.then5:                                         ; preds = %land.lhs.true
  %11 = load %struct.setpgid_args** %uap.addr, align 8, !dbg !2272
  %pid6 = getelementptr inbounds %struct.setpgid_args* %11, i32 0, i32 1, !dbg !2272
  %12 = load i32* %pid6, align 4, !dbg !2272
  %call7 = call %struct.proc* @pfind(i32 %12) #5, !dbg !2272
  store %struct.proc* %call7, %struct.proc** %targp, align 8, !dbg !2272
  %cmp8 = icmp eq %struct.proc* %call7, null, !dbg !2272
  br i1 %cmp8, label %if.then9, label %if.end10, !dbg !2272

if.then9:                                         ; preds = %if.then5
  store i32 3, i32* %error, align 4, !dbg !2274
  br label %done, !dbg !2276

if.end10:                                         ; preds = %if.then5
  %13 = load %struct.proc** %targp, align 8, !dbg !2277
  %call11 = call i32 @inferior(%struct.proc* %13) #5, !dbg !2277
  %tobool = icmp ne i32 %call11, 0, !dbg !2277
  br i1 %tobool, label %if.end13, label %if.then12, !dbg !2277

if.then12:                                        ; preds = %if.end10
  %14 = load %struct.proc** %targp, align 8, !dbg !2278
  %p_mtx = getelementptr inbounds %struct.proc* %14, i32 0, i32 18, !dbg !2278
  %mtx_lock = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !2278
  call void @__mtx_unlock_flags(i64* %mtx_lock, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 419) #5, !dbg !2278
  store i32 3, i32* %error, align 4, !dbg !2280
  br label %done, !dbg !2281

if.end13:                                         ; preds = %if.end10
  %15 = load %struct.thread** %td.addr, align 8, !dbg !2282
  %16 = load %struct.proc** %targp, align 8, !dbg !2282
  %call14 = call i32 @p_cansee(%struct.thread* %15, %struct.proc* %16) #5, !dbg !2282
  store i32 %call14, i32* %error, align 4, !dbg !2282
  %tobool15 = icmp ne i32 %call14, 0, !dbg !2282
  br i1 %tobool15, label %if.then16, label %if.end19, !dbg !2282

if.then16:                                        ; preds = %if.end13
  %17 = load %struct.proc** %targp, align 8, !dbg !2283
  %p_mtx17 = getelementptr inbounds %struct.proc* %17, i32 0, i32 18, !dbg !2283
  %mtx_lock18 = getelementptr inbounds %struct.mtx* %p_mtx17, i32 0, i32 1, !dbg !2283
  call void @__mtx_unlock_flags(i64* %mtx_lock18, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 424) #5, !dbg !2283
  br label %done, !dbg !2285

if.end19:                                         ; preds = %if.end13
  %18 = load %struct.proc** %targp, align 8, !dbg !2286
  %p_pgrp = getelementptr inbounds %struct.proc* %18, i32 0, i32 55, !dbg !2286
  %19 = load %struct.pgrp** %p_pgrp, align 8, !dbg !2286
  %cmp20 = icmp eq %struct.pgrp* %19, null, !dbg !2286
  br i1 %cmp20, label %if.then25, label %lor.lhs.false, !dbg !2286

lor.lhs.false:                                    ; preds = %if.end19
  %20 = load %struct.proc** %targp, align 8, !dbg !2286
  %p_pgrp21 = getelementptr inbounds %struct.proc* %20, i32 0, i32 55, !dbg !2286
  %21 = load %struct.pgrp** %p_pgrp21, align 8, !dbg !2286
  %pg_session = getelementptr inbounds %struct.pgrp* %21, i32 0, i32 2, !dbg !2286
  %22 = load %struct.session** %pg_session, align 8, !dbg !2286
  %23 = load %struct.proc** %curp, align 8, !dbg !2286
  %p_pgrp22 = getelementptr inbounds %struct.proc* %23, i32 0, i32 55, !dbg !2286
  %24 = load %struct.pgrp** %p_pgrp22, align 8, !dbg !2286
  %pg_session23 = getelementptr inbounds %struct.pgrp* %24, i32 0, i32 2, !dbg !2286
  %25 = load %struct.session** %pg_session23, align 8, !dbg !2286
  %cmp24 = icmp ne %struct.session* %22, %25, !dbg !2286
  br i1 %cmp24, label %if.then25, label %if.end28, !dbg !2286

if.then25:                                        ; preds = %lor.lhs.false, %if.end19
  %26 = load %struct.proc** %targp, align 8, !dbg !2287
  %p_mtx26 = getelementptr inbounds %struct.proc* %26, i32 0, i32 18, !dbg !2287
  %mtx_lock27 = getelementptr inbounds %struct.mtx* %p_mtx26, i32 0, i32 1, !dbg !2287
  call void @__mtx_unlock_flags(i64* %mtx_lock27, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 429) #5, !dbg !2287
  store i32 1, i32* %error, align 4, !dbg !2289
  br label %done, !dbg !2290

if.end28:                                         ; preds = %lor.lhs.false
  %27 = load %struct.proc** %targp, align 8, !dbg !2291
  %p_flag = getelementptr inbounds %struct.proc* %27, i32 0, i32 10, !dbg !2291
  %28 = load i32* %p_flag, align 4, !dbg !2291
  %and = and i32 %28, 16384, !dbg !2291
  %tobool29 = icmp ne i32 %and, 0, !dbg !2291
  br i1 %tobool29, label %if.then30, label %if.end33, !dbg !2291

if.then30:                                        ; preds = %if.end28
  %29 = load %struct.proc** %targp, align 8, !dbg !2292
  %p_mtx31 = getelementptr inbounds %struct.proc* %29, i32 0, i32 18, !dbg !2292
  %mtx_lock32 = getelementptr inbounds %struct.mtx* %p_mtx31, i32 0, i32 1, !dbg !2292
  call void @__mtx_unlock_flags(i64* %mtx_lock32, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 434) #5, !dbg !2292
  store i32 13, i32* %error, align 4, !dbg !2294
  br label %done, !dbg !2295

if.end33:                                         ; preds = %if.end28
  %30 = load %struct.proc** %targp, align 8, !dbg !2296
  %p_mtx34 = getelementptr inbounds %struct.proc* %30, i32 0, i32 18, !dbg !2296
  %mtx_lock35 = getelementptr inbounds %struct.mtx* %p_mtx34, i32 0, i32 1, !dbg !2296
  call void @__mtx_unlock_flags(i64* %mtx_lock35, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 438) #5, !dbg !2296
  br label %if.end36, !dbg !2297

if.else:                                          ; preds = %land.lhs.true, %if.end
  %31 = load %struct.proc** %curp, align 8, !dbg !2298
  store %struct.proc* %31, %struct.proc** %targp, align 8, !dbg !2298
  br label %if.end36

if.end36:                                         ; preds = %if.else, %if.end33
  %32 = load %struct.proc** %targp, align 8, !dbg !2299
  %p_pgrp37 = getelementptr inbounds %struct.proc* %32, i32 0, i32 55, !dbg !2299
  %33 = load %struct.pgrp** %p_pgrp37, align 8, !dbg !2299
  %pg_session38 = getelementptr inbounds %struct.pgrp* %33, i32 0, i32 2, !dbg !2299
  %34 = load %struct.session** %pg_session38, align 8, !dbg !2299
  %s_leader = getelementptr inbounds %struct.session* %34, i32 0, i32 1, !dbg !2299
  %35 = load %struct.proc** %s_leader, align 8, !dbg !2299
  %36 = load %struct.proc** %targp, align 8, !dbg !2299
  %cmp39 = icmp eq %struct.proc* %35, %36, !dbg !2299
  br i1 %cmp39, label %if.then40, label %if.end41, !dbg !2299

if.then40:                                        ; preds = %if.end36
  store i32 1, i32* %error, align 4, !dbg !2300
  br label %done, !dbg !2302

if.end41:                                         ; preds = %if.end36
  %37 = load %struct.setpgid_args** %uap.addr, align 8, !dbg !2303
  %pgid42 = getelementptr inbounds %struct.setpgid_args* %37, i32 0, i32 4, !dbg !2303
  %38 = load i32* %pgid42, align 4, !dbg !2303
  %cmp43 = icmp eq i32 %38, 0, !dbg !2303
  br i1 %cmp43, label %if.then44, label %if.end47, !dbg !2303

if.then44:                                        ; preds = %if.end41
  %39 = load %struct.proc** %targp, align 8, !dbg !2304
  %p_pid45 = getelementptr inbounds %struct.proc* %39, i32 0, i32 12, !dbg !2304
  %40 = load i32* %p_pid45, align 4, !dbg !2304
  %41 = load %struct.setpgid_args** %uap.addr, align 8, !dbg !2304
  %pgid46 = getelementptr inbounds %struct.setpgid_args* %41, i32 0, i32 4, !dbg !2304
  store i32 %40, i32* %pgid46, align 4, !dbg !2304
  br label %if.end47, !dbg !2304

if.end47:                                         ; preds = %if.then44, %if.end41
  %42 = load %struct.setpgid_args** %uap.addr, align 8, !dbg !2305
  %pgid48 = getelementptr inbounds %struct.setpgid_args* %42, i32 0, i32 4, !dbg !2305
  %43 = load i32* %pgid48, align 4, !dbg !2305
  %call49 = call %struct.pgrp* @pgfind(i32 %43) #5, !dbg !2305
  store %struct.pgrp* %call49, %struct.pgrp** %pgrp, align 8, !dbg !2305
  %cmp50 = icmp eq %struct.pgrp* %call49, null, !dbg !2305
  br i1 %cmp50, label %if.then51, label %if.else63, !dbg !2305

if.then51:                                        ; preds = %if.end47
  %44 = load %struct.setpgid_args** %uap.addr, align 8, !dbg !2306
  %pgid52 = getelementptr inbounds %struct.setpgid_args* %44, i32 0, i32 4, !dbg !2306
  %45 = load i32* %pgid52, align 4, !dbg !2306
  %46 = load %struct.proc** %targp, align 8, !dbg !2306
  %p_pid53 = getelementptr inbounds %struct.proc* %46, i32 0, i32 12, !dbg !2306
  %47 = load i32* %p_pid53, align 4, !dbg !2306
  %cmp54 = icmp eq i32 %45, %47, !dbg !2306
  br i1 %cmp54, label %if.then55, label %if.else61, !dbg !2306

if.then55:                                        ; preds = %if.then51
  %48 = load %struct.proc** %targp, align 8, !dbg !2308
  %49 = load %struct.setpgid_args** %uap.addr, align 8, !dbg !2308
  %pgid56 = getelementptr inbounds %struct.setpgid_args* %49, i32 0, i32 4, !dbg !2308
  %50 = load i32* %pgid56, align 4, !dbg !2308
  %51 = load %struct.pgrp** %newpgrp, align 8, !dbg !2308
  %call57 = call i32 @enterpgrp(%struct.proc* %48, i32 %50, %struct.pgrp* %51, %struct.session* null) #5, !dbg !2308
  store i32 %call57, i32* %error, align 4, !dbg !2308
  %52 = load i32* %error, align 4, !dbg !2310
  %cmp58 = icmp eq i32 %52, 0, !dbg !2310
  br i1 %cmp58, label %if.then59, label %if.end60, !dbg !2310

if.then59:                                        ; preds = %if.then55
  store %struct.pgrp* null, %struct.pgrp** %newpgrp, align 8, !dbg !2311
  br label %if.end60, !dbg !2311

if.end60:                                         ; preds = %if.then59, %if.then55
  br label %if.end62, !dbg !2312

if.else61:                                        ; preds = %if.then51
  store i32 1, i32* %error, align 4, !dbg !2313
  br label %if.end62

if.end62:                                         ; preds = %if.else61, %if.end60
  br label %if.end83, !dbg !2314

if.else63:                                        ; preds = %if.end47
  %53 = load %struct.pgrp** %pgrp, align 8, !dbg !2315
  %54 = load %struct.proc** %targp, align 8, !dbg !2315
  %p_pgrp64 = getelementptr inbounds %struct.proc* %54, i32 0, i32 55, !dbg !2315
  %55 = load %struct.pgrp** %p_pgrp64, align 8, !dbg !2315
  %cmp65 = icmp eq %struct.pgrp* %53, %55, !dbg !2315
  br i1 %cmp65, label %if.then66, label %if.end68, !dbg !2315

if.then66:                                        ; preds = %if.else63
  %56 = load %struct.pgrp** %pgrp, align 8, !dbg !2317
  %pg_mtx = getelementptr inbounds %struct.pgrp* %56, i32 0, i32 6, !dbg !2317
  %mtx_lock67 = getelementptr inbounds %struct.mtx* %pg_mtx, i32 0, i32 1, !dbg !2317
  call void @__mtx_unlock_flags(i64* %mtx_lock67, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 457) #5, !dbg !2317
  br label %done, !dbg !2319

if.end68:                                         ; preds = %if.else63
  %57 = load %struct.pgrp** %pgrp, align 8, !dbg !2320
  %pg_id = getelementptr inbounds %struct.pgrp* %57, i32 0, i32 4, !dbg !2320
  %58 = load i32* %pg_id, align 4, !dbg !2320
  %59 = load %struct.proc** %targp, align 8, !dbg !2320
  %p_pid69 = getelementptr inbounds %struct.proc* %59, i32 0, i32 12, !dbg !2320
  %60 = load i32* %p_pid69, align 4, !dbg !2320
  %cmp70 = icmp ne i32 %58, %60, !dbg !2320
  br i1 %cmp70, label %land.lhs.true71, label %if.end79, !dbg !2320

land.lhs.true71:                                  ; preds = %if.end68
  %61 = load %struct.pgrp** %pgrp, align 8, !dbg !2320
  %pg_session72 = getelementptr inbounds %struct.pgrp* %61, i32 0, i32 2, !dbg !2320
  %62 = load %struct.session** %pg_session72, align 8, !dbg !2320
  %63 = load %struct.proc** %curp, align 8, !dbg !2320
  %p_pgrp73 = getelementptr inbounds %struct.proc* %63, i32 0, i32 55, !dbg !2320
  %64 = load %struct.pgrp** %p_pgrp73, align 8, !dbg !2320
  %pg_session74 = getelementptr inbounds %struct.pgrp* %64, i32 0, i32 2, !dbg !2320
  %65 = load %struct.session** %pg_session74, align 8, !dbg !2320
  %cmp75 = icmp ne %struct.session* %62, %65, !dbg !2320
  br i1 %cmp75, label %if.then76, label %if.end79, !dbg !2320

if.then76:                                        ; preds = %land.lhs.true71
  %66 = load %struct.pgrp** %pgrp, align 8, !dbg !2321
  %pg_mtx77 = getelementptr inbounds %struct.pgrp* %66, i32 0, i32 6, !dbg !2321
  %mtx_lock78 = getelementptr inbounds %struct.mtx* %pg_mtx77, i32 0, i32 1, !dbg !2321
  call void @__mtx_unlock_flags(i64* %mtx_lock78, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 462) #5, !dbg !2321
  store i32 1, i32* %error, align 4, !dbg !2323
  br label %done, !dbg !2324

if.end79:                                         ; preds = %land.lhs.true71, %if.end68
  %67 = load %struct.pgrp** %pgrp, align 8, !dbg !2325
  %pg_mtx80 = getelementptr inbounds %struct.pgrp* %67, i32 0, i32 6, !dbg !2325
  %mtx_lock81 = getelementptr inbounds %struct.mtx* %pg_mtx80, i32 0, i32 1, !dbg !2325
  call void @__mtx_unlock_flags(i64* %mtx_lock81, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 466) #5, !dbg !2325
  %68 = load %struct.proc** %targp, align 8, !dbg !2326
  %69 = load %struct.pgrp** %pgrp, align 8, !dbg !2326
  %call82 = call i32 @enterthispgrp(%struct.proc* %68, %struct.pgrp* %69) #5, !dbg !2326
  store i32 %call82, i32* %error, align 4, !dbg !2326
  br label %if.end83

if.end83:                                         ; preds = %if.end79, %if.end62
  br label %done

done:                                             ; preds = %if.end83, %if.then76, %if.then66, %if.then40, %if.then30, %if.then25, %if.then16, %if.then12, %if.then9
  call void @_sx_xunlock(%struct.sx* @proctree_lock, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 470) #5, !dbg !2327
  br label %do.body, !dbg !2328

do.body:                                          ; preds = %done
  %70 = load i32* %error, align 4, !dbg !2329
  %cmp84 = icmp eq i32 %70, 0, !dbg !2329
  br i1 %cmp84, label %lor.end, label %lor.rhs, !dbg !2329

lor.rhs:                                          ; preds = %do.body
  %71 = load %struct.pgrp** %newpgrp, align 8, !dbg !2329
  %cmp85 = icmp ne %struct.pgrp* %71, null, !dbg !2329
  br label %lor.end, !dbg !2329

lor.end:                                          ; preds = %lor.rhs, %do.body
  %72 = phi i1 [ true, %do.body ], [ %cmp85, %lor.rhs ]
  %lnot = xor i1 %72, true, !dbg !2329
  %lnot.ext = zext i1 %lnot to i32, !dbg !2329
  %conv = sext i32 %lnot.ext to i64, !dbg !2329
  %expval = call i64 @llvm.expect.i64(i64 %conv, i64 0), !dbg !2329
  %tobool86 = icmp ne i64 %expval, 0, !dbg !2329
  br i1 %tobool86, label %if.then87, label %if.end88, !dbg !2329

if.then87:                                        ; preds = %lor.end
  call void (i8*, ...)* @kassert_panic(i8* getelementptr inbounds ([35 x i8]* @.str1, i32 0, i32 0)) #5, !dbg !2329
  br label %if.end88, !dbg !2329

if.end88:                                         ; preds = %if.then87, %lor.end
  br label %do.end, !dbg !2329

do.end:                                           ; preds = %if.end88
  %73 = load %struct.pgrp** %newpgrp, align 8, !dbg !2331
  %cmp89 = icmp ne %struct.pgrp* %73, null, !dbg !2331
  br i1 %cmp89, label %if.then91, label %if.end92, !dbg !2331

if.then91:                                        ; preds = %do.end
  %74 = load %struct.pgrp** %newpgrp, align 8, !dbg !2332
  %75 = bitcast %struct.pgrp* %74 to i8*, !dbg !2332
  call void @free(i8* %75, %struct.malloc_type* getelementptr inbounds ([1 x %struct.malloc_type]* @M_PGRP, i32 0, i32 0)) #5, !dbg !2332
  br label %if.end92, !dbg !2332

if.end92:                                         ; preds = %if.then91, %do.end
  %76 = load i32* %error, align 4, !dbg !2333
  store i32 %76, i32* %retval, !dbg !2333
  br label %return, !dbg !2333

return:                                           ; preds = %if.end92, %if.then
  %77 = load i32* %retval, !dbg !2334
  ret i32 %77, !dbg !2334
}

; Function Attrs: noimplicitfloat noredzone
declare i32 @inferior(%struct.proc*) #2

; Function Attrs: noimplicitfloat noredzone
declare i32 @enterthispgrp(%struct.proc*, %struct.pgrp*) #2

; Function Attrs: nounwind readnone
declare i64 @llvm.expect.i64(i64, i64) #1

; Function Attrs: noimplicitfloat noredzone
declare void @kassert_panic(i8*, ...) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys_setuid(%struct.thread* %td, %struct.setuid_args* %uap) #0 {
entry:
  %retval = alloca i32, align 4
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.setuid_args*, align 8
  %p = alloca %struct.proc*, align 8
  %newcred = alloca %struct.ucred*, align 8
  %oldcred = alloca %struct.ucred*, align 8
  %uid = alloca i32, align 4
  %uip = alloca %struct.uidinfo*, align 8
  %error = alloca i32, align 4
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !2335), !dbg !2336
  store %struct.setuid_args* %uap, %struct.setuid_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.setuid_args** %uap.addr}, metadata !2337), !dbg !2336
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p}, metadata !2338), !dbg !2339
  %0 = load %struct.thread** %td.addr, align 8, !dbg !2339
  %td_proc = getelementptr inbounds %struct.thread* %0, i32 0, i32 1, !dbg !2339
  %1 = load %struct.proc** %td_proc, align 8, !dbg !2339
  store %struct.proc* %1, %struct.proc** %p, align 8, !dbg !2339
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %newcred}, metadata !2340), !dbg !2341
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %oldcred}, metadata !2342), !dbg !2341
  call void @llvm.dbg.declare(metadata !{i32* %uid}, metadata !2343), !dbg !2344
  call void @llvm.dbg.declare(metadata !{%struct.uidinfo** %uip}, metadata !2345), !dbg !2346
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !2347), !dbg !2348
  %2 = load %struct.setuid_args** %uap.addr, align 8, !dbg !2349
  %uid1 = getelementptr inbounds %struct.setuid_args* %2, i32 0, i32 1, !dbg !2349
  %3 = load i32* %uid1, align 4, !dbg !2349
  store i32 %3, i32* %uid, align 4, !dbg !2349
  br label %do.body, !dbg !2350

do.body:                                          ; preds = %entry
  %call = call %struct.thread* @__curthread() #6, !dbg !2351
  %td_pflags = getelementptr inbounds %struct.thread* %call, i32 0, i32 18, !dbg !2351
  %4 = load i32* %td_pflags, align 4, !dbg !2351
  %and = and i32 %4, 16777216, !dbg !2351
  %tobool = icmp ne i32 %and, 0, !dbg !2351
  br i1 %tobool, label %if.then, label %if.end, !dbg !2351

if.then:                                          ; preds = %do.body
  %5 = load i32* %uid, align 4, !dbg !2351
  call void @audit_arg_uid(i32 %5) #5, !dbg !2351
  br label %if.end, !dbg !2351

if.end:                                           ; preds = %if.then, %do.body
  br label %do.end, !dbg !2351

do.end:                                           ; preds = %if.end
  %call2 = call %struct.ucred* @crget() #5, !dbg !2353
  store %struct.ucred* %call2, %struct.ucred** %newcred, align 8, !dbg !2353
  %6 = load i32* %uid, align 4, !dbg !2354
  %call3 = call %struct.uidinfo* @uifind(i32 %6) #5, !dbg !2354
  store %struct.uidinfo* %call3, %struct.uidinfo** %uip, align 8, !dbg !2354
  %7 = load %struct.proc** %p, align 8, !dbg !2355
  %p_mtx = getelementptr inbounds %struct.proc* %7, i32 0, i32 18, !dbg !2355
  %mtx_lock = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !2355
  call void @__mtx_lock_flags(i64* %mtx_lock, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 509) #5, !dbg !2355
  %8 = load %struct.proc** %p, align 8, !dbg !2356
  %9 = load %struct.ucred** %newcred, align 8, !dbg !2356
  %call4 = call %struct.ucred* @crcopysafe(%struct.proc* %8, %struct.ucred* %9) #5, !dbg !2356
  store %struct.ucred* %call4, %struct.ucred** %oldcred, align 8, !dbg !2356
  %10 = load %struct.ucred** %oldcred, align 8, !dbg !2357
  %11 = load i32* %uid, align 4, !dbg !2357
  %call5 = call i32 @mac_cred_check_setuid(%struct.ucred* %10, i32 %11) #5, !dbg !2357
  store i32 %call5, i32* %error, align 4, !dbg !2357
  %12 = load i32* %error, align 4, !dbg !2358
  %tobool6 = icmp ne i32 %12, 0, !dbg !2358
  br i1 %tobool6, label %if.then7, label %if.end8, !dbg !2358

if.then7:                                         ; preds = %do.end
  br label %fail, !dbg !2359

if.end8:                                          ; preds = %do.end
  %13 = load i32* %uid, align 4, !dbg !2360
  %14 = load %struct.ucred** %oldcred, align 8, !dbg !2360
  %cr_ruid = getelementptr inbounds %struct.ucred* %14, i32 0, i32 2, !dbg !2360
  %15 = load i32* %cr_ruid, align 4, !dbg !2360
  %cmp = icmp ne i32 %13, %15, !dbg !2360
  br i1 %cmp, label %land.lhs.true, label %if.end14, !dbg !2360

land.lhs.true:                                    ; preds = %if.end8
  %16 = load i32* %uid, align 4, !dbg !2360
  %17 = load %struct.ucred** %oldcred, align 8, !dbg !2360
  %cr_uid = getelementptr inbounds %struct.ucred* %17, i32 0, i32 1, !dbg !2360
  %18 = load i32* %cr_uid, align 4, !dbg !2360
  %cmp9 = icmp ne i32 %16, %18, !dbg !2360
  br i1 %cmp9, label %land.lhs.true10, label %if.end14, !dbg !2360

land.lhs.true10:                                  ; preds = %land.lhs.true
  %19 = load %struct.ucred** %oldcred, align 8, !dbg !2361
  %call11 = call i32 @priv_check_cred(%struct.ucred* %19, i32 50, i32 0) #5, !dbg !2361
  store i32 %call11, i32* %error, align 4, !dbg !2361
  %cmp12 = icmp ne i32 %call11, 0, !dbg !2361
  br i1 %cmp12, label %if.then13, label %if.end14, !dbg !2361

if.then13:                                        ; preds = %land.lhs.true10
  br label %fail, !dbg !2362

if.end14:                                         ; preds = %land.lhs.true10, %land.lhs.true, %if.end8
  %20 = load i32* %uid, align 4, !dbg !2363
  %21 = load %struct.ucred** %oldcred, align 8, !dbg !2363
  %cr_ruid15 = getelementptr inbounds %struct.ucred* %21, i32 0, i32 2, !dbg !2363
  %22 = load i32* %cr_ruid15, align 4, !dbg !2363
  %cmp16 = icmp ne i32 %20, %22, !dbg !2363
  br i1 %cmp16, label %if.then17, label %if.end18, !dbg !2363

if.then17:                                        ; preds = %if.end14
  %23 = load %struct.ucred** %newcred, align 8, !dbg !2365
  %24 = load %struct.uidinfo** %uip, align 8, !dbg !2365
  call void @change_ruid(%struct.ucred* %23, %struct.uidinfo* %24) #5, !dbg !2365
  %25 = load %struct.proc** %p, align 8, !dbg !2367
  call void @setsugid(%struct.proc* %25) #5, !dbg !2367
  br label %if.end18, !dbg !2368

if.end18:                                         ; preds = %if.then17, %if.end14
  %26 = load i32* %uid, align 4, !dbg !2369
  %27 = load %struct.ucred** %oldcred, align 8, !dbg !2369
  %cr_svuid = getelementptr inbounds %struct.ucred* %27, i32 0, i32 3, !dbg !2369
  %28 = load i32* %cr_svuid, align 4, !dbg !2369
  %cmp19 = icmp ne i32 %26, %28, !dbg !2369
  br i1 %cmp19, label %if.then20, label %if.end21, !dbg !2369

if.then20:                                        ; preds = %if.end18
  %29 = load %struct.ucred** %newcred, align 8, !dbg !2370
  %30 = load i32* %uid, align 4, !dbg !2370
  call void @change_svuid(%struct.ucred* %29, i32 %30) #5, !dbg !2370
  %31 = load %struct.proc** %p, align 8, !dbg !2372
  call void @setsugid(%struct.proc* %31) #5, !dbg !2372
  br label %if.end21, !dbg !2373

if.end21:                                         ; preds = %if.then20, %if.end18
  %32 = load i32* %uid, align 4, !dbg !2374
  %33 = load %struct.ucred** %oldcred, align 8, !dbg !2374
  %cr_uid22 = getelementptr inbounds %struct.ucred* %33, i32 0, i32 1, !dbg !2374
  %34 = load i32* %cr_uid22, align 4, !dbg !2374
  %cmp23 = icmp ne i32 %32, %34, !dbg !2374
  br i1 %cmp23, label %if.then24, label %if.end25, !dbg !2374

if.then24:                                        ; preds = %if.end21
  %35 = load %struct.ucred** %newcred, align 8, !dbg !2375
  %36 = load %struct.uidinfo** %uip, align 8, !dbg !2375
  call void @change_euid(%struct.ucred* %35, %struct.uidinfo* %36) #5, !dbg !2375
  %37 = load %struct.proc** %p, align 8, !dbg !2377
  call void @setsugid(%struct.proc* %37) #5, !dbg !2377
  br label %if.end25, !dbg !2378

if.end25:                                         ; preds = %if.then24, %if.end21
  %38 = load %struct.ucred** %newcred, align 8, !dbg !2379
  %39 = load %struct.proc** %p, align 8, !dbg !2379
  %p_ucred = getelementptr inbounds %struct.proc* %39, i32 0, i32 3, !dbg !2379
  store %struct.ucred* %38, %struct.ucred** %p_ucred, align 8, !dbg !2379
  %40 = load %struct.proc** %p, align 8, !dbg !2380
  %p_mtx26 = getelementptr inbounds %struct.proc* %40, i32 0, i32 18, !dbg !2380
  %mtx_lock27 = getelementptr inbounds %struct.mtx* %p_mtx26, i32 0, i32 1, !dbg !2380
  call void @__mtx_unlock_flags(i64* %mtx_lock27, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 589) #5, !dbg !2380
  %41 = load %struct.uidinfo** %uip, align 8, !dbg !2381
  call void @uifree(%struct.uidinfo* %41) #5, !dbg !2381
  %42 = load %struct.ucred** %oldcred, align 8, !dbg !2382
  call void @crfree(%struct.ucred* %42) #5, !dbg !2382
  store i32 0, i32* %retval, !dbg !2383
  br label %return, !dbg !2383

fail:                                             ; preds = %if.then13, %if.then7
  %43 = load %struct.proc** %p, align 8, !dbg !2384
  %p_mtx28 = getelementptr inbounds %struct.proc* %43, i32 0, i32 18, !dbg !2384
  %mtx_lock29 = getelementptr inbounds %struct.mtx* %p_mtx28, i32 0, i32 1, !dbg !2384
  call void @__mtx_unlock_flags(i64* %mtx_lock29, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 598) #5, !dbg !2384
  %44 = load %struct.uidinfo** %uip, align 8, !dbg !2385
  call void @uifree(%struct.uidinfo* %44) #5, !dbg !2385
  %45 = load %struct.ucred** %newcred, align 8, !dbg !2386
  call void @crfree(%struct.ucred* %45) #5, !dbg !2386
  %46 = load i32* %error, align 4, !dbg !2387
  store i32 %46, i32* %retval, !dbg !2387
  br label %return, !dbg !2387

return:                                           ; preds = %fail, %if.end25
  %47 = load i32* %retval, !dbg !2388
  ret i32 %47, !dbg !2388
}

; Function Attrs: inlinehint noimplicitfloat noredzone nounwind readnone ssp
define internal %struct.thread* @__curthread() #3 {
entry:
  %td = alloca %struct.thread*, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td}, metadata !2389), !dbg !2391
  %0 = call %struct.thread* asm "movq %gs:$1,$0", "=r,*m,~{dirflag},~{fpsr},~{flags}"(i8* null) #7, !dbg !2392, !srcloc !2393
  store %struct.thread* %0, %struct.thread** %td, align 8, !dbg !2392
  %1 = load %struct.thread** %td, align 8, !dbg !2394
  ret %struct.thread* %1, !dbg !2394
}

; Function Attrs: noimplicitfloat noredzone
declare void @audit_arg_uid(i32) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define %struct.ucred* @crget() #0 {
entry:
  %cr = alloca %struct.ucred*, align 8
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %cr}, metadata !2395), !dbg !2396
  %call = call noalias i8* @malloc(i64 160, %struct.malloc_type* getelementptr inbounds ([1 x %struct.malloc_type]* @M_CRED, i32 0, i32 0), i32 258) #5, !dbg !2397
  %0 = bitcast i8* %call to %struct.ucred*, !dbg !2397
  store %struct.ucred* %0, %struct.ucred** %cr, align 8, !dbg !2397
  %1 = load %struct.ucred** %cr, align 8, !dbg !2398
  %cr_ref = getelementptr inbounds %struct.ucred* %1, i32 0, i32 0, !dbg !2398
  call void @refcount_init(i32* %cr_ref, i32 1) #5, !dbg !2398
  %2 = load %struct.ucred** %cr, align 8, !dbg !2399
  call void @audit_cred_init(%struct.ucred* %2) #5, !dbg !2399
  %3 = load %struct.ucred** %cr, align 8, !dbg !2400
  call void @mac_cred_init(%struct.ucred* %3) #5, !dbg !2400
  %4 = load %struct.ucred** %cr, align 8, !dbg !2401
  call void @crextend(%struct.ucred* %4, i32 16) #5, !dbg !2401
  %5 = load %struct.ucred** %cr, align 8, !dbg !2402
  ret %struct.ucred* %5, !dbg !2402
}

; Function Attrs: noimplicitfloat noredzone
declare %struct.uidinfo* @uifind(i32) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define %struct.ucred* @crcopysafe(%struct.proc* %p, %struct.ucred* %cr) #0 {
entry:
  %p.addr = alloca %struct.proc*, align 8
  %cr.addr = alloca %struct.ucred*, align 8
  %oldcred = alloca %struct.ucred*, align 8
  %groups = alloca i32, align 4
  store %struct.proc* %p, %struct.proc** %p.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p.addr}, metadata !2403), !dbg !2404
  store %struct.ucred* %cr, %struct.ucred** %cr.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %cr.addr}, metadata !2405), !dbg !2404
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %oldcred}, metadata !2406), !dbg !2407
  call void @llvm.dbg.declare(metadata !{i32* %groups}, metadata !2408), !dbg !2409
  %0 = load %struct.proc** %p.addr, align 8, !dbg !2410
  %p_mtx = getelementptr inbounds %struct.proc* %0, i32 0, i32 18, !dbg !2410
  %mtx_lock = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !2410
  call void @__mtx_assert(i64* %mtx_lock, i32 4, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 1961) #5, !dbg !2410
  %1 = load %struct.proc** %p.addr, align 8, !dbg !2411
  %p_ucred = getelementptr inbounds %struct.proc* %1, i32 0, i32 3, !dbg !2411
  %2 = load %struct.ucred** %p_ucred, align 8, !dbg !2411
  store %struct.ucred* %2, %struct.ucred** %oldcred, align 8, !dbg !2411
  br label %while.cond, !dbg !2412

while.cond:                                       ; preds = %while.body, %entry
  %3 = load %struct.ucred** %cr.addr, align 8, !dbg !2412
  %cr_agroups = getelementptr inbounds %struct.ucred* %3, i32 0, i32 16, !dbg !2412
  %4 = load i32* %cr_agroups, align 4, !dbg !2412
  %5 = load %struct.ucred** %oldcred, align 8, !dbg !2412
  %cr_agroups1 = getelementptr inbounds %struct.ucred* %5, i32 0, i32 16, !dbg !2412
  %6 = load i32* %cr_agroups1, align 4, !dbg !2412
  %cmp = icmp slt i32 %4, %6, !dbg !2412
  br i1 %cmp, label %while.body, label %while.end, !dbg !2412

while.body:                                       ; preds = %while.cond
  %7 = load %struct.ucred** %oldcred, align 8, !dbg !2413
  %cr_agroups2 = getelementptr inbounds %struct.ucred* %7, i32 0, i32 16, !dbg !2413
  %8 = load i32* %cr_agroups2, align 4, !dbg !2413
  store i32 %8, i32* %groups, align 4, !dbg !2413
  %9 = load %struct.proc** %p.addr, align 8, !dbg !2415
  %p_mtx3 = getelementptr inbounds %struct.proc* %9, i32 0, i32 18, !dbg !2415
  %mtx_lock4 = getelementptr inbounds %struct.mtx* %p_mtx3, i32 0, i32 1, !dbg !2415
  call void @__mtx_unlock_flags(i64* %mtx_lock4, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 1966) #5, !dbg !2415
  %10 = load %struct.ucred** %cr.addr, align 8, !dbg !2416
  %11 = load i32* %groups, align 4, !dbg !2416
  call void @crextend(%struct.ucred* %10, i32 %11) #5, !dbg !2416
  %12 = load %struct.proc** %p.addr, align 8, !dbg !2417
  %p_mtx5 = getelementptr inbounds %struct.proc* %12, i32 0, i32 18, !dbg !2417
  %mtx_lock6 = getelementptr inbounds %struct.mtx* %p_mtx5, i32 0, i32 1, !dbg !2417
  call void @__mtx_lock_flags(i64* %mtx_lock6, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 1968) #5, !dbg !2417
  %13 = load %struct.proc** %p.addr, align 8, !dbg !2418
  %p_ucred7 = getelementptr inbounds %struct.proc* %13, i32 0, i32 3, !dbg !2418
  %14 = load %struct.ucred** %p_ucred7, align 8, !dbg !2418
  store %struct.ucred* %14, %struct.ucred** %oldcred, align 8, !dbg !2418
  br label %while.cond, !dbg !2419

while.end:                                        ; preds = %while.cond
  %15 = load %struct.ucred** %cr.addr, align 8, !dbg !2420
  %16 = load %struct.ucred** %oldcred, align 8, !dbg !2420
  call void @crcopy(%struct.ucred* %15, %struct.ucred* %16) #5, !dbg !2420
  %17 = load %struct.ucred** %oldcred, align 8, !dbg !2421
  ret %struct.ucred* %17, !dbg !2421
}

; Function Attrs: noimplicitfloat noredzone
declare i32 @mac_cred_check_setuid(%struct.ucred*, i32) #2

; Function Attrs: noimplicitfloat noredzone
declare i32 @priv_check_cred(%struct.ucred*, i32, i32) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define void @change_ruid(%struct.ucred* %newcred, %struct.uidinfo* %ruip) #0 {
entry:
  %newcred.addr = alloca %struct.ucred*, align 8
  %ruip.addr = alloca %struct.uidinfo*, align 8
  %ruid = alloca i32, align 4
  store %struct.ucred* %newcred, %struct.ucred** %newcred.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %newcred.addr}, metadata !2422), !dbg !2423
  store %struct.uidinfo* %ruip, %struct.uidinfo** %ruip.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.uidinfo** %ruip.addr}, metadata !2424), !dbg !2423
  call void @llvm.dbg.declare(metadata !{i32* %ruid}, metadata !2425), !dbg !2426
  %0 = load %struct.uidinfo** %ruip.addr, align 8, !dbg !2426
  %ui_uid = getelementptr inbounds %struct.uidinfo* %0, i32 0, i32 6, !dbg !2426
  %1 = load i32* %ui_uid, align 4, !dbg !2426
  store i32 %1, i32* %ruid, align 4, !dbg !2426
  call void (i8*, i32, i32, %struct.__tesla_locality*, ...)* @__tesla_inline_assertion(i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 2206, i32 4, %struct.__tesla_locality* null, i32 0, i32 0, i32 1) #5, !dbg !2427
  call void (i8*, i32, i32, %struct.__tesla_locality*, ...)* @__tesla_inline_assertion(i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 2208, i32 5, %struct.__tesla_locality* null, i32 0, i32 0, i32 1) #5, !dbg !2428
  %2 = load %struct.ucred** %newcred.addr, align 8, !dbg !2429
  %cr_ruidinfo = getelementptr inbounds %struct.ucred* %2, i32 0, i32 8, !dbg !2429
  %3 = load %struct.uidinfo** %cr_ruidinfo, align 8, !dbg !2429
  %call = call i32 @chgproccnt(%struct.uidinfo* %3, i32 -1, i64 0) #5, !dbg !2429
  %4 = load i32* %ruid, align 4, !dbg !2430
  %5 = load %struct.ucred** %newcred.addr, align 8, !dbg !2430
  %cr_ruid = getelementptr inbounds %struct.ucred* %5, i32 0, i32 2, !dbg !2430
  store i32 %4, i32* %cr_ruid, align 4, !dbg !2430
  %6 = load %struct.uidinfo** %ruip.addr, align 8, !dbg !2431
  call void @uihold(%struct.uidinfo* %6) #5, !dbg !2431
  %7 = load %struct.ucred** %newcred.addr, align 8, !dbg !2432
  %cr_ruidinfo1 = getelementptr inbounds %struct.ucred* %7, i32 0, i32 8, !dbg !2432
  %8 = load %struct.uidinfo** %cr_ruidinfo1, align 8, !dbg !2432
  call void @uifree(%struct.uidinfo* %8) #5, !dbg !2432
  %9 = load %struct.uidinfo** %ruip.addr, align 8, !dbg !2433
  %10 = load %struct.ucred** %newcred.addr, align 8, !dbg !2433
  %cr_ruidinfo2 = getelementptr inbounds %struct.ucred* %10, i32 0, i32 8, !dbg !2433
  store %struct.uidinfo* %9, %struct.uidinfo** %cr_ruidinfo2, align 8, !dbg !2433
  %11 = load %struct.ucred** %newcred.addr, align 8, !dbg !2434
  %cr_ruidinfo3 = getelementptr inbounds %struct.ucred* %11, i32 0, i32 8, !dbg !2434
  %12 = load %struct.uidinfo** %cr_ruidinfo3, align 8, !dbg !2434
  %call4 = call i32 @chgproccnt(%struct.uidinfo* %12, i32 1, i64 0) #5, !dbg !2434
  ret void, !dbg !2435
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define void @setsugid(%struct.proc* %p) #0 {
entry:
  %p.addr = alloca %struct.proc*, align 8
  store %struct.proc* %p, %struct.proc** %p.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p.addr}, metadata !2436), !dbg !2437
  %0 = load %struct.proc** %p.addr, align 8, !dbg !2438
  %p_mtx = getelementptr inbounds %struct.proc* %0, i32 0, i32 18, !dbg !2438
  %mtx_lock = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !2438
  call void @__mtx_assert(i64* %mtx_lock, i32 4, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 2132) #5, !dbg !2438
  %1 = load %struct.proc** %p.addr, align 8, !dbg !2439
  %p_flag = getelementptr inbounds %struct.proc* %1, i32 0, i32 10, !dbg !2439
  %2 = load i32* %p_flag, align 4, !dbg !2439
  %or = or i32 %2, 256, !dbg !2439
  store i32 %or, i32* %p_flag, align 4, !dbg !2439
  %3 = load %struct.proc** %p.addr, align 8, !dbg !2440
  %p_pfsflags = getelementptr inbounds %struct.proc* %3, i32 0, i32 42, !dbg !2440
  %4 = load i8* %p_pfsflags, align 1, !dbg !2440
  %conv = zext i8 %4 to i32, !dbg !2440
  %and = and i32 %conv, 2, !dbg !2440
  %tobool = icmp ne i32 %and, 0, !dbg !2440
  br i1 %tobool, label %if.end, label %if.then, !dbg !2440

if.then:                                          ; preds = %entry
  %5 = load %struct.proc** %p.addr, align 8, !dbg !2441
  %p_stops = getelementptr inbounds %struct.proc* %5, i32 0, i32 39, !dbg !2441
  store i32 0, i32* %p_stops, align 4, !dbg !2441
  br label %if.end, !dbg !2441

if.end:                                           ; preds = %if.then, %entry
  ret void, !dbg !2442
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define void @change_svuid(%struct.ucred* %newcred, i32 %svuid) #0 {
entry:
  %newcred.addr = alloca %struct.ucred*, align 8
  %svuid.addr = alloca i32, align 4
  store %struct.ucred* %newcred, %struct.ucred** %newcred.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %newcred.addr}, metadata !2443), !dbg !2444
  store i32 %svuid, i32* %svuid.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %svuid.addr}, metadata !2445), !dbg !2444
  call void (i8*, i32, i32, %struct.__tesla_locality*, ...)* @__tesla_inline_assertion(i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 2255, i32 8, %struct.__tesla_locality* null, i32 0, i32 0, i32 1) #5, !dbg !2446
  call void (i8*, i32, i32, %struct.__tesla_locality*, ...)* @__tesla_inline_assertion(i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 2257, i32 9, %struct.__tesla_locality* null, i32 0, i32 0, i32 1) #5, !dbg !2447
  %0 = load i32* %svuid.addr, align 4, !dbg !2448
  %1 = load %struct.ucred** %newcred.addr, align 8, !dbg !2448
  %cr_svuid = getelementptr inbounds %struct.ucred* %1, i32 0, i32 3, !dbg !2448
  store i32 %0, i32* %cr_svuid, align 4, !dbg !2448
  ret void, !dbg !2449
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define void @change_euid(%struct.ucred* %newcred, %struct.uidinfo* %euip) #0 {
entry:
  %newcred.addr = alloca %struct.ucred*, align 8
  %euip.addr = alloca %struct.uidinfo*, align 8
  %euid = alloca i32, align 4
  store %struct.ucred* %newcred, %struct.ucred** %newcred.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %newcred.addr}, metadata !2450), !dbg !2451
  store %struct.uidinfo* %euip, %struct.uidinfo** %euip.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.uidinfo** %euip.addr}, metadata !2452), !dbg !2451
  call void @llvm.dbg.declare(metadata !{i32* %euid}, metadata !2453), !dbg !2454
  %0 = load %struct.uidinfo** %euip.addr, align 8, !dbg !2455
  %ui_uid = getelementptr inbounds %struct.uidinfo* %0, i32 0, i32 6, !dbg !2455
  %1 = load i32* %ui_uid, align 4, !dbg !2455
  store i32 %1, i32* %euid, align 4, !dbg !2455
  call void (i8*, i32, i32, %struct.__tesla_locality*, ...)* @__tesla_inline_assertion(i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 2156, i32 0, %struct.__tesla_locality* null, i32 0, i32 0, i32 1) #5, !dbg !2456
  call void (i8*, i32, i32, %struct.__tesla_locality*, ...)* @__tesla_inline_assertion(i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 2158, i32 1, %struct.__tesla_locality* null, i32 0, i32 0, i32 1) #5, !dbg !2457
  %2 = load i32* %euid, align 4, !dbg !2458
  %3 = load %struct.ucred** %newcred.addr, align 8, !dbg !2458
  %cr_uid = getelementptr inbounds %struct.ucred* %3, i32 0, i32 1, !dbg !2458
  store i32 %2, i32* %cr_uid, align 4, !dbg !2458
  %4 = load %struct.uidinfo** %euip.addr, align 8, !dbg !2459
  call void @uihold(%struct.uidinfo* %4) #5, !dbg !2459
  %5 = load %struct.ucred** %newcred.addr, align 8, !dbg !2460
  %cr_uidinfo = getelementptr inbounds %struct.ucred* %5, i32 0, i32 7, !dbg !2460
  %6 = load %struct.uidinfo** %cr_uidinfo, align 8, !dbg !2460
  call void @uifree(%struct.uidinfo* %6) #5, !dbg !2460
  %7 = load %struct.uidinfo** %euip.addr, align 8, !dbg !2461
  %8 = load %struct.ucred** %newcred.addr, align 8, !dbg !2461
  %cr_uidinfo1 = getelementptr inbounds %struct.ucred* %8, i32 0, i32 7, !dbg !2461
  store %struct.uidinfo* %7, %struct.uidinfo** %cr_uidinfo1, align 8, !dbg !2461
  ret void, !dbg !2462
}

; Function Attrs: noimplicitfloat noredzone
declare void @uifree(%struct.uidinfo*) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define void @crfree(%struct.ucred* %cr) #0 {
entry:
  %cr.addr = alloca %struct.ucred*, align 8
  store %struct.ucred* %cr, %struct.ucred** %cr.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %cr.addr}, metadata !2463), !dbg !2464
  br label %do.body, !dbg !2465

do.body:                                          ; preds = %entry
  %0 = load %struct.ucred** %cr.addr, align 8, !dbg !2466
  %cr_ref = getelementptr inbounds %struct.ucred* %0, i32 0, i32 0, !dbg !2466
  %1 = load i32* %cr_ref, align 4, !dbg !2466
  %cmp = icmp ugt i32 %1, 0, !dbg !2466
  %lnot = xor i1 %cmp, true, !dbg !2466
  %lnot.ext = zext i1 %lnot to i32, !dbg !2466
  %conv = sext i32 %lnot.ext to i64, !dbg !2466
  %expval = call i64 @llvm.expect.i64(i64 %conv, i64 0), !dbg !2466
  %tobool = icmp ne i64 %expval, 0, !dbg !2466
  br i1 %tobool, label %if.then, label %if.end, !dbg !2466

if.then:                                          ; preds = %do.body
  %2 = load %struct.ucred** %cr.addr, align 8, !dbg !2466
  %cr_ref1 = getelementptr inbounds %struct.ucred* %2, i32 0, i32 0, !dbg !2466
  %3 = load i32* %cr_ref1, align 4, !dbg !2466
  call void (i8*, ...)* @kassert_panic(i8* getelementptr inbounds ([23 x i8]* @.str3, i32 0, i32 0), i32 %3) #5, !dbg !2466
  br label %if.end, !dbg !2466

if.end:                                           ; preds = %if.then, %do.body
  br label %do.end, !dbg !2466

do.end:                                           ; preds = %if.end
  br label %do.body2, !dbg !2468

do.body2:                                         ; preds = %do.end
  %4 = load %struct.ucred** %cr.addr, align 8, !dbg !2469
  %cr_ref3 = getelementptr inbounds %struct.ucred* %4, i32 0, i32 0, !dbg !2469
  %5 = load i32* %cr_ref3, align 4, !dbg !2469
  %cmp4 = icmp ne i32 %5, -559038242, !dbg !2469
  %lnot6 = xor i1 %cmp4, true, !dbg !2469
  %lnot.ext7 = zext i1 %lnot6 to i32, !dbg !2469
  %conv8 = sext i32 %lnot.ext7 to i64, !dbg !2469
  %expval9 = call i64 @llvm.expect.i64(i64 %conv8, i64 0), !dbg !2469
  %tobool10 = icmp ne i64 %expval9, 0, !dbg !2469
  br i1 %tobool10, label %if.then11, label %if.end12, !dbg !2469

if.then11:                                        ; preds = %do.body2
  call void (i8*, ...)* @kassert_panic(i8* getelementptr inbounds ([28 x i8]* @.str4, i32 0, i32 0)) #5, !dbg !2469
  br label %if.end12, !dbg !2469

if.end12:                                         ; preds = %if.then11, %do.body2
  br label %do.end13, !dbg !2469

do.end13:                                         ; preds = %if.end12
  %6 = load %struct.ucred** %cr.addr, align 8, !dbg !2471
  %cr_ref14 = getelementptr inbounds %struct.ucred* %6, i32 0, i32 0, !dbg !2471
  %call = call i32 @refcount_release(i32* %cr_ref14) #5, !dbg !2471
  %tobool15 = icmp ne i32 %call, 0, !dbg !2471
  br i1 %tobool15, label %if.then16, label %if.end37, !dbg !2471

if.then16:                                        ; preds = %do.end13
  %7 = load %struct.ucred** %cr.addr, align 8, !dbg !2472
  %cr_uidinfo = getelementptr inbounds %struct.ucred* %7, i32 0, i32 7, !dbg !2472
  %8 = load %struct.uidinfo** %cr_uidinfo, align 8, !dbg !2472
  %cmp17 = icmp ne %struct.uidinfo* %8, null, !dbg !2472
  br i1 %cmp17, label %if.then19, label %if.end21, !dbg !2472

if.then19:                                        ; preds = %if.then16
  %9 = load %struct.ucred** %cr.addr, align 8, !dbg !2474
  %cr_uidinfo20 = getelementptr inbounds %struct.ucred* %9, i32 0, i32 7, !dbg !2474
  %10 = load %struct.uidinfo** %cr_uidinfo20, align 8, !dbg !2474
  call void @uifree(%struct.uidinfo* %10) #5, !dbg !2474
  br label %if.end21, !dbg !2474

if.end21:                                         ; preds = %if.then19, %if.then16
  %11 = load %struct.ucred** %cr.addr, align 8, !dbg !2475
  %cr_ruidinfo = getelementptr inbounds %struct.ucred* %11, i32 0, i32 8, !dbg !2475
  %12 = load %struct.uidinfo** %cr_ruidinfo, align 8, !dbg !2475
  %cmp22 = icmp ne %struct.uidinfo* %12, null, !dbg !2475
  br i1 %cmp22, label %if.then24, label %if.end26, !dbg !2475

if.then24:                                        ; preds = %if.end21
  %13 = load %struct.ucred** %cr.addr, align 8, !dbg !2476
  %cr_ruidinfo25 = getelementptr inbounds %struct.ucred* %13, i32 0, i32 8, !dbg !2476
  %14 = load %struct.uidinfo** %cr_ruidinfo25, align 8, !dbg !2476
  call void @uifree(%struct.uidinfo* %14) #5, !dbg !2476
  br label %if.end26, !dbg !2476

if.end26:                                         ; preds = %if.then24, %if.end21
  %15 = load %struct.ucred** %cr.addr, align 8, !dbg !2477
  %cr_prison = getelementptr inbounds %struct.ucred* %15, i32 0, i32 9, !dbg !2477
  %16 = load %struct.prison** %cr_prison, align 8, !dbg !2477
  %cmp27 = icmp ne %struct.prison* %16, null, !dbg !2477
  br i1 %cmp27, label %if.then29, label %if.end31, !dbg !2477

if.then29:                                        ; preds = %if.end26
  %17 = load %struct.ucred** %cr.addr, align 8, !dbg !2478
  %cr_prison30 = getelementptr inbounds %struct.ucred* %17, i32 0, i32 9, !dbg !2478
  %18 = load %struct.prison** %cr_prison30, align 8, !dbg !2478
  call void @prison_free(%struct.prison* %18) #5, !dbg !2478
  br label %if.end31, !dbg !2478

if.end31:                                         ; preds = %if.then29, %if.end26
  %19 = load %struct.ucred** %cr.addr, align 8, !dbg !2479
  %cr_loginclass = getelementptr inbounds %struct.ucred* %19, i32 0, i32 10, !dbg !2479
  %20 = load %struct.loginclass** %cr_loginclass, align 8, !dbg !2479
  %cmp32 = icmp ne %struct.loginclass* %20, null, !dbg !2479
  br i1 %cmp32, label %if.then34, label %if.end36, !dbg !2479

if.then34:                                        ; preds = %if.end31
  %21 = load %struct.ucred** %cr.addr, align 8, !dbg !2480
  %cr_loginclass35 = getelementptr inbounds %struct.ucred* %21, i32 0, i32 10, !dbg !2480
  %22 = load %struct.loginclass** %cr_loginclass35, align 8, !dbg !2480
  call void @loginclass_free(%struct.loginclass* %22) #5, !dbg !2480
  br label %if.end36, !dbg !2480

if.end36:                                         ; preds = %if.then34, %if.end31
  %23 = load %struct.ucred** %cr.addr, align 8, !dbg !2481
  call void @audit_cred_destroy(%struct.ucred* %23) #5, !dbg !2481
  %24 = load %struct.ucred** %cr.addr, align 8, !dbg !2482
  call void @mac_cred_destroy(%struct.ucred* %24) #5, !dbg !2482
  %25 = load %struct.ucred** %cr.addr, align 8, !dbg !2483
  %cr_groups = getelementptr inbounds %struct.ucred* %25, i32 0, i32 15, !dbg !2483
  %26 = load i32** %cr_groups, align 8, !dbg !2483
  %27 = bitcast i32* %26 to i8*, !dbg !2483
  call void @free(i8* %27, %struct.malloc_type* getelementptr inbounds ([1 x %struct.malloc_type]* @M_CRED, i32 0, i32 0)) #5, !dbg !2483
  %28 = load %struct.ucred** %cr.addr, align 8, !dbg !2484
  %29 = bitcast %struct.ucred* %28 to i8*, !dbg !2484
  call void @free(i8* %29, %struct.malloc_type* getelementptr inbounds ([1 x %struct.malloc_type]* @M_CRED, i32 0, i32 0)) #5, !dbg !2484
  br label %if.end37, !dbg !2485

if.end37:                                         ; preds = %if.end36, %do.end13
  ret void, !dbg !2486
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys_seteuid(%struct.thread* %td, %struct.seteuid_args* %uap) #0 {
entry:
  %retval = alloca i32, align 4
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.seteuid_args*, align 8
  %p = alloca %struct.proc*, align 8
  %newcred = alloca %struct.ucred*, align 8
  %oldcred = alloca %struct.ucred*, align 8
  %euid = alloca i32, align 4
  %euip = alloca %struct.uidinfo*, align 8
  %error = alloca i32, align 4
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !2487), !dbg !2488
  store %struct.seteuid_args* %uap, %struct.seteuid_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.seteuid_args** %uap.addr}, metadata !2489), !dbg !2488
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p}, metadata !2490), !dbg !2491
  %0 = load %struct.thread** %td.addr, align 8, !dbg !2491
  %td_proc = getelementptr inbounds %struct.thread* %0, i32 0, i32 1, !dbg !2491
  %1 = load %struct.proc** %td_proc, align 8, !dbg !2491
  store %struct.proc* %1, %struct.proc** %p, align 8, !dbg !2491
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %newcred}, metadata !2492), !dbg !2493
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %oldcred}, metadata !2494), !dbg !2493
  call void @llvm.dbg.declare(metadata !{i32* %euid}, metadata !2495), !dbg !2496
  call void @llvm.dbg.declare(metadata !{%struct.uidinfo** %euip}, metadata !2497), !dbg !2498
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !2499), !dbg !2500
  %2 = load %struct.seteuid_args** %uap.addr, align 8, !dbg !2501
  %euid1 = getelementptr inbounds %struct.seteuid_args* %2, i32 0, i32 1, !dbg !2501
  %3 = load i32* %euid1, align 4, !dbg !2501
  store i32 %3, i32* %euid, align 4, !dbg !2501
  br label %do.body, !dbg !2502

do.body:                                          ; preds = %entry
  %call = call %struct.thread* @__curthread() #6, !dbg !2503
  %td_pflags = getelementptr inbounds %struct.thread* %call, i32 0, i32 18, !dbg !2503
  %4 = load i32* %td_pflags, align 4, !dbg !2503
  %and = and i32 %4, 16777216, !dbg !2503
  %tobool = icmp ne i32 %and, 0, !dbg !2503
  br i1 %tobool, label %if.then, label %if.end, !dbg !2503

if.then:                                          ; preds = %do.body
  %5 = load i32* %euid, align 4, !dbg !2503
  call void @audit_arg_euid(i32 %5) #5, !dbg !2503
  br label %if.end, !dbg !2503

if.end:                                           ; preds = %if.then, %do.body
  br label %do.end, !dbg !2503

do.end:                                           ; preds = %if.end
  %call2 = call %struct.ucred* @crget() #5, !dbg !2505
  store %struct.ucred* %call2, %struct.ucred** %newcred, align 8, !dbg !2505
  %6 = load i32* %euid, align 4, !dbg !2506
  %call3 = call %struct.uidinfo* @uifind(i32 %6) #5, !dbg !2506
  store %struct.uidinfo* %call3, %struct.uidinfo** %euip, align 8, !dbg !2506
  %7 = load %struct.proc** %p, align 8, !dbg !2507
  %p_mtx = getelementptr inbounds %struct.proc* %7, i32 0, i32 18, !dbg !2507
  %mtx_lock = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !2507
  call void @__mtx_lock_flags(i64* %mtx_lock, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 623) #5, !dbg !2507
  %8 = load %struct.proc** %p, align 8, !dbg !2508
  %9 = load %struct.ucred** %newcred, align 8, !dbg !2508
  %call4 = call %struct.ucred* @crcopysafe(%struct.proc* %8, %struct.ucred* %9) #5, !dbg !2508
  store %struct.ucred* %call4, %struct.ucred** %oldcred, align 8, !dbg !2508
  %10 = load %struct.ucred** %oldcred, align 8, !dbg !2509
  %11 = load i32* %euid, align 4, !dbg !2509
  %call5 = call i32 @mac_cred_check_seteuid(%struct.ucred* %10, i32 %11) #5, !dbg !2509
  store i32 %call5, i32* %error, align 4, !dbg !2509
  %12 = load i32* %error, align 4, !dbg !2510
  %tobool6 = icmp ne i32 %12, 0, !dbg !2510
  br i1 %tobool6, label %if.then7, label %if.end8, !dbg !2510

if.then7:                                         ; preds = %do.end
  br label %fail, !dbg !2511

if.end8:                                          ; preds = %do.end
  %13 = load i32* %euid, align 4, !dbg !2512
  %14 = load %struct.ucred** %oldcred, align 8, !dbg !2512
  %cr_ruid = getelementptr inbounds %struct.ucred* %14, i32 0, i32 2, !dbg !2512
  %15 = load i32* %cr_ruid, align 4, !dbg !2512
  %cmp = icmp ne i32 %13, %15, !dbg !2512
  br i1 %cmp, label %land.lhs.true, label %if.end14, !dbg !2512

land.lhs.true:                                    ; preds = %if.end8
  %16 = load i32* %euid, align 4, !dbg !2512
  %17 = load %struct.ucred** %oldcred, align 8, !dbg !2512
  %cr_svuid = getelementptr inbounds %struct.ucred* %17, i32 0, i32 3, !dbg !2512
  %18 = load i32* %cr_svuid, align 4, !dbg !2512
  %cmp9 = icmp ne i32 %16, %18, !dbg !2512
  br i1 %cmp9, label %land.lhs.true10, label %if.end14, !dbg !2512

land.lhs.true10:                                  ; preds = %land.lhs.true
  %19 = load %struct.ucred** %oldcred, align 8, !dbg !2513
  %call11 = call i32 @priv_check_cred(%struct.ucred* %19, i32 51, i32 0) #5, !dbg !2513
  store i32 %call11, i32* %error, align 4, !dbg !2513
  %cmp12 = icmp ne i32 %call11, 0, !dbg !2513
  br i1 %cmp12, label %if.then13, label %if.end14, !dbg !2513

if.then13:                                        ; preds = %land.lhs.true10
  br label %fail, !dbg !2514

if.end14:                                         ; preds = %land.lhs.true10, %land.lhs.true, %if.end8
  %20 = load %struct.ucred** %oldcred, align 8, !dbg !2515
  %cr_uid = getelementptr inbounds %struct.ucred* %20, i32 0, i32 1, !dbg !2515
  %21 = load i32* %cr_uid, align 4, !dbg !2515
  %22 = load i32* %euid, align 4, !dbg !2515
  %cmp15 = icmp ne i32 %21, %22, !dbg !2515
  br i1 %cmp15, label %if.then16, label %if.end17, !dbg !2515

if.then16:                                        ; preds = %if.end14
  %23 = load %struct.ucred** %newcred, align 8, !dbg !2516
  %24 = load %struct.uidinfo** %euip, align 8, !dbg !2516
  call void @change_euid(%struct.ucred* %23, %struct.uidinfo* %24) #5, !dbg !2516
  %25 = load %struct.proc** %p, align 8, !dbg !2518
  call void @setsugid(%struct.proc* %25) #5, !dbg !2518
  br label %if.end17, !dbg !2519

if.end17:                                         ; preds = %if.then16, %if.end14
  %26 = load %struct.ucred** %newcred, align 8, !dbg !2520
  %27 = load %struct.proc** %p, align 8, !dbg !2520
  %p_ucred = getelementptr inbounds %struct.proc* %27, i32 0, i32 3, !dbg !2520
  store %struct.ucred* %26, %struct.ucred** %p_ucred, align 8, !dbg !2520
  %28 = load %struct.proc** %p, align 8, !dbg !2521
  %p_mtx18 = getelementptr inbounds %struct.proc* %28, i32 0, i32 18, !dbg !2521
  %mtx_lock19 = getelementptr inbounds %struct.mtx* %p_mtx18, i32 0, i32 1, !dbg !2521
  call void @__mtx_unlock_flags(i64* %mtx_lock19, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 648) #5, !dbg !2521
  %29 = load %struct.uidinfo** %euip, align 8, !dbg !2522
  call void @uifree(%struct.uidinfo* %29) #5, !dbg !2522
  %30 = load %struct.ucred** %oldcred, align 8, !dbg !2523
  call void @crfree(%struct.ucred* %30) #5, !dbg !2523
  store i32 0, i32* %retval, !dbg !2524
  br label %return, !dbg !2524

fail:                                             ; preds = %if.then13, %if.then7
  %31 = load %struct.proc** %p, align 8, !dbg !2525
  %p_mtx20 = getelementptr inbounds %struct.proc* %31, i32 0, i32 18, !dbg !2525
  %mtx_lock21 = getelementptr inbounds %struct.mtx* %p_mtx20, i32 0, i32 1, !dbg !2525
  call void @__mtx_unlock_flags(i64* %mtx_lock21, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 654) #5, !dbg !2525
  %32 = load %struct.uidinfo** %euip, align 8, !dbg !2526
  call void @uifree(%struct.uidinfo* %32) #5, !dbg !2526
  %33 = load %struct.ucred** %newcred, align 8, !dbg !2527
  call void @crfree(%struct.ucred* %33) #5, !dbg !2527
  %34 = load i32* %error, align 4, !dbg !2528
  store i32 %34, i32* %retval, !dbg !2528
  br label %return, !dbg !2528

return:                                           ; preds = %fail, %if.end17
  %35 = load i32* %retval, !dbg !2529
  ret i32 %35, !dbg !2529
}

; Function Attrs: noimplicitfloat noredzone
declare void @audit_arg_euid(i32) #2

; Function Attrs: noimplicitfloat noredzone
declare i32 @mac_cred_check_seteuid(%struct.ucred*, i32) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys_setgid(%struct.thread* %td, %struct.setgid_args* %uap) #0 {
entry:
  %retval = alloca i32, align 4
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.setgid_args*, align 8
  %p = alloca %struct.proc*, align 8
  %newcred = alloca %struct.ucred*, align 8
  %oldcred = alloca %struct.ucred*, align 8
  %gid = alloca i32, align 4
  %error = alloca i32, align 4
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !2530), !dbg !2531
  store %struct.setgid_args* %uap, %struct.setgid_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.setgid_args** %uap.addr}, metadata !2532), !dbg !2531
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p}, metadata !2533), !dbg !2534
  %0 = load %struct.thread** %td.addr, align 8, !dbg !2534
  %td_proc = getelementptr inbounds %struct.thread* %0, i32 0, i32 1, !dbg !2534
  %1 = load %struct.proc** %td_proc, align 8, !dbg !2534
  store %struct.proc* %1, %struct.proc** %p, align 8, !dbg !2534
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %newcred}, metadata !2535), !dbg !2536
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %oldcred}, metadata !2537), !dbg !2536
  call void @llvm.dbg.declare(metadata !{i32* %gid}, metadata !2538), !dbg !2539
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !2540), !dbg !2541
  %2 = load %struct.setgid_args** %uap.addr, align 8, !dbg !2542
  %gid1 = getelementptr inbounds %struct.setgid_args* %2, i32 0, i32 1, !dbg !2542
  %3 = load i32* %gid1, align 4, !dbg !2542
  store i32 %3, i32* %gid, align 4, !dbg !2542
  br label %do.body, !dbg !2543

do.body:                                          ; preds = %entry
  %call = call %struct.thread* @__curthread() #6, !dbg !2544
  %td_pflags = getelementptr inbounds %struct.thread* %call, i32 0, i32 18, !dbg !2544
  %4 = load i32* %td_pflags, align 4, !dbg !2544
  %and = and i32 %4, 16777216, !dbg !2544
  %tobool = icmp ne i32 %and, 0, !dbg !2544
  br i1 %tobool, label %if.then, label %if.end, !dbg !2544

if.then:                                          ; preds = %do.body
  %5 = load i32* %gid, align 4, !dbg !2544
  call void @audit_arg_gid(i32 %5) #5, !dbg !2544
  br label %if.end, !dbg !2544

if.end:                                           ; preds = %if.then, %do.body
  br label %do.end, !dbg !2544

do.end:                                           ; preds = %if.end
  %call2 = call %struct.ucred* @crget() #5, !dbg !2546
  store %struct.ucred* %call2, %struct.ucred** %newcred, align 8, !dbg !2546
  %6 = load %struct.proc** %p, align 8, !dbg !2547
  %p_mtx = getelementptr inbounds %struct.proc* %6, i32 0, i32 18, !dbg !2547
  %mtx_lock = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !2547
  call void @__mtx_lock_flags(i64* %mtx_lock, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 677) #5, !dbg !2547
  %7 = load %struct.proc** %p, align 8, !dbg !2548
  %8 = load %struct.ucred** %newcred, align 8, !dbg !2548
  %call3 = call %struct.ucred* @crcopysafe(%struct.proc* %7, %struct.ucred* %8) #5, !dbg !2548
  store %struct.ucred* %call3, %struct.ucred** %oldcred, align 8, !dbg !2548
  %9 = load %struct.ucred** %oldcred, align 8, !dbg !2549
  %10 = load i32* %gid, align 4, !dbg !2549
  %call4 = call i32 @mac_cred_check_setgid(%struct.ucred* %9, i32 %10) #5, !dbg !2549
  store i32 %call4, i32* %error, align 4, !dbg !2549
  %11 = load i32* %error, align 4, !dbg !2550
  %tobool5 = icmp ne i32 %11, 0, !dbg !2550
  br i1 %tobool5, label %if.then6, label %if.end7, !dbg !2550

if.then6:                                         ; preds = %do.end
  br label %fail, !dbg !2551

if.end7:                                          ; preds = %do.end
  %12 = load i32* %gid, align 4, !dbg !2552
  %13 = load %struct.ucred** %oldcred, align 8, !dbg !2552
  %cr_rgid = getelementptr inbounds %struct.ucred* %13, i32 0, i32 5, !dbg !2552
  %14 = load i32* %cr_rgid, align 4, !dbg !2552
  %cmp = icmp ne i32 %12, %14, !dbg !2552
  br i1 %cmp, label %land.lhs.true, label %if.end13, !dbg !2552

land.lhs.true:                                    ; preds = %if.end7
  %15 = load i32* %gid, align 4, !dbg !2552
  %16 = load %struct.ucred** %oldcred, align 8, !dbg !2552
  %cr_groups = getelementptr inbounds %struct.ucred* %16, i32 0, i32 15, !dbg !2552
  %17 = load i32** %cr_groups, align 8, !dbg !2552
  %arrayidx = getelementptr inbounds i32* %17, i64 0, !dbg !2552
  %18 = load i32* %arrayidx, align 4, !dbg !2552
  %cmp8 = icmp ne i32 %15, %18, !dbg !2552
  br i1 %cmp8, label %land.lhs.true9, label %if.end13, !dbg !2552

land.lhs.true9:                                   ; preds = %land.lhs.true
  %19 = load %struct.ucred** %oldcred, align 8, !dbg !2553
  %call10 = call i32 @priv_check_cred(%struct.ucred* %19, i32 52, i32 0) #5, !dbg !2553
  store i32 %call10, i32* %error, align 4, !dbg !2553
  %cmp11 = icmp ne i32 %call10, 0, !dbg !2553
  br i1 %cmp11, label %if.then12, label %if.end13, !dbg !2553

if.then12:                                        ; preds = %land.lhs.true9
  br label %fail, !dbg !2554

if.end13:                                         ; preds = %land.lhs.true9, %land.lhs.true, %if.end7
  %20 = load %struct.ucred** %oldcred, align 8, !dbg !2555
  %cr_rgid14 = getelementptr inbounds %struct.ucred* %20, i32 0, i32 5, !dbg !2555
  %21 = load i32* %cr_rgid14, align 4, !dbg !2555
  %22 = load i32* %gid, align 4, !dbg !2555
  %cmp15 = icmp ne i32 %21, %22, !dbg !2555
  br i1 %cmp15, label %if.then16, label %if.end17, !dbg !2555

if.then16:                                        ; preds = %if.end13
  %23 = load %struct.ucred** %newcred, align 8, !dbg !2557
  %24 = load i32* %gid, align 4, !dbg !2557
  call void @change_rgid(%struct.ucred* %23, i32 %24) #5, !dbg !2557
  %25 = load %struct.proc** %p, align 8, !dbg !2559
  call void @setsugid(%struct.proc* %25) #5, !dbg !2559
  br label %if.end17, !dbg !2560

if.end17:                                         ; preds = %if.then16, %if.end13
  %26 = load %struct.ucred** %oldcred, align 8, !dbg !2561
  %cr_svgid = getelementptr inbounds %struct.ucred* %26, i32 0, i32 6, !dbg !2561
  %27 = load i32* %cr_svgid, align 4, !dbg !2561
  %28 = load i32* %gid, align 4, !dbg !2561
  %cmp18 = icmp ne i32 %27, %28, !dbg !2561
  br i1 %cmp18, label %if.then19, label %if.end20, !dbg !2561

if.then19:                                        ; preds = %if.end17
  %29 = load %struct.ucred** %newcred, align 8, !dbg !2562
  %30 = load i32* %gid, align 4, !dbg !2562
  call void @change_svgid(%struct.ucred* %29, i32 %30) #5, !dbg !2562
  %31 = load %struct.proc** %p, align 8, !dbg !2564
  call void @setsugid(%struct.proc* %31) #5, !dbg !2564
  br label %if.end20, !dbg !2565

if.end20:                                         ; preds = %if.then19, %if.end17
  %32 = load %struct.ucred** %oldcred, align 8, !dbg !2566
  %cr_groups21 = getelementptr inbounds %struct.ucred* %32, i32 0, i32 15, !dbg !2566
  %33 = load i32** %cr_groups21, align 8, !dbg !2566
  %arrayidx22 = getelementptr inbounds i32* %33, i64 0, !dbg !2566
  %34 = load i32* %arrayidx22, align 4, !dbg !2566
  %35 = load i32* %gid, align 4, !dbg !2566
  %cmp23 = icmp ne i32 %34, %35, !dbg !2566
  br i1 %cmp23, label %if.then24, label %if.end25, !dbg !2566

if.then24:                                        ; preds = %if.end20
  %36 = load %struct.ucred** %newcred, align 8, !dbg !2567
  %37 = load i32* %gid, align 4, !dbg !2567
  call void @change_egid(%struct.ucred* %36, i32 %37) #5, !dbg !2567
  %38 = load %struct.proc** %p, align 8, !dbg !2569
  call void @setsugid(%struct.proc* %38) #5, !dbg !2569
  br label %if.end25, !dbg !2570

if.end25:                                         ; preds = %if.then24, %if.end20
  %39 = load %struct.ucred** %newcred, align 8, !dbg !2571
  %40 = load %struct.proc** %p, align 8, !dbg !2571
  %p_ucred = getelementptr inbounds %struct.proc* %40, i32 0, i32 3, !dbg !2571
  store %struct.ucred* %39, %struct.ucred** %p_ucred, align 8, !dbg !2571
  %41 = load %struct.proc** %p, align 8, !dbg !2572
  %p_mtx26 = getelementptr inbounds %struct.proc* %41, i32 0, i32 18, !dbg !2572
  %mtx_lock27 = getelementptr inbounds %struct.mtx* %p_mtx26, i32 0, i32 1, !dbg !2572
  call void @__mtx_unlock_flags(i64* %mtx_lock27, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 748) #5, !dbg !2572
  %42 = load %struct.ucred** %oldcred, align 8, !dbg !2573
  call void @crfree(%struct.ucred* %42) #5, !dbg !2573
  store i32 0, i32* %retval, !dbg !2574
  br label %return, !dbg !2574

fail:                                             ; preds = %if.then12, %if.then6
  %43 = load %struct.proc** %p, align 8, !dbg !2575
  %p_mtx28 = getelementptr inbounds %struct.proc* %43, i32 0, i32 18, !dbg !2575
  %mtx_lock29 = getelementptr inbounds %struct.mtx* %p_mtx28, i32 0, i32 1, !dbg !2575
  call void @__mtx_unlock_flags(i64* %mtx_lock29, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 753) #5, !dbg !2575
  %44 = load %struct.ucred** %newcred, align 8, !dbg !2576
  call void @crfree(%struct.ucred* %44) #5, !dbg !2576
  %45 = load i32* %error, align 4, !dbg !2577
  store i32 %45, i32* %retval, !dbg !2577
  br label %return, !dbg !2577

return:                                           ; preds = %fail, %if.end25
  %46 = load i32* %retval, !dbg !2578
  ret i32 %46, !dbg !2578
}

; Function Attrs: noimplicitfloat noredzone
declare void @audit_arg_gid(i32) #2

; Function Attrs: noimplicitfloat noredzone
declare i32 @mac_cred_check_setgid(%struct.ucred*, i32) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define void @change_rgid(%struct.ucred* %newcred, i32 %rgid) #0 {
entry:
  %newcred.addr = alloca %struct.ucred*, align 8
  %rgid.addr = alloca i32, align 4
  store %struct.ucred* %newcred, %struct.ucred** %newcred.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %newcred.addr}, metadata !2579), !dbg !2580
  store i32 %rgid, i32* %rgid.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %rgid.addr}, metadata !2581), !dbg !2580
  call void (i8*, i32, i32, %struct.__tesla_locality*, ...)* @__tesla_inline_assertion(i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 2233, i32 6, %struct.__tesla_locality* null, i32 0, i32 0, i32 1) #5, !dbg !2582
  call void (i8*, i32, i32, %struct.__tesla_locality*, ...)* @__tesla_inline_assertion(i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 2235, i32 7, %struct.__tesla_locality* null, i32 0, i32 0, i32 1) #5, !dbg !2583
  %0 = load i32* %rgid.addr, align 4, !dbg !2584
  %1 = load %struct.ucred** %newcred.addr, align 8, !dbg !2584
  %cr_rgid = getelementptr inbounds %struct.ucred* %1, i32 0, i32 5, !dbg !2584
  store i32 %0, i32* %cr_rgid, align 4, !dbg !2584
  ret void, !dbg !2585
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define void @change_svgid(%struct.ucred* %newcred, i32 %svgid) #0 {
entry:
  %newcred.addr = alloca %struct.ucred*, align 8
  %svgid.addr = alloca i32, align 4
  store %struct.ucred* %newcred, %struct.ucred** %newcred.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %newcred.addr}, metadata !2586), !dbg !2587
  store i32 %svgid, i32* %svgid.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %svgid.addr}, metadata !2588), !dbg !2587
  call void (i8*, i32, i32, %struct.__tesla_locality*, ...)* @__tesla_inline_assertion(i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 2277, i32 10, %struct.__tesla_locality* null, i32 0, i32 0, i32 1) #5, !dbg !2589
  call void (i8*, i32, i32, %struct.__tesla_locality*, ...)* @__tesla_inline_assertion(i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 2279, i32 11, %struct.__tesla_locality* null, i32 0, i32 0, i32 1) #5, !dbg !2590
  %0 = load i32* %svgid.addr, align 4, !dbg !2591
  %1 = load %struct.ucred** %newcred.addr, align 8, !dbg !2591
  %cr_svgid = getelementptr inbounds %struct.ucred* %1, i32 0, i32 6, !dbg !2591
  store i32 %0, i32* %cr_svgid, align 4, !dbg !2591
  ret void, !dbg !2592
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define void @change_egid(%struct.ucred* %newcred, i32 %egid) #0 {
entry:
  %newcred.addr = alloca %struct.ucred*, align 8
  %egid.addr = alloca i32, align 4
  store %struct.ucred* %newcred, %struct.ucred** %newcred.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %newcred.addr}, metadata !2593), !dbg !2594
  store i32 %egid, i32* %egid.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %egid.addr}, metadata !2595), !dbg !2594
  call void (i8*, i32, i32, %struct.__tesla_locality*, ...)* @__tesla_inline_assertion(i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 2181, i32 2, %struct.__tesla_locality* null, i32 0, i32 0, i32 1) #5, !dbg !2596
  call void (i8*, i32, i32, %struct.__tesla_locality*, ...)* @__tesla_inline_assertion(i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 2183, i32 3, %struct.__tesla_locality* null, i32 0, i32 0, i32 1) #5, !dbg !2597
  %0 = load i32* %egid.addr, align 4, !dbg !2598
  %1 = load %struct.ucred** %newcred.addr, align 8, !dbg !2598
  %cr_groups = getelementptr inbounds %struct.ucred* %1, i32 0, i32 15, !dbg !2598
  %2 = load i32** %cr_groups, align 8, !dbg !2598
  %arrayidx = getelementptr inbounds i32* %2, i64 0, !dbg !2598
  store i32 %0, i32* %arrayidx, align 4, !dbg !2598
  ret void, !dbg !2599
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys_setegid(%struct.thread* %td, %struct.setegid_args* %uap) #0 {
entry:
  %retval = alloca i32, align 4
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.setegid_args*, align 8
  %p = alloca %struct.proc*, align 8
  %newcred = alloca %struct.ucred*, align 8
  %oldcred = alloca %struct.ucred*, align 8
  %egid = alloca i32, align 4
  %error = alloca i32, align 4
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !2600), !dbg !2601
  store %struct.setegid_args* %uap, %struct.setegid_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.setegid_args** %uap.addr}, metadata !2602), !dbg !2601
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p}, metadata !2603), !dbg !2604
  %0 = load %struct.thread** %td.addr, align 8, !dbg !2604
  %td_proc = getelementptr inbounds %struct.thread* %0, i32 0, i32 1, !dbg !2604
  %1 = load %struct.proc** %td_proc, align 8, !dbg !2604
  store %struct.proc* %1, %struct.proc** %p, align 8, !dbg !2604
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %newcred}, metadata !2605), !dbg !2606
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %oldcred}, metadata !2607), !dbg !2606
  call void @llvm.dbg.declare(metadata !{i32* %egid}, metadata !2608), !dbg !2609
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !2610), !dbg !2611
  %2 = load %struct.setegid_args** %uap.addr, align 8, !dbg !2612
  %egid1 = getelementptr inbounds %struct.setegid_args* %2, i32 0, i32 1, !dbg !2612
  %3 = load i32* %egid1, align 4, !dbg !2612
  store i32 %3, i32* %egid, align 4, !dbg !2612
  br label %do.body, !dbg !2613

do.body:                                          ; preds = %entry
  %call = call %struct.thread* @__curthread() #6, !dbg !2614
  %td_pflags = getelementptr inbounds %struct.thread* %call, i32 0, i32 18, !dbg !2614
  %4 = load i32* %td_pflags, align 4, !dbg !2614
  %and = and i32 %4, 16777216, !dbg !2614
  %tobool = icmp ne i32 %and, 0, !dbg !2614
  br i1 %tobool, label %if.then, label %if.end, !dbg !2614

if.then:                                          ; preds = %do.body
  %5 = load i32* %egid, align 4, !dbg !2614
  call void @audit_arg_egid(i32 %5) #5, !dbg !2614
  br label %if.end, !dbg !2614

if.end:                                           ; preds = %if.then, %do.body
  br label %do.end, !dbg !2614

do.end:                                           ; preds = %if.end
  %call2 = call %struct.ucred* @crget() #5, !dbg !2616
  store %struct.ucred* %call2, %struct.ucred** %newcred, align 8, !dbg !2616
  %6 = load %struct.proc** %p, align 8, !dbg !2617
  %p_mtx = getelementptr inbounds %struct.proc* %6, i32 0, i32 18, !dbg !2617
  %mtx_lock = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !2617
  call void @__mtx_lock_flags(i64* %mtx_lock, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 775) #5, !dbg !2617
  %7 = load %struct.proc** %p, align 8, !dbg !2618
  %8 = load %struct.ucred** %newcred, align 8, !dbg !2618
  %call3 = call %struct.ucred* @crcopysafe(%struct.proc* %7, %struct.ucred* %8) #5, !dbg !2618
  store %struct.ucred* %call3, %struct.ucred** %oldcred, align 8, !dbg !2618
  %9 = load %struct.ucred** %oldcred, align 8, !dbg !2619
  %10 = load i32* %egid, align 4, !dbg !2619
  %call4 = call i32 @mac_cred_check_setegid(%struct.ucred* %9, i32 %10) #5, !dbg !2619
  store i32 %call4, i32* %error, align 4, !dbg !2619
  %11 = load i32* %error, align 4, !dbg !2620
  %tobool5 = icmp ne i32 %11, 0, !dbg !2620
  br i1 %tobool5, label %if.then6, label %if.end7, !dbg !2620

if.then6:                                         ; preds = %do.end
  br label %fail, !dbg !2621

if.end7:                                          ; preds = %do.end
  %12 = load i32* %egid, align 4, !dbg !2622
  %13 = load %struct.ucred** %oldcred, align 8, !dbg !2622
  %cr_rgid = getelementptr inbounds %struct.ucred* %13, i32 0, i32 5, !dbg !2622
  %14 = load i32* %cr_rgid, align 4, !dbg !2622
  %cmp = icmp ne i32 %12, %14, !dbg !2622
  br i1 %cmp, label %land.lhs.true, label %if.end13, !dbg !2622

land.lhs.true:                                    ; preds = %if.end7
  %15 = load i32* %egid, align 4, !dbg !2622
  %16 = load %struct.ucred** %oldcred, align 8, !dbg !2622
  %cr_svgid = getelementptr inbounds %struct.ucred* %16, i32 0, i32 6, !dbg !2622
  %17 = load i32* %cr_svgid, align 4, !dbg !2622
  %cmp8 = icmp ne i32 %15, %17, !dbg !2622
  br i1 %cmp8, label %land.lhs.true9, label %if.end13, !dbg !2622

land.lhs.true9:                                   ; preds = %land.lhs.true
  %18 = load %struct.ucred** %oldcred, align 8, !dbg !2623
  %call10 = call i32 @priv_check_cred(%struct.ucred* %18, i32 53, i32 0) #5, !dbg !2623
  store i32 %call10, i32* %error, align 4, !dbg !2623
  %cmp11 = icmp ne i32 %call10, 0, !dbg !2623
  br i1 %cmp11, label %if.then12, label %if.end13, !dbg !2623

if.then12:                                        ; preds = %land.lhs.true9
  br label %fail, !dbg !2624

if.end13:                                         ; preds = %land.lhs.true9, %land.lhs.true, %if.end7
  %19 = load %struct.ucred** %oldcred, align 8, !dbg !2625
  %cr_groups = getelementptr inbounds %struct.ucred* %19, i32 0, i32 15, !dbg !2625
  %20 = load i32** %cr_groups, align 8, !dbg !2625
  %arrayidx = getelementptr inbounds i32* %20, i64 0, !dbg !2625
  %21 = load i32* %arrayidx, align 4, !dbg !2625
  %22 = load i32* %egid, align 4, !dbg !2625
  %cmp14 = icmp ne i32 %21, %22, !dbg !2625
  br i1 %cmp14, label %if.then15, label %if.end16, !dbg !2625

if.then15:                                        ; preds = %if.end13
  %23 = load %struct.ucred** %newcred, align 8, !dbg !2626
  %24 = load i32* %egid, align 4, !dbg !2626
  call void @change_egid(%struct.ucred* %23, i32 %24) #5, !dbg !2626
  %25 = load %struct.proc** %p, align 8, !dbg !2628
  call void @setsugid(%struct.proc* %25) #5, !dbg !2628
  br label %if.end16, !dbg !2629

if.end16:                                         ; preds = %if.then15, %if.end13
  %26 = load %struct.ucred** %newcred, align 8, !dbg !2630
  %27 = load %struct.proc** %p, align 8, !dbg !2630
  %p_ucred = getelementptr inbounds %struct.proc* %27, i32 0, i32 3, !dbg !2630
  store %struct.ucred* %26, %struct.ucred** %p_ucred, align 8, !dbg !2630
  %28 = load %struct.proc** %p, align 8, !dbg !2631
  %p_mtx17 = getelementptr inbounds %struct.proc* %28, i32 0, i32 18, !dbg !2631
  %mtx_lock18 = getelementptr inbounds %struct.mtx* %p_mtx17, i32 0, i32 1, !dbg !2631
  call void @__mtx_unlock_flags(i64* %mtx_lock18, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 794) #5, !dbg !2631
  %29 = load %struct.ucred** %oldcred, align 8, !dbg !2632
  call void @crfree(%struct.ucred* %29) #5, !dbg !2632
  store i32 0, i32* %retval, !dbg !2633
  br label %return, !dbg !2633

fail:                                             ; preds = %if.then12, %if.then6
  %30 = load %struct.proc** %p, align 8, !dbg !2634
  %p_mtx19 = getelementptr inbounds %struct.proc* %30, i32 0, i32 18, !dbg !2634
  %mtx_lock20 = getelementptr inbounds %struct.mtx* %p_mtx19, i32 0, i32 1, !dbg !2634
  call void @__mtx_unlock_flags(i64* %mtx_lock20, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 799) #5, !dbg !2634
  %31 = load %struct.ucred** %newcred, align 8, !dbg !2635
  call void @crfree(%struct.ucred* %31) #5, !dbg !2635
  %32 = load i32* %error, align 4, !dbg !2636
  store i32 %32, i32* %retval, !dbg !2636
  br label %return, !dbg !2636

return:                                           ; preds = %fail, %if.end16
  %33 = load i32* %retval, !dbg !2637
  ret i32 %33, !dbg !2637
}

; Function Attrs: noimplicitfloat noredzone
declare void @audit_arg_egid(i32) #2

; Function Attrs: noimplicitfloat noredzone
declare i32 @mac_cred_check_setegid(%struct.ucred*, i32) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys_setgroups(%struct.thread* %td, %struct.setgroups_args* %uap) #0 {
entry:
  %retval = alloca i32, align 4
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.setgroups_args*, align 8
  %groups = alloca i32*, align 8
  %error = alloca i32, align 4
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !2638), !dbg !2639
  store %struct.setgroups_args* %uap, %struct.setgroups_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.setgroups_args** %uap.addr}, metadata !2640), !dbg !2639
  call void @llvm.dbg.declare(metadata !{i32** %groups}, metadata !2641), !dbg !2642
  store i32* null, i32** %groups, align 8, !dbg !2642
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !2643), !dbg !2644
  %0 = load %struct.setgroups_args** %uap.addr, align 8, !dbg !2645
  %gidsetsize = getelementptr inbounds %struct.setgroups_args* %0, i32 0, i32 1, !dbg !2645
  %1 = load i32* %gidsetsize, align 4, !dbg !2645
  %2 = load i32* @ngroups_max, align 4, !dbg !2645
  %add = add nsw i32 %2, 1, !dbg !2645
  %cmp = icmp ugt i32 %1, %add, !dbg !2645
  br i1 %cmp, label %if.then, label %if.end, !dbg !2645

if.then:                                          ; preds = %entry
  store i32 22, i32* %retval, !dbg !2646
  br label %return, !dbg !2646

if.end:                                           ; preds = %entry
  %3 = load %struct.setgroups_args** %uap.addr, align 8, !dbg !2647
  %gidsetsize1 = getelementptr inbounds %struct.setgroups_args* %3, i32 0, i32 1, !dbg !2647
  %4 = load i32* %gidsetsize1, align 4, !dbg !2647
  %conv = zext i32 %4 to i64, !dbg !2647
  %mul = mul i64 %conv, 4, !dbg !2647
  %call = call noalias i8* @malloc(i64 %mul, %struct.malloc_type* getelementptr inbounds ([1 x %struct.malloc_type]* @M_TEMP, i32 0, i32 0), i32 2) #5, !dbg !2647
  %5 = bitcast i8* %call to i32*, !dbg !2647
  store i32* %5, i32** %groups, align 8, !dbg !2647
  %6 = load %struct.setgroups_args** %uap.addr, align 8, !dbg !2648
  %gidset = getelementptr inbounds %struct.setgroups_args* %6, i32 0, i32 4, !dbg !2648
  %7 = load i32** %gidset, align 8, !dbg !2648
  %8 = bitcast i32* %7 to i8*, !dbg !2648
  %9 = load i32** %groups, align 8, !dbg !2648
  %10 = bitcast i32* %9 to i8*, !dbg !2648
  %11 = load %struct.setgroups_args** %uap.addr, align 8, !dbg !2648
  %gidsetsize2 = getelementptr inbounds %struct.setgroups_args* %11, i32 0, i32 1, !dbg !2648
  %12 = load i32* %gidsetsize2, align 4, !dbg !2648
  %conv3 = zext i32 %12 to i64, !dbg !2648
  %mul4 = mul i64 %conv3, 4, !dbg !2648
  %call5 = call i32 @copyin(i8* %8, i8* %10, i64 %mul4) #5, !dbg !2648
  store i32 %call5, i32* %error, align 4, !dbg !2648
  %13 = load i32* %error, align 4, !dbg !2649
  %tobool = icmp ne i32 %13, 0, !dbg !2649
  br i1 %tobool, label %if.then6, label %if.end7, !dbg !2649

if.then6:                                         ; preds = %if.end
  br label %out, !dbg !2650

if.end7:                                          ; preds = %if.end
  %14 = load %struct.thread** %td.addr, align 8, !dbg !2651
  %15 = load %struct.setgroups_args** %uap.addr, align 8, !dbg !2651
  %gidsetsize8 = getelementptr inbounds %struct.setgroups_args* %15, i32 0, i32 1, !dbg !2651
  %16 = load i32* %gidsetsize8, align 4, !dbg !2651
  %17 = load i32** %groups, align 8, !dbg !2651
  %call9 = call i32 @kern_setgroups(%struct.thread* %14, i32 %16, i32* %17) #5, !dbg !2651
  store i32 %call9, i32* %error, align 4, !dbg !2651
  br label %out, !dbg !2651

out:                                              ; preds = %if.end7, %if.then6
  %18 = load i32** %groups, align 8, !dbg !2652
  %19 = bitcast i32* %18 to i8*, !dbg !2652
  call void @free(i8* %19, %struct.malloc_type* getelementptr inbounds ([1 x %struct.malloc_type]* @M_TEMP, i32 0, i32 0)) #5, !dbg !2652
  %20 = load i32* %error, align 4, !dbg !2653
  store i32 %20, i32* %retval, !dbg !2653
  br label %return, !dbg !2653

return:                                           ; preds = %out, %if.then
  %21 = load i32* %retval, !dbg !2654
  ret i32 %21, !dbg !2654
}

; Function Attrs: noimplicitfloat noredzone
declare i32 @copyin(i8*, i8*, i64) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @kern_setgroups(%struct.thread* %td, i32 %ngrp, i32* %groups) #0 {
entry:
  %retval = alloca i32, align 4
  %td.addr = alloca %struct.thread*, align 8
  %ngrp.addr = alloca i32, align 4
  %groups.addr = alloca i32*, align 8
  %p = alloca %struct.proc*, align 8
  %newcred = alloca %struct.ucred*, align 8
  %oldcred = alloca %struct.ucred*, align 8
  %error = alloca i32, align 4
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !2655), !dbg !2656
  store i32 %ngrp, i32* %ngrp.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %ngrp.addr}, metadata !2657), !dbg !2656
  store i32* %groups, i32** %groups.addr, align 8
  call void @llvm.dbg.declare(metadata !{i32** %groups.addr}, metadata !2658), !dbg !2656
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p}, metadata !2659), !dbg !2660
  %0 = load %struct.thread** %td.addr, align 8, !dbg !2660
  %td_proc = getelementptr inbounds %struct.thread* %0, i32 0, i32 1, !dbg !2660
  %1 = load %struct.proc** %td_proc, align 8, !dbg !2660
  store %struct.proc* %1, %struct.proc** %p, align 8, !dbg !2660
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %newcred}, metadata !2661), !dbg !2662
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %oldcred}, metadata !2663), !dbg !2662
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !2664), !dbg !2665
  %2 = load i32* %ngrp.addr, align 4, !dbg !2666
  %3 = load i32* @ngroups_max, align 4, !dbg !2666
  %add = add nsw i32 %3, 1, !dbg !2666
  %cmp = icmp ugt i32 %2, %add, !dbg !2666
  br i1 %cmp, label %if.then, label %if.end, !dbg !2666

if.then:                                          ; preds = %entry
  store i32 22, i32* %retval, !dbg !2667
  br label %return, !dbg !2667

if.end:                                           ; preds = %entry
  br label %do.body, !dbg !2668

do.body:                                          ; preds = %if.end
  %call = call %struct.thread* @__curthread() #6, !dbg !2669
  %td_pflags = getelementptr inbounds %struct.thread* %call, i32 0, i32 18, !dbg !2669
  %4 = load i32* %td_pflags, align 4, !dbg !2669
  %and = and i32 %4, 16777216, !dbg !2669
  %tobool = icmp ne i32 %and, 0, !dbg !2669
  br i1 %tobool, label %if.then1, label %if.end2, !dbg !2669

if.then1:                                         ; preds = %do.body
  %5 = load i32** %groups.addr, align 8, !dbg !2669
  %6 = load i32* %ngrp.addr, align 4, !dbg !2669
  call void @audit_arg_groupset(i32* %5, i32 %6) #5, !dbg !2669
  br label %if.end2, !dbg !2669

if.end2:                                          ; preds = %if.then1, %do.body
  br label %do.end, !dbg !2669

do.end:                                           ; preds = %if.end2
  %call3 = call %struct.ucred* @crget() #5, !dbg !2671
  store %struct.ucred* %call3, %struct.ucred** %newcred, align 8, !dbg !2671
  %7 = load %struct.ucred** %newcred, align 8, !dbg !2672
  %8 = load i32* %ngrp.addr, align 4, !dbg !2672
  call void @crextend(%struct.ucred* %7, i32 %8) #5, !dbg !2672
  %9 = load %struct.proc** %p, align 8, !dbg !2673
  %p_mtx = getelementptr inbounds %struct.proc* %9, i32 0, i32 18, !dbg !2673
  %mtx_lock = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !2673
  call void @__mtx_lock_flags(i64* %mtx_lock, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 841) #5, !dbg !2673
  %10 = load %struct.proc** %p, align 8, !dbg !2674
  %11 = load %struct.ucred** %newcred, align 8, !dbg !2674
  %call4 = call %struct.ucred* @crcopysafe(%struct.proc* %10, %struct.ucred* %11) #5, !dbg !2674
  store %struct.ucred* %call4, %struct.ucred** %oldcred, align 8, !dbg !2674
  %12 = load %struct.ucred** %oldcred, align 8, !dbg !2675
  %13 = load i32* %ngrp.addr, align 4, !dbg !2675
  %14 = load i32** %groups.addr, align 8, !dbg !2675
  %call5 = call i32 @mac_cred_check_setgroups(%struct.ucred* %12, i32 %13, i32* %14) #5, !dbg !2675
  store i32 %call5, i32* %error, align 4, !dbg !2675
  %15 = load i32* %error, align 4, !dbg !2676
  %tobool6 = icmp ne i32 %15, 0, !dbg !2676
  br i1 %tobool6, label %if.then7, label %if.end8, !dbg !2676

if.then7:                                         ; preds = %do.end
  br label %fail, !dbg !2677

if.end8:                                          ; preds = %do.end
  %16 = load %struct.ucred** %oldcred, align 8, !dbg !2678
  %call9 = call i32 @priv_check_cred(%struct.ucred* %16, i32 54, i32 0) #5, !dbg !2678
  store i32 %call9, i32* %error, align 4, !dbg !2678
  %17 = load i32* %error, align 4, !dbg !2679
  %tobool10 = icmp ne i32 %17, 0, !dbg !2679
  br i1 %tobool10, label %if.then11, label %if.end12, !dbg !2679

if.then11:                                        ; preds = %if.end8
  br label %fail, !dbg !2680

if.end12:                                         ; preds = %if.end8
  %18 = load i32* %ngrp.addr, align 4, !dbg !2681
  %cmp13 = icmp ult i32 %18, 1, !dbg !2681
  br i1 %cmp13, label %if.then14, label %if.else, !dbg !2681

if.then14:                                        ; preds = %if.end12
  %19 = load %struct.ucred** %newcred, align 8, !dbg !2682
  %cr_ngroups = getelementptr inbounds %struct.ucred* %19, i32 0, i32 4, !dbg !2682
  store i32 1, i32* %cr_ngroups, align 4, !dbg !2682
  br label %if.end15, !dbg !2684

if.else:                                          ; preds = %if.end12
  %20 = load %struct.ucred** %newcred, align 8, !dbg !2685
  %21 = load i32* %ngrp.addr, align 4, !dbg !2685
  %22 = load i32** %groups.addr, align 8, !dbg !2685
  call void @crsetgroups_locked(%struct.ucred* %20, i32 %21, i32* %22) #5, !dbg !2685
  br label %if.end15

if.end15:                                         ; preds = %if.else, %if.then14
  %23 = load %struct.proc** %p, align 8, !dbg !2687
  call void @setsugid(%struct.proc* %23) #5, !dbg !2687
  %24 = load %struct.ucred** %newcred, align 8, !dbg !2688
  %25 = load %struct.proc** %p, align 8, !dbg !2688
  %p_ucred = getelementptr inbounds %struct.proc* %25, i32 0, i32 3, !dbg !2688
  store %struct.ucred* %24, %struct.ucred** %p_ucred, align 8, !dbg !2688
  %26 = load %struct.proc** %p, align 8, !dbg !2689
  %p_mtx16 = getelementptr inbounds %struct.proc* %26, i32 0, i32 18, !dbg !2689
  %mtx_lock17 = getelementptr inbounds %struct.mtx* %p_mtx16, i32 0, i32 1, !dbg !2689
  call void @__mtx_unlock_flags(i64* %mtx_lock17, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 867) #5, !dbg !2689
  %27 = load %struct.ucred** %oldcred, align 8, !dbg !2690
  call void @crfree(%struct.ucred* %27) #5, !dbg !2690
  store i32 0, i32* %retval, !dbg !2691
  br label %return, !dbg !2691

fail:                                             ; preds = %if.then11, %if.then7
  %28 = load %struct.proc** %p, align 8, !dbg !2692
  %p_mtx18 = getelementptr inbounds %struct.proc* %28, i32 0, i32 18, !dbg !2692
  %mtx_lock19 = getelementptr inbounds %struct.mtx* %p_mtx18, i32 0, i32 1, !dbg !2692
  call void @__mtx_unlock_flags(i64* %mtx_lock19, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 872) #5, !dbg !2692
  %29 = load %struct.ucred** %newcred, align 8, !dbg !2693
  call void @crfree(%struct.ucred* %29) #5, !dbg !2693
  %30 = load i32* %error, align 4, !dbg !2694
  store i32 %30, i32* %retval, !dbg !2694
  br label %return, !dbg !2694

return:                                           ; preds = %fail, %if.end15, %if.then
  %31 = load i32* %retval, !dbg !2695
  ret i32 %31, !dbg !2695
}

; Function Attrs: noimplicitfloat noredzone
declare void @audit_arg_groupset(i32*, i32) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define internal void @crextend(%struct.ucred* %cr, i32 %n) #0 {
entry:
  %cr.addr = alloca %struct.ucred*, align 8
  %n.addr = alloca i32, align 4
  %cnt = alloca i32, align 4
  store %struct.ucred* %cr, %struct.ucred** %cr.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %cr.addr}, metadata !2696), !dbg !2697
  store i32 %n, i32* %n.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %n.addr}, metadata !2698), !dbg !2697
  call void @llvm.dbg.declare(metadata !{i32* %cnt}, metadata !2699), !dbg !2700
  %0 = load i32* %n.addr, align 4, !dbg !2701
  %1 = load %struct.ucred** %cr.addr, align 8, !dbg !2701
  %cr_agroups = getelementptr inbounds %struct.ucred* %1, i32 0, i32 16, !dbg !2701
  %2 = load i32* %cr_agroups, align 4, !dbg !2701
  %cmp = icmp sle i32 %0, %2, !dbg !2701
  br i1 %cmp, label %if.then, label %if.end, !dbg !2701

if.then:                                          ; preds = %entry
  br label %return, !dbg !2702

if.end:                                           ; preds = %entry
  %3 = load i32* %n.addr, align 4, !dbg !2703
  %conv = sext i32 %3 to i64, !dbg !2703
  %cmp1 = icmp ult i64 %conv, 1024, !dbg !2703
  br i1 %cmp1, label %if.then3, label %if.else13, !dbg !2703

if.then3:                                         ; preds = %if.end
  %4 = load %struct.ucred** %cr.addr, align 8, !dbg !2704
  %cr_agroups4 = getelementptr inbounds %struct.ucred* %4, i32 0, i32 16, !dbg !2704
  %5 = load i32* %cr_agroups4, align 4, !dbg !2704
  %cmp5 = icmp eq i32 %5, 0, !dbg !2704
  br i1 %cmp5, label %if.then7, label %if.else, !dbg !2704

if.then7:                                         ; preds = %if.then3
  store i32 4, i32* %cnt, align 4, !dbg !2706
  br label %if.end9, !dbg !2706

if.else:                                          ; preds = %if.then3
  %6 = load %struct.ucred** %cr.addr, align 8, !dbg !2707
  %cr_agroups8 = getelementptr inbounds %struct.ucred* %6, i32 0, i32 16, !dbg !2707
  %7 = load i32* %cr_agroups8, align 4, !dbg !2707
  %mul = mul nsw i32 %7, 2, !dbg !2707
  store i32 %mul, i32* %cnt, align 4, !dbg !2707
  br label %if.end9

if.end9:                                          ; preds = %if.else, %if.then7
  br label %while.cond, !dbg !2708

while.cond:                                       ; preds = %while.body, %if.end9
  %8 = load i32* %cnt, align 4, !dbg !2708
  %9 = load i32* %n.addr, align 4, !dbg !2708
  %cmp10 = icmp slt i32 %8, %9, !dbg !2708
  br i1 %cmp10, label %while.body, label %while.end, !dbg !2708

while.body:                                       ; preds = %while.cond
  %10 = load i32* %cnt, align 4, !dbg !2709
  %mul12 = mul nsw i32 %10, 2, !dbg !2709
  store i32 %mul12, i32* %cnt, align 4, !dbg !2709
  br label %while.cond, !dbg !2709

while.end:                                        ; preds = %while.cond
  br label %if.end16, !dbg !2710

if.else13:                                        ; preds = %if.end
  %11 = load i32* %n.addr, align 4, !dbg !2711
  %conv14 = sext i32 %11 to i64, !dbg !2711
  %add = add i64 %conv14, 1023, !dbg !2711
  %and = and i64 %add, -1024, !dbg !2711
  %conv15 = trunc i64 %and to i32, !dbg !2711
  store i32 %conv15, i32* %cnt, align 4, !dbg !2711
  br label %if.end16

if.end16:                                         ; preds = %if.else13, %while.end
  %12 = load %struct.ucred** %cr.addr, align 8, !dbg !2712
  %cr_groups = getelementptr inbounds %struct.ucred* %12, i32 0, i32 15, !dbg !2712
  %13 = load i32** %cr_groups, align 8, !dbg !2712
  %tobool = icmp ne i32* %13, null, !dbg !2712
  br i1 %tobool, label %if.then17, label %if.end19, !dbg !2712

if.then17:                                        ; preds = %if.end16
  %14 = load %struct.ucred** %cr.addr, align 8, !dbg !2713
  %cr_groups18 = getelementptr inbounds %struct.ucred* %14, i32 0, i32 15, !dbg !2713
  %15 = load i32** %cr_groups18, align 8, !dbg !2713
  %16 = bitcast i32* %15 to i8*, !dbg !2713
  call void @free(i8* %16, %struct.malloc_type* getelementptr inbounds ([1 x %struct.malloc_type]* @M_CRED, i32 0, i32 0)) #5, !dbg !2713
  br label %if.end19, !dbg !2713

if.end19:                                         ; preds = %if.then17, %if.end16
  %17 = load i32* %cnt, align 4, !dbg !2714
  %conv20 = sext i32 %17 to i64, !dbg !2714
  %mul21 = mul i64 %conv20, 4, !dbg !2714
  %call = call noalias i8* @malloc(i64 %mul21, %struct.malloc_type* getelementptr inbounds ([1 x %struct.malloc_type]* @M_CRED, i32 0, i32 0), i32 258) #5, !dbg !2714
  %18 = bitcast i8* %call to i32*, !dbg !2714
  %19 = load %struct.ucred** %cr.addr, align 8, !dbg !2714
  %cr_groups22 = getelementptr inbounds %struct.ucred* %19, i32 0, i32 15, !dbg !2714
  store i32* %18, i32** %cr_groups22, align 8, !dbg !2714
  %20 = load i32* %cnt, align 4, !dbg !2715
  %21 = load %struct.ucred** %cr.addr, align 8, !dbg !2715
  %cr_agroups23 = getelementptr inbounds %struct.ucred* %21, i32 0, i32 16, !dbg !2715
  store i32 %20, i32* %cr_agroups23, align 4, !dbg !2715
  br label %return, !dbg !2715

return:                                           ; preds = %if.end19, %if.then
  ret void, !dbg !2715
}

; Function Attrs: noimplicitfloat noredzone
declare i32 @mac_cred_check_setgroups(%struct.ucred*, i32, i32*) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define internal void @crsetgroups_locked(%struct.ucred* %cr, i32 %ngrp, i32* %groups) #0 {
entry:
  %cr.addr = alloca %struct.ucred*, align 8
  %ngrp.addr = alloca i32, align 4
  %groups.addr = alloca i32*, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %g = alloca i32, align 4
  store %struct.ucred* %cr, %struct.ucred** %cr.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %cr.addr}, metadata !2716), !dbg !2717
  store i32 %ngrp, i32* %ngrp.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %ngrp.addr}, metadata !2718), !dbg !2717
  store i32* %groups, i32** %groups.addr, align 8
  call void @llvm.dbg.declare(metadata !{i32** %groups.addr}, metadata !2719), !dbg !2717
  call void @llvm.dbg.declare(metadata !{i32* %i}, metadata !2720), !dbg !2721
  call void @llvm.dbg.declare(metadata !{i32* %j}, metadata !2722), !dbg !2723
  call void @llvm.dbg.declare(metadata !{i32* %g}, metadata !2724), !dbg !2725
  br label %do.body, !dbg !2726

do.body:                                          ; preds = %entry
  %0 = load %struct.ucred** %cr.addr, align 8, !dbg !2727
  %cr_agroups = getelementptr inbounds %struct.ucred* %0, i32 0, i32 16, !dbg !2727
  %1 = load i32* %cr_agroups, align 4, !dbg !2727
  %2 = load i32* %ngrp.addr, align 4, !dbg !2727
  %cmp = icmp sge i32 %1, %2, !dbg !2727
  %lnot = xor i1 %cmp, true, !dbg !2727
  %lnot.ext = zext i1 %lnot to i32, !dbg !2727
  %conv = sext i32 %lnot.ext to i64, !dbg !2727
  %expval = call i64 @llvm.expect.i64(i64 %conv, i64 0), !dbg !2727
  %tobool = icmp ne i64 %expval, 0, !dbg !2727
  br i1 %tobool, label %if.then, label %if.end, !dbg !2727

if.then:                                          ; preds = %do.body
  call void (i8*, ...)* @kassert_panic(i8* getelementptr inbounds ([24 x i8]* @.str6, i32 0, i32 0)) #5, !dbg !2727
  br label %if.end, !dbg !2727

if.end:                                           ; preds = %if.then, %do.body
  br label %do.end, !dbg !2727

do.end:                                           ; preds = %if.end
  %3 = load i32** %groups.addr, align 8, !dbg !2729
  %4 = bitcast i32* %3 to i8*, !dbg !2729
  %5 = load %struct.ucred** %cr.addr, align 8, !dbg !2729
  %cr_groups = getelementptr inbounds %struct.ucred* %5, i32 0, i32 15, !dbg !2729
  %6 = load i32** %cr_groups, align 8, !dbg !2729
  %7 = bitcast i32* %6 to i8*, !dbg !2729
  %8 = load i32* %ngrp.addr, align 4, !dbg !2729
  %conv1 = sext i32 %8 to i64, !dbg !2729
  %mul = mul i64 %conv1, 4, !dbg !2729
  call void @bcopy(i8* %4, i8* %7, i64 %mul) #5, !dbg !2729
  %9 = load i32* %ngrp.addr, align 4, !dbg !2730
  %10 = load %struct.ucred** %cr.addr, align 8, !dbg !2730
  %cr_ngroups = getelementptr inbounds %struct.ucred* %10, i32 0, i32 4, !dbg !2730
  store i32 %9, i32* %cr_ngroups, align 4, !dbg !2730
  store i32 2, i32* %i, align 4, !dbg !2731
  br label %for.cond, !dbg !2731

for.cond:                                         ; preds = %for.inc24, %do.end
  %11 = load i32* %i, align 4, !dbg !2731
  %12 = load i32* %ngrp.addr, align 4, !dbg !2731
  %cmp2 = icmp slt i32 %11, %12, !dbg !2731
  br i1 %cmp2, label %for.body, label %for.end25, !dbg !2731

for.body:                                         ; preds = %for.cond
  %13 = load i32* %i, align 4, !dbg !2733
  %idxprom = sext i32 %13 to i64, !dbg !2733
  %14 = load %struct.ucred** %cr.addr, align 8, !dbg !2733
  %cr_groups4 = getelementptr inbounds %struct.ucred* %14, i32 0, i32 15, !dbg !2733
  %15 = load i32** %cr_groups4, align 8, !dbg !2733
  %arrayidx = getelementptr inbounds i32* %15, i64 %idxprom, !dbg !2733
  %16 = load i32* %arrayidx, align 4, !dbg !2733
  store i32 %16, i32* %g, align 4, !dbg !2733
  %17 = load i32* %i, align 4, !dbg !2735
  %sub = sub nsw i32 %17, 1, !dbg !2735
  store i32 %sub, i32* %j, align 4, !dbg !2735
  br label %for.cond5, !dbg !2735

for.cond5:                                        ; preds = %for.inc, %for.body
  %18 = load i32* %j, align 4, !dbg !2735
  %cmp6 = icmp sge i32 %18, 1, !dbg !2735
  br i1 %cmp6, label %land.rhs, label %land.end, !dbg !2735

land.rhs:                                         ; preds = %for.cond5
  %19 = load i32* %g, align 4, !dbg !2735
  %20 = load i32* %j, align 4, !dbg !2735
  %idxprom8 = sext i32 %20 to i64, !dbg !2735
  %21 = load %struct.ucred** %cr.addr, align 8, !dbg !2735
  %cr_groups9 = getelementptr inbounds %struct.ucred* %21, i32 0, i32 15, !dbg !2735
  %22 = load i32** %cr_groups9, align 8, !dbg !2735
  %arrayidx10 = getelementptr inbounds i32* %22, i64 %idxprom8, !dbg !2735
  %23 = load i32* %arrayidx10, align 4, !dbg !2735
  %cmp11 = icmp ult i32 %19, %23, !dbg !2735
  br label %land.end

land.end:                                         ; preds = %land.rhs, %for.cond5
  %24 = phi i1 [ false, %for.cond5 ], [ %cmp11, %land.rhs ]
  br i1 %24, label %for.body13, label %for.end

for.body13:                                       ; preds = %land.end
  %25 = load i32* %j, align 4, !dbg !2737
  %idxprom14 = sext i32 %25 to i64, !dbg !2737
  %26 = load %struct.ucred** %cr.addr, align 8, !dbg !2737
  %cr_groups15 = getelementptr inbounds %struct.ucred* %26, i32 0, i32 15, !dbg !2737
  %27 = load i32** %cr_groups15, align 8, !dbg !2737
  %arrayidx16 = getelementptr inbounds i32* %27, i64 %idxprom14, !dbg !2737
  %28 = load i32* %arrayidx16, align 4, !dbg !2737
  %29 = load i32* %j, align 4, !dbg !2737
  %add = add nsw i32 %29, 1, !dbg !2737
  %idxprom17 = sext i32 %add to i64, !dbg !2737
  %30 = load %struct.ucred** %cr.addr, align 8, !dbg !2737
  %cr_groups18 = getelementptr inbounds %struct.ucred* %30, i32 0, i32 15, !dbg !2737
  %31 = load i32** %cr_groups18, align 8, !dbg !2737
  %arrayidx19 = getelementptr inbounds i32* %31, i64 %idxprom17, !dbg !2737
  store i32 %28, i32* %arrayidx19, align 4, !dbg !2737
  br label %for.inc, !dbg !2737

for.inc:                                          ; preds = %for.body13
  %32 = load i32* %j, align 4, !dbg !2735
  %dec = add nsw i32 %32, -1, !dbg !2735
  store i32 %dec, i32* %j, align 4, !dbg !2735
  br label %for.cond5, !dbg !2735

for.end:                                          ; preds = %land.end
  %33 = load i32* %g, align 4, !dbg !2738
  %34 = load i32* %j, align 4, !dbg !2738
  %add20 = add nsw i32 %34, 1, !dbg !2738
  %idxprom21 = sext i32 %add20 to i64, !dbg !2738
  %35 = load %struct.ucred** %cr.addr, align 8, !dbg !2738
  %cr_groups22 = getelementptr inbounds %struct.ucred* %35, i32 0, i32 15, !dbg !2738
  %36 = load i32** %cr_groups22, align 8, !dbg !2738
  %arrayidx23 = getelementptr inbounds i32* %36, i64 %idxprom21, !dbg !2738
  store i32 %33, i32* %arrayidx23, align 4, !dbg !2738
  br label %for.inc24, !dbg !2739

for.inc24:                                        ; preds = %for.end
  %37 = load i32* %i, align 4, !dbg !2731
  %inc = add nsw i32 %37, 1, !dbg !2731
  store i32 %inc, i32* %i, align 4, !dbg !2731
  br label %for.cond, !dbg !2731

for.end25:                                        ; preds = %for.cond
  ret void, !dbg !2740
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys_setreuid(%struct.thread* %td, %struct.setreuid_args* %uap) #0 {
entry:
  %retval = alloca i32, align 4
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.setreuid_args*, align 8
  %p = alloca %struct.proc*, align 8
  %newcred = alloca %struct.ucred*, align 8
  %oldcred = alloca %struct.ucred*, align 8
  %euid = alloca i32, align 4
  %ruid = alloca i32, align 4
  %euip = alloca %struct.uidinfo*, align 8
  %ruip = alloca %struct.uidinfo*, align 8
  %error = alloca i32, align 4
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !2741), !dbg !2742
  store %struct.setreuid_args* %uap, %struct.setreuid_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.setreuid_args** %uap.addr}, metadata !2743), !dbg !2742
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p}, metadata !2744), !dbg !2745
  %0 = load %struct.thread** %td.addr, align 8, !dbg !2745
  %td_proc = getelementptr inbounds %struct.thread* %0, i32 0, i32 1, !dbg !2745
  %1 = load %struct.proc** %td_proc, align 8, !dbg !2745
  store %struct.proc* %1, %struct.proc** %p, align 8, !dbg !2745
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %newcred}, metadata !2746), !dbg !2747
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %oldcred}, metadata !2748), !dbg !2747
  call void @llvm.dbg.declare(metadata !{i32* %euid}, metadata !2749), !dbg !2750
  call void @llvm.dbg.declare(metadata !{i32* %ruid}, metadata !2751), !dbg !2750
  call void @llvm.dbg.declare(metadata !{%struct.uidinfo** %euip}, metadata !2752), !dbg !2753
  call void @llvm.dbg.declare(metadata !{%struct.uidinfo** %ruip}, metadata !2754), !dbg !2753
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !2755), !dbg !2756
  %2 = load %struct.setreuid_args** %uap.addr, align 8, !dbg !2757
  %euid1 = getelementptr inbounds %struct.setreuid_args* %2, i32 0, i32 4, !dbg !2757
  %3 = load i32* %euid1, align 4, !dbg !2757
  store i32 %3, i32* %euid, align 4, !dbg !2757
  %4 = load %struct.setreuid_args** %uap.addr, align 8, !dbg !2758
  %ruid2 = getelementptr inbounds %struct.setreuid_args* %4, i32 0, i32 1, !dbg !2758
  %5 = load i32* %ruid2, align 4, !dbg !2758
  store i32 %5, i32* %ruid, align 4, !dbg !2758
  br label %do.body, !dbg !2759

do.body:                                          ; preds = %entry
  %call = call %struct.thread* @__curthread() #6, !dbg !2760
  %td_pflags = getelementptr inbounds %struct.thread* %call, i32 0, i32 18, !dbg !2760
  %6 = load i32* %td_pflags, align 4, !dbg !2760
  %and = and i32 %6, 16777216, !dbg !2760
  %tobool = icmp ne i32 %and, 0, !dbg !2760
  br i1 %tobool, label %if.then, label %if.end, !dbg !2760

if.then:                                          ; preds = %do.body
  %7 = load i32* %euid, align 4, !dbg !2760
  call void @audit_arg_euid(i32 %7) #5, !dbg !2760
  br label %if.end, !dbg !2760

if.end:                                           ; preds = %if.then, %do.body
  br label %do.end, !dbg !2760

do.end:                                           ; preds = %if.end
  br label %do.body3, !dbg !2762

do.body3:                                         ; preds = %do.end
  %call4 = call %struct.thread* @__curthread() #6, !dbg !2763
  %td_pflags5 = getelementptr inbounds %struct.thread* %call4, i32 0, i32 18, !dbg !2763
  %8 = load i32* %td_pflags5, align 4, !dbg !2763
  %and6 = and i32 %8, 16777216, !dbg !2763
  %tobool7 = icmp ne i32 %and6, 0, !dbg !2763
  br i1 %tobool7, label %if.then8, label %if.end9, !dbg !2763

if.then8:                                         ; preds = %do.body3
  %9 = load i32* %ruid, align 4, !dbg !2763
  call void @audit_arg_ruid(i32 %9) #5, !dbg !2763
  br label %if.end9, !dbg !2763

if.end9:                                          ; preds = %if.then8, %do.body3
  br label %do.end10, !dbg !2763

do.end10:                                         ; preds = %if.end9
  %call11 = call %struct.ucred* @crget() #5, !dbg !2765
  store %struct.ucred* %call11, %struct.ucred** %newcred, align 8, !dbg !2765
  %10 = load i32* %euid, align 4, !dbg !2766
  %call12 = call %struct.uidinfo* @uifind(i32 %10) #5, !dbg !2766
  store %struct.uidinfo* %call12, %struct.uidinfo** %euip, align 8, !dbg !2766
  %11 = load i32* %ruid, align 4, !dbg !2767
  %call13 = call %struct.uidinfo* @uifind(i32 %11) #5, !dbg !2767
  store %struct.uidinfo* %call13, %struct.uidinfo** %ruip, align 8, !dbg !2767
  %12 = load %struct.proc** %p, align 8, !dbg !2768
  %p_mtx = getelementptr inbounds %struct.proc* %12, i32 0, i32 18, !dbg !2768
  %mtx_lock = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !2768
  call void @__mtx_lock_flags(i64* %mtx_lock, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 900) #5, !dbg !2768
  %13 = load %struct.proc** %p, align 8, !dbg !2769
  %14 = load %struct.ucred** %newcred, align 8, !dbg !2769
  %call14 = call %struct.ucred* @crcopysafe(%struct.proc* %13, %struct.ucred* %14) #5, !dbg !2769
  store %struct.ucred* %call14, %struct.ucred** %oldcred, align 8, !dbg !2769
  %15 = load %struct.ucred** %oldcred, align 8, !dbg !2770
  %16 = load i32* %ruid, align 4, !dbg !2770
  %17 = load i32* %euid, align 4, !dbg !2770
  %call15 = call i32 @mac_cred_check_setreuid(%struct.ucred* %15, i32 %16, i32 %17) #5, !dbg !2770
  store i32 %call15, i32* %error, align 4, !dbg !2770
  %18 = load i32* %error, align 4, !dbg !2771
  %tobool16 = icmp ne i32 %18, 0, !dbg !2771
  br i1 %tobool16, label %if.then17, label %if.end18, !dbg !2771

if.then17:                                        ; preds = %do.end10
  br label %fail, !dbg !2772

if.end18:                                         ; preds = %do.end10
  %19 = load i32* %ruid, align 4, !dbg !2773
  %cmp = icmp ne i32 %19, -1, !dbg !2773
  br i1 %cmp, label %land.lhs.true, label %lor.lhs.false, !dbg !2773

land.lhs.true:                                    ; preds = %if.end18
  %20 = load i32* %ruid, align 4, !dbg !2773
  %21 = load %struct.ucred** %oldcred, align 8, !dbg !2773
  %cr_ruid = getelementptr inbounds %struct.ucred* %21, i32 0, i32 2, !dbg !2773
  %22 = load i32* %cr_ruid, align 4, !dbg !2773
  %cmp19 = icmp ne i32 %20, %22, !dbg !2773
  br i1 %cmp19, label %land.lhs.true20, label %lor.lhs.false, !dbg !2773

land.lhs.true20:                                  ; preds = %land.lhs.true
  %23 = load i32* %ruid, align 4, !dbg !2773
  %24 = load %struct.ucred** %oldcred, align 8, !dbg !2773
  %cr_svuid = getelementptr inbounds %struct.ucred* %24, i32 0, i32 3, !dbg !2773
  %25 = load i32* %cr_svuid, align 4, !dbg !2773
  %cmp21 = icmp ne i32 %23, %25, !dbg !2773
  br i1 %cmp21, label %land.lhs.true31, label %lor.lhs.false, !dbg !2773

lor.lhs.false:                                    ; preds = %land.lhs.true20, %land.lhs.true, %if.end18
  %26 = load i32* %euid, align 4, !dbg !2773
  %cmp22 = icmp ne i32 %26, -1, !dbg !2773
  br i1 %cmp22, label %land.lhs.true23, label %if.end35, !dbg !2773

land.lhs.true23:                                  ; preds = %lor.lhs.false
  %27 = load i32* %euid, align 4, !dbg !2773
  %28 = load %struct.ucred** %oldcred, align 8, !dbg !2773
  %cr_uid = getelementptr inbounds %struct.ucred* %28, i32 0, i32 1, !dbg !2773
  %29 = load i32* %cr_uid, align 4, !dbg !2773
  %cmp24 = icmp ne i32 %27, %29, !dbg !2773
  br i1 %cmp24, label %land.lhs.true25, label %if.end35, !dbg !2773

land.lhs.true25:                                  ; preds = %land.lhs.true23
  %30 = load i32* %euid, align 4, !dbg !2773
  %31 = load %struct.ucred** %oldcred, align 8, !dbg !2773
  %cr_ruid26 = getelementptr inbounds %struct.ucred* %31, i32 0, i32 2, !dbg !2773
  %32 = load i32* %cr_ruid26, align 4, !dbg !2773
  %cmp27 = icmp ne i32 %30, %32, !dbg !2773
  br i1 %cmp27, label %land.lhs.true28, label %if.end35, !dbg !2773

land.lhs.true28:                                  ; preds = %land.lhs.true25
  %33 = load i32* %euid, align 4, !dbg !2773
  %34 = load %struct.ucred** %oldcred, align 8, !dbg !2773
  %cr_svuid29 = getelementptr inbounds %struct.ucred* %34, i32 0, i32 3, !dbg !2773
  %35 = load i32* %cr_svuid29, align 4, !dbg !2773
  %cmp30 = icmp ne i32 %33, %35, !dbg !2773
  br i1 %cmp30, label %land.lhs.true31, label %if.end35, !dbg !2773

land.lhs.true31:                                  ; preds = %land.lhs.true28, %land.lhs.true20
  %36 = load %struct.ucred** %oldcred, align 8, !dbg !2774
  %call32 = call i32 @priv_check_cred(%struct.ucred* %36, i32 55, i32 0) #5, !dbg !2774
  store i32 %call32, i32* %error, align 4, !dbg !2774
  %cmp33 = icmp ne i32 %call32, 0, !dbg !2774
  br i1 %cmp33, label %if.then34, label %if.end35, !dbg !2774

if.then34:                                        ; preds = %land.lhs.true31
  br label %fail, !dbg !2775

if.end35:                                         ; preds = %land.lhs.true31, %land.lhs.true28, %land.lhs.true25, %land.lhs.true23, %lor.lhs.false
  %37 = load i32* %euid, align 4, !dbg !2776
  %cmp36 = icmp ne i32 %37, -1, !dbg !2776
  br i1 %cmp36, label %land.lhs.true37, label %if.end41, !dbg !2776

land.lhs.true37:                                  ; preds = %if.end35
  %38 = load %struct.ucred** %oldcred, align 8, !dbg !2776
  %cr_uid38 = getelementptr inbounds %struct.ucred* %38, i32 0, i32 1, !dbg !2776
  %39 = load i32* %cr_uid38, align 4, !dbg !2776
  %40 = load i32* %euid, align 4, !dbg !2776
  %cmp39 = icmp ne i32 %39, %40, !dbg !2776
  br i1 %cmp39, label %if.then40, label %if.end41, !dbg !2776

if.then40:                                        ; preds = %land.lhs.true37
  %41 = load %struct.ucred** %newcred, align 8, !dbg !2777
  %42 = load %struct.uidinfo** %euip, align 8, !dbg !2777
  call void @change_euid(%struct.ucred* %41, %struct.uidinfo* %42) #5, !dbg !2777
  %43 = load %struct.proc** %p, align 8, !dbg !2779
  call void @setsugid(%struct.proc* %43) #5, !dbg !2779
  br label %if.end41, !dbg !2780

if.end41:                                         ; preds = %if.then40, %land.lhs.true37, %if.end35
  %44 = load i32* %ruid, align 4, !dbg !2781
  %cmp42 = icmp ne i32 %44, -1, !dbg !2781
  br i1 %cmp42, label %land.lhs.true43, label %if.end47, !dbg !2781

land.lhs.true43:                                  ; preds = %if.end41
  %45 = load %struct.ucred** %oldcred, align 8, !dbg !2781
  %cr_ruid44 = getelementptr inbounds %struct.ucred* %45, i32 0, i32 2, !dbg !2781
  %46 = load i32* %cr_ruid44, align 4, !dbg !2781
  %47 = load i32* %ruid, align 4, !dbg !2781
  %cmp45 = icmp ne i32 %46, %47, !dbg !2781
  br i1 %cmp45, label %if.then46, label %if.end47, !dbg !2781

if.then46:                                        ; preds = %land.lhs.true43
  %48 = load %struct.ucred** %newcred, align 8, !dbg !2782
  %49 = load %struct.uidinfo** %ruip, align 8, !dbg !2782
  call void @change_ruid(%struct.ucred* %48, %struct.uidinfo* %49) #5, !dbg !2782
  %50 = load %struct.proc** %p, align 8, !dbg !2784
  call void @setsugid(%struct.proc* %50) #5, !dbg !2784
  br label %if.end47, !dbg !2785

if.end47:                                         ; preds = %if.then46, %land.lhs.true43, %if.end41
  %51 = load i32* %ruid, align 4, !dbg !2786
  %cmp48 = icmp ne i32 %51, -1, !dbg !2786
  br i1 %cmp48, label %land.lhs.true53, label %lor.lhs.false49, !dbg !2786

lor.lhs.false49:                                  ; preds = %if.end47
  %52 = load %struct.ucred** %newcred, align 8, !dbg !2786
  %cr_uid50 = getelementptr inbounds %struct.ucred* %52, i32 0, i32 1, !dbg !2786
  %53 = load i32* %cr_uid50, align 4, !dbg !2786
  %54 = load %struct.ucred** %newcred, align 8, !dbg !2786
  %cr_ruid51 = getelementptr inbounds %struct.ucred* %54, i32 0, i32 2, !dbg !2786
  %55 = load i32* %cr_ruid51, align 4, !dbg !2786
  %cmp52 = icmp ne i32 %53, %55, !dbg !2786
  br i1 %cmp52, label %land.lhs.true53, label %if.end59, !dbg !2786

land.lhs.true53:                                  ; preds = %lor.lhs.false49, %if.end47
  %56 = load %struct.ucred** %newcred, align 8, !dbg !2786
  %cr_svuid54 = getelementptr inbounds %struct.ucred* %56, i32 0, i32 3, !dbg !2786
  %57 = load i32* %cr_svuid54, align 4, !dbg !2786
  %58 = load %struct.ucred** %newcred, align 8, !dbg !2786
  %cr_uid55 = getelementptr inbounds %struct.ucred* %58, i32 0, i32 1, !dbg !2786
  %59 = load i32* %cr_uid55, align 4, !dbg !2786
  %cmp56 = icmp ne i32 %57, %59, !dbg !2786
  br i1 %cmp56, label %if.then57, label %if.end59, !dbg !2786

if.then57:                                        ; preds = %land.lhs.true53
  %60 = load %struct.ucred** %newcred, align 8, !dbg !2787
  %61 = load %struct.ucred** %newcred, align 8, !dbg !2787
  %cr_uid58 = getelementptr inbounds %struct.ucred* %61, i32 0, i32 1, !dbg !2787
  %62 = load i32* %cr_uid58, align 4, !dbg !2787
  call void @change_svuid(%struct.ucred* %60, i32 %62) #5, !dbg !2787
  %63 = load %struct.proc** %p, align 8, !dbg !2789
  call void @setsugid(%struct.proc* %63) #5, !dbg !2789
  br label %if.end59, !dbg !2790

if.end59:                                         ; preds = %if.then57, %land.lhs.true53, %lor.lhs.false49
  %64 = load %struct.ucred** %newcred, align 8, !dbg !2791
  %65 = load %struct.proc** %p, align 8, !dbg !2791
  %p_ucred = getelementptr inbounds %struct.proc* %65, i32 0, i32 3, !dbg !2791
  store %struct.ucred* %64, %struct.ucred** %p_ucred, align 8, !dbg !2791
  %66 = load %struct.proc** %p, align 8, !dbg !2792
  %p_mtx60 = getelementptr inbounds %struct.proc* %66, i32 0, i32 18, !dbg !2792
  %mtx_lock61 = getelementptr inbounds %struct.mtx* %p_mtx60, i32 0, i32 1, !dbg !2792
  call void @__mtx_unlock_flags(i64* %mtx_lock61, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 930) #5, !dbg !2792
  %67 = load %struct.uidinfo** %ruip, align 8, !dbg !2793
  call void @uifree(%struct.uidinfo* %67) #5, !dbg !2793
  %68 = load %struct.uidinfo** %euip, align 8, !dbg !2794
  call void @uifree(%struct.uidinfo* %68) #5, !dbg !2794
  %69 = load %struct.ucred** %oldcred, align 8, !dbg !2795
  call void @crfree(%struct.ucred* %69) #5, !dbg !2795
  store i32 0, i32* %retval, !dbg !2796
  br label %return, !dbg !2796

fail:                                             ; preds = %if.then34, %if.then17
  %70 = load %struct.proc** %p, align 8, !dbg !2797
  %p_mtx62 = getelementptr inbounds %struct.proc* %70, i32 0, i32 18, !dbg !2797
  %mtx_lock63 = getelementptr inbounds %struct.mtx* %p_mtx62, i32 0, i32 1, !dbg !2797
  call void @__mtx_unlock_flags(i64* %mtx_lock63, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 940) #5, !dbg !2797
  %71 = load %struct.uidinfo** %ruip, align 8, !dbg !2798
  call void @uifree(%struct.uidinfo* %71) #5, !dbg !2798
  %72 = load %struct.uidinfo** %euip, align 8, !dbg !2799
  call void @uifree(%struct.uidinfo* %72) #5, !dbg !2799
  %73 = load %struct.ucred** %newcred, align 8, !dbg !2800
  call void @crfree(%struct.ucred* %73) #5, !dbg !2800
  %74 = load i32* %error, align 4, !dbg !2801
  store i32 %74, i32* %retval, !dbg !2801
  br label %return, !dbg !2801

return:                                           ; preds = %fail, %if.end59
  %75 = load i32* %retval, !dbg !2802
  ret i32 %75, !dbg !2802
}

; Function Attrs: noimplicitfloat noredzone
declare void @audit_arg_ruid(i32) #2

; Function Attrs: noimplicitfloat noredzone
declare i32 @mac_cred_check_setreuid(%struct.ucred*, i32, i32) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys_setregid(%struct.thread* %td, %struct.setregid_args* %uap) #0 {
entry:
  %retval = alloca i32, align 4
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.setregid_args*, align 8
  %p = alloca %struct.proc*, align 8
  %newcred = alloca %struct.ucred*, align 8
  %oldcred = alloca %struct.ucred*, align 8
  %egid = alloca i32, align 4
  %rgid = alloca i32, align 4
  %error = alloca i32, align 4
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !2803), !dbg !2804
  store %struct.setregid_args* %uap, %struct.setregid_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.setregid_args** %uap.addr}, metadata !2805), !dbg !2804
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p}, metadata !2806), !dbg !2807
  %0 = load %struct.thread** %td.addr, align 8, !dbg !2807
  %td_proc = getelementptr inbounds %struct.thread* %0, i32 0, i32 1, !dbg !2807
  %1 = load %struct.proc** %td_proc, align 8, !dbg !2807
  store %struct.proc* %1, %struct.proc** %p, align 8, !dbg !2807
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %newcred}, metadata !2808), !dbg !2809
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %oldcred}, metadata !2810), !dbg !2809
  call void @llvm.dbg.declare(metadata !{i32* %egid}, metadata !2811), !dbg !2812
  call void @llvm.dbg.declare(metadata !{i32* %rgid}, metadata !2813), !dbg !2812
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !2814), !dbg !2815
  %2 = load %struct.setregid_args** %uap.addr, align 8, !dbg !2816
  %egid1 = getelementptr inbounds %struct.setregid_args* %2, i32 0, i32 4, !dbg !2816
  %3 = load i32* %egid1, align 4, !dbg !2816
  store i32 %3, i32* %egid, align 4, !dbg !2816
  %4 = load %struct.setregid_args** %uap.addr, align 8, !dbg !2817
  %rgid2 = getelementptr inbounds %struct.setregid_args* %4, i32 0, i32 1, !dbg !2817
  %5 = load i32* %rgid2, align 4, !dbg !2817
  store i32 %5, i32* %rgid, align 4, !dbg !2817
  br label %do.body, !dbg !2818

do.body:                                          ; preds = %entry
  %call = call %struct.thread* @__curthread() #6, !dbg !2819
  %td_pflags = getelementptr inbounds %struct.thread* %call, i32 0, i32 18, !dbg !2819
  %6 = load i32* %td_pflags, align 4, !dbg !2819
  %and = and i32 %6, 16777216, !dbg !2819
  %tobool = icmp ne i32 %and, 0, !dbg !2819
  br i1 %tobool, label %if.then, label %if.end, !dbg !2819

if.then:                                          ; preds = %do.body
  %7 = load i32* %egid, align 4, !dbg !2819
  call void @audit_arg_egid(i32 %7) #5, !dbg !2819
  br label %if.end, !dbg !2819

if.end:                                           ; preds = %if.then, %do.body
  br label %do.end, !dbg !2819

do.end:                                           ; preds = %if.end
  br label %do.body3, !dbg !2821

do.body3:                                         ; preds = %do.end
  %call4 = call %struct.thread* @__curthread() #6, !dbg !2822
  %td_pflags5 = getelementptr inbounds %struct.thread* %call4, i32 0, i32 18, !dbg !2822
  %8 = load i32* %td_pflags5, align 4, !dbg !2822
  %and6 = and i32 %8, 16777216, !dbg !2822
  %tobool7 = icmp ne i32 %and6, 0, !dbg !2822
  br i1 %tobool7, label %if.then8, label %if.end9, !dbg !2822

if.then8:                                         ; preds = %do.body3
  %9 = load i32* %rgid, align 4, !dbg !2822
  call void @audit_arg_rgid(i32 %9) #5, !dbg !2822
  br label %if.end9, !dbg !2822

if.end9:                                          ; preds = %if.then8, %do.body3
  br label %do.end10, !dbg !2822

do.end10:                                         ; preds = %if.end9
  %call11 = call %struct.ucred* @crget() #5, !dbg !2824
  store %struct.ucred* %call11, %struct.ucred** %newcred, align 8, !dbg !2824
  %10 = load %struct.proc** %p, align 8, !dbg !2825
  %p_mtx = getelementptr inbounds %struct.proc* %10, i32 0, i32 18, !dbg !2825
  %mtx_lock = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !2825
  call void @__mtx_lock_flags(i64* %mtx_lock, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 967) #5, !dbg !2825
  %11 = load %struct.proc** %p, align 8, !dbg !2826
  %12 = load %struct.ucred** %newcred, align 8, !dbg !2826
  %call12 = call %struct.ucred* @crcopysafe(%struct.proc* %11, %struct.ucred* %12) #5, !dbg !2826
  store %struct.ucred* %call12, %struct.ucred** %oldcred, align 8, !dbg !2826
  %13 = load %struct.ucred** %oldcred, align 8, !dbg !2827
  %14 = load i32* %rgid, align 4, !dbg !2827
  %15 = load i32* %egid, align 4, !dbg !2827
  %call13 = call i32 @mac_cred_check_setregid(%struct.ucred* %13, i32 %14, i32 %15) #5, !dbg !2827
  store i32 %call13, i32* %error, align 4, !dbg !2827
  %16 = load i32* %error, align 4, !dbg !2828
  %tobool14 = icmp ne i32 %16, 0, !dbg !2828
  br i1 %tobool14, label %if.then15, label %if.end16, !dbg !2828

if.then15:                                        ; preds = %do.end10
  br label %fail, !dbg !2829

if.end16:                                         ; preds = %do.end10
  %17 = load i32* %rgid, align 4, !dbg !2830
  %cmp = icmp ne i32 %17, -1, !dbg !2830
  br i1 %cmp, label %land.lhs.true, label %lor.lhs.false, !dbg !2830

land.lhs.true:                                    ; preds = %if.end16
  %18 = load i32* %rgid, align 4, !dbg !2830
  %19 = load %struct.ucred** %oldcred, align 8, !dbg !2830
  %cr_rgid = getelementptr inbounds %struct.ucred* %19, i32 0, i32 5, !dbg !2830
  %20 = load i32* %cr_rgid, align 4, !dbg !2830
  %cmp17 = icmp ne i32 %18, %20, !dbg !2830
  br i1 %cmp17, label %land.lhs.true18, label %lor.lhs.false, !dbg !2830

land.lhs.true18:                                  ; preds = %land.lhs.true
  %21 = load i32* %rgid, align 4, !dbg !2830
  %22 = load %struct.ucred** %oldcred, align 8, !dbg !2830
  %cr_svgid = getelementptr inbounds %struct.ucred* %22, i32 0, i32 6, !dbg !2830
  %23 = load i32* %cr_svgid, align 4, !dbg !2830
  %cmp19 = icmp ne i32 %21, %23, !dbg !2830
  br i1 %cmp19, label %land.lhs.true29, label %lor.lhs.false, !dbg !2830

lor.lhs.false:                                    ; preds = %land.lhs.true18, %land.lhs.true, %if.end16
  %24 = load i32* %egid, align 4, !dbg !2830
  %cmp20 = icmp ne i32 %24, -1, !dbg !2830
  br i1 %cmp20, label %land.lhs.true21, label %if.end33, !dbg !2830

land.lhs.true21:                                  ; preds = %lor.lhs.false
  %25 = load i32* %egid, align 4, !dbg !2830
  %26 = load %struct.ucred** %oldcred, align 8, !dbg !2830
  %cr_groups = getelementptr inbounds %struct.ucred* %26, i32 0, i32 15, !dbg !2830
  %27 = load i32** %cr_groups, align 8, !dbg !2830
  %arrayidx = getelementptr inbounds i32* %27, i64 0, !dbg !2830
  %28 = load i32* %arrayidx, align 4, !dbg !2830
  %cmp22 = icmp ne i32 %25, %28, !dbg !2830
  br i1 %cmp22, label %land.lhs.true23, label %if.end33, !dbg !2830

land.lhs.true23:                                  ; preds = %land.lhs.true21
  %29 = load i32* %egid, align 4, !dbg !2830
  %30 = load %struct.ucred** %oldcred, align 8, !dbg !2830
  %cr_rgid24 = getelementptr inbounds %struct.ucred* %30, i32 0, i32 5, !dbg !2830
  %31 = load i32* %cr_rgid24, align 4, !dbg !2830
  %cmp25 = icmp ne i32 %29, %31, !dbg !2830
  br i1 %cmp25, label %land.lhs.true26, label %if.end33, !dbg !2830

land.lhs.true26:                                  ; preds = %land.lhs.true23
  %32 = load i32* %egid, align 4, !dbg !2830
  %33 = load %struct.ucred** %oldcred, align 8, !dbg !2830
  %cr_svgid27 = getelementptr inbounds %struct.ucred* %33, i32 0, i32 6, !dbg !2830
  %34 = load i32* %cr_svgid27, align 4, !dbg !2830
  %cmp28 = icmp ne i32 %32, %34, !dbg !2830
  br i1 %cmp28, label %land.lhs.true29, label %if.end33, !dbg !2830

land.lhs.true29:                                  ; preds = %land.lhs.true26, %land.lhs.true18
  %35 = load %struct.ucred** %oldcred, align 8, !dbg !2831
  %call30 = call i32 @priv_check_cred(%struct.ucred* %35, i32 56, i32 0) #5, !dbg !2831
  store i32 %call30, i32* %error, align 4, !dbg !2831
  %cmp31 = icmp ne i32 %call30, 0, !dbg !2831
  br i1 %cmp31, label %if.then32, label %if.end33, !dbg !2831

if.then32:                                        ; preds = %land.lhs.true29
  br label %fail, !dbg !2832

if.end33:                                         ; preds = %land.lhs.true29, %land.lhs.true26, %land.lhs.true23, %land.lhs.true21, %lor.lhs.false
  %36 = load i32* %egid, align 4, !dbg !2833
  %cmp34 = icmp ne i32 %36, -1, !dbg !2833
  br i1 %cmp34, label %land.lhs.true35, label %if.end40, !dbg !2833

land.lhs.true35:                                  ; preds = %if.end33
  %37 = load %struct.ucred** %oldcred, align 8, !dbg !2833
  %cr_groups36 = getelementptr inbounds %struct.ucred* %37, i32 0, i32 15, !dbg !2833
  %38 = load i32** %cr_groups36, align 8, !dbg !2833
  %arrayidx37 = getelementptr inbounds i32* %38, i64 0, !dbg !2833
  %39 = load i32* %arrayidx37, align 4, !dbg !2833
  %40 = load i32* %egid, align 4, !dbg !2833
  %cmp38 = icmp ne i32 %39, %40, !dbg !2833
  br i1 %cmp38, label %if.then39, label %if.end40, !dbg !2833

if.then39:                                        ; preds = %land.lhs.true35
  %41 = load %struct.ucred** %newcred, align 8, !dbg !2834
  %42 = load i32* %egid, align 4, !dbg !2834
  call void @change_egid(%struct.ucred* %41, i32 %42) #5, !dbg !2834
  %43 = load %struct.proc** %p, align 8, !dbg !2836
  call void @setsugid(%struct.proc* %43) #5, !dbg !2836
  br label %if.end40, !dbg !2837

if.end40:                                         ; preds = %if.then39, %land.lhs.true35, %if.end33
  %44 = load i32* %rgid, align 4, !dbg !2838
  %cmp41 = icmp ne i32 %44, -1, !dbg !2838
  br i1 %cmp41, label %land.lhs.true42, label %if.end46, !dbg !2838

land.lhs.true42:                                  ; preds = %if.end40
  %45 = load %struct.ucred** %oldcred, align 8, !dbg !2838
  %cr_rgid43 = getelementptr inbounds %struct.ucred* %45, i32 0, i32 5, !dbg !2838
  %46 = load i32* %cr_rgid43, align 4, !dbg !2838
  %47 = load i32* %rgid, align 4, !dbg !2838
  %cmp44 = icmp ne i32 %46, %47, !dbg !2838
  br i1 %cmp44, label %if.then45, label %if.end46, !dbg !2838

if.then45:                                        ; preds = %land.lhs.true42
  %48 = load %struct.ucred** %newcred, align 8, !dbg !2839
  %49 = load i32* %rgid, align 4, !dbg !2839
  call void @change_rgid(%struct.ucred* %48, i32 %49) #5, !dbg !2839
  %50 = load %struct.proc** %p, align 8, !dbg !2841
  call void @setsugid(%struct.proc* %50) #5, !dbg !2841
  br label %if.end46, !dbg !2842

if.end46:                                         ; preds = %if.then45, %land.lhs.true42, %if.end40
  %51 = load i32* %rgid, align 4, !dbg !2843
  %cmp47 = icmp ne i32 %51, -1, !dbg !2843
  br i1 %cmp47, label %land.lhs.true53, label %lor.lhs.false48, !dbg !2843

lor.lhs.false48:                                  ; preds = %if.end46
  %52 = load %struct.ucred** %newcred, align 8, !dbg !2843
  %cr_groups49 = getelementptr inbounds %struct.ucred* %52, i32 0, i32 15, !dbg !2843
  %53 = load i32** %cr_groups49, align 8, !dbg !2843
  %arrayidx50 = getelementptr inbounds i32* %53, i64 0, !dbg !2843
  %54 = load i32* %arrayidx50, align 4, !dbg !2843
  %55 = load %struct.ucred** %newcred, align 8, !dbg !2843
  %cr_rgid51 = getelementptr inbounds %struct.ucred* %55, i32 0, i32 5, !dbg !2843
  %56 = load i32* %cr_rgid51, align 4, !dbg !2843
  %cmp52 = icmp ne i32 %54, %56, !dbg !2843
  br i1 %cmp52, label %land.lhs.true53, label %if.end61, !dbg !2843

land.lhs.true53:                                  ; preds = %lor.lhs.false48, %if.end46
  %57 = load %struct.ucred** %newcred, align 8, !dbg !2843
  %cr_svgid54 = getelementptr inbounds %struct.ucred* %57, i32 0, i32 6, !dbg !2843
  %58 = load i32* %cr_svgid54, align 4, !dbg !2843
  %59 = load %struct.ucred** %newcred, align 8, !dbg !2843
  %cr_groups55 = getelementptr inbounds %struct.ucred* %59, i32 0, i32 15, !dbg !2843
  %60 = load i32** %cr_groups55, align 8, !dbg !2843
  %arrayidx56 = getelementptr inbounds i32* %60, i64 0, !dbg !2843
  %61 = load i32* %arrayidx56, align 4, !dbg !2843
  %cmp57 = icmp ne i32 %58, %61, !dbg !2843
  br i1 %cmp57, label %if.then58, label %if.end61, !dbg !2843

if.then58:                                        ; preds = %land.lhs.true53
  %62 = load %struct.ucred** %newcred, align 8, !dbg !2844
  %63 = load %struct.ucred** %newcred, align 8, !dbg !2844
  %cr_groups59 = getelementptr inbounds %struct.ucred* %63, i32 0, i32 15, !dbg !2844
  %64 = load i32** %cr_groups59, align 8, !dbg !2844
  %arrayidx60 = getelementptr inbounds i32* %64, i64 0, !dbg !2844
  %65 = load i32* %arrayidx60, align 4, !dbg !2844
  call void @change_svgid(%struct.ucred* %62, i32 %65) #5, !dbg !2844
  %66 = load %struct.proc** %p, align 8, !dbg !2846
  call void @setsugid(%struct.proc* %66) #5, !dbg !2846
  br label %if.end61, !dbg !2847

if.end61:                                         ; preds = %if.then58, %land.lhs.true53, %lor.lhs.false48
  %67 = load %struct.ucred** %newcred, align 8, !dbg !2848
  %68 = load %struct.proc** %p, align 8, !dbg !2848
  %p_ucred = getelementptr inbounds %struct.proc* %68, i32 0, i32 3, !dbg !2848
  store %struct.ucred* %67, %struct.ucred** %p_ucred, align 8, !dbg !2848
  %69 = load %struct.proc** %p, align 8, !dbg !2849
  %p_mtx62 = getelementptr inbounds %struct.proc* %69, i32 0, i32 18, !dbg !2849
  %mtx_lock63 = getelementptr inbounds %struct.mtx* %p_mtx62, i32 0, i32 1, !dbg !2849
  call void @__mtx_unlock_flags(i64* %mtx_lock63, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 997) #5, !dbg !2849
  %70 = load %struct.ucred** %oldcred, align 8, !dbg !2850
  call void @crfree(%struct.ucred* %70) #5, !dbg !2850
  store i32 0, i32* %retval, !dbg !2851
  br label %return, !dbg !2851

fail:                                             ; preds = %if.then32, %if.then15
  %71 = load %struct.proc** %p, align 8, !dbg !2852
  %p_mtx64 = getelementptr inbounds %struct.proc* %71, i32 0, i32 18, !dbg !2852
  %mtx_lock65 = getelementptr inbounds %struct.mtx* %p_mtx64, i32 0, i32 1, !dbg !2852
  call void @__mtx_unlock_flags(i64* %mtx_lock65, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 1002) #5, !dbg !2852
  %72 = load %struct.ucred** %newcred, align 8, !dbg !2853
  call void @crfree(%struct.ucred* %72) #5, !dbg !2853
  %73 = load i32* %error, align 4, !dbg !2854
  store i32 %73, i32* %retval, !dbg !2854
  br label %return, !dbg !2854

return:                                           ; preds = %fail, %if.end61
  %74 = load i32* %retval, !dbg !2855
  ret i32 %74, !dbg !2855
}

; Function Attrs: noimplicitfloat noredzone
declare void @audit_arg_rgid(i32) #2

; Function Attrs: noimplicitfloat noredzone
declare i32 @mac_cred_check_setregid(%struct.ucred*, i32, i32) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys_setresuid(%struct.thread* %td, %struct.setresuid_args* %uap) #0 {
entry:
  %retval = alloca i32, align 4
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.setresuid_args*, align 8
  %p = alloca %struct.proc*, align 8
  %newcred = alloca %struct.ucred*, align 8
  %oldcred = alloca %struct.ucred*, align 8
  %euid = alloca i32, align 4
  %ruid = alloca i32, align 4
  %suid = alloca i32, align 4
  %euip = alloca %struct.uidinfo*, align 8
  %ruip = alloca %struct.uidinfo*, align 8
  %error = alloca i32, align 4
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !2856), !dbg !2857
  store %struct.setresuid_args* %uap, %struct.setresuid_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.setresuid_args** %uap.addr}, metadata !2858), !dbg !2857
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p}, metadata !2859), !dbg !2860
  %0 = load %struct.thread** %td.addr, align 8, !dbg !2860
  %td_proc = getelementptr inbounds %struct.thread* %0, i32 0, i32 1, !dbg !2860
  %1 = load %struct.proc** %td_proc, align 8, !dbg !2860
  store %struct.proc* %1, %struct.proc** %p, align 8, !dbg !2860
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %newcred}, metadata !2861), !dbg !2862
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %oldcred}, metadata !2863), !dbg !2862
  call void @llvm.dbg.declare(metadata !{i32* %euid}, metadata !2864), !dbg !2865
  call void @llvm.dbg.declare(metadata !{i32* %ruid}, metadata !2866), !dbg !2865
  call void @llvm.dbg.declare(metadata !{i32* %suid}, metadata !2867), !dbg !2865
  call void @llvm.dbg.declare(metadata !{%struct.uidinfo** %euip}, metadata !2868), !dbg !2869
  call void @llvm.dbg.declare(metadata !{%struct.uidinfo** %ruip}, metadata !2870), !dbg !2869
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !2871), !dbg !2872
  %2 = load %struct.setresuid_args** %uap.addr, align 8, !dbg !2873
  %euid1 = getelementptr inbounds %struct.setresuid_args* %2, i32 0, i32 4, !dbg !2873
  %3 = load i32* %euid1, align 4, !dbg !2873
  store i32 %3, i32* %euid, align 4, !dbg !2873
  %4 = load %struct.setresuid_args** %uap.addr, align 8, !dbg !2874
  %ruid2 = getelementptr inbounds %struct.setresuid_args* %4, i32 0, i32 1, !dbg !2874
  %5 = load i32* %ruid2, align 4, !dbg !2874
  store i32 %5, i32* %ruid, align 4, !dbg !2874
  %6 = load %struct.setresuid_args** %uap.addr, align 8, !dbg !2875
  %suid3 = getelementptr inbounds %struct.setresuid_args* %6, i32 0, i32 7, !dbg !2875
  %7 = load i32* %suid3, align 4, !dbg !2875
  store i32 %7, i32* %suid, align 4, !dbg !2875
  br label %do.body, !dbg !2876

do.body:                                          ; preds = %entry
  %call = call %struct.thread* @__curthread() #6, !dbg !2877
  %td_pflags = getelementptr inbounds %struct.thread* %call, i32 0, i32 18, !dbg !2877
  %8 = load i32* %td_pflags, align 4, !dbg !2877
  %and = and i32 %8, 16777216, !dbg !2877
  %tobool = icmp ne i32 %and, 0, !dbg !2877
  br i1 %tobool, label %if.then, label %if.end, !dbg !2877

if.then:                                          ; preds = %do.body
  %9 = load i32* %euid, align 4, !dbg !2877
  call void @audit_arg_euid(i32 %9) #5, !dbg !2877
  br label %if.end, !dbg !2877

if.end:                                           ; preds = %if.then, %do.body
  br label %do.end, !dbg !2877

do.end:                                           ; preds = %if.end
  br label %do.body4, !dbg !2879

do.body4:                                         ; preds = %do.end
  %call5 = call %struct.thread* @__curthread() #6, !dbg !2880
  %td_pflags6 = getelementptr inbounds %struct.thread* %call5, i32 0, i32 18, !dbg !2880
  %10 = load i32* %td_pflags6, align 4, !dbg !2880
  %and7 = and i32 %10, 16777216, !dbg !2880
  %tobool8 = icmp ne i32 %and7, 0, !dbg !2880
  br i1 %tobool8, label %if.then9, label %if.end10, !dbg !2880

if.then9:                                         ; preds = %do.body4
  %11 = load i32* %ruid, align 4, !dbg !2880
  call void @audit_arg_ruid(i32 %11) #5, !dbg !2880
  br label %if.end10, !dbg !2880

if.end10:                                         ; preds = %if.then9, %do.body4
  br label %do.end11, !dbg !2880

do.end11:                                         ; preds = %if.end10
  br label %do.body12, !dbg !2882

do.body12:                                        ; preds = %do.end11
  %call13 = call %struct.thread* @__curthread() #6, !dbg !2883
  %td_pflags14 = getelementptr inbounds %struct.thread* %call13, i32 0, i32 18, !dbg !2883
  %12 = load i32* %td_pflags14, align 4, !dbg !2883
  %and15 = and i32 %12, 16777216, !dbg !2883
  %tobool16 = icmp ne i32 %and15, 0, !dbg !2883
  br i1 %tobool16, label %if.then17, label %if.end18, !dbg !2883

if.then17:                                        ; preds = %do.body12
  %13 = load i32* %suid, align 4, !dbg !2883
  call void @audit_arg_suid(i32 %13) #5, !dbg !2883
  br label %if.end18, !dbg !2883

if.end18:                                         ; preds = %if.then17, %do.body12
  br label %do.end19, !dbg !2883

do.end19:                                         ; preds = %if.end18
  %call20 = call %struct.ucred* @crget() #5, !dbg !2885
  store %struct.ucred* %call20, %struct.ucred** %newcred, align 8, !dbg !2885
  %14 = load i32* %euid, align 4, !dbg !2886
  %call21 = call %struct.uidinfo* @uifind(i32 %14) #5, !dbg !2886
  store %struct.uidinfo* %call21, %struct.uidinfo** %euip, align 8, !dbg !2886
  %15 = load i32* %ruid, align 4, !dbg !2887
  %call22 = call %struct.uidinfo* @uifind(i32 %15) #5, !dbg !2887
  store %struct.uidinfo* %call22, %struct.uidinfo** %ruip, align 8, !dbg !2887
  %16 = load %struct.proc** %p, align 8, !dbg !2888
  %p_mtx = getelementptr inbounds %struct.proc* %16, i32 0, i32 18, !dbg !2888
  %mtx_lock = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !2888
  call void @__mtx_lock_flags(i64* %mtx_lock, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 1037) #5, !dbg !2888
  %17 = load %struct.proc** %p, align 8, !dbg !2889
  %18 = load %struct.ucred** %newcred, align 8, !dbg !2889
  %call23 = call %struct.ucred* @crcopysafe(%struct.proc* %17, %struct.ucred* %18) #5, !dbg !2889
  store %struct.ucred* %call23, %struct.ucred** %oldcred, align 8, !dbg !2889
  %19 = load %struct.ucred** %oldcred, align 8, !dbg !2890
  %20 = load i32* %ruid, align 4, !dbg !2890
  %21 = load i32* %euid, align 4, !dbg !2890
  %22 = load i32* %suid, align 4, !dbg !2890
  %call24 = call i32 @mac_cred_check_setresuid(%struct.ucred* %19, i32 %20, i32 %21, i32 %22) #5, !dbg !2890
  store i32 %call24, i32* %error, align 4, !dbg !2890
  %23 = load i32* %error, align 4, !dbg !2891
  %tobool25 = icmp ne i32 %23, 0, !dbg !2891
  br i1 %tobool25, label %if.then26, label %if.end27, !dbg !2891

if.then26:                                        ; preds = %do.end19
  br label %fail, !dbg !2892

if.end27:                                         ; preds = %do.end19
  %24 = load i32* %ruid, align 4, !dbg !2893
  %cmp = icmp ne i32 %24, -1, !dbg !2893
  br i1 %cmp, label %land.lhs.true, label %lor.lhs.false, !dbg !2893

land.lhs.true:                                    ; preds = %if.end27
  %25 = load i32* %ruid, align 4, !dbg !2893
  %26 = load %struct.ucred** %oldcred, align 8, !dbg !2893
  %cr_ruid = getelementptr inbounds %struct.ucred* %26, i32 0, i32 2, !dbg !2893
  %27 = load i32* %cr_ruid, align 4, !dbg !2893
  %cmp28 = icmp ne i32 %25, %27, !dbg !2893
  br i1 %cmp28, label %land.lhs.true29, label %lor.lhs.false, !dbg !2893

land.lhs.true29:                                  ; preds = %land.lhs.true
  %28 = load i32* %ruid, align 4, !dbg !2893
  %29 = load %struct.ucred** %oldcred, align 8, !dbg !2893
  %cr_svuid = getelementptr inbounds %struct.ucred* %29, i32 0, i32 3, !dbg !2893
  %30 = load i32* %cr_svuid, align 4, !dbg !2893
  %cmp30 = icmp ne i32 %28, %30, !dbg !2893
  br i1 %cmp30, label %land.lhs.true31, label %lor.lhs.false, !dbg !2893

land.lhs.true31:                                  ; preds = %land.lhs.true29
  %31 = load i32* %ruid, align 4, !dbg !2893
  %32 = load %struct.ucred** %oldcred, align 8, !dbg !2893
  %cr_uid = getelementptr inbounds %struct.ucred* %32, i32 0, i32 1, !dbg !2893
  %33 = load i32* %cr_uid, align 4, !dbg !2893
  %cmp32 = icmp ne i32 %31, %33, !dbg !2893
  br i1 %cmp32, label %land.lhs.true54, label %lor.lhs.false, !dbg !2893

lor.lhs.false:                                    ; preds = %land.lhs.true31, %land.lhs.true29, %land.lhs.true, %if.end27
  %34 = load i32* %euid, align 4, !dbg !2893
  %cmp33 = icmp ne i32 %34, -1, !dbg !2893
  br i1 %cmp33, label %land.lhs.true34, label %lor.lhs.false43, !dbg !2893

land.lhs.true34:                                  ; preds = %lor.lhs.false
  %35 = load i32* %euid, align 4, !dbg !2893
  %36 = load %struct.ucred** %oldcred, align 8, !dbg !2893
  %cr_ruid35 = getelementptr inbounds %struct.ucred* %36, i32 0, i32 2, !dbg !2893
  %37 = load i32* %cr_ruid35, align 4, !dbg !2893
  %cmp36 = icmp ne i32 %35, %37, !dbg !2893
  br i1 %cmp36, label %land.lhs.true37, label %lor.lhs.false43, !dbg !2893

land.lhs.true37:                                  ; preds = %land.lhs.true34
  %38 = load i32* %euid, align 4, !dbg !2893
  %39 = load %struct.ucred** %oldcred, align 8, !dbg !2893
  %cr_svuid38 = getelementptr inbounds %struct.ucred* %39, i32 0, i32 3, !dbg !2893
  %40 = load i32* %cr_svuid38, align 4, !dbg !2893
  %cmp39 = icmp ne i32 %38, %40, !dbg !2893
  br i1 %cmp39, label %land.lhs.true40, label %lor.lhs.false43, !dbg !2893

land.lhs.true40:                                  ; preds = %land.lhs.true37
  %41 = load i32* %euid, align 4, !dbg !2893
  %42 = load %struct.ucred** %oldcred, align 8, !dbg !2893
  %cr_uid41 = getelementptr inbounds %struct.ucred* %42, i32 0, i32 1, !dbg !2893
  %43 = load i32* %cr_uid41, align 4, !dbg !2893
  %cmp42 = icmp ne i32 %41, %43, !dbg !2893
  br i1 %cmp42, label %land.lhs.true54, label %lor.lhs.false43, !dbg !2893

lor.lhs.false43:                                  ; preds = %land.lhs.true40, %land.lhs.true37, %land.lhs.true34, %lor.lhs.false
  %44 = load i32* %suid, align 4, !dbg !2893
  %cmp44 = icmp ne i32 %44, -1, !dbg !2893
  br i1 %cmp44, label %land.lhs.true45, label %if.end58, !dbg !2893

land.lhs.true45:                                  ; preds = %lor.lhs.false43
  %45 = load i32* %suid, align 4, !dbg !2893
  %46 = load %struct.ucred** %oldcred, align 8, !dbg !2893
  %cr_ruid46 = getelementptr inbounds %struct.ucred* %46, i32 0, i32 2, !dbg !2893
  %47 = load i32* %cr_ruid46, align 4, !dbg !2893
  %cmp47 = icmp ne i32 %45, %47, !dbg !2893
  br i1 %cmp47, label %land.lhs.true48, label %if.end58, !dbg !2893

land.lhs.true48:                                  ; preds = %land.lhs.true45
  %48 = load i32* %suid, align 4, !dbg !2893
  %49 = load %struct.ucred** %oldcred, align 8, !dbg !2893
  %cr_svuid49 = getelementptr inbounds %struct.ucred* %49, i32 0, i32 3, !dbg !2893
  %50 = load i32* %cr_svuid49, align 4, !dbg !2893
  %cmp50 = icmp ne i32 %48, %50, !dbg !2893
  br i1 %cmp50, label %land.lhs.true51, label %if.end58, !dbg !2893

land.lhs.true51:                                  ; preds = %land.lhs.true48
  %51 = load i32* %suid, align 4, !dbg !2893
  %52 = load %struct.ucred** %oldcred, align 8, !dbg !2893
  %cr_uid52 = getelementptr inbounds %struct.ucred* %52, i32 0, i32 1, !dbg !2893
  %53 = load i32* %cr_uid52, align 4, !dbg !2893
  %cmp53 = icmp ne i32 %51, %53, !dbg !2893
  br i1 %cmp53, label %land.lhs.true54, label %if.end58, !dbg !2893

land.lhs.true54:                                  ; preds = %land.lhs.true51, %land.lhs.true40, %land.lhs.true31
  %54 = load %struct.ucred** %oldcred, align 8, !dbg !2894
  %call55 = call i32 @priv_check_cred(%struct.ucred* %54, i32 57, i32 0) #5, !dbg !2894
  store i32 %call55, i32* %error, align 4, !dbg !2894
  %cmp56 = icmp ne i32 %call55, 0, !dbg !2894
  br i1 %cmp56, label %if.then57, label %if.end58, !dbg !2894

if.then57:                                        ; preds = %land.lhs.true54
  br label %fail, !dbg !2895

if.end58:                                         ; preds = %land.lhs.true54, %land.lhs.true51, %land.lhs.true48, %land.lhs.true45, %lor.lhs.false43
  %55 = load i32* %euid, align 4, !dbg !2896
  %cmp59 = icmp ne i32 %55, -1, !dbg !2896
  br i1 %cmp59, label %land.lhs.true60, label %if.end64, !dbg !2896

land.lhs.true60:                                  ; preds = %if.end58
  %56 = load %struct.ucred** %oldcred, align 8, !dbg !2896
  %cr_uid61 = getelementptr inbounds %struct.ucred* %56, i32 0, i32 1, !dbg !2896
  %57 = load i32* %cr_uid61, align 4, !dbg !2896
  %58 = load i32* %euid, align 4, !dbg !2896
  %cmp62 = icmp ne i32 %57, %58, !dbg !2896
  br i1 %cmp62, label %if.then63, label %if.end64, !dbg !2896

if.then63:                                        ; preds = %land.lhs.true60
  %59 = load %struct.ucred** %newcred, align 8, !dbg !2897
  %60 = load %struct.uidinfo** %euip, align 8, !dbg !2897
  call void @change_euid(%struct.ucred* %59, %struct.uidinfo* %60) #5, !dbg !2897
  %61 = load %struct.proc** %p, align 8, !dbg !2899
  call void @setsugid(%struct.proc* %61) #5, !dbg !2899
  br label %if.end64, !dbg !2900

if.end64:                                         ; preds = %if.then63, %land.lhs.true60, %if.end58
  %62 = load i32* %ruid, align 4, !dbg !2901
  %cmp65 = icmp ne i32 %62, -1, !dbg !2901
  br i1 %cmp65, label %land.lhs.true66, label %if.end70, !dbg !2901

land.lhs.true66:                                  ; preds = %if.end64
  %63 = load %struct.ucred** %oldcred, align 8, !dbg !2901
  %cr_ruid67 = getelementptr inbounds %struct.ucred* %63, i32 0, i32 2, !dbg !2901
  %64 = load i32* %cr_ruid67, align 4, !dbg !2901
  %65 = load i32* %ruid, align 4, !dbg !2901
  %cmp68 = icmp ne i32 %64, %65, !dbg !2901
  br i1 %cmp68, label %if.then69, label %if.end70, !dbg !2901

if.then69:                                        ; preds = %land.lhs.true66
  %66 = load %struct.ucred** %newcred, align 8, !dbg !2902
  %67 = load %struct.uidinfo** %ruip, align 8, !dbg !2902
  call void @change_ruid(%struct.ucred* %66, %struct.uidinfo* %67) #5, !dbg !2902
  %68 = load %struct.proc** %p, align 8, !dbg !2904
  call void @setsugid(%struct.proc* %68) #5, !dbg !2904
  br label %if.end70, !dbg !2905

if.end70:                                         ; preds = %if.then69, %land.lhs.true66, %if.end64
  %69 = load i32* %suid, align 4, !dbg !2906
  %cmp71 = icmp ne i32 %69, -1, !dbg !2906
  br i1 %cmp71, label %land.lhs.true72, label %if.end76, !dbg !2906

land.lhs.true72:                                  ; preds = %if.end70
  %70 = load %struct.ucred** %oldcred, align 8, !dbg !2906
  %cr_svuid73 = getelementptr inbounds %struct.ucred* %70, i32 0, i32 3, !dbg !2906
  %71 = load i32* %cr_svuid73, align 4, !dbg !2906
  %72 = load i32* %suid, align 4, !dbg !2906
  %cmp74 = icmp ne i32 %71, %72, !dbg !2906
  br i1 %cmp74, label %if.then75, label %if.end76, !dbg !2906

if.then75:                                        ; preds = %land.lhs.true72
  %73 = load %struct.ucred** %newcred, align 8, !dbg !2907
  %74 = load i32* %suid, align 4, !dbg !2907
  call void @change_svuid(%struct.ucred* %73, i32 %74) #5, !dbg !2907
  %75 = load %struct.proc** %p, align 8, !dbg !2909
  call void @setsugid(%struct.proc* %75) #5, !dbg !2909
  br label %if.end76, !dbg !2910

if.end76:                                         ; preds = %if.then75, %land.lhs.true72, %if.end70
  %76 = load %struct.ucred** %newcred, align 8, !dbg !2911
  %77 = load %struct.proc** %p, align 8, !dbg !2911
  %p_ucred = getelementptr inbounds %struct.proc* %77, i32 0, i32 3, !dbg !2911
  store %struct.ucred* %76, %struct.ucred** %p_ucred, align 8, !dbg !2911
  %78 = load %struct.proc** %p, align 8, !dbg !2912
  %p_mtx77 = getelementptr inbounds %struct.proc* %78, i32 0, i32 18, !dbg !2912
  %mtx_lock78 = getelementptr inbounds %struct.mtx* %p_mtx77, i32 0, i32 1, !dbg !2912
  call void @__mtx_unlock_flags(i64* %mtx_lock78, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 1071) #5, !dbg !2912
  %79 = load %struct.uidinfo** %ruip, align 8, !dbg !2913
  call void @uifree(%struct.uidinfo* %79) #5, !dbg !2913
  %80 = load %struct.uidinfo** %euip, align 8, !dbg !2914
  call void @uifree(%struct.uidinfo* %80) #5, !dbg !2914
  %81 = load %struct.ucred** %oldcred, align 8, !dbg !2915
  call void @crfree(%struct.ucred* %81) #5, !dbg !2915
  store i32 0, i32* %retval, !dbg !2916
  br label %return, !dbg !2916

fail:                                             ; preds = %if.then57, %if.then26
  %82 = load %struct.proc** %p, align 8, !dbg !2917
  %p_mtx79 = getelementptr inbounds %struct.proc* %82, i32 0, i32 18, !dbg !2917
  %mtx_lock80 = getelementptr inbounds %struct.mtx* %p_mtx79, i32 0, i32 1, !dbg !2917
  call void @__mtx_unlock_flags(i64* %mtx_lock80, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 1081) #5, !dbg !2917
  %83 = load %struct.uidinfo** %ruip, align 8, !dbg !2918
  call void @uifree(%struct.uidinfo* %83) #5, !dbg !2918
  %84 = load %struct.uidinfo** %euip, align 8, !dbg !2919
  call void @uifree(%struct.uidinfo* %84) #5, !dbg !2919
  %85 = load %struct.ucred** %newcred, align 8, !dbg !2920
  call void @crfree(%struct.ucred* %85) #5, !dbg !2920
  %86 = load i32* %error, align 4, !dbg !2921
  store i32 %86, i32* %retval, !dbg !2921
  br label %return, !dbg !2921

return:                                           ; preds = %fail, %if.end76
  %87 = load i32* %retval, !dbg !2922
  ret i32 %87, !dbg !2922
}

; Function Attrs: noimplicitfloat noredzone
declare void @audit_arg_suid(i32) #2

; Function Attrs: noimplicitfloat noredzone
declare i32 @mac_cred_check_setresuid(%struct.ucred*, i32, i32, i32) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys_setresgid(%struct.thread* %td, %struct.setresgid_args* %uap) #0 {
entry:
  %retval = alloca i32, align 4
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.setresgid_args*, align 8
  %p = alloca %struct.proc*, align 8
  %newcred = alloca %struct.ucred*, align 8
  %oldcred = alloca %struct.ucred*, align 8
  %egid = alloca i32, align 4
  %rgid = alloca i32, align 4
  %sgid = alloca i32, align 4
  %error = alloca i32, align 4
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !2923), !dbg !2924
  store %struct.setresgid_args* %uap, %struct.setresgid_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.setresgid_args** %uap.addr}, metadata !2925), !dbg !2924
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p}, metadata !2926), !dbg !2927
  %0 = load %struct.thread** %td.addr, align 8, !dbg !2927
  %td_proc = getelementptr inbounds %struct.thread* %0, i32 0, i32 1, !dbg !2927
  %1 = load %struct.proc** %td_proc, align 8, !dbg !2927
  store %struct.proc* %1, %struct.proc** %p, align 8, !dbg !2927
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %newcred}, metadata !2928), !dbg !2929
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %oldcred}, metadata !2930), !dbg !2929
  call void @llvm.dbg.declare(metadata !{i32* %egid}, metadata !2931), !dbg !2932
  call void @llvm.dbg.declare(metadata !{i32* %rgid}, metadata !2933), !dbg !2932
  call void @llvm.dbg.declare(metadata !{i32* %sgid}, metadata !2934), !dbg !2932
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !2935), !dbg !2936
  %2 = load %struct.setresgid_args** %uap.addr, align 8, !dbg !2937
  %egid1 = getelementptr inbounds %struct.setresgid_args* %2, i32 0, i32 4, !dbg !2937
  %3 = load i32* %egid1, align 4, !dbg !2937
  store i32 %3, i32* %egid, align 4, !dbg !2937
  %4 = load %struct.setresgid_args** %uap.addr, align 8, !dbg !2938
  %rgid2 = getelementptr inbounds %struct.setresgid_args* %4, i32 0, i32 1, !dbg !2938
  %5 = load i32* %rgid2, align 4, !dbg !2938
  store i32 %5, i32* %rgid, align 4, !dbg !2938
  %6 = load %struct.setresgid_args** %uap.addr, align 8, !dbg !2939
  %sgid3 = getelementptr inbounds %struct.setresgid_args* %6, i32 0, i32 7, !dbg !2939
  %7 = load i32* %sgid3, align 4, !dbg !2939
  store i32 %7, i32* %sgid, align 4, !dbg !2939
  br label %do.body, !dbg !2940

do.body:                                          ; preds = %entry
  %call = call %struct.thread* @__curthread() #6, !dbg !2941
  %td_pflags = getelementptr inbounds %struct.thread* %call, i32 0, i32 18, !dbg !2941
  %8 = load i32* %td_pflags, align 4, !dbg !2941
  %and = and i32 %8, 16777216, !dbg !2941
  %tobool = icmp ne i32 %and, 0, !dbg !2941
  br i1 %tobool, label %if.then, label %if.end, !dbg !2941

if.then:                                          ; preds = %do.body
  %9 = load i32* %egid, align 4, !dbg !2941
  call void @audit_arg_egid(i32 %9) #5, !dbg !2941
  br label %if.end, !dbg !2941

if.end:                                           ; preds = %if.then, %do.body
  br label %do.end, !dbg !2941

do.end:                                           ; preds = %if.end
  br label %do.body4, !dbg !2943

do.body4:                                         ; preds = %do.end
  %call5 = call %struct.thread* @__curthread() #6, !dbg !2944
  %td_pflags6 = getelementptr inbounds %struct.thread* %call5, i32 0, i32 18, !dbg !2944
  %10 = load i32* %td_pflags6, align 4, !dbg !2944
  %and7 = and i32 %10, 16777216, !dbg !2944
  %tobool8 = icmp ne i32 %and7, 0, !dbg !2944
  br i1 %tobool8, label %if.then9, label %if.end10, !dbg !2944

if.then9:                                         ; preds = %do.body4
  %11 = load i32* %rgid, align 4, !dbg !2944
  call void @audit_arg_rgid(i32 %11) #5, !dbg !2944
  br label %if.end10, !dbg !2944

if.end10:                                         ; preds = %if.then9, %do.body4
  br label %do.end11, !dbg !2944

do.end11:                                         ; preds = %if.end10
  br label %do.body12, !dbg !2946

do.body12:                                        ; preds = %do.end11
  %call13 = call %struct.thread* @__curthread() #6, !dbg !2947
  %td_pflags14 = getelementptr inbounds %struct.thread* %call13, i32 0, i32 18, !dbg !2947
  %12 = load i32* %td_pflags14, align 4, !dbg !2947
  %and15 = and i32 %12, 16777216, !dbg !2947
  %tobool16 = icmp ne i32 %and15, 0, !dbg !2947
  br i1 %tobool16, label %if.then17, label %if.end18, !dbg !2947

if.then17:                                        ; preds = %do.body12
  %13 = load i32* %sgid, align 4, !dbg !2947
  call void @audit_arg_sgid(i32 %13) #5, !dbg !2947
  br label %if.end18, !dbg !2947

if.end18:                                         ; preds = %if.then17, %do.body12
  br label %do.end19, !dbg !2947

do.end19:                                         ; preds = %if.end18
  %call20 = call %struct.ucred* @crget() #5, !dbg !2949
  store %struct.ucred* %call20, %struct.ucred** %newcred, align 8, !dbg !2949
  %14 = load %struct.proc** %p, align 8, !dbg !2950
  %p_mtx = getelementptr inbounds %struct.proc* %14, i32 0, i32 18, !dbg !2950
  %mtx_lock = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !2950
  call void @__mtx_lock_flags(i64* %mtx_lock, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 1116) #5, !dbg !2950
  %15 = load %struct.proc** %p, align 8, !dbg !2951
  %16 = load %struct.ucred** %newcred, align 8, !dbg !2951
  %call21 = call %struct.ucred* @crcopysafe(%struct.proc* %15, %struct.ucred* %16) #5, !dbg !2951
  store %struct.ucred* %call21, %struct.ucred** %oldcred, align 8, !dbg !2951
  %17 = load %struct.ucred** %oldcred, align 8, !dbg !2952
  %18 = load i32* %rgid, align 4, !dbg !2952
  %19 = load i32* %egid, align 4, !dbg !2952
  %20 = load i32* %sgid, align 4, !dbg !2952
  %call22 = call i32 @mac_cred_check_setresgid(%struct.ucred* %17, i32 %18, i32 %19, i32 %20) #5, !dbg !2952
  store i32 %call22, i32* %error, align 4, !dbg !2952
  %21 = load i32* %error, align 4, !dbg !2953
  %tobool23 = icmp ne i32 %21, 0, !dbg !2953
  br i1 %tobool23, label %if.then24, label %if.end25, !dbg !2953

if.then24:                                        ; preds = %do.end19
  br label %fail, !dbg !2954

if.end25:                                         ; preds = %do.end19
  %22 = load i32* %rgid, align 4, !dbg !2955
  %cmp = icmp ne i32 %22, -1, !dbg !2955
  br i1 %cmp, label %land.lhs.true, label %lor.lhs.false, !dbg !2955

land.lhs.true:                                    ; preds = %if.end25
  %23 = load i32* %rgid, align 4, !dbg !2955
  %24 = load %struct.ucred** %oldcred, align 8, !dbg !2955
  %cr_rgid = getelementptr inbounds %struct.ucred* %24, i32 0, i32 5, !dbg !2955
  %25 = load i32* %cr_rgid, align 4, !dbg !2955
  %cmp26 = icmp ne i32 %23, %25, !dbg !2955
  br i1 %cmp26, label %land.lhs.true27, label %lor.lhs.false, !dbg !2955

land.lhs.true27:                                  ; preds = %land.lhs.true
  %26 = load i32* %rgid, align 4, !dbg !2955
  %27 = load %struct.ucred** %oldcred, align 8, !dbg !2955
  %cr_svgid = getelementptr inbounds %struct.ucred* %27, i32 0, i32 6, !dbg !2955
  %28 = load i32* %cr_svgid, align 4, !dbg !2955
  %cmp28 = icmp ne i32 %26, %28, !dbg !2955
  br i1 %cmp28, label %land.lhs.true29, label %lor.lhs.false, !dbg !2955

land.lhs.true29:                                  ; preds = %land.lhs.true27
  %29 = load i32* %rgid, align 4, !dbg !2955
  %30 = load %struct.ucred** %oldcred, align 8, !dbg !2955
  %cr_groups = getelementptr inbounds %struct.ucred* %30, i32 0, i32 15, !dbg !2955
  %31 = load i32** %cr_groups, align 8, !dbg !2955
  %arrayidx = getelementptr inbounds i32* %31, i64 0, !dbg !2955
  %32 = load i32* %arrayidx, align 4, !dbg !2955
  %cmp30 = icmp ne i32 %29, %32, !dbg !2955
  br i1 %cmp30, label %land.lhs.true54, label %lor.lhs.false, !dbg !2955

lor.lhs.false:                                    ; preds = %land.lhs.true29, %land.lhs.true27, %land.lhs.true, %if.end25
  %33 = load i32* %egid, align 4, !dbg !2955
  %cmp31 = icmp ne i32 %33, -1, !dbg !2955
  br i1 %cmp31, label %land.lhs.true32, label %lor.lhs.false42, !dbg !2955

land.lhs.true32:                                  ; preds = %lor.lhs.false
  %34 = load i32* %egid, align 4, !dbg !2955
  %35 = load %struct.ucred** %oldcred, align 8, !dbg !2955
  %cr_rgid33 = getelementptr inbounds %struct.ucred* %35, i32 0, i32 5, !dbg !2955
  %36 = load i32* %cr_rgid33, align 4, !dbg !2955
  %cmp34 = icmp ne i32 %34, %36, !dbg !2955
  br i1 %cmp34, label %land.lhs.true35, label %lor.lhs.false42, !dbg !2955

land.lhs.true35:                                  ; preds = %land.lhs.true32
  %37 = load i32* %egid, align 4, !dbg !2955
  %38 = load %struct.ucred** %oldcred, align 8, !dbg !2955
  %cr_svgid36 = getelementptr inbounds %struct.ucred* %38, i32 0, i32 6, !dbg !2955
  %39 = load i32* %cr_svgid36, align 4, !dbg !2955
  %cmp37 = icmp ne i32 %37, %39, !dbg !2955
  br i1 %cmp37, label %land.lhs.true38, label %lor.lhs.false42, !dbg !2955

land.lhs.true38:                                  ; preds = %land.lhs.true35
  %40 = load i32* %egid, align 4, !dbg !2955
  %41 = load %struct.ucred** %oldcred, align 8, !dbg !2955
  %cr_groups39 = getelementptr inbounds %struct.ucred* %41, i32 0, i32 15, !dbg !2955
  %42 = load i32** %cr_groups39, align 8, !dbg !2955
  %arrayidx40 = getelementptr inbounds i32* %42, i64 0, !dbg !2955
  %43 = load i32* %arrayidx40, align 4, !dbg !2955
  %cmp41 = icmp ne i32 %40, %43, !dbg !2955
  br i1 %cmp41, label %land.lhs.true54, label %lor.lhs.false42, !dbg !2955

lor.lhs.false42:                                  ; preds = %land.lhs.true38, %land.lhs.true35, %land.lhs.true32, %lor.lhs.false
  %44 = load i32* %sgid, align 4, !dbg !2955
  %cmp43 = icmp ne i32 %44, -1, !dbg !2955
  br i1 %cmp43, label %land.lhs.true44, label %if.end58, !dbg !2955

land.lhs.true44:                                  ; preds = %lor.lhs.false42
  %45 = load i32* %sgid, align 4, !dbg !2955
  %46 = load %struct.ucred** %oldcred, align 8, !dbg !2955
  %cr_rgid45 = getelementptr inbounds %struct.ucred* %46, i32 0, i32 5, !dbg !2955
  %47 = load i32* %cr_rgid45, align 4, !dbg !2955
  %cmp46 = icmp ne i32 %45, %47, !dbg !2955
  br i1 %cmp46, label %land.lhs.true47, label %if.end58, !dbg !2955

land.lhs.true47:                                  ; preds = %land.lhs.true44
  %48 = load i32* %sgid, align 4, !dbg !2955
  %49 = load %struct.ucred** %oldcred, align 8, !dbg !2955
  %cr_svgid48 = getelementptr inbounds %struct.ucred* %49, i32 0, i32 6, !dbg !2955
  %50 = load i32* %cr_svgid48, align 4, !dbg !2955
  %cmp49 = icmp ne i32 %48, %50, !dbg !2955
  br i1 %cmp49, label %land.lhs.true50, label %if.end58, !dbg !2955

land.lhs.true50:                                  ; preds = %land.lhs.true47
  %51 = load i32* %sgid, align 4, !dbg !2955
  %52 = load %struct.ucred** %oldcred, align 8, !dbg !2955
  %cr_groups51 = getelementptr inbounds %struct.ucred* %52, i32 0, i32 15, !dbg !2955
  %53 = load i32** %cr_groups51, align 8, !dbg !2955
  %arrayidx52 = getelementptr inbounds i32* %53, i64 0, !dbg !2955
  %54 = load i32* %arrayidx52, align 4, !dbg !2955
  %cmp53 = icmp ne i32 %51, %54, !dbg !2955
  br i1 %cmp53, label %land.lhs.true54, label %if.end58, !dbg !2955

land.lhs.true54:                                  ; preds = %land.lhs.true50, %land.lhs.true38, %land.lhs.true29
  %55 = load %struct.ucred** %oldcred, align 8, !dbg !2956
  %call55 = call i32 @priv_check_cred(%struct.ucred* %55, i32 58, i32 0) #5, !dbg !2956
  store i32 %call55, i32* %error, align 4, !dbg !2956
  %cmp56 = icmp ne i32 %call55, 0, !dbg !2956
  br i1 %cmp56, label %if.then57, label %if.end58, !dbg !2956

if.then57:                                        ; preds = %land.lhs.true54
  br label %fail, !dbg !2957

if.end58:                                         ; preds = %land.lhs.true54, %land.lhs.true50, %land.lhs.true47, %land.lhs.true44, %lor.lhs.false42
  %56 = load i32* %egid, align 4, !dbg !2958
  %cmp59 = icmp ne i32 %56, -1, !dbg !2958
  br i1 %cmp59, label %land.lhs.true60, label %if.end65, !dbg !2958

land.lhs.true60:                                  ; preds = %if.end58
  %57 = load %struct.ucred** %oldcred, align 8, !dbg !2958
  %cr_groups61 = getelementptr inbounds %struct.ucred* %57, i32 0, i32 15, !dbg !2958
  %58 = load i32** %cr_groups61, align 8, !dbg !2958
  %arrayidx62 = getelementptr inbounds i32* %58, i64 0, !dbg !2958
  %59 = load i32* %arrayidx62, align 4, !dbg !2958
  %60 = load i32* %egid, align 4, !dbg !2958
  %cmp63 = icmp ne i32 %59, %60, !dbg !2958
  br i1 %cmp63, label %if.then64, label %if.end65, !dbg !2958

if.then64:                                        ; preds = %land.lhs.true60
  %61 = load %struct.ucred** %newcred, align 8, !dbg !2959
  %62 = load i32* %egid, align 4, !dbg !2959
  call void @change_egid(%struct.ucred* %61, i32 %62) #5, !dbg !2959
  %63 = load %struct.proc** %p, align 8, !dbg !2961
  call void @setsugid(%struct.proc* %63) #5, !dbg !2961
  br label %if.end65, !dbg !2962

if.end65:                                         ; preds = %if.then64, %land.lhs.true60, %if.end58
  %64 = load i32* %rgid, align 4, !dbg !2963
  %cmp66 = icmp ne i32 %64, -1, !dbg !2963
  br i1 %cmp66, label %land.lhs.true67, label %if.end71, !dbg !2963

land.lhs.true67:                                  ; preds = %if.end65
  %65 = load %struct.ucred** %oldcred, align 8, !dbg !2963
  %cr_rgid68 = getelementptr inbounds %struct.ucred* %65, i32 0, i32 5, !dbg !2963
  %66 = load i32* %cr_rgid68, align 4, !dbg !2963
  %67 = load i32* %rgid, align 4, !dbg !2963
  %cmp69 = icmp ne i32 %66, %67, !dbg !2963
  br i1 %cmp69, label %if.then70, label %if.end71, !dbg !2963

if.then70:                                        ; preds = %land.lhs.true67
  %68 = load %struct.ucred** %newcred, align 8, !dbg !2964
  %69 = load i32* %rgid, align 4, !dbg !2964
  call void @change_rgid(%struct.ucred* %68, i32 %69) #5, !dbg !2964
  %70 = load %struct.proc** %p, align 8, !dbg !2966
  call void @setsugid(%struct.proc* %70) #5, !dbg !2966
  br label %if.end71, !dbg !2967

if.end71:                                         ; preds = %if.then70, %land.lhs.true67, %if.end65
  %71 = load i32* %sgid, align 4, !dbg !2968
  %cmp72 = icmp ne i32 %71, -1, !dbg !2968
  br i1 %cmp72, label %land.lhs.true73, label %if.end77, !dbg !2968

land.lhs.true73:                                  ; preds = %if.end71
  %72 = load %struct.ucred** %oldcred, align 8, !dbg !2968
  %cr_svgid74 = getelementptr inbounds %struct.ucred* %72, i32 0, i32 6, !dbg !2968
  %73 = load i32* %cr_svgid74, align 4, !dbg !2968
  %74 = load i32* %sgid, align 4, !dbg !2968
  %cmp75 = icmp ne i32 %73, %74, !dbg !2968
  br i1 %cmp75, label %if.then76, label %if.end77, !dbg !2968

if.then76:                                        ; preds = %land.lhs.true73
  %75 = load %struct.ucred** %newcred, align 8, !dbg !2969
  %76 = load i32* %sgid, align 4, !dbg !2969
  call void @change_svgid(%struct.ucred* %75, i32 %76) #5, !dbg !2969
  %77 = load %struct.proc** %p, align 8, !dbg !2971
  call void @setsugid(%struct.proc* %77) #5, !dbg !2971
  br label %if.end77, !dbg !2972

if.end77:                                         ; preds = %if.then76, %land.lhs.true73, %if.end71
  %78 = load %struct.ucred** %newcred, align 8, !dbg !2973
  %79 = load %struct.proc** %p, align 8, !dbg !2973
  %p_ucred = getelementptr inbounds %struct.proc* %79, i32 0, i32 3, !dbg !2973
  store %struct.ucred* %78, %struct.ucred** %p_ucred, align 8, !dbg !2973
  %80 = load %struct.proc** %p, align 8, !dbg !2974
  %p_mtx78 = getelementptr inbounds %struct.proc* %80, i32 0, i32 18, !dbg !2974
  %mtx_lock79 = getelementptr inbounds %struct.mtx* %p_mtx78, i32 0, i32 1, !dbg !2974
  call void @__mtx_unlock_flags(i64* %mtx_lock79, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 1150) #5, !dbg !2974
  %81 = load %struct.ucred** %oldcred, align 8, !dbg !2975
  call void @crfree(%struct.ucred* %81) #5, !dbg !2975
  store i32 0, i32* %retval, !dbg !2976
  br label %return, !dbg !2976

fail:                                             ; preds = %if.then57, %if.then24
  %82 = load %struct.proc** %p, align 8, !dbg !2977
  %p_mtx80 = getelementptr inbounds %struct.proc* %82, i32 0, i32 18, !dbg !2977
  %mtx_lock81 = getelementptr inbounds %struct.mtx* %p_mtx80, i32 0, i32 1, !dbg !2977
  call void @__mtx_unlock_flags(i64* %mtx_lock81, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 1155) #5, !dbg !2977
  %83 = load %struct.ucred** %newcred, align 8, !dbg !2978
  call void @crfree(%struct.ucred* %83) #5, !dbg !2978
  %84 = load i32* %error, align 4, !dbg !2979
  store i32 %84, i32* %retval, !dbg !2979
  br label %return, !dbg !2979

return:                                           ; preds = %fail, %if.end77
  %85 = load i32* %retval, !dbg !2980
  ret i32 %85, !dbg !2980
}

; Function Attrs: noimplicitfloat noredzone
declare void @audit_arg_sgid(i32) #2

; Function Attrs: noimplicitfloat noredzone
declare i32 @mac_cred_check_setresgid(%struct.ucred*, i32, i32, i32) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys_getresuid(%struct.thread* %td, %struct.getresuid_args* %uap) #0 {
entry:
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.getresuid_args*, align 8
  %cred = alloca %struct.ucred*, align 8
  %error1 = alloca i32, align 4
  %error2 = alloca i32, align 4
  %error3 = alloca i32, align 4
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !2981), !dbg !2982
  store %struct.getresuid_args* %uap, %struct.getresuid_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.getresuid_args** %uap.addr}, metadata !2983), !dbg !2982
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %cred}, metadata !2984), !dbg !2985
  call void @llvm.dbg.declare(metadata !{i32* %error1}, metadata !2986), !dbg !2987
  store i32 0, i32* %error1, align 4, !dbg !2987
  call void @llvm.dbg.declare(metadata !{i32* %error2}, metadata !2988), !dbg !2987
  store i32 0, i32* %error2, align 4, !dbg !2987
  call void @llvm.dbg.declare(metadata !{i32* %error3}, metadata !2989), !dbg !2987
  store i32 0, i32* %error3, align 4, !dbg !2987
  %0 = load %struct.thread** %td.addr, align 8, !dbg !2990
  %td_ucred = getelementptr inbounds %struct.thread* %0, i32 0, i32 37, !dbg !2990
  %1 = load %struct.ucred** %td_ucred, align 8, !dbg !2990
  store %struct.ucred* %1, %struct.ucred** %cred, align 8, !dbg !2990
  %2 = load %struct.getresuid_args** %uap.addr, align 8, !dbg !2991
  %ruid = getelementptr inbounds %struct.getresuid_args* %2, i32 0, i32 1, !dbg !2991
  %3 = load i32** %ruid, align 8, !dbg !2991
  %tobool = icmp ne i32* %3, null, !dbg !2991
  br i1 %tobool, label %if.then, label %if.end, !dbg !2991

if.then:                                          ; preds = %entry
  %4 = load %struct.ucred** %cred, align 8, !dbg !2992
  %cr_ruid = getelementptr inbounds %struct.ucred* %4, i32 0, i32 2, !dbg !2992
  %5 = bitcast i32* %cr_ruid to i8*, !dbg !2992
  %6 = load %struct.getresuid_args** %uap.addr, align 8, !dbg !2992
  %ruid1 = getelementptr inbounds %struct.getresuid_args* %6, i32 0, i32 1, !dbg !2992
  %7 = load i32** %ruid1, align 8, !dbg !2992
  %8 = bitcast i32* %7 to i8*, !dbg !2992
  %call = call i32 @copyout(i8* %5, i8* %8, i64 4) #5, !dbg !2992
  store i32 %call, i32* %error1, align 4, !dbg !2992
  br label %if.end, !dbg !2992

if.end:                                           ; preds = %if.then, %entry
  %9 = load %struct.getresuid_args** %uap.addr, align 8, !dbg !2993
  %euid = getelementptr inbounds %struct.getresuid_args* %9, i32 0, i32 4, !dbg !2993
  %10 = load i32** %euid, align 8, !dbg !2993
  %tobool2 = icmp ne i32* %10, null, !dbg !2993
  br i1 %tobool2, label %if.then3, label %if.end6, !dbg !2993

if.then3:                                         ; preds = %if.end
  %11 = load %struct.ucred** %cred, align 8, !dbg !2994
  %cr_uid = getelementptr inbounds %struct.ucred* %11, i32 0, i32 1, !dbg !2994
  %12 = bitcast i32* %cr_uid to i8*, !dbg !2994
  %13 = load %struct.getresuid_args** %uap.addr, align 8, !dbg !2994
  %euid4 = getelementptr inbounds %struct.getresuid_args* %13, i32 0, i32 4, !dbg !2994
  %14 = load i32** %euid4, align 8, !dbg !2994
  %15 = bitcast i32* %14 to i8*, !dbg !2994
  %call5 = call i32 @copyout(i8* %12, i8* %15, i64 4) #5, !dbg !2994
  store i32 %call5, i32* %error2, align 4, !dbg !2994
  br label %if.end6, !dbg !2994

if.end6:                                          ; preds = %if.then3, %if.end
  %16 = load %struct.getresuid_args** %uap.addr, align 8, !dbg !2995
  %suid = getelementptr inbounds %struct.getresuid_args* %16, i32 0, i32 7, !dbg !2995
  %17 = load i32** %suid, align 8, !dbg !2995
  %tobool7 = icmp ne i32* %17, null, !dbg !2995
  br i1 %tobool7, label %if.then8, label %if.end11, !dbg !2995

if.then8:                                         ; preds = %if.end6
  %18 = load %struct.ucred** %cred, align 8, !dbg !2996
  %cr_svuid = getelementptr inbounds %struct.ucred* %18, i32 0, i32 3, !dbg !2996
  %19 = bitcast i32* %cr_svuid to i8*, !dbg !2996
  %20 = load %struct.getresuid_args** %uap.addr, align 8, !dbg !2996
  %suid9 = getelementptr inbounds %struct.getresuid_args* %20, i32 0, i32 7, !dbg !2996
  %21 = load i32** %suid9, align 8, !dbg !2996
  %22 = bitcast i32* %21 to i8*, !dbg !2996
  %call10 = call i32 @copyout(i8* %19, i8* %22, i64 4) #5, !dbg !2996
  store i32 %call10, i32* %error3, align 4, !dbg !2996
  br label %if.end11, !dbg !2996

if.end11:                                         ; preds = %if.then8, %if.end6
  %23 = load i32* %error1, align 4, !dbg !2997
  %tobool12 = icmp ne i32 %23, 0, !dbg !2997
  br i1 %tobool12, label %cond.true, label %cond.false, !dbg !2997

cond.true:                                        ; preds = %if.end11
  %24 = load i32* %error1, align 4, !dbg !2997
  br label %cond.end16, !dbg !2997

cond.false:                                       ; preds = %if.end11
  %25 = load i32* %error2, align 4, !dbg !2997
  %tobool13 = icmp ne i32 %25, 0, !dbg !2997
  br i1 %tobool13, label %cond.true14, label %cond.false15, !dbg !2997

cond.true14:                                      ; preds = %cond.false
  %26 = load i32* %error2, align 4, !dbg !2997
  br label %cond.end, !dbg !2997

cond.false15:                                     ; preds = %cond.false
  %27 = load i32* %error3, align 4, !dbg !2997
  br label %cond.end, !dbg !2997

cond.end:                                         ; preds = %cond.false15, %cond.true14
  %cond = phi i32 [ %26, %cond.true14 ], [ %27, %cond.false15 ], !dbg !2997
  br label %cond.end16, !dbg !2997

cond.end16:                                       ; preds = %cond.end, %cond.true
  %cond17 = phi i32 [ %24, %cond.true ], [ %cond, %cond.end ], !dbg !2997
  ret i32 %cond17, !dbg !2997
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys_getresgid(%struct.thread* %td, %struct.getresgid_args* %uap) #0 {
entry:
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.getresgid_args*, align 8
  %cred = alloca %struct.ucred*, align 8
  %error1 = alloca i32, align 4
  %error2 = alloca i32, align 4
  %error3 = alloca i32, align 4
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !2998), !dbg !2999
  store %struct.getresgid_args* %uap, %struct.getresgid_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.getresgid_args** %uap.addr}, metadata !3000), !dbg !2999
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %cred}, metadata !3001), !dbg !3002
  call void @llvm.dbg.declare(metadata !{i32* %error1}, metadata !3003), !dbg !3004
  store i32 0, i32* %error1, align 4, !dbg !3004
  call void @llvm.dbg.declare(metadata !{i32* %error2}, metadata !3005), !dbg !3004
  store i32 0, i32* %error2, align 4, !dbg !3004
  call void @llvm.dbg.declare(metadata !{i32* %error3}, metadata !3006), !dbg !3004
  store i32 0, i32* %error3, align 4, !dbg !3004
  %0 = load %struct.thread** %td.addr, align 8, !dbg !3007
  %td_ucred = getelementptr inbounds %struct.thread* %0, i32 0, i32 37, !dbg !3007
  %1 = load %struct.ucred** %td_ucred, align 8, !dbg !3007
  store %struct.ucred* %1, %struct.ucred** %cred, align 8, !dbg !3007
  %2 = load %struct.getresgid_args** %uap.addr, align 8, !dbg !3008
  %rgid = getelementptr inbounds %struct.getresgid_args* %2, i32 0, i32 1, !dbg !3008
  %3 = load i32** %rgid, align 8, !dbg !3008
  %tobool = icmp ne i32* %3, null, !dbg !3008
  br i1 %tobool, label %if.then, label %if.end, !dbg !3008

if.then:                                          ; preds = %entry
  %4 = load %struct.ucred** %cred, align 8, !dbg !3009
  %cr_rgid = getelementptr inbounds %struct.ucred* %4, i32 0, i32 5, !dbg !3009
  %5 = bitcast i32* %cr_rgid to i8*, !dbg !3009
  %6 = load %struct.getresgid_args** %uap.addr, align 8, !dbg !3009
  %rgid1 = getelementptr inbounds %struct.getresgid_args* %6, i32 0, i32 1, !dbg !3009
  %7 = load i32** %rgid1, align 8, !dbg !3009
  %8 = bitcast i32* %7 to i8*, !dbg !3009
  %call = call i32 @copyout(i8* %5, i8* %8, i64 4) #5, !dbg !3009
  store i32 %call, i32* %error1, align 4, !dbg !3009
  br label %if.end, !dbg !3009

if.end:                                           ; preds = %if.then, %entry
  %9 = load %struct.getresgid_args** %uap.addr, align 8, !dbg !3010
  %egid = getelementptr inbounds %struct.getresgid_args* %9, i32 0, i32 4, !dbg !3010
  %10 = load i32** %egid, align 8, !dbg !3010
  %tobool2 = icmp ne i32* %10, null, !dbg !3010
  br i1 %tobool2, label %if.then3, label %if.end6, !dbg !3010

if.then3:                                         ; preds = %if.end
  %11 = load %struct.ucred** %cred, align 8, !dbg !3011
  %cr_groups = getelementptr inbounds %struct.ucred* %11, i32 0, i32 15, !dbg !3011
  %12 = load i32** %cr_groups, align 8, !dbg !3011
  %arrayidx = getelementptr inbounds i32* %12, i64 0, !dbg !3011
  %13 = bitcast i32* %arrayidx to i8*, !dbg !3011
  %14 = load %struct.getresgid_args** %uap.addr, align 8, !dbg !3011
  %egid4 = getelementptr inbounds %struct.getresgid_args* %14, i32 0, i32 4, !dbg !3011
  %15 = load i32** %egid4, align 8, !dbg !3011
  %16 = bitcast i32* %15 to i8*, !dbg !3011
  %call5 = call i32 @copyout(i8* %13, i8* %16, i64 4) #5, !dbg !3011
  store i32 %call5, i32* %error2, align 4, !dbg !3011
  br label %if.end6, !dbg !3011

if.end6:                                          ; preds = %if.then3, %if.end
  %17 = load %struct.getresgid_args** %uap.addr, align 8, !dbg !3012
  %sgid = getelementptr inbounds %struct.getresgid_args* %17, i32 0, i32 7, !dbg !3012
  %18 = load i32** %sgid, align 8, !dbg !3012
  %tobool7 = icmp ne i32* %18, null, !dbg !3012
  br i1 %tobool7, label %if.then8, label %if.end11, !dbg !3012

if.then8:                                         ; preds = %if.end6
  %19 = load %struct.ucred** %cred, align 8, !dbg !3013
  %cr_svgid = getelementptr inbounds %struct.ucred* %19, i32 0, i32 6, !dbg !3013
  %20 = bitcast i32* %cr_svgid to i8*, !dbg !3013
  %21 = load %struct.getresgid_args** %uap.addr, align 8, !dbg !3013
  %sgid9 = getelementptr inbounds %struct.getresgid_args* %21, i32 0, i32 7, !dbg !3013
  %22 = load i32** %sgid9, align 8, !dbg !3013
  %23 = bitcast i32* %22 to i8*, !dbg !3013
  %call10 = call i32 @copyout(i8* %20, i8* %23, i64 4) #5, !dbg !3013
  store i32 %call10, i32* %error3, align 4, !dbg !3013
  br label %if.end11, !dbg !3013

if.end11:                                         ; preds = %if.then8, %if.end6
  %24 = load i32* %error1, align 4, !dbg !3014
  %tobool12 = icmp ne i32 %24, 0, !dbg !3014
  br i1 %tobool12, label %cond.true, label %cond.false, !dbg !3014

cond.true:                                        ; preds = %if.end11
  %25 = load i32* %error1, align 4, !dbg !3014
  br label %cond.end16, !dbg !3014

cond.false:                                       ; preds = %if.end11
  %26 = load i32* %error2, align 4, !dbg !3014
  %tobool13 = icmp ne i32 %26, 0, !dbg !3014
  br i1 %tobool13, label %cond.true14, label %cond.false15, !dbg !3014

cond.true14:                                      ; preds = %cond.false
  %27 = load i32* %error2, align 4, !dbg !3014
  br label %cond.end, !dbg !3014

cond.false15:                                     ; preds = %cond.false
  %28 = load i32* %error3, align 4, !dbg !3014
  br label %cond.end, !dbg !3014

cond.end:                                         ; preds = %cond.false15, %cond.true14
  %cond = phi i32 [ %27, %cond.true14 ], [ %28, %cond.false15 ], !dbg !3014
  br label %cond.end16, !dbg !3014

cond.end16:                                       ; preds = %cond.end, %cond.true
  %cond17 = phi i32 [ %25, %cond.true ], [ %cond, %cond.end ], !dbg !3014
  ret i32 %cond17, !dbg !3014
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys_issetugid(%struct.thread* %td, %struct.issetugid_args* %uap) #0 {
entry:
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.issetugid_args*, align 8
  %p = alloca %struct.proc*, align 8
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !3015), !dbg !3016
  store %struct.issetugid_args* %uap, %struct.issetugid_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.issetugid_args** %uap.addr}, metadata !3017), !dbg !3016
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p}, metadata !3018), !dbg !3019
  %0 = load %struct.thread** %td.addr, align 8, !dbg !3019
  %td_proc = getelementptr inbounds %struct.thread* %0, i32 0, i32 1, !dbg !3019
  %1 = load %struct.proc** %td_proc, align 8, !dbg !3019
  store %struct.proc* %1, %struct.proc** %p, align 8, !dbg !3019
  %2 = load %struct.proc** %p, align 8, !dbg !3020
  %p_mtx = getelementptr inbounds %struct.proc* %2, i32 0, i32 18, !dbg !3020
  %mtx_lock = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !3020
  call void @__mtx_lock_flags(i64* %mtx_lock, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 1233) #5, !dbg !3020
  %3 = load %struct.proc** %p, align 8, !dbg !3021
  %p_flag = getelementptr inbounds %struct.proc* %3, i32 0, i32 10, !dbg !3021
  %4 = load i32* %p_flag, align 4, !dbg !3021
  %and = and i32 %4, 256, !dbg !3021
  %tobool = icmp ne i32 %and, 0, !dbg !3021
  %cond = select i1 %tobool, i32 1, i32 0, !dbg !3021
  %conv = sext i32 %cond to i64, !dbg !3021
  %5 = load %struct.thread** %td.addr, align 8, !dbg !3021
  %td_retval = getelementptr inbounds %struct.thread* %5, i32 0, i32 78, !dbg !3021
  %arrayidx = getelementptr inbounds [2 x i64]* %td_retval, i32 0, i64 0, !dbg !3021
  store i64 %conv, i64* %arrayidx, align 8, !dbg !3021
  %6 = load %struct.proc** %p, align 8, !dbg !3022
  %p_mtx1 = getelementptr inbounds %struct.proc* %6, i32 0, i32 18, !dbg !3022
  %mtx_lock2 = getelementptr inbounds %struct.mtx* %p_mtx1, i32 0, i32 1, !dbg !3022
  call void @__mtx_unlock_flags(i64* %mtx_lock2, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 1235) #5, !dbg !3022
  ret i32 0, !dbg !3023
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys___setugid(%struct.thread* %td, %struct.__setugid_args* %uap) #0 {
entry:
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.__setugid_args*, align 8
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !3024), !dbg !3025
  store %struct.__setugid_args* %uap, %struct.__setugid_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.__setugid_args** %uap.addr}, metadata !3026), !dbg !3025
  ret i32 78, !dbg !3027
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @groupmember(i32 %gid, %struct.ucred* %cred) #0 {
entry:
  %retval = alloca i32, align 4
  %gid.addr = alloca i32, align 4
  %cred.addr = alloca %struct.ucred*, align 8
  %l = alloca i32, align 4
  %h = alloca i32, align 4
  %m = alloca i32, align 4
  store i32 %gid, i32* %gid.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %gid.addr}, metadata !3028), !dbg !3029
  store %struct.ucred* %cred, %struct.ucred** %cred.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %cred.addr}, metadata !3030), !dbg !3029
  call void @llvm.dbg.declare(metadata !{i32* %l}, metadata !3031), !dbg !3032
  call void @llvm.dbg.declare(metadata !{i32* %h}, metadata !3033), !dbg !3034
  call void @llvm.dbg.declare(metadata !{i32* %m}, metadata !3035), !dbg !3036
  %0 = load %struct.ucred** %cred.addr, align 8, !dbg !3037
  %cr_groups = getelementptr inbounds %struct.ucred* %0, i32 0, i32 15, !dbg !3037
  %1 = load i32** %cr_groups, align 8, !dbg !3037
  %arrayidx = getelementptr inbounds i32* %1, i64 0, !dbg !3037
  %2 = load i32* %arrayidx, align 4, !dbg !3037
  %3 = load i32* %gid.addr, align 4, !dbg !3037
  %cmp = icmp eq i32 %2, %3, !dbg !3037
  br i1 %cmp, label %if.then, label %if.end, !dbg !3037

if.then:                                          ; preds = %entry
  store i32 1, i32* %retval, !dbg !3038
  br label %return, !dbg !3038

if.end:                                           ; preds = %entry
  store i32 1, i32* %l, align 4, !dbg !3039
  %4 = load %struct.ucred** %cred.addr, align 8, !dbg !3040
  %cr_ngroups = getelementptr inbounds %struct.ucred* %4, i32 0, i32 4, !dbg !3040
  %5 = load i32* %cr_ngroups, align 4, !dbg !3040
  store i32 %5, i32* %h, align 4, !dbg !3040
  br label %while.cond, !dbg !3041

while.cond:                                       ; preds = %if.end7, %if.end
  %6 = load i32* %l, align 4, !dbg !3041
  %7 = load i32* %h, align 4, !dbg !3041
  %cmp1 = icmp slt i32 %6, %7, !dbg !3041
  br i1 %cmp1, label %while.body, label %while.end, !dbg !3041

while.body:                                       ; preds = %while.cond
  %8 = load i32* %l, align 4, !dbg !3042
  %9 = load i32* %h, align 4, !dbg !3042
  %10 = load i32* %l, align 4, !dbg !3042
  %sub = sub nsw i32 %9, %10, !dbg !3042
  %div = sdiv i32 %sub, 2, !dbg !3042
  %add = add nsw i32 %8, %div, !dbg !3042
  store i32 %add, i32* %m, align 4, !dbg !3042
  %11 = load i32* %m, align 4, !dbg !3044
  %idxprom = sext i32 %11 to i64, !dbg !3044
  %12 = load %struct.ucred** %cred.addr, align 8, !dbg !3044
  %cr_groups2 = getelementptr inbounds %struct.ucred* %12, i32 0, i32 15, !dbg !3044
  %13 = load i32** %cr_groups2, align 8, !dbg !3044
  %arrayidx3 = getelementptr inbounds i32* %13, i64 %idxprom, !dbg !3044
  %14 = load i32* %arrayidx3, align 4, !dbg !3044
  %15 = load i32* %gid.addr, align 4, !dbg !3044
  %cmp4 = icmp ult i32 %14, %15, !dbg !3044
  br i1 %cmp4, label %if.then5, label %if.else, !dbg !3044

if.then5:                                         ; preds = %while.body
  %16 = load i32* %m, align 4, !dbg !3045
  %add6 = add nsw i32 %16, 1, !dbg !3045
  store i32 %add6, i32* %l, align 4, !dbg !3045
  br label %if.end7, !dbg !3045

if.else:                                          ; preds = %while.body
  %17 = load i32* %m, align 4, !dbg !3046
  store i32 %17, i32* %h, align 4, !dbg !3046
  br label %if.end7

if.end7:                                          ; preds = %if.else, %if.then5
  br label %while.cond, !dbg !3047

while.end:                                        ; preds = %while.cond
  %18 = load i32* %l, align 4, !dbg !3048
  %19 = load %struct.ucred** %cred.addr, align 8, !dbg !3048
  %cr_ngroups8 = getelementptr inbounds %struct.ucred* %19, i32 0, i32 4, !dbg !3048
  %20 = load i32* %cr_ngroups8, align 4, !dbg !3048
  %cmp9 = icmp slt i32 %18, %20, !dbg !3048
  br i1 %cmp9, label %land.lhs.true, label %if.end15, !dbg !3048

land.lhs.true:                                    ; preds = %while.end
  %21 = load i32* %l, align 4, !dbg !3048
  %idxprom10 = sext i32 %21 to i64, !dbg !3048
  %22 = load %struct.ucred** %cred.addr, align 8, !dbg !3048
  %cr_groups11 = getelementptr inbounds %struct.ucred* %22, i32 0, i32 15, !dbg !3048
  %23 = load i32** %cr_groups11, align 8, !dbg !3048
  %arrayidx12 = getelementptr inbounds i32* %23, i64 %idxprom10, !dbg !3048
  %24 = load i32* %arrayidx12, align 4, !dbg !3048
  %25 = load i32* %gid.addr, align 4, !dbg !3048
  %cmp13 = icmp eq i32 %24, %25, !dbg !3048
  br i1 %cmp13, label %if.then14, label %if.end15, !dbg !3048

if.then14:                                        ; preds = %land.lhs.true
  store i32 1, i32* %retval, !dbg !3049
  br label %return, !dbg !3049

if.end15:                                         ; preds = %land.lhs.true, %while.end
  store i32 0, i32* %retval, !dbg !3050
  br label %return, !dbg !3050

return:                                           ; preds = %if.end15, %if.then14, %if.then
  %26 = load i32* %retval, !dbg !3050
  ret i32 %26, !dbg !3050
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @securelevel_gt(%struct.ucred* %cr, i32 %level) #0 {
entry:
  %cr.addr = alloca %struct.ucred*, align 8
  %level.addr = alloca i32, align 4
  store %struct.ucred* %cr, %struct.ucred** %cr.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %cr.addr}, metadata !3051), !dbg !3052
  store i32 %level, i32* %level.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %level.addr}, metadata !3053), !dbg !3052
  %0 = load %struct.ucred** %cr.addr, align 8, !dbg !3054
  %cr_prison = getelementptr inbounds %struct.ucred* %0, i32 0, i32 9, !dbg !3054
  %1 = load %struct.prison** %cr_prison, align 8, !dbg !3054
  %pr_securelevel = getelementptr inbounds %struct.prison* %1, i32 0, i32 23, !dbg !3054
  %2 = load i32* %pr_securelevel, align 4, !dbg !3054
  %3 = load i32* %level.addr, align 4, !dbg !3054
  %cmp = icmp sgt i32 %2, %3, !dbg !3054
  %cond = select i1 %cmp, i32 1, i32 0, !dbg !3054
  ret i32 %cond, !dbg !3054
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @securelevel_ge(%struct.ucred* %cr, i32 %level) #0 {
entry:
  %cr.addr = alloca %struct.ucred*, align 8
  %level.addr = alloca i32, align 4
  store %struct.ucred* %cr, %struct.ucred** %cr.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %cr.addr}, metadata !3055), !dbg !3056
  store i32 %level, i32* %level.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %level.addr}, metadata !3057), !dbg !3056
  %0 = load %struct.ucred** %cr.addr, align 8, !dbg !3058
  %cr_prison = getelementptr inbounds %struct.ucred* %0, i32 0, i32 9, !dbg !3058
  %1 = load %struct.prison** %cr_prison, align 8, !dbg !3058
  %pr_securelevel = getelementptr inbounds %struct.prison* %1, i32 0, i32 23, !dbg !3058
  %2 = load i32* %pr_securelevel, align 4, !dbg !3058
  %3 = load i32* %level.addr, align 4, !dbg !3058
  %cmp = icmp sge i32 %2, %3, !dbg !3058
  %cond = select i1 %cmp, i32 1, i32 0, !dbg !3058
  ret i32 %cond, !dbg !3058
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @cr_cansee(%struct.ucred* %u1, %struct.ucred* %u2) #0 {
entry:
  %retval = alloca i32, align 4
  %u1.addr = alloca %struct.ucred*, align 8
  %u2.addr = alloca %struct.ucred*, align 8
  %error = alloca i32, align 4
  store %struct.ucred* %u1, %struct.ucred** %u1.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %u1.addr}, metadata !3059), !dbg !3060
  store %struct.ucred* %u2, %struct.ucred** %u2.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %u2.addr}, metadata !3061), !dbg !3060
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !3062), !dbg !3063
  %0 = load %struct.ucred** %u1.addr, align 8, !dbg !3064
  %1 = load %struct.ucred** %u2.addr, align 8, !dbg !3064
  %call = call i32 @prison_check(%struct.ucred* %0, %struct.ucred* %1) #5, !dbg !3064
  store i32 %call, i32* %error, align 4, !dbg !3064
  %tobool = icmp ne i32 %call, 0, !dbg !3064
  br i1 %tobool, label %if.then, label %if.end, !dbg !3064

if.then:                                          ; preds = %entry
  %2 = load i32* %error, align 4, !dbg !3065
  store i32 %2, i32* %retval, !dbg !3065
  br label %return, !dbg !3065

if.end:                                           ; preds = %entry
  %3 = load %struct.ucred** %u1.addr, align 8, !dbg !3066
  %4 = load %struct.ucred** %u2.addr, align 8, !dbg !3066
  %call1 = call i32 @mac_cred_check_visible(%struct.ucred* %3, %struct.ucred* %4) #5, !dbg !3066
  store i32 %call1, i32* %error, align 4, !dbg !3066
  %tobool2 = icmp ne i32 %call1, 0, !dbg !3066
  br i1 %tobool2, label %if.then3, label %if.end4, !dbg !3066

if.then3:                                         ; preds = %if.end
  %5 = load i32* %error, align 4, !dbg !3067
  store i32 %5, i32* %retval, !dbg !3067
  br label %return, !dbg !3067

if.end4:                                          ; preds = %if.end
  %6 = load %struct.ucred** %u1.addr, align 8, !dbg !3068
  %7 = load %struct.ucred** %u2.addr, align 8, !dbg !3068
  %call5 = call i32 @cr_seeotheruids(%struct.ucred* %6, %struct.ucred* %7) #5, !dbg !3068
  store i32 %call5, i32* %error, align 4, !dbg !3068
  %tobool6 = icmp ne i32 %call5, 0, !dbg !3068
  br i1 %tobool6, label %if.then7, label %if.end8, !dbg !3068

if.then7:                                         ; preds = %if.end4
  %8 = load i32* %error, align 4, !dbg !3069
  store i32 %8, i32* %retval, !dbg !3069
  br label %return, !dbg !3069

if.end8:                                          ; preds = %if.end4
  %9 = load %struct.ucred** %u1.addr, align 8, !dbg !3070
  %10 = load %struct.ucred** %u2.addr, align 8, !dbg !3070
  %call9 = call i32 @cr_seeothergids(%struct.ucred* %9, %struct.ucred* %10) #5, !dbg !3070
  store i32 %call9, i32* %error, align 4, !dbg !3070
  %tobool10 = icmp ne i32 %call9, 0, !dbg !3070
  br i1 %tobool10, label %if.then11, label %if.end12, !dbg !3070

if.then11:                                        ; preds = %if.end8
  %11 = load i32* %error, align 4, !dbg !3071
  store i32 %11, i32* %retval, !dbg !3071
  br label %return, !dbg !3071

if.end12:                                         ; preds = %if.end8
  store i32 0, i32* %retval, !dbg !3072
  br label %return, !dbg !3072

return:                                           ; preds = %if.end12, %if.then11, %if.then7, %if.then3, %if.then
  %12 = load i32* %retval, !dbg !3073
  ret i32 %12, !dbg !3073
}

; Function Attrs: noimplicitfloat noredzone
declare i32 @prison_check(%struct.ucred*, %struct.ucred*) #2

; Function Attrs: noimplicitfloat noredzone
declare i32 @mac_cred_check_visible(%struct.ucred*, %struct.ucred*) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define internal i32 @cr_seeotheruids(%struct.ucred* %u1, %struct.ucred* %u2) #0 {
entry:
  %retval = alloca i32, align 4
  %u1.addr = alloca %struct.ucred*, align 8
  %u2.addr = alloca %struct.ucred*, align 8
  store %struct.ucred* %u1, %struct.ucred** %u1.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %u1.addr}, metadata !3074), !dbg !3075
  store %struct.ucred* %u2, %struct.ucred** %u2.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %u2.addr}, metadata !3076), !dbg !3075
  %0 = load i32* @see_other_uids, align 4, !dbg !3077
  %tobool = icmp ne i32 %0, 0, !dbg !3077
  br i1 %tobool, label %if.end4, label %land.lhs.true, !dbg !3077

land.lhs.true:                                    ; preds = %entry
  %1 = load %struct.ucred** %u1.addr, align 8, !dbg !3077
  %cr_ruid = getelementptr inbounds %struct.ucred* %1, i32 0, i32 2, !dbg !3077
  %2 = load i32* %cr_ruid, align 4, !dbg !3077
  %3 = load %struct.ucred** %u2.addr, align 8, !dbg !3077
  %cr_ruid1 = getelementptr inbounds %struct.ucred* %3, i32 0, i32 2, !dbg !3077
  %4 = load i32* %cr_ruid1, align 4, !dbg !3077
  %cmp = icmp ne i32 %2, %4, !dbg !3077
  br i1 %cmp, label %if.then, label %if.end4, !dbg !3077

if.then:                                          ; preds = %land.lhs.true
  %5 = load %struct.ucred** %u1.addr, align 8, !dbg !3078
  %call = call i32 @priv_check_cred(%struct.ucred* %5, i32 60, i32 0) #5, !dbg !3078
  %cmp2 = icmp ne i32 %call, 0, !dbg !3078
  br i1 %cmp2, label %if.then3, label %if.end, !dbg !3078

if.then3:                                         ; preds = %if.then
  store i32 3, i32* %retval, !dbg !3080
  br label %return, !dbg !3080

if.end:                                           ; preds = %if.then
  br label %if.end4, !dbg !3081

if.end4:                                          ; preds = %if.end, %land.lhs.true, %entry
  store i32 0, i32* %retval, !dbg !3082
  br label %return, !dbg !3082

return:                                           ; preds = %if.end4, %if.then3
  %6 = load i32* %retval, !dbg !3082
  ret i32 %6, !dbg !3082
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define internal i32 @cr_seeothergids(%struct.ucred* %u1, %struct.ucred* %u2) #0 {
entry:
  %retval = alloca i32, align 4
  %u1.addr = alloca %struct.ucred*, align 8
  %u2.addr = alloca %struct.ucred*, align 8
  %i = alloca i32, align 4
  %match = alloca i32, align 4
  store %struct.ucred* %u1, %struct.ucred** %u1.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %u1.addr}, metadata !3083), !dbg !3084
  store %struct.ucred* %u2, %struct.ucred** %u2.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %u2.addr}, metadata !3085), !dbg !3084
  call void @llvm.dbg.declare(metadata !{i32* %i}, metadata !3086), !dbg !3088
  call void @llvm.dbg.declare(metadata !{i32* %match}, metadata !3089), !dbg !3088
  %0 = load i32* @see_other_gids, align 4, !dbg !3090
  %tobool = icmp ne i32 %0, 0, !dbg !3090
  br i1 %tobool, label %if.end13, label %if.then, !dbg !3090

if.then:                                          ; preds = %entry
  store i32 0, i32* %match, align 4, !dbg !3091
  store i32 0, i32* %i, align 4, !dbg !3093
  br label %for.cond, !dbg !3093

for.cond:                                         ; preds = %for.inc, %if.then
  %1 = load i32* %i, align 4, !dbg !3093
  %2 = load %struct.ucred** %u1.addr, align 8, !dbg !3093
  %cr_ngroups = getelementptr inbounds %struct.ucred* %2, i32 0, i32 4, !dbg !3093
  %3 = load i32* %cr_ngroups, align 4, !dbg !3093
  %cmp = icmp slt i32 %1, %3, !dbg !3093
  br i1 %cmp, label %for.body, label %for.end, !dbg !3093

for.body:                                         ; preds = %for.cond
  %4 = load i32* %i, align 4, !dbg !3095
  %idxprom = sext i32 %4 to i64, !dbg !3095
  %5 = load %struct.ucred** %u1.addr, align 8, !dbg !3095
  %cr_groups = getelementptr inbounds %struct.ucred* %5, i32 0, i32 15, !dbg !3095
  %6 = load i32** %cr_groups, align 8, !dbg !3095
  %arrayidx = getelementptr inbounds i32* %6, i64 %idxprom, !dbg !3095
  %7 = load i32* %arrayidx, align 4, !dbg !3095
  %8 = load %struct.ucred** %u2.addr, align 8, !dbg !3095
  %call = call i32 @groupmember(i32 %7, %struct.ucred* %8) #5, !dbg !3095
  %tobool1 = icmp ne i32 %call, 0, !dbg !3095
  br i1 %tobool1, label %if.then2, label %if.end, !dbg !3095

if.then2:                                         ; preds = %for.body
  store i32 1, i32* %match, align 4, !dbg !3097
  br label %if.end, !dbg !3097

if.end:                                           ; preds = %if.then2, %for.body
  %9 = load i32* %match, align 4, !dbg !3098
  %tobool3 = icmp ne i32 %9, 0, !dbg !3098
  br i1 %tobool3, label %if.then4, label %if.end5, !dbg !3098

if.then4:                                         ; preds = %if.end
  br label %for.end, !dbg !3099

if.end5:                                          ; preds = %if.end
  br label %for.inc, !dbg !3100

for.inc:                                          ; preds = %if.end5
  %10 = load i32* %i, align 4, !dbg !3093
  %inc = add nsw i32 %10, 1, !dbg !3093
  store i32 %inc, i32* %i, align 4, !dbg !3093
  br label %for.cond, !dbg !3093

for.end:                                          ; preds = %if.then4, %for.cond
  %11 = load i32* %match, align 4, !dbg !3101
  %tobool6 = icmp ne i32 %11, 0, !dbg !3101
  br i1 %tobool6, label %if.end12, label %if.then7, !dbg !3101

if.then7:                                         ; preds = %for.end
  %12 = load %struct.ucred** %u1.addr, align 8, !dbg !3102
  %call8 = call i32 @priv_check_cred(%struct.ucred* %12, i32 59, i32 0) #5, !dbg !3102
  %cmp9 = icmp ne i32 %call8, 0, !dbg !3102
  br i1 %cmp9, label %if.then10, label %if.end11, !dbg !3102

if.then10:                                        ; preds = %if.then7
  store i32 3, i32* %retval, !dbg !3104
  br label %return, !dbg !3104

if.end11:                                         ; preds = %if.then7
  br label %if.end12, !dbg !3105

if.end12:                                         ; preds = %if.end11, %for.end
  br label %if.end13, !dbg !3106

if.end13:                                         ; preds = %if.end12, %entry
  store i32 0, i32* %retval, !dbg !3107
  br label %return, !dbg !3107

return:                                           ; preds = %if.end13, %if.then10
  %13 = load i32* %retval, !dbg !3107
  ret i32 %13, !dbg !3107
}

; Function Attrs: noimplicitfloat noredzone
declare void @__mtx_assert(i64*, i32, i8*, i32) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @cr_cansignal(%struct.ucred* %cred, %struct.proc* %proc, i32 %signum) #0 {
entry:
  %retval = alloca i32, align 4
  %cred.addr = alloca %struct.ucred*, align 8
  %proc.addr = alloca %struct.proc*, align 8
  %signum.addr = alloca i32, align 4
  %error = alloca i32, align 4
  store %struct.ucred* %cred, %struct.ucred** %cred.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %cred.addr}, metadata !3108), !dbg !3109
  store %struct.proc* %proc, %struct.proc** %proc.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.proc** %proc.addr}, metadata !3110), !dbg !3109
  store i32 %signum, i32* %signum.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %signum.addr}, metadata !3111), !dbg !3109
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !3112), !dbg !3113
  %0 = load %struct.proc** %proc.addr, align 8, !dbg !3114
  %p_mtx = getelementptr inbounds %struct.proc* %0, i32 0, i32 18, !dbg !3114
  %mtx_lock = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !3114
  call void @__mtx_assert(i64* %mtx_lock, i32 4, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 1463) #5, !dbg !3114
  %1 = load %struct.ucred** %cred.addr, align 8, !dbg !3115
  %2 = load %struct.proc** %proc.addr, align 8, !dbg !3115
  %p_ucred = getelementptr inbounds %struct.proc* %2, i32 0, i32 3, !dbg !3115
  %3 = load %struct.ucred** %p_ucred, align 8, !dbg !3115
  %call = call i32 @prison_check(%struct.ucred* %1, %struct.ucred* %3) #5, !dbg !3115
  store i32 %call, i32* %error, align 4, !dbg !3115
  %4 = load i32* %error, align 4, !dbg !3116
  %tobool = icmp ne i32 %4, 0, !dbg !3116
  br i1 %tobool, label %if.then, label %if.end, !dbg !3116

if.then:                                          ; preds = %entry
  %5 = load i32* %error, align 4, !dbg !3117
  store i32 %5, i32* %retval, !dbg !3117
  br label %return, !dbg !3117

if.end:                                           ; preds = %entry
  %6 = load %struct.ucred** %cred.addr, align 8, !dbg !3118
  %7 = load %struct.proc** %proc.addr, align 8, !dbg !3118
  %8 = load i32* %signum.addr, align 4, !dbg !3118
  %call1 = call i32 @mac_proc_check_signal(%struct.ucred* %6, %struct.proc* %7, i32 %8) #5, !dbg !3118
  store i32 %call1, i32* %error, align 4, !dbg !3118
  %tobool2 = icmp ne i32 %call1, 0, !dbg !3118
  br i1 %tobool2, label %if.then3, label %if.end4, !dbg !3118

if.then3:                                         ; preds = %if.end
  %9 = load i32* %error, align 4, !dbg !3119
  store i32 %9, i32* %retval, !dbg !3119
  br label %return, !dbg !3119

if.end4:                                          ; preds = %if.end
  %10 = load %struct.ucred** %cred.addr, align 8, !dbg !3120
  %11 = load %struct.proc** %proc.addr, align 8, !dbg !3120
  %p_ucred5 = getelementptr inbounds %struct.proc* %11, i32 0, i32 3, !dbg !3120
  %12 = load %struct.ucred** %p_ucred5, align 8, !dbg !3120
  %call6 = call i32 @cr_seeotheruids(%struct.ucred* %10, %struct.ucred* %12) #5, !dbg !3120
  store i32 %call6, i32* %error, align 4, !dbg !3120
  %tobool7 = icmp ne i32 %call6, 0, !dbg !3120
  br i1 %tobool7, label %if.then8, label %if.end9, !dbg !3120

if.then8:                                         ; preds = %if.end4
  %13 = load i32* %error, align 4, !dbg !3121
  store i32 %13, i32* %retval, !dbg !3121
  br label %return, !dbg !3121

if.end9:                                          ; preds = %if.end4
  %14 = load %struct.ucred** %cred.addr, align 8, !dbg !3122
  %15 = load %struct.proc** %proc.addr, align 8, !dbg !3122
  %p_ucred10 = getelementptr inbounds %struct.proc* %15, i32 0, i32 3, !dbg !3122
  %16 = load %struct.ucred** %p_ucred10, align 8, !dbg !3122
  %call11 = call i32 @cr_seeothergids(%struct.ucred* %14, %struct.ucred* %16) #5, !dbg !3122
  store i32 %call11, i32* %error, align 4, !dbg !3122
  %tobool12 = icmp ne i32 %call11, 0, !dbg !3122
  br i1 %tobool12, label %if.then13, label %if.end14, !dbg !3122

if.then13:                                        ; preds = %if.end9
  %17 = load i32* %error, align 4, !dbg !3123
  store i32 %17, i32* %retval, !dbg !3123
  br label %return, !dbg !3123

if.end14:                                         ; preds = %if.end9
  %18 = load i32* @conservative_signals, align 4, !dbg !3124
  %tobool15 = icmp ne i32 %18, 0, !dbg !3124
  br i1 %tobool15, label %land.lhs.true, label %if.end22, !dbg !3124

land.lhs.true:                                    ; preds = %if.end14
  %19 = load %struct.proc** %proc.addr, align 8, !dbg !3124
  %p_flag = getelementptr inbounds %struct.proc* %19, i32 0, i32 10, !dbg !3124
  %20 = load i32* %p_flag, align 4, !dbg !3124
  %and = and i32 %20, 256, !dbg !3124
  %tobool16 = icmp ne i32 %and, 0, !dbg !3124
  br i1 %tobool16, label %if.then17, label %if.end22, !dbg !3124

if.then17:                                        ; preds = %land.lhs.true
  %21 = load i32* %signum.addr, align 4, !dbg !3125
  switch i32 %21, label %sw.default [
    i32 0, label %sw.bb
    i32 9, label %sw.bb
    i32 2, label %sw.bb
    i32 15, label %sw.bb
    i32 14, label %sw.bb
    i32 17, label %sw.bb
    i32 21, label %sw.bb
    i32 22, label %sw.bb
    i32 18, label %sw.bb
    i32 1, label %sw.bb
    i32 30, label %sw.bb
    i32 31, label %sw.bb
  ], !dbg !3125

sw.bb:                                            ; preds = %if.then17, %if.then17, %if.then17, %if.then17, %if.then17, %if.then17, %if.then17, %if.then17, %if.then17, %if.then17, %if.then17, %if.then17
  br label %sw.epilog, !dbg !3127

sw.default:                                       ; preds = %if.then17
  %22 = load %struct.ucred** %cred.addr, align 8, !dbg !3129
  %call18 = call i32 @priv_check_cred(%struct.ucred* %22, i32 231, i32 0) #5, !dbg !3129
  store i32 %call18, i32* %error, align 4, !dbg !3129
  %23 = load i32* %error, align 4, !dbg !3130
  %tobool19 = icmp ne i32 %23, 0, !dbg !3130
  br i1 %tobool19, label %if.then20, label %if.end21, !dbg !3130

if.then20:                                        ; preds = %sw.default
  %24 = load i32* %error, align 4, !dbg !3131
  store i32 %24, i32* %retval, !dbg !3131
  br label %return, !dbg !3131

if.end21:                                         ; preds = %sw.default
  br label %sw.epilog, !dbg !3132

sw.epilog:                                        ; preds = %if.end21, %sw.bb
  br label %if.end22, !dbg !3133

if.end22:                                         ; preds = %sw.epilog, %land.lhs.true, %if.end14
  %25 = load %struct.ucred** %cred.addr, align 8, !dbg !3134
  %cr_ruid = getelementptr inbounds %struct.ucred* %25, i32 0, i32 2, !dbg !3134
  %26 = load i32* %cr_ruid, align 4, !dbg !3134
  %27 = load %struct.proc** %proc.addr, align 8, !dbg !3134
  %p_ucred23 = getelementptr inbounds %struct.proc* %27, i32 0, i32 3, !dbg !3134
  %28 = load %struct.ucred** %p_ucred23, align 8, !dbg !3134
  %cr_ruid24 = getelementptr inbounds %struct.ucred* %28, i32 0, i32 2, !dbg !3134
  %29 = load i32* %cr_ruid24, align 4, !dbg !3134
  %cmp = icmp ne i32 %26, %29, !dbg !3134
  br i1 %cmp, label %land.lhs.true25, label %if.end43, !dbg !3134

land.lhs.true25:                                  ; preds = %if.end22
  %30 = load %struct.ucred** %cred.addr, align 8, !dbg !3134
  %cr_ruid26 = getelementptr inbounds %struct.ucred* %30, i32 0, i32 2, !dbg !3134
  %31 = load i32* %cr_ruid26, align 4, !dbg !3134
  %32 = load %struct.proc** %proc.addr, align 8, !dbg !3134
  %p_ucred27 = getelementptr inbounds %struct.proc* %32, i32 0, i32 3, !dbg !3134
  %33 = load %struct.ucred** %p_ucred27, align 8, !dbg !3134
  %cr_svuid = getelementptr inbounds %struct.ucred* %33, i32 0, i32 3, !dbg !3134
  %34 = load i32* %cr_svuid, align 4, !dbg !3134
  %cmp28 = icmp ne i32 %31, %34, !dbg !3134
  br i1 %cmp28, label %land.lhs.true29, label %if.end43, !dbg !3134

land.lhs.true29:                                  ; preds = %land.lhs.true25
  %35 = load %struct.ucred** %cred.addr, align 8, !dbg !3134
  %cr_uid = getelementptr inbounds %struct.ucred* %35, i32 0, i32 1, !dbg !3134
  %36 = load i32* %cr_uid, align 4, !dbg !3134
  %37 = load %struct.proc** %proc.addr, align 8, !dbg !3134
  %p_ucred30 = getelementptr inbounds %struct.proc* %37, i32 0, i32 3, !dbg !3134
  %38 = load %struct.ucred** %p_ucred30, align 8, !dbg !3134
  %cr_ruid31 = getelementptr inbounds %struct.ucred* %38, i32 0, i32 2, !dbg !3134
  %39 = load i32* %cr_ruid31, align 4, !dbg !3134
  %cmp32 = icmp ne i32 %36, %39, !dbg !3134
  br i1 %cmp32, label %land.lhs.true33, label %if.end43, !dbg !3134

land.lhs.true33:                                  ; preds = %land.lhs.true29
  %40 = load %struct.ucred** %cred.addr, align 8, !dbg !3134
  %cr_uid34 = getelementptr inbounds %struct.ucred* %40, i32 0, i32 1, !dbg !3134
  %41 = load i32* %cr_uid34, align 4, !dbg !3134
  %42 = load %struct.proc** %proc.addr, align 8, !dbg !3134
  %p_ucred35 = getelementptr inbounds %struct.proc* %42, i32 0, i32 3, !dbg !3134
  %43 = load %struct.ucred** %p_ucred35, align 8, !dbg !3134
  %cr_svuid36 = getelementptr inbounds %struct.ucred* %43, i32 0, i32 3, !dbg !3134
  %44 = load i32* %cr_svuid36, align 4, !dbg !3134
  %cmp37 = icmp ne i32 %41, %44, !dbg !3134
  br i1 %cmp37, label %if.then38, label %if.end43, !dbg !3134

if.then38:                                        ; preds = %land.lhs.true33
  %45 = load %struct.ucred** %cred.addr, align 8, !dbg !3135
  %call39 = call i32 @priv_check_cred(%struct.ucred* %45, i32 230, i32 0) #5, !dbg !3135
  store i32 %call39, i32* %error, align 4, !dbg !3135
  %46 = load i32* %error, align 4, !dbg !3137
  %tobool40 = icmp ne i32 %46, 0, !dbg !3137
  br i1 %tobool40, label %if.then41, label %if.end42, !dbg !3137

if.then41:                                        ; preds = %if.then38
  %47 = load i32* %error, align 4, !dbg !3138
  store i32 %47, i32* %retval, !dbg !3138
  br label %return, !dbg !3138

if.end42:                                         ; preds = %if.then38
  br label %if.end43, !dbg !3139

if.end43:                                         ; preds = %if.end42, %land.lhs.true33, %land.lhs.true29, %land.lhs.true25, %if.end22
  store i32 0, i32* %retval, !dbg !3140
  br label %return, !dbg !3140

return:                                           ; preds = %if.end43, %if.then41, %if.then20, %if.then13, %if.then8, %if.then3, %if.then
  %48 = load i32* %retval, !dbg !3141
  ret i32 %48, !dbg !3141
}

; Function Attrs: noimplicitfloat noredzone
declare i32 @mac_proc_check_signal(%struct.ucred*, %struct.proc*, i32) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @p_cansignal(%struct.thread* %td, %struct.proc* %p, i32 %signum) #0 {
entry:
  %retval = alloca i32, align 4
  %td.addr = alloca %struct.thread*, align 8
  %p.addr = alloca %struct.proc*, align 8
  %signum.addr = alloca i32, align 4
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !3142), !dbg !3143
  store %struct.proc* %p, %struct.proc** %p.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p.addr}, metadata !3144), !dbg !3143
  store i32 %signum, i32* %signum.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %signum.addr}, metadata !3145), !dbg !3143
  br label %do.body, !dbg !3146

do.body:                                          ; preds = %entry
  %0 = load %struct.thread** %td.addr, align 8, !dbg !3147
  %call = call %struct.thread* @__curthread() #6, !dbg !3147
  %cmp = icmp eq %struct.thread* %0, %call, !dbg !3147
  %lnot = xor i1 %cmp, true, !dbg !3147
  %lnot.ext = zext i1 %lnot to i32, !dbg !3147
  %conv = sext i32 %lnot.ext to i64, !dbg !3147
  %expval = call i64 @llvm.expect.i64(i64 %conv, i64 0), !dbg !3147
  %tobool = icmp ne i64 %expval, 0, !dbg !3147
  br i1 %tobool, label %if.then, label %if.end, !dbg !3147

if.then:                                          ; preds = %do.body
  call void (i8*, ...)* @kassert_panic(i8* getelementptr inbounds ([21 x i8]* @.str2, i32 0, i32 0), i8* getelementptr inbounds ([12 x i8]* @__func__.p_cansignal, i32 0, i32 0)) #5, !dbg !3147
  br label %if.end, !dbg !3147

if.end:                                           ; preds = %if.then, %do.body
  br label %do.end, !dbg !3147

do.end:                                           ; preds = %if.end
  %1 = load %struct.proc** %p.addr, align 8, !dbg !3149
  %p_mtx = getelementptr inbounds %struct.proc* %1, i32 0, i32 18, !dbg !3149
  %mtx_lock = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !3149
  call void @__mtx_assert(i64* %mtx_lock, i32 4, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 1541) #5, !dbg !3149
  %2 = load %struct.thread** %td.addr, align 8, !dbg !3150
  %td_proc = getelementptr inbounds %struct.thread* %2, i32 0, i32 1, !dbg !3150
  %3 = load %struct.proc** %td_proc, align 8, !dbg !3150
  %4 = load %struct.proc** %p.addr, align 8, !dbg !3150
  %cmp1 = icmp eq %struct.proc* %3, %4, !dbg !3150
  br i1 %cmp1, label %if.then3, label %if.end4, !dbg !3150

if.then3:                                         ; preds = %do.end
  store i32 0, i32* %retval, !dbg !3151
  br label %return, !dbg !3151

if.end4:                                          ; preds = %do.end
  %5 = load i32* %signum.addr, align 4, !dbg !3152
  %cmp5 = icmp eq i32 %5, 19, !dbg !3152
  br i1 %cmp5, label %land.lhs.true, label %if.end13, !dbg !3152

land.lhs.true:                                    ; preds = %if.end4
  %6 = load %struct.thread** %td.addr, align 8, !dbg !3152
  %td_proc7 = getelementptr inbounds %struct.thread* %6, i32 0, i32 1, !dbg !3152
  %7 = load %struct.proc** %td_proc7, align 8, !dbg !3152
  %p_pgrp = getelementptr inbounds %struct.proc* %7, i32 0, i32 55, !dbg !3152
  %8 = load %struct.pgrp** %p_pgrp, align 8, !dbg !3152
  %pg_session = getelementptr inbounds %struct.pgrp* %8, i32 0, i32 2, !dbg !3152
  %9 = load %struct.session** %pg_session, align 8, !dbg !3152
  %10 = load %struct.proc** %p.addr, align 8, !dbg !3152
  %p_pgrp8 = getelementptr inbounds %struct.proc* %10, i32 0, i32 55, !dbg !3152
  %11 = load %struct.pgrp** %p_pgrp8, align 8, !dbg !3152
  %pg_session9 = getelementptr inbounds %struct.pgrp* %11, i32 0, i32 2, !dbg !3152
  %12 = load %struct.session** %pg_session9, align 8, !dbg !3152
  %cmp10 = icmp eq %struct.session* %9, %12, !dbg !3152
  br i1 %cmp10, label %if.then12, label %if.end13, !dbg !3152

if.then12:                                        ; preds = %land.lhs.true
  store i32 0, i32* %retval, !dbg !3153
  br label %return, !dbg !3153

if.end13:                                         ; preds = %land.lhs.true, %if.end4
  %13 = load %struct.thread** %td.addr, align 8, !dbg !3154
  %td_proc14 = getelementptr inbounds %struct.thread* %13, i32 0, i32 1, !dbg !3154
  %14 = load %struct.proc** %td_proc14, align 8, !dbg !3154
  %p_leader = getelementptr inbounds %struct.proc* %14, i32 0, i32 68, !dbg !3154
  %15 = load %struct.proc** %p_leader, align 8, !dbg !3154
  %cmp15 = icmp ne %struct.proc* %15, null, !dbg !3154
  br i1 %cmp15, label %land.lhs.true17, label %if.end30, !dbg !3154

land.lhs.true17:                                  ; preds = %if.end13
  %16 = load i32* %signum.addr, align 4, !dbg !3154
  %cmp18 = icmp sge i32 %16, 32, !dbg !3154
  br i1 %cmp18, label %land.lhs.true20, label %if.end30, !dbg !3154

land.lhs.true20:                                  ; preds = %land.lhs.true17
  %17 = load i32* %signum.addr, align 4, !dbg !3154
  %cmp21 = icmp slt i32 %17, 36, !dbg !3154
  br i1 %cmp21, label %land.lhs.true23, label %if.end30, !dbg !3154

land.lhs.true23:                                  ; preds = %land.lhs.true20
  %18 = load %struct.thread** %td.addr, align 8, !dbg !3154
  %td_proc24 = getelementptr inbounds %struct.thread* %18, i32 0, i32 1, !dbg !3154
  %19 = load %struct.proc** %td_proc24, align 8, !dbg !3154
  %p_leader25 = getelementptr inbounds %struct.proc* %19, i32 0, i32 68, !dbg !3154
  %20 = load %struct.proc** %p_leader25, align 8, !dbg !3154
  %21 = load %struct.proc** %p.addr, align 8, !dbg !3154
  %p_leader26 = getelementptr inbounds %struct.proc* %21, i32 0, i32 68, !dbg !3154
  %22 = load %struct.proc** %p_leader26, align 8, !dbg !3154
  %cmp27 = icmp eq %struct.proc* %20, %22, !dbg !3154
  br i1 %cmp27, label %if.then29, label %if.end30, !dbg !3154

if.then29:                                        ; preds = %land.lhs.true23
  store i32 0, i32* %retval, !dbg !3155
  br label %return, !dbg !3155

if.end30:                                         ; preds = %land.lhs.true23, %land.lhs.true20, %land.lhs.true17, %if.end13
  %23 = load %struct.thread** %td.addr, align 8, !dbg !3156
  %td_ucred = getelementptr inbounds %struct.thread* %23, i32 0, i32 37, !dbg !3156
  %24 = load %struct.ucred** %td_ucred, align 8, !dbg !3156
  %25 = load %struct.proc** %p.addr, align 8, !dbg !3156
  %26 = load i32* %signum.addr, align 4, !dbg !3156
  %call31 = call i32 @cr_cansignal(%struct.ucred* %24, %struct.proc* %25, i32 %26) #5, !dbg !3156
  store i32 %call31, i32* %retval, !dbg !3156
  br label %return, !dbg !3156

return:                                           ; preds = %if.end30, %if.then29, %if.then12, %if.then3
  %27 = load i32* %retval, !dbg !3157
  ret i32 %27, !dbg !3157
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @p_cansched(%struct.thread* %td, %struct.proc* %p) #0 {
entry:
  %retval = alloca i32, align 4
  %td.addr = alloca %struct.thread*, align 8
  %p.addr = alloca %struct.proc*, align 8
  %error = alloca i32, align 4
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !3158), !dbg !3159
  store %struct.proc* %p, %struct.proc** %p.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p.addr}, metadata !3160), !dbg !3159
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !3161), !dbg !3162
  br label %do.body, !dbg !3163

do.body:                                          ; preds = %entry
  %0 = load %struct.thread** %td.addr, align 8, !dbg !3164
  %call = call %struct.thread* @__curthread() #6, !dbg !3164
  %cmp = icmp eq %struct.thread* %0, %call, !dbg !3164
  %lnot = xor i1 %cmp, true, !dbg !3164
  %lnot.ext = zext i1 %lnot to i32, !dbg !3164
  %conv = sext i32 %lnot.ext to i64, !dbg !3164
  %expval = call i64 @llvm.expect.i64(i64 %conv, i64 0), !dbg !3164
  %tobool = icmp ne i64 %expval, 0, !dbg !3164
  br i1 %tobool, label %if.then, label %if.end, !dbg !3164

if.then:                                          ; preds = %do.body
  call void (i8*, ...)* @kassert_panic(i8* getelementptr inbounds ([21 x i8]* @.str2, i32 0, i32 0), i8* getelementptr inbounds ([11 x i8]* @__func__.p_cansched, i32 0, i32 0)) #5, !dbg !3164
  br label %if.end, !dbg !3164

if.end:                                           ; preds = %if.then, %do.body
  br label %do.end, !dbg !3164

do.end:                                           ; preds = %if.end
  %1 = load %struct.proc** %p.addr, align 8, !dbg !3166
  %p_mtx = getelementptr inbounds %struct.proc* %1, i32 0, i32 18, !dbg !3166
  %mtx_lock = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !3166
  call void @__mtx_assert(i64* %mtx_lock, i32 4, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 1583) #5, !dbg !3166
  %2 = load %struct.thread** %td.addr, align 8, !dbg !3167
  %td_proc = getelementptr inbounds %struct.thread* %2, i32 0, i32 1, !dbg !3167
  %3 = load %struct.proc** %td_proc, align 8, !dbg !3167
  %4 = load %struct.proc** %p.addr, align 8, !dbg !3167
  %cmp1 = icmp eq %struct.proc* %3, %4, !dbg !3167
  br i1 %cmp1, label %if.then3, label %if.end4, !dbg !3167

if.then3:                                         ; preds = %do.end
  store i32 0, i32* %retval, !dbg !3168
  br label %return, !dbg !3168

if.end4:                                          ; preds = %do.end
  %5 = load %struct.thread** %td.addr, align 8, !dbg !3169
  %td_ucred = getelementptr inbounds %struct.thread* %5, i32 0, i32 37, !dbg !3169
  %6 = load %struct.ucred** %td_ucred, align 8, !dbg !3169
  %7 = load %struct.proc** %p.addr, align 8, !dbg !3169
  %p_ucred = getelementptr inbounds %struct.proc* %7, i32 0, i32 3, !dbg !3169
  %8 = load %struct.ucred** %p_ucred, align 8, !dbg !3169
  %call5 = call i32 @prison_check(%struct.ucred* %6, %struct.ucred* %8) #5, !dbg !3169
  store i32 %call5, i32* %error, align 4, !dbg !3169
  %tobool6 = icmp ne i32 %call5, 0, !dbg !3169
  br i1 %tobool6, label %if.then7, label %if.end8, !dbg !3169

if.then7:                                         ; preds = %if.end4
  %9 = load i32* %error, align 4, !dbg !3170
  store i32 %9, i32* %retval, !dbg !3170
  br label %return, !dbg !3170

if.end8:                                          ; preds = %if.end4
  %10 = load %struct.thread** %td.addr, align 8, !dbg !3171
  %td_ucred9 = getelementptr inbounds %struct.thread* %10, i32 0, i32 37, !dbg !3171
  %11 = load %struct.ucred** %td_ucred9, align 8, !dbg !3171
  %12 = load %struct.proc** %p.addr, align 8, !dbg !3171
  %call10 = call i32 @mac_proc_check_sched(%struct.ucred* %11, %struct.proc* %12) #5, !dbg !3171
  store i32 %call10, i32* %error, align 4, !dbg !3171
  %tobool11 = icmp ne i32 %call10, 0, !dbg !3171
  br i1 %tobool11, label %if.then12, label %if.end13, !dbg !3171

if.then12:                                        ; preds = %if.end8
  %13 = load i32* %error, align 4, !dbg !3172
  store i32 %13, i32* %retval, !dbg !3172
  br label %return, !dbg !3172

if.end13:                                         ; preds = %if.end8
  %14 = load %struct.thread** %td.addr, align 8, !dbg !3173
  %td_ucred14 = getelementptr inbounds %struct.thread* %14, i32 0, i32 37, !dbg !3173
  %15 = load %struct.ucred** %td_ucred14, align 8, !dbg !3173
  %16 = load %struct.proc** %p.addr, align 8, !dbg !3173
  %p_ucred15 = getelementptr inbounds %struct.proc* %16, i32 0, i32 3, !dbg !3173
  %17 = load %struct.ucred** %p_ucred15, align 8, !dbg !3173
  %call16 = call i32 @cr_seeotheruids(%struct.ucred* %15, %struct.ucred* %17) #5, !dbg !3173
  store i32 %call16, i32* %error, align 4, !dbg !3173
  %tobool17 = icmp ne i32 %call16, 0, !dbg !3173
  br i1 %tobool17, label %if.then18, label %if.end19, !dbg !3173

if.then18:                                        ; preds = %if.end13
  %18 = load i32* %error, align 4, !dbg !3174
  store i32 %18, i32* %retval, !dbg !3174
  br label %return, !dbg !3174

if.end19:                                         ; preds = %if.end13
  %19 = load %struct.thread** %td.addr, align 8, !dbg !3175
  %td_ucred20 = getelementptr inbounds %struct.thread* %19, i32 0, i32 37, !dbg !3175
  %20 = load %struct.ucred** %td_ucred20, align 8, !dbg !3175
  %21 = load %struct.proc** %p.addr, align 8, !dbg !3175
  %p_ucred21 = getelementptr inbounds %struct.proc* %21, i32 0, i32 3, !dbg !3175
  %22 = load %struct.ucred** %p_ucred21, align 8, !dbg !3175
  %call22 = call i32 @cr_seeothergids(%struct.ucred* %20, %struct.ucred* %22) #5, !dbg !3175
  store i32 %call22, i32* %error, align 4, !dbg !3175
  %tobool23 = icmp ne i32 %call22, 0, !dbg !3175
  br i1 %tobool23, label %if.then24, label %if.end25, !dbg !3175

if.then24:                                        ; preds = %if.end19
  %23 = load i32* %error, align 4, !dbg !3176
  store i32 %23, i32* %retval, !dbg !3176
  br label %return, !dbg !3176

if.end25:                                         ; preds = %if.end19
  %24 = load %struct.thread** %td.addr, align 8, !dbg !3177
  %td_ucred26 = getelementptr inbounds %struct.thread* %24, i32 0, i32 37, !dbg !3177
  %25 = load %struct.ucred** %td_ucred26, align 8, !dbg !3177
  %cr_ruid = getelementptr inbounds %struct.ucred* %25, i32 0, i32 2, !dbg !3177
  %26 = load i32* %cr_ruid, align 4, !dbg !3177
  %27 = load %struct.proc** %p.addr, align 8, !dbg !3177
  %p_ucred27 = getelementptr inbounds %struct.proc* %27, i32 0, i32 3, !dbg !3177
  %28 = load %struct.ucred** %p_ucred27, align 8, !dbg !3177
  %cr_ruid28 = getelementptr inbounds %struct.ucred* %28, i32 0, i32 2, !dbg !3177
  %29 = load i32* %cr_ruid28, align 4, !dbg !3177
  %cmp29 = icmp ne i32 %26, %29, !dbg !3177
  br i1 %cmp29, label %land.lhs.true, label %if.end41, !dbg !3177

land.lhs.true:                                    ; preds = %if.end25
  %30 = load %struct.thread** %td.addr, align 8, !dbg !3177
  %td_ucred31 = getelementptr inbounds %struct.thread* %30, i32 0, i32 37, !dbg !3177
  %31 = load %struct.ucred** %td_ucred31, align 8, !dbg !3177
  %cr_uid = getelementptr inbounds %struct.ucred* %31, i32 0, i32 1, !dbg !3177
  %32 = load i32* %cr_uid, align 4, !dbg !3177
  %33 = load %struct.proc** %p.addr, align 8, !dbg !3177
  %p_ucred32 = getelementptr inbounds %struct.proc* %33, i32 0, i32 3, !dbg !3177
  %34 = load %struct.ucred** %p_ucred32, align 8, !dbg !3177
  %cr_ruid33 = getelementptr inbounds %struct.ucred* %34, i32 0, i32 2, !dbg !3177
  %35 = load i32* %cr_ruid33, align 4, !dbg !3177
  %cmp34 = icmp ne i32 %32, %35, !dbg !3177
  br i1 %cmp34, label %if.then36, label %if.end41, !dbg !3177

if.then36:                                        ; preds = %land.lhs.true
  %36 = load %struct.thread** %td.addr, align 8, !dbg !3178
  %call37 = call i32 @priv_check(%struct.thread* %36, i32 200) #5, !dbg !3178
  store i32 %call37, i32* %error, align 4, !dbg !3178
  %37 = load i32* %error, align 4, !dbg !3180
  %tobool38 = icmp ne i32 %37, 0, !dbg !3180
  br i1 %tobool38, label %if.then39, label %if.end40, !dbg !3180

if.then39:                                        ; preds = %if.then36
  %38 = load i32* %error, align 4, !dbg !3181
  store i32 %38, i32* %retval, !dbg !3181
  br label %return, !dbg !3181

if.end40:                                         ; preds = %if.then36
  br label %if.end41, !dbg !3182

if.end41:                                         ; preds = %if.end40, %land.lhs.true, %if.end25
  store i32 0, i32* %retval, !dbg !3183
  br label %return, !dbg !3183

return:                                           ; preds = %if.end41, %if.then39, %if.then24, %if.then18, %if.then12, %if.then7, %if.then3
  %39 = load i32* %retval, !dbg !3184
  ret i32 %39, !dbg !3184
}

; Function Attrs: noimplicitfloat noredzone
declare i32 @mac_proc_check_sched(%struct.ucred*, %struct.proc*) #2

; Function Attrs: noimplicitfloat noredzone
declare i32 @priv_check(%struct.thread*, i32) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @p_candebug(%struct.thread* %td, %struct.proc* %p) #0 {
entry:
  %retval = alloca i32, align 4
  %td.addr = alloca %struct.thread*, align 8
  %p.addr = alloca %struct.proc*, align 8
  %credentialchanged = alloca i32, align 4
  %error = alloca i32, align 4
  %grpsubset = alloca i32, align 4
  %i = alloca i32, align 4
  %uidsubset = alloca i32, align 4
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !3185), !dbg !3186
  store %struct.proc* %p, %struct.proc** %p.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p.addr}, metadata !3187), !dbg !3186
  call void @llvm.dbg.declare(metadata !{i32* %credentialchanged}, metadata !3188), !dbg !3189
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !3190), !dbg !3189
  call void @llvm.dbg.declare(metadata !{i32* %grpsubset}, metadata !3191), !dbg !3189
  call void @llvm.dbg.declare(metadata !{i32* %i}, metadata !3192), !dbg !3189
  call void @llvm.dbg.declare(metadata !{i32* %uidsubset}, metadata !3193), !dbg !3189
  br label %do.body, !dbg !3194

do.body:                                          ; preds = %entry
  %0 = load %struct.thread** %td.addr, align 8, !dbg !3195
  %call = call %struct.thread* @__curthread() #6, !dbg !3195
  %cmp = icmp eq %struct.thread* %0, %call, !dbg !3195
  %lnot = xor i1 %cmp, true, !dbg !3195
  %lnot.ext = zext i1 %lnot to i32, !dbg !3195
  %conv = sext i32 %lnot.ext to i64, !dbg !3195
  %expval = call i64 @llvm.expect.i64(i64 %conv, i64 0), !dbg !3195
  %tobool = icmp ne i64 %expval, 0, !dbg !3195
  br i1 %tobool, label %if.then, label %if.end, !dbg !3195

if.then:                                          ; preds = %do.body
  call void (i8*, ...)* @kassert_panic(i8* getelementptr inbounds ([21 x i8]* @.str2, i32 0, i32 0), i8* getelementptr inbounds ([11 x i8]* @__func__.p_candebug, i32 0, i32 0)) #5, !dbg !3195
  br label %if.end, !dbg !3195

if.end:                                           ; preds = %if.then, %do.body
  br label %do.end, !dbg !3195

do.end:                                           ; preds = %if.end
  %1 = load %struct.proc** %p.addr, align 8, !dbg !3197
  %p_mtx = getelementptr inbounds %struct.proc* %1, i32 0, i32 18, !dbg !3197
  %mtx_lock = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !3197
  call void @__mtx_assert(i64* %mtx_lock, i32 4, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 1635) #5, !dbg !3197
  %2 = load i32* @unprivileged_proc_debug, align 4, !dbg !3198
  %tobool1 = icmp ne i32 %2, 0, !dbg !3198
  br i1 %tobool1, label %if.end7, label %if.then2, !dbg !3198

if.then2:                                         ; preds = %do.end
  %3 = load %struct.thread** %td.addr, align 8, !dbg !3199
  %call3 = call i32 @priv_check(%struct.thread* %3, i32 82) #5, !dbg !3199
  store i32 %call3, i32* %error, align 4, !dbg !3199
  %4 = load i32* %error, align 4, !dbg !3201
  %tobool4 = icmp ne i32 %4, 0, !dbg !3201
  br i1 %tobool4, label %if.then5, label %if.end6, !dbg !3201

if.then5:                                         ; preds = %if.then2
  %5 = load i32* %error, align 4, !dbg !3202
  store i32 %5, i32* %retval, !dbg !3202
  br label %return, !dbg !3202

if.end6:                                          ; preds = %if.then2
  br label %if.end7, !dbg !3203

if.end7:                                          ; preds = %if.end6, %do.end
  %6 = load %struct.thread** %td.addr, align 8, !dbg !3204
  %td_proc = getelementptr inbounds %struct.thread* %6, i32 0, i32 1, !dbg !3204
  %7 = load %struct.proc** %td_proc, align 8, !dbg !3204
  %8 = load %struct.proc** %p.addr, align 8, !dbg !3204
  %cmp8 = icmp eq %struct.proc* %7, %8, !dbg !3204
  br i1 %cmp8, label %if.then10, label %if.end11, !dbg !3204

if.then10:                                        ; preds = %if.end7
  store i32 0, i32* %retval, !dbg !3205
  br label %return, !dbg !3205

if.end11:                                         ; preds = %if.end7
  %9 = load %struct.thread** %td.addr, align 8, !dbg !3206
  %td_ucred = getelementptr inbounds %struct.thread* %9, i32 0, i32 37, !dbg !3206
  %10 = load %struct.ucred** %td_ucred, align 8, !dbg !3206
  %11 = load %struct.proc** %p.addr, align 8, !dbg !3206
  %p_ucred = getelementptr inbounds %struct.proc* %11, i32 0, i32 3, !dbg !3206
  %12 = load %struct.ucred** %p_ucred, align 8, !dbg !3206
  %call12 = call i32 @prison_check(%struct.ucred* %10, %struct.ucred* %12) #5, !dbg !3206
  store i32 %call12, i32* %error, align 4, !dbg !3206
  %tobool13 = icmp ne i32 %call12, 0, !dbg !3206
  br i1 %tobool13, label %if.then14, label %if.end15, !dbg !3206

if.then14:                                        ; preds = %if.end11
  %13 = load i32* %error, align 4, !dbg !3207
  store i32 %13, i32* %retval, !dbg !3207
  br label %return, !dbg !3207

if.end15:                                         ; preds = %if.end11
  %14 = load %struct.thread** %td.addr, align 8, !dbg !3208
  %td_ucred16 = getelementptr inbounds %struct.thread* %14, i32 0, i32 37, !dbg !3208
  %15 = load %struct.ucred** %td_ucred16, align 8, !dbg !3208
  %16 = load %struct.proc** %p.addr, align 8, !dbg !3208
  %call17 = call i32 @mac_proc_check_debug(%struct.ucred* %15, %struct.proc* %16) #5, !dbg !3208
  store i32 %call17, i32* %error, align 4, !dbg !3208
  %tobool18 = icmp ne i32 %call17, 0, !dbg !3208
  br i1 %tobool18, label %if.then19, label %if.end20, !dbg !3208

if.then19:                                        ; preds = %if.end15
  %17 = load i32* %error, align 4, !dbg !3209
  store i32 %17, i32* %retval, !dbg !3209
  br label %return, !dbg !3209

if.end20:                                         ; preds = %if.end15
  %18 = load %struct.thread** %td.addr, align 8, !dbg !3210
  %td_ucred21 = getelementptr inbounds %struct.thread* %18, i32 0, i32 37, !dbg !3210
  %19 = load %struct.ucred** %td_ucred21, align 8, !dbg !3210
  %20 = load %struct.proc** %p.addr, align 8, !dbg !3210
  %p_ucred22 = getelementptr inbounds %struct.proc* %20, i32 0, i32 3, !dbg !3210
  %21 = load %struct.ucred** %p_ucred22, align 8, !dbg !3210
  %call23 = call i32 @cr_seeotheruids(%struct.ucred* %19, %struct.ucred* %21) #5, !dbg !3210
  store i32 %call23, i32* %error, align 4, !dbg !3210
  %tobool24 = icmp ne i32 %call23, 0, !dbg !3210
  br i1 %tobool24, label %if.then25, label %if.end26, !dbg !3210

if.then25:                                        ; preds = %if.end20
  %22 = load i32* %error, align 4, !dbg !3211
  store i32 %22, i32* %retval, !dbg !3211
  br label %return, !dbg !3211

if.end26:                                         ; preds = %if.end20
  %23 = load %struct.thread** %td.addr, align 8, !dbg !3212
  %td_ucred27 = getelementptr inbounds %struct.thread* %23, i32 0, i32 37, !dbg !3212
  %24 = load %struct.ucred** %td_ucred27, align 8, !dbg !3212
  %25 = load %struct.proc** %p.addr, align 8, !dbg !3212
  %p_ucred28 = getelementptr inbounds %struct.proc* %25, i32 0, i32 3, !dbg !3212
  %26 = load %struct.ucred** %p_ucred28, align 8, !dbg !3212
  %call29 = call i32 @cr_seeothergids(%struct.ucred* %24, %struct.ucred* %26) #5, !dbg !3212
  store i32 %call29, i32* %error, align 4, !dbg !3212
  %tobool30 = icmp ne i32 %call29, 0, !dbg !3212
  br i1 %tobool30, label %if.then31, label %if.end32, !dbg !3212

if.then31:                                        ; preds = %if.end26
  %27 = load i32* %error, align 4, !dbg !3213
  store i32 %27, i32* %retval, !dbg !3213
  br label %return, !dbg !3213

if.end32:                                         ; preds = %if.end26
  store i32 1, i32* %grpsubset, align 4, !dbg !3214
  store i32 0, i32* %i, align 4, !dbg !3215
  br label %for.cond, !dbg !3215

for.cond:                                         ; preds = %for.inc, %if.end32
  %28 = load i32* %i, align 4, !dbg !3215
  %29 = load %struct.proc** %p.addr, align 8, !dbg !3215
  %p_ucred33 = getelementptr inbounds %struct.proc* %29, i32 0, i32 3, !dbg !3215
  %30 = load %struct.ucred** %p_ucred33, align 8, !dbg !3215
  %cr_ngroups = getelementptr inbounds %struct.ucred* %30, i32 0, i32 4, !dbg !3215
  %31 = load i32* %cr_ngroups, align 4, !dbg !3215
  %cmp34 = icmp slt i32 %28, %31, !dbg !3215
  br i1 %cmp34, label %for.body, label %for.end, !dbg !3215

for.body:                                         ; preds = %for.cond
  %32 = load i32* %i, align 4, !dbg !3217
  %idxprom = sext i32 %32 to i64, !dbg !3217
  %33 = load %struct.proc** %p.addr, align 8, !dbg !3217
  %p_ucred36 = getelementptr inbounds %struct.proc* %33, i32 0, i32 3, !dbg !3217
  %34 = load %struct.ucred** %p_ucred36, align 8, !dbg !3217
  %cr_groups = getelementptr inbounds %struct.ucred* %34, i32 0, i32 15, !dbg !3217
  %35 = load i32** %cr_groups, align 8, !dbg !3217
  %arrayidx = getelementptr inbounds i32* %35, i64 %idxprom, !dbg !3217
  %36 = load i32* %arrayidx, align 4, !dbg !3217
  %37 = load %struct.thread** %td.addr, align 8, !dbg !3217
  %td_ucred37 = getelementptr inbounds %struct.thread* %37, i32 0, i32 37, !dbg !3217
  %38 = load %struct.ucred** %td_ucred37, align 8, !dbg !3217
  %call38 = call i32 @groupmember(i32 %36, %struct.ucred* %38) #5, !dbg !3217
  %tobool39 = icmp ne i32 %call38, 0, !dbg !3217
  br i1 %tobool39, label %if.end41, label %if.then40, !dbg !3217

if.then40:                                        ; preds = %for.body
  store i32 0, i32* %grpsubset, align 4, !dbg !3219
  br label %for.end, !dbg !3221

if.end41:                                         ; preds = %for.body
  br label %for.inc, !dbg !3222

for.inc:                                          ; preds = %if.end41
  %39 = load i32* %i, align 4, !dbg !3215
  %inc = add nsw i32 %39, 1, !dbg !3215
  store i32 %inc, i32* %i, align 4, !dbg !3215
  br label %for.cond, !dbg !3215

for.end:                                          ; preds = %if.then40, %for.cond
  %40 = load i32* %grpsubset, align 4, !dbg !3223
  %tobool42 = icmp ne i32 %40, 0, !dbg !3223
  br i1 %tobool42, label %land.lhs.true, label %land.end, !dbg !3223

land.lhs.true:                                    ; preds = %for.end
  %41 = load %struct.proc** %p.addr, align 8, !dbg !3224
  %p_ucred43 = getelementptr inbounds %struct.proc* %41, i32 0, i32 3, !dbg !3224
  %42 = load %struct.ucred** %p_ucred43, align 8, !dbg !3224
  %cr_rgid = getelementptr inbounds %struct.ucred* %42, i32 0, i32 5, !dbg !3224
  %43 = load i32* %cr_rgid, align 4, !dbg !3224
  %44 = load %struct.thread** %td.addr, align 8, !dbg !3224
  %td_ucred44 = getelementptr inbounds %struct.thread* %44, i32 0, i32 37, !dbg !3224
  %45 = load %struct.ucred** %td_ucred44, align 8, !dbg !3224
  %call45 = call i32 @groupmember(i32 %43, %struct.ucred* %45) #5, !dbg !3224
  %tobool46 = icmp ne i32 %call45, 0, !dbg !3224
  br i1 %tobool46, label %land.rhs, label %land.end, !dbg !3224

land.rhs:                                         ; preds = %land.lhs.true
  %46 = load %struct.proc** %p.addr, align 8, !dbg !3225
  %p_ucred47 = getelementptr inbounds %struct.proc* %46, i32 0, i32 3, !dbg !3225
  %47 = load %struct.ucred** %p_ucred47, align 8, !dbg !3225
  %cr_svgid = getelementptr inbounds %struct.ucred* %47, i32 0, i32 6, !dbg !3225
  %48 = load i32* %cr_svgid, align 4, !dbg !3225
  %49 = load %struct.thread** %td.addr, align 8, !dbg !3225
  %td_ucred48 = getelementptr inbounds %struct.thread* %49, i32 0, i32 37, !dbg !3225
  %50 = load %struct.ucred** %td_ucred48, align 8, !dbg !3225
  %call49 = call i32 @groupmember(i32 %48, %struct.ucred* %50) #5, !dbg !3225
  %tobool50 = icmp ne i32 %call49, 0, !dbg !3225
  br label %land.end

land.end:                                         ; preds = %land.rhs, %land.lhs.true, %for.end
  %51 = phi i1 [ false, %land.lhs.true ], [ false, %for.end ], [ %tobool50, %land.rhs ]
  %land.ext = zext i1 %51 to i32
  store i32 %land.ext, i32* %grpsubset, align 4
  %52 = load %struct.thread** %td.addr, align 8, !dbg !3226
  %td_ucred51 = getelementptr inbounds %struct.thread* %52, i32 0, i32 37, !dbg !3226
  %53 = load %struct.ucred** %td_ucred51, align 8, !dbg !3226
  %cr_uid = getelementptr inbounds %struct.ucred* %53, i32 0, i32 1, !dbg !3226
  %54 = load i32* %cr_uid, align 4, !dbg !3226
  %55 = load %struct.proc** %p.addr, align 8, !dbg !3226
  %p_ucred52 = getelementptr inbounds %struct.proc* %55, i32 0, i32 3, !dbg !3226
  %56 = load %struct.ucred** %p_ucred52, align 8, !dbg !3226
  %cr_uid53 = getelementptr inbounds %struct.ucred* %56, i32 0, i32 1, !dbg !3226
  %57 = load i32* %cr_uid53, align 4, !dbg !3226
  %cmp54 = icmp eq i32 %54, %57, !dbg !3226
  br i1 %cmp54, label %land.lhs.true56, label %land.end68, !dbg !3226

land.lhs.true56:                                  ; preds = %land.end
  %58 = load %struct.thread** %td.addr, align 8, !dbg !3226
  %td_ucred57 = getelementptr inbounds %struct.thread* %58, i32 0, i32 37, !dbg !3226
  %59 = load %struct.ucred** %td_ucred57, align 8, !dbg !3226
  %cr_uid58 = getelementptr inbounds %struct.ucred* %59, i32 0, i32 1, !dbg !3226
  %60 = load i32* %cr_uid58, align 4, !dbg !3226
  %61 = load %struct.proc** %p.addr, align 8, !dbg !3226
  %p_ucred59 = getelementptr inbounds %struct.proc* %61, i32 0, i32 3, !dbg !3226
  %62 = load %struct.ucred** %p_ucred59, align 8, !dbg !3226
  %cr_svuid = getelementptr inbounds %struct.ucred* %62, i32 0, i32 3, !dbg !3226
  %63 = load i32* %cr_svuid, align 4, !dbg !3226
  %cmp60 = icmp eq i32 %60, %63, !dbg !3226
  br i1 %cmp60, label %land.rhs62, label %land.end68, !dbg !3226

land.rhs62:                                       ; preds = %land.lhs.true56
  %64 = load %struct.thread** %td.addr, align 8, !dbg !3226
  %td_ucred63 = getelementptr inbounds %struct.thread* %64, i32 0, i32 37, !dbg !3226
  %65 = load %struct.ucred** %td_ucred63, align 8, !dbg !3226
  %cr_uid64 = getelementptr inbounds %struct.ucred* %65, i32 0, i32 1, !dbg !3226
  %66 = load i32* %cr_uid64, align 4, !dbg !3226
  %67 = load %struct.proc** %p.addr, align 8, !dbg !3226
  %p_ucred65 = getelementptr inbounds %struct.proc* %67, i32 0, i32 3, !dbg !3226
  %68 = load %struct.ucred** %p_ucred65, align 8, !dbg !3226
  %cr_ruid = getelementptr inbounds %struct.ucred* %68, i32 0, i32 2, !dbg !3226
  %69 = load i32* %cr_ruid, align 4, !dbg !3226
  %cmp66 = icmp eq i32 %66, %69, !dbg !3226
  br label %land.end68

land.end68:                                       ; preds = %land.rhs62, %land.lhs.true56, %land.end
  %70 = phi i1 [ false, %land.lhs.true56 ], [ false, %land.end ], [ %cmp66, %land.rhs62 ]
  %land.ext69 = zext i1 %70 to i32
  store i32 %land.ext69, i32* %uidsubset, align 4
  %71 = load %struct.proc** %p.addr, align 8, !dbg !3227
  %p_flag = getelementptr inbounds %struct.proc* %71, i32 0, i32 10, !dbg !3227
  %72 = load i32* %p_flag, align 4, !dbg !3227
  %and = and i32 %72, 256, !dbg !3227
  store i32 %and, i32* %credentialchanged, align 4, !dbg !3227
  %73 = load i32* %grpsubset, align 4, !dbg !3228
  %tobool70 = icmp ne i32 %73, 0, !dbg !3228
  br i1 %tobool70, label %lor.lhs.false, label %if.then72, !dbg !3228

lor.lhs.false:                                    ; preds = %land.end68
  %74 = load i32* %uidsubset, align 4, !dbg !3228
  %tobool71 = icmp ne i32 %74, 0, !dbg !3228
  br i1 %tobool71, label %if.end77, label %if.then72, !dbg !3228

if.then72:                                        ; preds = %lor.lhs.false, %land.end68
  %75 = load %struct.thread** %td.addr, align 8, !dbg !3229
  %call73 = call i32 @priv_check(%struct.thread* %75, i32 80) #5, !dbg !3229
  store i32 %call73, i32* %error, align 4, !dbg !3229
  %76 = load i32* %error, align 4, !dbg !3231
  %tobool74 = icmp ne i32 %76, 0, !dbg !3231
  br i1 %tobool74, label %if.then75, label %if.end76, !dbg !3231

if.then75:                                        ; preds = %if.then72
  %77 = load i32* %error, align 4, !dbg !3232
  store i32 %77, i32* %retval, !dbg !3232
  br label %return, !dbg !3232

if.end76:                                         ; preds = %if.then72
  br label %if.end77, !dbg !3233

if.end77:                                         ; preds = %if.end76, %lor.lhs.false
  %78 = load i32* %credentialchanged, align 4, !dbg !3234
  %tobool78 = icmp ne i32 %78, 0, !dbg !3234
  br i1 %tobool78, label %if.then79, label %if.end84, !dbg !3234

if.then79:                                        ; preds = %if.end77
  %79 = load %struct.thread** %td.addr, align 8, !dbg !3235
  %call80 = call i32 @priv_check(%struct.thread* %79, i32 81) #5, !dbg !3235
  store i32 %call80, i32* %error, align 4, !dbg !3235
  %80 = load i32* %error, align 4, !dbg !3237
  %tobool81 = icmp ne i32 %80, 0, !dbg !3237
  br i1 %tobool81, label %if.then82, label %if.end83, !dbg !3237

if.then82:                                        ; preds = %if.then79
  %81 = load i32* %error, align 4, !dbg !3238
  store i32 %81, i32* %retval, !dbg !3238
  br label %return, !dbg !3238

if.end83:                                         ; preds = %if.then79
  br label %if.end84, !dbg !3239

if.end84:                                         ; preds = %if.end83, %if.end77
  %82 = load %struct.proc** %p.addr, align 8, !dbg !3240
  %83 = load %struct.proc** @initproc, align 8, !dbg !3240
  %cmp85 = icmp eq %struct.proc* %82, %83, !dbg !3240
  br i1 %cmp85, label %if.then87, label %if.end93, !dbg !3240

if.then87:                                        ; preds = %if.end84
  %84 = load %struct.thread** %td.addr, align 8, !dbg !3241
  %td_ucred88 = getelementptr inbounds %struct.thread* %84, i32 0, i32 37, !dbg !3241
  %85 = load %struct.ucred** %td_ucred88, align 8, !dbg !3241
  %call89 = call i32 @securelevel_gt(%struct.ucred* %85, i32 0) #5, !dbg !3241
  store i32 %call89, i32* %error, align 4, !dbg !3241
  %86 = load i32* %error, align 4, !dbg !3243
  %tobool90 = icmp ne i32 %86, 0, !dbg !3243
  br i1 %tobool90, label %if.then91, label %if.end92, !dbg !3243

if.then91:                                        ; preds = %if.then87
  %87 = load i32* %error, align 4, !dbg !3244
  store i32 %87, i32* %retval, !dbg !3244
  br label %return, !dbg !3244

if.end92:                                         ; preds = %if.then87
  br label %if.end93, !dbg !3245

if.end93:                                         ; preds = %if.end92, %if.end84
  %88 = load %struct.proc** %p.addr, align 8, !dbg !3246
  %p_flag94 = getelementptr inbounds %struct.proc* %88, i32 0, i32 10, !dbg !3246
  %89 = load i32* %p_flag94, align 4, !dbg !3246
  %and95 = and i32 %89, 67108864, !dbg !3246
  %cmp96 = icmp ne i32 %and95, 0, !dbg !3246
  br i1 %cmp96, label %if.then98, label %if.end99, !dbg !3246

if.then98:                                        ; preds = %if.end93
  store i32 16, i32* %retval, !dbg !3247
  br label %return, !dbg !3247

if.end99:                                         ; preds = %if.end93
  store i32 0, i32* %retval, !dbg !3248
  br label %return, !dbg !3248

return:                                           ; preds = %if.end99, %if.then98, %if.then91, %if.then82, %if.then75, %if.then31, %if.then25, %if.then19, %if.then14, %if.then10, %if.then5
  %90 = load i32* %retval, !dbg !3249
  ret i32 %90, !dbg !3249
}

; Function Attrs: noimplicitfloat noredzone
declare i32 @mac_proc_check_debug(%struct.ucred*, %struct.proc*) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @cr_canseesocket(%struct.ucred* %cred, %struct.socket* %so) #0 {
entry:
  %retval = alloca i32, align 4
  %cred.addr = alloca %struct.ucred*, align 8
  %so.addr = alloca %struct.socket*, align 8
  %error = alloca i32, align 4
  store %struct.ucred* %cred, %struct.ucred** %cred.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %cred.addr}, metadata !3250), !dbg !3251
  store %struct.socket* %so, %struct.socket** %so.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.socket** %so.addr}, metadata !3252), !dbg !3251
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !3253), !dbg !3254
  %0 = load %struct.ucred** %cred.addr, align 8, !dbg !3255
  %1 = load %struct.socket** %so.addr, align 8, !dbg !3255
  %so_cred = getelementptr inbounds %struct.socket* %1, i32 0, i32 23, !dbg !3255
  %2 = load %struct.ucred** %so_cred, align 8, !dbg !3255
  %call = call i32 @prison_check(%struct.ucred* %0, %struct.ucred* %2) #5, !dbg !3255
  store i32 %call, i32* %error, align 4, !dbg !3255
  %3 = load i32* %error, align 4, !dbg !3256
  %tobool = icmp ne i32 %3, 0, !dbg !3256
  br i1 %tobool, label %if.then, label %if.end, !dbg !3256

if.then:                                          ; preds = %entry
  store i32 2, i32* %retval, !dbg !3257
  br label %return, !dbg !3257

if.end:                                           ; preds = %entry
  %4 = load %struct.ucred** %cred.addr, align 8, !dbg !3258
  %5 = load %struct.socket** %so.addr, align 8, !dbg !3258
  %call1 = call i32 @mac_socket_check_visible(%struct.ucred* %4, %struct.socket* %5) #5, !dbg !3258
  store i32 %call1, i32* %error, align 4, !dbg !3258
  %6 = load i32* %error, align 4, !dbg !3259
  %tobool2 = icmp ne i32 %6, 0, !dbg !3259
  br i1 %tobool2, label %if.then3, label %if.end4, !dbg !3259

if.then3:                                         ; preds = %if.end
  %7 = load i32* %error, align 4, !dbg !3260
  store i32 %7, i32* %retval, !dbg !3260
  br label %return, !dbg !3260

if.end4:                                          ; preds = %if.end
  %8 = load %struct.ucred** %cred.addr, align 8, !dbg !3261
  %9 = load %struct.socket** %so.addr, align 8, !dbg !3261
  %so_cred5 = getelementptr inbounds %struct.socket* %9, i32 0, i32 23, !dbg !3261
  %10 = load %struct.ucred** %so_cred5, align 8, !dbg !3261
  %call6 = call i32 @cr_seeotheruids(%struct.ucred* %8, %struct.ucred* %10) #5, !dbg !3261
  %tobool7 = icmp ne i32 %call6, 0, !dbg !3261
  br i1 %tobool7, label %if.then8, label %if.end9, !dbg !3261

if.then8:                                         ; preds = %if.end4
  store i32 2, i32* %retval, !dbg !3262
  br label %return, !dbg !3262

if.end9:                                          ; preds = %if.end4
  %11 = load %struct.ucred** %cred.addr, align 8, !dbg !3263
  %12 = load %struct.socket** %so.addr, align 8, !dbg !3263
  %so_cred10 = getelementptr inbounds %struct.socket* %12, i32 0, i32 23, !dbg !3263
  %13 = load %struct.ucred** %so_cred10, align 8, !dbg !3263
  %call11 = call i32 @cr_seeothergids(%struct.ucred* %11, %struct.ucred* %13) #5, !dbg !3263
  %tobool12 = icmp ne i32 %call11, 0, !dbg !3263
  br i1 %tobool12, label %if.then13, label %if.end14, !dbg !3263

if.then13:                                        ; preds = %if.end9
  store i32 2, i32* %retval, !dbg !3264
  br label %return, !dbg !3264

if.end14:                                         ; preds = %if.end9
  store i32 0, i32* %retval, !dbg !3265
  br label %return, !dbg !3265

return:                                           ; preds = %if.end14, %if.then13, %if.then8, %if.then3, %if.then
  %14 = load i32* %retval, !dbg !3266
  ret i32 %14, !dbg !3266
}

; Function Attrs: noimplicitfloat noredzone
declare i32 @mac_socket_check_visible(%struct.ucred*, %struct.socket*) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @cr_canseeinpcb(%struct.ucred* %cred, %struct.inpcb* %inp) #0 {
entry:
  %retval = alloca i32, align 4
  %cred.addr = alloca %struct.ucred*, align 8
  %inp.addr = alloca %struct.inpcb*, align 8
  %error = alloca i32, align 4
  store %struct.ucred* %cred, %struct.ucred** %cred.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %cred.addr}, metadata !3267), !dbg !3268
  store %struct.inpcb* %inp, %struct.inpcb** %inp.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.inpcb** %inp.addr}, metadata !3269), !dbg !3268
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !3270), !dbg !3271
  %0 = load %struct.ucred** %cred.addr, align 8, !dbg !3272
  %1 = load %struct.inpcb** %inp.addr, align 8, !dbg !3272
  %inp_cred = getelementptr inbounds %struct.inpcb* %1, i32 0, i32 8, !dbg !3272
  %2 = load %struct.ucred** %inp_cred, align 8, !dbg !3272
  %call = call i32 @prison_check(%struct.ucred* %0, %struct.ucred* %2) #5, !dbg !3272
  store i32 %call, i32* %error, align 4, !dbg !3272
  %3 = load i32* %error, align 4, !dbg !3273
  %tobool = icmp ne i32 %3, 0, !dbg !3273
  br i1 %tobool, label %if.then, label %if.end, !dbg !3273

if.then:                                          ; preds = %entry
  store i32 2, i32* %retval, !dbg !3274
  br label %return, !dbg !3274

if.end:                                           ; preds = %entry
  %4 = load %struct.inpcb** %inp.addr, align 8, !dbg !3275
  %inp_lock = getelementptr inbounds %struct.inpcb* %4, i32 0, i32 30, !dbg !3275
  %rw_lock = getelementptr inbounds %struct.rwlock* %inp_lock, i32 0, i32 1, !dbg !3275
  call void @__rw_assert(i64* %rw_lock, i32 1, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 1758) #5, !dbg !3275
  %5 = load %struct.ucred** %cred.addr, align 8, !dbg !3276
  %6 = load %struct.inpcb** %inp.addr, align 8, !dbg !3276
  %call1 = call i32 @mac_inpcb_check_visible(%struct.ucred* %5, %struct.inpcb* %6) #5, !dbg !3276
  store i32 %call1, i32* %error, align 4, !dbg !3276
  %7 = load i32* %error, align 4, !dbg !3277
  %tobool2 = icmp ne i32 %7, 0, !dbg !3277
  br i1 %tobool2, label %if.then3, label %if.end4, !dbg !3277

if.then3:                                         ; preds = %if.end
  %8 = load i32* %error, align 4, !dbg !3278
  store i32 %8, i32* %retval, !dbg !3278
  br label %return, !dbg !3278

if.end4:                                          ; preds = %if.end
  %9 = load %struct.ucred** %cred.addr, align 8, !dbg !3279
  %10 = load %struct.inpcb** %inp.addr, align 8, !dbg !3279
  %inp_cred5 = getelementptr inbounds %struct.inpcb* %10, i32 0, i32 8, !dbg !3279
  %11 = load %struct.ucred** %inp_cred5, align 8, !dbg !3279
  %call6 = call i32 @cr_seeotheruids(%struct.ucred* %9, %struct.ucred* %11) #5, !dbg !3279
  %tobool7 = icmp ne i32 %call6, 0, !dbg !3279
  br i1 %tobool7, label %if.then8, label %if.end9, !dbg !3279

if.then8:                                         ; preds = %if.end4
  store i32 2, i32* %retval, !dbg !3280
  br label %return, !dbg !3280

if.end9:                                          ; preds = %if.end4
  %12 = load %struct.ucred** %cred.addr, align 8, !dbg !3281
  %13 = load %struct.inpcb** %inp.addr, align 8, !dbg !3281
  %inp_cred10 = getelementptr inbounds %struct.inpcb* %13, i32 0, i32 8, !dbg !3281
  %14 = load %struct.ucred** %inp_cred10, align 8, !dbg !3281
  %call11 = call i32 @cr_seeothergids(%struct.ucred* %12, %struct.ucred* %14) #5, !dbg !3281
  %tobool12 = icmp ne i32 %call11, 0, !dbg !3281
  br i1 %tobool12, label %if.then13, label %if.end14, !dbg !3281

if.then13:                                        ; preds = %if.end9
  store i32 2, i32* %retval, !dbg !3282
  br label %return, !dbg !3282

if.end14:                                         ; preds = %if.end9
  store i32 0, i32* %retval, !dbg !3283
  br label %return, !dbg !3283

return:                                           ; preds = %if.end14, %if.then13, %if.then8, %if.then3, %if.then
  %15 = load i32* %retval, !dbg !3284
  ret i32 %15, !dbg !3284
}

; Function Attrs: noimplicitfloat noredzone
declare void @__rw_assert(i64*, i32, i8*, i32) #2

; Function Attrs: noimplicitfloat noredzone
declare i32 @mac_inpcb_check_visible(%struct.ucred*, %struct.inpcb*) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @p_canwait(%struct.thread* %td, %struct.proc* %p) #0 {
entry:
  %retval = alloca i32, align 4
  %td.addr = alloca %struct.thread*, align 8
  %p.addr = alloca %struct.proc*, align 8
  %error = alloca i32, align 4
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !3285), !dbg !3286
  store %struct.proc* %p, %struct.proc** %p.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p.addr}, metadata !3287), !dbg !3286
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !3288), !dbg !3289
  br label %do.body, !dbg !3290

do.body:                                          ; preds = %entry
  %0 = load %struct.thread** %td.addr, align 8, !dbg !3291
  %call = call %struct.thread* @__curthread() #6, !dbg !3291
  %cmp = icmp eq %struct.thread* %0, %call, !dbg !3291
  %lnot = xor i1 %cmp, true, !dbg !3291
  %lnot.ext = zext i1 %lnot to i32, !dbg !3291
  %conv = sext i32 %lnot.ext to i64, !dbg !3291
  %expval = call i64 @llvm.expect.i64(i64 %conv, i64 0), !dbg !3291
  %tobool = icmp ne i64 %expval, 0, !dbg !3291
  br i1 %tobool, label %if.then, label %if.end, !dbg !3291

if.then:                                          ; preds = %do.body
  call void (i8*, ...)* @kassert_panic(i8* getelementptr inbounds ([21 x i8]* @.str2, i32 0, i32 0), i8* getelementptr inbounds ([10 x i8]* @__func__.p_canwait, i32 0, i32 0)) #5, !dbg !3291
  br label %if.end, !dbg !3291

if.end:                                           ; preds = %if.then, %do.body
  br label %do.end, !dbg !3291

do.end:                                           ; preds = %if.end
  %1 = load %struct.proc** %p.addr, align 8, !dbg !3293
  %p_mtx = getelementptr inbounds %struct.proc* %1, i32 0, i32 18, !dbg !3293
  %mtx_lock = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !3293
  call void @__mtx_assert(i64* %mtx_lock, i32 4, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 1787) #5, !dbg !3293
  %2 = load %struct.thread** %td.addr, align 8, !dbg !3294
  %td_ucred = getelementptr inbounds %struct.thread* %2, i32 0, i32 37, !dbg !3294
  %3 = load %struct.ucred** %td_ucred, align 8, !dbg !3294
  %4 = load %struct.proc** %p.addr, align 8, !dbg !3294
  %p_ucred = getelementptr inbounds %struct.proc* %4, i32 0, i32 3, !dbg !3294
  %5 = load %struct.ucred** %p_ucred, align 8, !dbg !3294
  %call1 = call i32 @prison_check(%struct.ucred* %3, %struct.ucred* %5) #5, !dbg !3294
  store i32 %call1, i32* %error, align 4, !dbg !3294
  %tobool2 = icmp ne i32 %call1, 0, !dbg !3294
  br i1 %tobool2, label %if.then3, label %if.end4, !dbg !3294

if.then3:                                         ; preds = %do.end
  %6 = load i32* %error, align 4, !dbg !3295
  store i32 %6, i32* %retval, !dbg !3295
  br label %return, !dbg !3295

if.end4:                                          ; preds = %do.end
  %7 = load %struct.thread** %td.addr, align 8, !dbg !3296
  %td_ucred5 = getelementptr inbounds %struct.thread* %7, i32 0, i32 37, !dbg !3296
  %8 = load %struct.ucred** %td_ucred5, align 8, !dbg !3296
  %9 = load %struct.proc** %p.addr, align 8, !dbg !3296
  %call6 = call i32 @mac_proc_check_wait(%struct.ucred* %8, %struct.proc* %9) #5, !dbg !3296
  store i32 %call6, i32* %error, align 4, !dbg !3296
  %tobool7 = icmp ne i32 %call6, 0, !dbg !3296
  br i1 %tobool7, label %if.then8, label %if.end9, !dbg !3296

if.then8:                                         ; preds = %if.end4
  %10 = load i32* %error, align 4, !dbg !3297
  store i32 %10, i32* %retval, !dbg !3297
  br label %return, !dbg !3297

if.end9:                                          ; preds = %if.end4
  store i32 0, i32* %retval, !dbg !3298
  br label %return, !dbg !3298

return:                                           ; preds = %if.end9, %if.then8, %if.then3
  %11 = load i32* %retval, !dbg !3299
  ret i32 %11, !dbg !3299
}

; Function Attrs: noimplicitfloat noredzone
declare i32 @mac_proc_check_wait(%struct.ucred*, %struct.proc*) #2

; Function Attrs: inlinehint noimplicitfloat noredzone nounwind ssp
define internal void @refcount_init(i32* %count, i32 %value) #4 {
entry:
  %count.addr = alloca i32*, align 8
  %value.addr = alloca i32, align 4
  store i32* %count, i32** %count.addr, align 8
  call void @llvm.dbg.declare(metadata !{i32** %count.addr}, metadata !3300), !dbg !3301
  store i32 %value, i32* %value.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %value.addr}, metadata !3302), !dbg !3301
  %0 = load i32* %value.addr, align 4, !dbg !3303
  %1 = load i32** %count.addr, align 8, !dbg !3303
  store volatile i32 %0, i32* %1, align 4, !dbg !3303
  ret void, !dbg !3305
}

; Function Attrs: noimplicitfloat noredzone
declare void @audit_cred_init(%struct.ucred*) #2

; Function Attrs: noimplicitfloat noredzone
declare void @mac_cred_init(%struct.ucred*) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define %struct.ucred* @crhold(%struct.ucred* %cr) #0 {
entry:
  %cr.addr = alloca %struct.ucred*, align 8
  store %struct.ucred* %cr, %struct.ucred** %cr.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %cr.addr}, metadata !3306), !dbg !3307
  %0 = load %struct.ucred** %cr.addr, align 8, !dbg !3308
  %cr_ref = getelementptr inbounds %struct.ucred* %0, i32 0, i32 0, !dbg !3308
  call void @refcount_acquire(i32* %cr_ref) #5, !dbg !3308
  %1 = load %struct.ucred** %cr.addr, align 8, !dbg !3309
  ret %struct.ucred* %1, !dbg !3309
}

; Function Attrs: inlinehint noimplicitfloat noredzone nounwind ssp
define internal void @refcount_acquire(i32* %count) #4 {
entry:
  %count.addr = alloca i32*, align 8
  store i32* %count, i32** %count.addr, align 8
  call void @llvm.dbg.declare(metadata !{i32** %count.addr}, metadata !3310), !dbg !3311
  br label %do.body, !dbg !3312

do.body:                                          ; preds = %entry
  %0 = load i32** %count.addr, align 8, !dbg !3314
  %1 = load volatile i32* %0, align 4, !dbg !3314
  %cmp = icmp ult i32 %1, -1, !dbg !3314
  %lnot = xor i1 %cmp, true, !dbg !3314
  %lnot.ext = zext i1 %lnot to i32, !dbg !3314
  %conv = sext i32 %lnot.ext to i64, !dbg !3314
  %expval = call i64 @llvm.expect.i64(i64 %conv, i64 0), !dbg !3314
  %tobool = icmp ne i64 %expval, 0, !dbg !3314
  br i1 %tobool, label %if.then, label %if.end, !dbg !3314

if.then:                                          ; preds = %do.body
  %2 = load i32** %count.addr, align 8, !dbg !3314
  call void (i8*, ...)* @kassert_panic(i8* getelementptr inbounds ([23 x i8]* @.str8, i32 0, i32 0), i32* %2) #5, !dbg !3314
  br label %if.end, !dbg !3314

if.end:                                           ; preds = %if.then, %do.body
  br label %do.end, !dbg !3314

do.end:                                           ; preds = %if.end
  %3 = load i32** %count.addr, align 8, !dbg !3316
  call void @atomic_add_barr_int(i32* %3, i32 1) #5, !dbg !3316
  ret void, !dbg !3317
}

; Function Attrs: inlinehint noimplicitfloat noredzone nounwind ssp
define internal i32 @refcount_release(i32* %count) #4 {
entry:
  %count.addr = alloca i32*, align 8
  %old = alloca i32, align 4
  store i32* %count, i32** %count.addr, align 8
  call void @llvm.dbg.declare(metadata !{i32** %count.addr}, metadata !3318), !dbg !3319
  call void @llvm.dbg.declare(metadata !{i32* %old}, metadata !3320), !dbg !3322
  %0 = load i32** %count.addr, align 8, !dbg !3323
  %call = call i32 @atomic_fetchadd_int(i32* %0, i32 -1) #5, !dbg !3323
  store i32 %call, i32* %old, align 4, !dbg !3323
  br label %do.body, !dbg !3324

do.body:                                          ; preds = %entry
  %1 = load i32* %old, align 4, !dbg !3325
  %cmp = icmp ugt i32 %1, 0, !dbg !3325
  %lnot = xor i1 %cmp, true, !dbg !3325
  %lnot.ext = zext i1 %lnot to i32, !dbg !3325
  %conv = sext i32 %lnot.ext to i64, !dbg !3325
  %expval = call i64 @llvm.expect.i64(i64 %conv, i64 0), !dbg !3325
  %tobool = icmp ne i64 %expval, 0, !dbg !3325
  br i1 %tobool, label %if.then, label %if.end, !dbg !3325

if.then:                                          ; preds = %do.body
  %2 = load i32** %count.addr, align 8, !dbg !3325
  call void (i8*, ...)* @kassert_panic(i8* getelementptr inbounds ([21 x i8]* @.str7, i32 0, i32 0), i32* %2) #5, !dbg !3325
  br label %if.end, !dbg !3325

if.end:                                           ; preds = %if.then, %do.body
  br label %do.end, !dbg !3325

do.end:                                           ; preds = %if.end
  %3 = load i32* %old, align 4, !dbg !3327
  %cmp1 = icmp eq i32 %3, 1, !dbg !3327
  %conv2 = zext i1 %cmp1 to i32, !dbg !3327
  ret i32 %conv2, !dbg !3327
}

; Function Attrs: noimplicitfloat noredzone
declare void @prison_free(%struct.prison*) #2

; Function Attrs: noimplicitfloat noredzone
declare void @loginclass_free(%struct.loginclass*) #2

; Function Attrs: noimplicitfloat noredzone
declare void @audit_cred_destroy(%struct.ucred*) #2

; Function Attrs: noimplicitfloat noredzone
declare void @mac_cred_destroy(%struct.ucred*) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @crshared(%struct.ucred* %cr) #0 {
entry:
  %cr.addr = alloca %struct.ucred*, align 8
  store %struct.ucred* %cr, %struct.ucred** %cr.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %cr.addr}, metadata !3328), !dbg !3329
  %0 = load %struct.ucred** %cr.addr, align 8, !dbg !3330
  %cr_ref = getelementptr inbounds %struct.ucred* %0, i32 0, i32 0, !dbg !3330
  %1 = load i32* %cr_ref, align 4, !dbg !3330
  %cmp = icmp ugt i32 %1, 1, !dbg !3330
  %conv = zext i1 %cmp to i32, !dbg !3330
  ret i32 %conv, !dbg !3330
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define void @crcopy(%struct.ucred* %dest, %struct.ucred* %src) #0 {
entry:
  %dest.addr = alloca %struct.ucred*, align 8
  %src.addr = alloca %struct.ucred*, align 8
  store %struct.ucred* %dest, %struct.ucred** %dest.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %dest.addr}, metadata !3331), !dbg !3332
  store %struct.ucred* %src, %struct.ucred** %src.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %src.addr}, metadata !3333), !dbg !3332
  br label %do.body, !dbg !3334

do.body:                                          ; preds = %entry
  %0 = load %struct.ucred** %dest.addr, align 8, !dbg !3335
  %call = call i32 @crshared(%struct.ucred* %0) #5, !dbg !3335
  %cmp = icmp eq i32 %call, 0, !dbg !3335
  %lnot = xor i1 %cmp, true, !dbg !3335
  %lnot.ext = zext i1 %lnot to i32, !dbg !3335
  %conv = sext i32 %lnot.ext to i64, !dbg !3335
  %expval = call i64 @llvm.expect.i64(i64 %conv, i64 0), !dbg !3335
  %tobool = icmp ne i64 %expval, 0, !dbg !3335
  br i1 %tobool, label %if.then, label %if.end, !dbg !3335

if.then:                                          ; preds = %do.body
  call void (i8*, ...)* @kassert_panic(i8* getelementptr inbounds ([23 x i8]* @.str5, i32 0, i32 0)) #5, !dbg !3335
  br label %if.end, !dbg !3335

if.end:                                           ; preds = %if.then, %do.body
  br label %do.end, !dbg !3335

do.end:                                           ; preds = %if.end
  %1 = load %struct.ucred** %src.addr, align 8, !dbg !3337
  %cr_uid = getelementptr inbounds %struct.ucred* %1, i32 0, i32 1, !dbg !3337
  %2 = bitcast i32* %cr_uid to i8*, !dbg !3337
  %3 = load %struct.ucred** %dest.addr, align 8, !dbg !3337
  %cr_uid1 = getelementptr inbounds %struct.ucred* %3, i32 0, i32 1, !dbg !3337
  %4 = bitcast i32* %cr_uid1 to i8*, !dbg !3337
  %5 = load %struct.ucred** %src.addr, align 8, !dbg !3337
  %cr_label = getelementptr inbounds %struct.ucred* %5, i32 0, i32 13, !dbg !3337
  %6 = bitcast %struct.label** %cr_label to i8*, !dbg !3337
  %7 = load %struct.ucred** %src.addr, align 8, !dbg !3337
  %cr_uid2 = getelementptr inbounds %struct.ucred* %7, i32 0, i32 1, !dbg !3337
  %8 = bitcast i32* %cr_uid2 to i8*, !dbg !3337
  %sub.ptr.lhs.cast = ptrtoint i8* %6 to i64, !dbg !3337
  %sub.ptr.rhs.cast = ptrtoint i8* %8 to i64, !dbg !3337
  %sub.ptr.sub = sub i64 %sub.ptr.lhs.cast, %sub.ptr.rhs.cast, !dbg !3337
  %conv3 = trunc i64 %sub.ptr.sub to i32, !dbg !3337
  %conv4 = zext i32 %conv3 to i64, !dbg !3337
  call void @bcopy(i8* %2, i8* %4, i64 %conv4) #5, !dbg !3337
  %9 = load %struct.ucred** %dest.addr, align 8, !dbg !3338
  %10 = load %struct.ucred** %src.addr, align 8, !dbg !3338
  %cr_ngroups = getelementptr inbounds %struct.ucred* %10, i32 0, i32 4, !dbg !3338
  %11 = load i32* %cr_ngroups, align 4, !dbg !3338
  %12 = load %struct.ucred** %src.addr, align 8, !dbg !3338
  %cr_groups = getelementptr inbounds %struct.ucred* %12, i32 0, i32 15, !dbg !3338
  %13 = load i32** %cr_groups, align 8, !dbg !3338
  call void @crsetgroups(%struct.ucred* %9, i32 %11, i32* %13) #5, !dbg !3338
  %14 = load %struct.ucred** %dest.addr, align 8, !dbg !3339
  %cr_uidinfo = getelementptr inbounds %struct.ucred* %14, i32 0, i32 7, !dbg !3339
  %15 = load %struct.uidinfo** %cr_uidinfo, align 8, !dbg !3339
  call void @uihold(%struct.uidinfo* %15) #5, !dbg !3339
  %16 = load %struct.ucred** %dest.addr, align 8, !dbg !3340
  %cr_ruidinfo = getelementptr inbounds %struct.ucred* %16, i32 0, i32 8, !dbg !3340
  %17 = load %struct.uidinfo** %cr_ruidinfo, align 8, !dbg !3340
  call void @uihold(%struct.uidinfo* %17) #5, !dbg !3340
  %18 = load %struct.ucred** %dest.addr, align 8, !dbg !3341
  %cr_prison = getelementptr inbounds %struct.ucred* %18, i32 0, i32 9, !dbg !3341
  %19 = load %struct.prison** %cr_prison, align 8, !dbg !3341
  call void @prison_hold(%struct.prison* %19) #5, !dbg !3341
  %20 = load %struct.ucred** %dest.addr, align 8, !dbg !3342
  %cr_loginclass = getelementptr inbounds %struct.ucred* %20, i32 0, i32 10, !dbg !3342
  %21 = load %struct.loginclass** %cr_loginclass, align 8, !dbg !3342
  call void @loginclass_hold(%struct.loginclass* %21) #5, !dbg !3342
  %22 = load %struct.ucred** %src.addr, align 8, !dbg !3343
  %23 = load %struct.ucred** %dest.addr, align 8, !dbg !3343
  call void @audit_cred_copy(%struct.ucred* %22, %struct.ucred* %23) #5, !dbg !3343
  %24 = load %struct.ucred** %src.addr, align 8, !dbg !3344
  %25 = load %struct.ucred** %dest.addr, align 8, !dbg !3344
  call void @mac_cred_copy(%struct.ucred* %24, %struct.ucred* %25) #5, !dbg !3344
  ret void, !dbg !3345
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define void @crsetgroups(%struct.ucred* %cr, i32 %ngrp, i32* %groups) #0 {
entry:
  %cr.addr = alloca %struct.ucred*, align 8
  %ngrp.addr = alloca i32, align 4
  %groups.addr = alloca i32*, align 8
  store %struct.ucred* %cr, %struct.ucred** %cr.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %cr.addr}, metadata !3346), !dbg !3347
  store i32 %ngrp, i32* %ngrp.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %ngrp.addr}, metadata !3348), !dbg !3347
  store i32* %groups, i32** %groups.addr, align 8
  call void @llvm.dbg.declare(metadata !{i32** %groups.addr}, metadata !3349), !dbg !3347
  %0 = load i32* %ngrp.addr, align 4, !dbg !3350
  %1 = load i32* @ngroups_max, align 4, !dbg !3350
  %add = add nsw i32 %1, 1, !dbg !3350
  %cmp = icmp sgt i32 %0, %add, !dbg !3350
  br i1 %cmp, label %if.then, label %if.end, !dbg !3350

if.then:                                          ; preds = %entry
  %2 = load i32* @ngroups_max, align 4, !dbg !3351
  %add1 = add nsw i32 %2, 1, !dbg !3351
  store i32 %add1, i32* %ngrp.addr, align 4, !dbg !3351
  br label %if.end, !dbg !3351

if.end:                                           ; preds = %if.then, %entry
  %3 = load %struct.ucred** %cr.addr, align 8, !dbg !3352
  %4 = load i32* %ngrp.addr, align 4, !dbg !3352
  call void @crextend(%struct.ucred* %3, i32 %4) #5, !dbg !3352
  %5 = load %struct.ucred** %cr.addr, align 8, !dbg !3353
  %6 = load i32* %ngrp.addr, align 4, !dbg !3353
  %7 = load i32** %groups.addr, align 8, !dbg !3353
  call void @crsetgroups_locked(%struct.ucred* %5, i32 %6, i32* %7) #5, !dbg !3353
  ret void, !dbg !3354
}

; Function Attrs: noimplicitfloat noredzone
declare void @uihold(%struct.uidinfo*) #2

; Function Attrs: noimplicitfloat noredzone
declare void @prison_hold(%struct.prison*) #2

; Function Attrs: noimplicitfloat noredzone
declare void @loginclass_hold(%struct.loginclass*) #2

; Function Attrs: noimplicitfloat noredzone
declare void @audit_cred_copy(%struct.ucred*, %struct.ucred*) #2

; Function Attrs: noimplicitfloat noredzone
declare void @mac_cred_copy(%struct.ucred*, %struct.ucred*) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define %struct.ucred* @crdup(%struct.ucred* %cr) #0 {
entry:
  %cr.addr = alloca %struct.ucred*, align 8
  %newcr = alloca %struct.ucred*, align 8
  store %struct.ucred* %cr, %struct.ucred** %cr.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %cr.addr}, metadata !3355), !dbg !3356
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %newcr}, metadata !3357), !dbg !3358
  %call = call %struct.ucred* @crget() #5, !dbg !3359
  store %struct.ucred* %call, %struct.ucred** %newcr, align 8, !dbg !3359
  %0 = load %struct.ucred** %newcr, align 8, !dbg !3360
  %1 = load %struct.ucred** %cr.addr, align 8, !dbg !3360
  call void @crcopy(%struct.ucred* %0, %struct.ucred* %1) #5, !dbg !3360
  %2 = load %struct.ucred** %newcr, align 8, !dbg !3361
  ret %struct.ucred* %2, !dbg !3361
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define void @cru2x(%struct.ucred* %cr, %struct.xucred* %xcr) #0 {
entry:
  %cr.addr = alloca %struct.ucred*, align 8
  %xcr.addr = alloca %struct.xucred*, align 8
  %ngroups = alloca i32, align 4
  store %struct.ucred* %cr, %struct.ucred** %cr.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %cr.addr}, metadata !3362), !dbg !3363
  store %struct.xucred* %xcr, %struct.xucred** %xcr.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.xucred** %xcr.addr}, metadata !3364), !dbg !3363
  call void @llvm.dbg.declare(metadata !{i32* %ngroups}, metadata !3365), !dbg !3366
  %0 = load %struct.xucred** %xcr.addr, align 8, !dbg !3367
  %1 = bitcast %struct.xucred* %0 to i8*, !dbg !3367
  call void @bzero(i8* %1, i64 88) #5, !dbg !3367
  %2 = load %struct.xucred** %xcr.addr, align 8, !dbg !3368
  %cr_version = getelementptr inbounds %struct.xucred* %2, i32 0, i32 0, !dbg !3368
  store i32 0, i32* %cr_version, align 4, !dbg !3368
  %3 = load %struct.ucred** %cr.addr, align 8, !dbg !3369
  %cr_uid = getelementptr inbounds %struct.ucred* %3, i32 0, i32 1, !dbg !3369
  %4 = load i32* %cr_uid, align 4, !dbg !3369
  %5 = load %struct.xucred** %xcr.addr, align 8, !dbg !3369
  %cr_uid1 = getelementptr inbounds %struct.xucred* %5, i32 0, i32 1, !dbg !3369
  store i32 %4, i32* %cr_uid1, align 4, !dbg !3369
  %6 = load %struct.ucred** %cr.addr, align 8, !dbg !3370
  %cr_ngroups = getelementptr inbounds %struct.ucred* %6, i32 0, i32 4, !dbg !3370
  %7 = load i32* %cr_ngroups, align 4, !dbg !3370
  %cmp = icmp slt i32 %7, 16, !dbg !3370
  br i1 %cmp, label %cond.true, label %cond.false, !dbg !3370

cond.true:                                        ; preds = %entry
  %8 = load %struct.ucred** %cr.addr, align 8, !dbg !3370
  %cr_ngroups2 = getelementptr inbounds %struct.ucred* %8, i32 0, i32 4, !dbg !3370
  %9 = load i32* %cr_ngroups2, align 4, !dbg !3370
  br label %cond.end, !dbg !3370

cond.false:                                       ; preds = %entry
  br label %cond.end, !dbg !3370

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi i32 [ %9, %cond.true ], [ 16, %cond.false ], !dbg !3370
  store i32 %cond, i32* %ngroups, align 4, !dbg !3370
  %10 = load i32* %ngroups, align 4, !dbg !3371
  %conv = trunc i32 %10 to i16, !dbg !3371
  %11 = load %struct.xucred** %xcr.addr, align 8, !dbg !3371
  %cr_ngroups3 = getelementptr inbounds %struct.xucred* %11, i32 0, i32 2, !dbg !3371
  store i16 %conv, i16* %cr_ngroups3, align 2, !dbg !3371
  %12 = load %struct.ucred** %cr.addr, align 8, !dbg !3372
  %cr_groups = getelementptr inbounds %struct.ucred* %12, i32 0, i32 15, !dbg !3372
  %13 = load i32** %cr_groups, align 8, !dbg !3372
  %14 = bitcast i32* %13 to i8*, !dbg !3372
  %15 = load %struct.xucred** %xcr.addr, align 8, !dbg !3372
  %cr_groups4 = getelementptr inbounds %struct.xucred* %15, i32 0, i32 3, !dbg !3372
  %arraydecay = getelementptr inbounds [16 x i32]* %cr_groups4, i32 0, i32 0, !dbg !3372
  %16 = bitcast i32* %arraydecay to i8*, !dbg !3372
  %17 = load i32* %ngroups, align 4, !dbg !3372
  %conv5 = sext i32 %17 to i64, !dbg !3372
  %mul = mul i64 %conv5, 4, !dbg !3372
  call void @bcopy(i8* %14, i8* %16, i64 %mul) #5, !dbg !3372
  ret void, !dbg !3373
}

; Function Attrs: noimplicitfloat noredzone
declare void @bzero(i8*, i64) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define void @cred_update_thread(%struct.thread* %td) #0 {
entry:
  %td.addr = alloca %struct.thread*, align 8
  %p = alloca %struct.proc*, align 8
  %cred = alloca %struct.ucred*, align 8
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !3374), !dbg !3375
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p}, metadata !3376), !dbg !3377
  call void @llvm.dbg.declare(metadata !{%struct.ucred** %cred}, metadata !3378), !dbg !3379
  %0 = load %struct.thread** %td.addr, align 8, !dbg !3380
  %td_proc = getelementptr inbounds %struct.thread* %0, i32 0, i32 1, !dbg !3380
  %1 = load %struct.proc** %td_proc, align 8, !dbg !3380
  store %struct.proc* %1, %struct.proc** %p, align 8, !dbg !3380
  %2 = load %struct.thread** %td.addr, align 8, !dbg !3381
  %td_ucred = getelementptr inbounds %struct.thread* %2, i32 0, i32 37, !dbg !3381
  %3 = load %struct.ucred** %td_ucred, align 8, !dbg !3381
  store %struct.ucred* %3, %struct.ucred** %cred, align 8, !dbg !3381
  %4 = load %struct.proc** %p, align 8, !dbg !3382
  %p_mtx = getelementptr inbounds %struct.proc* %4, i32 0, i32 18, !dbg !3382
  %mtx_lock = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !3382
  call void @__mtx_lock_flags(i64* %mtx_lock, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 1948) #5, !dbg !3382
  %5 = load %struct.proc** %p, align 8, !dbg !3383
  %p_ucred = getelementptr inbounds %struct.proc* %5, i32 0, i32 3, !dbg !3383
  %6 = load %struct.ucred** %p_ucred, align 8, !dbg !3383
  %call = call %struct.ucred* @crhold(%struct.ucred* %6) #5, !dbg !3383
  %7 = load %struct.thread** %td.addr, align 8, !dbg !3383
  %td_ucred1 = getelementptr inbounds %struct.thread* %7, i32 0, i32 37, !dbg !3383
  store %struct.ucred* %call, %struct.ucred** %td_ucred1, align 8, !dbg !3383
  %8 = load %struct.proc** %p, align 8, !dbg !3384
  %p_mtx2 = getelementptr inbounds %struct.proc* %8, i32 0, i32 18, !dbg !3384
  %mtx_lock3 = getelementptr inbounds %struct.mtx* %p_mtx2, i32 0, i32 1, !dbg !3384
  call void @__mtx_unlock_flags(i64* %mtx_lock3, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 1950) #5, !dbg !3384
  %9 = load %struct.ucred** %cred, align 8, !dbg !3385
  %cmp = icmp ne %struct.ucred* %9, null, !dbg !3385
  br i1 %cmp, label %if.then, label %if.end, !dbg !3385

if.then:                                          ; preds = %entry
  %10 = load %struct.ucred** %cred, align 8, !dbg !3386
  call void @crfree(%struct.ucred* %10) #5, !dbg !3386
  br label %if.end, !dbg !3386

if.end:                                           ; preds = %if.then, %entry
  ret void, !dbg !3387
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys_getlogin(%struct.thread* %td, %struct.getlogin_args* %uap) #0 {
entry:
  %retval = alloca i32, align 4
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.getlogin_args*, align 8
  %error = alloca i32, align 4
  %login = alloca [33 x i8], align 16
  %p = alloca %struct.proc*, align 8
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !3388), !dbg !3389
  store %struct.getlogin_args* %uap, %struct.getlogin_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.getlogin_args** %uap.addr}, metadata !3390), !dbg !3389
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !3391), !dbg !3392
  call void @llvm.dbg.declare(metadata !{[33 x i8]* %login}, metadata !3393), !dbg !3394
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p}, metadata !3395), !dbg !3396
  %0 = load %struct.thread** %td.addr, align 8, !dbg !3396
  %td_proc = getelementptr inbounds %struct.thread* %0, i32 0, i32 1, !dbg !3396
  %1 = load %struct.proc** %td_proc, align 8, !dbg !3396
  store %struct.proc* %1, %struct.proc** %p, align 8, !dbg !3396
  %2 = load %struct.getlogin_args** %uap.addr, align 8, !dbg !3397
  %namelen = getelementptr inbounds %struct.getlogin_args* %2, i32 0, i32 4, !dbg !3397
  %3 = load i32* %namelen, align 4, !dbg !3397
  %cmp = icmp ugt i32 %3, 33, !dbg !3397
  br i1 %cmp, label %if.then, label %if.end, !dbg !3397

if.then:                                          ; preds = %entry
  %4 = load %struct.getlogin_args** %uap.addr, align 8, !dbg !3398
  %namelen1 = getelementptr inbounds %struct.getlogin_args* %4, i32 0, i32 4, !dbg !3398
  store i32 33, i32* %namelen1, align 4, !dbg !3398
  br label %if.end, !dbg !3398

if.end:                                           ; preds = %if.then, %entry
  %5 = load %struct.proc** %p, align 8, !dbg !3399
  %p_mtx = getelementptr inbounds %struct.proc* %5, i32 0, i32 18, !dbg !3399
  %mtx_lock = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !3399
  call void @__mtx_lock_flags(i64* %mtx_lock, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 2084) #5, !dbg !3399
  %6 = load %struct.proc** %p, align 8, !dbg !3400
  %p_pgrp = getelementptr inbounds %struct.proc* %6, i32 0, i32 55, !dbg !3400
  %7 = load %struct.pgrp** %p_pgrp, align 8, !dbg !3400
  %pg_session = getelementptr inbounds %struct.pgrp* %7, i32 0, i32 2, !dbg !3400
  %8 = load %struct.session** %pg_session, align 8, !dbg !3400
  %s_mtx = getelementptr inbounds %struct.session* %8, i32 0, i32 7, !dbg !3400
  %mtx_lock2 = getelementptr inbounds %struct.mtx* %s_mtx, i32 0, i32 1, !dbg !3400
  call void @__mtx_lock_flags(i64* %mtx_lock2, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 2085) #5, !dbg !3400
  %9 = load %struct.proc** %p, align 8, !dbg !3401
  %p_pgrp3 = getelementptr inbounds %struct.proc* %9, i32 0, i32 55, !dbg !3401
  %10 = load %struct.pgrp** %p_pgrp3, align 8, !dbg !3401
  %pg_session4 = getelementptr inbounds %struct.pgrp* %10, i32 0, i32 2, !dbg !3401
  %11 = load %struct.session** %pg_session4, align 8, !dbg !3401
  %s_login = getelementptr inbounds %struct.session* %11, i32 0, i32 6, !dbg !3401
  %arraydecay = getelementptr inbounds [40 x i8]* %s_login, i32 0, i32 0, !dbg !3401
  %arraydecay5 = getelementptr inbounds [33 x i8]* %login, i32 0, i32 0, !dbg !3401
  %12 = load %struct.getlogin_args** %uap.addr, align 8, !dbg !3401
  %namelen6 = getelementptr inbounds %struct.getlogin_args* %12, i32 0, i32 4, !dbg !3401
  %13 = load i32* %namelen6, align 4, !dbg !3401
  %conv = zext i32 %13 to i64, !dbg !3401
  call void @bcopy(i8* %arraydecay, i8* %arraydecay5, i64 %conv) #5, !dbg !3401
  %14 = load %struct.proc** %p, align 8, !dbg !3402
  %p_pgrp7 = getelementptr inbounds %struct.proc* %14, i32 0, i32 55, !dbg !3402
  %15 = load %struct.pgrp** %p_pgrp7, align 8, !dbg !3402
  %pg_session8 = getelementptr inbounds %struct.pgrp* %15, i32 0, i32 2, !dbg !3402
  %16 = load %struct.session** %pg_session8, align 8, !dbg !3402
  %s_mtx9 = getelementptr inbounds %struct.session* %16, i32 0, i32 7, !dbg !3402
  %mtx_lock10 = getelementptr inbounds %struct.mtx* %s_mtx9, i32 0, i32 1, !dbg !3402
  call void @__mtx_unlock_flags(i64* %mtx_lock10, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 2087) #5, !dbg !3402
  %17 = load %struct.proc** %p, align 8, !dbg !3403
  %p_mtx11 = getelementptr inbounds %struct.proc* %17, i32 0, i32 18, !dbg !3403
  %mtx_lock12 = getelementptr inbounds %struct.mtx* %p_mtx11, i32 0, i32 1, !dbg !3403
  call void @__mtx_unlock_flags(i64* %mtx_lock12, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 2088) #5, !dbg !3403
  %arraydecay13 = getelementptr inbounds [33 x i8]* %login, i32 0, i32 0, !dbg !3404
  %call = call i64 @strlen(i8* %arraydecay13) #5, !dbg !3404
  %add = add i64 %call, 1, !dbg !3404
  %18 = load %struct.getlogin_args** %uap.addr, align 8, !dbg !3404
  %namelen14 = getelementptr inbounds %struct.getlogin_args* %18, i32 0, i32 4, !dbg !3404
  %19 = load i32* %namelen14, align 4, !dbg !3404
  %conv15 = zext i32 %19 to i64, !dbg !3404
  %cmp16 = icmp ugt i64 %add, %conv15, !dbg !3404
  br i1 %cmp16, label %if.then18, label %if.end19, !dbg !3404

if.then18:                                        ; preds = %if.end
  store i32 34, i32* %retval, !dbg !3405
  br label %return, !dbg !3405

if.end19:                                         ; preds = %if.end
  %arraydecay20 = getelementptr inbounds [33 x i8]* %login, i32 0, i32 0, !dbg !3406
  %20 = load %struct.getlogin_args** %uap.addr, align 8, !dbg !3406
  %namebuf = getelementptr inbounds %struct.getlogin_args* %20, i32 0, i32 1, !dbg !3406
  %21 = load i8** %namebuf, align 8, !dbg !3406
  %22 = load %struct.getlogin_args** %uap.addr, align 8, !dbg !3406
  %namelen21 = getelementptr inbounds %struct.getlogin_args* %22, i32 0, i32 4, !dbg !3406
  %23 = load i32* %namelen21, align 4, !dbg !3406
  %conv22 = zext i32 %23 to i64, !dbg !3406
  %call23 = call i32 @copyout(i8* %arraydecay20, i8* %21, i64 %conv22) #5, !dbg !3406
  store i32 %call23, i32* %error, align 4, !dbg !3406
  %24 = load i32* %error, align 4, !dbg !3407
  store i32 %24, i32* %retval, !dbg !3407
  br label %return, !dbg !3407

return:                                           ; preds = %if.end19, %if.then18
  %25 = load i32* %retval, !dbg !3408
  ret i32 %25, !dbg !3408
}

; Function Attrs: noimplicitfloat noredzone
declare i64 @strlen(i8*) #2

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys_setlogin(%struct.thread* %td, %struct.setlogin_args* %uap) #0 {
entry:
  %retval = alloca i32, align 4
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.setlogin_args*, align 8
  %p = alloca %struct.proc*, align 8
  %error = alloca i32, align 4
  %logintmp = alloca [33 x i8], align 16
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !3409), !dbg !3410
  store %struct.setlogin_args* %uap, %struct.setlogin_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.setlogin_args** %uap.addr}, metadata !3411), !dbg !3410
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p}, metadata !3412), !dbg !3413
  %0 = load %struct.thread** %td.addr, align 8, !dbg !3413
  %td_proc = getelementptr inbounds %struct.thread* %0, i32 0, i32 1, !dbg !3413
  %1 = load %struct.proc** %td_proc, align 8, !dbg !3413
  store %struct.proc* %1, %struct.proc** %p, align 8, !dbg !3413
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !3414), !dbg !3415
  call void @llvm.dbg.declare(metadata !{[33 x i8]* %logintmp}, metadata !3416), !dbg !3417
  %2 = load %struct.thread** %td.addr, align 8, !dbg !3418
  %call = call i32 @priv_check(%struct.thread* %2, i32 161) #5, !dbg !3418
  store i32 %call, i32* %error, align 4, !dbg !3418
  %3 = load i32* %error, align 4, !dbg !3419
  %tobool = icmp ne i32 %3, 0, !dbg !3419
  br i1 %tobool, label %if.then, label %if.end, !dbg !3419

if.then:                                          ; preds = %entry
  %4 = load i32* %error, align 4, !dbg !3420
  store i32 %4, i32* %retval, !dbg !3420
  br label %return, !dbg !3420

if.end:                                           ; preds = %entry
  %5 = load %struct.setlogin_args** %uap.addr, align 8, !dbg !3421
  %namebuf = getelementptr inbounds %struct.setlogin_args* %5, i32 0, i32 1, !dbg !3421
  %6 = load i8** %namebuf, align 8, !dbg !3421
  %arraydecay = getelementptr inbounds [33 x i8]* %logintmp, i32 0, i32 0, !dbg !3421
  %call1 = call i32 @copyinstr(i8* %6, i8* %arraydecay, i64 33, i64* null) #5, !dbg !3421
  store i32 %call1, i32* %error, align 4, !dbg !3421
  %7 = load i32* %error, align 4, !dbg !3422
  %cmp = icmp eq i32 %7, 63, !dbg !3422
  br i1 %cmp, label %if.then2, label %if.else, !dbg !3422

if.then2:                                         ; preds = %if.end
  store i32 22, i32* %error, align 4, !dbg !3423
  br label %if.end18, !dbg !3423

if.else:                                          ; preds = %if.end
  %8 = load i32* %error, align 4, !dbg !3424
  %tobool3 = icmp ne i32 %8, 0, !dbg !3424
  br i1 %tobool3, label %if.end17, label %if.then4, !dbg !3424

if.then4:                                         ; preds = %if.else
  %9 = load %struct.proc** %p, align 8, !dbg !3425
  %p_mtx = getelementptr inbounds %struct.proc* %9, i32 0, i32 18, !dbg !3425
  %mtx_lock = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !3425
  call void @__mtx_lock_flags(i64* %mtx_lock, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 2118) #5, !dbg !3425
  %10 = load %struct.proc** %p, align 8, !dbg !3427
  %p_pgrp = getelementptr inbounds %struct.proc* %10, i32 0, i32 55, !dbg !3427
  %11 = load %struct.pgrp** %p_pgrp, align 8, !dbg !3427
  %pg_session = getelementptr inbounds %struct.pgrp* %11, i32 0, i32 2, !dbg !3427
  %12 = load %struct.session** %pg_session, align 8, !dbg !3427
  %s_mtx = getelementptr inbounds %struct.session* %12, i32 0, i32 7, !dbg !3427
  %mtx_lock5 = getelementptr inbounds %struct.mtx* %s_mtx, i32 0, i32 1, !dbg !3427
  call void @__mtx_lock_flags(i64* %mtx_lock5, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 2119) #5, !dbg !3427
  %13 = load %struct.proc** %p, align 8, !dbg !3428
  %p_pgrp6 = getelementptr inbounds %struct.proc* %13, i32 0, i32 55, !dbg !3428
  %14 = load %struct.pgrp** %p_pgrp6, align 8, !dbg !3428
  %pg_session7 = getelementptr inbounds %struct.pgrp* %14, i32 0, i32 2, !dbg !3428
  %15 = load %struct.session** %pg_session7, align 8, !dbg !3428
  %s_login = getelementptr inbounds %struct.session* %15, i32 0, i32 6, !dbg !3428
  %arraydecay8 = getelementptr inbounds [40 x i8]* %s_login, i32 0, i32 0, !dbg !3428
  %arraydecay9 = getelementptr inbounds [33 x i8]* %logintmp, i32 0, i32 0, !dbg !3428
  %call10 = call i8* @memcpy(i8* %arraydecay8, i8* %arraydecay9, i64 33) #5, !dbg !3428
  %16 = load %struct.proc** %p, align 8, !dbg !3429
  %p_pgrp11 = getelementptr inbounds %struct.proc* %16, i32 0, i32 55, !dbg !3429
  %17 = load %struct.pgrp** %p_pgrp11, align 8, !dbg !3429
  %pg_session12 = getelementptr inbounds %struct.pgrp* %17, i32 0, i32 2, !dbg !3429
  %18 = load %struct.session** %pg_session12, align 8, !dbg !3429
  %s_mtx13 = getelementptr inbounds %struct.session* %18, i32 0, i32 7, !dbg !3429
  %mtx_lock14 = getelementptr inbounds %struct.mtx* %s_mtx13, i32 0, i32 1, !dbg !3429
  call void @__mtx_unlock_flags(i64* %mtx_lock14, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 2122) #5, !dbg !3429
  %19 = load %struct.proc** %p, align 8, !dbg !3430
  %p_mtx15 = getelementptr inbounds %struct.proc* %19, i32 0, i32 18, !dbg !3430
  %mtx_lock16 = getelementptr inbounds %struct.mtx* %p_mtx15, i32 0, i32 1, !dbg !3430
  call void @__mtx_unlock_flags(i64* %mtx_lock16, i32 0, i8* getelementptr inbounds ([66 x i8]* @.str, i32 0, i32 0), i32 2123) #5, !dbg !3430
  br label %if.end17, !dbg !3431

if.end17:                                         ; preds = %if.then4, %if.else
  br label %if.end18

if.end18:                                         ; preds = %if.end17, %if.then2
  %20 = load i32* %error, align 4, !dbg !3432
  store i32 %20, i32* %retval, !dbg !3432
  br label %return, !dbg !3432

return:                                           ; preds = %if.end18, %if.then
  %21 = load i32* %retval, !dbg !3433
  ret i32 %21, !dbg !3433
}

; Function Attrs: noimplicitfloat noredzone
declare i32 @copyinstr(i8*, i8*, i64, i64*) #2

; Function Attrs: noimplicitfloat noredzone
declare i8* @memcpy(i8*, i8*, i64) #2

; Function Attrs: noimplicitfloat noredzone
declare void @__tesla_inline_assertion(i8*, i32, i32, %struct.__tesla_locality*, ...) #2

; Function Attrs: noimplicitfloat noredzone
declare i32 @chgproccnt(%struct.uidinfo*, i32, i64) #2

; Function Attrs: inlinehint noimplicitfloat noredzone nounwind ssp
define internal i32 @atomic_fetchadd_int(i32* %p, i32 %v) #4 {
entry:
  %p.addr = alloca i32*, align 8
  %v.addr = alloca i32, align 4
  store i32* %p, i32** %p.addr, align 8
  call void @llvm.dbg.declare(metadata !{i32** %p.addr}, metadata !3434), !dbg !3435
  store i32 %v, i32* %v.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %v.addr}, metadata !3436), !dbg !3435
  %0 = load i32* %v.addr, align 4, !dbg !3437
  %1 = load i32** %p.addr, align 8, !dbg !3437
  %2 = load i32** %p.addr, align 8, !dbg !3437
  %3 = call i32 asm sideeffect "\09lock ; \09\09\09xaddl\09$0, $1 ;\09# atomic_fetchadd_int", "=r,=*m,*m,0,~{cc},~{dirflag},~{fpsr},~{flags}"(i32* %1, i32* %2, i32 %0) #7, !dbg !3437, !srcloc !3439
  store i32 %3, i32* %v.addr, align 4, !dbg !3437
  %4 = load i32* %v.addr, align 4, !dbg !3440
  ret i32 %4, !dbg !3440
}

; Function Attrs: inlinehint noimplicitfloat noredzone nounwind ssp
define internal void @atomic_add_barr_int(i32* %p, i32 %v) #4 {
entry:
  %p.addr = alloca i32*, align 8
  %v.addr = alloca i32, align 4
  store i32* %p, i32** %p.addr, align 8
  call void @llvm.dbg.declare(metadata !{i32** %p.addr}, metadata !3441), !dbg !3442
  store i32 %v, i32* %v.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %v.addr}, metadata !3443), !dbg !3442
  %0 = load i32** %p.addr, align 8, !dbg !3444
  %1 = load i32* %v.addr, align 4, !dbg !3444
  %2 = load i32** %p.addr, align 8, !dbg !3444
  call void asm sideeffect "lock ; addl $1,$0", "=*m,ir,*m,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32* %0, i32 %1, i32* %2) #7, !dbg !3444, !srcloc !3446
  ret void, !dbg !3444
}

; Function Attrs: noimplicitfloat noredzone
declare i32 @sysctl_handle_int(%struct.sysctl_oid*, i8*, i64, %struct.sysctl_req*) #2

; Function Attrs: noimplicitfloat noredzone
declare void @malloc_uninit(i8*) #2

; Function Attrs: noimplicitfloat noredzone
declare void @malloc_init(i8*) #2

attributes #0 = { noimplicitfloat noredzone nounwind ssp "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf"="true" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { noimplicitfloat noredzone "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf"="true" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { inlinehint noimplicitfloat noredzone nounwind readnone ssp "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf"="true" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { inlinehint noimplicitfloat noredzone nounwind ssp "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf"="true" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nobuiltin noimplicitfloat noredzone }
attributes #6 = { nobuiltin noimplicitfloat noredzone nounwind readnone }
attributes #7 = { nounwind }

!llvm.dbg.cu = !{!0}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"clang version 3.3 (186282)", i1 false, metadata !"", i32 0, metadata !2, metadata !1289, metadata !1290, metadata !1982, metadata !1289, metadata !""} ; [ DW_TAG_compile_unit ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c] [DW_LANG_C99]
!1 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!2 = metadata !{metadata !3, metadata !617, metadata !623, metadata !810, metadata !1197, metadata !1281}
!3 = metadata !{i32 786436, metadata !4, metadata !5, metadata !"", i32 502, i64 32, i64 32, i32 0, i32 0, null, metadata !1193, i32 0, i32 0} ; [ DW_TAG_enumeration_type ] [line 502, size 32, align 32, offset 0] [from ]
!4 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/proc.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!5 = metadata !{i32 786451, metadata !4, null, metadata !"proc", i32 485, i64 9664, i64 64, i32 0, i32 0, null, metadata !6, i32 0, null, null} ; [ DW_TAG_structure_type ] [proc] [line 485, size 9664, align 64, offset 0] [from ]
!6 = metadata !{metadata !7, metadata !14, metadata !905, metadata !906, metadata !907, metadata !910, metadata !913, metadata !934, metadata !949, metadata !950, metadata !978, metadata !979, metadata !980, metadata !981, metadata !986, metadata !991, metadata !992, metadata !997, metadata !1001, metadata !1002, metadata !1003, metadata !1004, metadata !1005, metadata !1008, metadata !1009, metadata !1010, metadata !1011, metadata !1012, metadata !1013, metadata !1014, metadata !1015, metadata !1016, metadata !1017, metadata !1018, metadata !1019, metadata !1020, metadata !1077, metadata !1078, metadata !1079, metadata !1080, metadata !1081, metadata !1082, metadata !1083, metadata !1084, metadata !1087, metadata !1090, metadata !1091, metadata !1092, metadata !1093, metadata !1094, metadata !1095, metadata !1098, metadata !1101, metadata !1102, metadata !1103, metadata !1104, metadata !1105, metadata !1108, metadata !1116, metadata !1117, metadata !1119, metadata !1120, metadata !1121, metadata !1122, metadata !1123, metadata !1148, metadata !1149, metadata !1150, metadata !1151, metadata !1152, metadata !1153, metadata !1154, metadata !1157, metadata !1165, metadata !1171, metadata !1174, metadata !1180, metadata !1181, metadata !1182, metadata !1183, metadata !1184, metadata !1189}
!7 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_list", i32 486, i64 128, i64 64, i64 0, i32 0, metadata !8} ; [ DW_TAG_member ] [p_list] [line 486, size 128, align 64, offset 0] [from ]
!8 = metadata !{i32 786451, metadata !4, metadata !5, metadata !"", i32 486, i64 128, i64 64, i32 0, i32 0, null, metadata !9, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 486, size 128, align 64, offset 0] [from ]
!9 = metadata !{metadata !10, metadata !12}
!10 = metadata !{i32 786445, metadata !4, metadata !8, metadata !"le_next", i32 486, i64 64, i64 64, i64 0, i32 0, metadata !11} ; [ DW_TAG_member ] [le_next] [line 486, size 64, align 64, offset 0] [from ]
!11 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !5} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from proc]
!12 = metadata !{i32 786445, metadata !4, metadata !8, metadata !"le_prev", i32 486, i64 64, i64 64, i64 64, i32 0, metadata !13} ; [ DW_TAG_member ] [le_prev] [line 486, size 64, align 64, offset 64] [from ]
!13 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !11} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!14 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_threads", i32 487, i64 128, i64 64, i64 128, i32 0, metadata !15} ; [ DW_TAG_member ] [p_threads] [line 487, size 128, align 64, offset 128] [from ]
!15 = metadata !{i32 786451, metadata !4, metadata !5, metadata !"", i32 487, i64 128, i64 64, i32 0, i32 0, null, metadata !16, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 487, size 128, align 64, offset 0] [from ]
!16 = metadata !{metadata !17, metadata !904}
!17 = metadata !{i32 786445, metadata !4, metadata !15, metadata !"tqh_first", i32 487, i64 64, i64 64, i64 0, i32 0, metadata !18} ; [ DW_TAG_member ] [tqh_first] [line 487, size 64, align 64, offset 0] [from ]
!18 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !19} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from thread]
!19 = metadata !{i32 786451, metadata !4, null, metadata !"thread", i32 205, i64 9088, i64 64, i32 0, i32 0, null, metadata !20, i32 0, null, null} ; [ DW_TAG_structure_type ] [thread] [line 205, size 9088, align 64, offset 0] [from ]
!20 = metadata !{metadata !21, metadata !48, metadata !49, metadata !55, metadata !60, metadata !65, metadata !70, metadata !75, metadata !113, metadata !116, metadata !119, metadata !122, metadata !125, metadata !128, metadata !133, metadata !220, metadata !223, metadata !224, metadata !225, metadata !226, metadata !227, metadata !228, metadata !229, metadata !230, metadata !231, metadata !232, metadata !234, metadata !235, metadata !237, metadata !238, metadata !239, metadata !240, metadata !241, metadata !242, metadata !246, metadata !250, metadata !251, metadata !252, metadata !511, metadata !512, metadata !513, metadata !514, metadata !515, metadata !516, metadata !545, metadata !556, metadata !557, metadata !558, metadata !559, metadata !560, metadata !561, metadata !562, metadata !563, metadata !564, metadata !565, metadata !575, metadata !576, metadata !578, metadata !579, metadata !583, metadata !787, metadata !788, metadata !789, metadata !790, metadata !791, metadata !794, metadata !795, metadata !796, metadata !797, metadata !798, metadata !799, metadata !800, metadata !801, metadata !802, metadata !803, metadata !804, metadata !805, metadata !809, metadata !817, metadata !821, metadata !854, metadata !858, metadata !861, metadata !864, metadata !865, metadata !866, metadata !873, metadata !876, metadata !879, metadata !887, metadata !890, metadata !891, metadata !892, metadata !893, metadata !894, metadata !895, metadata !900, metadata !901}
!21 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_lock", i32 206, i64 64, i64 64, i64 0, i32 0, metadata !22} ; [ DW_TAG_member ] [td_lock] [line 206, size 64, align 64, offset 0] [from ]
!22 = metadata !{i32 786485, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !23} ; [ DW_TAG_volatile_type ] [line 0, size 0, align 0, offset 0] [from ]
!23 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !24} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from mtx]
!24 = metadata !{i32 786451, metadata !25, null, metadata !"mtx", i32 45, i64 256, i64 64, i32 0, i32 0, null, metadata !26, i32 0, null, null} ; [ DW_TAG_structure_type ] [mtx] [line 45, size 256, align 64, offset 0] [from ]
!25 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/_mutex.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!26 = metadata !{metadata !27, metadata !42}
!27 = metadata !{i32 786445, metadata !25, metadata !24, metadata !"lock_object", i32 46, i64 192, i64 64, i64 0, i32 0, metadata !28} ; [ DW_TAG_member ] [lock_object] [line 46, size 192, align 64, offset 0] [from lock_object]
!28 = metadata !{i32 786451, metadata !29, null, metadata !"lock_object", i32 34, i64 192, i64 64, i32 0, i32 0, null, metadata !30, i32 0, null, null} ; [ DW_TAG_structure_type ] [lock_object] [line 34, size 192, align 64, offset 0] [from ]
!29 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/_lock.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!30 = metadata !{metadata !31, metadata !35, metadata !38, metadata !39}
!31 = metadata !{i32 786445, metadata !29, metadata !28, metadata !"lo_name", i32 35, i64 64, i64 64, i64 0, i32 0, metadata !32} ; [ DW_TAG_member ] [lo_name] [line 35, size 64, align 64, offset 0] [from ]
!32 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !33} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!33 = metadata !{i32 786470, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !34} ; [ DW_TAG_const_type ] [line 0, size 0, align 0, offset 0] [from char]
!34 = metadata !{i32 786468, null, null, metadata !"char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ] [char] [line 0, size 8, align 8, offset 0, enc DW_ATE_signed_char]
!35 = metadata !{i32 786445, metadata !29, metadata !28, metadata !"lo_flags", i32 36, i64 32, i64 32, i64 64, i32 0, metadata !36} ; [ DW_TAG_member ] [lo_flags] [line 36, size 32, align 32, offset 64] [from u_int]
!36 = metadata !{i32 786454, metadata !29, null, metadata !"u_int", i32 52, i64 0, i64 0, i64 0, i32 0, metadata !37} ; [ DW_TAG_typedef ] [u_int] [line 52, size 0, align 0, offset 0] [from unsigned int]
!37 = metadata !{i32 786468, null, null, metadata !"unsigned int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [unsigned int] [line 0, size 32, align 32, offset 0, enc DW_ATE_unsigned]
!38 = metadata !{i32 786445, metadata !29, metadata !28, metadata !"lo_data", i32 37, i64 32, i64 32, i64 96, i32 0, metadata !36} ; [ DW_TAG_member ] [lo_data] [line 37, size 32, align 32, offset 96] [from u_int]
!39 = metadata !{i32 786445, metadata !29, metadata !28, metadata !"lo_witness", i32 38, i64 64, i64 64, i64 128, i32 0, metadata !40} ; [ DW_TAG_member ] [lo_witness] [line 38, size 64, align 64, offset 128] [from ]
!40 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !41} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from witness]
!41 = metadata !{i32 786451, metadata !29, null, metadata !"witness", i32 38, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [witness] [line 38, size 0, align 0, offset 0] [fwd] [from ]
!42 = metadata !{i32 786445, metadata !25, metadata !24, metadata !"mtx_lock", i32 47, i64 64, i64 64, i64 192, i32 0, metadata !43} ; [ DW_TAG_member ] [mtx_lock] [line 47, size 64, align 64, offset 192] [from ]
!43 = metadata !{i32 786485, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !44} ; [ DW_TAG_volatile_type ] [line 0, size 0, align 0, offset 0] [from uintptr_t]
!44 = metadata !{i32 786454, metadata !25, null, metadata !"uintptr_t", i32 78, i64 0, i64 0, i64 0, i32 0, metadata !45} ; [ DW_TAG_typedef ] [uintptr_t] [line 78, size 0, align 0, offset 0] [from __uintptr_t]
!45 = metadata !{i32 786454, metadata !25, null, metadata !"__uintptr_t", i32 108, i64 0, i64 0, i64 0, i32 0, metadata !46} ; [ DW_TAG_typedef ] [__uintptr_t] [line 108, size 0, align 0, offset 0] [from __uint64_t]
!46 = metadata !{i32 786454, metadata !25, null, metadata !"__uint64_t", i32 59, i64 0, i64 0, i64 0, i32 0, metadata !47} ; [ DW_TAG_typedef ] [__uint64_t] [line 59, size 0, align 0, offset 0] [from long unsigned int]
!47 = metadata !{i32 786468, null, null, metadata !"long unsigned int", i32 0, i64 64, i64 64, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [long unsigned int] [line 0, size 64, align 64, offset 0, enc DW_ATE_unsigned]
!48 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_proc", i32 207, i64 64, i64 64, i64 64, i32 0, metadata !11} ; [ DW_TAG_member ] [td_proc] [line 207, size 64, align 64, offset 64] [from ]
!49 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_plist", i32 208, i64 128, i64 64, i64 128, i32 0, metadata !50} ; [ DW_TAG_member ] [td_plist] [line 208, size 128, align 64, offset 128] [from ]
!50 = metadata !{i32 786451, metadata !4, metadata !19, metadata !"", i32 208, i64 128, i64 64, i32 0, i32 0, null, metadata !51, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 208, size 128, align 64, offset 0] [from ]
!51 = metadata !{metadata !52, metadata !53}
!52 = metadata !{i32 786445, metadata !4, metadata !50, metadata !"tqe_next", i32 208, i64 64, i64 64, i64 0, i32 0, metadata !18} ; [ DW_TAG_member ] [tqe_next] [line 208, size 64, align 64, offset 0] [from ]
!53 = metadata !{i32 786445, metadata !4, metadata !50, metadata !"tqe_prev", i32 208, i64 64, i64 64, i64 64, i32 0, metadata !54} ; [ DW_TAG_member ] [tqe_prev] [line 208, size 64, align 64, offset 64] [from ]
!54 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !18} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!55 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_runq", i32 209, i64 128, i64 64, i64 256, i32 0, metadata !56} ; [ DW_TAG_member ] [td_runq] [line 209, size 128, align 64, offset 256] [from ]
!56 = metadata !{i32 786451, metadata !4, metadata !19, metadata !"", i32 209, i64 128, i64 64, i32 0, i32 0, null, metadata !57, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 209, size 128, align 64, offset 0] [from ]
!57 = metadata !{metadata !58, metadata !59}
!58 = metadata !{i32 786445, metadata !4, metadata !56, metadata !"tqe_next", i32 209, i64 64, i64 64, i64 0, i32 0, metadata !18} ; [ DW_TAG_member ] [tqe_next] [line 209, size 64, align 64, offset 0] [from ]
!59 = metadata !{i32 786445, metadata !4, metadata !56, metadata !"tqe_prev", i32 209, i64 64, i64 64, i64 64, i32 0, metadata !54} ; [ DW_TAG_member ] [tqe_prev] [line 209, size 64, align 64, offset 64] [from ]
!60 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_slpq", i32 210, i64 128, i64 64, i64 384, i32 0, metadata !61} ; [ DW_TAG_member ] [td_slpq] [line 210, size 128, align 64, offset 384] [from ]
!61 = metadata !{i32 786451, metadata !4, metadata !19, metadata !"", i32 210, i64 128, i64 64, i32 0, i32 0, null, metadata !62, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 210, size 128, align 64, offset 0] [from ]
!62 = metadata !{metadata !63, metadata !64}
!63 = metadata !{i32 786445, metadata !4, metadata !61, metadata !"tqe_next", i32 210, i64 64, i64 64, i64 0, i32 0, metadata !18} ; [ DW_TAG_member ] [tqe_next] [line 210, size 64, align 64, offset 0] [from ]
!64 = metadata !{i32 786445, metadata !4, metadata !61, metadata !"tqe_prev", i32 210, i64 64, i64 64, i64 64, i32 0, metadata !54} ; [ DW_TAG_member ] [tqe_prev] [line 210, size 64, align 64, offset 64] [from ]
!65 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_lockq", i32 211, i64 128, i64 64, i64 512, i32 0, metadata !66} ; [ DW_TAG_member ] [td_lockq] [line 211, size 128, align 64, offset 512] [from ]
!66 = metadata !{i32 786451, metadata !4, metadata !19, metadata !"", i32 211, i64 128, i64 64, i32 0, i32 0, null, metadata !67, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 211, size 128, align 64, offset 0] [from ]
!67 = metadata !{metadata !68, metadata !69}
!68 = metadata !{i32 786445, metadata !4, metadata !66, metadata !"tqe_next", i32 211, i64 64, i64 64, i64 0, i32 0, metadata !18} ; [ DW_TAG_member ] [tqe_next] [line 211, size 64, align 64, offset 0] [from ]
!69 = metadata !{i32 786445, metadata !4, metadata !66, metadata !"tqe_prev", i32 211, i64 64, i64 64, i64 64, i32 0, metadata !54} ; [ DW_TAG_member ] [tqe_prev] [line 211, size 64, align 64, offset 64] [from ]
!70 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_hash", i32 212, i64 128, i64 64, i64 640, i32 0, metadata !71} ; [ DW_TAG_member ] [td_hash] [line 212, size 128, align 64, offset 640] [from ]
!71 = metadata !{i32 786451, metadata !4, metadata !19, metadata !"", i32 212, i64 128, i64 64, i32 0, i32 0, null, metadata !72, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 212, size 128, align 64, offset 0] [from ]
!72 = metadata !{metadata !73, metadata !74}
!73 = metadata !{i32 786445, metadata !4, metadata !71, metadata !"le_next", i32 212, i64 64, i64 64, i64 0, i32 0, metadata !18} ; [ DW_TAG_member ] [le_next] [line 212, size 64, align 64, offset 0] [from ]
!74 = metadata !{i32 786445, metadata !4, metadata !71, metadata !"le_prev", i32 212, i64 64, i64 64, i64 64, i32 0, metadata !54} ; [ DW_TAG_member ] [le_prev] [line 212, size 64, align 64, offset 64] [from ]
!75 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_cpuset", i32 213, i64 64, i64 64, i64 768, i32 0, metadata !76} ; [ DW_TAG_member ] [td_cpuset] [line 213, size 64, align 64, offset 768] [from ]
!76 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !77} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from cpuset]
!77 = metadata !{i32 786451, metadata !78, null, metadata !"cpuset", i32 97, i64 576, i64 64, i32 0, i32 0, null, metadata !79, i32 0, null, null} ; [ DW_TAG_structure_type ] [cpuset] [line 97, size 576, align 64, offset 0] [from ]
!78 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/cpuset.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!79 = metadata !{metadata !80, metadata !90, metadata !92, metadata !94, metadata !97, metadata !98, metadata !104, metadata !109}
!80 = metadata !{i32 786445, metadata !78, metadata !77, metadata !"cs_mask", i32 98, i64 64, i64 64, i64 0, i32 0, metadata !81} ; [ DW_TAG_member ] [cs_mask] [line 98, size 64, align 64, offset 0] [from cpuset_t]
!81 = metadata !{i32 786454, metadata !78, null, metadata !"cpuset_t", i32 51, i64 0, i64 0, i64 0, i32 0, metadata !82} ; [ DW_TAG_typedef ] [cpuset_t] [line 51, size 0, align 0, offset 0] [from _cpuset]
!82 = metadata !{i32 786451, metadata !83, null, metadata !"_cpuset", i32 50, i64 64, i64 64, i32 0, i32 0, null, metadata !84, i32 0, null, null} ; [ DW_TAG_structure_type ] [_cpuset] [line 50, size 64, align 64, offset 0] [from ]
!83 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/_cpuset.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!84 = metadata !{metadata !85}
!85 = metadata !{i32 786445, metadata !83, metadata !82, metadata !"__bits", i32 50, i64 64, i64 64, i64 0, i32 0, metadata !86} ; [ DW_TAG_member ] [__bits] [line 50, size 64, align 64, offset 0] [from ]
!86 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 64, i64 64, i32 0, i32 0, metadata !87, metadata !88, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 64, align 64, offset 0] [from long int]
!87 = metadata !{i32 786468, null, null, metadata !"long int", i32 0, i64 64, i64 64, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [long int] [line 0, size 64, align 64, offset 0, enc DW_ATE_signed]
!88 = metadata !{metadata !89}
!89 = metadata !{i32 786465, i64 0, i64 1}        ; [ DW_TAG_subrange_type ] [0, 0]
!90 = metadata !{i32 786445, metadata !78, metadata !77, metadata !"cs_ref", i32 99, i64 32, i64 32, i64 64, i32 0, metadata !91} ; [ DW_TAG_member ] [cs_ref] [line 99, size 32, align 32, offset 64] [from ]
!91 = metadata !{i32 786485, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !36} ; [ DW_TAG_volatile_type ] [line 0, size 0, align 0, offset 0] [from u_int]
!92 = metadata !{i32 786445, metadata !78, metadata !77, metadata !"cs_flags", i32 100, i64 32, i64 32, i64 96, i32 0, metadata !93} ; [ DW_TAG_member ] [cs_flags] [line 100, size 32, align 32, offset 96] [from int]
!93 = metadata !{i32 786468, null, null, metadata !"int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [int] [line 0, size 32, align 32, offset 0, enc DW_ATE_signed]
!94 = metadata !{i32 786445, metadata !78, metadata !77, metadata !"cs_id", i32 101, i64 32, i64 32, i64 128, i32 0, metadata !95} ; [ DW_TAG_member ] [cs_id] [line 101, size 32, align 32, offset 128] [from cpusetid_t]
!95 = metadata !{i32 786454, metadata !78, null, metadata !"cpusetid_t", i32 84, i64 0, i64 0, i64 0, i32 0, metadata !96} ; [ DW_TAG_typedef ] [cpusetid_t] [line 84, size 0, align 0, offset 0] [from __cpusetid_t]
!96 = metadata !{i32 786454, metadata !78, null, metadata !"__cpusetid_t", i32 68, i64 0, i64 0, i64 0, i32 0, metadata !93} ; [ DW_TAG_typedef ] [__cpusetid_t] [line 68, size 0, align 0, offset 0] [from int]
!97 = metadata !{i32 786445, metadata !78, metadata !77, metadata !"cs_parent", i32 102, i64 64, i64 64, i64 192, i32 0, metadata !76} ; [ DW_TAG_member ] [cs_parent] [line 102, size 64, align 64, offset 192] [from ]
!98 = metadata !{i32 786445, metadata !78, metadata !77, metadata !"cs_link", i32 103, i64 128, i64 64, i64 256, i32 0, metadata !99} ; [ DW_TAG_member ] [cs_link] [line 103, size 128, align 64, offset 256] [from ]
!99 = metadata !{i32 786451, metadata !78, metadata !77, metadata !"", i32 103, i64 128, i64 64, i32 0, i32 0, null, metadata !100, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 103, size 128, align 64, offset 0] [from ]
!100 = metadata !{metadata !101, metadata !102}
!101 = metadata !{i32 786445, metadata !78, metadata !99, metadata !"le_next", i32 103, i64 64, i64 64, i64 0, i32 0, metadata !76} ; [ DW_TAG_member ] [le_next] [line 103, size 64, align 64, offset 0] [from ]
!102 = metadata !{i32 786445, metadata !78, metadata !99, metadata !"le_prev", i32 103, i64 64, i64 64, i64 64, i32 0, metadata !103} ; [ DW_TAG_member ] [le_prev] [line 103, size 64, align 64, offset 64] [from ]
!103 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !76} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!104 = metadata !{i32 786445, metadata !78, metadata !77, metadata !"cs_siblings", i32 104, i64 128, i64 64, i64 384, i32 0, metadata !105} ; [ DW_TAG_member ] [cs_siblings] [line 104, size 128, align 64, offset 384] [from ]
!105 = metadata !{i32 786451, metadata !78, metadata !77, metadata !"", i32 104, i64 128, i64 64, i32 0, i32 0, null, metadata !106, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 104, size 128, align 64, offset 0] [from ]
!106 = metadata !{metadata !107, metadata !108}
!107 = metadata !{i32 786445, metadata !78, metadata !105, metadata !"le_next", i32 104, i64 64, i64 64, i64 0, i32 0, metadata !76} ; [ DW_TAG_member ] [le_next] [line 104, size 64, align 64, offset 0] [from ]
!108 = metadata !{i32 786445, metadata !78, metadata !105, metadata !"le_prev", i32 104, i64 64, i64 64, i64 64, i32 0, metadata !103} ; [ DW_TAG_member ] [le_prev] [line 104, size 64, align 64, offset 64] [from ]
!109 = metadata !{i32 786445, metadata !78, metadata !77, metadata !"cs_children", i32 105, i64 64, i64 64, i64 512, i32 0, metadata !110} ; [ DW_TAG_member ] [cs_children] [line 105, size 64, align 64, offset 512] [from setlist]
!110 = metadata !{i32 786451, metadata !78, null, metadata !"setlist", i32 84, i64 64, i64 64, i32 0, i32 0, null, metadata !111, i32 0, null, null} ; [ DW_TAG_structure_type ] [setlist] [line 84, size 64, align 64, offset 0] [from ]
!111 = metadata !{metadata !112}
!112 = metadata !{i32 786445, metadata !78, metadata !110, metadata !"lh_first", i32 84, i64 64, i64 64, i64 0, i32 0, metadata !76} ; [ DW_TAG_member ] [lh_first] [line 84, size 64, align 64, offset 0] [from ]
!113 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_sel", i32 214, i64 64, i64 64, i64 832, i32 0, metadata !114} ; [ DW_TAG_member ] [td_sel] [line 214, size 64, align 64, offset 832] [from ]
!114 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !115} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from seltd]
!115 = metadata !{i32 786451, metadata !4, null, metadata !"seltd", i32 214, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [seltd] [line 214, size 0, align 0, offset 0] [fwd] [from ]
!116 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_sleepqueue", i32 215, i64 64, i64 64, i64 896, i32 0, metadata !117} ; [ DW_TAG_member ] [td_sleepqueue] [line 215, size 64, align 64, offset 896] [from ]
!117 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !118} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from sleepqueue]
!118 = metadata !{i32 786451, metadata !4, null, metadata !"sleepqueue", i32 172, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [sleepqueue] [line 172, size 0, align 0, offset 0] [fwd] [from ]
!119 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_turnstile", i32 216, i64 64, i64 64, i64 960, i32 0, metadata !120} ; [ DW_TAG_member ] [td_turnstile] [line 216, size 64, align 64, offset 960] [from ]
!120 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !121} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from turnstile]
!121 = metadata !{i32 786451, metadata !4, null, metadata !"turnstile", i32 177, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [turnstile] [line 177, size 0, align 0, offset 0] [fwd] [from ]
!122 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_rlqe", i32 217, i64 64, i64 64, i64 1024, i32 0, metadata !123} ; [ DW_TAG_member ] [td_rlqe] [line 217, size 64, align 64, offset 1024] [from ]
!123 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !124} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from rl_q_entry]
!124 = metadata !{i32 786451, metadata !4, null, metadata !"rl_q_entry", i32 217, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [rl_q_entry] [line 217, size 0, align 0, offset 0] [fwd] [from ]
!125 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_umtxq", i32 218, i64 64, i64 64, i64 1088, i32 0, metadata !126} ; [ DW_TAG_member ] [td_umtxq] [line 218, size 64, align 64, offset 1088] [from ]
!126 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !127} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from umtx_q]
!127 = metadata !{i32 786451, metadata !4, null, metadata !"umtx_q", i32 218, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [umtx_q] [line 218, size 0, align 0, offset 0] [fwd] [from ]
!128 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_tid", i32 219, i64 32, i64 32, i64 1152, i32 0, metadata !129} ; [ DW_TAG_member ] [td_tid] [line 219, size 32, align 32, offset 1152] [from lwpid_t]
!129 = metadata !{i32 786454, metadata !4, null, metadata !"lwpid_t", i32 155, i64 0, i64 0, i64 0, i32 0, metadata !130} ; [ DW_TAG_typedef ] [lwpid_t] [line 155, size 0, align 0, offset 0] [from __lwpid_t]
!130 = metadata !{i32 786454, metadata !4, null, metadata !"__lwpid_t", i32 49, i64 0, i64 0, i64 0, i32 0, metadata !131} ; [ DW_TAG_typedef ] [__lwpid_t] [line 49, size 0, align 0, offset 0] [from __int32_t]
!131 = metadata !{i32 786454, metadata !132, null, metadata !"__int32_t", i32 55, i64 0, i64 0, i64 0, i32 0, metadata !93} ; [ DW_TAG_typedef ] [__int32_t] [line 55, size 0, align 0, offset 0] [from int]
!132 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/bsm/audit.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!133 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_sigqueue", i32 220, i64 512, i64 64, i64 1216, i32 0, metadata !134} ; [ DW_TAG_member ] [td_sigqueue] [line 220, size 512, align 64, offset 1216] [from sigqueue_t]
!134 = metadata !{i32 786454, metadata !4, null, metadata !"sigqueue_t", i32 248, i64 0, i64 0, i64 0, i32 0, metadata !135} ; [ DW_TAG_typedef ] [sigqueue_t] [line 248, size 0, align 0, offset 0] [from sigqueue]
!135 = metadata !{i32 786451, metadata !136, null, metadata !"sigqueue", i32 242, i64 512, i64 64, i32 0, i32 0, null, metadata !137, i32 0, null, null} ; [ DW_TAG_structure_type ] [sigqueue] [line 242, size 512, align 64, offset 0] [from ]
!136 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/signalvar.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!137 = metadata !{metadata !138, metadata !150, metadata !151, metadata !218, metadata !219}
!138 = metadata !{i32 786445, metadata !136, metadata !135, metadata !"sq_signals", i32 243, i64 128, i64 32, i64 0, i32 0, metadata !139} ; [ DW_TAG_member ] [sq_signals] [line 243, size 128, align 32, offset 0] [from sigset_t]
!139 = metadata !{i32 786454, metadata !136, null, metadata !"sigset_t", i32 49, i64 0, i64 0, i64 0, i32 0, metadata !140} ; [ DW_TAG_typedef ] [sigset_t] [line 49, size 0, align 0, offset 0] [from __sigset_t]
!140 = metadata !{i32 786454, metadata !136, null, metadata !"__sigset_t", i32 53, i64 0, i64 0, i64 0, i32 0, metadata !141} ; [ DW_TAG_typedef ] [__sigset_t] [line 53, size 0, align 0, offset 0] [from __sigset]
!141 = metadata !{i32 786451, metadata !142, null, metadata !"__sigset", i32 51, i64 128, i64 32, i32 0, i32 0, null, metadata !143, i32 0, null, null} ; [ DW_TAG_structure_type ] [__sigset] [line 51, size 128, align 32, offset 0] [from ]
!142 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/_sigset.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!143 = metadata !{metadata !144}
!144 = metadata !{i32 786445, metadata !142, metadata !141, metadata !"__bits", i32 52, i64 128, i64 32, i64 0, i32 0, metadata !145} ; [ DW_TAG_member ] [__bits] [line 52, size 128, align 32, offset 0] [from ]
!145 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 128, i64 32, i32 0, i32 0, metadata !146, metadata !148, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 128, align 32, offset 0] [from __uint32_t]
!146 = metadata !{i32 786454, metadata !147, null, metadata !"__uint32_t", i32 56, i64 0, i64 0, i64 0, i32 0, metadata !37} ; [ DW_TAG_typedef ] [__uint32_t] [line 56, size 0, align 0, offset 0] [from unsigned int]
!147 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/ucred.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!148 = metadata !{metadata !149}
!149 = metadata !{i32 786465, i64 0, i64 4}       ; [ DW_TAG_subrange_type ] [0, 3]
!150 = metadata !{i32 786445, metadata !136, metadata !135, metadata !"sq_kill", i32 244, i64 128, i64 32, i64 128, i32 0, metadata !139} ; [ DW_TAG_member ] [sq_kill] [line 244, size 128, align 32, offset 128] [from sigset_t]
!151 = metadata !{i32 786445, metadata !136, metadata !135, metadata !"sq_list", i32 245, i64 128, i64 64, i64 256, i32 0, metadata !152} ; [ DW_TAG_member ] [sq_list] [line 245, size 128, align 64, offset 256] [from ]
!152 = metadata !{i32 786451, metadata !136, metadata !135, metadata !"", i32 245, i64 128, i64 64, i32 0, i32 0, null, metadata !153, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 245, size 128, align 64, offset 0] [from ]
!153 = metadata !{metadata !154, metadata !217}
!154 = metadata !{i32 786445, metadata !136, metadata !152, metadata !"tqh_first", i32 245, i64 64, i64 64, i64 0, i32 0, metadata !155} ; [ DW_TAG_member ] [tqh_first] [line 245, size 64, align 64, offset 0] [from ]
!155 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !156} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ksiginfo]
!156 = metadata !{i32 786451, metadata !136, null, metadata !"ksiginfo", i32 211, i64 896, i64 64, i32 0, i32 0, null, metadata !157, i32 0, null, null} ; [ DW_TAG_structure_type ] [ksiginfo] [line 211, size 896, align 64, offset 0] [from ]
!157 = metadata !{metadata !158, metadata !164, metadata !214, metadata !215}
!158 = metadata !{i32 786445, metadata !136, metadata !156, metadata !"ksi_link", i32 212, i64 128, i64 64, i64 0, i32 0, metadata !159} ; [ DW_TAG_member ] [ksi_link] [line 212, size 128, align 64, offset 0] [from ]
!159 = metadata !{i32 786451, metadata !136, metadata !156, metadata !"", i32 212, i64 128, i64 64, i32 0, i32 0, null, metadata !160, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 212, size 128, align 64, offset 0] [from ]
!160 = metadata !{metadata !161, metadata !162}
!161 = metadata !{i32 786445, metadata !136, metadata !159, metadata !"tqe_next", i32 212, i64 64, i64 64, i64 0, i32 0, metadata !155} ; [ DW_TAG_member ] [tqe_next] [line 212, size 64, align 64, offset 0] [from ]
!162 = metadata !{i32 786445, metadata !136, metadata !159, metadata !"tqe_prev", i32 212, i64 64, i64 64, i64 64, i32 0, metadata !163} ; [ DW_TAG_member ] [tqe_prev] [line 212, size 64, align 64, offset 64] [from ]
!163 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !155} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!164 = metadata !{i32 786445, metadata !136, metadata !156, metadata !"ksi_info", i32 213, i64 640, i64 64, i64 128, i32 0, metadata !165} ; [ DW_TAG_member ] [ksi_info] [line 213, size 640, align 64, offset 128] [from siginfo_t]
!165 = metadata !{i32 786454, metadata !136, null, metadata !"siginfo_t", i32 230, i64 0, i64 0, i64 0, i32 0, metadata !166} ; [ DW_TAG_typedef ] [siginfo_t] [line 230, size 0, align 0, offset 0] [from __siginfo]
!166 = metadata !{i32 786451, metadata !167, null, metadata !"__siginfo", i32 196, i64 640, i64 64, i32 0, i32 0, null, metadata !168, i32 0, null, null} ; [ DW_TAG_structure_type ] [__siginfo] [line 196, size 640, align 64, offset 0] [from ]
!167 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/signal.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!168 = metadata !{metadata !169, metadata !170, metadata !171, metadata !172, metadata !174, metadata !176, metadata !177, metadata !179, metadata !186}
!169 = metadata !{i32 786445, metadata !167, metadata !166, metadata !"si_signo", i32 197, i64 32, i64 32, i64 0, i32 0, metadata !93} ; [ DW_TAG_member ] [si_signo] [line 197, size 32, align 32, offset 0] [from int]
!170 = metadata !{i32 786445, metadata !167, metadata !166, metadata !"si_errno", i32 198, i64 32, i64 32, i64 32, i32 0, metadata !93} ; [ DW_TAG_member ] [si_errno] [line 198, size 32, align 32, offset 32] [from int]
!171 = metadata !{i32 786445, metadata !167, metadata !166, metadata !"si_code", i32 205, i64 32, i64 32, i64 64, i32 0, metadata !93} ; [ DW_TAG_member ] [si_code] [line 205, size 32, align 32, offset 64] [from int]
!172 = metadata !{i32 786445, metadata !167, metadata !166, metadata !"si_pid", i32 206, i64 32, i64 32, i64 96, i32 0, metadata !173} ; [ DW_TAG_member ] [si_pid] [line 206, size 32, align 32, offset 96] [from __pid_t]
!173 = metadata !{i32 786454, metadata !132, null, metadata !"__pid_t", i32 55, i64 0, i64 0, i64 0, i32 0, metadata !131} ; [ DW_TAG_typedef ] [__pid_t] [line 55, size 0, align 0, offset 0] [from __int32_t]
!174 = metadata !{i32 786445, metadata !167, metadata !166, metadata !"si_uid", i32 207, i64 32, i64 32, i64 128, i32 0, metadata !175} ; [ DW_TAG_member ] [si_uid] [line 207, size 32, align 32, offset 128] [from __uid_t]
!175 = metadata !{i32 786454, metadata !147, null, metadata !"__uid_t", i32 64, i64 0, i64 0, i64 0, i32 0, metadata !146} ; [ DW_TAG_typedef ] [__uid_t] [line 64, size 0, align 0, offset 0] [from __uint32_t]
!176 = metadata !{i32 786445, metadata !167, metadata !166, metadata !"si_status", i32 208, i64 32, i64 32, i64 160, i32 0, metadata !93} ; [ DW_TAG_member ] [si_status] [line 208, size 32, align 32, offset 160] [from int]
!177 = metadata !{i32 786445, metadata !167, metadata !166, metadata !"si_addr", i32 209, i64 64, i64 64, i64 192, i32 0, metadata !178} ; [ DW_TAG_member ] [si_addr] [line 209, size 64, align 64, offset 192] [from ]
!178 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!179 = metadata !{i32 786445, metadata !167, metadata !166, metadata !"si_value", i32 210, i64 64, i64 64, i64 256, i32 0, metadata !180} ; [ DW_TAG_member ] [si_value] [line 210, size 64, align 64, offset 256] [from sigval]
!180 = metadata !{i32 786455, metadata !167, null, metadata !"sigval", i32 152, i64 64, i64 64, i64 0, i32 0, null, metadata !181, i32 0, i32 0, null} ; [ DW_TAG_union_type ] [sigval] [line 152, size 64, align 64, offset 0] [from ]
!181 = metadata !{metadata !182, metadata !183, metadata !184, metadata !185}
!182 = metadata !{i32 786445, metadata !167, metadata !180, metadata !"sival_int", i32 154, i64 32, i64 32, i64 0, i32 0, metadata !93} ; [ DW_TAG_member ] [sival_int] [line 154, size 32, align 32, offset 0] [from int]
!183 = metadata !{i32 786445, metadata !167, metadata !180, metadata !"sival_ptr", i32 155, i64 64, i64 64, i64 0, i32 0, metadata !178} ; [ DW_TAG_member ] [sival_ptr] [line 155, size 64, align 64, offset 0] [from ]
!184 = metadata !{i32 786445, metadata !167, metadata !180, metadata !"sigval_int", i32 157, i64 32, i64 32, i64 0, i32 0, metadata !93} ; [ DW_TAG_member ] [sigval_int] [line 157, size 32, align 32, offset 0] [from int]
!185 = metadata !{i32 786445, metadata !167, metadata !180, metadata !"sigval_ptr", i32 158, i64 64, i64 64, i64 0, i32 0, metadata !178} ; [ DW_TAG_member ] [sigval_ptr] [line 158, size 64, align 64, offset 0] [from ]
!186 = metadata !{i32 786445, metadata !167, metadata !166, metadata !"_reason", i32 229, i64 320, i64 64, i64 320, i32 0, metadata !187} ; [ DW_TAG_member ] [_reason] [line 229, size 320, align 64, offset 320] [from ]
!187 = metadata !{i32 786455, metadata !167, metadata !166, metadata !"", i32 211, i64 320, i64 64, i64 0, i32 0, null, metadata !188, i32 0, i32 0, null} ; [ DW_TAG_union_type ] [line 211, size 320, align 64, offset 0] [from ]
!188 = metadata !{metadata !189, metadata !193, metadata !198, metadata !202, metadata !206}
!189 = metadata !{i32 786445, metadata !167, metadata !187, metadata !"_fault", i32 214, i64 32, i64 32, i64 0, i32 0, metadata !190} ; [ DW_TAG_member ] [_fault] [line 214, size 32, align 32, offset 0] [from ]
!190 = metadata !{i32 786451, metadata !167, metadata !187, metadata !"", i32 212, i64 32, i64 32, i32 0, i32 0, null, metadata !191, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 212, size 32, align 32, offset 0] [from ]
!191 = metadata !{metadata !192}
!192 = metadata !{i32 786445, metadata !167, metadata !190, metadata !"_trapno", i32 213, i64 32, i64 32, i64 0, i32 0, metadata !93} ; [ DW_TAG_member ] [_trapno] [line 213, size 32, align 32, offset 0] [from int]
!193 = metadata !{i32 786445, metadata !167, metadata !187, metadata !"_timer", i32 218, i64 64, i64 32, i64 0, i32 0, metadata !194} ; [ DW_TAG_member ] [_timer] [line 218, size 64, align 32, offset 0] [from ]
!194 = metadata !{i32 786451, metadata !167, metadata !187, metadata !"", i32 215, i64 64, i64 32, i32 0, i32 0, null, metadata !195, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 215, size 64, align 32, offset 0] [from ]
!195 = metadata !{metadata !196, metadata !197}
!196 = metadata !{i32 786445, metadata !167, metadata !194, metadata !"_timerid", i32 216, i64 32, i64 32, i64 0, i32 0, metadata !93} ; [ DW_TAG_member ] [_timerid] [line 216, size 32, align 32, offset 0] [from int]
!197 = metadata !{i32 786445, metadata !167, metadata !194, metadata !"_overrun", i32 217, i64 32, i64 32, i64 32, i32 0, metadata !93} ; [ DW_TAG_member ] [_overrun] [line 217, size 32, align 32, offset 32] [from int]
!198 = metadata !{i32 786445, metadata !167, metadata !187, metadata !"_mesgq", i32 221, i64 32, i64 32, i64 0, i32 0, metadata !199} ; [ DW_TAG_member ] [_mesgq] [line 221, size 32, align 32, offset 0] [from ]
!199 = metadata !{i32 786451, metadata !167, metadata !187, metadata !"", i32 219, i64 32, i64 32, i32 0, i32 0, null, metadata !200, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 219, size 32, align 32, offset 0] [from ]
!200 = metadata !{metadata !201}
!201 = metadata !{i32 786445, metadata !167, metadata !199, metadata !"_mqd", i32 220, i64 32, i64 32, i64 0, i32 0, metadata !93} ; [ DW_TAG_member ] [_mqd] [line 220, size 32, align 32, offset 0] [from int]
!202 = metadata !{i32 786445, metadata !167, metadata !187, metadata !"_poll", i32 224, i64 64, i64 64, i64 0, i32 0, metadata !203} ; [ DW_TAG_member ] [_poll] [line 224, size 64, align 64, offset 0] [from ]
!203 = metadata !{i32 786451, metadata !167, metadata !187, metadata !"", i32 222, i64 64, i64 64, i32 0, i32 0, null, metadata !204, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 222, size 64, align 64, offset 0] [from ]
!204 = metadata !{metadata !205}
!205 = metadata !{i32 786445, metadata !167, metadata !203, metadata !"_band", i32 223, i64 64, i64 64, i64 0, i32 0, metadata !87} ; [ DW_TAG_member ] [_band] [line 223, size 64, align 64, offset 0] [from long int]
!206 = metadata !{i32 786445, metadata !167, metadata !187, metadata !"__spare__", i32 228, i64 320, i64 64, i64 0, i32 0, metadata !207} ; [ DW_TAG_member ] [__spare__] [line 228, size 320, align 64, offset 0] [from ]
!207 = metadata !{i32 786451, metadata !167, metadata !187, metadata !"", i32 225, i64 320, i64 64, i32 0, i32 0, null, metadata !208, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 225, size 320, align 64, offset 0] [from ]
!208 = metadata !{metadata !209, metadata !210}
!209 = metadata !{i32 786445, metadata !167, metadata !207, metadata !"__spare1__", i32 226, i64 64, i64 64, i64 0, i32 0, metadata !87} ; [ DW_TAG_member ] [__spare1__] [line 226, size 64, align 64, offset 0] [from long int]
!210 = metadata !{i32 786445, metadata !167, metadata !207, metadata !"__spare2__", i32 227, i64 224, i64 32, i64 64, i32 0, metadata !211} ; [ DW_TAG_member ] [__spare2__] [line 227, size 224, align 32, offset 64] [from ]
!211 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 224, i64 32, i32 0, i32 0, metadata !93, metadata !212, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 224, align 32, offset 0] [from int]
!212 = metadata !{metadata !213}
!213 = metadata !{i32 786465, i64 0, i64 7}       ; [ DW_TAG_subrange_type ] [0, 6]
!214 = metadata !{i32 786445, metadata !136, metadata !156, metadata !"ksi_flags", i32 214, i64 32, i64 32, i64 768, i32 0, metadata !93} ; [ DW_TAG_member ] [ksi_flags] [line 214, size 32, align 32, offset 768] [from int]
!215 = metadata !{i32 786445, metadata !136, metadata !156, metadata !"ksi_sigq", i32 215, i64 64, i64 64, i64 832, i32 0, metadata !216} ; [ DW_TAG_member ] [ksi_sigq] [line 215, size 64, align 64, offset 832] [from ]
!216 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !135} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from sigqueue]
!217 = metadata !{i32 786445, metadata !136, metadata !152, metadata !"tqh_last", i32 245, i64 64, i64 64, i64 64, i32 0, metadata !163} ; [ DW_TAG_member ] [tqh_last] [line 245, size 64, align 64, offset 64] [from ]
!218 = metadata !{i32 786445, metadata !136, metadata !135, metadata !"sq_proc", i32 246, i64 64, i64 64, i64 384, i32 0, metadata !11} ; [ DW_TAG_member ] [sq_proc] [line 246, size 64, align 64, offset 384] [from ]
!219 = metadata !{i32 786445, metadata !136, metadata !135, metadata !"sq_flags", i32 247, i64 32, i64 32, i64 448, i32 0, metadata !93} ; [ DW_TAG_member ] [sq_flags] [line 247, size 32, align 32, offset 448] [from int]
!220 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_lend_user_pri", i32 222, i64 8, i64 8, i64 1728, i32 0, metadata !221} ; [ DW_TAG_member ] [td_lend_user_pri] [line 222, size 8, align 8, offset 1728] [from u_char]
!221 = metadata !{i32 786454, metadata !4, null, metadata !"u_char", i32 50, i64 0, i64 0, i64 0, i32 0, metadata !222} ; [ DW_TAG_typedef ] [u_char] [line 50, size 0, align 0, offset 0] [from unsigned char]
!222 = metadata !{i32 786468, null, null, metadata !"unsigned char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 8} ; [ DW_TAG_base_type ] [unsigned char] [line 0, size 8, align 8, offset 0, enc DW_ATE_unsigned_char]
!223 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_flags", i32 226, i64 32, i64 32, i64 1760, i32 0, metadata !93} ; [ DW_TAG_member ] [td_flags] [line 226, size 32, align 32, offset 1760] [from int]
!224 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_inhibitors", i32 227, i64 32, i64 32, i64 1792, i32 0, metadata !93} ; [ DW_TAG_member ] [td_inhibitors] [line 227, size 32, align 32, offset 1792] [from int]
!225 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_pflags", i32 228, i64 32, i64 32, i64 1824, i32 0, metadata !93} ; [ DW_TAG_member ] [td_pflags] [line 228, size 32, align 32, offset 1824] [from int]
!226 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_dupfd", i32 229, i64 32, i64 32, i64 1856, i32 0, metadata !93} ; [ DW_TAG_member ] [td_dupfd] [line 229, size 32, align 32, offset 1856] [from int]
!227 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_sqqueue", i32 230, i64 32, i64 32, i64 1888, i32 0, metadata !93} ; [ DW_TAG_member ] [td_sqqueue] [line 230, size 32, align 32, offset 1888] [from int]
!228 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_wchan", i32 231, i64 64, i64 64, i64 1920, i32 0, metadata !178} ; [ DW_TAG_member ] [td_wchan] [line 231, size 64, align 64, offset 1920] [from ]
!229 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_wmesg", i32 232, i64 64, i64 64, i64 1984, i32 0, metadata !32} ; [ DW_TAG_member ] [td_wmesg] [line 232, size 64, align 64, offset 1984] [from ]
!230 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_lastcpu", i32 233, i64 8, i64 8, i64 2048, i32 0, metadata !221} ; [ DW_TAG_member ] [td_lastcpu] [line 233, size 8, align 8, offset 2048] [from u_char]
!231 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_oncpu", i32 234, i64 8, i64 8, i64 2056, i32 0, metadata !221} ; [ DW_TAG_member ] [td_oncpu] [line 234, size 8, align 8, offset 2056] [from u_char]
!232 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_owepreempt", i32 235, i64 8, i64 8, i64 2064, i32 0, metadata !233} ; [ DW_TAG_member ] [td_owepreempt] [line 235, size 8, align 8, offset 2064] [from ]
!233 = metadata !{i32 786485, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !221} ; [ DW_TAG_volatile_type ] [line 0, size 0, align 0, offset 0] [from u_char]
!234 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_tsqueue", i32 236, i64 8, i64 8, i64 2072, i32 0, metadata !221} ; [ DW_TAG_member ] [td_tsqueue] [line 236, size 8, align 8, offset 2072] [from u_char]
!235 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_locks", i32 237, i64 16, i64 16, i64 2080, i32 0, metadata !236} ; [ DW_TAG_member ] [td_locks] [line 237, size 16, align 16, offset 2080] [from short]
!236 = metadata !{i32 786468, null, null, metadata !"short", i32 0, i64 16, i64 16, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [short] [line 0, size 16, align 16, offset 0, enc DW_ATE_signed]
!237 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_rw_rlocks", i32 238, i64 16, i64 16, i64 2096, i32 0, metadata !236} ; [ DW_TAG_member ] [td_rw_rlocks] [line 238, size 16, align 16, offset 2096] [from short]
!238 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_lk_slocks", i32 239, i64 16, i64 16, i64 2112, i32 0, metadata !236} ; [ DW_TAG_member ] [td_lk_slocks] [line 239, size 16, align 16, offset 2112] [from short]
!239 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_stopsched", i32 240, i64 16, i64 16, i64 2128, i32 0, metadata !236} ; [ DW_TAG_member ] [td_stopsched] [line 240, size 16, align 16, offset 2128] [from short]
!240 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_blocked", i32 241, i64 64, i64 64, i64 2176, i32 0, metadata !120} ; [ DW_TAG_member ] [td_blocked] [line 241, size 64, align 64, offset 2176] [from ]
!241 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_lockname", i32 242, i64 64, i64 64, i64 2240, i32 0, metadata !32} ; [ DW_TAG_member ] [td_lockname] [line 242, size 64, align 64, offset 2240] [from ]
!242 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_contested", i32 243, i64 64, i64 64, i64 2304, i32 0, metadata !243} ; [ DW_TAG_member ] [td_contested] [line 243, size 64, align 64, offset 2304] [from ]
!243 = metadata !{i32 786451, metadata !4, metadata !19, metadata !"", i32 243, i64 64, i64 64, i32 0, i32 0, null, metadata !244, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 243, size 64, align 64, offset 0] [from ]
!244 = metadata !{metadata !245}
!245 = metadata !{i32 786445, metadata !4, metadata !243, metadata !"lh_first", i32 243, i64 64, i64 64, i64 0, i32 0, metadata !120} ; [ DW_TAG_member ] [lh_first] [line 243, size 64, align 64, offset 0] [from ]
!246 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_sleeplocks", i32 244, i64 64, i64 64, i64 2368, i32 0, metadata !247} ; [ DW_TAG_member ] [td_sleeplocks] [line 244, size 64, align 64, offset 2368] [from ]
!247 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !248} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from lock_list_entry]
!248 = metadata !{i32 786451, metadata !249, null, metadata !"lock_list_entry", i32 38, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [lock_list_entry] [line 38, size 0, align 0, offset 0] [fwd] [from ]
!249 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/lock.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!250 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_intr_nesting_level", i32 245, i64 32, i64 32, i64 2432, i32 0, metadata !93} ; [ DW_TAG_member ] [td_intr_nesting_level] [line 245, size 32, align 32, offset 2432] [from int]
!251 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_pinned", i32 246, i64 32, i64 32, i64 2464, i32 0, metadata !93} ; [ DW_TAG_member ] [td_pinned] [line 246, size 32, align 32, offset 2464] [from int]
!252 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_ucred", i32 247, i64 64, i64 64, i64 2496, i32 0, metadata !253} ; [ DW_TAG_member ] [td_ucred] [line 247, size 64, align 64, offset 2496] [from ]
!253 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !254} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ucred]
!254 = metadata !{i32 786451, metadata !147, null, metadata !"ucred", i32 47, i64 1280, i64 64, i32 0, i32 0, null, metadata !255, i32 0, null, null} ; [ DW_TAG_structure_type ] [ucred] [line 47, size 1280, align 64, offset 0] [from ]
!255 = metadata !{metadata !256, metadata !257, metadata !259, metadata !260, metadata !261, metadata !262, metadata !265, metadata !266, metadata !303, metadata !304, metadata !455, metadata !472, metadata !473, metadata !477, metadata !480, metadata !508, metadata !510}
!256 = metadata !{i32 786445, metadata !147, metadata !254, metadata !"cr_ref", i32 48, i64 32, i64 32, i64 0, i32 0, metadata !36} ; [ DW_TAG_member ] [cr_ref] [line 48, size 32, align 32, offset 0] [from u_int]
!257 = metadata !{i32 786445, metadata !147, metadata !254, metadata !"cr_uid", i32 50, i64 32, i64 32, i64 32, i32 0, metadata !258} ; [ DW_TAG_member ] [cr_uid] [line 50, size 32, align 32, offset 32] [from uid_t]
!258 = metadata !{i32 786454, metadata !147, null, metadata !"uid_t", i32 228, i64 0, i64 0, i64 0, i32 0, metadata !175} ; [ DW_TAG_typedef ] [uid_t] [line 228, size 0, align 0, offset 0] [from __uid_t]
!259 = metadata !{i32 786445, metadata !147, metadata !254, metadata !"cr_ruid", i32 51, i64 32, i64 32, i64 64, i32 0, metadata !258} ; [ DW_TAG_member ] [cr_ruid] [line 51, size 32, align 32, offset 64] [from uid_t]
!260 = metadata !{i32 786445, metadata !147, metadata !254, metadata !"cr_svuid", i32 52, i64 32, i64 32, i64 96, i32 0, metadata !258} ; [ DW_TAG_member ] [cr_svuid] [line 52, size 32, align 32, offset 96] [from uid_t]
!261 = metadata !{i32 786445, metadata !147, metadata !254, metadata !"cr_ngroups", i32 53, i64 32, i64 32, i64 128, i32 0, metadata !93} ; [ DW_TAG_member ] [cr_ngroups] [line 53, size 32, align 32, offset 128] [from int]
!262 = metadata !{i32 786445, metadata !147, metadata !254, metadata !"cr_rgid", i32 54, i64 32, i64 32, i64 160, i32 0, metadata !263} ; [ DW_TAG_member ] [cr_rgid] [line 54, size 32, align 32, offset 160] [from gid_t]
!263 = metadata !{i32 786454, metadata !147, null, metadata !"gid_t", i32 125, i64 0, i64 0, i64 0, i32 0, metadata !264} ; [ DW_TAG_typedef ] [gid_t] [line 125, size 0, align 0, offset 0] [from __gid_t]
!264 = metadata !{i32 786454, metadata !147, null, metadata !"__gid_t", i32 45, i64 0, i64 0, i64 0, i32 0, metadata !146} ; [ DW_TAG_typedef ] [__gid_t] [line 45, size 0, align 0, offset 0] [from __uint32_t]
!265 = metadata !{i32 786445, metadata !147, metadata !254, metadata !"cr_svgid", i32 55, i64 32, i64 32, i64 192, i32 0, metadata !263} ; [ DW_TAG_member ] [cr_svgid] [line 55, size 32, align 32, offset 192] [from gid_t]
!266 = metadata !{i32 786445, metadata !147, metadata !254, metadata !"cr_uidinfo", i32 56, i64 64, i64 64, i64 256, i32 0, metadata !267} ; [ DW_TAG_member ] [cr_uidinfo] [line 56, size 64, align 64, offset 256] [from ]
!267 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !268} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from uidinfo]
!268 = metadata !{i32 786451, metadata !269, null, metadata !"uidinfo", i32 95, i64 768, i64 64, i32 0, i32 0, null, metadata !270, i32 0, null, null} ; [ DW_TAG_structure_type ] [uidinfo] [line 95, size 768, align 64, offset 0] [from ]
!269 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/resourcevar.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!270 = metadata !{metadata !271, metadata !277, metadata !278, metadata !282, metadata !283, metadata !284, metadata !285, metadata !286, metadata !287}
!271 = metadata !{i32 786445, metadata !269, metadata !268, metadata !"ui_hash", i32 96, i64 128, i64 64, i64 0, i32 0, metadata !272} ; [ DW_TAG_member ] [ui_hash] [line 96, size 128, align 64, offset 0] [from ]
!272 = metadata !{i32 786451, metadata !269, metadata !268, metadata !"", i32 96, i64 128, i64 64, i32 0, i32 0, null, metadata !273, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 96, size 128, align 64, offset 0] [from ]
!273 = metadata !{metadata !274, metadata !275}
!274 = metadata !{i32 786445, metadata !269, metadata !272, metadata !"le_next", i32 96, i64 64, i64 64, i64 0, i32 0, metadata !267} ; [ DW_TAG_member ] [le_next] [line 96, size 64, align 64, offset 0] [from ]
!275 = metadata !{i32 786445, metadata !269, metadata !272, metadata !"le_prev", i32 96, i64 64, i64 64, i64 64, i32 0, metadata !276} ; [ DW_TAG_member ] [le_prev] [line 96, size 64, align 64, offset 64] [from ]
!276 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !267} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!277 = metadata !{i32 786445, metadata !269, metadata !268, metadata !"ui_vmsize_mtx", i32 97, i64 256, i64 64, i64 128, i32 0, metadata !24} ; [ DW_TAG_member ] [ui_vmsize_mtx] [line 97, size 256, align 64, offset 128] [from mtx]
!278 = metadata !{i32 786445, metadata !269, metadata !268, metadata !"ui_vmsize", i32 98, i64 64, i64 64, i64 384, i32 0, metadata !279} ; [ DW_TAG_member ] [ui_vmsize] [line 98, size 64, align 64, offset 384] [from vm_ooffset_t]
!279 = metadata !{i32 786454, metadata !269, null, metadata !"vm_ooffset_t", i32 238, i64 0, i64 0, i64 0, i32 0, metadata !280} ; [ DW_TAG_typedef ] [vm_ooffset_t] [line 238, size 0, align 0, offset 0] [from __vm_ooffset_t]
!280 = metadata !{i32 786454, metadata !269, null, metadata !"__vm_ooffset_t", i32 143, i64 0, i64 0, i64 0, i32 0, metadata !281} ; [ DW_TAG_typedef ] [__vm_ooffset_t] [line 143, size 0, align 0, offset 0] [from __int64_t]
!281 = metadata !{i32 786454, metadata !269, null, metadata !"__int64_t", i32 58, i64 0, i64 0, i64 0, i32 0, metadata !87} ; [ DW_TAG_typedef ] [__int64_t] [line 58, size 0, align 0, offset 0] [from long int]
!282 = metadata !{i32 786445, metadata !269, metadata !268, metadata !"ui_sbsize", i32 99, i64 64, i64 64, i64 448, i32 0, metadata !87} ; [ DW_TAG_member ] [ui_sbsize] [line 99, size 64, align 64, offset 448] [from long int]
!283 = metadata !{i32 786445, metadata !269, metadata !268, metadata !"ui_proccnt", i32 100, i64 64, i64 64, i64 512, i32 0, metadata !87} ; [ DW_TAG_member ] [ui_proccnt] [line 100, size 64, align 64, offset 512] [from long int]
!284 = metadata !{i32 786445, metadata !269, metadata !268, metadata !"ui_ptscnt", i32 101, i64 64, i64 64, i64 576, i32 0, metadata !87} ; [ DW_TAG_member ] [ui_ptscnt] [line 101, size 64, align 64, offset 576] [from long int]
!285 = metadata !{i32 786445, metadata !269, metadata !268, metadata !"ui_uid", i32 102, i64 32, i64 32, i64 640, i32 0, metadata !258} ; [ DW_TAG_member ] [ui_uid] [line 102, size 32, align 32, offset 640] [from uid_t]
!286 = metadata !{i32 786445, metadata !269, metadata !268, metadata !"ui_ref", i32 103, i64 32, i64 32, i64 672, i32 0, metadata !36} ; [ DW_TAG_member ] [ui_ref] [line 103, size 32, align 32, offset 672] [from u_int]
!287 = metadata !{i32 786445, metadata !269, metadata !268, metadata !"ui_racct", i32 104, i64 64, i64 64, i64 704, i32 0, metadata !288} ; [ DW_TAG_member ] [ui_racct] [line 104, size 64, align 64, offset 704] [from ]
!288 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !289} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from racct]
!289 = metadata !{i32 786451, metadata !290, null, metadata !"racct", i32 139, i64 1408, i64 64, i32 0, i32 0, null, metadata !291, i32 0, null, null} ; [ DW_TAG_structure_type ] [racct] [line 139, size 1408, align 64, offset 0] [from ]
!290 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/racct.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!291 = metadata !{metadata !292, metadata !297}
!292 = metadata !{i32 786445, metadata !290, metadata !289, metadata !"r_resources", i32 140, i64 1344, i64 64, i64 0, i32 0, metadata !293} ; [ DW_TAG_member ] [r_resources] [line 140, size 1344, align 64, offset 0] [from ]
!293 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 1344, i64 64, i32 0, i32 0, metadata !294, metadata !295, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 1344, align 64, offset 0] [from int64_t]
!294 = metadata !{i32 786454, metadata !290, null, metadata !"int64_t", i32 49, i64 0, i64 0, i64 0, i32 0, metadata !281} ; [ DW_TAG_typedef ] [int64_t] [line 49, size 0, align 0, offset 0] [from __int64_t]
!295 = metadata !{metadata !296}
!296 = metadata !{i32 786465, i64 0, i64 21}      ; [ DW_TAG_subrange_type ] [0, 20]
!297 = metadata !{i32 786445, metadata !290, metadata !289, metadata !"r_rule_links", i32 141, i64 64, i64 64, i64 1344, i32 0, metadata !298} ; [ DW_TAG_member ] [r_rule_links] [line 141, size 64, align 64, offset 1344] [from ]
!298 = metadata !{i32 786451, metadata !290, metadata !289, metadata !"", i32 141, i64 64, i64 64, i32 0, i32 0, null, metadata !299, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 141, size 64, align 64, offset 0] [from ]
!299 = metadata !{metadata !300}
!300 = metadata !{i32 786445, metadata !290, metadata !298, metadata !"lh_first", i32 141, i64 64, i64 64, i64 0, i32 0, metadata !301} ; [ DW_TAG_member ] [lh_first] [line 141, size 64, align 64, offset 0] [from ]
!301 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !302} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from rctl_rule_link]
!302 = metadata !{i32 786451, metadata !290, null, metadata !"rctl_rule_link", i32 44, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [rctl_rule_link] [line 44, size 0, align 0, offset 0] [fwd] [from ]
!303 = metadata !{i32 786445, metadata !147, metadata !254, metadata !"cr_ruidinfo", i32 57, i64 64, i64 64, i64 320, i32 0, metadata !267} ; [ DW_TAG_member ] [cr_ruidinfo] [line 57, size 64, align 64, offset 320] [from ]
!304 = metadata !{i32 786445, metadata !147, metadata !254, metadata !"cr_prison", i32 58, i64 64, i64 64, i64 384, i32 0, metadata !305} ; [ DW_TAG_member ] [cr_prison] [line 58, size 64, align 64, offset 384] [from ]
!305 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !306} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from prison]
!306 = metadata !{i32 786451, metadata !307, null, metadata !"prison", i32 153, i64 17152, i64 64, i32 0, i32 0, null, metadata !308, i32 0, null, null} ; [ DW_TAG_structure_type ] [prison] [line 153, size 17152, align 64, offset 0] [from ]
!307 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/jail.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!308 = metadata !{metadata !309, metadata !315, metadata !316, metadata !317, metadata !318, metadata !319, metadata !323, metadata !328, metadata !329, metadata !330, metadata !349, metadata !363, metadata !364, metadata !380, metadata !383, metadata !384, metadata !385, metadata !392, metadata !415, metadata !431, metadata !435, metadata !436, metadata !437, metadata !438, metadata !439, metadata !440, metadata !441, metadata !443, metadata !444, metadata !445, metadata !449, metadata !450, metadata !451}
!309 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_list", i32 154, i64 128, i64 64, i64 0, i32 0, metadata !310} ; [ DW_TAG_member ] [pr_list] [line 154, size 128, align 64, offset 0] [from ]
!310 = metadata !{i32 786451, metadata !307, metadata !306, metadata !"", i32 154, i64 128, i64 64, i32 0, i32 0, null, metadata !311, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 154, size 128, align 64, offset 0] [from ]
!311 = metadata !{metadata !312, metadata !313}
!312 = metadata !{i32 786445, metadata !307, metadata !310, metadata !"tqe_next", i32 154, i64 64, i64 64, i64 0, i32 0, metadata !305} ; [ DW_TAG_member ] [tqe_next] [line 154, size 64, align 64, offset 0] [from ]
!313 = metadata !{i32 786445, metadata !307, metadata !310, metadata !"tqe_prev", i32 154, i64 64, i64 64, i64 64, i32 0, metadata !314} ; [ DW_TAG_member ] [tqe_prev] [line 154, size 64, align 64, offset 64] [from ]
!314 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !305} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!315 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_id", i32 155, i64 32, i64 32, i64 128, i32 0, metadata !93} ; [ DW_TAG_member ] [pr_id] [line 155, size 32, align 32, offset 128] [from int]
!316 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_ref", i32 156, i64 32, i64 32, i64 160, i32 0, metadata !93} ; [ DW_TAG_member ] [pr_ref] [line 156, size 32, align 32, offset 160] [from int]
!317 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_uref", i32 157, i64 32, i64 32, i64 192, i32 0, metadata !93} ; [ DW_TAG_member ] [pr_uref] [line 157, size 32, align 32, offset 192] [from int]
!318 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_flags", i32 158, i64 32, i64 32, i64 224, i32 0, metadata !37} ; [ DW_TAG_member ] [pr_flags] [line 158, size 32, align 32, offset 224] [from unsigned int]
!319 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_children", i32 159, i64 64, i64 64, i64 256, i32 0, metadata !320} ; [ DW_TAG_member ] [pr_children] [line 159, size 64, align 64, offset 256] [from ]
!320 = metadata !{i32 786451, metadata !307, metadata !306, metadata !"", i32 159, i64 64, i64 64, i32 0, i32 0, null, metadata !321, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 159, size 64, align 64, offset 0] [from ]
!321 = metadata !{metadata !322}
!322 = metadata !{i32 786445, metadata !307, metadata !320, metadata !"lh_first", i32 159, i64 64, i64 64, i64 0, i32 0, metadata !305} ; [ DW_TAG_member ] [lh_first] [line 159, size 64, align 64, offset 0] [from ]
!323 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_sibling", i32 160, i64 128, i64 64, i64 320, i32 0, metadata !324} ; [ DW_TAG_member ] [pr_sibling] [line 160, size 128, align 64, offset 320] [from ]
!324 = metadata !{i32 786451, metadata !307, metadata !306, metadata !"", i32 160, i64 128, i64 64, i32 0, i32 0, null, metadata !325, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 160, size 128, align 64, offset 0] [from ]
!325 = metadata !{metadata !326, metadata !327}
!326 = metadata !{i32 786445, metadata !307, metadata !324, metadata !"le_next", i32 160, i64 64, i64 64, i64 0, i32 0, metadata !305} ; [ DW_TAG_member ] [le_next] [line 160, size 64, align 64, offset 0] [from ]
!327 = metadata !{i32 786445, metadata !307, metadata !324, metadata !"le_prev", i32 160, i64 64, i64 64, i64 64, i32 0, metadata !314} ; [ DW_TAG_member ] [le_prev] [line 160, size 64, align 64, offset 64] [from ]
!328 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_parent", i32 161, i64 64, i64 64, i64 448, i32 0, metadata !305} ; [ DW_TAG_member ] [pr_parent] [line 161, size 64, align 64, offset 448] [from ]
!329 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_mtx", i32 162, i64 256, i64 64, i64 512, i32 0, metadata !24} ; [ DW_TAG_member ] [pr_mtx] [line 162, size 256, align 64, offset 512] [from mtx]
!330 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_task", i32 163, i64 256, i64 64, i64 768, i32 0, metadata !331} ; [ DW_TAG_member ] [pr_task] [line 163, size 256, align 64, offset 768] [from task]
!331 = metadata !{i32 786451, metadata !332, null, metadata !"task", i32 46, i64 256, i64 64, i32 0, i32 0, null, metadata !333, i32 0, null, null} ; [ DW_TAG_structure_type ] [task] [line 46, size 256, align 64, offset 0] [from ]
!332 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/_task.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!333 = metadata !{metadata !334, metadata !339, metadata !342, metadata !343, metadata !348}
!334 = metadata !{i32 786445, metadata !332, metadata !331, metadata !"ta_link", i32 47, i64 64, i64 64, i64 0, i32 0, metadata !335} ; [ DW_TAG_member ] [ta_link] [line 47, size 64, align 64, offset 0] [from ]
!335 = metadata !{i32 786451, metadata !332, metadata !331, metadata !"", i32 47, i64 64, i64 64, i32 0, i32 0, null, metadata !336, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 47, size 64, align 64, offset 0] [from ]
!336 = metadata !{metadata !337}
!337 = metadata !{i32 786445, metadata !332, metadata !335, metadata !"stqe_next", i32 47, i64 64, i64 64, i64 0, i32 0, metadata !338} ; [ DW_TAG_member ] [stqe_next] [line 47, size 64, align 64, offset 0] [from ]
!338 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !331} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from task]
!339 = metadata !{i32 786445, metadata !332, metadata !331, metadata !"ta_pending", i32 48, i64 16, i64 16, i64 64, i32 0, metadata !340} ; [ DW_TAG_member ] [ta_pending] [line 48, size 16, align 16, offset 64] [from u_short]
!340 = metadata !{i32 786454, metadata !332, null, metadata !"u_short", i32 51, i64 0, i64 0, i64 0, i32 0, metadata !341} ; [ DW_TAG_typedef ] [u_short] [line 51, size 0, align 0, offset 0] [from unsigned short]
!341 = metadata !{i32 786468, null, null, metadata !"unsigned short", i32 0, i64 16, i64 16, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [unsigned short] [line 0, size 16, align 16, offset 0, enc DW_ATE_unsigned]
!342 = metadata !{i32 786445, metadata !332, metadata !331, metadata !"ta_priority", i32 49, i64 16, i64 16, i64 80, i32 0, metadata !340} ; [ DW_TAG_member ] [ta_priority] [line 49, size 16, align 16, offset 80] [from u_short]
!343 = metadata !{i32 786445, metadata !332, metadata !331, metadata !"ta_func", i32 50, i64 64, i64 64, i64 128, i32 0, metadata !344} ; [ DW_TAG_member ] [ta_func] [line 50, size 64, align 64, offset 128] [from ]
!344 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !345} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from task_fn_t]
!345 = metadata !{i32 786454, metadata !332, null, metadata !"task_fn_t", i32 44, i64 0, i64 0, i64 0, i32 0, metadata !346} ; [ DW_TAG_typedef ] [task_fn_t] [line 44, size 0, align 0, offset 0] [from ]
!346 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !347, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!347 = metadata !{null, metadata !178, metadata !93}
!348 = metadata !{i32 786445, metadata !332, metadata !331, metadata !"ta_context", i32 51, i64 64, i64 64, i64 192, i32 0, metadata !178} ; [ DW_TAG_member ] [ta_context] [line 51, size 64, align 64, offset 192] [from ]
!349 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_osd", i32 164, i64 256, i64 64, i64 1024, i32 0, metadata !350} ; [ DW_TAG_member ] [pr_osd] [line 164, size 256, align 64, offset 1024] [from osd]
!350 = metadata !{i32 786451, metadata !351, null, metadata !"osd", i32 39, i64 256, i64 64, i32 0, i32 0, null, metadata !352, i32 0, null, null} ; [ DW_TAG_structure_type ] [osd] [line 39, size 256, align 64, offset 0] [from ]
!351 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/osd.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!352 = metadata !{metadata !353, metadata !354, metadata !356}
!353 = metadata !{i32 786445, metadata !351, metadata !350, metadata !"osd_nslots", i32 40, i64 32, i64 32, i64 0, i32 0, metadata !36} ; [ DW_TAG_member ] [osd_nslots] [line 40, size 32, align 32, offset 0] [from u_int]
!354 = metadata !{i32 786445, metadata !351, metadata !350, metadata !"osd_slots", i32 41, i64 64, i64 64, i64 64, i32 0, metadata !355} ; [ DW_TAG_member ] [osd_slots] [line 41, size 64, align 64, offset 64] [from ]
!355 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !178} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!356 = metadata !{i32 786445, metadata !351, metadata !350, metadata !"osd_next", i32 42, i64 128, i64 64, i64 128, i32 0, metadata !357} ; [ DW_TAG_member ] [osd_next] [line 42, size 128, align 64, offset 128] [from ]
!357 = metadata !{i32 786451, metadata !351, metadata !350, metadata !"", i32 42, i64 128, i64 64, i32 0, i32 0, null, metadata !358, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 42, size 128, align 64, offset 0] [from ]
!358 = metadata !{metadata !359, metadata !361}
!359 = metadata !{i32 786445, metadata !351, metadata !357, metadata !"le_next", i32 42, i64 64, i64 64, i64 0, i32 0, metadata !360} ; [ DW_TAG_member ] [le_next] [line 42, size 64, align 64, offset 0] [from ]
!360 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !350} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from osd]
!361 = metadata !{i32 786445, metadata !351, metadata !357, metadata !"le_prev", i32 42, i64 64, i64 64, i64 64, i32 0, metadata !362} ; [ DW_TAG_member ] [le_prev] [line 42, size 64, align 64, offset 64] [from ]
!362 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !360} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!363 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_cpuset", i32 165, i64 64, i64 64, i64 1280, i32 0, metadata !76} ; [ DW_TAG_member ] [pr_cpuset] [line 165, size 64, align 64, offset 1280] [from ]
!364 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_vnet", i32 166, i64 64, i64 64, i64 1344, i32 0, metadata !365} ; [ DW_TAG_member ] [pr_vnet] [line 166, size 64, align 64, offset 1344] [from ]
!365 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !366} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from vnet]
!366 = metadata !{i32 786451, metadata !367, null, metadata !"vnet", i32 68, i64 384, i64 64, i32 0, i32 0, null, metadata !368, i32 0, null, null} ; [ DW_TAG_structure_type ] [vnet] [line 68, size 384, align 64, offset 0] [from ]
!367 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/net/vnet.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!368 = metadata !{metadata !369, metadata !375, metadata !376, metadata !377, metadata !378, metadata !379}
!369 = metadata !{i32 786445, metadata !367, metadata !366, metadata !"vnet_le", i32 69, i64 128, i64 64, i64 0, i32 0, metadata !370} ; [ DW_TAG_member ] [vnet_le] [line 69, size 128, align 64, offset 0] [from ]
!370 = metadata !{i32 786451, metadata !367, metadata !366, metadata !"", i32 69, i64 128, i64 64, i32 0, i32 0, null, metadata !371, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 69, size 128, align 64, offset 0] [from ]
!371 = metadata !{metadata !372, metadata !373}
!372 = metadata !{i32 786445, metadata !367, metadata !370, metadata !"le_next", i32 69, i64 64, i64 64, i64 0, i32 0, metadata !365} ; [ DW_TAG_member ] [le_next] [line 69, size 64, align 64, offset 0] [from ]
!373 = metadata !{i32 786445, metadata !367, metadata !370, metadata !"le_prev", i32 69, i64 64, i64 64, i64 64, i32 0, metadata !374} ; [ DW_TAG_member ] [le_prev] [line 69, size 64, align 64, offset 64] [from ]
!374 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !365} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!375 = metadata !{i32 786445, metadata !367, metadata !366, metadata !"vnet_magic_n", i32 70, i64 32, i64 32, i64 128, i32 0, metadata !36} ; [ DW_TAG_member ] [vnet_magic_n] [line 70, size 32, align 32, offset 128] [from u_int]
!376 = metadata !{i32 786445, metadata !367, metadata !366, metadata !"vnet_ifcnt", i32 71, i64 32, i64 32, i64 160, i32 0, metadata !36} ; [ DW_TAG_member ] [vnet_ifcnt] [line 71, size 32, align 32, offset 160] [from u_int]
!377 = metadata !{i32 786445, metadata !367, metadata !366, metadata !"vnet_sockcnt", i32 72, i64 32, i64 32, i64 192, i32 0, metadata !36} ; [ DW_TAG_member ] [vnet_sockcnt] [line 72, size 32, align 32, offset 192] [from u_int]
!378 = metadata !{i32 786445, metadata !367, metadata !366, metadata !"vnet_data_mem", i32 73, i64 64, i64 64, i64 256, i32 0, metadata !178} ; [ DW_TAG_member ] [vnet_data_mem] [line 73, size 64, align 64, offset 256] [from ]
!379 = metadata !{i32 786445, metadata !367, metadata !366, metadata !"vnet_data_base", i32 74, i64 64, i64 64, i64 320, i32 0, metadata !44} ; [ DW_TAG_member ] [vnet_data_base] [line 74, size 64, align 64, offset 320] [from uintptr_t]
!380 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_root", i32 167, i64 64, i64 64, i64 1408, i32 0, metadata !381} ; [ DW_TAG_member ] [pr_root] [line 167, size 64, align 64, offset 1408] [from ]
!381 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !382} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from vnode]
!382 = metadata !{i32 786451, metadata !4, null, metadata !"vnode", i32 79, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [vnode] [line 79, size 0, align 0, offset 0] [fwd] [from ]
!383 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_ip4s", i32 168, i64 32, i64 32, i64 1472, i32 0, metadata !93} ; [ DW_TAG_member ] [pr_ip4s] [line 168, size 32, align 32, offset 1472] [from int]
!384 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_ip6s", i32 169, i64 32, i64 32, i64 1504, i32 0, metadata !93} ; [ DW_TAG_member ] [pr_ip6s] [line 169, size 32, align 32, offset 1504] [from int]
!385 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_ip4", i32 170, i64 64, i64 64, i64 1536, i32 0, metadata !386} ; [ DW_TAG_member ] [pr_ip4] [line 170, size 64, align 64, offset 1536] [from ]
!386 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !387} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from in_addr]
!387 = metadata !{i32 786451, metadata !388, null, metadata !"in_addr", i32 81, i64 32, i64 32, i32 0, i32 0, null, metadata !389, i32 0, null, null} ; [ DW_TAG_structure_type ] [in_addr] [line 81, size 32, align 32, offset 0] [from ]
!388 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/netinet/in.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!389 = metadata !{metadata !390}
!390 = metadata !{i32 786445, metadata !388, metadata !387, metadata !"s_addr", i32 82, i64 32, i64 32, i64 0, i32 0, metadata !391} ; [ DW_TAG_member ] [s_addr] [line 82, size 32, align 32, offset 0] [from in_addr_t]
!391 = metadata !{i32 786454, metadata !388, null, metadata !"in_addr_t", i32 130, i64 0, i64 0, i64 0, i32 0, metadata !146} ; [ DW_TAG_typedef ] [in_addr_t] [line 130, size 0, align 0, offset 0] [from __uint32_t]
!392 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_ip6", i32 171, i64 64, i64 64, i64 1600, i32 0, metadata !393} ; [ DW_TAG_member ] [pr_ip6] [line 171, size 64, align 64, offset 1600] [from ]
!393 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !394} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from in6_addr]
!394 = metadata !{i32 786451, metadata !395, null, metadata !"in6_addr", i32 95, i64 128, i64 32, i32 0, i32 0, null, metadata !396, i32 0, null, null} ; [ DW_TAG_structure_type ] [in6_addr] [line 95, size 128, align 32, offset 0] [from ]
!395 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/netinet6/in6.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!396 = metadata !{metadata !397}
!397 = metadata !{i32 786445, metadata !395, metadata !394, metadata !"__u6_addr", i32 100, i64 128, i64 32, i64 0, i32 0, metadata !398} ; [ DW_TAG_member ] [__u6_addr] [line 100, size 128, align 32, offset 0] [from ]
!398 = metadata !{i32 786455, metadata !395, metadata !394, metadata !"", i32 96, i64 128, i64 32, i64 0, i32 0, null, metadata !399, i32 0, i32 0, null} ; [ DW_TAG_union_type ] [line 96, size 128, align 32, offset 0] [from ]
!399 = metadata !{metadata !400, metadata !406, metadata !412}
!400 = metadata !{i32 786445, metadata !395, metadata !398, metadata !"__u6_addr8", i32 97, i64 128, i64 8, i64 0, i32 0, metadata !401} ; [ DW_TAG_member ] [__u6_addr8] [line 97, size 128, align 8, offset 0] [from ]
!401 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 128, i64 8, i32 0, i32 0, metadata !402, metadata !404, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 128, align 8, offset 0] [from uint8_t]
!402 = metadata !{i32 786454, metadata !395, null, metadata !"uint8_t", i32 54, i64 0, i64 0, i64 0, i32 0, metadata !403} ; [ DW_TAG_typedef ] [uint8_t] [line 54, size 0, align 0, offset 0] [from __uint8_t]
!403 = metadata !{i32 786454, metadata !395, null, metadata !"__uint8_t", i32 52, i64 0, i64 0, i64 0, i32 0, metadata !222} ; [ DW_TAG_typedef ] [__uint8_t] [line 52, size 0, align 0, offset 0] [from unsigned char]
!404 = metadata !{metadata !405}
!405 = metadata !{i32 786465, i64 0, i64 16}      ; [ DW_TAG_subrange_type ] [0, 15]
!406 = metadata !{i32 786445, metadata !395, metadata !398, metadata !"__u6_addr16", i32 98, i64 128, i64 16, i64 0, i32 0, metadata !407} ; [ DW_TAG_member ] [__u6_addr16] [line 98, size 128, align 16, offset 0] [from ]
!407 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 128, i64 16, i32 0, i32 0, metadata !408, metadata !410, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 128, align 16, offset 0] [from uint16_t]
!408 = metadata !{i32 786454, metadata !395, null, metadata !"uint16_t", i32 59, i64 0, i64 0, i64 0, i32 0, metadata !409} ; [ DW_TAG_typedef ] [uint16_t] [line 59, size 0, align 0, offset 0] [from __uint16_t]
!409 = metadata !{i32 786454, metadata !395, null, metadata !"__uint16_t", i32 54, i64 0, i64 0, i64 0, i32 0, metadata !341} ; [ DW_TAG_typedef ] [__uint16_t] [line 54, size 0, align 0, offset 0] [from unsigned short]
!410 = metadata !{metadata !411}
!411 = metadata !{i32 786465, i64 0, i64 8}       ; [ DW_TAG_subrange_type ] [0, 7]
!412 = metadata !{i32 786445, metadata !395, metadata !398, metadata !"__u6_addr32", i32 99, i64 128, i64 32, i64 0, i32 0, metadata !413} ; [ DW_TAG_member ] [__u6_addr32] [line 99, size 128, align 32, offset 0] [from ]
!413 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 128, i64 32, i32 0, i32 0, metadata !414, metadata !148, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 128, align 32, offset 0] [from uint32_t]
!414 = metadata !{i32 786454, metadata !395, null, metadata !"uint32_t", i32 64, i64 0, i64 0, i64 0, i32 0, metadata !146} ; [ DW_TAG_typedef ] [uint32_t] [line 64, size 0, align 0, offset 0] [from __uint32_t]
!415 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_prison_racct", i32 172, i64 64, i64 64, i64 1664, i32 0, metadata !416} ; [ DW_TAG_member ] [pr_prison_racct] [line 172, size 64, align 64, offset 1664] [from ]
!416 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !417} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from prison_racct]
!417 = metadata !{i32 786451, metadata !307, null, metadata !"prison_racct", i32 189, i64 2304, i64 64, i32 0, i32 0, null, metadata !418, i32 0, null, null} ; [ DW_TAG_structure_type ] [prison_racct] [line 189, size 2304, align 64, offset 0] [from ]
!418 = metadata !{metadata !419, metadata !425, metadata !429, metadata !430}
!419 = metadata !{i32 786445, metadata !307, metadata !417, metadata !"prr_next", i32 190, i64 128, i64 64, i64 0, i32 0, metadata !420} ; [ DW_TAG_member ] [prr_next] [line 190, size 128, align 64, offset 0] [from ]
!420 = metadata !{i32 786451, metadata !307, metadata !417, metadata !"", i32 190, i64 128, i64 64, i32 0, i32 0, null, metadata !421, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 190, size 128, align 64, offset 0] [from ]
!421 = metadata !{metadata !422, metadata !423}
!422 = metadata !{i32 786445, metadata !307, metadata !420, metadata !"le_next", i32 190, i64 64, i64 64, i64 0, i32 0, metadata !416} ; [ DW_TAG_member ] [le_next] [line 190, size 64, align 64, offset 0] [from ]
!423 = metadata !{i32 786445, metadata !307, metadata !420, metadata !"le_prev", i32 190, i64 64, i64 64, i64 64, i32 0, metadata !424} ; [ DW_TAG_member ] [le_prev] [line 190, size 64, align 64, offset 64] [from ]
!424 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !416} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!425 = metadata !{i32 786445, metadata !307, metadata !417, metadata !"prr_name", i32 191, i64 2048, i64 8, i64 128, i32 0, metadata !426} ; [ DW_TAG_member ] [prr_name] [line 191, size 2048, align 8, offset 128] [from ]
!426 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 2048, i64 8, i32 0, i32 0, metadata !34, metadata !427, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 2048, align 8, offset 0] [from char]
!427 = metadata !{metadata !428}
!428 = metadata !{i32 786465, i64 0, i64 256}     ; [ DW_TAG_subrange_type ] [0, 255]
!429 = metadata !{i32 786445, metadata !307, metadata !417, metadata !"prr_refcount", i32 192, i64 32, i64 32, i64 2176, i32 0, metadata !36} ; [ DW_TAG_member ] [prr_refcount] [line 192, size 32, align 32, offset 2176] [from u_int]
!430 = metadata !{i32 786445, metadata !307, metadata !417, metadata !"prr_racct", i32 193, i64 64, i64 64, i64 2240, i32 0, metadata !288} ; [ DW_TAG_member ] [prr_racct] [line 193, size 64, align 64, offset 2240] [from ]
!431 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_sparep", i32 173, i64 192, i64 64, i64 1728, i32 0, metadata !432} ; [ DW_TAG_member ] [pr_sparep] [line 173, size 192, align 64, offset 1728] [from ]
!432 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 192, i64 64, i32 0, i32 0, metadata !178, metadata !433, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 192, align 64, offset 0] [from ]
!433 = metadata !{metadata !434}
!434 = metadata !{i32 786465, i64 0, i64 3}       ; [ DW_TAG_subrange_type ] [0, 2]
!435 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_childcount", i32 174, i64 32, i64 32, i64 1920, i32 0, metadata !93} ; [ DW_TAG_member ] [pr_childcount] [line 174, size 32, align 32, offset 1920] [from int]
!436 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_childmax", i32 175, i64 32, i64 32, i64 1952, i32 0, metadata !93} ; [ DW_TAG_member ] [pr_childmax] [line 175, size 32, align 32, offset 1952] [from int]
!437 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_allow", i32 176, i64 32, i64 32, i64 1984, i32 0, metadata !37} ; [ DW_TAG_member ] [pr_allow] [line 176, size 32, align 32, offset 1984] [from unsigned int]
!438 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_securelevel", i32 177, i64 32, i64 32, i64 2016, i32 0, metadata !93} ; [ DW_TAG_member ] [pr_securelevel] [line 177, size 32, align 32, offset 2016] [from int]
!439 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_enforce_statfs", i32 178, i64 32, i64 32, i64 2048, i32 0, metadata !93} ; [ DW_TAG_member ] [pr_enforce_statfs] [line 178, size 32, align 32, offset 2048] [from int]
!440 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_devfs_rsnum", i32 179, i64 32, i64 32, i64 2080, i32 0, metadata !93} ; [ DW_TAG_member ] [pr_devfs_rsnum] [line 179, size 32, align 32, offset 2080] [from int]
!441 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_spare", i32 180, i64 128, i64 32, i64 2112, i32 0, metadata !442} ; [ DW_TAG_member ] [pr_spare] [line 180, size 128, align 32, offset 2112] [from ]
!442 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 128, i64 32, i32 0, i32 0, metadata !93, metadata !148, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 128, align 32, offset 0] [from int]
!443 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_hostid", i32 181, i64 64, i64 64, i64 2240, i32 0, metadata !47} ; [ DW_TAG_member ] [pr_hostid] [line 181, size 64, align 64, offset 2240] [from long unsigned int]
!444 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_name", i32 182, i64 2048, i64 8, i64 2304, i32 0, metadata !426} ; [ DW_TAG_member ] [pr_name] [line 182, size 2048, align 8, offset 2304] [from ]
!445 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_path", i32 183, i64 8192, i64 8, i64 4352, i32 0, metadata !446} ; [ DW_TAG_member ] [pr_path] [line 183, size 8192, align 8, offset 4352] [from ]
!446 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 8192, i64 8, i32 0, i32 0, metadata !34, metadata !447, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 8192, align 8, offset 0] [from char]
!447 = metadata !{metadata !448}
!448 = metadata !{i32 786465, i64 0, i64 1024}    ; [ DW_TAG_subrange_type ] [0, 1023]
!449 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_hostname", i32 184, i64 2048, i64 8, i64 12544, i32 0, metadata !426} ; [ DW_TAG_member ] [pr_hostname] [line 184, size 2048, align 8, offset 12544] [from ]
!450 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_domainname", i32 185, i64 2048, i64 8, i64 14592, i32 0, metadata !426} ; [ DW_TAG_member ] [pr_domainname] [line 185, size 2048, align 8, offset 14592] [from ]
!451 = metadata !{i32 786445, metadata !307, metadata !306, metadata !"pr_hostuuid", i32 186, i64 512, i64 8, i64 16640, i32 0, metadata !452} ; [ DW_TAG_member ] [pr_hostuuid] [line 186, size 512, align 8, offset 16640] [from ]
!452 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 512, i64 8, i32 0, i32 0, metadata !34, metadata !453, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 512, align 8, offset 0] [from char]
!453 = metadata !{metadata !454}
!454 = metadata !{i32 786465, i64 0, i64 64}      ; [ DW_TAG_subrange_type ] [0, 63]
!455 = metadata !{i32 786445, metadata !147, metadata !254, metadata !"cr_loginclass", i32 59, i64 64, i64 64, i64 448, i32 0, metadata !456} ; [ DW_TAG_member ] [cr_loginclass] [line 59, size 64, align 64, offset 448] [from ]
!456 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !457} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from loginclass]
!457 = metadata !{i32 786451, metadata !458, null, metadata !"loginclass", i32 40, i64 512, i64 64, i32 0, i32 0, null, metadata !459, i32 0, null, null} ; [ DW_TAG_structure_type ] [loginclass] [line 40, size 512, align 64, offset 0] [from ]
!458 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/loginclass.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!459 = metadata !{metadata !460, metadata !466, metadata !470, metadata !471}
!460 = metadata !{i32 786445, metadata !458, metadata !457, metadata !"lc_next", i32 41, i64 128, i64 64, i64 0, i32 0, metadata !461} ; [ DW_TAG_member ] [lc_next] [line 41, size 128, align 64, offset 0] [from ]
!461 = metadata !{i32 786451, metadata !458, metadata !457, metadata !"", i32 41, i64 128, i64 64, i32 0, i32 0, null, metadata !462, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 41, size 128, align 64, offset 0] [from ]
!462 = metadata !{metadata !463, metadata !464}
!463 = metadata !{i32 786445, metadata !458, metadata !461, metadata !"le_next", i32 41, i64 64, i64 64, i64 0, i32 0, metadata !456} ; [ DW_TAG_member ] [le_next] [line 41, size 64, align 64, offset 0] [from ]
!464 = metadata !{i32 786445, metadata !458, metadata !461, metadata !"le_prev", i32 41, i64 64, i64 64, i64 64, i32 0, metadata !465} ; [ DW_TAG_member ] [le_prev] [line 41, size 64, align 64, offset 64] [from ]
!465 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !456} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!466 = metadata !{i32 786445, metadata !458, metadata !457, metadata !"lc_name", i32 42, i64 264, i64 8, i64 128, i32 0, metadata !467} ; [ DW_TAG_member ] [lc_name] [line 42, size 264, align 8, offset 128] [from ]
!467 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 264, i64 8, i32 0, i32 0, metadata !34, metadata !468, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 264, align 8, offset 0] [from char]
!468 = metadata !{metadata !469}
!469 = metadata !{i32 786465, i64 0, i64 33}      ; [ DW_TAG_subrange_type ] [0, 32]
!470 = metadata !{i32 786445, metadata !458, metadata !457, metadata !"lc_refcount", i32 43, i64 32, i64 32, i64 416, i32 0, metadata !36} ; [ DW_TAG_member ] [lc_refcount] [line 43, size 32, align 32, offset 416] [from u_int]
!471 = metadata !{i32 786445, metadata !458, metadata !457, metadata !"lc_racct", i32 44, i64 64, i64 64, i64 448, i32 0, metadata !288} ; [ DW_TAG_member ] [lc_racct] [line 44, size 64, align 64, offset 448] [from ]
!472 = metadata !{i32 786445, metadata !147, metadata !254, metadata !"cr_flags", i32 60, i64 32, i64 32, i64 512, i32 0, metadata !36} ; [ DW_TAG_member ] [cr_flags] [line 60, size 32, align 32, offset 512] [from u_int]
!473 = metadata !{i32 786445, metadata !147, metadata !254, metadata !"cr_pspare2", i32 61, i64 128, i64 64, i64 576, i32 0, metadata !474} ; [ DW_TAG_member ] [cr_pspare2] [line 61, size 128, align 64, offset 576] [from ]
!474 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 128, i64 64, i32 0, i32 0, metadata !178, metadata !475, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 128, align 64, offset 0] [from ]
!475 = metadata !{metadata !476}
!476 = metadata !{i32 786465, i64 0, i64 2}       ; [ DW_TAG_subrange_type ] [0, 1]
!477 = metadata !{i32 786445, metadata !147, metadata !254, metadata !"cr_label", i32 63, i64 64, i64 64, i64 704, i32 0, metadata !478} ; [ DW_TAG_member ] [cr_label] [line 63, size 64, align 64, offset 704] [from ]
!478 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !479} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from label]
!479 = metadata !{i32 786451, metadata !147, null, metadata !"label", i32 63, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [label] [line 63, size 0, align 0, offset 0] [fwd] [from ]
!480 = metadata !{i32 786445, metadata !147, metadata !254, metadata !"cr_audit", i32 64, i64 384, i64 64, i64 768, i32 0, metadata !481} ; [ DW_TAG_member ] [cr_audit] [line 64, size 384, align 64, offset 768] [from auditinfo_addr]
!481 = metadata !{i32 786451, metadata !132, null, metadata !"auditinfo_addr", i32 205, i64 384, i64 64, i32 0, i32 0, null, metadata !482, i32 0, null, null} ; [ DW_TAG_structure_type ] [auditinfo_addr] [line 205, size 384, align 64, offset 0] [from ]
!482 = metadata !{metadata !483, metadata !485, metadata !491, metadata !502, metadata !505}
!483 = metadata !{i32 786445, metadata !132, metadata !481, metadata !"ai_auid", i32 206, i64 32, i64 32, i64 0, i32 0, metadata !484} ; [ DW_TAG_member ] [ai_auid] [line 206, size 32, align 32, offset 0] [from au_id_t]
!484 = metadata !{i32 786454, metadata !132, null, metadata !"au_id_t", i32 171, i64 0, i64 0, i64 0, i32 0, metadata !258} ; [ DW_TAG_typedef ] [au_id_t] [line 171, size 0, align 0, offset 0] [from uid_t]
!485 = metadata !{i32 786445, metadata !132, metadata !481, metadata !"ai_mask", i32 207, i64 64, i64 32, i64 32, i32 0, metadata !486} ; [ DW_TAG_member ] [ai_mask] [line 207, size 64, align 32, offset 32] [from au_mask_t]
!486 = metadata !{i32 786454, metadata !132, null, metadata !"au_mask_t", i32 195, i64 0, i64 0, i64 0, i32 0, metadata !487} ; [ DW_TAG_typedef ] [au_mask_t] [line 195, size 0, align 0, offset 0] [from au_mask]
!487 = metadata !{i32 786451, metadata !132, null, metadata !"au_mask", i32 191, i64 64, i64 32, i32 0, i32 0, null, metadata !488, i32 0, null, null} ; [ DW_TAG_structure_type ] [au_mask] [line 191, size 64, align 32, offset 0] [from ]
!488 = metadata !{metadata !489, metadata !490}
!489 = metadata !{i32 786445, metadata !132, metadata !487, metadata !"am_success", i32 192, i64 32, i64 32, i64 0, i32 0, metadata !37} ; [ DW_TAG_member ] [am_success] [line 192, size 32, align 32, offset 0] [from unsigned int]
!490 = metadata !{i32 786445, metadata !132, metadata !487, metadata !"am_failure", i32 193, i64 32, i64 32, i64 32, i32 0, metadata !37} ; [ DW_TAG_member ] [am_failure] [line 193, size 32, align 32, offset 32] [from unsigned int]
!491 = metadata !{i32 786445, metadata !132, metadata !481, metadata !"ai_termid", i32 208, i64 192, i64 32, i64 96, i32 0, metadata !492} ; [ DW_TAG_member ] [ai_termid] [line 208, size 192, align 32, offset 96] [from au_tid_addr_t]
!492 = metadata !{i32 786454, metadata !132, null, metadata !"au_tid_addr_t", i32 189, i64 0, i64 0, i64 0, i32 0, metadata !493} ; [ DW_TAG_typedef ] [au_tid_addr_t] [line 189, size 0, align 0, offset 0] [from au_tid_addr]
!493 = metadata !{i32 786451, metadata !132, null, metadata !"au_tid_addr", i32 184, i64 192, i64 32, i32 0, i32 0, null, metadata !494, i32 0, null, null} ; [ DW_TAG_structure_type ] [au_tid_addr] [line 184, size 192, align 32, offset 0] [from ]
!494 = metadata !{metadata !495, metadata !498, metadata !500}
!495 = metadata !{i32 786445, metadata !132, metadata !493, metadata !"at_port", i32 185, i64 32, i64 32, i64 0, i32 0, metadata !496} ; [ DW_TAG_member ] [at_port] [line 185, size 32, align 32, offset 0] [from dev_t]
!496 = metadata !{i32 786454, metadata !132, null, metadata !"dev_t", i32 107, i64 0, i64 0, i64 0, i32 0, metadata !497} ; [ DW_TAG_typedef ] [dev_t] [line 107, size 0, align 0, offset 0] [from __dev_t]
!497 = metadata !{i32 786454, metadata !132, null, metadata !"__dev_t", i32 103, i64 0, i64 0, i64 0, i32 0, metadata !146} ; [ DW_TAG_typedef ] [__dev_t] [line 103, size 0, align 0, offset 0] [from __uint32_t]
!498 = metadata !{i32 786445, metadata !132, metadata !493, metadata !"at_type", i32 186, i64 32, i64 32, i64 32, i32 0, metadata !499} ; [ DW_TAG_member ] [at_type] [line 186, size 32, align 32, offset 32] [from u_int32_t]
!499 = metadata !{i32 786454, metadata !132, null, metadata !"u_int32_t", i32 67, i64 0, i64 0, i64 0, i32 0, metadata !146} ; [ DW_TAG_typedef ] [u_int32_t] [line 67, size 0, align 0, offset 0] [from __uint32_t]
!500 = metadata !{i32 786445, metadata !132, metadata !493, metadata !"at_addr", i32 187, i64 128, i64 32, i64 64, i32 0, metadata !501} ; [ DW_TAG_member ] [at_addr] [line 187, size 128, align 32, offset 64] [from ]
!501 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 128, i64 32, i32 0, i32 0, metadata !499, metadata !148, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 128, align 32, offset 0] [from u_int32_t]
!502 = metadata !{i32 786445, metadata !132, metadata !481, metadata !"ai_asid", i32 209, i64 32, i64 32, i64 288, i32 0, metadata !503} ; [ DW_TAG_member ] [ai_asid] [line 209, size 32, align 32, offset 288] [from au_asid_t]
!503 = metadata !{i32 786454, metadata !132, null, metadata !"au_asid_t", i32 172, i64 0, i64 0, i64 0, i32 0, metadata !504} ; [ DW_TAG_typedef ] [au_asid_t] [line 172, size 0, align 0, offset 0] [from pid_t]
!504 = metadata !{i32 786454, metadata !132, null, metadata !"pid_t", i32 180, i64 0, i64 0, i64 0, i32 0, metadata !173} ; [ DW_TAG_typedef ] [pid_t] [line 180, size 0, align 0, offset 0] [from __pid_t]
!505 = metadata !{i32 786445, metadata !132, metadata !481, metadata !"ai_flags", i32 210, i64 64, i64 64, i64 320, i32 0, metadata !506} ; [ DW_TAG_member ] [ai_flags] [line 210, size 64, align 64, offset 320] [from au_asflgs_t]
!506 = metadata !{i32 786454, metadata !132, null, metadata !"au_asflgs_t", i32 176, i64 0, i64 0, i64 0, i32 0, metadata !507} ; [ DW_TAG_typedef ] [au_asflgs_t] [line 176, size 0, align 0, offset 0] [from u_int64_t]
!507 = metadata !{i32 786454, metadata !132, null, metadata !"u_int64_t", i32 68, i64 0, i64 0, i64 0, i32 0, metadata !46} ; [ DW_TAG_typedef ] [u_int64_t] [line 68, size 0, align 0, offset 0] [from __uint64_t]
!508 = metadata !{i32 786445, metadata !147, metadata !254, metadata !"cr_groups", i32 65, i64 64, i64 64, i64 1152, i32 0, metadata !509} ; [ DW_TAG_member ] [cr_groups] [line 65, size 64, align 64, offset 1152] [from ]
!509 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !263} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from gid_t]
!510 = metadata !{i32 786445, metadata !147, metadata !254, metadata !"cr_agroups", i32 66, i64 32, i64 32, i64 1216, i32 0, metadata !93} ; [ DW_TAG_member ] [cr_agroups] [line 66, size 32, align 32, offset 1216] [from int]
!511 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_estcpu", i32 248, i64 32, i64 32, i64 2560, i32 0, metadata !36} ; [ DW_TAG_member ] [td_estcpu] [line 248, size 32, align 32, offset 2560] [from u_int]
!512 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_slptick", i32 249, i64 32, i64 32, i64 2592, i32 0, metadata !93} ; [ DW_TAG_member ] [td_slptick] [line 249, size 32, align 32, offset 2592] [from int]
!513 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_blktick", i32 250, i64 32, i64 32, i64 2624, i32 0, metadata !93} ; [ DW_TAG_member ] [td_blktick] [line 250, size 32, align 32, offset 2624] [from int]
!514 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_swvoltick", i32 251, i64 32, i64 32, i64 2656, i32 0, metadata !93} ; [ DW_TAG_member ] [td_swvoltick] [line 251, size 32, align 32, offset 2656] [from int]
!515 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_cow", i32 252, i64 32, i64 32, i64 2688, i32 0, metadata !36} ; [ DW_TAG_member ] [td_cow] [line 252, size 32, align 32, offset 2688] [from u_int]
!516 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_ru", i32 253, i64 1152, i64 64, i64 2752, i32 0, metadata !517} ; [ DW_TAG_member ] [td_ru] [line 253, size 1152, align 64, offset 2752] [from rusage]
!517 = metadata !{i32 786451, metadata !518, null, metadata !"rusage", i32 61, i64 1152, i64 64, i32 0, i32 0, null, metadata !519, i32 0, null, null} ; [ DW_TAG_structure_type ] [rusage] [line 61, size 1152, align 64, offset 0] [from ]
!518 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/resource.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!519 = metadata !{metadata !520, metadata !530, metadata !531, metadata !532, metadata !533, metadata !534, metadata !535, metadata !536, metadata !537, metadata !538, metadata !539, metadata !540, metadata !541, metadata !542, metadata !543, metadata !544}
!520 = metadata !{i32 786445, metadata !518, metadata !517, metadata !"ru_utime", i32 62, i64 128, i64 64, i64 0, i32 0, metadata !521} ; [ DW_TAG_member ] [ru_utime] [line 62, size 128, align 64, offset 0] [from timeval]
!521 = metadata !{i32 786451, metadata !522, null, metadata !"timeval", i32 47, i64 128, i64 64, i32 0, i32 0, null, metadata !523, i32 0, null, null} ; [ DW_TAG_structure_type ] [timeval] [line 47, size 128, align 64, offset 0] [from ]
!522 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/_timeval.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!523 = metadata !{metadata !524, metadata !527}
!524 = metadata !{i32 786445, metadata !522, metadata !521, metadata !"tv_sec", i32 48, i64 64, i64 64, i64 0, i32 0, metadata !525} ; [ DW_TAG_member ] [tv_sec] [line 48, size 64, align 64, offset 0] [from time_t]
!525 = metadata !{i32 786454, metadata !522, null, metadata !"time_t", i32 211, i64 0, i64 0, i64 0, i32 0, metadata !526} ; [ DW_TAG_typedef ] [time_t] [line 211, size 0, align 0, offset 0] [from __time_t]
!526 = metadata !{i32 786454, metadata !522, null, metadata !"__time_t", i32 106, i64 0, i64 0, i64 0, i32 0, metadata !281} ; [ DW_TAG_typedef ] [__time_t] [line 106, size 0, align 0, offset 0] [from __int64_t]
!527 = metadata !{i32 786445, metadata !522, metadata !521, metadata !"tv_usec", i32 49, i64 64, i64 64, i64 64, i32 0, metadata !528} ; [ DW_TAG_member ] [tv_usec] [line 49, size 64, align 64, offset 64] [from suseconds_t]
!528 = metadata !{i32 786454, metadata !522, null, metadata !"suseconds_t", i32 206, i64 0, i64 0, i64 0, i32 0, metadata !529} ; [ DW_TAG_typedef ] [suseconds_t] [line 206, size 0, align 0, offset 0] [from __suseconds_t]
!529 = metadata !{i32 786454, metadata !522, null, metadata !"__suseconds_t", i32 61, i64 0, i64 0, i64 0, i32 0, metadata !87} ; [ DW_TAG_typedef ] [__suseconds_t] [line 61, size 0, align 0, offset 0] [from long int]
!530 = metadata !{i32 786445, metadata !518, metadata !517, metadata !"ru_stime", i32 63, i64 128, i64 64, i64 128, i32 0, metadata !521} ; [ DW_TAG_member ] [ru_stime] [line 63, size 128, align 64, offset 128] [from timeval]
!531 = metadata !{i32 786445, metadata !518, metadata !517, metadata !"ru_maxrss", i32 64, i64 64, i64 64, i64 256, i32 0, metadata !87} ; [ DW_TAG_member ] [ru_maxrss] [line 64, size 64, align 64, offset 256] [from long int]
!532 = metadata !{i32 786445, metadata !518, metadata !517, metadata !"ru_ixrss", i32 66, i64 64, i64 64, i64 320, i32 0, metadata !87} ; [ DW_TAG_member ] [ru_ixrss] [line 66, size 64, align 64, offset 320] [from long int]
!533 = metadata !{i32 786445, metadata !518, metadata !517, metadata !"ru_idrss", i32 67, i64 64, i64 64, i64 384, i32 0, metadata !87} ; [ DW_TAG_member ] [ru_idrss] [line 67, size 64, align 64, offset 384] [from long int]
!534 = metadata !{i32 786445, metadata !518, metadata !517, metadata !"ru_isrss", i32 68, i64 64, i64 64, i64 448, i32 0, metadata !87} ; [ DW_TAG_member ] [ru_isrss] [line 68, size 64, align 64, offset 448] [from long int]
!535 = metadata !{i32 786445, metadata !518, metadata !517, metadata !"ru_minflt", i32 69, i64 64, i64 64, i64 512, i32 0, metadata !87} ; [ DW_TAG_member ] [ru_minflt] [line 69, size 64, align 64, offset 512] [from long int]
!536 = metadata !{i32 786445, metadata !518, metadata !517, metadata !"ru_majflt", i32 70, i64 64, i64 64, i64 576, i32 0, metadata !87} ; [ DW_TAG_member ] [ru_majflt] [line 70, size 64, align 64, offset 576] [from long int]
!537 = metadata !{i32 786445, metadata !518, metadata !517, metadata !"ru_nswap", i32 71, i64 64, i64 64, i64 640, i32 0, metadata !87} ; [ DW_TAG_member ] [ru_nswap] [line 71, size 64, align 64, offset 640] [from long int]
!538 = metadata !{i32 786445, metadata !518, metadata !517, metadata !"ru_inblock", i32 72, i64 64, i64 64, i64 704, i32 0, metadata !87} ; [ DW_TAG_member ] [ru_inblock] [line 72, size 64, align 64, offset 704] [from long int]
!539 = metadata !{i32 786445, metadata !518, metadata !517, metadata !"ru_oublock", i32 73, i64 64, i64 64, i64 768, i32 0, metadata !87} ; [ DW_TAG_member ] [ru_oublock] [line 73, size 64, align 64, offset 768] [from long int]
!540 = metadata !{i32 786445, metadata !518, metadata !517, metadata !"ru_msgsnd", i32 74, i64 64, i64 64, i64 832, i32 0, metadata !87} ; [ DW_TAG_member ] [ru_msgsnd] [line 74, size 64, align 64, offset 832] [from long int]
!541 = metadata !{i32 786445, metadata !518, metadata !517, metadata !"ru_msgrcv", i32 75, i64 64, i64 64, i64 896, i32 0, metadata !87} ; [ DW_TAG_member ] [ru_msgrcv] [line 75, size 64, align 64, offset 896] [from long int]
!542 = metadata !{i32 786445, metadata !518, metadata !517, metadata !"ru_nsignals", i32 76, i64 64, i64 64, i64 960, i32 0, metadata !87} ; [ DW_TAG_member ] [ru_nsignals] [line 76, size 64, align 64, offset 960] [from long int]
!543 = metadata !{i32 786445, metadata !518, metadata !517, metadata !"ru_nvcsw", i32 77, i64 64, i64 64, i64 1024, i32 0, metadata !87} ; [ DW_TAG_member ] [ru_nvcsw] [line 77, size 64, align 64, offset 1024] [from long int]
!544 = metadata !{i32 786445, metadata !518, metadata !517, metadata !"ru_nivcsw", i32 78, i64 64, i64 64, i64 1088, i32 0, metadata !87} ; [ DW_TAG_member ] [ru_nivcsw] [line 78, size 64, align 64, offset 1088] [from long int]
!545 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_rux", i32 254, i64 448, i64 64, i64 3904, i32 0, metadata !546} ; [ DW_TAG_member ] [td_rux] [line 254, size 448, align 64, offset 3904] [from rusage_ext]
!546 = metadata !{i32 786451, metadata !4, null, metadata !"rusage_ext", i32 190, i64 448, i64 64, i32 0, i32 0, null, metadata !547, i32 0, null, null} ; [ DW_TAG_structure_type ] [rusage_ext] [line 190, size 448, align 64, offset 0] [from ]
!547 = metadata !{metadata !548, metadata !550, metadata !551, metadata !552, metadata !553, metadata !554, metadata !555}
!548 = metadata !{i32 786445, metadata !4, metadata !546, metadata !"rux_runtime", i32 191, i64 64, i64 64, i64 0, i32 0, metadata !549} ; [ DW_TAG_member ] [rux_runtime] [line 191, size 64, align 64, offset 0] [from uint64_t]
!549 = metadata !{i32 786454, metadata !4, null, metadata !"uint64_t", i32 69, i64 0, i64 0, i64 0, i32 0, metadata !46} ; [ DW_TAG_typedef ] [uint64_t] [line 69, size 0, align 0, offset 0] [from __uint64_t]
!550 = metadata !{i32 786445, metadata !4, metadata !546, metadata !"rux_uticks", i32 192, i64 64, i64 64, i64 64, i32 0, metadata !549} ; [ DW_TAG_member ] [rux_uticks] [line 192, size 64, align 64, offset 64] [from uint64_t]
!551 = metadata !{i32 786445, metadata !4, metadata !546, metadata !"rux_sticks", i32 193, i64 64, i64 64, i64 128, i32 0, metadata !549} ; [ DW_TAG_member ] [rux_sticks] [line 193, size 64, align 64, offset 128] [from uint64_t]
!552 = metadata !{i32 786445, metadata !4, metadata !546, metadata !"rux_iticks", i32 194, i64 64, i64 64, i64 192, i32 0, metadata !549} ; [ DW_TAG_member ] [rux_iticks] [line 194, size 64, align 64, offset 192] [from uint64_t]
!553 = metadata !{i32 786445, metadata !4, metadata !546, metadata !"rux_uu", i32 195, i64 64, i64 64, i64 256, i32 0, metadata !549} ; [ DW_TAG_member ] [rux_uu] [line 195, size 64, align 64, offset 256] [from uint64_t]
!554 = metadata !{i32 786445, metadata !4, metadata !546, metadata !"rux_su", i32 196, i64 64, i64 64, i64 320, i32 0, metadata !549} ; [ DW_TAG_member ] [rux_su] [line 196, size 64, align 64, offset 320] [from uint64_t]
!555 = metadata !{i32 786445, metadata !4, metadata !546, metadata !"rux_tu", i32 197, i64 64, i64 64, i64 384, i32 0, metadata !549} ; [ DW_TAG_member ] [rux_tu] [line 197, size 64, align 64, offset 384] [from uint64_t]
!556 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_incruntime", i32 255, i64 64, i64 64, i64 4352, i32 0, metadata !549} ; [ DW_TAG_member ] [td_incruntime] [line 255, size 64, align 64, offset 4352] [from uint64_t]
!557 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_runtime", i32 256, i64 64, i64 64, i64 4416, i32 0, metadata !549} ; [ DW_TAG_member ] [td_runtime] [line 256, size 64, align 64, offset 4416] [from uint64_t]
!558 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_pticks", i32 257, i64 32, i64 32, i64 4480, i32 0, metadata !36} ; [ DW_TAG_member ] [td_pticks] [line 257, size 32, align 32, offset 4480] [from u_int]
!559 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_sticks", i32 258, i64 32, i64 32, i64 4512, i32 0, metadata !36} ; [ DW_TAG_member ] [td_sticks] [line 258, size 32, align 32, offset 4512] [from u_int]
!560 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_iticks", i32 259, i64 32, i64 32, i64 4544, i32 0, metadata !36} ; [ DW_TAG_member ] [td_iticks] [line 259, size 32, align 32, offset 4544] [from u_int]
!561 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_uticks", i32 260, i64 32, i64 32, i64 4576, i32 0, metadata !36} ; [ DW_TAG_member ] [td_uticks] [line 260, size 32, align 32, offset 4576] [from u_int]
!562 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_intrval", i32 261, i64 32, i64 32, i64 4608, i32 0, metadata !93} ; [ DW_TAG_member ] [td_intrval] [line 261, size 32, align 32, offset 4608] [from int]
!563 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_oldsigmask", i32 262, i64 128, i64 32, i64 4640, i32 0, metadata !139} ; [ DW_TAG_member ] [td_oldsigmask] [line 262, size 128, align 32, offset 4640] [from sigset_t]
!564 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_generation", i32 263, i64 32, i64 32, i64 4768, i32 0, metadata !91} ; [ DW_TAG_member ] [td_generation] [line 263, size 32, align 32, offset 4768] [from ]
!565 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_sigstk", i32 264, i64 192, i64 64, i64 4800, i32 0, metadata !566} ; [ DW_TAG_member ] [td_sigstk] [line 264, size 192, align 64, offset 4800] [from stack_t]
!566 = metadata !{i32 786454, metadata !4, null, metadata !"stack_t", i32 368, i64 0, i64 0, i64 0, i32 0, metadata !567} ; [ DW_TAG_typedef ] [stack_t] [line 368, size 0, align 0, offset 0] [from sigaltstack]
!567 = metadata !{i32 786451, metadata !167, null, metadata !"sigaltstack", i32 361, i64 192, i64 64, i32 0, i32 0, null, metadata !568, i32 0, null, null} ; [ DW_TAG_structure_type ] [sigaltstack] [line 361, size 192, align 64, offset 0] [from ]
!568 = metadata !{metadata !569, metadata !571, metadata !574}
!569 = metadata !{i32 786445, metadata !167, metadata !567, metadata !"ss_sp", i32 365, i64 64, i64 64, i64 0, i32 0, metadata !570} ; [ DW_TAG_member ] [ss_sp] [line 365, size 64, align 64, offset 0] [from ]
!570 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !34} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from char]
!571 = metadata !{i32 786445, metadata !167, metadata !567, metadata !"ss_size", i32 366, i64 64, i64 64, i64 64, i32 0, metadata !572} ; [ DW_TAG_member ] [ss_size] [line 366, size 64, align 64, offset 64] [from __size_t]
!572 = metadata !{i32 786454, metadata !573, null, metadata !"__size_t", i32 104, i64 0, i64 0, i64 0, i32 0, metadata !46} ; [ DW_TAG_typedef ] [__size_t] [line 104, size 0, align 0, offset 0] [from __uint64_t]
!573 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/_iovec.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!574 = metadata !{i32 786445, metadata !167, metadata !567, metadata !"ss_flags", i32 367, i64 32, i64 32, i64 128, i32 0, metadata !93} ; [ DW_TAG_member ] [ss_flags] [line 367, size 32, align 32, offset 128] [from int]
!575 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_xsig", i32 265, i64 32, i64 32, i64 4992, i32 0, metadata !93} ; [ DW_TAG_member ] [td_xsig] [line 265, size 32, align 32, offset 4992] [from int]
!576 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_profil_addr", i32 266, i64 64, i64 64, i64 5056, i32 0, metadata !577} ; [ DW_TAG_member ] [td_profil_addr] [line 266, size 64, align 64, offset 5056] [from u_long]
!577 = metadata !{i32 786454, metadata !269, null, metadata !"u_long", i32 53, i64 0, i64 0, i64 0, i32 0, metadata !47} ; [ DW_TAG_typedef ] [u_long] [line 53, size 0, align 0, offset 0] [from long unsigned int]
!578 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_profil_ticks", i32 267, i64 32, i64 32, i64 5120, i32 0, metadata !36} ; [ DW_TAG_member ] [td_profil_ticks] [line 267, size 32, align 32, offset 5120] [from u_int]
!579 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_name", i32 268, i64 160, i64 8, i64 5152, i32 0, metadata !580} ; [ DW_TAG_member ] [td_name] [line 268, size 160, align 8, offset 5152] [from ]
!580 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 160, i64 8, i32 0, i32 0, metadata !34, metadata !581, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 160, align 8, offset 0] [from char]
!581 = metadata !{metadata !582}
!582 = metadata !{i32 786465, i64 0, i64 20}      ; [ DW_TAG_subrange_type ] [0, 19]
!583 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_fpop", i32 269, i64 64, i64 64, i64 5312, i32 0, metadata !584} ; [ DW_TAG_member ] [td_fpop] [line 269, size 64, align 64, offset 5312] [from ]
!584 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !585} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from file]
!585 = metadata !{i32 786451, metadata !586, null, metadata !"file", i32 148, i64 640, i64 64, i32 0, i32 0, null, metadata !587, i32 0, null, null} ; [ DW_TAG_structure_type ] [file] [line 148, size 640, align 64, offset 0] [from ]
!586 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/file.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!587 = metadata !{metadata !588, metadata !589, metadata !762, metadata !763, metadata !764, metadata !765, metadata !766, metadata !767, metadata !768, metadata !769, metadata !770, metadata !785, metadata !786}
!588 = metadata !{i32 786445, metadata !586, metadata !585, metadata !"f_data", i32 149, i64 64, i64 64, i64 0, i32 0, metadata !178} ; [ DW_TAG_member ] [f_data] [line 149, size 64, align 64, offset 0] [from ]
!589 = metadata !{i32 786445, metadata !586, metadata !585, metadata !"f_ops", i32 150, i64 64, i64 64, i64 64, i32 0, metadata !590} ; [ DW_TAG_member ] [f_ops] [line 150, size 64, align 64, offset 64] [from ]
!590 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !591} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from fileops]
!591 = metadata !{i32 786451, metadata !586, null, metadata !"fileops", i32 110, i64 704, i64 64, i32 0, i32 0, null, metadata !592, i32 0, null, null} ; [ DW_TAG_structure_type ] [fileops] [line 110, size 704, align 64, offset 0] [from ]
!592 = metadata !{metadata !593, metadata !628, metadata !629, metadata !634, metadata !639, metadata !644, metadata !735, metadata !743, metadata !748, metadata !755, metadata !760}
!593 = metadata !{i32 786445, metadata !586, metadata !591, metadata !"fo_read", i32 111, i64 64, i64 64, i64 0, i32 0, metadata !594} ; [ DW_TAG_member ] [fo_read] [line 111, size 64, align 64, offset 0] [from ]
!594 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !595} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from fo_rdwr_t]
!595 = metadata !{i32 786454, metadata !586, null, metadata !"fo_rdwr_t", i32 91, i64 0, i64 0, i64 0, i32 0, metadata !596} ; [ DW_TAG_typedef ] [fo_rdwr_t] [line 91, size 0, align 0, offset 0] [from ]
!596 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !597, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!597 = metadata !{metadata !93, metadata !584, metadata !598, metadata !253, metadata !93, metadata !18}
!598 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !599} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from uio]
!599 = metadata !{i32 786451, metadata !600, null, metadata !"uio", i32 63, i64 384, i64 64, i32 0, i32 0, null, metadata !601, i32 0, null, null} ; [ DW_TAG_structure_type ] [uio] [line 63, size 384, align 64, offset 0] [from ]
!600 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/uio.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!601 = metadata !{metadata !602, metadata !609, metadata !610, metadata !613, metadata !616, metadata !622, metadata !627}
!602 = metadata !{i32 786445, metadata !600, metadata !599, metadata !"uio_iov", i32 64, i64 64, i64 64, i64 0, i32 0, metadata !603} ; [ DW_TAG_member ] [uio_iov] [line 64, size 64, align 64, offset 0] [from ]
!603 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !604} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from iovec]
!604 = metadata !{i32 786451, metadata !573, null, metadata !"iovec", i32 43, i64 128, i64 64, i32 0, i32 0, null, metadata !605, i32 0, null, null} ; [ DW_TAG_structure_type ] [iovec] [line 43, size 128, align 64, offset 0] [from ]
!605 = metadata !{metadata !606, metadata !607}
!606 = metadata !{i32 786445, metadata !573, metadata !604, metadata !"iov_base", i32 44, i64 64, i64 64, i64 0, i32 0, metadata !178} ; [ DW_TAG_member ] [iov_base] [line 44, size 64, align 64, offset 0] [from ]
!607 = metadata !{i32 786445, metadata !573, metadata !604, metadata !"iov_len", i32 45, i64 64, i64 64, i64 64, i32 0, metadata !608} ; [ DW_TAG_member ] [iov_len] [line 45, size 64, align 64, offset 64] [from size_t]
!608 = metadata !{i32 786454, metadata !573, null, metadata !"size_t", i32 196, i64 0, i64 0, i64 0, i32 0, metadata !572} ; [ DW_TAG_typedef ] [size_t] [line 196, size 0, align 0, offset 0] [from __size_t]
!609 = metadata !{i32 786445, metadata !600, metadata !599, metadata !"uio_iovcnt", i32 65, i64 32, i64 32, i64 64, i32 0, metadata !93} ; [ DW_TAG_member ] [uio_iovcnt] [line 65, size 32, align 32, offset 64] [from int]
!610 = metadata !{i32 786445, metadata !600, metadata !599, metadata !"uio_offset", i32 66, i64 64, i64 64, i64 128, i32 0, metadata !611} ; [ DW_TAG_member ] [uio_offset] [line 66, size 64, align 64, offset 128] [from off_t]
!611 = metadata !{i32 786454, metadata !600, null, metadata !"off_t", i32 175, i64 0, i64 0, i64 0, i32 0, metadata !612} ; [ DW_TAG_typedef ] [off_t] [line 175, size 0, align 0, offset 0] [from __off_t]
!612 = metadata !{i32 786454, metadata !600, null, metadata !"__off_t", i32 54, i64 0, i64 0, i64 0, i32 0, metadata !281} ; [ DW_TAG_typedef ] [__off_t] [line 54, size 0, align 0, offset 0] [from __int64_t]
!613 = metadata !{i32 786445, metadata !600, metadata !599, metadata !"uio_resid", i32 67, i64 64, i64 64, i64 192, i32 0, metadata !614} ; [ DW_TAG_member ] [uio_resid] [line 67, size 64, align 64, offset 192] [from ssize_t]
!614 = metadata !{i32 786454, metadata !600, null, metadata !"ssize_t", i32 201, i64 0, i64 0, i64 0, i32 0, metadata !615} ; [ DW_TAG_typedef ] [ssize_t] [line 201, size 0, align 0, offset 0] [from __ssize_t]
!615 = metadata !{i32 786454, metadata !600, null, metadata !"__ssize_t", i32 105, i64 0, i64 0, i64 0, i32 0, metadata !281} ; [ DW_TAG_typedef ] [__ssize_t] [line 105, size 0, align 0, offset 0] [from __int64_t]
!616 = metadata !{i32 786445, metadata !600, metadata !599, metadata !"uio_segflg", i32 68, i64 32, i64 32, i64 256, i32 0, metadata !617} ; [ DW_TAG_member ] [uio_segflg] [line 68, size 32, align 32, offset 256] [from uio_seg]
!617 = metadata !{i32 786436, metadata !600, null, metadata !"uio_seg", i32 54, i64 32, i64 32, i32 0, i32 0, null, metadata !618, i32 0, i32 0} ; [ DW_TAG_enumeration_type ] [uio_seg] [line 54, size 32, align 32, offset 0] [from ]
!618 = metadata !{metadata !619, metadata !620, metadata !621}
!619 = metadata !{i32 786472, metadata !"UIO_USERSPACE", i64 0} ; [ DW_TAG_enumerator ] [UIO_USERSPACE :: 0]
!620 = metadata !{i32 786472, metadata !"UIO_SYSSPACE", i64 1} ; [ DW_TAG_enumerator ] [UIO_SYSSPACE :: 1]
!621 = metadata !{i32 786472, metadata !"UIO_NOCOPY", i64 2} ; [ DW_TAG_enumerator ] [UIO_NOCOPY :: 2]
!622 = metadata !{i32 786445, metadata !600, metadata !599, metadata !"uio_rw", i32 69, i64 32, i64 32, i64 288, i32 0, metadata !623} ; [ DW_TAG_member ] [uio_rw] [line 69, size 32, align 32, offset 288] [from uio_rw]
!623 = metadata !{i32 786436, metadata !600, null, metadata !"uio_rw", i32 51, i64 32, i64 32, i32 0, i32 0, null, metadata !624, i32 0, i32 0} ; [ DW_TAG_enumeration_type ] [uio_rw] [line 51, size 32, align 32, offset 0] [from ]
!624 = metadata !{metadata !625, metadata !626}
!625 = metadata !{i32 786472, metadata !"UIO_READ", i64 0} ; [ DW_TAG_enumerator ] [UIO_READ :: 0]
!626 = metadata !{i32 786472, metadata !"UIO_WRITE", i64 1} ; [ DW_TAG_enumerator ] [UIO_WRITE :: 1]
!627 = metadata !{i32 786445, metadata !600, metadata !599, metadata !"uio_td", i32 70, i64 64, i64 64, i64 320, i32 0, metadata !18} ; [ DW_TAG_member ] [uio_td] [line 70, size 64, align 64, offset 320] [from ]
!628 = metadata !{i32 786445, metadata !586, metadata !591, metadata !"fo_write", i32 112, i64 64, i64 64, i64 64, i32 0, metadata !594} ; [ DW_TAG_member ] [fo_write] [line 112, size 64, align 64, offset 64] [from ]
!629 = metadata !{i32 786445, metadata !586, metadata !591, metadata !"fo_truncate", i32 113, i64 64, i64 64, i64 128, i32 0, metadata !630} ; [ DW_TAG_member ] [fo_truncate] [line 113, size 64, align 64, offset 128] [from ]
!630 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !631} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from fo_truncate_t]
!631 = metadata !{i32 786454, metadata !586, null, metadata !"fo_truncate_t", i32 94, i64 0, i64 0, i64 0, i32 0, metadata !632} ; [ DW_TAG_typedef ] [fo_truncate_t] [line 94, size 0, align 0, offset 0] [from ]
!632 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !633, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!633 = metadata !{metadata !93, metadata !584, metadata !611, metadata !253, metadata !18}
!634 = metadata !{i32 786445, metadata !586, metadata !591, metadata !"fo_ioctl", i32 114, i64 64, i64 64, i64 192, i32 0, metadata !635} ; [ DW_TAG_member ] [fo_ioctl] [line 114, size 64, align 64, offset 192] [from ]
!635 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !636} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from fo_ioctl_t]
!636 = metadata !{i32 786454, metadata !586, null, metadata !"fo_ioctl_t", i32 96, i64 0, i64 0, i64 0, i32 0, metadata !637} ; [ DW_TAG_typedef ] [fo_ioctl_t] [line 96, size 0, align 0, offset 0] [from ]
!637 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !638, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!638 = metadata !{metadata !93, metadata !584, metadata !577, metadata !178, metadata !253, metadata !18}
!639 = metadata !{i32 786445, metadata !586, metadata !591, metadata !"fo_poll", i32 115, i64 64, i64 64, i64 256, i32 0, metadata !640} ; [ DW_TAG_member ] [fo_poll] [line 115, size 64, align 64, offset 256] [from ]
!640 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !641} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from fo_poll_t]
!641 = metadata !{i32 786454, metadata !586, null, metadata !"fo_poll_t", i32 98, i64 0, i64 0, i64 0, i32 0, metadata !642} ; [ DW_TAG_typedef ] [fo_poll_t] [line 98, size 0, align 0, offset 0] [from ]
!642 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !643, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!643 = metadata !{metadata !93, metadata !584, metadata !93, metadata !253, metadata !18}
!644 = metadata !{i32 786445, metadata !586, metadata !591, metadata !"fo_kqfilter", i32 116, i64 64, i64 64, i64 320, i32 0, metadata !645} ; [ DW_TAG_member ] [fo_kqfilter] [line 116, size 64, align 64, offset 320] [from ]
!645 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !646} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from fo_kqfilter_t]
!646 = metadata !{i32 786454, metadata !586, null, metadata !"fo_kqfilter_t", i32 100, i64 0, i64 0, i64 0, i32 0, metadata !647} ; [ DW_TAG_typedef ] [fo_kqfilter_t] [line 100, size 0, align 0, offset 0] [from ]
!647 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !648, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!648 = metadata !{metadata !93, metadata !584, metadata !649}
!649 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !650} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from knote]
!650 = metadata !{i32 786451, metadata !651, null, metadata !"knote", i32 192, i64 1024, i64 64, i32 0, i32 0, null, metadata !652, i32 0, null, null} ; [ DW_TAG_structure_type ] [knote] [line 192, size 1024, align 64, offset 0] [from ]
!651 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/event.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!652 = metadata !{metadata !653, metadata !657, metadata !661, metadata !677, metadata !683, metadata !686, metadata !697, metadata !698, metadata !699, metadata !700, metadata !711, metadata !733, metadata !734}
!653 = metadata !{i32 786445, metadata !651, metadata !650, metadata !"kn_link", i32 193, i64 64, i64 64, i64 0, i32 0, metadata !654} ; [ DW_TAG_member ] [kn_link] [line 193, size 64, align 64, offset 0] [from ]
!654 = metadata !{i32 786451, metadata !651, metadata !650, metadata !"", i32 193, i64 64, i64 64, i32 0, i32 0, null, metadata !655, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 193, size 64, align 64, offset 0] [from ]
!655 = metadata !{metadata !656}
!656 = metadata !{i32 786445, metadata !651, metadata !654, metadata !"sle_next", i32 193, i64 64, i64 64, i64 0, i32 0, metadata !649} ; [ DW_TAG_member ] [sle_next] [line 193, size 64, align 64, offset 0] [from ]
!657 = metadata !{i32 786445, metadata !651, metadata !650, metadata !"kn_selnext", i32 194, i64 64, i64 64, i64 64, i32 0, metadata !658} ; [ DW_TAG_member ] [kn_selnext] [line 194, size 64, align 64, offset 64] [from ]
!658 = metadata !{i32 786451, metadata !651, metadata !650, metadata !"", i32 194, i64 64, i64 64, i32 0, i32 0, null, metadata !659, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 194, size 64, align 64, offset 0] [from ]
!659 = metadata !{metadata !660}
!660 = metadata !{i32 786445, metadata !651, metadata !658, metadata !"sle_next", i32 194, i64 64, i64 64, i64 0, i32 0, metadata !649} ; [ DW_TAG_member ] [sle_next] [line 194, size 64, align 64, offset 0] [from ]
!661 = metadata !{i32 786445, metadata !651, metadata !650, metadata !"kn_knlist", i32 195, i64 64, i64 64, i64 128, i32 0, metadata !662} ; [ DW_TAG_member ] [kn_knlist] [line 195, size 64, align 64, offset 128] [from ]
!662 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !663} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from knlist]
!663 = metadata !{i32 786451, metadata !651, null, metadata !"knlist", i32 138, i64 384, i64 64, i32 0, i32 0, null, metadata !664, i32 0, null, null} ; [ DW_TAG_structure_type ] [knlist] [line 138, size 384, align 64, offset 0] [from ]
!664 = metadata !{metadata !665, metadata !669, metadata !673, metadata !674, metadata !675, metadata !676}
!665 = metadata !{i32 786445, metadata !651, metadata !663, metadata !"kl_list", i32 139, i64 64, i64 64, i64 0, i32 0, metadata !666} ; [ DW_TAG_member ] [kl_list] [line 139, size 64, align 64, offset 0] [from klist]
!666 = metadata !{i32 786451, metadata !651, null, metadata !"klist", i32 135, i64 64, i64 64, i32 0, i32 0, null, metadata !667, i32 0, null, null} ; [ DW_TAG_structure_type ] [klist] [line 135, size 64, align 64, offset 0] [from ]
!667 = metadata !{metadata !668}
!668 = metadata !{i32 786445, metadata !651, metadata !666, metadata !"slh_first", i32 135, i64 64, i64 64, i64 0, i32 0, metadata !649} ; [ DW_TAG_member ] [slh_first] [line 135, size 64, align 64, offset 0] [from ]
!669 = metadata !{i32 786445, metadata !651, metadata !663, metadata !"kl_lock", i32 140, i64 64, i64 64, i64 64, i32 0, metadata !670} ; [ DW_TAG_member ] [kl_lock] [line 140, size 64, align 64, offset 64] [from ]
!670 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !671} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!671 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !672, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!672 = metadata !{null, metadata !178}
!673 = metadata !{i32 786445, metadata !651, metadata !663, metadata !"kl_unlock", i32 141, i64 64, i64 64, i64 128, i32 0, metadata !670} ; [ DW_TAG_member ] [kl_unlock] [line 141, size 64, align 64, offset 128] [from ]
!674 = metadata !{i32 786445, metadata !651, metadata !663, metadata !"kl_assert_locked", i32 142, i64 64, i64 64, i64 192, i32 0, metadata !670} ; [ DW_TAG_member ] [kl_assert_locked] [line 142, size 64, align 64, offset 192] [from ]
!675 = metadata !{i32 786445, metadata !651, metadata !663, metadata !"kl_assert_unlocked", i32 143, i64 64, i64 64, i64 256, i32 0, metadata !670} ; [ DW_TAG_member ] [kl_assert_unlocked] [line 143, size 64, align 64, offset 256] [from ]
!676 = metadata !{i32 786445, metadata !651, metadata !663, metadata !"kl_lockarg", i32 144, i64 64, i64 64, i64 320, i32 0, metadata !178} ; [ DW_TAG_member ] [kl_lockarg] [line 144, size 64, align 64, offset 320] [from ]
!677 = metadata !{i32 786445, metadata !651, metadata !650, metadata !"kn_tqe", i32 196, i64 128, i64 64, i64 192, i32 0, metadata !678} ; [ DW_TAG_member ] [kn_tqe] [line 196, size 128, align 64, offset 192] [from ]
!678 = metadata !{i32 786451, metadata !651, metadata !650, metadata !"", i32 196, i64 128, i64 64, i32 0, i32 0, null, metadata !679, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 196, size 128, align 64, offset 0] [from ]
!679 = metadata !{metadata !680, metadata !681}
!680 = metadata !{i32 786445, metadata !651, metadata !678, metadata !"tqe_next", i32 196, i64 64, i64 64, i64 0, i32 0, metadata !649} ; [ DW_TAG_member ] [tqe_next] [line 196, size 64, align 64, offset 0] [from ]
!681 = metadata !{i32 786445, metadata !651, metadata !678, metadata !"tqe_prev", i32 196, i64 64, i64 64, i64 64, i32 0, metadata !682} ; [ DW_TAG_member ] [tqe_prev] [line 196, size 64, align 64, offset 64] [from ]
!682 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !649} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!683 = metadata !{i32 786445, metadata !651, metadata !650, metadata !"kn_kq", i32 197, i64 64, i64 64, i64 320, i32 0, metadata !684} ; [ DW_TAG_member ] [kn_kq] [line 197, size 64, align 64, offset 320] [from ]
!684 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !685} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from kqueue]
!685 = metadata !{i32 786451, metadata !651, null, metadata !"kqueue", i32 136, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [kqueue] [line 136, size 0, align 0, offset 0] [fwd] [from ]
!686 = metadata !{i32 786445, metadata !651, metadata !650, metadata !"kn_kevent", i32 198, i64 256, i64 64, i64 384, i32 0, metadata !687} ; [ DW_TAG_member ] [kn_kevent] [line 198, size 256, align 64, offset 384] [from kevent]
!687 = metadata !{i32 786451, metadata !651, null, metadata !"kevent", i32 57, i64 256, i64 64, i32 0, i32 0, null, metadata !688, i32 0, null, null} ; [ DW_TAG_structure_type ] [kevent] [line 57, size 256, align 64, offset 0] [from ]
!688 = metadata !{metadata !689, metadata !690, metadata !691, metadata !692, metadata !693, metadata !696}
!689 = metadata !{i32 786445, metadata !651, metadata !687, metadata !"ident", i32 58, i64 64, i64 64, i64 0, i32 0, metadata !44} ; [ DW_TAG_member ] [ident] [line 58, size 64, align 64, offset 0] [from uintptr_t]
!690 = metadata !{i32 786445, metadata !651, metadata !687, metadata !"filter", i32 59, i64 16, i64 16, i64 64, i32 0, metadata !236} ; [ DW_TAG_member ] [filter] [line 59, size 16, align 16, offset 64] [from short]
!691 = metadata !{i32 786445, metadata !651, metadata !687, metadata !"flags", i32 60, i64 16, i64 16, i64 80, i32 0, metadata !340} ; [ DW_TAG_member ] [flags] [line 60, size 16, align 16, offset 80] [from u_short]
!692 = metadata !{i32 786445, metadata !651, metadata !687, metadata !"fflags", i32 61, i64 32, i64 32, i64 96, i32 0, metadata !36} ; [ DW_TAG_member ] [fflags] [line 61, size 32, align 32, offset 96] [from u_int]
!693 = metadata !{i32 786445, metadata !651, metadata !687, metadata !"data", i32 62, i64 64, i64 64, i64 128, i32 0, metadata !694} ; [ DW_TAG_member ] [data] [line 62, size 64, align 64, offset 128] [from intptr_t]
!694 = metadata !{i32 786454, metadata !651, null, metadata !"intptr_t", i32 74, i64 0, i64 0, i64 0, i32 0, metadata !695} ; [ DW_TAG_typedef ] [intptr_t] [line 74, size 0, align 0, offset 0] [from __intptr_t]
!695 = metadata !{i32 786454, metadata !651, null, metadata !"__intptr_t", i32 82, i64 0, i64 0, i64 0, i32 0, metadata !281} ; [ DW_TAG_typedef ] [__intptr_t] [line 82, size 0, align 0, offset 0] [from __int64_t]
!696 = metadata !{i32 786445, metadata !651, metadata !687, metadata !"udata", i32 63, i64 64, i64 64, i64 192, i32 0, metadata !178} ; [ DW_TAG_member ] [udata] [line 63, size 64, align 64, offset 192] [from ]
!697 = metadata !{i32 786445, metadata !651, metadata !650, metadata !"kn_status", i32 199, i64 32, i64 32, i64 640, i32 0, metadata !93} ; [ DW_TAG_member ] [kn_status] [line 199, size 32, align 32, offset 640] [from int]
!698 = metadata !{i32 786445, metadata !651, metadata !650, metadata !"kn_sfflags", i32 208, i64 32, i64 32, i64 672, i32 0, metadata !93} ; [ DW_TAG_member ] [kn_sfflags] [line 208, size 32, align 32, offset 672] [from int]
!699 = metadata !{i32 786445, metadata !651, metadata !650, metadata !"kn_sdata", i32 209, i64 64, i64 64, i64 704, i32 0, metadata !694} ; [ DW_TAG_member ] [kn_sdata] [line 209, size 64, align 64, offset 704] [from intptr_t]
!700 = metadata !{i32 786445, metadata !651, metadata !650, metadata !"kn_ptr", i32 215, i64 64, i64 64, i64 768, i32 0, metadata !701} ; [ DW_TAG_member ] [kn_ptr] [line 215, size 64, align 64, offset 768] [from ]
!701 = metadata !{i32 786455, metadata !651, metadata !650, metadata !"", i32 210, i64 64, i64 64, i64 0, i32 0, null, metadata !702, i32 0, i32 0, null} ; [ DW_TAG_union_type ] [line 210, size 64, align 64, offset 0] [from ]
!702 = metadata !{metadata !703, metadata !704, metadata !705, metadata !708}
!703 = metadata !{i32 786445, metadata !651, metadata !701, metadata !"p_fp", i32 211, i64 64, i64 64, i64 0, i32 0, metadata !584} ; [ DW_TAG_member ] [p_fp] [line 211, size 64, align 64, offset 0] [from ]
!704 = metadata !{i32 786445, metadata !651, metadata !701, metadata !"p_proc", i32 212, i64 64, i64 64, i64 0, i32 0, metadata !11} ; [ DW_TAG_member ] [p_proc] [line 212, size 64, align 64, offset 0] [from ]
!705 = metadata !{i32 786445, metadata !651, metadata !701, metadata !"p_aio", i32 213, i64 64, i64 64, i64 0, i32 0, metadata !706} ; [ DW_TAG_member ] [p_aio] [line 213, size 64, align 64, offset 0] [from ]
!706 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !707} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from aiocblist]
!707 = metadata !{i32 786451, metadata !651, null, metadata !"aiocblist", i32 213, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [aiocblist] [line 213, size 0, align 0, offset 0] [fwd] [from ]
!708 = metadata !{i32 786445, metadata !651, metadata !701, metadata !"p_lio", i32 214, i64 64, i64 64, i64 0, i32 0, metadata !709} ; [ DW_TAG_member ] [p_lio] [line 214, size 64, align 64, offset 0] [from ]
!709 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !710} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from aioliojob]
!710 = metadata !{i32 786451, metadata !651, null, metadata !"aioliojob", i32 214, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [aioliojob] [line 214, size 0, align 0, offset 0] [fwd] [from ]
!711 = metadata !{i32 786445, metadata !651, metadata !650, metadata !"kn_fop", i32 216, i64 64, i64 64, i64 832, i32 0, metadata !712} ; [ DW_TAG_member ] [kn_fop] [line 216, size 64, align 64, offset 832] [from ]
!712 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !713} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from filterops]
!713 = metadata !{i32 786451, metadata !651, null, metadata !"filterops", i32 178, i64 320, i64 64, i32 0, i32 0, null, metadata !714, i32 0, null, null} ; [ DW_TAG_structure_type ] [filterops] [line 178, size 320, align 64, offset 0] [from ]
!714 = metadata !{metadata !715, metadata !716, metadata !720, metadata !724, metadata !728}
!715 = metadata !{i32 786445, metadata !651, metadata !713, metadata !"f_isfd", i32 179, i64 32, i64 32, i64 0, i32 0, metadata !93} ; [ DW_TAG_member ] [f_isfd] [line 179, size 32, align 32, offset 0] [from int]
!716 = metadata !{i32 786445, metadata !651, metadata !713, metadata !"f_attach", i32 180, i64 64, i64 64, i64 64, i32 0, metadata !717} ; [ DW_TAG_member ] [f_attach] [line 180, size 64, align 64, offset 64] [from ]
!717 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !718} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!718 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !719, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!719 = metadata !{metadata !93, metadata !649}
!720 = metadata !{i32 786445, metadata !651, metadata !713, metadata !"f_detach", i32 181, i64 64, i64 64, i64 128, i32 0, metadata !721} ; [ DW_TAG_member ] [f_detach] [line 181, size 64, align 64, offset 128] [from ]
!721 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !722} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!722 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !723, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!723 = metadata !{null, metadata !649}
!724 = metadata !{i32 786445, metadata !651, metadata !713, metadata !"f_event", i32 182, i64 64, i64 64, i64 192, i32 0, metadata !725} ; [ DW_TAG_member ] [f_event] [line 182, size 64, align 64, offset 192] [from ]
!725 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !726} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!726 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !727, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!727 = metadata !{metadata !93, metadata !649, metadata !87}
!728 = metadata !{i32 786445, metadata !651, metadata !713, metadata !"f_touch", i32 183, i64 64, i64 64, i64 256, i32 0, metadata !729} ; [ DW_TAG_member ] [f_touch] [line 183, size 64, align 64, offset 256] [from ]
!729 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !730} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!730 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !731, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!731 = metadata !{null, metadata !649, metadata !732, metadata !577}
!732 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !687} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from kevent]
!733 = metadata !{i32 786445, metadata !651, metadata !650, metadata !"kn_hook", i32 217, i64 64, i64 64, i64 896, i32 0, metadata !178} ; [ DW_TAG_member ] [kn_hook] [line 217, size 64, align 64, offset 896] [from ]
!734 = metadata !{i32 786445, metadata !651, metadata !650, metadata !"kn_hookid", i32 218, i64 32, i64 32, i64 960, i32 0, metadata !93} ; [ DW_TAG_member ] [kn_hookid] [line 218, size 32, align 32, offset 960] [from int]
!735 = metadata !{i32 786445, metadata !586, metadata !591, metadata !"fo_stat", i32 117, i64 64, i64 64, i64 384, i32 0, metadata !736} ; [ DW_TAG_member ] [fo_stat] [line 117, size 64, align 64, offset 384] [from ]
!736 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !737} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from fo_stat_t]
!737 = metadata !{i32 786454, metadata !586, null, metadata !"fo_stat_t", i32 101, i64 0, i64 0, i64 0, i32 0, metadata !738} ; [ DW_TAG_typedef ] [fo_stat_t] [line 101, size 0, align 0, offset 0] [from ]
!738 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !739, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!739 = metadata !{metadata !93, metadata !584, metadata !740, metadata !253, metadata !18}
!740 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !741} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from stat]
!741 = metadata !{i32 786451, metadata !742, null, metadata !"stat", i32 565, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [stat] [line 565, size 0, align 0, offset 0] [fwd] [from ]
!742 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/sysproto.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!743 = metadata !{i32 786445, metadata !586, metadata !591, metadata !"fo_close", i32 118, i64 64, i64 64, i64 448, i32 0, metadata !744} ; [ DW_TAG_member ] [fo_close] [line 118, size 64, align 64, offset 448] [from ]
!744 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !745} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from fo_close_t]
!745 = metadata !{i32 786454, metadata !586, null, metadata !"fo_close_t", i32 103, i64 0, i64 0, i64 0, i32 0, metadata !746} ; [ DW_TAG_typedef ] [fo_close_t] [line 103, size 0, align 0, offset 0] [from ]
!746 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !747, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!747 = metadata !{metadata !93, metadata !584, metadata !18}
!748 = metadata !{i32 786445, metadata !586, metadata !591, metadata !"fo_chmod", i32 119, i64 64, i64 64, i64 512, i32 0, metadata !749} ; [ DW_TAG_member ] [fo_chmod] [line 119, size 64, align 64, offset 512] [from ]
!749 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !750} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from fo_chmod_t]
!750 = metadata !{i32 786454, metadata !586, null, metadata !"fo_chmod_t", i32 104, i64 0, i64 0, i64 0, i32 0, metadata !751} ; [ DW_TAG_typedef ] [fo_chmod_t] [line 104, size 0, align 0, offset 0] [from ]
!751 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !752, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!752 = metadata !{metadata !93, metadata !584, metadata !753, metadata !253, metadata !18}
!753 = metadata !{i32 786454, metadata !586, null, metadata !"mode_t", i32 160, i64 0, i64 0, i64 0, i32 0, metadata !754} ; [ DW_TAG_typedef ] [mode_t] [line 160, size 0, align 0, offset 0] [from __mode_t]
!754 = metadata !{i32 786454, metadata !586, null, metadata !"__mode_t", i32 50, i64 0, i64 0, i64 0, i32 0, metadata !409} ; [ DW_TAG_typedef ] [__mode_t] [line 50, size 0, align 0, offset 0] [from __uint16_t]
!755 = metadata !{i32 786445, metadata !586, metadata !591, metadata !"fo_chown", i32 120, i64 64, i64 64, i64 576, i32 0, metadata !756} ; [ DW_TAG_member ] [fo_chown] [line 120, size 64, align 64, offset 576] [from ]
!756 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !757} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from fo_chown_t]
!757 = metadata !{i32 786454, metadata !586, null, metadata !"fo_chown_t", i32 106, i64 0, i64 0, i64 0, i32 0, metadata !758} ; [ DW_TAG_typedef ] [fo_chown_t] [line 106, size 0, align 0, offset 0] [from ]
!758 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !759, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!759 = metadata !{metadata !93, metadata !584, metadata !258, metadata !263, metadata !253, metadata !18}
!760 = metadata !{i32 786445, metadata !586, metadata !591, metadata !"fo_flags", i32 121, i64 32, i64 32, i64 640, i32 0, metadata !761} ; [ DW_TAG_member ] [fo_flags] [line 121, size 32, align 32, offset 640] [from fo_flags_t]
!761 = metadata !{i32 786454, metadata !586, null, metadata !"fo_flags_t", i32 108, i64 0, i64 0, i64 0, i32 0, metadata !93} ; [ DW_TAG_typedef ] [fo_flags_t] [line 108, size 0, align 0, offset 0] [from int]
!762 = metadata !{i32 786445, metadata !586, metadata !585, metadata !"f_cred", i32 151, i64 64, i64 64, i64 128, i32 0, metadata !253} ; [ DW_TAG_member ] [f_cred] [line 151, size 64, align 64, offset 128] [from ]
!763 = metadata !{i32 786445, metadata !586, metadata !585, metadata !"f_vnode", i32 152, i64 64, i64 64, i64 192, i32 0, metadata !381} ; [ DW_TAG_member ] [f_vnode] [line 152, size 64, align 64, offset 192] [from ]
!764 = metadata !{i32 786445, metadata !586, metadata !585, metadata !"f_type", i32 153, i64 16, i64 16, i64 256, i32 0, metadata !236} ; [ DW_TAG_member ] [f_type] [line 153, size 16, align 16, offset 256] [from short]
!765 = metadata !{i32 786445, metadata !586, metadata !585, metadata !"f_vnread_flags", i32 154, i64 16, i64 16, i64 272, i32 0, metadata !236} ; [ DW_TAG_member ] [f_vnread_flags] [line 154, size 16, align 16, offset 272] [from short]
!766 = metadata !{i32 786445, metadata !586, metadata !585, metadata !"f_flag", i32 155, i64 32, i64 32, i64 288, i32 0, metadata !91} ; [ DW_TAG_member ] [f_flag] [line 155, size 32, align 32, offset 288] [from ]
!767 = metadata !{i32 786445, metadata !586, metadata !585, metadata !"f_count", i32 156, i64 32, i64 32, i64 320, i32 0, metadata !91} ; [ DW_TAG_member ] [f_count] [line 156, size 32, align 32, offset 320] [from ]
!768 = metadata !{i32 786445, metadata !586, metadata !585, metadata !"f_seqcount", i32 160, i64 32, i64 32, i64 352, i32 0, metadata !93} ; [ DW_TAG_member ] [f_seqcount] [line 160, size 32, align 32, offset 352] [from int]
!769 = metadata !{i32 786445, metadata !586, metadata !585, metadata !"f_nextoff", i32 161, i64 64, i64 64, i64 384, i32 0, metadata !611} ; [ DW_TAG_member ] [f_nextoff] [line 161, size 64, align 64, offset 384] [from off_t]
!770 = metadata !{i32 786445, metadata !586, metadata !585, metadata !"f_vnun", i32 166, i64 64, i64 64, i64 448, i32 0, metadata !771} ; [ DW_TAG_member ] [f_vnun] [line 166, size 64, align 64, offset 448] [from ]
!771 = metadata !{i32 786455, metadata !586, metadata !585, metadata !"", i32 162, i64 64, i64 64, i64 0, i32 0, null, metadata !772, i32 0, i32 0, null} ; [ DW_TAG_union_type ] [line 162, size 64, align 64, offset 0] [from ]
!772 = metadata !{metadata !773, metadata !776}
!773 = metadata !{i32 786445, metadata !586, metadata !771, metadata !"fvn_cdevpriv", i32 163, i64 64, i64 64, i64 0, i32 0, metadata !774} ; [ DW_TAG_member ] [fvn_cdevpriv] [line 163, size 64, align 64, offset 0] [from ]
!774 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !775} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from cdev_privdata]
!775 = metadata !{i32 786451, metadata !586, null, metadata !"cdev_privdata", i32 163, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [cdev_privdata] [line 163, size 0, align 0, offset 0] [fwd] [from ]
!776 = metadata !{i32 786445, metadata !586, metadata !771, metadata !"fvn_advice", i32 165, i64 64, i64 64, i64 0, i32 0, metadata !777} ; [ DW_TAG_member ] [fvn_advice] [line 165, size 64, align 64, offset 0] [from ]
!777 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !778} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from fadvise_info]
!778 = metadata !{i32 786451, metadata !586, null, metadata !"fadvise_info", i32 140, i64 320, i64 64, i32 0, i32 0, null, metadata !779, i32 0, null, null} ; [ DW_TAG_structure_type ] [fadvise_info] [line 140, size 320, align 64, offset 0] [from ]
!779 = metadata !{metadata !780, metadata !781, metadata !782, metadata !783, metadata !784}
!780 = metadata !{i32 786445, metadata !586, metadata !778, metadata !"fa_advice", i32 141, i64 32, i64 32, i64 0, i32 0, metadata !93} ; [ DW_TAG_member ] [fa_advice] [line 141, size 32, align 32, offset 0] [from int]
!781 = metadata !{i32 786445, metadata !586, metadata !778, metadata !"fa_start", i32 142, i64 64, i64 64, i64 64, i32 0, metadata !611} ; [ DW_TAG_member ] [fa_start] [line 142, size 64, align 64, offset 64] [from off_t]
!782 = metadata !{i32 786445, metadata !586, metadata !778, metadata !"fa_end", i32 143, i64 64, i64 64, i64 128, i32 0, metadata !611} ; [ DW_TAG_member ] [fa_end] [line 143, size 64, align 64, offset 128] [from off_t]
!783 = metadata !{i32 786445, metadata !586, metadata !778, metadata !"fa_prevstart", i32 144, i64 64, i64 64, i64 192, i32 0, metadata !611} ; [ DW_TAG_member ] [fa_prevstart] [line 144, size 64, align 64, offset 192] [from off_t]
!784 = metadata !{i32 786445, metadata !586, metadata !778, metadata !"fa_prevend", i32 145, i64 64, i64 64, i64 256, i32 0, metadata !611} ; [ DW_TAG_member ] [fa_prevend] [line 145, size 64, align 64, offset 256] [from off_t]
!785 = metadata !{i32 786445, metadata !586, metadata !585, metadata !"f_offset", i32 170, i64 64, i64 64, i64 512, i32 0, metadata !611} ; [ DW_TAG_member ] [f_offset] [line 170, size 64, align 64, offset 512] [from off_t]
!786 = metadata !{i32 786445, metadata !586, metadata !585, metadata !"f_label", i32 174, i64 64, i64 64, i64 576, i32 0, metadata !178} ; [ DW_TAG_member ] [f_label] [line 174, size 64, align 64, offset 576] [from ]
!787 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_dbgflags", i32 270, i64 32, i64 32, i64 5376, i32 0, metadata !93} ; [ DW_TAG_member ] [td_dbgflags] [line 270, size 32, align 32, offset 5376] [from int]
!788 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_dbgksi", i32 271, i64 896, i64 64, i64 5440, i32 0, metadata !156} ; [ DW_TAG_member ] [td_dbgksi] [line 271, size 896, align 64, offset 5440] [from ksiginfo]
!789 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_ng_outbound", i32 272, i64 32, i64 32, i64 6336, i32 0, metadata !93} ; [ DW_TAG_member ] [td_ng_outbound] [line 272, size 32, align 32, offset 6336] [from int]
!790 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_osd", i32 273, i64 256, i64 64, i64 6400, i32 0, metadata !350} ; [ DW_TAG_member ] [td_osd] [line 273, size 256, align 64, offset 6400] [from osd]
!791 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_map_def_user", i32 274, i64 64, i64 64, i64 6656, i32 0, metadata !792} ; [ DW_TAG_member ] [td_map_def_user] [line 274, size 64, align 64, offset 6656] [from ]
!792 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !793} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from vm_map_entry]
!793 = metadata !{i32 786451, metadata !4, null, metadata !"vm_map_entry", i32 274, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [vm_map_entry] [line 274, size 0, align 0, offset 0] [fwd] [from ]
!794 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_dbg_forked", i32 275, i64 32, i64 32, i64 6720, i32 0, metadata !504} ; [ DW_TAG_member ] [td_dbg_forked] [line 275, size 32, align 32, offset 6720] [from pid_t]
!795 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_vp_reserv", i32 276, i64 32, i64 32, i64 6752, i32 0, metadata !36} ; [ DW_TAG_member ] [td_vp_reserv] [line 276, size 32, align 32, offset 6752] [from u_int]
!796 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_no_sleeping", i32 277, i64 32, i64 32, i64 6784, i32 0, metadata !93} ; [ DW_TAG_member ] [td_no_sleeping] [line 277, size 32, align 32, offset 6784] [from int]
!797 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_dom_rr_idx", i32 278, i64 32, i64 32, i64 6816, i32 0, metadata !93} ; [ DW_TAG_member ] [td_dom_rr_idx] [line 278, size 32, align 32, offset 6816] [from int]
!798 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_sigmask", i32 283, i64 128, i64 32, i64 6848, i32 0, metadata !139} ; [ DW_TAG_member ] [td_sigmask] [line 283, size 128, align 32, offset 6848] [from sigset_t]
!799 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_rqindex", i32 284, i64 8, i64 8, i64 6976, i32 0, metadata !221} ; [ DW_TAG_member ] [td_rqindex] [line 284, size 8, align 8, offset 6976] [from u_char]
!800 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_base_pri", i32 285, i64 8, i64 8, i64 6984, i32 0, metadata !221} ; [ DW_TAG_member ] [td_base_pri] [line 285, size 8, align 8, offset 6984] [from u_char]
!801 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_priority", i32 286, i64 8, i64 8, i64 6992, i32 0, metadata !221} ; [ DW_TAG_member ] [td_priority] [line 286, size 8, align 8, offset 6992] [from u_char]
!802 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_pri_class", i32 287, i64 8, i64 8, i64 7000, i32 0, metadata !221} ; [ DW_TAG_member ] [td_pri_class] [line 287, size 8, align 8, offset 7000] [from u_char]
!803 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_user_pri", i32 288, i64 8, i64 8, i64 7008, i32 0, metadata !221} ; [ DW_TAG_member ] [td_user_pri] [line 288, size 8, align 8, offset 7008] [from u_char]
!804 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_base_user_pri", i32 289, i64 8, i64 8, i64 7016, i32 0, metadata !221} ; [ DW_TAG_member ] [td_base_user_pri] [line 289, size 8, align 8, offset 7016] [from u_char]
!805 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_pcb", i32 296, i64 64, i64 64, i64 7040, i32 0, metadata !806} ; [ DW_TAG_member ] [td_pcb] [line 296, size 64, align 64, offset 7040] [from ]
!806 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !807} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from pcb]
!807 = metadata !{i32 786451, metadata !808, null, metadata !"pcb", i32 34, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [pcb] [line 34, size 0, align 0, offset 0] [fwd] [from ]
!808 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/kdb.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!809 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_state", i32 303, i64 32, i64 32, i64 7104, i32 0, metadata !810} ; [ DW_TAG_member ] [td_state] [line 303, size 32, align 32, offset 7104] [from ]
!810 = metadata !{i32 786436, metadata !4, metadata !19, metadata !"", i32 297, i64 32, i64 32, i32 0, i32 0, null, metadata !811, i32 0, i32 0} ; [ DW_TAG_enumeration_type ] [line 297, size 32, align 32, offset 0] [from ]
!811 = metadata !{metadata !812, metadata !813, metadata !814, metadata !815, metadata !816}
!812 = metadata !{i32 786472, metadata !"TDS_INACTIVE", i64 0} ; [ DW_TAG_enumerator ] [TDS_INACTIVE :: 0]
!813 = metadata !{i32 786472, metadata !"TDS_INHIBITED", i64 1} ; [ DW_TAG_enumerator ] [TDS_INHIBITED :: 1]
!814 = metadata !{i32 786472, metadata !"TDS_CAN_RUN", i64 2} ; [ DW_TAG_enumerator ] [TDS_CAN_RUN :: 2]
!815 = metadata !{i32 786472, metadata !"TDS_RUNQ", i64 3} ; [ DW_TAG_enumerator ] [TDS_RUNQ :: 3]
!816 = metadata !{i32 786472, metadata !"TDS_RUNNING", i64 4} ; [ DW_TAG_enumerator ] [TDS_RUNNING :: 4]
!817 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_retval", i32 304, i64 128, i64 64, i64 7168, i32 0, metadata !818} ; [ DW_TAG_member ] [td_retval] [line 304, size 128, align 64, offset 7168] [from ]
!818 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 128, i64 64, i32 0, i32 0, metadata !819, metadata !475, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 128, align 64, offset 0] [from register_t]
!819 = metadata !{i32 786454, metadata !4, null, metadata !"register_t", i32 184, i64 0, i64 0, i64 0, i32 0, metadata !820} ; [ DW_TAG_typedef ] [register_t] [line 184, size 0, align 0, offset 0] [from __register_t]
!820 = metadata !{i32 786454, metadata !4, null, metadata !"__register_t", i32 102, i64 0, i64 0, i64 0, i32 0, metadata !281} ; [ DW_TAG_typedef ] [__register_t] [line 102, size 0, align 0, offset 0] [from __int64_t]
!821 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_slpcallout", i32 305, i64 512, i64 64, i64 7296, i32 0, metadata !822} ; [ DW_TAG_member ] [td_slpcallout] [line 305, size 512, align 64, offset 7296] [from callout]
!822 = metadata !{i32 786451, metadata !823, null, metadata !"callout", i32 49, i64 512, i64 64, i32 0, i32 0, null, metadata !824, i32 0, null, null} ; [ DW_TAG_structure_type ] [callout] [line 49, size 512, align 64, offset 0] [from ]
!823 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/_callout.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!824 = metadata !{metadata !825, metadata !844, metadata !846, metadata !847, metadata !848, metadata !849, metadata !851, metadata !852}
!825 = metadata !{i32 786445, metadata !823, metadata !822, metadata !"c_links", i32 54, i64 128, i64 64, i64 0, i32 0, metadata !826} ; [ DW_TAG_member ] [c_links] [line 54, size 128, align 64, offset 0] [from ]
!826 = metadata !{i32 786455, metadata !823, metadata !822, metadata !"", i32 50, i64 128, i64 64, i64 0, i32 0, null, metadata !827, i32 0, i32 0, null} ; [ DW_TAG_union_type ] [line 50, size 128, align 64, offset 0] [from ]
!827 = metadata !{metadata !828, metadata !835, metadata !839}
!828 = metadata !{i32 786445, metadata !823, metadata !826, metadata !"le", i32 51, i64 128, i64 64, i64 0, i32 0, metadata !829} ; [ DW_TAG_member ] [le] [line 51, size 128, align 64, offset 0] [from ]
!829 = metadata !{i32 786451, metadata !823, metadata !826, metadata !"", i32 51, i64 128, i64 64, i32 0, i32 0, null, metadata !830, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 51, size 128, align 64, offset 0] [from ]
!830 = metadata !{metadata !831, metadata !833}
!831 = metadata !{i32 786445, metadata !823, metadata !829, metadata !"le_next", i32 51, i64 64, i64 64, i64 0, i32 0, metadata !832} ; [ DW_TAG_member ] [le_next] [line 51, size 64, align 64, offset 0] [from ]
!832 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !822} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from callout]
!833 = metadata !{i32 786445, metadata !823, metadata !829, metadata !"le_prev", i32 51, i64 64, i64 64, i64 64, i32 0, metadata !834} ; [ DW_TAG_member ] [le_prev] [line 51, size 64, align 64, offset 64] [from ]
!834 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !832} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!835 = metadata !{i32 786445, metadata !823, metadata !826, metadata !"sle", i32 52, i64 64, i64 64, i64 0, i32 0, metadata !836} ; [ DW_TAG_member ] [sle] [line 52, size 64, align 64, offset 0] [from ]
!836 = metadata !{i32 786451, metadata !823, metadata !826, metadata !"", i32 52, i64 64, i64 64, i32 0, i32 0, null, metadata !837, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 52, size 64, align 64, offset 0] [from ]
!837 = metadata !{metadata !838}
!838 = metadata !{i32 786445, metadata !823, metadata !836, metadata !"sle_next", i32 52, i64 64, i64 64, i64 0, i32 0, metadata !832} ; [ DW_TAG_member ] [sle_next] [line 52, size 64, align 64, offset 0] [from ]
!839 = metadata !{i32 786445, metadata !823, metadata !826, metadata !"tqe", i32 53, i64 128, i64 64, i64 0, i32 0, metadata !840} ; [ DW_TAG_member ] [tqe] [line 53, size 128, align 64, offset 0] [from ]
!840 = metadata !{i32 786451, metadata !823, metadata !826, metadata !"", i32 53, i64 128, i64 64, i32 0, i32 0, null, metadata !841, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 53, size 128, align 64, offset 0] [from ]
!841 = metadata !{metadata !842, metadata !843}
!842 = metadata !{i32 786445, metadata !823, metadata !840, metadata !"tqe_next", i32 53, i64 64, i64 64, i64 0, i32 0, metadata !832} ; [ DW_TAG_member ] [tqe_next] [line 53, size 64, align 64, offset 0] [from ]
!843 = metadata !{i32 786445, metadata !823, metadata !840, metadata !"tqe_prev", i32 53, i64 64, i64 64, i64 64, i32 0, metadata !834} ; [ DW_TAG_member ] [tqe_prev] [line 53, size 64, align 64, offset 64] [from ]
!844 = metadata !{i32 786445, metadata !823, metadata !822, metadata !"c_time", i32 55, i64 64, i64 64, i64 128, i32 0, metadata !845} ; [ DW_TAG_member ] [c_time] [line 55, size 64, align 64, offset 128] [from sbintime_t]
!845 = metadata !{i32 786454, metadata !823, null, metadata !"sbintime_t", i32 191, i64 0, i64 0, i64 0, i32 0, metadata !281} ; [ DW_TAG_typedef ] [sbintime_t] [line 191, size 0, align 0, offset 0] [from __int64_t]
!846 = metadata !{i32 786445, metadata !823, metadata !822, metadata !"c_precision", i32 56, i64 64, i64 64, i64 192, i32 0, metadata !845} ; [ DW_TAG_member ] [c_precision] [line 56, size 64, align 64, offset 192] [from sbintime_t]
!847 = metadata !{i32 786445, metadata !823, metadata !822, metadata !"c_arg", i32 57, i64 64, i64 64, i64 256, i32 0, metadata !178} ; [ DW_TAG_member ] [c_arg] [line 57, size 64, align 64, offset 256] [from ]
!848 = metadata !{i32 786445, metadata !823, metadata !822, metadata !"c_func", i32 58, i64 64, i64 64, i64 320, i32 0, metadata !670} ; [ DW_TAG_member ] [c_func] [line 58, size 64, align 64, offset 320] [from ]
!849 = metadata !{i32 786445, metadata !823, metadata !822, metadata !"c_lock", i32 59, i64 64, i64 64, i64 384, i32 0, metadata !850} ; [ DW_TAG_member ] [c_lock] [line 59, size 64, align 64, offset 384] [from ]
!850 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !28} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from lock_object]
!851 = metadata !{i32 786445, metadata !823, metadata !822, metadata !"c_flags", i32 60, i64 32, i64 32, i64 448, i32 0, metadata !93} ; [ DW_TAG_member ] [c_flags] [line 60, size 32, align 32, offset 448] [from int]
!852 = metadata !{i32 786445, metadata !823, metadata !822, metadata !"c_cpu", i32 61, i64 32, i64 32, i64 480, i32 0, metadata !853} ; [ DW_TAG_member ] [c_cpu] [line 61, size 32, align 32, offset 480] [from ]
!853 = metadata !{i32 786485, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !93} ; [ DW_TAG_volatile_type ] [line 0, size 0, align 0, offset 0] [from int]
!854 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_frame", i32 306, i64 64, i64 64, i64 7808, i32 0, metadata !855} ; [ DW_TAG_member ] [td_frame] [line 306, size 64, align 64, offset 7808] [from ]
!855 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !856} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from trapframe]
!856 = metadata !{i32 786451, metadata !857, null, metadata !"trapframe", i32 166, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [trapframe] [line 166, size 0, align 0, offset 0] [fwd] [from ]
!857 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/systm.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!858 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_kstack_obj", i32 307, i64 64, i64 64, i64 7872, i32 0, metadata !859} ; [ DW_TAG_member ] [td_kstack_obj] [line 307, size 64, align 64, offset 7872] [from ]
!859 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !860} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from vm_object]
!860 = metadata !{i32 786451, metadata !4, null, metadata !"vm_object", i32 307, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [vm_object] [line 307, size 0, align 0, offset 0] [fwd] [from ]
!861 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_kstack", i32 308, i64 64, i64 64, i64 7936, i32 0, metadata !862} ; [ DW_TAG_member ] [td_kstack] [line 308, size 64, align 64, offset 7936] [from vm_offset_t]
!862 = metadata !{i32 786454, metadata !4, null, metadata !"vm_offset_t", i32 237, i64 0, i64 0, i64 0, i32 0, metadata !863} ; [ DW_TAG_typedef ] [vm_offset_t] [line 237, size 0, align 0, offset 0] [from __vm_offset_t]
!863 = metadata !{i32 786454, metadata !4, null, metadata !"__vm_offset_t", i32 130, i64 0, i64 0, i64 0, i32 0, metadata !46} ; [ DW_TAG_typedef ] [__vm_offset_t] [line 130, size 0, align 0, offset 0] [from __uint64_t]
!864 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_kstack_pages", i32 309, i64 32, i64 32, i64 8000, i32 0, metadata !93} ; [ DW_TAG_member ] [td_kstack_pages] [line 309, size 32, align 32, offset 8000] [from int]
!865 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_critnest", i32 310, i64 32, i64 32, i64 8032, i32 0, metadata !91} ; [ DW_TAG_member ] [td_critnest] [line 310, size 32, align 32, offset 8032] [from ]
!866 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_md", i32 311, i64 192, i64 64, i64 8064, i32 0, metadata !867} ; [ DW_TAG_member ] [td_md] [line 311, size 192, align 64, offset 8064] [from mdthread]
!867 = metadata !{i32 786451, metadata !868, null, metadata !"mdthread", i32 46, i64 192, i64 64, i32 0, i32 0, null, metadata !869, i32 0, null, null} ; [ DW_TAG_structure_type ] [mdthread] [line 46, size 192, align 64, offset 0] [from ]
!868 = metadata !{metadata !"./machine/proc.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!869 = metadata !{metadata !870, metadata !871, metadata !872}
!870 = metadata !{i32 786445, metadata !868, metadata !867, metadata !"md_spinlock_count", i32 47, i64 32, i64 32, i64 0, i32 0, metadata !93} ; [ DW_TAG_member ] [md_spinlock_count] [line 47, size 32, align 32, offset 0] [from int]
!871 = metadata !{i32 786445, metadata !868, metadata !867, metadata !"md_saved_flags", i32 48, i64 64, i64 64, i64 64, i32 0, metadata !819} ; [ DW_TAG_member ] [md_saved_flags] [line 48, size 64, align 64, offset 64] [from register_t]
!872 = metadata !{i32 786445, metadata !868, metadata !867, metadata !"md_spurflt_addr", i32 49, i64 64, i64 64, i64 128, i32 0, metadata !819} ; [ DW_TAG_member ] [md_spurflt_addr] [line 49, size 64, align 64, offset 128] [from register_t]
!873 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_sched", i32 312, i64 64, i64 64, i64 8256, i32 0, metadata !874} ; [ DW_TAG_member ] [td_sched] [line 312, size 64, align 64, offset 8256] [from ]
!874 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !875} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from td_sched]
!875 = metadata !{i32 786451, metadata !4, null, metadata !"td_sched", i32 173, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [td_sched] [line 173, size 0, align 0, offset 0] [fwd] [from ]
!876 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_ar", i32 313, i64 64, i64 64, i64 8320, i32 0, metadata !877} ; [ DW_TAG_member ] [td_ar] [line 313, size 64, align 64, offset 8320] [from ]
!877 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !878} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from kaudit_record]
!878 = metadata !{i32 786451, metadata !4, null, metadata !"kaudit_record", i32 162, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [kaudit_record] [line 162, size 0, align 0, offset 0] [fwd] [from ]
!879 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_lprof", i32 314, i64 128, i64 64, i64 8384, i32 0, metadata !880} ; [ DW_TAG_member ] [td_lprof] [line 314, size 128, align 64, offset 8384] [from ]
!880 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 128, i64 64, i32 0, i32 0, metadata !881, metadata !475, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 128, align 64, offset 0] [from lpohead]
!881 = metadata !{i32 786451, metadata !882, null, metadata !"lpohead", i32 35, i64 64, i64 64, i32 0, i32 0, null, metadata !883, i32 0, null, null} ; [ DW_TAG_structure_type ] [lpohead] [line 35, size 64, align 64, offset 0] [from ]
!882 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/lock_profile.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!883 = metadata !{metadata !884}
!884 = metadata !{i32 786445, metadata !882, metadata !881, metadata !"lh_first", i32 35, i64 64, i64 64, i64 0, i32 0, metadata !885} ; [ DW_TAG_member ] [lh_first] [line 35, size 64, align 64, offset 0] [from ]
!885 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !886} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from lock_profile_object]
!886 = metadata !{i32 786451, metadata !882, null, metadata !"lock_profile_object", i32 34, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [lock_profile_object] [line 34, size 0, align 0, offset 0] [fwd] [from ]
!887 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_dtrace", i32 315, i64 64, i64 64, i64 8512, i32 0, metadata !888} ; [ DW_TAG_member ] [td_dtrace] [line 315, size 64, align 64, offset 8512] [from ]
!888 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !889} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from kdtrace_thread]
!889 = metadata !{i32 786451, metadata !4, null, metadata !"kdtrace_thread", i32 164, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [kdtrace_thread] [line 164, size 0, align 0, offset 0] [fwd] [from ]
!890 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_errno", i32 316, i64 32, i64 32, i64 8576, i32 0, metadata !93} ; [ DW_TAG_member ] [td_errno] [line 316, size 32, align 32, offset 8576] [from int]
!891 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_vnet", i32 317, i64 64, i64 64, i64 8640, i32 0, metadata !365} ; [ DW_TAG_member ] [td_vnet] [line 317, size 64, align 64, offset 8640] [from ]
!892 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_vnet_lpush", i32 318, i64 64, i64 64, i64 8704, i32 0, metadata !32} ; [ DW_TAG_member ] [td_vnet_lpush] [line 318, size 64, align 64, offset 8704] [from ]
!893 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_intr_frame", i32 319, i64 64, i64 64, i64 8768, i32 0, metadata !855} ; [ DW_TAG_member ] [td_intr_frame] [line 319, size 64, align 64, offset 8768] [from ]
!894 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_rfppwait_p", i32 320, i64 64, i64 64, i64 8832, i32 0, metadata !11} ; [ DW_TAG_member ] [td_rfppwait_p] [line 320, size 64, align 64, offset 8832] [from ]
!895 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_ma", i32 321, i64 64, i64 64, i64 8896, i32 0, metadata !896} ; [ DW_TAG_member ] [td_ma] [line 321, size 64, align 64, offset 8896] [from ]
!896 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !897} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!897 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !898} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from vm_page]
!898 = metadata !{i32 786451, metadata !899, null, metadata !"vm_page", i32 263, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [vm_page] [line 263, size 0, align 0, offset 0] [fwd] [from ]
!899 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/types.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!900 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_ma_cnt", i32 322, i64 32, i64 32, i64 8960, i32 0, metadata !93} ; [ DW_TAG_member ] [td_ma_cnt] [line 322, size 32, align 32, offset 8960] [from int]
!901 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_tesla", i32 323, i64 64, i64 64, i64 9024, i32 0, metadata !902} ; [ DW_TAG_member ] [td_tesla] [line 323, size 64, align 64, offset 9024] [from ]
!902 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !903} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from tesla_store]
!903 = metadata !{i32 786451, metadata !4, null, metadata !"tesla_store", i32 174, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [tesla_store] [line 174, size 0, align 0, offset 0] [fwd] [from ]
!904 = metadata !{i32 786445, metadata !4, metadata !15, metadata !"tqh_last", i32 487, i64 64, i64 64, i64 64, i32 0, metadata !54} ; [ DW_TAG_member ] [tqh_last] [line 487, size 64, align 64, offset 64] [from ]
!905 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_slock", i32 488, i64 256, i64 64, i64 256, i32 0, metadata !24} ; [ DW_TAG_member ] [p_slock] [line 488, size 256, align 64, offset 256] [from mtx]
!906 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_ucred", i32 489, i64 64, i64 64, i64 512, i32 0, metadata !253} ; [ DW_TAG_member ] [p_ucred] [line 489, size 64, align 64, offset 512] [from ]
!907 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_fd", i32 490, i64 64, i64 64, i64 576, i32 0, metadata !908} ; [ DW_TAG_member ] [p_fd] [line 490, size 64, align 64, offset 576] [from ]
!908 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !909} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from filedesc]
!909 = metadata !{i32 786451, metadata !4, null, metadata !"filedesc", i32 490, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [filedesc] [line 490, size 0, align 0, offset 0] [fwd] [from ]
!910 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_fdtol", i32 491, i64 64, i64 64, i64 640, i32 0, metadata !911} ; [ DW_TAG_member ] [p_fdtol] [line 491, size 64, align 64, offset 640] [from ]
!911 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !912} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from filedesc_to_leader]
!912 = metadata !{i32 786451, metadata !4, null, metadata !"filedesc_to_leader", i32 491, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [filedesc_to_leader] [line 491, size 0, align 0, offset 0] [fwd] [from ]
!913 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_stats", i32 492, i64 64, i64 64, i64 704, i32 0, metadata !914} ; [ DW_TAG_member ] [p_stats] [line 492, size 64, align 64, offset 704] [from ]
!914 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !915} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from pstats]
!915 = metadata !{i32 786451, metadata !269, null, metadata !"pstats", i32 53, i64 2304, i64 64, i32 0, i32 0, null, metadata !916, i32 0, null, null} ; [ DW_TAG_structure_type ] [pstats] [line 53, size 2304, align 64, offset 0] [from ]
!916 = metadata !{metadata !917, metadata !918, metadata !925, metadata !933}
!917 = metadata !{i32 786445, metadata !269, metadata !915, metadata !"p_cru", i32 55, i64 1152, i64 64, i64 0, i32 0, metadata !517} ; [ DW_TAG_member ] [p_cru] [line 55, size 1152, align 64, offset 0] [from rusage]
!918 = metadata !{i32 786445, metadata !269, metadata !915, metadata !"p_timer", i32 56, i64 768, i64 64, i64 1152, i32 0, metadata !919} ; [ DW_TAG_member ] [p_timer] [line 56, size 768, align 64, offset 1152] [from ]
!919 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 768, i64 64, i32 0, i32 0, metadata !920, metadata !433, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 768, align 64, offset 0] [from itimerval]
!920 = metadata !{i32 786451, metadata !921, null, metadata !"itimerval", i32 319, i64 256, i64 64, i32 0, i32 0, null, metadata !922, i32 0, null, null} ; [ DW_TAG_structure_type ] [itimerval] [line 319, size 256, align 64, offset 0] [from ]
!921 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/time.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!922 = metadata !{metadata !923, metadata !924}
!923 = metadata !{i32 786445, metadata !921, metadata !920, metadata !"it_interval", i32 320, i64 128, i64 64, i64 0, i32 0, metadata !521} ; [ DW_TAG_member ] [it_interval] [line 320, size 128, align 64, offset 0] [from timeval]
!924 = metadata !{i32 786445, metadata !921, metadata !920, metadata !"it_value", i32 321, i64 128, i64 64, i64 128, i32 0, metadata !521} ; [ DW_TAG_member ] [it_value] [line 321, size 128, align 64, offset 128] [from timeval]
!925 = metadata !{i32 786445, metadata !269, metadata !915, metadata !"p_prof", i32 65, i64 256, i64 64, i64 1920, i32 0, metadata !926} ; [ DW_TAG_member ] [p_prof] [line 65, size 256, align 64, offset 1920] [from uprof]
!926 = metadata !{i32 786451, metadata !269, null, metadata !"uprof", i32 60, i64 256, i64 64, i32 0, i32 0, null, metadata !927, i32 0, null, null} ; [ DW_TAG_structure_type ] [uprof] [line 60, size 256, align 64, offset 0] [from ]
!927 = metadata !{metadata !928, metadata !930, metadata !931, metadata !932}
!928 = metadata !{i32 786445, metadata !269, metadata !926, metadata !"pr_base", i32 61, i64 64, i64 64, i64 0, i32 0, metadata !929} ; [ DW_TAG_member ] [pr_base] [line 61, size 64, align 64, offset 0] [from caddr_t]
!929 = metadata !{i32 786454, metadata !269, null, metadata !"caddr_t", i32 74, i64 0, i64 0, i64 0, i32 0, metadata !570} ; [ DW_TAG_typedef ] [caddr_t] [line 74, size 0, align 0, offset 0] [from ]
!930 = metadata !{i32 786445, metadata !269, metadata !926, metadata !"pr_size", i32 62, i64 64, i64 64, i64 64, i32 0, metadata !577} ; [ DW_TAG_member ] [pr_size] [line 62, size 64, align 64, offset 64] [from u_long]
!931 = metadata !{i32 786445, metadata !269, metadata !926, metadata !"pr_off", i32 63, i64 64, i64 64, i64 128, i32 0, metadata !577} ; [ DW_TAG_member ] [pr_off] [line 63, size 64, align 64, offset 128] [from u_long]
!932 = metadata !{i32 786445, metadata !269, metadata !926, metadata !"pr_scale", i32 64, i64 64, i64 64, i64 192, i32 0, metadata !577} ; [ DW_TAG_member ] [pr_scale] [line 64, size 64, align 64, offset 192] [from u_long]
!933 = metadata !{i32 786445, metadata !269, metadata !915, metadata !"p_start", i32 67, i64 128, i64 64, i64 2176, i32 0, metadata !521} ; [ DW_TAG_member ] [p_start] [line 67, size 128, align 64, offset 2176] [from timeval]
!934 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_limit", i32 493, i64 64, i64 64, i64 768, i32 0, metadata !935} ; [ DW_TAG_member ] [p_limit] [line 493, size 64, align 64, offset 768] [from ]
!935 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !936} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from plimit]
!936 = metadata !{i32 786451, metadata !269, null, metadata !"plimit", i32 77, i64 1728, i64 64, i32 0, i32 0, null, metadata !937, i32 0, null, null} ; [ DW_TAG_structure_type ] [plimit] [line 77, size 1728, align 64, offset 0] [from ]
!937 = metadata !{metadata !938, metadata !948}
!938 = metadata !{i32 786445, metadata !269, metadata !936, metadata !"pl_rlimit", i32 78, i64 1664, i64 64, i64 0, i32 0, metadata !939} ; [ DW_TAG_member ] [pl_rlimit] [line 78, size 1664, align 64, offset 0] [from ]
!939 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 1664, i64 64, i32 0, i32 0, metadata !940, metadata !946, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 1664, align 64, offset 0] [from rlimit]
!940 = metadata !{i32 786451, metadata !518, null, metadata !"rlimit", i32 140, i64 128, i64 64, i32 0, i32 0, null, metadata !941, i32 0, null, null} ; [ DW_TAG_structure_type ] [rlimit] [line 140, size 128, align 64, offset 0] [from ]
!941 = metadata !{metadata !942, metadata !945}
!942 = metadata !{i32 786445, metadata !518, metadata !940, metadata !"rlim_cur", i32 141, i64 64, i64 64, i64 0, i32 0, metadata !943} ; [ DW_TAG_member ] [rlim_cur] [line 141, size 64, align 64, offset 0] [from rlim_t]
!943 = metadata !{i32 786454, metadata !518, null, metadata !"rlim_t", i32 187, i64 0, i64 0, i64 0, i32 0, metadata !944} ; [ DW_TAG_typedef ] [rlim_t] [line 187, size 0, align 0, offset 0] [from __rlim_t]
!944 = metadata !{i32 786454, metadata !518, null, metadata !"__rlim_t", i32 56, i64 0, i64 0, i64 0, i32 0, metadata !281} ; [ DW_TAG_typedef ] [__rlim_t] [line 56, size 0, align 0, offset 0] [from __int64_t]
!945 = metadata !{i32 786445, metadata !518, metadata !940, metadata !"rlim_max", i32 142, i64 64, i64 64, i64 64, i32 0, metadata !943} ; [ DW_TAG_member ] [rlim_max] [line 142, size 64, align 64, offset 64] [from rlim_t]
!946 = metadata !{metadata !947}
!947 = metadata !{i32 786465, i64 0, i64 13}      ; [ DW_TAG_subrange_type ] [0, 12]
!948 = metadata !{i32 786445, metadata !269, metadata !936, metadata !"pl_refcnt", i32 79, i64 32, i64 32, i64 1664, i32 0, metadata !93} ; [ DW_TAG_member ] [pl_refcnt] [line 79, size 32, align 32, offset 1664] [from int]
!949 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_limco", i32 494, i64 512, i64 64, i64 832, i32 0, metadata !822} ; [ DW_TAG_member ] [p_limco] [line 494, size 512, align 64, offset 832] [from callout]
!950 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_sigacts", i32 495, i64 64, i64 64, i64 1344, i32 0, metadata !951} ; [ DW_TAG_member ] [p_sigacts] [line 495, size 64, align 64, offset 1344] [from ]
!951 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !952} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from sigacts]
!952 = metadata !{i32 786451, metadata !136, null, metadata !"sigacts", i32 52, i64 26176, i64 64, i32 0, i32 0, null, metadata !953, i32 0, null, null} ; [ DW_TAG_structure_type ] [sigacts] [line 52, size 26176, align 64, offset 0] [from ]
!953 = metadata !{metadata !954, metadata !963, metadata !965, metadata !966, metadata !967, metadata !968, metadata !969, metadata !970, metadata !971, metadata !972, metadata !973, metadata !974, metadata !975, metadata !976, metadata !977}
!954 = metadata !{i32 786445, metadata !136, metadata !952, metadata !"ps_sigact", i32 53, i64 8192, i64 64, i64 0, i32 0, metadata !955} ; [ DW_TAG_member ] [ps_sigact] [line 53, size 8192, align 64, offset 0] [from ]
!955 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 8192, i64 64, i32 0, i32 0, metadata !956, metadata !961, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 8192, align 64, offset 0] [from sig_t]
!956 = metadata !{i32 786454, metadata !136, null, metadata !"sig_t", i32 352, i64 0, i64 0, i64 0, i32 0, metadata !957} ; [ DW_TAG_typedef ] [sig_t] [line 352, size 0, align 0, offset 0] [from ]
!957 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !958} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from __sighandler_t]
!958 = metadata !{i32 786454, metadata !136, null, metadata !"__sighandler_t", i32 142, i64 0, i64 0, i64 0, i32 0, metadata !959} ; [ DW_TAG_typedef ] [__sighandler_t] [line 142, size 0, align 0, offset 0] [from ]
!959 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !960, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!960 = metadata !{null, metadata !93}
!961 = metadata !{metadata !962}
!962 = metadata !{i32 786465, i64 0, i64 128}     ; [ DW_TAG_subrange_type ] [0, 127]
!963 = metadata !{i32 786445, metadata !136, metadata !952, metadata !"ps_catchmask", i32 54, i64 16384, i64 32, i64 8192, i32 0, metadata !964} ; [ DW_TAG_member ] [ps_catchmask] [line 54, size 16384, align 32, offset 8192] [from ]
!964 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 16384, i64 32, i32 0, i32 0, metadata !139, metadata !961, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 16384, align 32, offset 0] [from sigset_t]
!965 = metadata !{i32 786445, metadata !136, metadata !952, metadata !"ps_sigonstack", i32 55, i64 128, i64 32, i64 24576, i32 0, metadata !139} ; [ DW_TAG_member ] [ps_sigonstack] [line 55, size 128, align 32, offset 24576] [from sigset_t]
!966 = metadata !{i32 786445, metadata !136, metadata !952, metadata !"ps_sigintr", i32 56, i64 128, i64 32, i64 24704, i32 0, metadata !139} ; [ DW_TAG_member ] [ps_sigintr] [line 56, size 128, align 32, offset 24704] [from sigset_t]
!967 = metadata !{i32 786445, metadata !136, metadata !952, metadata !"ps_sigreset", i32 57, i64 128, i64 32, i64 24832, i32 0, metadata !139} ; [ DW_TAG_member ] [ps_sigreset] [line 57, size 128, align 32, offset 24832] [from sigset_t]
!968 = metadata !{i32 786445, metadata !136, metadata !952, metadata !"ps_signodefer", i32 58, i64 128, i64 32, i64 24960, i32 0, metadata !139} ; [ DW_TAG_member ] [ps_signodefer] [line 58, size 128, align 32, offset 24960] [from sigset_t]
!969 = metadata !{i32 786445, metadata !136, metadata !952, metadata !"ps_siginfo", i32 59, i64 128, i64 32, i64 25088, i32 0, metadata !139} ; [ DW_TAG_member ] [ps_siginfo] [line 59, size 128, align 32, offset 25088] [from sigset_t]
!970 = metadata !{i32 786445, metadata !136, metadata !952, metadata !"ps_sigignore", i32 60, i64 128, i64 32, i64 25216, i32 0, metadata !139} ; [ DW_TAG_member ] [ps_sigignore] [line 60, size 128, align 32, offset 25216] [from sigset_t]
!971 = metadata !{i32 786445, metadata !136, metadata !952, metadata !"ps_sigcatch", i32 61, i64 128, i64 32, i64 25344, i32 0, metadata !139} ; [ DW_TAG_member ] [ps_sigcatch] [line 61, size 128, align 32, offset 25344] [from sigset_t]
!972 = metadata !{i32 786445, metadata !136, metadata !952, metadata !"ps_freebsd4", i32 62, i64 128, i64 32, i64 25472, i32 0, metadata !139} ; [ DW_TAG_member ] [ps_freebsd4] [line 62, size 128, align 32, offset 25472] [from sigset_t]
!973 = metadata !{i32 786445, metadata !136, metadata !952, metadata !"ps_osigset", i32 63, i64 128, i64 32, i64 25600, i32 0, metadata !139} ; [ DW_TAG_member ] [ps_osigset] [line 63, size 128, align 32, offset 25600] [from sigset_t]
!974 = metadata !{i32 786445, metadata !136, metadata !952, metadata !"ps_usertramp", i32 64, i64 128, i64 32, i64 25728, i32 0, metadata !139} ; [ DW_TAG_member ] [ps_usertramp] [line 64, size 128, align 32, offset 25728] [from sigset_t]
!975 = metadata !{i32 786445, metadata !136, metadata !952, metadata !"ps_flag", i32 65, i64 32, i64 32, i64 25856, i32 0, metadata !93} ; [ DW_TAG_member ] [ps_flag] [line 65, size 32, align 32, offset 25856] [from int]
!976 = metadata !{i32 786445, metadata !136, metadata !952, metadata !"ps_refcnt", i32 66, i64 32, i64 32, i64 25888, i32 0, metadata !93} ; [ DW_TAG_member ] [ps_refcnt] [line 66, size 32, align 32, offset 25888] [from int]
!977 = metadata !{i32 786445, metadata !136, metadata !952, metadata !"ps_mtx", i32 67, i64 256, i64 64, i64 25920, i32 0, metadata !24} ; [ DW_TAG_member ] [ps_mtx] [line 67, size 256, align 64, offset 25920] [from mtx]
!978 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_flag", i32 501, i64 32, i64 32, i64 1408, i32 0, metadata !93} ; [ DW_TAG_member ] [p_flag] [line 501, size 32, align 32, offset 1408] [from int]
!979 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_state", i32 506, i64 32, i64 32, i64 1440, i32 0, metadata !3} ; [ DW_TAG_member ] [p_state] [line 506, size 32, align 32, offset 1440] [from ]
!980 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_pid", i32 507, i64 32, i64 32, i64 1472, i32 0, metadata !504} ; [ DW_TAG_member ] [p_pid] [line 507, size 32, align 32, offset 1472] [from pid_t]
!981 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_hash", i32 508, i64 128, i64 64, i64 1536, i32 0, metadata !982} ; [ DW_TAG_member ] [p_hash] [line 508, size 128, align 64, offset 1536] [from ]
!982 = metadata !{i32 786451, metadata !4, metadata !5, metadata !"", i32 508, i64 128, i64 64, i32 0, i32 0, null, metadata !983, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 508, size 128, align 64, offset 0] [from ]
!983 = metadata !{metadata !984, metadata !985}
!984 = metadata !{i32 786445, metadata !4, metadata !982, metadata !"le_next", i32 508, i64 64, i64 64, i64 0, i32 0, metadata !11} ; [ DW_TAG_member ] [le_next] [line 508, size 64, align 64, offset 0] [from ]
!985 = metadata !{i32 786445, metadata !4, metadata !982, metadata !"le_prev", i32 508, i64 64, i64 64, i64 64, i32 0, metadata !13} ; [ DW_TAG_member ] [le_prev] [line 508, size 64, align 64, offset 64] [from ]
!986 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_pglist", i32 509, i64 128, i64 64, i64 1664, i32 0, metadata !987} ; [ DW_TAG_member ] [p_pglist] [line 509, size 128, align 64, offset 1664] [from ]
!987 = metadata !{i32 786451, metadata !4, metadata !5, metadata !"", i32 509, i64 128, i64 64, i32 0, i32 0, null, metadata !988, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 509, size 128, align 64, offset 0] [from ]
!988 = metadata !{metadata !989, metadata !990}
!989 = metadata !{i32 786445, metadata !4, metadata !987, metadata !"le_next", i32 509, i64 64, i64 64, i64 0, i32 0, metadata !11} ; [ DW_TAG_member ] [le_next] [line 509, size 64, align 64, offset 0] [from ]
!990 = metadata !{i32 786445, metadata !4, metadata !987, metadata !"le_prev", i32 509, i64 64, i64 64, i64 64, i32 0, metadata !13} ; [ DW_TAG_member ] [le_prev] [line 509, size 64, align 64, offset 64] [from ]
!991 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_pptr", i32 510, i64 64, i64 64, i64 1792, i32 0, metadata !11} ; [ DW_TAG_member ] [p_pptr] [line 510, size 64, align 64, offset 1792] [from ]
!992 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_sibling", i32 511, i64 128, i64 64, i64 1856, i32 0, metadata !993} ; [ DW_TAG_member ] [p_sibling] [line 511, size 128, align 64, offset 1856] [from ]
!993 = metadata !{i32 786451, metadata !4, metadata !5, metadata !"", i32 511, i64 128, i64 64, i32 0, i32 0, null, metadata !994, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 511, size 128, align 64, offset 0] [from ]
!994 = metadata !{metadata !995, metadata !996}
!995 = metadata !{i32 786445, metadata !4, metadata !993, metadata !"le_next", i32 511, i64 64, i64 64, i64 0, i32 0, metadata !11} ; [ DW_TAG_member ] [le_next] [line 511, size 64, align 64, offset 0] [from ]
!996 = metadata !{i32 786445, metadata !4, metadata !993, metadata !"le_prev", i32 511, i64 64, i64 64, i64 64, i32 0, metadata !13} ; [ DW_TAG_member ] [le_prev] [line 511, size 64, align 64, offset 64] [from ]
!997 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_children", i32 512, i64 64, i64 64, i64 1984, i32 0, metadata !998} ; [ DW_TAG_member ] [p_children] [line 512, size 64, align 64, offset 1984] [from ]
!998 = metadata !{i32 786451, metadata !4, metadata !5, metadata !"", i32 512, i64 64, i64 64, i32 0, i32 0, null, metadata !999, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 512, size 64, align 64, offset 0] [from ]
!999 = metadata !{metadata !1000}
!1000 = metadata !{i32 786445, metadata !4, metadata !998, metadata !"lh_first", i32 512, i64 64, i64 64, i64 0, i32 0, metadata !11} ; [ DW_TAG_member ] [lh_first] [line 512, size 64, align 64, offset 0] [from ]
!1001 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_mtx", i32 513, i64 256, i64 64, i64 2048, i32 0, metadata !24} ; [ DW_TAG_member ] [p_mtx] [line 513, size 256, align 64, offset 2048] [from mtx]
!1002 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_ksi", i32 514, i64 64, i64 64, i64 2304, i32 0, metadata !155} ; [ DW_TAG_member ] [p_ksi] [line 514, size 64, align 64, offset 2304] [from ]
!1003 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_sigqueue", i32 515, i64 512, i64 64, i64 2368, i32 0, metadata !134} ; [ DW_TAG_member ] [p_sigqueue] [line 515, size 512, align 64, offset 2368] [from sigqueue_t]
!1004 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_oppid", i32 520, i64 32, i64 32, i64 2880, i32 0, metadata !504} ; [ DW_TAG_member ] [p_oppid] [line 520, size 32, align 32, offset 2880] [from pid_t]
!1005 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_vmspace", i32 521, i64 64, i64 64, i64 2944, i32 0, metadata !1006} ; [ DW_TAG_member ] [p_vmspace] [line 521, size 64, align 64, offset 2944] [from ]
!1006 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1007} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from vmspace]
!1007 = metadata !{i32 786451, metadata !4, null, metadata !"vmspace", i32 521, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [vmspace] [line 521, size 0, align 0, offset 0] [fwd] [from ]
!1008 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_swtick", i32 522, i64 32, i64 32, i64 3008, i32 0, metadata !36} ; [ DW_TAG_member ] [p_swtick] [line 522, size 32, align 32, offset 3008] [from u_int]
!1009 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_realtimer", i32 523, i64 256, i64 64, i64 3072, i32 0, metadata !920} ; [ DW_TAG_member ] [p_realtimer] [line 523, size 256, align 64, offset 3072] [from itimerval]
!1010 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_ru", i32 524, i64 1152, i64 64, i64 3328, i32 0, metadata !517} ; [ DW_TAG_member ] [p_ru] [line 524, size 1152, align 64, offset 3328] [from rusage]
!1011 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_rux", i32 525, i64 448, i64 64, i64 4480, i32 0, metadata !546} ; [ DW_TAG_member ] [p_rux] [line 525, size 448, align 64, offset 4480] [from rusage_ext]
!1012 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_crux", i32 526, i64 448, i64 64, i64 4928, i32 0, metadata !546} ; [ DW_TAG_member ] [p_crux] [line 526, size 448, align 64, offset 4928] [from rusage_ext]
!1013 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_profthreads", i32 527, i64 32, i64 32, i64 5376, i32 0, metadata !93} ; [ DW_TAG_member ] [p_profthreads] [line 527, size 32, align 32, offset 5376] [from int]
!1014 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_exitthreads", i32 528, i64 32, i64 32, i64 5408, i32 0, metadata !853} ; [ DW_TAG_member ] [p_exitthreads] [line 528, size 32, align 32, offset 5408] [from ]
!1015 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_traceflag", i32 529, i64 32, i64 32, i64 5440, i32 0, metadata !93} ; [ DW_TAG_member ] [p_traceflag] [line 529, size 32, align 32, offset 5440] [from int]
!1016 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_tracevp", i32 530, i64 64, i64 64, i64 5504, i32 0, metadata !381} ; [ DW_TAG_member ] [p_tracevp] [line 530, size 64, align 64, offset 5504] [from ]
!1017 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_tracecred", i32 531, i64 64, i64 64, i64 5568, i32 0, metadata !253} ; [ DW_TAG_member ] [p_tracecred] [line 531, size 64, align 64, offset 5568] [from ]
!1018 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_textvp", i32 532, i64 64, i64 64, i64 5632, i32 0, metadata !381} ; [ DW_TAG_member ] [p_textvp] [line 532, size 64, align 64, offset 5632] [from ]
!1019 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_lock", i32 533, i64 32, i64 32, i64 5696, i32 0, metadata !36} ; [ DW_TAG_member ] [p_lock] [line 533, size 32, align 32, offset 5696] [from u_int]
!1020 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_sigiolst", i32 534, i64 64, i64 64, i64 5760, i32 0, metadata !1021} ; [ DW_TAG_member ] [p_sigiolst] [line 534, size 64, align 64, offset 5760] [from sigiolst]
!1021 = metadata !{i32 786451, metadata !1022, null, metadata !"sigiolst", i32 60, i64 64, i64 64, i32 0, i32 0, null, metadata !1023, i32 0, null, null} ; [ DW_TAG_structure_type ] [sigiolst] [line 60, size 64, align 64, offset 0] [from ]
!1022 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/sigio.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!1023 = metadata !{metadata !1024}
!1024 = metadata !{i32 786445, metadata !1022, metadata !1021, metadata !"slh_first", i32 60, i64 64, i64 64, i64 0, i32 0, metadata !1025} ; [ DW_TAG_member ] [slh_first] [line 60, size 64, align 64, offset 0] [from ]
!1025 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1026} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from sigio]
!1026 = metadata !{i32 786451, metadata !1022, null, metadata !"sigio", i32 46, i64 320, i64 64, i32 0, i32 0, null, metadata !1027, i32 0, null, null} ; [ DW_TAG_structure_type ] [sigio] [line 46, size 320, align 64, offset 0] [from ]
!1027 = metadata !{metadata !1028, metadata !1069, metadata !1073, metadata !1075, metadata !1076}
!1028 = metadata !{i32 786445, metadata !1022, metadata !1026, metadata !"sio_u", i32 50, i64 64, i64 64, i64 0, i32 0, metadata !1029} ; [ DW_TAG_member ] [sio_u] [line 50, size 64, align 64, offset 0] [from ]
!1029 = metadata !{i32 786455, metadata !1022, metadata !1026, metadata !"", i32 47, i64 64, i64 64, i64 0, i32 0, null, metadata !1030, i32 0, i32 0, null} ; [ DW_TAG_union_type ] [line 47, size 64, align 64, offset 0] [from ]
!1030 = metadata !{metadata !1031, metadata !1032}
!1031 = metadata !{i32 786445, metadata !1022, metadata !1029, metadata !"siu_proc", i32 48, i64 64, i64 64, i64 0, i32 0, metadata !11} ; [ DW_TAG_member ] [siu_proc] [line 48, size 64, align 64, offset 0] [from ]
!1032 = metadata !{i32 786445, metadata !1022, metadata !1029, metadata !"siu_pgrp", i32 49, i64 64, i64 64, i64 0, i32 0, metadata !1033} ; [ DW_TAG_member ] [siu_pgrp] [line 49, size 64, align 64, offset 0] [from ]
!1033 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1034} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from pgrp]
!1034 = metadata !{i32 786451, metadata !4, null, metadata !"pgrp", i32 96, i64 640, i64 64, i32 0, i32 0, null, metadata !1035, i32 0, null, null} ; [ DW_TAG_structure_type ] [pgrp] [line 96, size 640, align 64, offset 0] [from ]
!1035 = metadata !{metadata !1036, metadata !1042, metadata !1046, metadata !1065, metadata !1066, metadata !1067, metadata !1068}
!1036 = metadata !{i32 786445, metadata !4, metadata !1034, metadata !"pg_hash", i32 97, i64 128, i64 64, i64 0, i32 0, metadata !1037} ; [ DW_TAG_member ] [pg_hash] [line 97, size 128, align 64, offset 0] [from ]
!1037 = metadata !{i32 786451, metadata !4, metadata !1034, metadata !"", i32 97, i64 128, i64 64, i32 0, i32 0, null, metadata !1038, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 97, size 128, align 64, offset 0] [from ]
!1038 = metadata !{metadata !1039, metadata !1040}
!1039 = metadata !{i32 786445, metadata !4, metadata !1037, metadata !"le_next", i32 97, i64 64, i64 64, i64 0, i32 0, metadata !1033} ; [ DW_TAG_member ] [le_next] [line 97, size 64, align 64, offset 0] [from ]
!1040 = metadata !{i32 786445, metadata !4, metadata !1037, metadata !"le_prev", i32 97, i64 64, i64 64, i64 64, i32 0, metadata !1041} ; [ DW_TAG_member ] [le_prev] [line 97, size 64, align 64, offset 64] [from ]
!1041 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1033} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!1042 = metadata !{i32 786445, metadata !4, metadata !1034, metadata !"pg_members", i32 98, i64 64, i64 64, i64 128, i32 0, metadata !1043} ; [ DW_TAG_member ] [pg_members] [line 98, size 64, align 64, offset 128] [from ]
!1043 = metadata !{i32 786451, metadata !4, metadata !1034, metadata !"", i32 98, i64 64, i64 64, i32 0, i32 0, null, metadata !1044, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 98, size 64, align 64, offset 0] [from ]
!1044 = metadata !{metadata !1045}
!1045 = metadata !{i32 786445, metadata !4, metadata !1043, metadata !"lh_first", i32 98, i64 64, i64 64, i64 0, i32 0, metadata !11} ; [ DW_TAG_member ] [lh_first] [line 98, size 64, align 64, offset 0] [from ]
!1046 = metadata !{i32 786445, metadata !4, metadata !1034, metadata !"pg_session", i32 99, i64 64, i64 64, i64 192, i32 0, metadata !1047} ; [ DW_TAG_member ] [pg_session] [line 99, size 64, align 64, offset 192] [from ]
!1047 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1048} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from session]
!1048 = metadata !{i32 786451, metadata !4, null, metadata !"session", i32 76, i64 960, i64 64, i32 0, i32 0, null, metadata !1049, i32 0, null, null} ; [ DW_TAG_structure_type ] [session] [line 76, size 960, align 64, offset 0] [from ]
!1049 = metadata !{metadata !1050, metadata !1051, metadata !1052, metadata !1053, metadata !1056, metadata !1059, metadata !1060, metadata !1064}
!1050 = metadata !{i32 786445, metadata !4, metadata !1048, metadata !"s_count", i32 77, i64 32, i64 32, i64 0, i32 0, metadata !36} ; [ DW_TAG_member ] [s_count] [line 77, size 32, align 32, offset 0] [from u_int]
!1051 = metadata !{i32 786445, metadata !4, metadata !1048, metadata !"s_leader", i32 78, i64 64, i64 64, i64 64, i32 0, metadata !11} ; [ DW_TAG_member ] [s_leader] [line 78, size 64, align 64, offset 64] [from ]
!1052 = metadata !{i32 786445, metadata !4, metadata !1048, metadata !"s_ttyvp", i32 79, i64 64, i64 64, i64 128, i32 0, metadata !381} ; [ DW_TAG_member ] [s_ttyvp] [line 79, size 64, align 64, offset 128] [from ]
!1053 = metadata !{i32 786445, metadata !4, metadata !1048, metadata !"s_ttydp", i32 80, i64 64, i64 64, i64 192, i32 0, metadata !1054} ; [ DW_TAG_member ] [s_ttydp] [line 80, size 64, align 64, offset 192] [from ]
!1054 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1055} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from cdev_priv]
!1055 = metadata !{i32 786451, metadata !4, null, metadata !"cdev_priv", i32 80, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [cdev_priv] [line 80, size 0, align 0, offset 0] [fwd] [from ]
!1056 = metadata !{i32 786445, metadata !4, metadata !1048, metadata !"s_ttyp", i32 81, i64 64, i64 64, i64 256, i32 0, metadata !1057} ; [ DW_TAG_member ] [s_ttyp] [line 81, size 64, align 64, offset 256] [from ]
!1057 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1058} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from tty]
!1058 = metadata !{i32 786451, metadata !857, null, metadata !"tty", i32 162, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [tty] [line 162, size 0, align 0, offset 0] [fwd] [from ]
!1059 = metadata !{i32 786445, metadata !4, metadata !1048, metadata !"s_sid", i32 82, i64 32, i64 32, i64 320, i32 0, metadata !504} ; [ DW_TAG_member ] [s_sid] [line 82, size 32, align 32, offset 320] [from pid_t]
!1060 = metadata !{i32 786445, metadata !4, metadata !1048, metadata !"s_login", i32 84, i64 320, i64 8, i64 352, i32 0, metadata !1061} ; [ DW_TAG_member ] [s_login] [line 84, size 320, align 8, offset 352] [from ]
!1061 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 320, i64 8, i32 0, i32 0, metadata !34, metadata !1062, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 320, align 8, offset 0] [from char]
!1062 = metadata !{metadata !1063}
!1063 = metadata !{i32 786465, i64 0, i64 40}     ; [ DW_TAG_subrange_type ] [0, 39]
!1064 = metadata !{i32 786445, metadata !4, metadata !1048, metadata !"s_mtx", i32 85, i64 256, i64 64, i64 704, i32 0, metadata !24} ; [ DW_TAG_member ] [s_mtx] [line 85, size 256, align 64, offset 704] [from mtx]
!1065 = metadata !{i32 786445, metadata !4, metadata !1034, metadata !"pg_sigiolst", i32 100, i64 64, i64 64, i64 256, i32 0, metadata !1021} ; [ DW_TAG_member ] [pg_sigiolst] [line 100, size 64, align 64, offset 256] [from sigiolst]
!1066 = metadata !{i32 786445, metadata !4, metadata !1034, metadata !"pg_id", i32 101, i64 32, i64 32, i64 320, i32 0, metadata !504} ; [ DW_TAG_member ] [pg_id] [line 101, size 32, align 32, offset 320] [from pid_t]
!1067 = metadata !{i32 786445, metadata !4, metadata !1034, metadata !"pg_jobc", i32 102, i64 32, i64 32, i64 352, i32 0, metadata !93} ; [ DW_TAG_member ] [pg_jobc] [line 102, size 32, align 32, offset 352] [from int]
!1068 = metadata !{i32 786445, metadata !4, metadata !1034, metadata !"pg_mtx", i32 103, i64 256, i64 64, i64 384, i32 0, metadata !24} ; [ DW_TAG_member ] [pg_mtx] [line 103, size 256, align 64, offset 384] [from mtx]
!1069 = metadata !{i32 786445, metadata !1022, metadata !1026, metadata !"sio_pgsigio", i32 51, i64 64, i64 64, i64 64, i32 0, metadata !1070} ; [ DW_TAG_member ] [sio_pgsigio] [line 51, size 64, align 64, offset 64] [from ]
!1070 = metadata !{i32 786451, metadata !1022, metadata !1026, metadata !"", i32 51, i64 64, i64 64, i32 0, i32 0, null, metadata !1071, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 51, size 64, align 64, offset 0] [from ]
!1071 = metadata !{metadata !1072}
!1072 = metadata !{i32 786445, metadata !1022, metadata !1070, metadata !"sle_next", i32 51, i64 64, i64 64, i64 0, i32 0, metadata !1025} ; [ DW_TAG_member ] [sle_next] [line 51, size 64, align 64, offset 0] [from ]
!1073 = metadata !{i32 786445, metadata !1022, metadata !1026, metadata !"sio_myref", i32 52, i64 64, i64 64, i64 128, i32 0, metadata !1074} ; [ DW_TAG_member ] [sio_myref] [line 52, size 64, align 64, offset 128] [from ]
!1074 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1025} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!1075 = metadata !{i32 786445, metadata !1022, metadata !1026, metadata !"sio_ucred", i32 54, i64 64, i64 64, i64 192, i32 0, metadata !253} ; [ DW_TAG_member ] [sio_ucred] [line 54, size 64, align 64, offset 192] [from ]
!1076 = metadata !{i32 786445, metadata !1022, metadata !1026, metadata !"sio_pgid", i32 55, i64 32, i64 32, i64 256, i32 0, metadata !504} ; [ DW_TAG_member ] [sio_pgid] [line 55, size 32, align 32, offset 256] [from pid_t]
!1077 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_sigparent", i32 535, i64 32, i64 32, i64 5824, i32 0, metadata !93} ; [ DW_TAG_member ] [p_sigparent] [line 535, size 32, align 32, offset 5824] [from int]
!1078 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_sig", i32 536, i64 32, i64 32, i64 5856, i32 0, metadata !93} ; [ DW_TAG_member ] [p_sig] [line 536, size 32, align 32, offset 5856] [from int]
!1079 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_code", i32 537, i64 64, i64 64, i64 5888, i32 0, metadata !577} ; [ DW_TAG_member ] [p_code] [line 537, size 64, align 64, offset 5888] [from u_long]
!1080 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_stops", i32 538, i64 32, i64 32, i64 5952, i32 0, metadata !36} ; [ DW_TAG_member ] [p_stops] [line 538, size 32, align 32, offset 5952] [from u_int]
!1081 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_stype", i32 539, i64 32, i64 32, i64 5984, i32 0, metadata !36} ; [ DW_TAG_member ] [p_stype] [line 539, size 32, align 32, offset 5984] [from u_int]
!1082 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_step", i32 540, i64 8, i64 8, i64 6016, i32 0, metadata !34} ; [ DW_TAG_member ] [p_step] [line 540, size 8, align 8, offset 6016] [from char]
!1083 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_pfsflags", i32 541, i64 8, i64 8, i64 6024, i32 0, metadata !221} ; [ DW_TAG_member ] [p_pfsflags] [line 541, size 8, align 8, offset 6024] [from u_char]
!1084 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_nlminfo", i32 542, i64 64, i64 64, i64 6080, i32 0, metadata !1085} ; [ DW_TAG_member ] [p_nlminfo] [line 542, size 64, align 64, offset 6080] [from ]
!1085 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1086} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from nlminfo]
!1086 = metadata !{i32 786451, metadata !4, null, metadata !"nlminfo", i32 166, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [nlminfo] [line 166, size 0, align 0, offset 0] [fwd] [from ]
!1087 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_aioinfo", i32 543, i64 64, i64 64, i64 6144, i32 0, metadata !1088} ; [ DW_TAG_member ] [p_aioinfo] [line 543, size 64, align 64, offset 6144] [from ]
!1088 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1089} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from kaioinfo]
!1089 = metadata !{i32 786451, metadata !4, null, metadata !"kaioinfo", i32 161, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [kaioinfo] [line 161, size 0, align 0, offset 0] [fwd] [from ]
!1090 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_singlethread", i32 544, i64 64, i64 64, i64 6208, i32 0, metadata !18} ; [ DW_TAG_member ] [p_singlethread] [line 544, size 64, align 64, offset 6208] [from ]
!1091 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_suspcount", i32 545, i64 32, i64 32, i64 6272, i32 0, metadata !93} ; [ DW_TAG_member ] [p_suspcount] [line 545, size 32, align 32, offset 6272] [from int]
!1092 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_xthread", i32 546, i64 64, i64 64, i64 6336, i32 0, metadata !18} ; [ DW_TAG_member ] [p_xthread] [line 546, size 64, align 64, offset 6336] [from ]
!1093 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_boundary_count", i32 547, i64 32, i64 32, i64 6400, i32 0, metadata !93} ; [ DW_TAG_member ] [p_boundary_count] [line 547, size 32, align 32, offset 6400] [from int]
!1094 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_pendingcnt", i32 548, i64 32, i64 32, i64 6432, i32 0, metadata !93} ; [ DW_TAG_member ] [p_pendingcnt] [line 548, size 32, align 32, offset 6432] [from int]
!1095 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_itimers", i32 549, i64 64, i64 64, i64 6464, i32 0, metadata !1096} ; [ DW_TAG_member ] [p_itimers] [line 549, size 64, align 64, offset 6464] [from ]
!1096 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1097} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from itimers]
!1097 = metadata !{i32 786451, metadata !4, null, metadata !"itimers", i32 549, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [itimers] [line 549, size 0, align 0, offset 0] [fwd] [from ]
!1098 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_procdesc", i32 550, i64 64, i64 64, i64 6528, i32 0, metadata !1099} ; [ DW_TAG_member ] [p_procdesc] [line 550, size 64, align 64, offset 6528] [from ]
!1099 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1100} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from procdesc]
!1100 = metadata !{i32 786451, metadata !4, null, metadata !"procdesc", i32 169, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [procdesc] [line 169, size 0, align 0, offset 0] [fwd] [from ]
!1101 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_magic", i32 556, i64 32, i64 32, i64 6592, i32 0, metadata !36} ; [ DW_TAG_member ] [p_magic] [line 556, size 32, align 32, offset 6592] [from u_int]
!1102 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_osrel", i32 557, i64 32, i64 32, i64 6624, i32 0, metadata !93} ; [ DW_TAG_member ] [p_osrel] [line 557, size 32, align 32, offset 6624] [from int]
!1103 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_comm", i32 559, i64 160, i64 8, i64 6656, i32 0, metadata !580} ; [ DW_TAG_member ] [p_comm] [line 559, size 160, align 8, offset 6656] [from ]
!1104 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_pgrp", i32 560, i64 64, i64 64, i64 6848, i32 0, metadata !1033} ; [ DW_TAG_member ] [p_pgrp] [line 560, size 64, align 64, offset 6848] [from ]
!1105 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_sysent", i32 561, i64 64, i64 64, i64 6912, i32 0, metadata !1106} ; [ DW_TAG_member ] [p_sysent] [line 561, size 64, align 64, offset 6912] [from ]
!1106 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1107} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from sysentvec]
!1107 = metadata !{i32 786451, metadata !4, null, metadata !"sysentvec", i32 561, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [sysentvec] [line 561, size 0, align 0, offset 0] [fwd] [from ]
!1108 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_args", i32 562, i64 64, i64 64, i64 6976, i32 0, metadata !1109} ; [ DW_TAG_member ] [p_args] [line 562, size 64, align 64, offset 6976] [from ]
!1109 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1110} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from pargs]
!1110 = metadata !{i32 786451, metadata !4, null, metadata !"pargs", i32 109, i64 96, i64 32, i32 0, i32 0, null, metadata !1111, i32 0, null, null} ; [ DW_TAG_structure_type ] [pargs] [line 109, size 96, align 32, offset 0] [from ]
!1111 = metadata !{metadata !1112, metadata !1113, metadata !1114}
!1112 = metadata !{i32 786445, metadata !4, metadata !1110, metadata !"ar_ref", i32 110, i64 32, i64 32, i64 0, i32 0, metadata !36} ; [ DW_TAG_member ] [ar_ref] [line 110, size 32, align 32, offset 0] [from u_int]
!1113 = metadata !{i32 786445, metadata !4, metadata !1110, metadata !"ar_length", i32 111, i64 32, i64 32, i64 32, i32 0, metadata !36} ; [ DW_TAG_member ] [ar_length] [line 111, size 32, align 32, offset 32] [from u_int]
!1114 = metadata !{i32 786445, metadata !4, metadata !1110, metadata !"ar_args", i32 112, i64 8, i64 8, i64 64, i32 0, metadata !1115} ; [ DW_TAG_member ] [ar_args] [line 112, size 8, align 8, offset 64] [from ]
!1115 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 8, i64 8, i32 0, i32 0, metadata !221, metadata !88, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 8, align 8, offset 0] [from u_char]
!1116 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_cpulimit", i32 563, i64 64, i64 64, i64 7040, i32 0, metadata !943} ; [ DW_TAG_member ] [p_cpulimit] [line 563, size 64, align 64, offset 7040] [from rlim_t]
!1117 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_nice", i32 564, i64 8, i64 8, i64 7104, i32 0, metadata !1118} ; [ DW_TAG_member ] [p_nice] [line 564, size 8, align 8, offset 7104] [from signed char]
!1118 = metadata !{i32 786468, null, null, metadata !"signed char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ] [signed char] [line 0, size 8, align 8, offset 0, enc DW_ATE_signed_char]
!1119 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_fibnum", i32 565, i64 32, i64 32, i64 7136, i32 0, metadata !93} ; [ DW_TAG_member ] [p_fibnum] [line 565, size 32, align 32, offset 7136] [from int]
!1120 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_xstat", i32 569, i64 16, i64 16, i64 7168, i32 0, metadata !340} ; [ DW_TAG_member ] [p_xstat] [line 569, size 16, align 16, offset 7168] [from u_short]
!1121 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_klist", i32 570, i64 384, i64 64, i64 7232, i32 0, metadata !663} ; [ DW_TAG_member ] [p_klist] [line 570, size 384, align 64, offset 7232] [from knlist]
!1122 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_numthreads", i32 571, i64 32, i64 32, i64 7616, i32 0, metadata !93} ; [ DW_TAG_member ] [p_numthreads] [line 571, size 32, align 32, offset 7616] [from int]
!1123 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_md", i32 572, i64 192, i64 64, i64 7680, i32 0, metadata !1124} ; [ DW_TAG_member ] [p_md] [line 572, size 192, align 64, offset 7680] [from mdproc]
!1124 = metadata !{i32 786451, metadata !868, null, metadata !"mdproc", i32 52, i64 192, i64 64, i32 0, i32 0, null, metadata !1125, i32 0, null, null} ; [ DW_TAG_structure_type ] [mdproc] [line 52, size 192, align 64, offset 0] [from ]
!1125 = metadata !{metadata !1126, metadata !1132}
!1126 = metadata !{i32 786445, metadata !868, metadata !1124, metadata !"md_ldt", i32 53, i64 64, i64 64, i64 0, i32 0, metadata !1127} ; [ DW_TAG_member ] [md_ldt] [line 53, size 64, align 64, offset 0] [from ]
!1127 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1128} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from proc_ldt]
!1128 = metadata !{i32 786451, metadata !868, null, metadata !"proc_ldt", i32 38, i64 128, i64 64, i32 0, i32 0, null, metadata !1129, i32 0, null, null} ; [ DW_TAG_structure_type ] [proc_ldt] [line 38, size 128, align 64, offset 0] [from ]
!1129 = metadata !{metadata !1130, metadata !1131}
!1130 = metadata !{i32 786445, metadata !868, metadata !1128, metadata !"ldt_base", i32 39, i64 64, i64 64, i64 0, i32 0, metadata !929} ; [ DW_TAG_member ] [ldt_base] [line 39, size 64, align 64, offset 0] [from caddr_t]
!1131 = metadata !{i32 786445, metadata !868, metadata !1128, metadata !"ldt_refcnt", i32 40, i64 32, i64 32, i64 64, i32 0, metadata !93} ; [ DW_TAG_member ] [ldt_refcnt] [line 40, size 32, align 32, offset 64] [from int]
!1132 = metadata !{i32 786445, metadata !868, metadata !1124, metadata !"md_ldt_sd", i32 54, i64 128, i64 8, i64 64, i32 0, metadata !1133} ; [ DW_TAG_member ] [md_ldt_sd] [line 54, size 128, align 8, offset 64] [from system_segment_descriptor]
!1133 = metadata !{i32 786451, metadata !1134, null, metadata !"system_segment_descriptor", i32 49, i64 128, i64 8, i32 0, i32 0, null, metadata !1135, i32 0, null, null} ; [ DW_TAG_structure_type ] [system_segment_descriptor] [line 49, size 128, align 8, offset 0] [from ]
!1134 = metadata !{metadata !"./machine/segments.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!1135 = metadata !{metadata !1136, metadata !1137, metadata !1138, metadata !1139, metadata !1140, metadata !1141, metadata !1142, metadata !1143, metadata !1144, metadata !1145, metadata !1146, metadata !1147}
!1136 = metadata !{i32 786445, metadata !1134, metadata !1133, metadata !"sd_lolimit", i32 50, i64 16, i64 64, i64 0, i32 0, metadata !507} ; [ DW_TAG_member ] [sd_lolimit] [line 50, size 16, align 64, offset 0] [from u_int64_t]
!1137 = metadata !{i32 786445, metadata !1134, metadata !1133, metadata !"sd_lobase", i32 51, i64 24, i64 64, i64 16, i32 0, metadata !507} ; [ DW_TAG_member ] [sd_lobase] [line 51, size 24, align 64, offset 16] [from u_int64_t]
!1138 = metadata !{i32 786445, metadata !1134, metadata !1133, metadata !"sd_type", i32 52, i64 5, i64 64, i64 40, i32 0, metadata !507} ; [ DW_TAG_member ] [sd_type] [line 52, size 5, align 64, offset 40] [from u_int64_t]
!1139 = metadata !{i32 786445, metadata !1134, metadata !1133, metadata !"sd_dpl", i32 53, i64 2, i64 64, i64 45, i32 0, metadata !507} ; [ DW_TAG_member ] [sd_dpl] [line 53, size 2, align 64, offset 45] [from u_int64_t]
!1140 = metadata !{i32 786445, metadata !1134, metadata !1133, metadata !"sd_p", i32 54, i64 1, i64 64, i64 47, i32 0, metadata !507} ; [ DW_TAG_member ] [sd_p] [line 54, size 1, align 64, offset 47] [from u_int64_t]
!1141 = metadata !{i32 786445, metadata !1134, metadata !1133, metadata !"sd_hilimit", i32 55, i64 4, i64 64, i64 48, i32 0, metadata !507} ; [ DW_TAG_member ] [sd_hilimit] [line 55, size 4, align 64, offset 48] [from u_int64_t]
!1142 = metadata !{i32 786445, metadata !1134, metadata !1133, metadata !"sd_xx0", i32 56, i64 3, i64 64, i64 52, i32 0, metadata !507} ; [ DW_TAG_member ] [sd_xx0] [line 56, size 3, align 64, offset 52] [from u_int64_t]
!1143 = metadata !{i32 786445, metadata !1134, metadata !1133, metadata !"sd_gran", i32 57, i64 1, i64 64, i64 55, i32 0, metadata !507} ; [ DW_TAG_member ] [sd_gran] [line 57, size 1, align 64, offset 55] [from u_int64_t]
!1144 = metadata !{i32 786445, metadata !1134, metadata !1133, metadata !"sd_hibase", i32 58, i64 40, i64 64, i64 56, i32 0, metadata !507} ; [ DW_TAG_member ] [sd_hibase] [line 58, size 40, align 64, offset 56] [from u_int64_t]
!1145 = metadata !{i32 786445, metadata !1134, metadata !1133, metadata !"sd_xx1", i32 59, i64 8, i64 64, i64 96, i32 0, metadata !507} ; [ DW_TAG_member ] [sd_xx1] [line 59, size 8, align 64, offset 96] [from u_int64_t]
!1146 = metadata !{i32 786445, metadata !1134, metadata !1133, metadata !"sd_mbz", i32 60, i64 5, i64 64, i64 104, i32 0, metadata !507} ; [ DW_TAG_member ] [sd_mbz] [line 60, size 5, align 64, offset 104] [from u_int64_t]
!1147 = metadata !{i32 786445, metadata !1134, metadata !1133, metadata !"sd_xx2", i32 61, i64 19, i64 64, i64 109, i32 0, metadata !507} ; [ DW_TAG_member ] [sd_xx2] [line 61, size 19, align 64, offset 109] [from u_int64_t]
!1148 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_itcallout", i32 573, i64 512, i64 64, i64 7872, i32 0, metadata !822} ; [ DW_TAG_member ] [p_itcallout] [line 573, size 512, align 64, offset 7872] [from callout]
!1149 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_acflag", i32 574, i64 16, i64 16, i64 8384, i32 0, metadata !340} ; [ DW_TAG_member ] [p_acflag] [line 574, size 16, align 16, offset 8384] [from u_short]
!1150 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_peers", i32 575, i64 64, i64 64, i64 8448, i32 0, metadata !11} ; [ DW_TAG_member ] [p_peers] [line 575, size 64, align 64, offset 8448] [from ]
!1151 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_leader", i32 576, i64 64, i64 64, i64 8512, i32 0, metadata !11} ; [ DW_TAG_member ] [p_leader] [line 576, size 64, align 64, offset 8512] [from ]
!1152 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_emuldata", i32 577, i64 64, i64 64, i64 8576, i32 0, metadata !178} ; [ DW_TAG_member ] [p_emuldata] [line 577, size 64, align 64, offset 8576] [from ]
!1153 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_label", i32 578, i64 64, i64 64, i64 8640, i32 0, metadata !478} ; [ DW_TAG_member ] [p_label] [line 578, size 64, align 64, offset 8640] [from ]
!1154 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_sched", i32 579, i64 64, i64 64, i64 8704, i32 0, metadata !1155} ; [ DW_TAG_member ] [p_sched] [line 579, size 64, align 64, offset 8704] [from ]
!1155 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1156} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from p_sched]
!1156 = metadata !{i32 786451, metadata !4, null, metadata !"p_sched", i32 167, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [p_sched] [line 167, size 0, align 0, offset 0] [fwd] [from ]
!1157 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_ktr", i32 580, i64 128, i64 64, i64 8768, i32 0, metadata !1158} ; [ DW_TAG_member ] [p_ktr] [line 580, size 128, align 64, offset 8768] [from ]
!1158 = metadata !{i32 786451, metadata !4, metadata !5, metadata !"", i32 580, i64 128, i64 64, i32 0, i32 0, null, metadata !1159, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 580, size 128, align 64, offset 0] [from ]
!1159 = metadata !{metadata !1160, metadata !1163}
!1160 = metadata !{i32 786445, metadata !4, metadata !1158, metadata !"stqh_first", i32 580, i64 64, i64 64, i64 0, i32 0, metadata !1161} ; [ DW_TAG_member ] [stqh_first] [line 580, size 64, align 64, offset 0] [from ]
!1161 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1162} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ktr_request]
!1162 = metadata !{i32 786451, metadata !4, null, metadata !"ktr_request", i32 580, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [ktr_request] [line 580, size 0, align 0, offset 0] [fwd] [from ]
!1163 = metadata !{i32 786445, metadata !4, metadata !1158, metadata !"stqh_last", i32 580, i64 64, i64 64, i64 64, i32 0, metadata !1164} ; [ DW_TAG_member ] [stqh_last] [line 580, size 64, align 64, offset 64] [from ]
!1164 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1161} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!1165 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_mqnotifier", i32 581, i64 64, i64 64, i64 8896, i32 0, metadata !1166} ; [ DW_TAG_member ] [p_mqnotifier] [line 581, size 64, align 64, offset 8896] [from ]
!1166 = metadata !{i32 786451, metadata !4, metadata !5, metadata !"", i32 581, i64 64, i64 64, i32 0, i32 0, null, metadata !1167, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 581, size 64, align 64, offset 0] [from ]
!1167 = metadata !{metadata !1168}
!1168 = metadata !{i32 786445, metadata !4, metadata !1166, metadata !"lh_first", i32 581, i64 64, i64 64, i64 0, i32 0, metadata !1169} ; [ DW_TAG_member ] [lh_first] [line 581, size 64, align 64, offset 0] [from ]
!1169 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1170} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from mqueue_notifier]
!1170 = metadata !{i32 786451, metadata !4, null, metadata !"mqueue_notifier", i32 165, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [mqueue_notifier] [line 165, size 0, align 0, offset 0] [fwd] [from ]
!1171 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_dtrace", i32 582, i64 64, i64 64, i64 8960, i32 0, metadata !1172} ; [ DW_TAG_member ] [p_dtrace] [line 582, size 64, align 64, offset 8960] [from ]
!1172 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1173} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from kdtrace_proc]
!1173 = metadata !{i32 786451, metadata !4, null, metadata !"kdtrace_proc", i32 163, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [kdtrace_proc] [line 163, size 0, align 0, offset 0] [fwd] [from ]
!1174 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_pwait", i32 583, i64 128, i64 64, i64 9024, i32 0, metadata !1175} ; [ DW_TAG_member ] [p_pwait] [line 583, size 128, align 64, offset 9024] [from cv]
!1175 = metadata !{i32 786451, metadata !1176, null, metadata !"cv", i32 46, i64 128, i64 64, i32 0, i32 0, null, metadata !1177, i32 0, null, null} ; [ DW_TAG_structure_type ] [cv] [line 46, size 128, align 64, offset 0] [from ]
!1176 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/condvar.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!1177 = metadata !{metadata !1178, metadata !1179}
!1178 = metadata !{i32 786445, metadata !1176, metadata !1175, metadata !"cv_description", i32 47, i64 64, i64 64, i64 0, i32 0, metadata !32} ; [ DW_TAG_member ] [cv_description] [line 47, size 64, align 64, offset 0] [from ]
!1179 = metadata !{i32 786445, metadata !1176, metadata !1175, metadata !"cv_waiters", i32 48, i64 32, i64 32, i64 64, i32 0, metadata !93} ; [ DW_TAG_member ] [cv_waiters] [line 48, size 32, align 32, offset 64] [from int]
!1180 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_dbgwait", i32 584, i64 128, i64 64, i64 9152, i32 0, metadata !1175} ; [ DW_TAG_member ] [p_dbgwait] [line 584, size 128, align 64, offset 9152] [from cv]
!1181 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_prev_runtime", i32 586, i64 64, i64 64, i64 9280, i32 0, metadata !549} ; [ DW_TAG_member ] [p_prev_runtime] [line 586, size 64, align 64, offset 9280] [from uint64_t]
!1182 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_racct", i32 587, i64 64, i64 64, i64 9344, i32 0, metadata !288} ; [ DW_TAG_member ] [p_racct] [line 587, size 64, align 64, offset 9344] [from ]
!1183 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_throttled", i32 588, i64 8, i64 8, i64 9408, i32 0, metadata !221} ; [ DW_TAG_member ] [p_throttled] [line 588, size 8, align 8, offset 9408] [from u_char]
!1184 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_orphan", i32 595, i64 128, i64 64, i64 9472, i32 0, metadata !1185} ; [ DW_TAG_member ] [p_orphan] [line 595, size 128, align 64, offset 9472] [from ]
!1185 = metadata !{i32 786451, metadata !4, metadata !5, metadata !"", i32 595, i64 128, i64 64, i32 0, i32 0, null, metadata !1186, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 595, size 128, align 64, offset 0] [from ]
!1186 = metadata !{metadata !1187, metadata !1188}
!1187 = metadata !{i32 786445, metadata !4, metadata !1185, metadata !"le_next", i32 595, i64 64, i64 64, i64 0, i32 0, metadata !11} ; [ DW_TAG_member ] [le_next] [line 595, size 64, align 64, offset 0] [from ]
!1188 = metadata !{i32 786445, metadata !4, metadata !1185, metadata !"le_prev", i32 595, i64 64, i64 64, i64 64, i32 0, metadata !13} ; [ DW_TAG_member ] [le_prev] [line 595, size 64, align 64, offset 64] [from ]
!1189 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_orphans", i32 596, i64 64, i64 64, i64 9600, i32 0, metadata !1190} ; [ DW_TAG_member ] [p_orphans] [line 596, size 64, align 64, offset 9600] [from ]
!1190 = metadata !{i32 786451, metadata !4, metadata !5, metadata !"", i32 596, i64 64, i64 64, i32 0, i32 0, null, metadata !1191, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 596, size 64, align 64, offset 0] [from ]
!1191 = metadata !{metadata !1192}
!1192 = metadata !{i32 786445, metadata !4, metadata !1190, metadata !"lh_first", i32 596, i64 64, i64 64, i64 0, i32 0, metadata !11} ; [ DW_TAG_member ] [lh_first] [line 596, size 64, align 64, offset 0] [from ]
!1193 = metadata !{metadata !1194, metadata !1195, metadata !1196}
!1194 = metadata !{i32 786472, metadata !"PRS_NEW", i64 0} ; [ DW_TAG_enumerator ] [PRS_NEW :: 0]
!1195 = metadata !{i32 786472, metadata !"PRS_NORMAL", i64 1} ; [ DW_TAG_enumerator ] [PRS_NORMAL :: 1]
!1196 = metadata !{i32 786472, metadata !"PRS_ZOMBIE", i64 2} ; [ DW_TAG_enumerator ] [PRS_ZOMBIE :: 2]
!1197 = metadata !{i32 786436, metadata !1198, null, metadata !"sysinit_sub_id", i32 88, i64 32, i64 32, i32 0, i32 0, null, metadata !1199, i32 0, i32 0} ; [ DW_TAG_enumeration_type ] [sysinit_sub_id] [line 88, size 32, align 32, offset 0] [from ]
!1198 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/kernel.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!1199 = metadata !{metadata !1200, metadata !1201, metadata !1202, metadata !1203, metadata !1204, metadata !1205, metadata !1206, metadata !1207, metadata !1208, metadata !1209, metadata !1210, metadata !1211, metadata !1212, metadata !1213, metadata !1214, metadata !1215, metadata !1216, metadata !1217, metadata !1218, metadata !1219, metadata !1220, metadata !1221, metadata !1222, metadata !1223, metadata !1224, metadata !1225, metadata !1226, metadata !1227, metadata !1228, metadata !1229, metadata !1230, metadata !1231, metadata !1232, metadata !1233, metadata !1234, metadata !1235, metadata !1236, metadata !1237, metadata !1238, metadata !1239, metadata !1240, metadata !1241, metadata !1242, metadata !1243, metadata !1244, metadata !1245, metadata !1246, metadata !1247, metadata !1248, metadata !1249, metadata !1250, metadata !1251, metadata !1252, metadata !1253, metadata !1254, metadata !1255, metadata !1256, metadata !1257, metadata !1258, metadata !1259, metadata !1260, metadata !1261, metadata !1262, metadata !1263, metadata !1264, metadata !1265, metadata !1266, metadata !1267, metadata !1268, metadata !1269, metadata !1270, metadata !1271, metadata !1272, metadata !1273, metadata !1274, metadata !1275, metadata !1276, metadata !1277, metadata !1278, metadata !1279, metadata !1280}
!1200 = metadata !{i32 786472, metadata !"SI_SUB_DUMMY", i64 0} ; [ DW_TAG_enumerator ] [SI_SUB_DUMMY :: 0]
!1201 = metadata !{i32 786472, metadata !"SI_SUB_DONE", i64 1} ; [ DW_TAG_enumerator ] [SI_SUB_DONE :: 1]
!1202 = metadata !{i32 786472, metadata !"SI_SUB_TUNABLES", i64 7340032} ; [ DW_TAG_enumerator ] [SI_SUB_TUNABLES :: 7340032]
!1203 = metadata !{i32 786472, metadata !"SI_SUB_COPYRIGHT", i64 8388609} ; [ DW_TAG_enumerator ] [SI_SUB_COPYRIGHT :: 8388609]
!1204 = metadata !{i32 786472, metadata !"SI_SUB_SETTINGS", i64 8912896} ; [ DW_TAG_enumerator ] [SI_SUB_SETTINGS :: 8912896]
!1205 = metadata !{i32 786472, metadata !"SI_SUB_MTX_POOL_STATIC", i64 9437184} ; [ DW_TAG_enumerator ] [SI_SUB_MTX_POOL_STATIC :: 9437184]
!1206 = metadata !{i32 786472, metadata !"SI_SUB_LOCKMGR", i64 9961472} ; [ DW_TAG_enumerator ] [SI_SUB_LOCKMGR :: 9961472]
!1207 = metadata !{i32 786472, metadata !"SI_SUB_VM", i64 16777216} ; [ DW_TAG_enumerator ] [SI_SUB_VM :: 16777216]
!1208 = metadata !{i32 786472, metadata !"SI_SUB_KMEM", i64 25165824} ; [ DW_TAG_enumerator ] [SI_SUB_KMEM :: 25165824]
!1209 = metadata !{i32 786472, metadata !"SI_SUB_KVM_RSRC", i64 27262976} ; [ DW_TAG_enumerator ] [SI_SUB_KVM_RSRC :: 27262976]
!1210 = metadata !{i32 786472, metadata !"SI_SUB_WITNESS", i64 27787264} ; [ DW_TAG_enumerator ] [SI_SUB_WITNESS :: 27787264]
!1211 = metadata !{i32 786472, metadata !"SI_SUB_MTX_POOL_DYNAMIC", i64 28049408} ; [ DW_TAG_enumerator ] [SI_SUB_MTX_POOL_DYNAMIC :: 28049408]
!1212 = metadata !{i32 786472, metadata !"SI_SUB_LOCK", i64 28311552} ; [ DW_TAG_enumerator ] [SI_SUB_LOCK :: 28311552]
!1213 = metadata !{i32 786472, metadata !"SI_SUB_EVENTHANDLER", i64 29360128} ; [ DW_TAG_enumerator ] [SI_SUB_EVENTHANDLER :: 29360128]
!1214 = metadata !{i32 786472, metadata !"SI_SUB_TESLA", i64 29884416} ; [ DW_TAG_enumerator ] [SI_SUB_TESLA :: 29884416]
!1215 = metadata !{i32 786472, metadata !"SI_SUB_VNET_PRELINK", i64 31457280} ; [ DW_TAG_enumerator ] [SI_SUB_VNET_PRELINK :: 31457280]
!1216 = metadata !{i32 786472, metadata !"SI_SUB_KLD", i64 33554432} ; [ DW_TAG_enumerator ] [SI_SUB_KLD :: 33554432]
!1217 = metadata !{i32 786472, metadata !"SI_SUB_CPU", i64 34603008} ; [ DW_TAG_enumerator ] [SI_SUB_CPU :: 34603008]
!1218 = metadata !{i32 786472, metadata !"SI_SUB_RACCT", i64 34668544} ; [ DW_TAG_enumerator ] [SI_SUB_RACCT :: 34668544]
!1219 = metadata !{i32 786472, metadata !"SI_SUB_RANDOM", i64 34734080} ; [ DW_TAG_enumerator ] [SI_SUB_RANDOM :: 34734080]
!1220 = metadata !{i32 786472, metadata !"SI_SUB_KDTRACE", i64 34865152} ; [ DW_TAG_enumerator ] [SI_SUB_KDTRACE :: 34865152]
!1221 = metadata !{i32 786472, metadata !"SI_SUB_MAC", i64 35127296} ; [ DW_TAG_enumerator ] [SI_SUB_MAC :: 35127296]
!1222 = metadata !{i32 786472, metadata !"SI_SUB_MAC_POLICY", i64 35389440} ; [ DW_TAG_enumerator ] [SI_SUB_MAC_POLICY :: 35389440]
!1223 = metadata !{i32 786472, metadata !"SI_SUB_MAC_LATE", i64 35454976} ; [ DW_TAG_enumerator ] [SI_SUB_MAC_LATE :: 35454976]
!1224 = metadata !{i32 786472, metadata !"SI_SUB_VNET", i64 35520512} ; [ DW_TAG_enumerator ] [SI_SUB_VNET :: 35520512]
!1225 = metadata !{i32 786472, metadata !"SI_SUB_INTRINSIC", i64 35651584} ; [ DW_TAG_enumerator ] [SI_SUB_INTRINSIC :: 35651584]
!1226 = metadata !{i32 786472, metadata !"SI_SUB_VM_CONF", i64 36700160} ; [ DW_TAG_enumerator ] [SI_SUB_VM_CONF :: 36700160]
!1227 = metadata !{i32 786472, metadata !"SI_SUB_DDB_SERVICES", i64 37224448} ; [ DW_TAG_enumerator ] [SI_SUB_DDB_SERVICES :: 37224448]
!1228 = metadata !{i32 786472, metadata !"SI_SUB_RUN_QUEUE", i64 37748736} ; [ DW_TAG_enumerator ] [SI_SUB_RUN_QUEUE :: 37748736]
!1229 = metadata !{i32 786472, metadata !"SI_SUB_KTRACE", i64 38273024} ; [ DW_TAG_enumerator ] [SI_SUB_KTRACE :: 38273024]
!1230 = metadata !{i32 786472, metadata !"SI_SUB_OPENSOLARIS", i64 38338560} ; [ DW_TAG_enumerator ] [SI_SUB_OPENSOLARIS :: 38338560]
!1231 = metadata !{i32 786472, metadata !"SI_SUB_CYCLIC", i64 38404096} ; [ DW_TAG_enumerator ] [SI_SUB_CYCLIC :: 38404096]
!1232 = metadata !{i32 786472, metadata !"SI_SUB_AUDIT", i64 38535168} ; [ DW_TAG_enumerator ] [SI_SUB_AUDIT :: 38535168]
!1233 = metadata !{i32 786472, metadata !"SI_SUB_CREATE_INIT", i64 38797312} ; [ DW_TAG_enumerator ] [SI_SUB_CREATE_INIT :: 38797312]
!1234 = metadata !{i32 786472, metadata !"SI_SUB_SCHED_IDLE", i64 39845888} ; [ DW_TAG_enumerator ] [SI_SUB_SCHED_IDLE :: 39845888]
!1235 = metadata !{i32 786472, metadata !"SI_SUB_MBUF", i64 40894464} ; [ DW_TAG_enumerator ] [SI_SUB_MBUF :: 40894464]
!1236 = metadata !{i32 786472, metadata !"SI_SUB_INTR", i64 41943040} ; [ DW_TAG_enumerator ] [SI_SUB_INTR :: 41943040]
!1237 = metadata !{i32 786472, metadata !"SI_SUB_SOFTINTR", i64 41943041} ; [ DW_TAG_enumerator ] [SI_SUB_SOFTINTR :: 41943041]
!1238 = metadata !{i32 786472, metadata !"SI_SUB_ACL", i64 42991616} ; [ DW_TAG_enumerator ] [SI_SUB_ACL :: 42991616]
!1239 = metadata !{i32 786472, metadata !"SI_SUB_DEVFS", i64 49283072} ; [ DW_TAG_enumerator ] [SI_SUB_DEVFS :: 49283072]
!1240 = metadata !{i32 786472, metadata !"SI_SUB_INIT_IF", i64 50331648} ; [ DW_TAG_enumerator ] [SI_SUB_INIT_IF :: 50331648]
!1241 = metadata !{i32 786472, metadata !"SI_SUB_NETGRAPH", i64 50397184} ; [ DW_TAG_enumerator ] [SI_SUB_NETGRAPH :: 50397184]
!1242 = metadata !{i32 786472, metadata !"SI_SUB_DTRACE", i64 50462720} ; [ DW_TAG_enumerator ] [SI_SUB_DTRACE :: 50462720]
!1243 = metadata !{i32 786472, metadata !"SI_SUB_DTRACE_PROVIDER", i64 50626560} ; [ DW_TAG_enumerator ] [SI_SUB_DTRACE_PROVIDER :: 50626560]
!1244 = metadata !{i32 786472, metadata !"SI_SUB_DTRACE_ANON", i64 50905088} ; [ DW_TAG_enumerator ] [SI_SUB_DTRACE_ANON :: 50905088]
!1245 = metadata !{i32 786472, metadata !"SI_SUB_DRIVERS", i64 51380224} ; [ DW_TAG_enumerator ] [SI_SUB_DRIVERS :: 51380224]
!1246 = metadata !{i32 786472, metadata !"SI_SUB_CONFIGURE", i64 58720256} ; [ DW_TAG_enumerator ] [SI_SUB_CONFIGURE :: 58720256]
!1247 = metadata !{i32 786472, metadata !"SI_SUB_VFS", i64 67108864} ; [ DW_TAG_enumerator ] [SI_SUB_VFS :: 67108864]
!1248 = metadata !{i32 786472, metadata !"SI_SUB_CLOCKS", i64 75497472} ; [ DW_TAG_enumerator ] [SI_SUB_CLOCKS :: 75497472]
!1249 = metadata !{i32 786472, metadata !"SI_SUB_CLIST", i64 92274688} ; [ DW_TAG_enumerator ] [SI_SUB_CLIST :: 92274688]
!1250 = metadata !{i32 786472, metadata !"SI_SUB_SYSV_SHM", i64 104857600} ; [ DW_TAG_enumerator ] [SI_SUB_SYSV_SHM :: 104857600]
!1251 = metadata !{i32 786472, metadata !"SI_SUB_SYSV_SEM", i64 109051904} ; [ DW_TAG_enumerator ] [SI_SUB_SYSV_SEM :: 109051904]
!1252 = metadata !{i32 786472, metadata !"SI_SUB_SYSV_MSG", i64 113246208} ; [ DW_TAG_enumerator ] [SI_SUB_SYSV_MSG :: 113246208]
!1253 = metadata !{i32 786472, metadata !"SI_SUB_P1003_1B", i64 115343360} ; [ DW_TAG_enumerator ] [SI_SUB_P1003_1B :: 115343360]
!1254 = metadata !{i32 786472, metadata !"SI_SUB_PSEUDO", i64 117440512} ; [ DW_TAG_enumerator ] [SI_SUB_PSEUDO :: 117440512]
!1255 = metadata !{i32 786472, metadata !"SI_SUB_EXEC", i64 121634816} ; [ DW_TAG_enumerator ] [SI_SUB_EXEC :: 121634816]
!1256 = metadata !{i32 786472, metadata !"SI_SUB_PROTO_BEGIN", i64 134217728} ; [ DW_TAG_enumerator ] [SI_SUB_PROTO_BEGIN :: 134217728]
!1257 = metadata !{i32 786472, metadata !"SI_SUB_PROTO_IF", i64 138412032} ; [ DW_TAG_enumerator ] [SI_SUB_PROTO_IF :: 138412032]
!1258 = metadata !{i32 786472, metadata !"SI_SUB_PROTO_DOMAININIT", i64 140509184} ; [ DW_TAG_enumerator ] [SI_SUB_PROTO_DOMAININIT :: 140509184]
!1259 = metadata !{i32 786472, metadata !"SI_SUB_PROTO_DOMAIN", i64 142606336} ; [ DW_TAG_enumerator ] [SI_SUB_PROTO_DOMAIN :: 142606336]
!1260 = metadata !{i32 786472, metadata !"SI_SUB_PROTO_IFATTACHDOMAIN", i64 142606337} ; [ DW_TAG_enumerator ] [SI_SUB_PROTO_IFATTACHDOMAIN :: 142606337]
!1261 = metadata !{i32 786472, metadata !"SI_SUB_PROTO_END", i64 150994943} ; [ DW_TAG_enumerator ] [SI_SUB_PROTO_END :: 150994943]
!1262 = metadata !{i32 786472, metadata !"SI_SUB_KPROF", i64 150994944} ; [ DW_TAG_enumerator ] [SI_SUB_KPROF :: 150994944]
!1263 = metadata !{i32 786472, metadata !"SI_SUB_KICK_SCHEDULER", i64 167772160} ; [ DW_TAG_enumerator ] [SI_SUB_KICK_SCHEDULER :: 167772160]
!1264 = metadata !{i32 786472, metadata !"SI_SUB_INT_CONFIG_HOOKS", i64 176160768} ; [ DW_TAG_enumerator ] [SI_SUB_INT_CONFIG_HOOKS :: 176160768]
!1265 = metadata !{i32 786472, metadata !"SI_SUB_ROOT_CONF", i64 184549376} ; [ DW_TAG_enumerator ] [SI_SUB_ROOT_CONF :: 184549376]
!1266 = metadata !{i32 786472, metadata !"SI_SUB_DUMP_CONF", i64 186646528} ; [ DW_TAG_enumerator ] [SI_SUB_DUMP_CONF :: 186646528]
!1267 = metadata !{i32 786472, metadata !"SI_SUB_RAID", i64 188219392} ; [ DW_TAG_enumerator ] [SI_SUB_RAID :: 188219392]
!1268 = metadata !{i32 786472, metadata !"SI_SUB_SWAP", i64 201326592} ; [ DW_TAG_enumerator ] [SI_SUB_SWAP :: 201326592]
!1269 = metadata !{i32 786472, metadata !"SI_SUB_INTRINSIC_POST", i64 218103808} ; [ DW_TAG_enumerator ] [SI_SUB_INTRINSIC_POST :: 218103808]
!1270 = metadata !{i32 786472, metadata !"SI_SUB_SYSCALLS", i64 226492416} ; [ DW_TAG_enumerator ] [SI_SUB_SYSCALLS :: 226492416]
!1271 = metadata !{i32 786472, metadata !"SI_SUB_VNET_DONE", i64 230686720} ; [ DW_TAG_enumerator ] [SI_SUB_VNET_DONE :: 230686720]
!1272 = metadata !{i32 786472, metadata !"SI_SUB_KTHREAD_INIT", i64 234881024} ; [ DW_TAG_enumerator ] [SI_SUB_KTHREAD_INIT :: 234881024]
!1273 = metadata !{i32 786472, metadata !"SI_SUB_KTHREAD_PAGE", i64 239075328} ; [ DW_TAG_enumerator ] [SI_SUB_KTHREAD_PAGE :: 239075328]
!1274 = metadata !{i32 786472, metadata !"SI_SUB_KTHREAD_VM", i64 243269632} ; [ DW_TAG_enumerator ] [SI_SUB_KTHREAD_VM :: 243269632]
!1275 = metadata !{i32 786472, metadata !"SI_SUB_KTHREAD_BUF", i64 245366784} ; [ DW_TAG_enumerator ] [SI_SUB_KTHREAD_BUF :: 245366784]
!1276 = metadata !{i32 786472, metadata !"SI_SUB_KTHREAD_UPDATE", i64 247463936} ; [ DW_TAG_enumerator ] [SI_SUB_KTHREAD_UPDATE :: 247463936]
!1277 = metadata !{i32 786472, metadata !"SI_SUB_KTHREAD_IDLE", i64 249561088} ; [ DW_TAG_enumerator ] [SI_SUB_KTHREAD_IDLE :: 249561088]
!1278 = metadata !{i32 786472, metadata !"SI_SUB_SMP", i64 251658240} ; [ DW_TAG_enumerator ] [SI_SUB_SMP :: 251658240]
!1279 = metadata !{i32 786472, metadata !"SI_SUB_RACCTD", i64 252706816} ; [ DW_TAG_enumerator ] [SI_SUB_RACCTD :: 252706816]
!1280 = metadata !{i32 786472, metadata !"SI_SUB_RUN_SCHEDULER", i64 268435455} ; [ DW_TAG_enumerator ] [SI_SUB_RUN_SCHEDULER :: 268435455]
!1281 = metadata !{i32 786436, metadata !1198, null, metadata !"sysinit_elem_order", i32 176, i64 32, i64 32, i32 0, i32 0, null, metadata !1282, i32 0, i32 0} ; [ DW_TAG_enumeration_type ] [sysinit_elem_order] [line 176, size 32, align 32, offset 0] [from ]
!1282 = metadata !{metadata !1283, metadata !1284, metadata !1285, metadata !1286, metadata !1287, metadata !1288}
!1283 = metadata !{i32 786472, metadata !"SI_ORDER_FIRST", i64 0} ; [ DW_TAG_enumerator ] [SI_ORDER_FIRST :: 0]
!1284 = metadata !{i32 786472, metadata !"SI_ORDER_SECOND", i64 1} ; [ DW_TAG_enumerator ] [SI_ORDER_SECOND :: 1]
!1285 = metadata !{i32 786472, metadata !"SI_ORDER_THIRD", i64 2} ; [ DW_TAG_enumerator ] [SI_ORDER_THIRD :: 2]
!1286 = metadata !{i32 786472, metadata !"SI_ORDER_FOURTH", i64 3} ; [ DW_TAG_enumerator ] [SI_ORDER_FOURTH :: 3]
!1287 = metadata !{i32 786472, metadata !"SI_ORDER_MIDDLE", i64 16777216} ; [ DW_TAG_enumerator ] [SI_ORDER_MIDDLE :: 16777216]
!1288 = metadata !{i32 786472, metadata !"SI_ORDER_ANY", i64 268435455} ; [ DW_TAG_enumerator ] [SI_ORDER_ANY :: 268435455]
!1289 = metadata !{i32 0}
!1290 = metadata !{metadata !1291, metadata !1299, metadata !1306, metadata !1313, metadata !1326, metadata !1335, metadata !1342, metadata !1349, metadata !1356, metadata !1363, metadata !1375, metadata !1379, metadata !1386, metadata !1398, metadata !1407, metadata !1416, metadata !1425, metadata !1434, metadata !1446, metadata !1449, metadata !1461, metadata !1473, metadata !1488, metadata !1503, metadata !1519, metadata !1534, metadata !1541, metadata !1550, metadata !1553, metadata !1556, metadata !1557, metadata !1560, metadata !1563, metadata !1566, metadata !1569, metadata !1570, metadata !1571, metadata !1703, metadata !1879, metadata !1880, metadata !1883, metadata !1886, metadata !1889, metadata !1892, metadata !1895, metadata !1896, metadata !1908, metadata !1911, metadata !1914, metadata !1917, metadata !1929, metadata !1938, metadata !1941, metadata !1944, metadata !1947, metadata !1948, metadata !1949, metadata !1952, metadata !1953, metadata !1954, metadata !1957, metadata !1963, metadata !1968, metadata !1971, metadata !1974, metadata !1975, metadata !1976, metadata !1977}
!1291 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"sys_getpid", metadata !"sys_getpid", metadata !"", i32 104, metadata !1293, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.getpid_args*)* @sys_getpid, null, null, metadata !1289, i32 105} ; [ DW_TAG_subprogram ] [line 104] [def] [scope 105] [sys_getpid]
!1292 = metadata !{i32 786473, metadata !1}       ; [ DW_TAG_file_type ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!1293 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1294, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1294 = metadata !{metadata !93, metadata !18, metadata !1295}
!1295 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1296} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from getpid_args]
!1296 = metadata !{i32 786451, metadata !742, null, metadata !"getpid_args", i32 99, i64 64, i64 64, i32 0, i32 0, null, metadata !1297, i32 0, null, null} ; [ DW_TAG_structure_type ] [getpid_args] [line 99, size 64, align 64, offset 0] [from ]
!1297 = metadata !{metadata !1298}
!1298 = metadata !{i32 786445, metadata !742, metadata !1296, metadata !"dummy", i32 100, i64 64, i64 64, i64 0, i32 0, metadata !819} ; [ DW_TAG_member ] [dummy] [line 100, size 64, align 64, offset 0] [from register_t]
!1299 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"sys_getppid", metadata !"sys_getppid", metadata !"", i32 124, metadata !1300, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.getppid_args*)* @sys_getppid, null, null, metadata !1289, i32 125} ; [ DW_TAG_subprogram ] [line 124] [def] [scope 125] [sys_getppid]
!1300 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1301, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1301 = metadata !{metadata !93, metadata !18, metadata !1302}
!1302 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1303} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from getppid_args]
!1303 = metadata !{i32 786451, metadata !742, null, metadata !"getppid_args", i32 179, i64 64, i64 64, i32 0, i32 0, null, metadata !1304, i32 0, null, null} ; [ DW_TAG_structure_type ] [getppid_args] [line 179, size 64, align 64, offset 0] [from ]
!1304 = metadata !{metadata !1305}
!1305 = metadata !{i32 786445, metadata !742, metadata !1303, metadata !"dummy", i32 180, i64 64, i64 64, i64 0, i32 0, metadata !819} ; [ DW_TAG_member ] [dummy] [line 180, size 64, align 64, offset 0] [from register_t]
!1306 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"sys_getpgrp", metadata !"sys_getpgrp", metadata !"", i32 143, metadata !1307, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.getpgrp_args*)* @sys_getpgrp, null, null, metadata !1289, i32 144} ; [ DW_TAG_subprogram ] [line 143] [def] [scope 144] [sys_getpgrp]
!1307 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1308, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1308 = metadata !{metadata !93, metadata !18, metadata !1309}
!1309 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1310} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from getpgrp_args]
!1310 = metadata !{i32 786451, metadata !742, null, metadata !"getpgrp_args", i32 301, i64 64, i64 64, i32 0, i32 0, null, metadata !1311, i32 0, null, null} ; [ DW_TAG_structure_type ] [getpgrp_args] [line 301, size 64, align 64, offset 0] [from ]
!1311 = metadata !{metadata !1312}
!1312 = metadata !{i32 786445, metadata !742, metadata !1310, metadata !"dummy", i32 302, i64 64, i64 64, i64 0, i32 0, metadata !819} ; [ DW_TAG_member ] [dummy] [line 302, size 64, align 64, offset 0] [from register_t]
!1313 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"sys_getpgid", metadata !"sys_getpgid", metadata !"", i32 160, metadata !1314, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.getpgid_args*)* @sys_getpgid, null, null, metadata !1289, i32 161} ; [ DW_TAG_subprogram ] [line 160] [def] [scope 161] [sys_getpgid]
!1314 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1315, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1315 = metadata !{metadata !93, metadata !18, metadata !1316}
!1316 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1317} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from getpgid_args]
!1317 = metadata !{i32 786451, metadata !742, null, metadata !"getpgid_args", i32 645, i64 64, i64 32, i32 0, i32 0, null, metadata !1318, i32 0, null, null} ; [ DW_TAG_structure_type ] [getpgid_args] [line 645, size 64, align 32, offset 0] [from ]
!1318 = metadata !{metadata !1319, metadata !1323, metadata !1324}
!1319 = metadata !{i32 786445, metadata !742, metadata !1317, metadata !"pid_l_", i32 646, i64 0, i64 8, i64 0, i32 0, metadata !1320} ; [ DW_TAG_member ] [pid_l_] [line 646, size 0, align 8, offset 0] [from ]
!1320 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 0, i64 8, i32 0, i32 0, metadata !34, metadata !1321, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 0, align 8, offset 0] [from char]
!1321 = metadata !{metadata !1322}
!1322 = metadata !{i32 786465, i64 0, i64 0}      ; [ DW_TAG_subrange_type ] [0, -1]
!1323 = metadata !{i32 786445, metadata !742, metadata !1317, metadata !"pid", i32 646, i64 32, i64 32, i64 0, i32 0, metadata !504} ; [ DW_TAG_member ] [pid] [line 646, size 32, align 32, offset 0] [from pid_t]
!1324 = metadata !{i32 786445, metadata !742, metadata !1317, metadata !"pid_r_", i32 646, i64 32, i64 8, i64 32, i32 0, metadata !1325} ; [ DW_TAG_member ] [pid_r_] [line 646, size 32, align 8, offset 32] [from ]
!1325 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 32, i64 8, i32 0, i32 0, metadata !34, metadata !148, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 32, align 8, offset 0] [from char]
!1326 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"sys_getsid", metadata !"sys_getsid", metadata !"", i32 192, metadata !1327, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.getsid_args*)* @sys_getsid, null, null, metadata !1289, i32 193} ; [ DW_TAG_subprogram ] [line 192] [def] [scope 193] [sys_getsid]
!1327 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1328, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1328 = metadata !{metadata !93, metadata !18, metadata !1329}
!1329 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1330} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from getsid_args]
!1330 = metadata !{i32 786451, metadata !742, null, metadata !"getsid_args", i32 857, i64 64, i64 32, i32 0, i32 0, null, metadata !1331, i32 0, null, null} ; [ DW_TAG_structure_type ] [getsid_args] [line 857, size 64, align 32, offset 0] [from ]
!1331 = metadata !{metadata !1332, metadata !1333, metadata !1334}
!1332 = metadata !{i32 786445, metadata !742, metadata !1330, metadata !"pid_l_", i32 858, i64 0, i64 8, i64 0, i32 0, metadata !1320} ; [ DW_TAG_member ] [pid_l_] [line 858, size 0, align 8, offset 0] [from ]
!1333 = metadata !{i32 786445, metadata !742, metadata !1330, metadata !"pid", i32 858, i64 32, i64 32, i64 0, i32 0, metadata !504} ; [ DW_TAG_member ] [pid] [line 858, size 32, align 32, offset 0] [from pid_t]
!1334 = metadata !{i32 786445, metadata !742, metadata !1330, metadata !"pid_r_", i32 858, i64 32, i64 8, i64 32, i32 0, metadata !1325} ; [ DW_TAG_member ] [pid_r_] [line 858, size 32, align 8, offset 32] [from ]
!1335 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"sys_getuid", metadata !"sys_getuid", metadata !"", i32 222, metadata !1336, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.getuid_args*)* @sys_getuid, null, null, metadata !1289, i32 223} ; [ DW_TAG_subprogram ] [line 222] [def] [scope 223] [sys_getuid]
!1336 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1337, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1337 = metadata !{metadata !93, metadata !18, metadata !1338}
!1338 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1339} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from getuid_args]
!1339 = metadata !{i32 786451, metadata !742, null, metadata !"getuid_args", i32 115, i64 64, i64 64, i32 0, i32 0, null, metadata !1340, i32 0, null, null} ; [ DW_TAG_structure_type ] [getuid_args] [line 115, size 64, align 64, offset 0] [from ]
!1340 = metadata !{metadata !1341}
!1341 = metadata !{i32 786445, metadata !742, metadata !1339, metadata !"dummy", i32 116, i64 64, i64 64, i64 0, i32 0, metadata !819} ; [ DW_TAG_member ] [dummy] [line 116, size 64, align 64, offset 0] [from register_t]
!1342 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"sys_geteuid", metadata !"sys_geteuid", metadata !"", i32 239, metadata !1343, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.geteuid_args*)* @sys_geteuid, null, null, metadata !1289, i32 240} ; [ DW_TAG_subprogram ] [line 239] [def] [scope 240] [sys_geteuid]
!1343 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1344, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1344 = metadata !{metadata !93, metadata !18, metadata !1345}
!1345 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1346} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from geteuid_args]
!1346 = metadata !{i32 786451, metadata !742, null, metadata !"geteuid_args", i32 118, i64 64, i64 64, i32 0, i32 0, null, metadata !1347, i32 0, null, null} ; [ DW_TAG_structure_type ] [geteuid_args] [line 118, size 64, align 64, offset 0] [from ]
!1347 = metadata !{metadata !1348}
!1348 = metadata !{i32 786445, metadata !742, metadata !1346, metadata !"dummy", i32 119, i64 64, i64 64, i64 0, i32 0, metadata !819} ; [ DW_TAG_member ] [dummy] [line 119, size 64, align 64, offset 0] [from register_t]
!1349 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"sys_getgid", metadata !"sys_getgid", metadata !"", i32 253, metadata !1350, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.getgid_args*)* @sys_getgid, null, null, metadata !1289, i32 254} ; [ DW_TAG_subprogram ] [line 253] [def] [scope 254] [sys_getgid]
!1350 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1351, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1351 = metadata !{metadata !93, metadata !18, metadata !1352}
!1352 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1353} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from getgid_args]
!1353 = metadata !{i32 786451, metadata !742, null, metadata !"getgid_args", i32 203, i64 64, i64 64, i32 0, i32 0, null, metadata !1354, i32 0, null, null} ; [ DW_TAG_structure_type ] [getgid_args] [line 203, size 64, align 64, offset 0] [from ]
!1354 = metadata !{metadata !1355}
!1355 = metadata !{i32 786445, metadata !742, metadata !1353, metadata !"dummy", i32 204, i64 64, i64 64, i64 0, i32 0, metadata !819} ; [ DW_TAG_member ] [dummy] [line 204, size 64, align 64, offset 0] [from register_t]
!1356 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"sys_getegid", metadata !"sys_getegid", metadata !"", i32 275, metadata !1357, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.getegid_args*)* @sys_getegid, null, null, metadata !1289, i32 276} ; [ DW_TAG_subprogram ] [line 275] [def] [scope 276] [sys_getegid]
!1357 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1358, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1358 = metadata !{metadata !93, metadata !18, metadata !1359}
!1359 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1360} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from getegid_args]
!1360 = metadata !{i32 786451, metadata !742, null, metadata !"getegid_args", i32 188, i64 64, i64 64, i32 0, i32 0, null, metadata !1361, i32 0, null, null} ; [ DW_TAG_structure_type ] [getegid_args] [line 188, size 64, align 64, offset 0] [from ]
!1361 = metadata !{metadata !1362}
!1362 = metadata !{i32 786445, metadata !742, metadata !1360, metadata !"dummy", i32 189, i64 64, i64 64, i64 0, i32 0, metadata !819} ; [ DW_TAG_member ] [dummy] [line 189, size 64, align 64, offset 0] [from register_t]
!1363 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"sys_getgroups", metadata !"sys_getgroups", metadata !"", i32 289, metadata !1364, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.getgroups_args*)* @sys_getgroups, null, null, metadata !1289, i32 290} ; [ DW_TAG_subprogram ] [line 289] [def] [scope 290] [sys_getgroups]
!1364 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1365, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1365 = metadata !{metadata !93, metadata !18, metadata !1366}
!1366 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1367} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from getgroups_args]
!1367 = metadata !{i32 786451, metadata !742, null, metadata !"getgroups_args", i32 293, i64 128, i64 64, i32 0, i32 0, null, metadata !1368, i32 0, null, null} ; [ DW_TAG_structure_type ] [getgroups_args] [line 293, size 128, align 64, offset 0] [from ]
!1368 = metadata !{metadata !1369, metadata !1370, metadata !1371, metadata !1372, metadata !1373, metadata !1374}
!1369 = metadata !{i32 786445, metadata !742, metadata !1367, metadata !"gidsetsize_l_", i32 294, i64 0, i64 8, i64 0, i32 0, metadata !1320} ; [ DW_TAG_member ] [gidsetsize_l_] [line 294, size 0, align 8, offset 0] [from ]
!1370 = metadata !{i32 786445, metadata !742, metadata !1367, metadata !"gidsetsize", i32 294, i64 32, i64 32, i64 0, i32 0, metadata !36} ; [ DW_TAG_member ] [gidsetsize] [line 294, size 32, align 32, offset 0] [from u_int]
!1371 = metadata !{i32 786445, metadata !742, metadata !1367, metadata !"gidsetsize_r_", i32 294, i64 32, i64 8, i64 32, i32 0, metadata !1325} ; [ DW_TAG_member ] [gidsetsize_r_] [line 294, size 32, align 8, offset 32] [from ]
!1372 = metadata !{i32 786445, metadata !742, metadata !1367, metadata !"gidset_l_", i32 295, i64 0, i64 8, i64 64, i32 0, metadata !1320} ; [ DW_TAG_member ] [gidset_l_] [line 295, size 0, align 8, offset 64] [from ]
!1373 = metadata !{i32 786445, metadata !742, metadata !1367, metadata !"gidset", i32 295, i64 64, i64 64, i64 64, i32 0, metadata !509} ; [ DW_TAG_member ] [gidset] [line 295, size 64, align 64, offset 64] [from ]
!1374 = metadata !{i32 786445, metadata !742, metadata !1367, metadata !"gidset_r_", i32 295, i64 0, i64 8, i64 128, i32 0, metadata !1320} ; [ DW_TAG_member ] [gidset_r_] [line 295, size 0, align 8, offset 128] [from ]
!1375 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"kern_getgroups", metadata !"kern_getgroups", metadata !"", i32 316, metadata !1376, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, i32*, i32*)* @kern_getgroups, null, null, metadata !1289, i32 317} ; [ DW_TAG_subprogram ] [line 316] [def] [scope 317] [kern_getgroups]
!1376 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1377, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1377 = metadata !{metadata !93, metadata !18, metadata !1378, metadata !509}
!1378 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !36} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from u_int]
!1379 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"sys_setsid", metadata !"sys_setsid", metadata !"", i32 339, metadata !1380, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.setsid_args*)* @sys_setsid, null, null, metadata !1289, i32 340} ; [ DW_TAG_subprogram ] [line 339] [def] [scope 340] [sys_setsid]
!1380 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1381, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1381 = metadata !{metadata !93, metadata !18, metadata !1382}
!1382 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1383} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from setsid_args]
!1383 = metadata !{i32 786451, metadata !742, null, metadata !"setsid_args", i32 474, i64 64, i64 64, i32 0, i32 0, null, metadata !1384, i32 0, null, null} ; [ DW_TAG_structure_type ] [setsid_args] [line 474, size 64, align 64, offset 0] [from ]
!1384 = metadata !{metadata !1385}
!1385 = metadata !{i32 786445, metadata !742, metadata !1383, metadata !"dummy", i32 475, i64 64, i64 64, i64 0, i32 0, metadata !819} ; [ DW_TAG_member ] [dummy] [line 475, size 64, align 64, offset 0] [from register_t]
!1386 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"sys_setpgid", metadata !"sys_setpgid", metadata !"", i32 397, metadata !1387, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.setpgid_args*)* @sys_setpgid, null, null, metadata !1289, i32 398} ; [ DW_TAG_subprogram ] [line 397] [def] [scope 398] [sys_setpgid]
!1387 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1388, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1388 = metadata !{metadata !93, metadata !18, metadata !1389}
!1389 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1390} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from setpgid_args]
!1390 = metadata !{i32 786451, metadata !742, null, metadata !"setpgid_args", i32 304, i64 128, i64 32, i32 0, i32 0, null, metadata !1391, i32 0, null, null} ; [ DW_TAG_structure_type ] [setpgid_args] [line 304, size 128, align 32, offset 0] [from ]
!1391 = metadata !{metadata !1392, metadata !1393, metadata !1394, metadata !1395, metadata !1396, metadata !1397}
!1392 = metadata !{i32 786445, metadata !742, metadata !1390, metadata !"pid_l_", i32 305, i64 0, i64 8, i64 0, i32 0, metadata !1320} ; [ DW_TAG_member ] [pid_l_] [line 305, size 0, align 8, offset 0] [from ]
!1393 = metadata !{i32 786445, metadata !742, metadata !1390, metadata !"pid", i32 305, i64 32, i64 32, i64 0, i32 0, metadata !93} ; [ DW_TAG_member ] [pid] [line 305, size 32, align 32, offset 0] [from int]
!1394 = metadata !{i32 786445, metadata !742, metadata !1390, metadata !"pid_r_", i32 305, i64 32, i64 8, i64 32, i32 0, metadata !1325} ; [ DW_TAG_member ] [pid_r_] [line 305, size 32, align 8, offset 32] [from ]
!1395 = metadata !{i32 786445, metadata !742, metadata !1390, metadata !"pgid_l_", i32 306, i64 0, i64 8, i64 64, i32 0, metadata !1320} ; [ DW_TAG_member ] [pgid_l_] [line 306, size 0, align 8, offset 64] [from ]
!1396 = metadata !{i32 786445, metadata !742, metadata !1390, metadata !"pgid", i32 306, i64 32, i64 32, i64 64, i32 0, metadata !93} ; [ DW_TAG_member ] [pgid] [line 306, size 32, align 32, offset 64] [from int]
!1397 = metadata !{i32 786445, metadata !742, metadata !1390, metadata !"pgid_r_", i32 306, i64 32, i64 8, i64 96, i32 0, metadata !1325} ; [ DW_TAG_member ] [pgid_r_] [line 306, size 32, align 8, offset 96] [from ]
!1398 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"sys_setuid", metadata !"sys_setuid", metadata !"", i32 497, metadata !1399, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.setuid_args*)* @sys_setuid, null, null, metadata !1289, i32 498} ; [ DW_TAG_subprogram ] [line 497] [def] [scope 498] [sys_setuid]
!1399 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1400, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1400 = metadata !{metadata !93, metadata !18, metadata !1401}
!1401 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1402} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from setuid_args]
!1402 = metadata !{i32 786451, metadata !742, null, metadata !"setuid_args", i32 112, i64 64, i64 32, i32 0, i32 0, null, metadata !1403, i32 0, null, null} ; [ DW_TAG_structure_type ] [setuid_args] [line 112, size 64, align 32, offset 0] [from ]
!1403 = metadata !{metadata !1404, metadata !1405, metadata !1406}
!1404 = metadata !{i32 786445, metadata !742, metadata !1402, metadata !"uid_l_", i32 113, i64 0, i64 8, i64 0, i32 0, metadata !1320} ; [ DW_TAG_member ] [uid_l_] [line 113, size 0, align 8, offset 0] [from ]
!1405 = metadata !{i32 786445, metadata !742, metadata !1402, metadata !"uid", i32 113, i64 32, i64 32, i64 0, i32 0, metadata !258} ; [ DW_TAG_member ] [uid] [line 113, size 32, align 32, offset 0] [from uid_t]
!1406 = metadata !{i32 786445, metadata !742, metadata !1402, metadata !"uid_r_", i32 113, i64 32, i64 8, i64 32, i32 0, metadata !1325} ; [ DW_TAG_member ] [uid_r_] [line 113, size 32, align 8, offset 32] [from ]
!1407 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"sys_seteuid", metadata !"sys_seteuid", metadata !"", i32 611, metadata !1408, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.seteuid_args*)* @sys_seteuid, null, null, metadata !1289, i32 612} ; [ DW_TAG_subprogram ] [line 611] [def] [scope 612] [sys_seteuid]
!1408 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1409, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1409 = metadata !{metadata !93, metadata !18, metadata !1410}
!1410 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1411} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from seteuid_args]
!1411 = metadata !{i32 786451, metadata !742, null, metadata !"seteuid_args", i32 560, i64 64, i64 32, i32 0, i32 0, null, metadata !1412, i32 0, null, null} ; [ DW_TAG_structure_type ] [seteuid_args] [line 560, size 64, align 32, offset 0] [from ]
!1412 = metadata !{metadata !1413, metadata !1414, metadata !1415}
!1413 = metadata !{i32 786445, metadata !742, metadata !1411, metadata !"euid_l_", i32 561, i64 0, i64 8, i64 0, i32 0, metadata !1320} ; [ DW_TAG_member ] [euid_l_] [line 561, size 0, align 8, offset 0] [from ]
!1414 = metadata !{i32 786445, metadata !742, metadata !1411, metadata !"euid", i32 561, i64 32, i64 32, i64 0, i32 0, metadata !258} ; [ DW_TAG_member ] [euid] [line 561, size 32, align 32, offset 0] [from uid_t]
!1415 = metadata !{i32 786445, metadata !742, metadata !1411, metadata !"euid_r_", i32 561, i64 32, i64 8, i64 32, i32 0, metadata !1325} ; [ DW_TAG_member ] [euid_r_] [line 561, size 32, align 8, offset 32] [from ]
!1416 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"sys_setgid", metadata !"sys_setgid", metadata !"", i32 667, metadata !1417, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.setgid_args*)* @sys_setgid, null, null, metadata !1289, i32 668} ; [ DW_TAG_subprogram ] [line 667] [def] [scope 668] [sys_setgid]
!1417 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1418, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1418 = metadata !{metadata !93, metadata !18, metadata !1419}
!1419 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1420} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from setgid_args]
!1420 = metadata !{i32 786451, metadata !742, null, metadata !"setgid_args", i32 554, i64 64, i64 32, i32 0, i32 0, null, metadata !1421, i32 0, null, null} ; [ DW_TAG_structure_type ] [setgid_args] [line 554, size 64, align 32, offset 0] [from ]
!1421 = metadata !{metadata !1422, metadata !1423, metadata !1424}
!1422 = metadata !{i32 786445, metadata !742, metadata !1420, metadata !"gid_l_", i32 555, i64 0, i64 8, i64 0, i32 0, metadata !1320} ; [ DW_TAG_member ] [gid_l_] [line 555, size 0, align 8, offset 0] [from ]
!1423 = metadata !{i32 786445, metadata !742, metadata !1420, metadata !"gid", i32 555, i64 32, i64 32, i64 0, i32 0, metadata !263} ; [ DW_TAG_member ] [gid] [line 555, size 32, align 32, offset 0] [from gid_t]
!1424 = metadata !{i32 786445, metadata !742, metadata !1420, metadata !"gid_r_", i32 555, i64 32, i64 8, i64 32, i32 0, metadata !1325} ; [ DW_TAG_member ] [gid_r_] [line 555, size 32, align 8, offset 32] [from ]
!1425 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"sys_setegid", metadata !"sys_setegid", metadata !"", i32 765, metadata !1426, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.setegid_args*)* @sys_setegid, null, null, metadata !1289, i32 766} ; [ DW_TAG_subprogram ] [line 765] [def] [scope 766] [sys_setegid]
!1426 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1427, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1427 = metadata !{metadata !93, metadata !18, metadata !1428}
!1428 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1429} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from setegid_args]
!1429 = metadata !{i32 786451, metadata !742, null, metadata !"setegid_args", i32 557, i64 64, i64 32, i32 0, i32 0, null, metadata !1430, i32 0, null, null} ; [ DW_TAG_structure_type ] [setegid_args] [line 557, size 64, align 32, offset 0] [from ]
!1430 = metadata !{metadata !1431, metadata !1432, metadata !1433}
!1431 = metadata !{i32 786445, metadata !742, metadata !1429, metadata !"egid_l_", i32 558, i64 0, i64 8, i64 0, i32 0, metadata !1320} ; [ DW_TAG_member ] [egid_l_] [line 558, size 0, align 8, offset 0] [from ]
!1432 = metadata !{i32 786445, metadata !742, metadata !1429, metadata !"egid", i32 558, i64 32, i64 32, i64 0, i32 0, metadata !263} ; [ DW_TAG_member ] [egid] [line 558, size 32, align 32, offset 0] [from gid_t]
!1433 = metadata !{i32 786445, metadata !742, metadata !1429, metadata !"egid_r_", i32 558, i64 32, i64 8, i64 32, i32 0, metadata !1325} ; [ DW_TAG_member ] [egid_r_] [line 558, size 32, align 8, offset 32] [from ]
!1434 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"sys_setgroups", metadata !"sys_setgroups", metadata !"", i32 812, metadata !1435, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.setgroups_args*)* @sys_setgroups, null, null, metadata !1289, i32 813} ; [ DW_TAG_subprogram ] [line 812] [def] [scope 813] [sys_setgroups]
!1435 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1436, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1436 = metadata !{metadata !93, metadata !18, metadata !1437}
!1437 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1438} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from setgroups_args]
!1438 = metadata !{i32 786451, metadata !742, null, metadata !"setgroups_args", i32 297, i64 128, i64 64, i32 0, i32 0, null, metadata !1439, i32 0, null, null} ; [ DW_TAG_structure_type ] [setgroups_args] [line 297, size 128, align 64, offset 0] [from ]
!1439 = metadata !{metadata !1440, metadata !1441, metadata !1442, metadata !1443, metadata !1444, metadata !1445}
!1440 = metadata !{i32 786445, metadata !742, metadata !1438, metadata !"gidsetsize_l_", i32 298, i64 0, i64 8, i64 0, i32 0, metadata !1320} ; [ DW_TAG_member ] [gidsetsize_l_] [line 298, size 0, align 8, offset 0] [from ]
!1441 = metadata !{i32 786445, metadata !742, metadata !1438, metadata !"gidsetsize", i32 298, i64 32, i64 32, i64 0, i32 0, metadata !36} ; [ DW_TAG_member ] [gidsetsize] [line 298, size 32, align 32, offset 0] [from u_int]
!1442 = metadata !{i32 786445, metadata !742, metadata !1438, metadata !"gidsetsize_r_", i32 298, i64 32, i64 8, i64 32, i32 0, metadata !1325} ; [ DW_TAG_member ] [gidsetsize_r_] [line 298, size 32, align 8, offset 32] [from ]
!1443 = metadata !{i32 786445, metadata !742, metadata !1438, metadata !"gidset_l_", i32 299, i64 0, i64 8, i64 64, i32 0, metadata !1320} ; [ DW_TAG_member ] [gidset_l_] [line 299, size 0, align 8, offset 64] [from ]
!1444 = metadata !{i32 786445, metadata !742, metadata !1438, metadata !"gidset", i32 299, i64 64, i64 64, i64 64, i32 0, metadata !509} ; [ DW_TAG_member ] [gidset] [line 299, size 64, align 64, offset 64] [from ]
!1445 = metadata !{i32 786445, metadata !742, metadata !1438, metadata !"gidset_r_", i32 299, i64 0, i64 8, i64 128, i32 0, metadata !1320} ; [ DW_TAG_member ] [gidset_r_] [line 299, size 0, align 8, offset 128] [from ]
!1446 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"kern_setgroups", metadata !"kern_setgroups", metadata !"", i32 830, metadata !1447, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, i32, i32*)* @kern_setgroups, null, null, metadata !1289, i32 831} ; [ DW_TAG_subprogram ] [line 830] [def] [scope 831] [kern_setgroups]
!1447 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1448, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1448 = metadata !{metadata !93, metadata !18, metadata !36, metadata !509}
!1449 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"sys_setreuid", metadata !"sys_setreuid", metadata !"", i32 885, metadata !1450, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.setreuid_args*)* @sys_setreuid, null, null, metadata !1289, i32 886} ; [ DW_TAG_subprogram ] [line 885] [def] [scope 886] [sys_setreuid]
!1450 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1451, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1451 = metadata !{metadata !93, metadata !18, metadata !1452}
!1452 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1453} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from setreuid_args]
!1453 = metadata !{i32 786451, metadata !742, null, metadata !"setreuid_args", i32 418, i64 128, i64 32, i32 0, i32 0, null, metadata !1454, i32 0, null, null} ; [ DW_TAG_structure_type ] [setreuid_args] [line 418, size 128, align 32, offset 0] [from ]
!1454 = metadata !{metadata !1455, metadata !1456, metadata !1457, metadata !1458, metadata !1459, metadata !1460}
!1455 = metadata !{i32 786445, metadata !742, metadata !1453, metadata !"ruid_l_", i32 419, i64 0, i64 8, i64 0, i32 0, metadata !1320} ; [ DW_TAG_member ] [ruid_l_] [line 419, size 0, align 8, offset 0] [from ]
!1456 = metadata !{i32 786445, metadata !742, metadata !1453, metadata !"ruid", i32 419, i64 32, i64 32, i64 0, i32 0, metadata !93} ; [ DW_TAG_member ] [ruid] [line 419, size 32, align 32, offset 0] [from int]
!1457 = metadata !{i32 786445, metadata !742, metadata !1453, metadata !"ruid_r_", i32 419, i64 32, i64 8, i64 32, i32 0, metadata !1325} ; [ DW_TAG_member ] [ruid_r_] [line 419, size 32, align 8, offset 32] [from ]
!1458 = metadata !{i32 786445, metadata !742, metadata !1453, metadata !"euid_l_", i32 420, i64 0, i64 8, i64 64, i32 0, metadata !1320} ; [ DW_TAG_member ] [euid_l_] [line 420, size 0, align 8, offset 64] [from ]
!1459 = metadata !{i32 786445, metadata !742, metadata !1453, metadata !"euid", i32 420, i64 32, i64 32, i64 64, i32 0, metadata !93} ; [ DW_TAG_member ] [euid] [line 420, size 32, align 32, offset 64] [from int]
!1460 = metadata !{i32 786445, metadata !742, metadata !1453, metadata !"euid_r_", i32 420, i64 32, i64 8, i64 96, i32 0, metadata !1325} ; [ DW_TAG_member ] [euid_r_] [line 420, size 32, align 8, offset 96] [from ]
!1461 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"sys_setregid", metadata !"sys_setregid", metadata !"", i32 955, metadata !1462, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.setregid_args*)* @sys_setregid, null, null, metadata !1289, i32 956} ; [ DW_TAG_subprogram ] [line 955] [def] [scope 956] [sys_setregid]
!1462 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1463, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1463 = metadata !{metadata !93, metadata !18, metadata !1464}
!1464 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1465} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from setregid_args]
!1465 = metadata !{i32 786451, metadata !742, null, metadata !"setregid_args", i32 422, i64 128, i64 32, i32 0, i32 0, null, metadata !1466, i32 0, null, null} ; [ DW_TAG_structure_type ] [setregid_args] [line 422, size 128, align 32, offset 0] [from ]
!1466 = metadata !{metadata !1467, metadata !1468, metadata !1469, metadata !1470, metadata !1471, metadata !1472}
!1467 = metadata !{i32 786445, metadata !742, metadata !1465, metadata !"rgid_l_", i32 423, i64 0, i64 8, i64 0, i32 0, metadata !1320} ; [ DW_TAG_member ] [rgid_l_] [line 423, size 0, align 8, offset 0] [from ]
!1468 = metadata !{i32 786445, metadata !742, metadata !1465, metadata !"rgid", i32 423, i64 32, i64 32, i64 0, i32 0, metadata !93} ; [ DW_TAG_member ] [rgid] [line 423, size 32, align 32, offset 0] [from int]
!1469 = metadata !{i32 786445, metadata !742, metadata !1465, metadata !"rgid_r_", i32 423, i64 32, i64 8, i64 32, i32 0, metadata !1325} ; [ DW_TAG_member ] [rgid_r_] [line 423, size 32, align 8, offset 32] [from ]
!1470 = metadata !{i32 786445, metadata !742, metadata !1465, metadata !"egid_l_", i32 424, i64 0, i64 8, i64 64, i32 0, metadata !1320} ; [ DW_TAG_member ] [egid_l_] [line 424, size 0, align 8, offset 64] [from ]
!1471 = metadata !{i32 786445, metadata !742, metadata !1465, metadata !"egid", i32 424, i64 32, i64 32, i64 64, i32 0, metadata !93} ; [ DW_TAG_member ] [egid] [line 424, size 32, align 32, offset 64] [from int]
!1472 = metadata !{i32 786445, metadata !742, metadata !1465, metadata !"egid_r_", i32 424, i64 32, i64 8, i64 96, i32 0, metadata !1325} ; [ DW_TAG_member ] [egid_r_] [line 424, size 32, align 8, offset 96] [from ]
!1473 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"sys_setresuid", metadata !"sys_setresuid", metadata !"", i32 1020, metadata !1474, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.setresuid_args*)* @sys_setresuid, null, null, metadata !1289, i32 1021} ; [ DW_TAG_subprogram ] [line 1020] [def] [scope 1021] [sys_setresuid]
!1474 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1475, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1475 = metadata !{metadata !93, metadata !18, metadata !1476}
!1476 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1477} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from setresuid_args]
!1477 = metadata !{i32 786451, metadata !742, null, metadata !"setresuid_args", i32 860, i64 192, i64 32, i32 0, i32 0, null, metadata !1478, i32 0, null, null} ; [ DW_TAG_structure_type ] [setresuid_args] [line 860, size 192, align 32, offset 0] [from ]
!1478 = metadata !{metadata !1479, metadata !1480, metadata !1481, metadata !1482, metadata !1483, metadata !1484, metadata !1485, metadata !1486, metadata !1487}
!1479 = metadata !{i32 786445, metadata !742, metadata !1477, metadata !"ruid_l_", i32 861, i64 0, i64 8, i64 0, i32 0, metadata !1320} ; [ DW_TAG_member ] [ruid_l_] [line 861, size 0, align 8, offset 0] [from ]
!1480 = metadata !{i32 786445, metadata !742, metadata !1477, metadata !"ruid", i32 861, i64 32, i64 32, i64 0, i32 0, metadata !258} ; [ DW_TAG_member ] [ruid] [line 861, size 32, align 32, offset 0] [from uid_t]
!1481 = metadata !{i32 786445, metadata !742, metadata !1477, metadata !"ruid_r_", i32 861, i64 32, i64 8, i64 32, i32 0, metadata !1325} ; [ DW_TAG_member ] [ruid_r_] [line 861, size 32, align 8, offset 32] [from ]
!1482 = metadata !{i32 786445, metadata !742, metadata !1477, metadata !"euid_l_", i32 862, i64 0, i64 8, i64 64, i32 0, metadata !1320} ; [ DW_TAG_member ] [euid_l_] [line 862, size 0, align 8, offset 64] [from ]
!1483 = metadata !{i32 786445, metadata !742, metadata !1477, metadata !"euid", i32 862, i64 32, i64 32, i64 64, i32 0, metadata !258} ; [ DW_TAG_member ] [euid] [line 862, size 32, align 32, offset 64] [from uid_t]
!1484 = metadata !{i32 786445, metadata !742, metadata !1477, metadata !"euid_r_", i32 862, i64 32, i64 8, i64 96, i32 0, metadata !1325} ; [ DW_TAG_member ] [euid_r_] [line 862, size 32, align 8, offset 96] [from ]
!1485 = metadata !{i32 786445, metadata !742, metadata !1477, metadata !"suid_l_", i32 863, i64 0, i64 8, i64 128, i32 0, metadata !1320} ; [ DW_TAG_member ] [suid_l_] [line 863, size 0, align 8, offset 128] [from ]
!1486 = metadata !{i32 786445, metadata !742, metadata !1477, metadata !"suid", i32 863, i64 32, i64 32, i64 128, i32 0, metadata !258} ; [ DW_TAG_member ] [suid] [line 863, size 32, align 32, offset 128] [from uid_t]
!1487 = metadata !{i32 786445, metadata !742, metadata !1477, metadata !"suid_r_", i32 863, i64 32, i64 8, i64 160, i32 0, metadata !1325} ; [ DW_TAG_member ] [suid_r_] [line 863, size 32, align 8, offset 160] [from ]
!1488 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"sys_setresgid", metadata !"sys_setresgid", metadata !"", i32 1102, metadata !1489, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.setresgid_args*)* @sys_setresgid, null, null, metadata !1289, i32 1103} ; [ DW_TAG_subprogram ] [line 1102] [def] [scope 1103] [sys_setresgid]
!1489 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1490, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1490 = metadata !{metadata !93, metadata !18, metadata !1491}
!1491 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1492} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from setresgid_args]
!1492 = metadata !{i32 786451, metadata !742, null, metadata !"setresgid_args", i32 865, i64 192, i64 32, i32 0, i32 0, null, metadata !1493, i32 0, null, null} ; [ DW_TAG_structure_type ] [setresgid_args] [line 865, size 192, align 32, offset 0] [from ]
!1493 = metadata !{metadata !1494, metadata !1495, metadata !1496, metadata !1497, metadata !1498, metadata !1499, metadata !1500, metadata !1501, metadata !1502}
!1494 = metadata !{i32 786445, metadata !742, metadata !1492, metadata !"rgid_l_", i32 866, i64 0, i64 8, i64 0, i32 0, metadata !1320} ; [ DW_TAG_member ] [rgid_l_] [line 866, size 0, align 8, offset 0] [from ]
!1495 = metadata !{i32 786445, metadata !742, metadata !1492, metadata !"rgid", i32 866, i64 32, i64 32, i64 0, i32 0, metadata !263} ; [ DW_TAG_member ] [rgid] [line 866, size 32, align 32, offset 0] [from gid_t]
!1496 = metadata !{i32 786445, metadata !742, metadata !1492, metadata !"rgid_r_", i32 866, i64 32, i64 8, i64 32, i32 0, metadata !1325} ; [ DW_TAG_member ] [rgid_r_] [line 866, size 32, align 8, offset 32] [from ]
!1497 = metadata !{i32 786445, metadata !742, metadata !1492, metadata !"egid_l_", i32 867, i64 0, i64 8, i64 64, i32 0, metadata !1320} ; [ DW_TAG_member ] [egid_l_] [line 867, size 0, align 8, offset 64] [from ]
!1498 = metadata !{i32 786445, metadata !742, metadata !1492, metadata !"egid", i32 867, i64 32, i64 32, i64 64, i32 0, metadata !263} ; [ DW_TAG_member ] [egid] [line 867, size 32, align 32, offset 64] [from gid_t]
!1499 = metadata !{i32 786445, metadata !742, metadata !1492, metadata !"egid_r_", i32 867, i64 32, i64 8, i64 96, i32 0, metadata !1325} ; [ DW_TAG_member ] [egid_r_] [line 867, size 32, align 8, offset 96] [from ]
!1500 = metadata !{i32 786445, metadata !742, metadata !1492, metadata !"sgid_l_", i32 868, i64 0, i64 8, i64 128, i32 0, metadata !1320} ; [ DW_TAG_member ] [sgid_l_] [line 868, size 0, align 8, offset 128] [from ]
!1501 = metadata !{i32 786445, metadata !742, metadata !1492, metadata !"sgid", i32 868, i64 32, i64 32, i64 128, i32 0, metadata !263} ; [ DW_TAG_member ] [sgid] [line 868, size 32, align 32, offset 128] [from gid_t]
!1502 = metadata !{i32 786445, metadata !742, metadata !1492, metadata !"sgid_r_", i32 868, i64 32, i64 8, i64 160, i32 0, metadata !1325} ; [ DW_TAG_member ] [sgid_r_] [line 868, size 32, align 8, offset 160] [from ]
!1503 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"sys_getresuid", metadata !"sys_getresuid", metadata !"", i32 1169, metadata !1504, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.getresuid_args*)* @sys_getresuid, null, null, metadata !1289, i32 1170} ; [ DW_TAG_subprogram ] [line 1169] [def] [scope 1170] [sys_getresuid]
!1504 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1505, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1505 = metadata !{metadata !93, metadata !18, metadata !1506}
!1506 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1507} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from getresuid_args]
!1507 = metadata !{i32 786451, metadata !742, null, metadata !"getresuid_args", i32 1046, i64 192, i64 64, i32 0, i32 0, null, metadata !1508, i32 0, null, null} ; [ DW_TAG_structure_type ] [getresuid_args] [line 1046, size 192, align 64, offset 0] [from ]
!1508 = metadata !{metadata !1509, metadata !1510, metadata !1512, metadata !1513, metadata !1514, metadata !1515, metadata !1516, metadata !1517, metadata !1518}
!1509 = metadata !{i32 786445, metadata !742, metadata !1507, metadata !"ruid_l_", i32 1047, i64 0, i64 8, i64 0, i32 0, metadata !1320} ; [ DW_TAG_member ] [ruid_l_] [line 1047, size 0, align 8, offset 0] [from ]
!1510 = metadata !{i32 786445, metadata !742, metadata !1507, metadata !"ruid", i32 1047, i64 64, i64 64, i64 0, i32 0, metadata !1511} ; [ DW_TAG_member ] [ruid] [line 1047, size 64, align 64, offset 0] [from ]
!1511 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !258} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from uid_t]
!1512 = metadata !{i32 786445, metadata !742, metadata !1507, metadata !"ruid_r_", i32 1047, i64 0, i64 8, i64 64, i32 0, metadata !1320} ; [ DW_TAG_member ] [ruid_r_] [line 1047, size 0, align 8, offset 64] [from ]
!1513 = metadata !{i32 786445, metadata !742, metadata !1507, metadata !"euid_l_", i32 1048, i64 0, i64 8, i64 64, i32 0, metadata !1320} ; [ DW_TAG_member ] [euid_l_] [line 1048, size 0, align 8, offset 64] [from ]
!1514 = metadata !{i32 786445, metadata !742, metadata !1507, metadata !"euid", i32 1048, i64 64, i64 64, i64 64, i32 0, metadata !1511} ; [ DW_TAG_member ] [euid] [line 1048, size 64, align 64, offset 64] [from ]
!1515 = metadata !{i32 786445, metadata !742, metadata !1507, metadata !"euid_r_", i32 1048, i64 0, i64 8, i64 128, i32 0, metadata !1320} ; [ DW_TAG_member ] [euid_r_] [line 1048, size 0, align 8, offset 128] [from ]
!1516 = metadata !{i32 786445, metadata !742, metadata !1507, metadata !"suid_l_", i32 1049, i64 0, i64 8, i64 128, i32 0, metadata !1320} ; [ DW_TAG_member ] [suid_l_] [line 1049, size 0, align 8, offset 128] [from ]
!1517 = metadata !{i32 786445, metadata !742, metadata !1507, metadata !"suid", i32 1049, i64 64, i64 64, i64 128, i32 0, metadata !1511} ; [ DW_TAG_member ] [suid] [line 1049, size 64, align 64, offset 128] [from ]
!1518 = metadata !{i32 786445, metadata !742, metadata !1507, metadata !"suid_r_", i32 1049, i64 0, i64 8, i64 192, i32 0, metadata !1320} ; [ DW_TAG_member ] [suid_r_] [line 1049, size 0, align 8, offset 192] [from ]
!1519 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"sys_getresgid", metadata !"sys_getresgid", metadata !"", i32 1196, metadata !1520, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.getresgid_args*)* @sys_getresgid, null, null, metadata !1289, i32 1197} ; [ DW_TAG_subprogram ] [line 1196] [def] [scope 1197] [sys_getresgid]
!1520 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1521, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1521 = metadata !{metadata !93, metadata !18, metadata !1522}
!1522 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1523} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from getresgid_args]
!1523 = metadata !{i32 786451, metadata !742, null, metadata !"getresgid_args", i32 1051, i64 192, i64 64, i32 0, i32 0, null, metadata !1524, i32 0, null, null} ; [ DW_TAG_structure_type ] [getresgid_args] [line 1051, size 192, align 64, offset 0] [from ]
!1524 = metadata !{metadata !1525, metadata !1526, metadata !1527, metadata !1528, metadata !1529, metadata !1530, metadata !1531, metadata !1532, metadata !1533}
!1525 = metadata !{i32 786445, metadata !742, metadata !1523, metadata !"rgid_l_", i32 1052, i64 0, i64 8, i64 0, i32 0, metadata !1320} ; [ DW_TAG_member ] [rgid_l_] [line 1052, size 0, align 8, offset 0] [from ]
!1526 = metadata !{i32 786445, metadata !742, metadata !1523, metadata !"rgid", i32 1052, i64 64, i64 64, i64 0, i32 0, metadata !509} ; [ DW_TAG_member ] [rgid] [line 1052, size 64, align 64, offset 0] [from ]
!1527 = metadata !{i32 786445, metadata !742, metadata !1523, metadata !"rgid_r_", i32 1052, i64 0, i64 8, i64 64, i32 0, metadata !1320} ; [ DW_TAG_member ] [rgid_r_] [line 1052, size 0, align 8, offset 64] [from ]
!1528 = metadata !{i32 786445, metadata !742, metadata !1523, metadata !"egid_l_", i32 1053, i64 0, i64 8, i64 64, i32 0, metadata !1320} ; [ DW_TAG_member ] [egid_l_] [line 1053, size 0, align 8, offset 64] [from ]
!1529 = metadata !{i32 786445, metadata !742, metadata !1523, metadata !"egid", i32 1053, i64 64, i64 64, i64 64, i32 0, metadata !509} ; [ DW_TAG_member ] [egid] [line 1053, size 64, align 64, offset 64] [from ]
!1530 = metadata !{i32 786445, metadata !742, metadata !1523, metadata !"egid_r_", i32 1053, i64 0, i64 8, i64 128, i32 0, metadata !1320} ; [ DW_TAG_member ] [egid_r_] [line 1053, size 0, align 8, offset 128] [from ]
!1531 = metadata !{i32 786445, metadata !742, metadata !1523, metadata !"sgid_l_", i32 1054, i64 0, i64 8, i64 128, i32 0, metadata !1320} ; [ DW_TAG_member ] [sgid_l_] [line 1054, size 0, align 8, offset 128] [from ]
!1532 = metadata !{i32 786445, metadata !742, metadata !1523, metadata !"sgid", i32 1054, i64 64, i64 64, i64 128, i32 0, metadata !509} ; [ DW_TAG_member ] [sgid] [line 1054, size 64, align 64, offset 128] [from ]
!1533 = metadata !{i32 786445, metadata !742, metadata !1523, metadata !"sgid_r_", i32 1054, i64 0, i64 8, i64 192, i32 0, metadata !1320} ; [ DW_TAG_member ] [sgid_r_] [line 1054, size 0, align 8, offset 192] [from ]
!1534 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"sys_issetugid", metadata !"sys_issetugid", metadata !"", i32 1221, metadata !1535, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.issetugid_args*)* @sys_issetugid, null, null, metadata !1289, i32 1222} ; [ DW_TAG_subprogram ] [line 1221] [def] [scope 1222] [sys_issetugid]
!1535 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1536, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1536 = metadata !{metadata !93, metadata !18, metadata !1537}
!1537 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1538} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from issetugid_args]
!1538 = metadata !{i32 786451, metadata !742, null, metadata !"issetugid_args", i32 760, i64 64, i64 64, i32 0, i32 0, null, metadata !1539, i32 0, null, null} ; [ DW_TAG_structure_type ] [issetugid_args] [line 760, size 64, align 64, offset 0] [from ]
!1539 = metadata !{metadata !1540}
!1540 = metadata !{i32 786445, metadata !742, metadata !1538, metadata !"dummy", i32 761, i64 64, i64 64, i64 0, i32 0, metadata !819} ; [ DW_TAG_member ] [dummy] [line 761, size 64, align 64, offset 0] [from register_t]
!1541 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"sys___setugid", metadata !"sys___setugid", metadata !"", i32 1240, metadata !1542, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.__setugid_args*)* @sys___setugid, null, null, metadata !1289, i32 1241} ; [ DW_TAG_subprogram ] [line 1240] [def] [scope 1241] [sys___setugid]
!1542 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1543, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1543 = metadata !{metadata !93, metadata !18, metadata !1544}
!1544 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1545} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from __setugid_args]
!1545 = metadata !{i32 786451, metadata !742, null, metadata !"__setugid_args", i32 1086, i64 64, i64 32, i32 0, i32 0, null, metadata !1546, i32 0, null, null} ; [ DW_TAG_structure_type ] [__setugid_args] [line 1086, size 64, align 32, offset 0] [from ]
!1546 = metadata !{metadata !1547, metadata !1548, metadata !1549}
!1547 = metadata !{i32 786445, metadata !742, metadata !1545, metadata !"flag_l_", i32 1087, i64 0, i64 8, i64 0, i32 0, metadata !1320} ; [ DW_TAG_member ] [flag_l_] [line 1087, size 0, align 8, offset 0] [from ]
!1548 = metadata !{i32 786445, metadata !742, metadata !1545, metadata !"flag", i32 1087, i64 32, i64 32, i64 0, i32 0, metadata !93} ; [ DW_TAG_member ] [flag] [line 1087, size 32, align 32, offset 0] [from int]
!1549 = metadata !{i32 786445, metadata !742, metadata !1545, metadata !"flag_r_", i32 1087, i64 32, i64 8, i64 32, i32 0, metadata !1325} ; [ DW_TAG_member ] [flag_r_] [line 1087, size 32, align 8, offset 32] [from ]
!1550 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"groupmember", metadata !"groupmember", metadata !"", i32 1270, metadata !1551, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32, %struct.ucred*)* @groupmember, null, null, metadata !1289, i32 1271} ; [ DW_TAG_subprogram ] [line 1270] [def] [scope 1271] [groupmember]
!1551 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1552, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1552 = metadata !{metadata !93, metadata !263, metadata !253}
!1553 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"securelevel_gt", metadata !"securelevel_gt", metadata !"", i32 1313, metadata !1554, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.ucred*, i32)* @securelevel_gt, null, null, metadata !1289, i32 1314} ; [ DW_TAG_subprogram ] [line 1313] [def] [scope 1314] [securelevel_gt]
!1554 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1555, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1555 = metadata !{metadata !93, metadata !253, metadata !93}
!1556 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"securelevel_ge", metadata !"securelevel_ge", metadata !"", i32 1320, metadata !1554, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.ucred*, i32)* @securelevel_ge, null, null, metadata !1289, i32 1321} ; [ DW_TAG_subprogram ] [line 1320] [def] [scope 1321] [securelevel_ge]
!1557 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"cr_cansee", metadata !"cr_cansee", metadata !"", i32 1404, metadata !1558, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.ucred*, %struct.ucred*)* @cr_cansee, null, null, metadata !1289, i32 1405} ; [ DW_TAG_subprogram ] [line 1404] [def] [scope 1405] [cr_cansee]
!1558 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1559, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1559 = metadata !{metadata !93, metadata !253, metadata !253}
!1560 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"p_cansee", metadata !"p_cansee", metadata !"", i32 1429, metadata !1561, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.proc*)* @p_cansee, null, null, metadata !1289, i32 1430} ; [ DW_TAG_subprogram ] [line 1429] [def] [scope 1430] [p_cansee]
!1561 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1562, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1562 = metadata !{metadata !93, metadata !18, metadata !11}
!1563 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"cr_cansignal", metadata !"cr_cansignal", metadata !"", i32 1459, metadata !1564, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.ucred*, %struct.proc*, i32)* @cr_cansignal, null, null, metadata !1289, i32 1460} ; [ DW_TAG_subprogram ] [line 1459] [def] [scope 1460] [cr_cansignal]
!1564 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1565, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1565 = metadata !{metadata !93, metadata !253, metadata !11, metadata !93}
!1566 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"p_cansignal", metadata !"p_cansignal", metadata !"", i32 1537, metadata !1567, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.proc*, i32)* @p_cansignal, null, null, metadata !1289, i32 1538} ; [ DW_TAG_subprogram ] [line 1537] [def] [scope 1538] [p_cansignal]
!1567 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1568, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1568 = metadata !{metadata !93, metadata !18, metadata !11, metadata !93}
!1569 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"p_cansched", metadata !"p_cansched", metadata !"", i32 1578, metadata !1561, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.proc*)* @p_cansched, null, null, metadata !1289, i32 1579} ; [ DW_TAG_subprogram ] [line 1578] [def] [scope 1579] [p_cansched]
!1570 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"p_candebug", metadata !"p_candebug", metadata !"", i32 1630, metadata !1561, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.proc*)* @p_candebug, null, null, metadata !1289, i32 1631} ; [ DW_TAG_subprogram ] [line 1630] [def] [scope 1631] [p_candebug]
!1571 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"cr_canseesocket", metadata !"cr_canseesocket", metadata !"", i32 1724, metadata !1572, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.ucred*, %struct.socket*)* @cr_canseesocket, null, null, metadata !1289, i32 1725} ; [ DW_TAG_subprogram ] [line 1724] [def] [scope 1725] [cr_canseesocket]
!1572 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1573, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1573 = metadata !{metadata !93, metadata !253, metadata !1574}
!1574 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1575} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from socket]
!1575 = metadata !{i32 786451, metadata !1576, null, metadata !"socket", i32 71, i64 5440, i64 64, i32 0, i32 0, null, metadata !1577, i32 0, null, null} ; [ DW_TAG_structure_type ] [socket] [line 71, size 5440, align 64, offset 0] [from ]
!1576 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/socketvar.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!1577 = metadata !{metadata !1578, metadata !1579, metadata !1580, metadata !1581, metadata !1582, metadata !1583, metadata !1584, metadata !1585, metadata !1586, metadata !1590, metadata !1591, metadata !1597, metadata !1602, metadata !1607, metadata !1608, metadata !1609, metadata !1610, metadata !1611, metadata !1612, metadata !1613, metadata !1614, metadata !1620, metadata !1668, metadata !1669, metadata !1670, metadata !1671, metadata !1672, metadata !1675, metadata !1676, metadata !1701, metadata !1702}
!1578 = metadata !{i32 786445, metadata !1576, metadata !1575, metadata !"so_count", i32 72, i64 32, i64 32, i64 0, i32 0, metadata !93} ; [ DW_TAG_member ] [so_count] [line 72, size 32, align 32, offset 0] [from int]
!1579 = metadata !{i32 786445, metadata !1576, metadata !1575, metadata !"so_type", i32 73, i64 16, i64 16, i64 32, i32 0, metadata !236} ; [ DW_TAG_member ] [so_type] [line 73, size 16, align 16, offset 32] [from short]
!1580 = metadata !{i32 786445, metadata !1576, metadata !1575, metadata !"so_options", i32 74, i64 16, i64 16, i64 48, i32 0, metadata !236} ; [ DW_TAG_member ] [so_options] [line 74, size 16, align 16, offset 48] [from short]
!1581 = metadata !{i32 786445, metadata !1576, metadata !1575, metadata !"so_linger", i32 75, i64 16, i64 16, i64 64, i32 0, metadata !236} ; [ DW_TAG_member ] [so_linger] [line 75, size 16, align 16, offset 64] [from short]
!1582 = metadata !{i32 786445, metadata !1576, metadata !1575, metadata !"so_state", i32 76, i64 16, i64 16, i64 80, i32 0, metadata !236} ; [ DW_TAG_member ] [so_state] [line 76, size 16, align 16, offset 80] [from short]
!1583 = metadata !{i32 786445, metadata !1576, metadata !1575, metadata !"so_qstate", i32 77, i64 32, i64 32, i64 96, i32 0, metadata !93} ; [ DW_TAG_member ] [so_qstate] [line 77, size 32, align 32, offset 96] [from int]
!1584 = metadata !{i32 786445, metadata !1576, metadata !1575, metadata !"so_pcb", i32 78, i64 64, i64 64, i64 128, i32 0, metadata !178} ; [ DW_TAG_member ] [so_pcb] [line 78, size 64, align 64, offset 128] [from ]
!1585 = metadata !{i32 786445, metadata !1576, metadata !1575, metadata !"so_vnet", i32 79, i64 64, i64 64, i64 192, i32 0, metadata !365} ; [ DW_TAG_member ] [so_vnet] [line 79, size 64, align 64, offset 192] [from ]
!1586 = metadata !{i32 786445, metadata !1576, metadata !1575, metadata !"so_proto", i32 80, i64 64, i64 64, i64 256, i32 0, metadata !1587} ; [ DW_TAG_member ] [so_proto] [line 80, size 64, align 64, offset 256] [from ]
!1587 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1588} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from protosw]
!1588 = metadata !{i32 786451, metadata !1589, null, metadata !"protosw", i32 685, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [protosw] [line 685, size 0, align 0, offset 0] [fwd] [from ]
!1589 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/socket.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!1590 = metadata !{i32 786445, metadata !1576, metadata !1575, metadata !"so_head", i32 92, i64 64, i64 64, i64 320, i32 0, metadata !1574} ; [ DW_TAG_member ] [so_head] [line 92, size 64, align 64, offset 320] [from ]
!1591 = metadata !{i32 786445, metadata !1576, metadata !1575, metadata !"so_incomp", i32 93, i64 128, i64 64, i64 384, i32 0, metadata !1592} ; [ DW_TAG_member ] [so_incomp] [line 93, size 128, align 64, offset 384] [from ]
!1592 = metadata !{i32 786451, metadata !1576, metadata !1575, metadata !"", i32 93, i64 128, i64 64, i32 0, i32 0, null, metadata !1593, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 93, size 128, align 64, offset 0] [from ]
!1593 = metadata !{metadata !1594, metadata !1595}
!1594 = metadata !{i32 786445, metadata !1576, metadata !1592, metadata !"tqh_first", i32 93, i64 64, i64 64, i64 0, i32 0, metadata !1574} ; [ DW_TAG_member ] [tqh_first] [line 93, size 64, align 64, offset 0] [from ]
!1595 = metadata !{i32 786445, metadata !1576, metadata !1592, metadata !"tqh_last", i32 93, i64 64, i64 64, i64 64, i32 0, metadata !1596} ; [ DW_TAG_member ] [tqh_last] [line 93, size 64, align 64, offset 64] [from ]
!1596 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1574} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!1597 = metadata !{i32 786445, metadata !1576, metadata !1575, metadata !"so_comp", i32 94, i64 128, i64 64, i64 512, i32 0, metadata !1598} ; [ DW_TAG_member ] [so_comp] [line 94, size 128, align 64, offset 512] [from ]
!1598 = metadata !{i32 786451, metadata !1576, metadata !1575, metadata !"", i32 94, i64 128, i64 64, i32 0, i32 0, null, metadata !1599, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 94, size 128, align 64, offset 0] [from ]
!1599 = metadata !{metadata !1600, metadata !1601}
!1600 = metadata !{i32 786445, metadata !1576, metadata !1598, metadata !"tqh_first", i32 94, i64 64, i64 64, i64 0, i32 0, metadata !1574} ; [ DW_TAG_member ] [tqh_first] [line 94, size 64, align 64, offset 0] [from ]
!1601 = metadata !{i32 786445, metadata !1576, metadata !1598, metadata !"tqh_last", i32 94, i64 64, i64 64, i64 64, i32 0, metadata !1596} ; [ DW_TAG_member ] [tqh_last] [line 94, size 64, align 64, offset 64] [from ]
!1602 = metadata !{i32 786445, metadata !1576, metadata !1575, metadata !"so_list", i32 95, i64 128, i64 64, i64 640, i32 0, metadata !1603} ; [ DW_TAG_member ] [so_list] [line 95, size 128, align 64, offset 640] [from ]
!1603 = metadata !{i32 786451, metadata !1576, metadata !1575, metadata !"", i32 95, i64 128, i64 64, i32 0, i32 0, null, metadata !1604, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 95, size 128, align 64, offset 0] [from ]
!1604 = metadata !{metadata !1605, metadata !1606}
!1605 = metadata !{i32 786445, metadata !1576, metadata !1603, metadata !"tqe_next", i32 95, i64 64, i64 64, i64 0, i32 0, metadata !1574} ; [ DW_TAG_member ] [tqe_next] [line 95, size 64, align 64, offset 0] [from ]
!1606 = metadata !{i32 786445, metadata !1576, metadata !1603, metadata !"tqe_prev", i32 95, i64 64, i64 64, i64 64, i32 0, metadata !1596} ; [ DW_TAG_member ] [tqe_prev] [line 95, size 64, align 64, offset 64] [from ]
!1607 = metadata !{i32 786445, metadata !1576, metadata !1575, metadata !"so_qlen", i32 96, i64 16, i64 16, i64 768, i32 0, metadata !340} ; [ DW_TAG_member ] [so_qlen] [line 96, size 16, align 16, offset 768] [from u_short]
!1608 = metadata !{i32 786445, metadata !1576, metadata !1575, metadata !"so_incqlen", i32 97, i64 16, i64 16, i64 784, i32 0, metadata !340} ; [ DW_TAG_member ] [so_incqlen] [line 97, size 16, align 16, offset 784] [from u_short]
!1609 = metadata !{i32 786445, metadata !1576, metadata !1575, metadata !"so_qlimit", i32 99, i64 16, i64 16, i64 800, i32 0, metadata !340} ; [ DW_TAG_member ] [so_qlimit] [line 99, size 16, align 16, offset 800] [from u_short]
!1610 = metadata !{i32 786445, metadata !1576, metadata !1575, metadata !"so_timeo", i32 100, i64 16, i64 16, i64 816, i32 0, metadata !236} ; [ DW_TAG_member ] [so_timeo] [line 100, size 16, align 16, offset 816] [from short]
!1611 = metadata !{i32 786445, metadata !1576, metadata !1575, metadata !"so_error", i32 101, i64 16, i64 16, i64 832, i32 0, metadata !340} ; [ DW_TAG_member ] [so_error] [line 101, size 16, align 16, offset 832] [from u_short]
!1612 = metadata !{i32 786445, metadata !1576, metadata !1575, metadata !"so_sigio", i32 102, i64 64, i64 64, i64 896, i32 0, metadata !1025} ; [ DW_TAG_member ] [so_sigio] [line 102, size 64, align 64, offset 896] [from ]
!1613 = metadata !{i32 786445, metadata !1576, metadata !1575, metadata !"so_oobmark", i32 104, i64 64, i64 64, i64 960, i32 0, metadata !577} ; [ DW_TAG_member ] [so_oobmark] [line 104, size 64, align 64, offset 960] [from u_long]
!1614 = metadata !{i32 786445, metadata !1576, metadata !1575, metadata !"so_aiojobq", i32 105, i64 128, i64 64, i64 1024, i32 0, metadata !1615} ; [ DW_TAG_member ] [so_aiojobq] [line 105, size 128, align 64, offset 1024] [from ]
!1615 = metadata !{i32 786451, metadata !1576, metadata !1575, metadata !"", i32 105, i64 128, i64 64, i32 0, i32 0, null, metadata !1616, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 105, size 128, align 64, offset 0] [from ]
!1616 = metadata !{metadata !1617, metadata !1618}
!1617 = metadata !{i32 786445, metadata !1576, metadata !1615, metadata !"tqh_first", i32 105, i64 64, i64 64, i64 0, i32 0, metadata !706} ; [ DW_TAG_member ] [tqh_first] [line 105, size 64, align 64, offset 0] [from ]
!1618 = metadata !{i32 786445, metadata !1576, metadata !1615, metadata !"tqh_last", i32 105, i64 64, i64 64, i64 64, i32 0, metadata !1619} ; [ DW_TAG_member ] [tqh_last] [line 105, size 64, align 64, offset 64] [from ]
!1619 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !706} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!1620 = metadata !{i32 786445, metadata !1576, metadata !1575, metadata !"so_rcv", i32 107, i64 1920, i64 64, i64 1152, i32 0, metadata !1621} ; [ DW_TAG_member ] [so_rcv] [line 107, size 1920, align 64, offset 1152] [from sockbuf]
!1621 = metadata !{i32 786451, metadata !1622, null, metadata !"sockbuf", i32 80, i64 1920, i64 64, i32 0, i32 0, null, metadata !1623, i32 0, null, null} ; [ DW_TAG_structure_type ] [sockbuf] [line 80, size 1920, align 64, offset 0] [from ]
!1622 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/sockbuf.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!1623 = metadata !{metadata !1624, metadata !1638, metadata !1639, metadata !1645, metadata !1646, metadata !1649, metadata !1650, metadata !1651, metadata !1652, metadata !1653, metadata !1654, metadata !1655, metadata !1656, metadata !1657, metadata !1658, metadata !1659, metadata !1660, metadata !1661, metadata !1662, metadata !1663, metadata !1667}
!1624 = metadata !{i32 786445, metadata !1622, metadata !1621, metadata !"sb_sel", i32 81, i64 576, i64 64, i64 0, i32 0, metadata !1625} ; [ DW_TAG_member ] [sb_sel] [line 81, size 576, align 64, offset 0] [from selinfo]
!1625 = metadata !{i32 786451, metadata !1626, null, metadata !"selinfo", i32 45, i64 576, i64 64, i32 0, i32 0, null, metadata !1627, i32 0, null, null} ; [ DW_TAG_structure_type ] [selinfo] [line 45, size 576, align 64, offset 0] [from ]
!1626 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/selinfo.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!1627 = metadata !{metadata !1628, metadata !1636, metadata !1637}
!1628 = metadata !{i32 786445, metadata !1626, metadata !1625, metadata !"si_tdlist", i32 46, i64 128, i64 64, i64 0, i32 0, metadata !1629} ; [ DW_TAG_member ] [si_tdlist] [line 46, size 128, align 64, offset 0] [from selfdlist]
!1629 = metadata !{i32 786451, metadata !1626, null, metadata !"selfdlist", i32 39, i64 128, i64 64, i32 0, i32 0, null, metadata !1630, i32 0, null, null} ; [ DW_TAG_structure_type ] [selfdlist] [line 39, size 128, align 64, offset 0] [from ]
!1630 = metadata !{metadata !1631, metadata !1634}
!1631 = metadata !{i32 786445, metadata !1626, metadata !1629, metadata !"tqh_first", i32 39, i64 64, i64 64, i64 0, i32 0, metadata !1632} ; [ DW_TAG_member ] [tqh_first] [line 39, size 64, align 64, offset 0] [from ]
!1632 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1633} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from selfd]
!1633 = metadata !{i32 786451, metadata !1626, null, metadata !"selfd", i32 38, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [selfd] [line 38, size 0, align 0, offset 0] [fwd] [from ]
!1634 = metadata !{i32 786445, metadata !1626, metadata !1629, metadata !"tqh_last", i32 39, i64 64, i64 64, i64 64, i32 0, metadata !1635} ; [ DW_TAG_member ] [tqh_last] [line 39, size 64, align 64, offset 64] [from ]
!1635 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1632} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!1636 = metadata !{i32 786445, metadata !1626, metadata !1625, metadata !"si_note", i32 47, i64 384, i64 64, i64 128, i32 0, metadata !663} ; [ DW_TAG_member ] [si_note] [line 47, size 384, align 64, offset 128] [from knlist]
!1637 = metadata !{i32 786445, metadata !1626, metadata !1625, metadata !"si_mtx", i32 48, i64 64, i64 64, i64 512, i32 0, metadata !23} ; [ DW_TAG_member ] [si_mtx] [line 48, size 64, align 64, offset 512] [from ]
!1638 = metadata !{i32 786445, metadata !1622, metadata !1621, metadata !"sb_mtx", i32 82, i64 256, i64 64, i64 576, i32 0, metadata !24} ; [ DW_TAG_member ] [sb_mtx] [line 82, size 256, align 64, offset 576] [from mtx]
!1639 = metadata !{i32 786445, metadata !1622, metadata !1621, metadata !"sb_sx", i32 83, i64 256, i64 64, i64 832, i32 0, metadata !1640} ; [ DW_TAG_member ] [sb_sx] [line 83, size 256, align 64, offset 832] [from sx]
!1640 = metadata !{i32 786451, metadata !1641, null, metadata !"sx", i32 37, i64 256, i64 64, i32 0, i32 0, null, metadata !1642, i32 0, null, null} ; [ DW_TAG_structure_type ] [sx] [line 37, size 256, align 64, offset 0] [from ]
!1641 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/_sx.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!1642 = metadata !{metadata !1643, metadata !1644}
!1643 = metadata !{i32 786445, metadata !1641, metadata !1640, metadata !"lock_object", i32 38, i64 192, i64 64, i64 0, i32 0, metadata !28} ; [ DW_TAG_member ] [lock_object] [line 38, size 192, align 64, offset 0] [from lock_object]
!1644 = metadata !{i32 786445, metadata !1641, metadata !1640, metadata !"sx_lock", i32 39, i64 64, i64 64, i64 192, i32 0, metadata !43} ; [ DW_TAG_member ] [sx_lock] [line 39, size 64, align 64, offset 192] [from ]
!1645 = metadata !{i32 786445, metadata !1622, metadata !1621, metadata !"sb_state", i32 84, i64 16, i64 16, i64 1088, i32 0, metadata !236} ; [ DW_TAG_member ] [sb_state] [line 84, size 16, align 16, offset 1088] [from short]
!1646 = metadata !{i32 786445, metadata !1622, metadata !1621, metadata !"sb_mb", i32 86, i64 64, i64 64, i64 1152, i32 0, metadata !1647} ; [ DW_TAG_member ] [sb_mb] [line 86, size 64, align 64, offset 1152] [from ]
!1647 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1648} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from mbuf]
!1648 = metadata !{i32 786451, metadata !1622, null, metadata !"mbuf", i32 60, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [mbuf] [line 60, size 0, align 0, offset 0] [fwd] [from ]
!1649 = metadata !{i32 786445, metadata !1622, metadata !1621, metadata !"sb_mbtail", i32 87, i64 64, i64 64, i64 1216, i32 0, metadata !1647} ; [ DW_TAG_member ] [sb_mbtail] [line 87, size 64, align 64, offset 1216] [from ]
!1650 = metadata !{i32 786445, metadata !1622, metadata !1621, metadata !"sb_lastrecord", i32 88, i64 64, i64 64, i64 1280, i32 0, metadata !1647} ; [ DW_TAG_member ] [sb_lastrecord] [line 88, size 64, align 64, offset 1280] [from ]
!1651 = metadata !{i32 786445, metadata !1622, metadata !1621, metadata !"sb_sndptr", i32 90, i64 64, i64 64, i64 1344, i32 0, metadata !1647} ; [ DW_TAG_member ] [sb_sndptr] [line 90, size 64, align 64, offset 1344] [from ]
!1652 = metadata !{i32 786445, metadata !1622, metadata !1621, metadata !"sb_sndptroff", i32 91, i64 32, i64 32, i64 1408, i32 0, metadata !36} ; [ DW_TAG_member ] [sb_sndptroff] [line 91, size 32, align 32, offset 1408] [from u_int]
!1653 = metadata !{i32 786445, metadata !1622, metadata !1621, metadata !"sb_cc", i32 92, i64 32, i64 32, i64 1440, i32 0, metadata !36} ; [ DW_TAG_member ] [sb_cc] [line 92, size 32, align 32, offset 1440] [from u_int]
!1654 = metadata !{i32 786445, metadata !1622, metadata !1621, metadata !"sb_hiwat", i32 93, i64 32, i64 32, i64 1472, i32 0, metadata !36} ; [ DW_TAG_member ] [sb_hiwat] [line 93, size 32, align 32, offset 1472] [from u_int]
!1655 = metadata !{i32 786445, metadata !1622, metadata !1621, metadata !"sb_mbcnt", i32 94, i64 32, i64 32, i64 1504, i32 0, metadata !36} ; [ DW_TAG_member ] [sb_mbcnt] [line 94, size 32, align 32, offset 1504] [from u_int]
!1656 = metadata !{i32 786445, metadata !1622, metadata !1621, metadata !"sb_mcnt", i32 95, i64 32, i64 32, i64 1536, i32 0, metadata !36} ; [ DW_TAG_member ] [sb_mcnt] [line 95, size 32, align 32, offset 1536] [from u_int]
!1657 = metadata !{i32 786445, metadata !1622, metadata !1621, metadata !"sb_ccnt", i32 96, i64 32, i64 32, i64 1568, i32 0, metadata !36} ; [ DW_TAG_member ] [sb_ccnt] [line 96, size 32, align 32, offset 1568] [from u_int]
!1658 = metadata !{i32 786445, metadata !1622, metadata !1621, metadata !"sb_mbmax", i32 97, i64 32, i64 32, i64 1600, i32 0, metadata !36} ; [ DW_TAG_member ] [sb_mbmax] [line 97, size 32, align 32, offset 1600] [from u_int]
!1659 = metadata !{i32 786445, metadata !1622, metadata !1621, metadata !"sb_ctl", i32 98, i64 32, i64 32, i64 1632, i32 0, metadata !36} ; [ DW_TAG_member ] [sb_ctl] [line 98, size 32, align 32, offset 1632] [from u_int]
!1660 = metadata !{i32 786445, metadata !1622, metadata !1621, metadata !"sb_lowat", i32 99, i64 32, i64 32, i64 1664, i32 0, metadata !93} ; [ DW_TAG_member ] [sb_lowat] [line 99, size 32, align 32, offset 1664] [from int]
!1661 = metadata !{i32 786445, metadata !1622, metadata !1621, metadata !"sb_timeo", i32 100, i64 32, i64 32, i64 1696, i32 0, metadata !93} ; [ DW_TAG_member ] [sb_timeo] [line 100, size 32, align 32, offset 1696] [from int]
!1662 = metadata !{i32 786445, metadata !1622, metadata !1621, metadata !"sb_flags", i32 101, i64 16, i64 16, i64 1728, i32 0, metadata !236} ; [ DW_TAG_member ] [sb_flags] [line 101, size 16, align 16, offset 1728] [from short]
!1663 = metadata !{i32 786445, metadata !1622, metadata !1621, metadata !"sb_upcall", i32 102, i64 64, i64 64, i64 1792, i32 0, metadata !1664} ; [ DW_TAG_member ] [sb_upcall] [line 102, size 64, align 64, offset 1792] [from ]
!1664 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1665} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!1665 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1666, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1666 = metadata !{metadata !93, metadata !1574, metadata !178, metadata !93}
!1667 = metadata !{i32 786445, metadata !1622, metadata !1621, metadata !"sb_upcallarg", i32 103, i64 64, i64 64, i64 1856, i32 0, metadata !178} ; [ DW_TAG_member ] [sb_upcallarg] [line 103, size 64, align 64, offset 1856] [from ]
!1668 = metadata !{i32 786445, metadata !1576, metadata !1575, metadata !"so_snd", i32 107, i64 1920, i64 64, i64 3072, i32 0, metadata !1621} ; [ DW_TAG_member ] [so_snd] [line 107, size 1920, align 64, offset 3072] [from sockbuf]
!1669 = metadata !{i32 786445, metadata !1576, metadata !1575, metadata !"so_cred", i32 109, i64 64, i64 64, i64 4992, i32 0, metadata !253} ; [ DW_TAG_member ] [so_cred] [line 109, size 64, align 64, offset 4992] [from ]
!1670 = metadata !{i32 786445, metadata !1576, metadata !1575, metadata !"so_label", i32 110, i64 64, i64 64, i64 5056, i32 0, metadata !478} ; [ DW_TAG_member ] [so_label] [line 110, size 64, align 64, offset 5056] [from ]
!1671 = metadata !{i32 786445, metadata !1576, metadata !1575, metadata !"so_peerlabel", i32 111, i64 64, i64 64, i64 5120, i32 0, metadata !478} ; [ DW_TAG_member ] [so_peerlabel] [line 111, size 64, align 64, offset 5120] [from ]
!1672 = metadata !{i32 786445, metadata !1576, metadata !1575, metadata !"so_gencnt", i32 113, i64 64, i64 64, i64 5184, i32 0, metadata !1673} ; [ DW_TAG_member ] [so_gencnt] [line 113, size 64, align 64, offset 5184] [from so_gen_t]
!1673 = metadata !{i32 786454, metadata !1576, null, metadata !"so_gen_t", i32 56, i64 0, i64 0, i64 0, i32 0, metadata !1674} ; [ DW_TAG_typedef ] [so_gen_t] [line 56, size 0, align 0, offset 0] [from u_quad_t]
!1674 = metadata !{i32 786454, metadata !1576, null, metadata !"u_quad_t", i32 70, i64 0, i64 0, i64 0, i32 0, metadata !46} ; [ DW_TAG_typedef ] [u_quad_t] [line 70, size 0, align 0, offset 0] [from __uint64_t]
!1675 = metadata !{i32 786445, metadata !1576, metadata !1575, metadata !"so_emuldata", i32 114, i64 64, i64 64, i64 5248, i32 0, metadata !178} ; [ DW_TAG_member ] [so_emuldata] [line 114, size 64, align 64, offset 5248] [from ]
!1676 = metadata !{i32 786445, metadata !1576, metadata !1575, metadata !"so_accf", i32 119, i64 64, i64 64, i64 5312, i32 0, metadata !1677} ; [ DW_TAG_member ] [so_accf] [line 119, size 64, align 64, offset 5312] [from ]
!1677 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1678} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from so_accf]
!1678 = metadata !{i32 786451, metadata !1576, null, metadata !"so_accf", i32 115, i64 192, i64 64, i32 0, i32 0, null, metadata !1679, i32 0, null, null} ; [ DW_TAG_structure_type ] [so_accf] [line 115, size 192, align 64, offset 0] [from ]
!1679 = metadata !{metadata !1680, metadata !1699, metadata !1700}
!1680 = metadata !{i32 786445, metadata !1576, metadata !1678, metadata !"so_accept_filter", i32 116, i64 64, i64 64, i64 0, i32 0, metadata !1681} ; [ DW_TAG_member ] [so_accept_filter] [line 116, size 64, align 64, offset 0] [from ]
!1681 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1682} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from accept_filter]
!1682 = metadata !{i32 786451, metadata !1576, null, metadata !"accept_filter", i32 278, i64 384, i64 64, i32 0, i32 0, null, metadata !1683, i32 0, null, null} ; [ DW_TAG_structure_type ] [accept_filter] [line 278, size 384, align 64, offset 0] [from ]
!1683 = metadata !{metadata !1684, metadata !1686, metadata !1687, metadata !1691, metadata !1695}
!1684 = metadata !{i32 786445, metadata !1576, metadata !1682, metadata !"accf_name", i32 279, i64 128, i64 8, i64 0, i32 0, metadata !1685} ; [ DW_TAG_member ] [accf_name] [line 279, size 128, align 8, offset 0] [from ]
!1685 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 128, i64 8, i32 0, i32 0, metadata !34, metadata !404, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 128, align 8, offset 0] [from char]
!1686 = metadata !{i32 786445, metadata !1576, metadata !1682, metadata !"accf_callback", i32 280, i64 64, i64 64, i64 128, i32 0, metadata !1664} ; [ DW_TAG_member ] [accf_callback] [line 280, size 64, align 64, offset 128] [from ]
!1687 = metadata !{i32 786445, metadata !1576, metadata !1682, metadata !"accf_create", i32 282, i64 64, i64 64, i64 192, i32 0, metadata !1688} ; [ DW_TAG_member ] [accf_create] [line 282, size 64, align 64, offset 192] [from ]
!1688 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1689} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!1689 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1690, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1690 = metadata !{metadata !178, metadata !1574, metadata !570}
!1691 = metadata !{i32 786445, metadata !1576, metadata !1682, metadata !"accf_destroy", i32 284, i64 64, i64 64, i64 256, i32 0, metadata !1692} ; [ DW_TAG_member ] [accf_destroy] [line 284, size 64, align 64, offset 256] [from ]
!1692 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1693} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!1693 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1694, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1694 = metadata !{null, metadata !1574}
!1695 = metadata !{i32 786445, metadata !1576, metadata !1682, metadata !"accf_next", i32 286, i64 64, i64 64, i64 320, i32 0, metadata !1696} ; [ DW_TAG_member ] [accf_next] [line 286, size 64, align 64, offset 320] [from ]
!1696 = metadata !{i32 786451, metadata !1576, metadata !1682, metadata !"", i32 286, i64 64, i64 64, i32 0, i32 0, null, metadata !1697, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 286, size 64, align 64, offset 0] [from ]
!1697 = metadata !{metadata !1698}
!1698 = metadata !{i32 786445, metadata !1576, metadata !1696, metadata !"sle_next", i32 286, i64 64, i64 64, i64 0, i32 0, metadata !1681} ; [ DW_TAG_member ] [sle_next] [line 286, size 64, align 64, offset 0] [from ]
!1699 = metadata !{i32 786445, metadata !1576, metadata !1678, metadata !"so_accept_filter_arg", i32 117, i64 64, i64 64, i64 64, i32 0, metadata !178} ; [ DW_TAG_member ] [so_accept_filter_arg] [line 117, size 64, align 64, offset 64] [from ]
!1700 = metadata !{i32 786445, metadata !1576, metadata !1678, metadata !"so_accept_filter_str", i32 118, i64 64, i64 64, i64 128, i32 0, metadata !570} ; [ DW_TAG_member ] [so_accept_filter_str] [line 118, size 64, align 64, offset 128] [from ]
!1701 = metadata !{i32 786445, metadata !1576, metadata !1575, metadata !"so_fibnum", i32 126, i64 32, i64 32, i64 5376, i32 0, metadata !93} ; [ DW_TAG_member ] [so_fibnum] [line 126, size 32, align 32, offset 5376] [from int]
!1702 = metadata !{i32 786445, metadata !1576, metadata !1575, metadata !"so_user_cookie", i32 127, i64 32, i64 32, i64 5408, i32 0, metadata !414} ; [ DW_TAG_member ] [so_user_cookie] [line 127, size 32, align 32, offset 5408] [from uint32_t]
!1703 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"cr_canseeinpcb", metadata !"cr_canseeinpcb", metadata !"", i32 1750, metadata !1704, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.ucred*, %struct.inpcb*)* @cr_canseeinpcb, null, null, metadata !1289, i32 1751} ; [ DW_TAG_subprogram ] [line 1750] [def] [scope 1751] [cr_canseeinpcb]
!1704 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1705, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1705 = metadata !{metadata !93, metadata !253, metadata !1706}
!1706 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1707} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from inpcb]
!1707 = metadata !{i32 786451, metadata !1708, null, metadata !"inpcb", i32 163, i64 3136, i64 64, i32 0, i32 0, null, metadata !1709, i32 0, null, null} ; [ DW_TAG_structure_type ] [inpcb] [line 163, size 3136, align 64, offset 0] [from ]
!1708 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/netinet/in_pcb.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!1709 = metadata !{metadata !1710, metadata !1716, metadata !1721, metadata !1726, metadata !1727, metadata !1784, metadata !1785, metadata !1790, metadata !1791, metadata !1792, metadata !1793, metadata !1794, metadata !1795, metadata !1796, metadata !1797, metadata !1798, metadata !1799, metadata !1800, metadata !1801, metadata !1805, metadata !1809, metadata !1837, metadata !1838, metadata !1841, metadata !1849, metadata !1864, metadata !1869, metadata !1870, metadata !1872, metadata !1875, metadata !1878}
!1710 = metadata !{i32 786445, metadata !1708, metadata !1707, metadata !"inp_hash", i32 164, i64 128, i64 64, i64 0, i32 0, metadata !1711} ; [ DW_TAG_member ] [inp_hash] [line 164, size 128, align 64, offset 0] [from ]
!1711 = metadata !{i32 786451, metadata !1708, metadata !1707, metadata !"", i32 164, i64 128, i64 64, i32 0, i32 0, null, metadata !1712, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 164, size 128, align 64, offset 0] [from ]
!1712 = metadata !{metadata !1713, metadata !1714}
!1713 = metadata !{i32 786445, metadata !1708, metadata !1711, metadata !"le_next", i32 164, i64 64, i64 64, i64 0, i32 0, metadata !1706} ; [ DW_TAG_member ] [le_next] [line 164, size 64, align 64, offset 0] [from ]
!1714 = metadata !{i32 786445, metadata !1708, metadata !1711, metadata !"le_prev", i32 164, i64 64, i64 64, i64 64, i32 0, metadata !1715} ; [ DW_TAG_member ] [le_prev] [line 164, size 64, align 64, offset 64] [from ]
!1715 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1706} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!1716 = metadata !{i32 786445, metadata !1708, metadata !1707, metadata !"inp_pcbgrouphash", i32 165, i64 128, i64 64, i64 128, i32 0, metadata !1717} ; [ DW_TAG_member ] [inp_pcbgrouphash] [line 165, size 128, align 64, offset 128] [from ]
!1717 = metadata !{i32 786451, metadata !1708, metadata !1707, metadata !"", i32 165, i64 128, i64 64, i32 0, i32 0, null, metadata !1718, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 165, size 128, align 64, offset 0] [from ]
!1718 = metadata !{metadata !1719, metadata !1720}
!1719 = metadata !{i32 786445, metadata !1708, metadata !1717, metadata !"le_next", i32 165, i64 64, i64 64, i64 0, i32 0, metadata !1706} ; [ DW_TAG_member ] [le_next] [line 165, size 64, align 64, offset 0] [from ]
!1720 = metadata !{i32 786445, metadata !1708, metadata !1717, metadata !"le_prev", i32 165, i64 64, i64 64, i64 64, i32 0, metadata !1715} ; [ DW_TAG_member ] [le_prev] [line 165, size 64, align 64, offset 64] [from ]
!1721 = metadata !{i32 786445, metadata !1708, metadata !1707, metadata !"inp_list", i32 166, i64 128, i64 64, i64 256, i32 0, metadata !1722} ; [ DW_TAG_member ] [inp_list] [line 166, size 128, align 64, offset 256] [from ]
!1722 = metadata !{i32 786451, metadata !1708, metadata !1707, metadata !"", i32 166, i64 128, i64 64, i32 0, i32 0, null, metadata !1723, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 166, size 128, align 64, offset 0] [from ]
!1723 = metadata !{metadata !1724, metadata !1725}
!1724 = metadata !{i32 786445, metadata !1708, metadata !1722, metadata !"le_next", i32 166, i64 64, i64 64, i64 0, i32 0, metadata !1706} ; [ DW_TAG_member ] [le_next] [line 166, size 64, align 64, offset 0] [from ]
!1725 = metadata !{i32 786445, metadata !1708, metadata !1722, metadata !"le_prev", i32 166, i64 64, i64 64, i64 64, i32 0, metadata !1715} ; [ DW_TAG_member ] [le_prev] [line 166, size 64, align 64, offset 64] [from ]
!1726 = metadata !{i32 786445, metadata !1708, metadata !1707, metadata !"inp_ppcb", i32 167, i64 64, i64 64, i64 384, i32 0, metadata !178} ; [ DW_TAG_member ] [inp_ppcb] [line 167, size 64, align 64, offset 384] [from ]
!1727 = metadata !{i32 786445, metadata !1708, metadata !1707, metadata !"inp_pcbinfo", i32 168, i64 64, i64 64, i64 448, i32 0, metadata !1728} ; [ DW_TAG_member ] [inp_pcbinfo] [line 168, size 64, align 64, offset 448] [from ]
!1728 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1729} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from inpcbinfo]
!1729 = metadata !{i32 786451, metadata !1708, null, metadata !"inpcbinfo", i32 291, i64 1536, i64 64, i32 0, i32 0, null, metadata !1730, i32 0, null, null} ; [ DW_TAG_structure_type ] [inpcbinfo] [line 291, size 1536, align 64, offset 0] [from ]
!1730 = metadata !{metadata !1731, metadata !1737, metadata !1742, metadata !1743, metadata !1744, metadata !1745, metadata !1746, metadata !1747, metadata !1750, metadata !1758, metadata !1759, metadata !1760, metadata !1761, metadata !1762, metadata !1763, metadata !1779, metadata !1780, metadata !1781, metadata !1782, metadata !1783}
!1731 = metadata !{i32 786445, metadata !1708, metadata !1729, metadata !"ipi_lock", i32 295, i64 256, i64 64, i64 0, i32 0, metadata !1732} ; [ DW_TAG_member ] [ipi_lock] [line 295, size 256, align 64, offset 0] [from rwlock]
!1732 = metadata !{i32 786451, metadata !1733, null, metadata !"rwlock", i32 46, i64 256, i64 64, i32 0, i32 0, null, metadata !1734, i32 0, null, null} ; [ DW_TAG_structure_type ] [rwlock] [line 46, size 256, align 64, offset 0] [from ]
!1733 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/_rwlock.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!1734 = metadata !{metadata !1735, metadata !1736}
!1735 = metadata !{i32 786445, metadata !1733, metadata !1732, metadata !"lock_object", i32 47, i64 192, i64 64, i64 0, i32 0, metadata !28} ; [ DW_TAG_member ] [lock_object] [line 47, size 192, align 64, offset 0] [from lock_object]
!1736 = metadata !{i32 786445, metadata !1733, metadata !1732, metadata !"rw_lock", i32 48, i64 64, i64 64, i64 192, i32 0, metadata !43} ; [ DW_TAG_member ] [rw_lock] [line 48, size 64, align 64, offset 192] [from ]
!1737 = metadata !{i32 786445, metadata !1708, metadata !1729, metadata !"ipi_listhead", i32 300, i64 64, i64 64, i64 256, i32 0, metadata !1738} ; [ DW_TAG_member ] [ipi_listhead] [line 300, size 64, align 64, offset 256] [from ]
!1738 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1739} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from inpcbhead]
!1739 = metadata !{i32 786451, metadata !1708, null, metadata !"inpcbhead", i32 65, i64 64, i64 64, i32 0, i32 0, null, metadata !1740, i32 0, null, null} ; [ DW_TAG_structure_type ] [inpcbhead] [line 65, size 64, align 64, offset 0] [from ]
!1740 = metadata !{metadata !1741}
!1741 = metadata !{i32 786445, metadata !1708, metadata !1739, metadata !"lh_first", i32 65, i64 64, i64 64, i64 0, i32 0, metadata !1706} ; [ DW_TAG_member ] [lh_first] [line 65, size 64, align 64, offset 0] [from ]
!1742 = metadata !{i32 786445, metadata !1708, metadata !1729, metadata !"ipi_count", i32 301, i64 32, i64 32, i64 320, i32 0, metadata !36} ; [ DW_TAG_member ] [ipi_count] [line 301, size 32, align 32, offset 320] [from u_int]
!1743 = metadata !{i32 786445, metadata !1708, metadata !1729, metadata !"ipi_gencnt", i32 307, i64 64, i64 64, i64 384, i32 0, metadata !1674} ; [ DW_TAG_member ] [ipi_gencnt] [line 307, size 64, align 64, offset 384] [from u_quad_t]
!1744 = metadata !{i32 786445, metadata !1708, metadata !1729, metadata !"ipi_lastport", i32 312, i64 16, i64 16, i64 448, i32 0, metadata !340} ; [ DW_TAG_member ] [ipi_lastport] [line 312, size 16, align 16, offset 448] [from u_short]
!1745 = metadata !{i32 786445, metadata !1708, metadata !1729, metadata !"ipi_lastlow", i32 313, i64 16, i64 16, i64 464, i32 0, metadata !340} ; [ DW_TAG_member ] [ipi_lastlow] [line 313, size 16, align 16, offset 464] [from u_short]
!1746 = metadata !{i32 786445, metadata !1708, metadata !1729, metadata !"ipi_lasthi", i32 314, i64 16, i64 16, i64 480, i32 0, metadata !340} ; [ DW_TAG_member ] [ipi_lasthi] [line 314, size 16, align 16, offset 480] [from u_short]
!1747 = metadata !{i32 786445, metadata !1708, metadata !1729, metadata !"ipi_zone", i32 319, i64 64, i64 64, i64 512, i32 0, metadata !1748} ; [ DW_TAG_member ] [ipi_zone] [line 319, size 64, align 64, offset 512] [from ]
!1748 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1749} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from uma_zone]
!1749 = metadata !{i32 786451, metadata !4, null, metadata !"uma_zone", i32 829, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [uma_zone] [line 829, size 0, align 0, offset 0] [fwd] [from ]
!1750 = metadata !{i32 786445, metadata !1708, metadata !1729, metadata !"ipi_pcbgroups", i32 326, i64 64, i64 64, i64 576, i32 0, metadata !1751} ; [ DW_TAG_member ] [ipi_pcbgroups] [line 326, size 64, align 64, offset 576] [from ]
!1751 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1752} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from inpcbgroup]
!1752 = metadata !{i32 786451, metadata !1708, null, metadata !"inpcbgroup", i32 372, i64 1024, i64 1024, i32 0, i32 0, null, metadata !1753, i32 0, null, null} ; [ DW_TAG_structure_type ] [inpcbgroup] [line 372, size 1024, align 1024, offset 0] [from ]
!1753 = metadata !{metadata !1754, metadata !1755, metadata !1756, metadata !1757}
!1754 = metadata !{i32 786445, metadata !1708, metadata !1752, metadata !"ipg_hashbase", i32 377, i64 64, i64 64, i64 0, i32 0, metadata !1738} ; [ DW_TAG_member ] [ipg_hashbase] [line 377, size 64, align 64, offset 0] [from ]
!1755 = metadata !{i32 786445, metadata !1708, metadata !1752, metadata !"ipg_hashmask", i32 378, i64 64, i64 64, i64 64, i32 0, metadata !577} ; [ DW_TAG_member ] [ipg_hashmask] [line 378, size 64, align 64, offset 64] [from u_long]
!1756 = metadata !{i32 786445, metadata !1708, metadata !1752, metadata !"ipg_cpu", i32 383, i64 32, i64 32, i64 128, i32 0, metadata !36} ; [ DW_TAG_member ] [ipg_cpu] [line 383, size 32, align 32, offset 128] [from u_int]
!1757 = metadata !{i32 786445, metadata !1708, metadata !1752, metadata !"ipg_lock", i32 390, i64 256, i64 64, i64 192, i32 0, metadata !24} ; [ DW_TAG_member ] [ipg_lock] [line 390, size 256, align 64, offset 192] [from mtx]
!1758 = metadata !{i32 786445, metadata !1708, metadata !1729, metadata !"ipi_npcbgroups", i32 327, i64 32, i64 32, i64 640, i32 0, metadata !36} ; [ DW_TAG_member ] [ipi_npcbgroups] [line 327, size 32, align 32, offset 640] [from u_int]
!1759 = metadata !{i32 786445, metadata !1708, metadata !1729, metadata !"ipi_hashfields", i32 328, i64 32, i64 32, i64 672, i32 0, metadata !36} ; [ DW_TAG_member ] [ipi_hashfields] [line 328, size 32, align 32, offset 672] [from u_int]
!1760 = metadata !{i32 786445, metadata !1708, metadata !1729, metadata !"ipi_hash_lock", i32 333, i64 256, i64 64, i64 704, i32 0, metadata !1732} ; [ DW_TAG_member ] [ipi_hash_lock] [line 333, size 256, align 64, offset 704] [from rwlock]
!1761 = metadata !{i32 786445, metadata !1708, metadata !1729, metadata !"ipi_hashbase", i32 339, i64 64, i64 64, i64 960, i32 0, metadata !1738} ; [ DW_TAG_member ] [ipi_hashbase] [line 339, size 64, align 64, offset 960] [from ]
!1762 = metadata !{i32 786445, metadata !1708, metadata !1729, metadata !"ipi_hashmask", i32 340, i64 64, i64 64, i64 1024, i32 0, metadata !577} ; [ DW_TAG_member ] [ipi_hashmask] [line 340, size 64, align 64, offset 1024] [from u_long]
!1763 = metadata !{i32 786445, metadata !1708, metadata !1729, metadata !"ipi_porthashbase", i32 345, i64 64, i64 64, i64 1088, i32 0, metadata !1764} ; [ DW_TAG_member ] [ipi_porthashbase] [line 345, size 64, align 64, offset 1088] [from ]
!1764 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1765} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from inpcbporthead]
!1765 = metadata !{i32 786451, metadata !1708, null, metadata !"inpcbporthead", i32 66, i64 64, i64 64, i32 0, i32 0, null, metadata !1766, i32 0, null, null} ; [ DW_TAG_structure_type ] [inpcbporthead] [line 66, size 64, align 64, offset 0] [from ]
!1766 = metadata !{metadata !1767}
!1767 = metadata !{i32 786445, metadata !1708, metadata !1765, metadata !"lh_first", i32 66, i64 64, i64 64, i64 0, i32 0, metadata !1768} ; [ DW_TAG_member ] [lh_first] [line 66, size 64, align 64, offset 0] [from ]
!1768 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1769} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from inpcbport]
!1769 = metadata !{i32 786451, metadata !1708, null, metadata !"inpcbport", i32 267, i64 256, i64 64, i32 0, i32 0, null, metadata !1770, i32 0, null, null} ; [ DW_TAG_structure_type ] [inpcbport] [line 267, size 256, align 64, offset 0] [from ]
!1770 = metadata !{metadata !1771, metadata !1777, metadata !1778}
!1771 = metadata !{i32 786445, metadata !1708, metadata !1769, metadata !"phd_hash", i32 268, i64 128, i64 64, i64 0, i32 0, metadata !1772} ; [ DW_TAG_member ] [phd_hash] [line 268, size 128, align 64, offset 0] [from ]
!1772 = metadata !{i32 786451, metadata !1708, metadata !1769, metadata !"", i32 268, i64 128, i64 64, i32 0, i32 0, null, metadata !1773, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 268, size 128, align 64, offset 0] [from ]
!1773 = metadata !{metadata !1774, metadata !1775}
!1774 = metadata !{i32 786445, metadata !1708, metadata !1772, metadata !"le_next", i32 268, i64 64, i64 64, i64 0, i32 0, metadata !1768} ; [ DW_TAG_member ] [le_next] [line 268, size 64, align 64, offset 0] [from ]
!1775 = metadata !{i32 786445, metadata !1708, metadata !1772, metadata !"le_prev", i32 268, i64 64, i64 64, i64 64, i32 0, metadata !1776} ; [ DW_TAG_member ] [le_prev] [line 268, size 64, align 64, offset 64] [from ]
!1776 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1768} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!1777 = metadata !{i32 786445, metadata !1708, metadata !1769, metadata !"phd_pcblist", i32 269, i64 64, i64 64, i64 128, i32 0, metadata !1739} ; [ DW_TAG_member ] [phd_pcblist] [line 269, size 64, align 64, offset 128] [from inpcbhead]
!1778 = metadata !{i32 786445, metadata !1708, metadata !1769, metadata !"phd_port", i32 270, i64 16, i64 16, i64 192, i32 0, metadata !340} ; [ DW_TAG_member ] [phd_port] [line 270, size 16, align 16, offset 192] [from u_short]
!1779 = metadata !{i32 786445, metadata !1708, metadata !1729, metadata !"ipi_porthashmask", i32 346, i64 64, i64 64, i64 1152, i32 0, metadata !577} ; [ DW_TAG_member ] [ipi_porthashmask] [line 346, size 64, align 64, offset 1152] [from u_long]
!1780 = metadata !{i32 786445, metadata !1708, metadata !1729, metadata !"ipi_wildbase", i32 353, i64 64, i64 64, i64 1216, i32 0, metadata !1738} ; [ DW_TAG_member ] [ipi_wildbase] [line 353, size 64, align 64, offset 1216] [from ]
!1781 = metadata !{i32 786445, metadata !1708, metadata !1729, metadata !"ipi_wildmask", i32 354, i64 64, i64 64, i64 1280, i32 0, metadata !577} ; [ DW_TAG_member ] [ipi_wildmask] [line 354, size 64, align 64, offset 1280] [from u_long]
!1782 = metadata !{i32 786445, metadata !1708, metadata !1729, metadata !"ipi_vnet", i32 359, i64 64, i64 64, i64 1344, i32 0, metadata !365} ; [ DW_TAG_member ] [ipi_vnet] [line 359, size 64, align 64, offset 1344] [from ]
!1783 = metadata !{i32 786445, metadata !1708, metadata !1729, metadata !"ipi_pspare", i32 364, i64 128, i64 64, i64 1408, i32 0, metadata !474} ; [ DW_TAG_member ] [ipi_pspare] [line 364, size 128, align 64, offset 1408] [from ]
!1784 = metadata !{i32 786445, metadata !1708, metadata !1707, metadata !"inp_pcbgroup", i32 169, i64 64, i64 64, i64 512, i32 0, metadata !1751} ; [ DW_TAG_member ] [inp_pcbgroup] [line 169, size 64, align 64, offset 512] [from ]
!1785 = metadata !{i32 786445, metadata !1708, metadata !1707, metadata !"inp_pcbgroup_wild", i32 170, i64 128, i64 64, i64 576, i32 0, metadata !1786} ; [ DW_TAG_member ] [inp_pcbgroup_wild] [line 170, size 128, align 64, offset 576] [from ]
!1786 = metadata !{i32 786451, metadata !1708, metadata !1707, metadata !"", i32 170, i64 128, i64 64, i32 0, i32 0, null, metadata !1787, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 170, size 128, align 64, offset 0] [from ]
!1787 = metadata !{metadata !1788, metadata !1789}
!1788 = metadata !{i32 786445, metadata !1708, metadata !1786, metadata !"le_next", i32 170, i64 64, i64 64, i64 0, i32 0, metadata !1706} ; [ DW_TAG_member ] [le_next] [line 170, size 64, align 64, offset 0] [from ]
!1789 = metadata !{i32 786445, metadata !1708, metadata !1786, metadata !"le_prev", i32 170, i64 64, i64 64, i64 64, i32 0, metadata !1715} ; [ DW_TAG_member ] [le_prev] [line 170, size 64, align 64, offset 64] [from ]
!1790 = metadata !{i32 786445, metadata !1708, metadata !1707, metadata !"inp_socket", i32 171, i64 64, i64 64, i64 704, i32 0, metadata !1574} ; [ DW_TAG_member ] [inp_socket] [line 171, size 64, align 64, offset 704] [from ]
!1791 = metadata !{i32 786445, metadata !1708, metadata !1707, metadata !"inp_cred", i32 172, i64 64, i64 64, i64 768, i32 0, metadata !253} ; [ DW_TAG_member ] [inp_cred] [line 172, size 64, align 64, offset 768] [from ]
!1792 = metadata !{i32 786445, metadata !1708, metadata !1707, metadata !"inp_flow", i32 173, i64 32, i64 32, i64 832, i32 0, metadata !499} ; [ DW_TAG_member ] [inp_flow] [line 173, size 32, align 32, offset 832] [from u_int32_t]
!1793 = metadata !{i32 786445, metadata !1708, metadata !1707, metadata !"inp_flags", i32 174, i64 32, i64 32, i64 864, i32 0, metadata !93} ; [ DW_TAG_member ] [inp_flags] [line 174, size 32, align 32, offset 864] [from int]
!1794 = metadata !{i32 786445, metadata !1708, metadata !1707, metadata !"inp_flags2", i32 175, i64 32, i64 32, i64 896, i32 0, metadata !93} ; [ DW_TAG_member ] [inp_flags2] [line 175, size 32, align 32, offset 896] [from int]
!1795 = metadata !{i32 786445, metadata !1708, metadata !1707, metadata !"inp_vflag", i32 176, i64 8, i64 8, i64 928, i32 0, metadata !221} ; [ DW_TAG_member ] [inp_vflag] [line 176, size 8, align 8, offset 928] [from u_char]
!1796 = metadata !{i32 786445, metadata !1708, metadata !1707, metadata !"inp_ip_ttl", i32 177, i64 8, i64 8, i64 936, i32 0, metadata !221} ; [ DW_TAG_member ] [inp_ip_ttl] [line 177, size 8, align 8, offset 936] [from u_char]
!1797 = metadata !{i32 786445, metadata !1708, metadata !1707, metadata !"inp_ip_p", i32 178, i64 8, i64 8, i64 944, i32 0, metadata !221} ; [ DW_TAG_member ] [inp_ip_p] [line 178, size 8, align 8, offset 944] [from u_char]
!1798 = metadata !{i32 786445, metadata !1708, metadata !1707, metadata !"inp_ip_minttl", i32 179, i64 8, i64 8, i64 952, i32 0, metadata !221} ; [ DW_TAG_member ] [inp_ip_minttl] [line 179, size 8, align 8, offset 952] [from u_char]
!1799 = metadata !{i32 786445, metadata !1708, metadata !1707, metadata !"inp_flowid", i32 180, i64 32, i64 32, i64 960, i32 0, metadata !414} ; [ DW_TAG_member ] [inp_flowid] [line 180, size 32, align 32, offset 960] [from uint32_t]
!1800 = metadata !{i32 786445, metadata !1708, metadata !1707, metadata !"inp_refcount", i32 181, i64 32, i64 32, i64 992, i32 0, metadata !36} ; [ DW_TAG_member ] [inp_refcount] [line 181, size 32, align 32, offset 992] [from u_int]
!1801 = metadata !{i32 786445, metadata !1708, metadata !1707, metadata !"inp_pspare", i32 182, i64 320, i64 64, i64 1024, i32 0, metadata !1802} ; [ DW_TAG_member ] [inp_pspare] [line 182, size 320, align 64, offset 1024] [from ]
!1802 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 320, i64 64, i32 0, i32 0, metadata !178, metadata !1803, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 320, align 64, offset 0] [from ]
!1803 = metadata !{metadata !1804}
!1804 = metadata !{i32 786465, i64 0, i64 5}      ; [ DW_TAG_subrange_type ] [0, 4]
!1805 = metadata !{i32 786445, metadata !1708, metadata !1707, metadata !"inp_ispare", i32 183, i64 192, i64 32, i64 1344, i32 0, metadata !1806} ; [ DW_TAG_member ] [inp_ispare] [line 183, size 192, align 32, offset 1344] [from ]
!1806 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 192, i64 32, i32 0, i32 0, metadata !36, metadata !1807, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 192, align 32, offset 0] [from u_int]
!1807 = metadata !{metadata !1808}
!1808 = metadata !{i32 786465, i64 0, i64 6}      ; [ DW_TAG_subrange_type ] [0, 5]
!1809 = metadata !{i32 786445, metadata !1708, metadata !1707, metadata !"inp_inc", i32 187, i64 320, i64 32, i64 1536, i32 0, metadata !1810} ; [ DW_TAG_member ] [inp_inc] [line 187, size 320, align 32, offset 1536] [from in_conninfo]
!1810 = metadata !{i32 786451, metadata !1708, null, metadata !"in_conninfo", i32 107, i64 320, i64 32, i32 0, i32 0, null, metadata !1811, i32 0, null, null} ; [ DW_TAG_structure_type ] [in_conninfo] [line 107, size 320, align 32, offset 0] [from ]
!1811 = metadata !{metadata !1812, metadata !1814, metadata !1815, metadata !1817}
!1812 = metadata !{i32 786445, metadata !1708, metadata !1810, metadata !"inc_flags", i32 108, i64 8, i64 8, i64 0, i32 0, metadata !1813} ; [ DW_TAG_member ] [inc_flags] [line 108, size 8, align 8, offset 0] [from u_int8_t]
!1813 = metadata !{i32 786454, metadata !1708, null, metadata !"u_int8_t", i32 65, i64 0, i64 0, i64 0, i32 0, metadata !403} ; [ DW_TAG_typedef ] [u_int8_t] [line 65, size 0, align 0, offset 0] [from __uint8_t]
!1814 = metadata !{i32 786445, metadata !1708, metadata !1810, metadata !"inc_len", i32 109, i64 8, i64 8, i64 8, i32 0, metadata !1813} ; [ DW_TAG_member ] [inc_len] [line 109, size 8, align 8, offset 8] [from u_int8_t]
!1815 = metadata !{i32 786445, metadata !1708, metadata !1810, metadata !"inc_fibnum", i32 110, i64 16, i64 16, i64 16, i32 0, metadata !1816} ; [ DW_TAG_member ] [inc_fibnum] [line 110, size 16, align 16, offset 16] [from u_int16_t]
!1816 = metadata !{i32 786454, metadata !1708, null, metadata !"u_int16_t", i32 66, i64 0, i64 0, i64 0, i32 0, metadata !409} ; [ DW_TAG_typedef ] [u_int16_t] [line 66, size 0, align 0, offset 0] [from __uint16_t]
!1817 = metadata !{i32 786445, metadata !1708, metadata !1810, metadata !"inc_ie", i32 112, i64 288, i64 32, i64 32, i32 0, metadata !1818} ; [ DW_TAG_member ] [inc_ie] [line 112, size 288, align 32, offset 32] [from in_endpoints]
!1818 = metadata !{i32 786451, metadata !1708, null, metadata !"in_endpoints", i32 83, i64 288, i64 32, i32 0, i32 0, null, metadata !1819, i32 0, null, null} ; [ DW_TAG_structure_type ] [in_endpoints] [line 83, size 288, align 32, offset 0] [from ]
!1819 = metadata !{metadata !1820, metadata !1821, metadata !1822, metadata !1832}
!1820 = metadata !{i32 786445, metadata !1708, metadata !1818, metadata !"ie_fport", i32 84, i64 16, i64 16, i64 0, i32 0, metadata !1816} ; [ DW_TAG_member ] [ie_fport] [line 84, size 16, align 16, offset 0] [from u_int16_t]
!1821 = metadata !{i32 786445, metadata !1708, metadata !1818, metadata !"ie_lport", i32 85, i64 16, i64 16, i64 16, i32 0, metadata !1816} ; [ DW_TAG_member ] [ie_lport] [line 85, size 16, align 16, offset 16] [from u_int16_t]
!1822 = metadata !{i32 786445, metadata !1708, metadata !1818, metadata !"ie_dependfaddr", i32 91, i64 128, i64 32, i64 32, i32 0, metadata !1823} ; [ DW_TAG_member ] [ie_dependfaddr] [line 91, size 128, align 32, offset 32] [from ]
!1823 = metadata !{i32 786455, metadata !1708, metadata !1818, metadata !"", i32 87, i64 128, i64 32, i64 0, i32 0, null, metadata !1824, i32 0, i32 0, null} ; [ DW_TAG_union_type ] [line 87, size 128, align 32, offset 0] [from ]
!1824 = metadata !{metadata !1825, metadata !1831}
!1825 = metadata !{i32 786445, metadata !1708, metadata !1823, metadata !"ie46_foreign", i32 89, i64 128, i64 32, i64 0, i32 0, metadata !1826} ; [ DW_TAG_member ] [ie46_foreign] [line 89, size 128, align 32, offset 0] [from in_addr_4in6]
!1826 = metadata !{i32 786451, metadata !1708, null, metadata !"in_addr_4in6", i32 74, i64 128, i64 32, i32 0, i32 0, null, metadata !1827, i32 0, null, null} ; [ DW_TAG_structure_type ] [in_addr_4in6] [line 74, size 128, align 32, offset 0] [from ]
!1827 = metadata !{metadata !1828, metadata !1830}
!1828 = metadata !{i32 786445, metadata !1708, metadata !1826, metadata !"ia46_pad32", i32 75, i64 96, i64 32, i64 0, i32 0, metadata !1829} ; [ DW_TAG_member ] [ia46_pad32] [line 75, size 96, align 32, offset 0] [from ]
!1829 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 96, i64 32, i32 0, i32 0, metadata !499, metadata !433, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 96, align 32, offset 0] [from u_int32_t]
!1830 = metadata !{i32 786445, metadata !1708, metadata !1826, metadata !"ia46_addr4", i32 76, i64 32, i64 32, i64 96, i32 0, metadata !387} ; [ DW_TAG_member ] [ia46_addr4] [line 76, size 32, align 32, offset 96] [from in_addr]
!1831 = metadata !{i32 786445, metadata !1708, metadata !1823, metadata !"ie6_foreign", i32 90, i64 128, i64 32, i64 0, i32 0, metadata !394} ; [ DW_TAG_member ] [ie6_foreign] [line 90, size 128, align 32, offset 0] [from in6_addr]
!1832 = metadata !{i32 786445, metadata !1708, metadata !1818, metadata !"ie_dependladdr", i32 96, i64 128, i64 32, i64 160, i32 0, metadata !1833} ; [ DW_TAG_member ] [ie_dependladdr] [line 96, size 128, align 32, offset 160] [from ]
!1833 = metadata !{i32 786455, metadata !1708, metadata !1818, metadata !"", i32 92, i64 128, i64 32, i64 0, i32 0, null, metadata !1834, i32 0, i32 0, null} ; [ DW_TAG_union_type ] [line 92, size 128, align 32, offset 0] [from ]
!1834 = metadata !{metadata !1835, metadata !1836}
!1835 = metadata !{i32 786445, metadata !1708, metadata !1833, metadata !"ie46_local", i32 94, i64 128, i64 32, i64 0, i32 0, metadata !1826} ; [ DW_TAG_member ] [ie46_local] [line 94, size 128, align 32, offset 0] [from in_addr_4in6]
!1836 = metadata !{i32 786445, metadata !1708, metadata !1833, metadata !"ie6_local", i32 95, i64 128, i64 32, i64 0, i32 0, metadata !394} ; [ DW_TAG_member ] [ie6_local] [line 95, size 128, align 32, offset 0] [from in6_addr]
!1837 = metadata !{i32 786445, metadata !1708, metadata !1707, metadata !"inp_label", i32 190, i64 64, i64 64, i64 1856, i32 0, metadata !478} ; [ DW_TAG_member ] [inp_label] [line 190, size 64, align 64, offset 1856] [from ]
!1838 = metadata !{i32 786445, metadata !1708, metadata !1707, metadata !"inp_sp", i32 191, i64 64, i64 64, i64 1920, i32 0, metadata !1839} ; [ DW_TAG_member ] [inp_sp] [line 191, size 64, align 64, offset 1920] [from ]
!1839 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1840} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from inpcbpolicy]
!1840 = metadata !{i32 786451, metadata !1708, null, metadata !"inpcbpolicy", i32 55, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [inpcbpolicy] [line 55, size 0, align 0, offset 0] [fwd] [from ]
!1841 = metadata !{i32 786445, metadata !1708, metadata !1707, metadata !"inp_depend4", i32 198, i64 192, i64 64, i64 1984, i32 0, metadata !1842} ; [ DW_TAG_member ] [inp_depend4] [line 198, size 192, align 64, offset 1984] [from ]
!1842 = metadata !{i32 786451, metadata !1708, metadata !1707, metadata !"", i32 194, i64 192, i64 64, i32 0, i32 0, null, metadata !1843, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 194, size 192, align 64, offset 0] [from ]
!1843 = metadata !{metadata !1844, metadata !1845, metadata !1846}
!1844 = metadata !{i32 786445, metadata !1708, metadata !1842, metadata !"inp4_ip_tos", i32 195, i64 8, i64 8, i64 0, i32 0, metadata !221} ; [ DW_TAG_member ] [inp4_ip_tos] [line 195, size 8, align 8, offset 0] [from u_char]
!1845 = metadata !{i32 786445, metadata !1708, metadata !1842, metadata !"inp4_options", i32 196, i64 64, i64 64, i64 64, i32 0, metadata !1647} ; [ DW_TAG_member ] [inp4_options] [line 196, size 64, align 64, offset 64] [from ]
!1846 = metadata !{i32 786445, metadata !1708, metadata !1842, metadata !"inp4_moptions", i32 197, i64 64, i64 64, i64 128, i32 0, metadata !1847} ; [ DW_TAG_member ] [inp4_moptions] [line 197, size 64, align 64, offset 128] [from ]
!1847 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1848} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ip_moptions]
!1848 = metadata !{i32 786451, metadata !1708, null, metadata !"ip_moptions", i32 197, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [ip_moptions] [line 197, size 0, align 0, offset 0] [fwd] [from ]
!1849 = metadata !{i32 786445, metadata !1708, metadata !1707, metadata !"inp_depend6", i32 211, i64 320, i64 64, i64 2176, i32 0, metadata !1850} ; [ DW_TAG_member ] [inp_depend6] [line 211, size 320, align 64, offset 2176] [from ]
!1850 = metadata !{i32 786451, metadata !1708, metadata !1707, metadata !"", i32 199, i64 320, i64 64, i32 0, i32 0, null, metadata !1851, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 199, size 320, align 64, offset 0] [from ]
!1851 = metadata !{metadata !1852, metadata !1853, metadata !1856, metadata !1859, metadata !1862, metadata !1863}
!1852 = metadata !{i32 786445, metadata !1708, metadata !1850, metadata !"inp6_options", i32 201, i64 64, i64 64, i64 0, i32 0, metadata !1647} ; [ DW_TAG_member ] [inp6_options] [line 201, size 64, align 64, offset 0] [from ]
!1853 = metadata !{i32 786445, metadata !1708, metadata !1850, metadata !"inp6_outputopts", i32 203, i64 64, i64 64, i64 64, i32 0, metadata !1854} ; [ DW_TAG_member ] [inp6_outputopts] [line 203, size 64, align 64, offset 64] [from ]
!1854 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1855} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ip6_pktopts]
!1855 = metadata !{i32 786451, metadata !1708, null, metadata !"ip6_pktopts", i32 203, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [ip6_pktopts] [line 203, size 0, align 0, offset 0] [fwd] [from ]
!1856 = metadata !{i32 786445, metadata !1708, metadata !1850, metadata !"inp6_moptions", i32 205, i64 64, i64 64, i64 128, i32 0, metadata !1857} ; [ DW_TAG_member ] [inp6_moptions] [line 205, size 64, align 64, offset 128] [from ]
!1857 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1858} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ip6_moptions]
!1858 = metadata !{i32 786451, metadata !1708, null, metadata !"ip6_moptions", i32 205, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [ip6_moptions] [line 205, size 0, align 0, offset 0] [fwd] [from ]
!1859 = metadata !{i32 786445, metadata !1708, metadata !1850, metadata !"inp6_icmp6filt", i32 207, i64 64, i64 64, i64 192, i32 0, metadata !1860} ; [ DW_TAG_member ] [inp6_icmp6filt] [line 207, size 64, align 64, offset 192] [from ]
!1860 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1861} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from icmp6_filter]
!1861 = metadata !{i32 786451, metadata !1708, null, metadata !"icmp6_filter", i32 128, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [icmp6_filter] [line 128, size 0, align 0, offset 0] [fwd] [from ]
!1862 = metadata !{i32 786445, metadata !1708, metadata !1850, metadata !"inp6_cksum", i32 209, i64 32, i64 32, i64 256, i32 0, metadata !93} ; [ DW_TAG_member ] [inp6_cksum] [line 209, size 32, align 32, offset 256] [from int]
!1863 = metadata !{i32 786445, metadata !1708, metadata !1850, metadata !"inp6_hops", i32 210, i64 16, i64 16, i64 288, i32 0, metadata !236} ; [ DW_TAG_member ] [inp6_hops] [line 210, size 16, align 16, offset 288] [from short]
!1864 = metadata !{i32 786445, metadata !1708, metadata !1707, metadata !"inp_portlist", i32 212, i64 128, i64 64, i64 2496, i32 0, metadata !1865} ; [ DW_TAG_member ] [inp_portlist] [line 212, size 128, align 64, offset 2496] [from ]
!1865 = metadata !{i32 786451, metadata !1708, metadata !1707, metadata !"", i32 212, i64 128, i64 64, i32 0, i32 0, null, metadata !1866, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 212, size 128, align 64, offset 0] [from ]
!1866 = metadata !{metadata !1867, metadata !1868}
!1867 = metadata !{i32 786445, metadata !1708, metadata !1865, metadata !"le_next", i32 212, i64 64, i64 64, i64 0, i32 0, metadata !1706} ; [ DW_TAG_member ] [le_next] [line 212, size 64, align 64, offset 0] [from ]
!1868 = metadata !{i32 786445, metadata !1708, metadata !1865, metadata !"le_prev", i32 212, i64 64, i64 64, i64 64, i32 0, metadata !1715} ; [ DW_TAG_member ] [le_prev] [line 212, size 64, align 64, offset 64] [from ]
!1869 = metadata !{i32 786445, metadata !1708, metadata !1707, metadata !"inp_phd", i32 213, i64 64, i64 64, i64 2624, i32 0, metadata !1768} ; [ DW_TAG_member ] [inp_phd] [line 213, size 64, align 64, offset 2624] [from ]
!1870 = metadata !{i32 786445, metadata !1708, metadata !1707, metadata !"inp_gencnt", i32 215, i64 64, i64 64, i64 2688, i32 0, metadata !1871} ; [ DW_TAG_member ] [inp_gencnt] [line 215, size 64, align 64, offset 2688] [from inp_gen_t]
!1871 = metadata !{i32 786454, metadata !1708, null, metadata !"inp_gen_t", i32 67, i64 0, i64 0, i64 0, i32 0, metadata !1674} ; [ DW_TAG_typedef ] [inp_gen_t] [line 67, size 0, align 0, offset 0] [from u_quad_t]
!1872 = metadata !{i32 786445, metadata !1708, metadata !1707, metadata !"inp_lle", i32 216, i64 64, i64 64, i64 2752, i32 0, metadata !1873} ; [ DW_TAG_member ] [inp_lle] [line 216, size 64, align 64, offset 2752] [from ]
!1873 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1874} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from llentry]
!1874 = metadata !{i32 786451, metadata !395, null, metadata !"llentry", i32 378, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [llentry] [line 378, size 0, align 0, offset 0] [fwd] [from ]
!1875 = metadata !{i32 786445, metadata !1708, metadata !1707, metadata !"inp_rt", i32 217, i64 64, i64 64, i64 2816, i32 0, metadata !1876} ; [ DW_TAG_member ] [inp_rt] [line 217, size 64, align 64, offset 2816] [from ]
!1876 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1877} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from rtentry]
!1877 = metadata !{i32 786451, metadata !395, null, metadata !"rtentry", i32 377, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [rtentry] [line 377, size 0, align 0, offset 0] [fwd] [from ]
!1878 = metadata !{i32 786445, metadata !1708, metadata !1707, metadata !"inp_lock", i32 218, i64 256, i64 64, i64 2880, i32 0, metadata !1732} ; [ DW_TAG_member ] [inp_lock] [line 218, size 256, align 64, offset 2880] [from rwlock]
!1879 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"p_canwait", metadata !"p_canwait", metadata !"", i32 1782, metadata !1561, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.proc*)* @p_canwait, null, null, metadata !1289, i32 1783} ; [ DW_TAG_subprogram ] [line 1782] [def] [scope 1783] [p_canwait]
!1880 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"crget", metadata !"crget", metadata !"", i32 1807, metadata !1881, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, %struct.ucred* ()* @crget, null, null, metadata !1289, i32 1808} ; [ DW_TAG_subprogram ] [line 1807] [def] [scope 1808] [crget]
!1881 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1882, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1882 = metadata !{metadata !253}
!1883 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"crhold", metadata !"crhold", metadata !"", i32 1827, metadata !1884, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, %struct.ucred* (%struct.ucred*)* @crhold, null, null, metadata !1289, i32 1828} ; [ DW_TAG_subprogram ] [line 1827] [def] [scope 1828] [crhold]
!1884 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1885, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1885 = metadata !{metadata !253, metadata !253}
!1886 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"crfree", metadata !"crfree", metadata !"", i32 1838, metadata !1887, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (%struct.ucred*)* @crfree, null, null, metadata !1289, i32 1839} ; [ DW_TAG_subprogram ] [line 1838] [def] [scope 1839] [crfree]
!1887 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1888, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1888 = metadata !{null, metadata !253}
!1889 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"crshared", metadata !"crshared", metadata !"", i32 1875, metadata !1890, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.ucred*)* @crshared, null, null, metadata !1289, i32 1876} ; [ DW_TAG_subprogram ] [line 1875] [def] [scope 1876] [crshared]
!1890 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1891, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1891 = metadata !{metadata !93, metadata !253}
!1892 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"crcopy", metadata !"crcopy", metadata !"", i32 1885, metadata !1893, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (%struct.ucred*, %struct.ucred*)* @crcopy, null, null, metadata !1289, i32 1886} ; [ DW_TAG_subprogram ] [line 1885] [def] [scope 1886] [crcopy]
!1893 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1894, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1894 = metadata !{null, metadata !253, metadata !253}
!1895 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"crdup", metadata !"crdup", metadata !"", i32 1909, metadata !1884, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, %struct.ucred* (%struct.ucred*)* @crdup, null, null, metadata !1289, i32 1910} ; [ DW_TAG_subprogram ] [line 1909] [def] [scope 1910] [crdup]
!1896 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"cru2x", metadata !"cru2x", metadata !"", i32 1922, metadata !1897, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (%struct.ucred*, %struct.xucred*)* @cru2x, null, null, metadata !1289, i32 1923} ; [ DW_TAG_subprogram ] [line 1922] [def] [scope 1923] [cru2x]
!1897 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1898, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1898 = metadata !{null, metadata !253, metadata !1899}
!1899 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1900} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from xucred]
!1900 = metadata !{i32 786451, metadata !147, null, metadata !"xucred", i32 82, i64 704, i64 64, i32 0, i32 0, null, metadata !1901, i32 0, null, null} ; [ DW_TAG_structure_type ] [xucred] [line 82, size 704, align 64, offset 0] [from ]
!1901 = metadata !{metadata !1902, metadata !1903, metadata !1904, metadata !1905, metadata !1907}
!1902 = metadata !{i32 786445, metadata !147, metadata !1900, metadata !"cr_version", i32 83, i64 32, i64 32, i64 0, i32 0, metadata !36} ; [ DW_TAG_member ] [cr_version] [line 83, size 32, align 32, offset 0] [from u_int]
!1903 = metadata !{i32 786445, metadata !147, metadata !1900, metadata !"cr_uid", i32 84, i64 32, i64 32, i64 32, i32 0, metadata !258} ; [ DW_TAG_member ] [cr_uid] [line 84, size 32, align 32, offset 32] [from uid_t]
!1904 = metadata !{i32 786445, metadata !147, metadata !1900, metadata !"cr_ngroups", i32 85, i64 16, i64 16, i64 64, i32 0, metadata !236} ; [ DW_TAG_member ] [cr_ngroups] [line 85, size 16, align 16, offset 64] [from short]
!1905 = metadata !{i32 786445, metadata !147, metadata !1900, metadata !"cr_groups", i32 86, i64 512, i64 32, i64 96, i32 0, metadata !1906} ; [ DW_TAG_member ] [cr_groups] [line 86, size 512, align 32, offset 96] [from ]
!1906 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 512, i64 32, i32 0, i32 0, metadata !263, metadata !404, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 512, align 32, offset 0] [from gid_t]
!1907 = metadata !{i32 786445, metadata !147, metadata !1900, metadata !"_cr_unused1", i32 87, i64 64, i64 64, i64 640, i32 0, metadata !178} ; [ DW_TAG_member ] [_cr_unused1] [line 87, size 64, align 64, offset 640] [from ]
!1908 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"cred_update_thread", metadata !"cred_update_thread", metadata !"", i32 1941, metadata !1909, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (%struct.thread*)* @cred_update_thread, null, null, metadata !1289, i32 1942} ; [ DW_TAG_subprogram ] [line 1941] [def] [scope 1942] [cred_update_thread]
!1909 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1910, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1910 = metadata !{null, metadata !18}
!1911 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"crcopysafe", metadata !"crcopysafe", metadata !"", i32 1956, metadata !1912, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, %struct.ucred* (%struct.proc*, %struct.ucred*)* @crcopysafe, null, null, metadata !1289, i32 1957} ; [ DW_TAG_subprogram ] [line 1956] [def] [scope 1957] [crcopysafe]
!1912 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1913, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1913 = metadata !{metadata !253, metadata !11, metadata !253}
!1914 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"crsetgroups", metadata !"crsetgroups", metadata !"", i32 2055, metadata !1915, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (%struct.ucred*, i32, i32*)* @crsetgroups, null, null, metadata !1289, i32 2056} ; [ DW_TAG_subprogram ] [line 2055] [def] [scope 2056] [crsetgroups]
!1915 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1916, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1916 = metadata !{null, metadata !253, metadata !93, metadata !509}
!1917 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"sys_getlogin", metadata !"sys_getlogin", metadata !"", i32 2076, metadata !1918, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.getlogin_args*)* @sys_getlogin, null, null, metadata !1289, i32 2077} ; [ DW_TAG_subprogram ] [line 2076] [def] [scope 2077] [sys_getlogin]
!1918 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1919, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1919 = metadata !{metadata !93, metadata !18, metadata !1920}
!1920 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1921} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from getlogin_args]
!1921 = metadata !{i32 786451, metadata !742, null, metadata !"getlogin_args", i32 206, i64 128, i64 64, i32 0, i32 0, null, metadata !1922, i32 0, null, null} ; [ DW_TAG_structure_type ] [getlogin_args] [line 206, size 128, align 64, offset 0] [from ]
!1922 = metadata !{metadata !1923, metadata !1924, metadata !1925, metadata !1926, metadata !1927, metadata !1928}
!1923 = metadata !{i32 786445, metadata !742, metadata !1921, metadata !"namebuf_l_", i32 207, i64 0, i64 8, i64 0, i32 0, metadata !1320} ; [ DW_TAG_member ] [namebuf_l_] [line 207, size 0, align 8, offset 0] [from ]
!1924 = metadata !{i32 786445, metadata !742, metadata !1921, metadata !"namebuf", i32 207, i64 64, i64 64, i64 0, i32 0, metadata !570} ; [ DW_TAG_member ] [namebuf] [line 207, size 64, align 64, offset 0] [from ]
!1925 = metadata !{i32 786445, metadata !742, metadata !1921, metadata !"namebuf_r_", i32 207, i64 0, i64 8, i64 64, i32 0, metadata !1320} ; [ DW_TAG_member ] [namebuf_r_] [line 207, size 0, align 8, offset 64] [from ]
!1926 = metadata !{i32 786445, metadata !742, metadata !1921, metadata !"namelen_l_", i32 208, i64 0, i64 8, i64 64, i32 0, metadata !1320} ; [ DW_TAG_member ] [namelen_l_] [line 208, size 0, align 8, offset 64] [from ]
!1927 = metadata !{i32 786445, metadata !742, metadata !1921, metadata !"namelen", i32 208, i64 32, i64 32, i64 64, i32 0, metadata !36} ; [ DW_TAG_member ] [namelen] [line 208, size 32, align 32, offset 64] [from u_int]
!1928 = metadata !{i32 786445, metadata !742, metadata !1921, metadata !"namelen_r_", i32 208, i64 32, i64 8, i64 96, i32 0, metadata !1325} ; [ DW_TAG_member ] [namelen_r_] [line 208, size 32, align 8, offset 96] [from ]
!1929 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"sys_setlogin", metadata !"sys_setlogin", metadata !"", i32 2105, metadata !1930, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.setlogin_args*)* @sys_setlogin, null, null, metadata !1289, i32 2106} ; [ DW_TAG_subprogram ] [line 2105] [def] [scope 2106] [sys_setlogin]
!1930 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1931, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1931 = metadata !{metadata !93, metadata !18, metadata !1932}
!1932 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1933} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from setlogin_args]
!1933 = metadata !{i32 786451, metadata !742, null, metadata !"setlogin_args", i32 210, i64 64, i64 64, i32 0, i32 0, null, metadata !1934, i32 0, null, null} ; [ DW_TAG_structure_type ] [setlogin_args] [line 210, size 64, align 64, offset 0] [from ]
!1934 = metadata !{metadata !1935, metadata !1936, metadata !1937}
!1935 = metadata !{i32 786445, metadata !742, metadata !1933, metadata !"namebuf_l_", i32 211, i64 0, i64 8, i64 0, i32 0, metadata !1320} ; [ DW_TAG_member ] [namebuf_l_] [line 211, size 0, align 8, offset 0] [from ]
!1936 = metadata !{i32 786445, metadata !742, metadata !1933, metadata !"namebuf", i32 211, i64 64, i64 64, i64 0, i32 0, metadata !570} ; [ DW_TAG_member ] [namebuf] [line 211, size 64, align 64, offset 0] [from ]
!1937 = metadata !{i32 786445, metadata !742, metadata !1933, metadata !"namebuf_r_", i32 211, i64 0, i64 8, i64 64, i32 0, metadata !1320} ; [ DW_TAG_member ] [namebuf_r_] [line 211, size 0, align 8, offset 64] [from ]
!1938 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"setsugid", metadata !"setsugid", metadata !"", i32 2129, metadata !1939, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (%struct.proc*)* @setsugid, null, null, metadata !1289, i32 2130} ; [ DW_TAG_subprogram ] [line 2129] [def] [scope 2130] [setsugid]
!1939 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1940, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1940 = metadata !{null, metadata !11}
!1941 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"change_euid", metadata !"change_euid", metadata !"", i32 2145, metadata !1942, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (%struct.ucred*, %struct.uidinfo*)* @change_euid, null, null, metadata !1289, i32 2146} ; [ DW_TAG_subprogram ] [line 2145] [def] [scope 2146] [change_euid]
!1942 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1943, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1943 = metadata !{null, metadata !253, metadata !267}
!1944 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"change_egid", metadata !"change_egid", metadata !"", i32 2173, metadata !1945, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (%struct.ucred*, i32)* @change_egid, null, null, metadata !1289, i32 2174} ; [ DW_TAG_subprogram ] [line 2173] [def] [scope 2174] [change_egid]
!1945 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1946, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1946 = metadata !{null, metadata !253, metadata !263}
!1947 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"change_ruid", metadata !"change_ruid", metadata !"", i32 2197, metadata !1942, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (%struct.ucred*, %struct.uidinfo*)* @change_ruid, null, null, metadata !1289, i32 2198} ; [ DW_TAG_subprogram ] [line 2197] [def] [scope 2198] [change_ruid]
!1948 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"change_rgid", metadata !"change_rgid", metadata !"", i32 2225, metadata !1945, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (%struct.ucred*, i32)* @change_rgid, null, null, metadata !1289, i32 2226} ; [ DW_TAG_subprogram ] [line 2225] [def] [scope 2226] [change_rgid]
!1949 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"change_svuid", metadata !"change_svuid", metadata !"", i32 2247, metadata !1950, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (%struct.ucred*, i32)* @change_svuid, null, null, metadata !1289, i32 2248} ; [ DW_TAG_subprogram ] [line 2247] [def] [scope 2248] [change_svuid]
!1950 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1951, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1951 = metadata !{null, metadata !253, metadata !258}
!1952 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"change_svgid", metadata !"change_svgid", metadata !"", i32 2269, metadata !1945, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (%struct.ucred*, i32)* @change_svgid, null, null, metadata !1289, i32 2270} ; [ DW_TAG_subprogram ] [line 2269] [def] [scope 2270] [change_svgid]
!1953 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"crsetgroups_locked", metadata !"crsetgroups_locked", metadata !"", i32 2023, metadata !1915, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (%struct.ucred*, i32, i32*)* @crsetgroups_locked, null, null, metadata !1289, i32 2024} ; [ DW_TAG_subprogram ] [line 2023] [local] [def] [scope 2024] [crsetgroups_locked]
!1954 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"crextend", metadata !"crextend", metadata !"", i32 1980, metadata !1955, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (%struct.ucred*, i32)* @crextend, null, null, metadata !1289, i32 1981} ; [ DW_TAG_subprogram ] [line 1980] [local] [def] [scope 1981] [crextend]
!1955 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1956, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1956 = metadata !{null, metadata !253, metadata !93}
!1957 = metadata !{i32 786478, metadata !1958, metadata !1959, metadata !"refcount_release", metadata !"refcount_release", metadata !"", i32 60, metadata !1960, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32*)* @refcount_release, null, null, metadata !1289, i32 61} ; [ DW_TAG_subprogram ] [line 60] [local] [def] [scope 61] [refcount_release]
!1958 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/refcount.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!1959 = metadata !{i32 786473, metadata !1958}    ; [ DW_TAG_file_type ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/refcount.h]
!1960 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1961, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1961 = metadata !{metadata !93, metadata !1962}
!1962 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !91} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!1963 = metadata !{i32 786478, metadata !1964, metadata !1965, metadata !"atomic_fetchadd_int", metadata !"atomic_fetchadd_int", metadata !"", i32 181, metadata !1966, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32*, i32)* @atomic_fetchadd_int, null, null, metadata !1289, i32 182} ; [ DW_TAG_subprogram ] [line 181] [local] [def] [scope 182] [atomic_fetchadd_int]
!1964 = metadata !{metadata !"./machine/atomic.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!1965 = metadata !{i32 786473, metadata !1964}    ; [ DW_TAG_file_type ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA/./machine/atomic.h]
!1966 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1967, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1967 = metadata !{metadata !36, metadata !1962, metadata !36}
!1968 = metadata !{i32 786478, metadata !1958, metadata !1959, metadata !"refcount_acquire", metadata !"refcount_acquire", metadata !"", i32 52, metadata !1969, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i32*)* @refcount_acquire, null, null, metadata !1289, i32 53} ; [ DW_TAG_subprogram ] [line 52] [local] [def] [scope 53] [refcount_acquire]
!1969 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1970, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1970 = metadata !{null, metadata !1962}
!1971 = metadata !{i32 786478, metadata !1964, metadata !1965, metadata !"atomic_add_barr_int", metadata !"atomic_add_barr_int", metadata !"", i32 282, metadata !1972, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i32*, i32)* @atomic_add_barr_int, null, null, metadata !1289, i32 282} ; [ DW_TAG_subprogram ] [line 282] [local] [def] [atomic_add_barr_int]
!1972 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1973, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1973 = metadata !{null, metadata !1962, metadata !36}
!1974 = metadata !{i32 786478, metadata !1958, metadata !1959, metadata !"refcount_init", metadata !"refcount_init", metadata !"", i32 45, metadata !1972, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i32*, i32)* @refcount_init, null, null, metadata !1289, i32 46} ; [ DW_TAG_subprogram ] [line 45] [local] [def] [scope 46] [refcount_init]
!1975 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"cr_seeothergids", metadata !"cr_seeothergids", metadata !"", i32 1376, metadata !1558, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.ucred*, %struct.ucred*)* @cr_seeothergids, null, null, metadata !1289, i32 1377} ; [ DW_TAG_subprogram ] [line 1376] [local] [def] [scope 1377] [cr_seeothergids]
!1976 = metadata !{i32 786478, metadata !1, metadata !1292, metadata !"cr_seeotheruids", metadata !"cr_seeotheruids", metadata !"", i32 1346, metadata !1558, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.ucred*, %struct.ucred*)* @cr_seeotheruids, null, null, metadata !1289, i32 1347} ; [ DW_TAG_subprogram ] [line 1346] [local] [def] [scope 1347] [cr_seeotheruids]
!1977 = metadata !{i32 786478, metadata !1978, metadata !1979, metadata !"__curthread", metadata !"__curthread", metadata !"", i32 232, metadata !1980, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, %struct.thread* ()* @__curthread, null, null, metadata !1289, i32 233} ; [ DW_TAG_subprogram ] [line 232] [local] [def] [scope 233] [__curthread]
!1978 = metadata !{metadata !"./machine/pcpu.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!1979 = metadata !{i32 786473, metadata !1978}    ; [ DW_TAG_file_type ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA/./machine/pcpu.h]
!1980 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1981, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1981 = metadata !{metadata !18}
!1982 = metadata !{metadata !1983, metadata !1987, metadata !1988, metadata !1989, metadata !1990, metadata !1991, metadata !1992, metadata !1993, metadata !2041, metadata !2051, metadata !2052, metadata !2053, metadata !2054, metadata !2055, metadata !2056, metadata !2057, metadata !2058, metadata !2059, metadata !2060, metadata !2071}
!1983 = metadata !{i32 786484, i32 0, null, metadata !"__set_sysinit_set_sym_M_CRED_init_sys_init", metadata !"__set_sysinit_set_sym_M_CRED_init_sys_init", metadata !"", metadata !1292, i32 89, metadata !1984, i32 1, i32 1, i8** @__set_sysinit_set_sym_M_CRED_init_sys_init, null} ; [ DW_TAG_variable ] [__set_sysinit_set_sym_M_CRED_init_sys_init] [line 89] [local] [def]
!1984 = metadata !{i32 786470, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !1985} ; [ DW_TAG_const_type ] [line 0, size 0, align 0, offset 0] [from ]
!1985 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1986} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!1986 = metadata !{i32 786470, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null} ; [ DW_TAG_const_type ] [line 0, size 0, align 0, offset 0] [from ]
!1987 = metadata !{i32 786484, i32 0, null, metadata !"__set_sysuninit_set_sym_M_CRED_uninit_sys_uninit", metadata !"__set_sysuninit_set_sym_M_CRED_uninit_sys_uninit", metadata !"", metadata !1292, i32 89, metadata !1984, i32 1, i32 1, i8** @__set_sysuninit_set_sym_M_CRED_uninit_sys_uninit, null} ; [ DW_TAG_variable ] [__set_sysuninit_set_sym_M_CRED_uninit_sys_uninit] [line 89] [local] [def]
!1988 = metadata !{i32 786484, i32 0, null, metadata !"__set_sysctl_set_sym_sysctl___security_bsd", metadata !"__set_sysctl_set_sym_sysctl___security_bsd", metadata !"", metadata !1292, i32 91, metadata !1984, i32 1, i32 1, i8** @__set_sysctl_set_sym_sysctl___security_bsd, null} ; [ DW_TAG_variable ] [__set_sysctl_set_sym_sysctl___security_bsd] [line 91] [local] [def]
!1989 = metadata !{i32 786484, i32 0, null, metadata !"__set_sysctl_set_sym_sysctl___security_bsd_see_other_uids", metadata !"__set_sysctl_set_sym_sysctl___security_bsd_see_other_uids", metadata !"", metadata !1292, i32 1333, metadata !1984, i32 1, i32 1, i8** @__set_sysctl_set_sym_sysctl___security_bsd_see_other_uids, null} ; [ DW_TAG_variable ] [__set_sysctl_set_sym_sysctl___security_bsd_see_other_uids] [line 1333] [local] [def]
!1990 = metadata !{i32 786484, i32 0, null, metadata !"__set_sysctl_set_sym_sysctl___security_bsd_see_other_gids", metadata !"__set_sysctl_set_sym_sysctl___security_bsd_see_other_gids", metadata !"", metadata !1292, i32 1363, metadata !1984, i32 1, i32 1, i8** @__set_sysctl_set_sym_sysctl___security_bsd_see_other_gids, null} ; [ DW_TAG_variable ] [__set_sysctl_set_sym_sysctl___security_bsd_see_other_gids] [line 1363] [local] [def]
!1991 = metadata !{i32 786484, i32 0, null, metadata !"__set_sysctl_set_sym_sysctl___security_bsd_conservative_signals", metadata !"__set_sysctl_set_sym_sysctl___security_bsd_conservative_signals", metadata !"", metadata !1292, i32 1449, metadata !1984, i32 1, i32 1, i8** @__set_sysctl_set_sym_sysctl___security_bsd_conservative_signals, null} ; [ DW_TAG_variable ] [__set_sysctl_set_sym_sysctl___security_bsd_conservative_signals] [line 1449] [local] [def]
!1992 = metadata !{i32 786484, i32 0, null, metadata !"__set_sysctl_set_sym_sysctl___security_bsd_unprivileged_proc_debug", metadata !"__set_sysctl_set_sym_sysctl___security_bsd_unprivileged_proc_debug", metadata !"", metadata !1292, i32 1617, metadata !1984, i32 1, i32 1, i8** @__set_sysctl_set_sym_sysctl___security_bsd_unprivileged_proc_debug, null} ; [ DW_TAG_variable ] [__set_sysctl_set_sym_sysctl___security_bsd_unprivileged_proc_debug] [line 1617] [local] [def]
!1993 = metadata !{i32 786484, i32 0, null, metadata !"sysctl__security_bsd_children", metadata !"sysctl__security_bsd_children", metadata !"", metadata !1292, i32 91, metadata !1994, i32 0, i32 1, %struct.sysctl_oid_list* @sysctl__security_bsd_children, null} ; [ DW_TAG_variable ] [sysctl__security_bsd_children] [line 91] [def]
!1994 = metadata !{i32 786451, metadata !1995, null, metadata !"sysctl_oid_list", i32 157, i64 64, i64 64, i32 0, i32 0, null, metadata !1996, i32 0, null, null} ; [ DW_TAG_structure_type ] [sysctl_oid_list] [line 157, size 64, align 64, offset 0] [from ]
!1995 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/sysctl.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!1996 = metadata !{metadata !1997}
!1997 = metadata !{i32 786445, metadata !1995, metadata !1994, metadata !"slh_first", i32 157, i64 64, i64 64, i64 0, i32 0, metadata !1998} ; [ DW_TAG_member ] [slh_first] [line 157, size 64, align 64, offset 0] [from ]
!1998 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1999} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from sysctl_oid]
!1999 = metadata !{i32 786451, metadata !1995, null, metadata !"sysctl_oid", i32 163, i64 640, i64 64, i32 0, i32 0, null, metadata !2000, i32 0, null, null} ; [ DW_TAG_structure_type ] [sysctl_oid] [line 163, size 640, align 64, offset 0] [from ]
!2000 = metadata !{metadata !2001, metadata !2003, metadata !2007, metadata !2008, metadata !2009, metadata !2010, metadata !2011, metadata !2012, metadata !2037, metadata !2038, metadata !2039, metadata !2040}
!2001 = metadata !{i32 786445, metadata !1995, metadata !1999, metadata !"oid_parent", i32 164, i64 64, i64 64, i64 0, i32 0, metadata !2002} ; [ DW_TAG_member ] [oid_parent] [line 164, size 64, align 64, offset 0] [from ]
!2002 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1994} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from sysctl_oid_list]
!2003 = metadata !{i32 786445, metadata !1995, metadata !1999, metadata !"oid_link", i32 165, i64 64, i64 64, i64 64, i32 0, metadata !2004} ; [ DW_TAG_member ] [oid_link] [line 165, size 64, align 64, offset 64] [from ]
!2004 = metadata !{i32 786451, metadata !1995, metadata !1999, metadata !"", i32 165, i64 64, i64 64, i32 0, i32 0, null, metadata !2005, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 165, size 64, align 64, offset 0] [from ]
!2005 = metadata !{metadata !2006}
!2006 = metadata !{i32 786445, metadata !1995, metadata !2004, metadata !"sle_next", i32 165, i64 64, i64 64, i64 0, i32 0, metadata !1998} ; [ DW_TAG_member ] [sle_next] [line 165, size 64, align 64, offset 0] [from ]
!2007 = metadata !{i32 786445, metadata !1995, metadata !1999, metadata !"oid_number", i32 166, i64 32, i64 32, i64 128, i32 0, metadata !93} ; [ DW_TAG_member ] [oid_number] [line 166, size 32, align 32, offset 128] [from int]
!2008 = metadata !{i32 786445, metadata !1995, metadata !1999, metadata !"oid_kind", i32 167, i64 32, i64 32, i64 160, i32 0, metadata !36} ; [ DW_TAG_member ] [oid_kind] [line 167, size 32, align 32, offset 160] [from u_int]
!2009 = metadata !{i32 786445, metadata !1995, metadata !1999, metadata !"oid_arg1", i32 168, i64 64, i64 64, i64 192, i32 0, metadata !178} ; [ DW_TAG_member ] [oid_arg1] [line 168, size 64, align 64, offset 192] [from ]
!2010 = metadata !{i32 786445, metadata !1995, metadata !1999, metadata !"oid_arg2", i32 169, i64 64, i64 64, i64 256, i32 0, metadata !694} ; [ DW_TAG_member ] [oid_arg2] [line 169, size 64, align 64, offset 256] [from intptr_t]
!2011 = metadata !{i32 786445, metadata !1995, metadata !1999, metadata !"oid_name", i32 170, i64 64, i64 64, i64 320, i32 0, metadata !32} ; [ DW_TAG_member ] [oid_name] [line 170, size 64, align 64, offset 320] [from ]
!2012 = metadata !{i32 786445, metadata !1995, metadata !1999, metadata !"oid_handler", i32 171, i64 64, i64 64, i64 384, i32 0, metadata !2013} ; [ DW_TAG_member ] [oid_handler] [line 171, size 64, align 64, offset 384] [from ]
!2013 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !2014} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!2014 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !2015, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!2015 = metadata !{metadata !93, metadata !1998, metadata !178, metadata !694, metadata !2016}
!2016 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !2017} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from sysctl_req]
!2017 = metadata !{i32 786451, metadata !1995, null, metadata !"sysctl_req", i32 142, i64 768, i64 64, i32 0, i32 0, null, metadata !2018, i32 0, null, null} ; [ DW_TAG_structure_type ] [sysctl_req] [line 142, size 768, align 64, offset 0] [from ]
!2018 = metadata !{metadata !2019, metadata !2020, metadata !2021, metadata !2022, metadata !2023, metadata !2024, metadata !2028, metadata !2029, metadata !2030, metadata !2031, metadata !2035, metadata !2036}
!2019 = metadata !{i32 786445, metadata !1995, metadata !2017, metadata !"td", i32 143, i64 64, i64 64, i64 0, i32 0, metadata !18} ; [ DW_TAG_member ] [td] [line 143, size 64, align 64, offset 0] [from ]
!2020 = metadata !{i32 786445, metadata !1995, metadata !2017, metadata !"lock", i32 144, i64 32, i64 32, i64 64, i32 0, metadata !93} ; [ DW_TAG_member ] [lock] [line 144, size 32, align 32, offset 64] [from int]
!2021 = metadata !{i32 786445, metadata !1995, metadata !2017, metadata !"oldptr", i32 145, i64 64, i64 64, i64 128, i32 0, metadata !178} ; [ DW_TAG_member ] [oldptr] [line 145, size 64, align 64, offset 128] [from ]
!2022 = metadata !{i32 786445, metadata !1995, metadata !2017, metadata !"oldlen", i32 146, i64 64, i64 64, i64 192, i32 0, metadata !608} ; [ DW_TAG_member ] [oldlen] [line 146, size 64, align 64, offset 192] [from size_t]
!2023 = metadata !{i32 786445, metadata !1995, metadata !2017, metadata !"oldidx", i32 147, i64 64, i64 64, i64 256, i32 0, metadata !608} ; [ DW_TAG_member ] [oldidx] [line 147, size 64, align 64, offset 256] [from size_t]
!2024 = metadata !{i32 786445, metadata !1995, metadata !2017, metadata !"oldfunc", i32 148, i64 64, i64 64, i64 320, i32 0, metadata !2025} ; [ DW_TAG_member ] [oldfunc] [line 148, size 64, align 64, offset 320] [from ]
!2025 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !2026} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!2026 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !2027, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!2027 = metadata !{metadata !93, metadata !2016, metadata !1985, metadata !608}
!2028 = metadata !{i32 786445, metadata !1995, metadata !2017, metadata !"newptr", i32 149, i64 64, i64 64, i64 384, i32 0, metadata !178} ; [ DW_TAG_member ] [newptr] [line 149, size 64, align 64, offset 384] [from ]
!2029 = metadata !{i32 786445, metadata !1995, metadata !2017, metadata !"newlen", i32 150, i64 64, i64 64, i64 448, i32 0, metadata !608} ; [ DW_TAG_member ] [newlen] [line 150, size 64, align 64, offset 448] [from size_t]
!2030 = metadata !{i32 786445, metadata !1995, metadata !2017, metadata !"newidx", i32 151, i64 64, i64 64, i64 512, i32 0, metadata !608} ; [ DW_TAG_member ] [newidx] [line 151, size 64, align 64, offset 512] [from size_t]
!2031 = metadata !{i32 786445, metadata !1995, metadata !2017, metadata !"newfunc", i32 152, i64 64, i64 64, i64 576, i32 0, metadata !2032} ; [ DW_TAG_member ] [newfunc] [line 152, size 64, align 64, offset 576] [from ]
!2032 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !2033} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!2033 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !2034, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!2034 = metadata !{metadata !93, metadata !2016, metadata !178, metadata !608}
!2035 = metadata !{i32 786445, metadata !1995, metadata !2017, metadata !"validlen", i32 153, i64 64, i64 64, i64 640, i32 0, metadata !608} ; [ DW_TAG_member ] [validlen] [line 153, size 64, align 64, offset 640] [from size_t]
!2036 = metadata !{i32 786445, metadata !1995, metadata !2017, metadata !"flags", i32 154, i64 32, i64 32, i64 704, i32 0, metadata !93} ; [ DW_TAG_member ] [flags] [line 154, size 32, align 32, offset 704] [from int]
!2037 = metadata !{i32 786445, metadata !1995, metadata !1999, metadata !"oid_fmt", i32 172, i64 64, i64 64, i64 448, i32 0, metadata !32} ; [ DW_TAG_member ] [oid_fmt] [line 172, size 64, align 64, offset 448] [from ]
!2038 = metadata !{i32 786445, metadata !1995, metadata !1999, metadata !"oid_refcnt", i32 173, i64 32, i64 32, i64 512, i32 0, metadata !93} ; [ DW_TAG_member ] [oid_refcnt] [line 173, size 32, align 32, offset 512] [from int]
!2039 = metadata !{i32 786445, metadata !1995, metadata !1999, metadata !"oid_running", i32 174, i64 32, i64 32, i64 544, i32 0, metadata !36} ; [ DW_TAG_member ] [oid_running] [line 174, size 32, align 32, offset 544] [from u_int]
!2040 = metadata !{i32 786445, metadata !1995, metadata !1999, metadata !"oid_descr", i32 175, i64 64, i64 64, i64 576, i32 0, metadata !32} ; [ DW_TAG_member ] [oid_descr] [line 175, size 64, align 64, offset 576] [from ]
!2041 = metadata !{i32 786484, i32 0, null, metadata !"M_CRED", metadata !"M_CRED", metadata !"", metadata !1292, i32 89, metadata !2042, i32 1, i32 1, [1 x %struct.malloc_type]* @M_CRED, null} ; [ DW_TAG_variable ] [M_CRED] [line 89] [local] [def]
!2042 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 256, i64 64, i32 0, i32 0, metadata !2043, metadata !88, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 256, align 64, offset 0] [from malloc_type]
!2043 = metadata !{i32 786451, metadata !2044, null, metadata !"malloc_type", i32 103, i64 256, i64 64, i32 0, i32 0, null, metadata !2045, i32 0, null, null} ; [ DW_TAG_structure_type ] [malloc_type] [line 103, size 256, align 64, offset 0] [from ]
!2044 = metadata !{metadata !"/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/malloc.h", metadata !"/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA"}
!2045 = metadata !{metadata !2046, metadata !2048, metadata !2049, metadata !2050}
!2046 = metadata !{i32 786445, metadata !2044, metadata !2043, metadata !"ks_next", i32 104, i64 64, i64 64, i64 0, i32 0, metadata !2047} ; [ DW_TAG_member ] [ks_next] [line 104, size 64, align 64, offset 0] [from ]
!2047 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !2043} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from malloc_type]
!2048 = metadata !{i32 786445, metadata !2044, metadata !2043, metadata !"ks_magic", i32 105, i64 64, i64 64, i64 64, i32 0, metadata !577} ; [ DW_TAG_member ] [ks_magic] [line 105, size 64, align 64, offset 64] [from u_long]
!2049 = metadata !{i32 786445, metadata !2044, metadata !2043, metadata !"ks_shortdesc", i32 106, i64 64, i64 64, i64 128, i32 0, metadata !32} ; [ DW_TAG_member ] [ks_shortdesc] [line 106, size 64, align 64, offset 128] [from ]
!2050 = metadata !{i32 786445, metadata !2044, metadata !2043, metadata !"ks_handle", i32 107, i64 64, i64 64, i64 192, i32 0, metadata !178} ; [ DW_TAG_member ] [ks_handle] [line 107, size 64, align 64, offset 192] [from ]
!2051 = metadata !{i32 786484, i32 0, null, metadata !"unprivileged_proc_debug", metadata !"unprivileged_proc_debug", metadata !"", metadata !1292, i32 1616, metadata !93, i32 1, i32 1, i32* @unprivileged_proc_debug, null} ; [ DW_TAG_variable ] [unprivileged_proc_debug] [line 1616] [local] [def]
!2052 = metadata !{i32 786484, i32 0, null, metadata !"sysctl___security_bsd_unprivileged_proc_debug", metadata !"sysctl___security_bsd_unprivileged_proc_debug", metadata !"", metadata !1292, i32 1617, metadata !1999, i32 1, i32 1, %struct.sysctl_oid* @sysctl___security_bsd_unprivileged_proc_debug, null} ; [ DW_TAG_variable ] [sysctl___security_bsd_unprivileged_proc_debug] [line 1617] [local] [def]
!2053 = metadata !{i32 786484, i32 0, null, metadata !"conservative_signals", metadata !"conservative_signals", metadata !"", metadata !1292, i32 1448, metadata !93, i32 1, i32 1, i32* @conservative_signals, null} ; [ DW_TAG_variable ] [conservative_signals] [line 1448] [local] [def]
!2054 = metadata !{i32 786484, i32 0, null, metadata !"sysctl___security_bsd_conservative_signals", metadata !"sysctl___security_bsd_conservative_signals", metadata !"", metadata !1292, i32 1449, metadata !1999, i32 1, i32 1, %struct.sysctl_oid* @sysctl___security_bsd_conservative_signals, null} ; [ DW_TAG_variable ] [sysctl___security_bsd_conservative_signals] [line 1449] [local] [def]
!2055 = metadata !{i32 786484, i32 0, null, metadata !"see_other_gids", metadata !"see_other_gids", metadata !"", metadata !1292, i32 1362, metadata !93, i32 1, i32 1, i32* @see_other_gids, null} ; [ DW_TAG_variable ] [see_other_gids] [line 1362] [local] [def]
!2056 = metadata !{i32 786484, i32 0, null, metadata !"see_other_uids", metadata !"see_other_uids", metadata !"", metadata !1292, i32 1332, metadata !93, i32 1, i32 1, i32* @see_other_uids, null} ; [ DW_TAG_variable ] [see_other_uids] [line 1332] [local] [def]
!2057 = metadata !{i32 786484, i32 0, null, metadata !"sysctl___security_bsd_see_other_gids", metadata !"sysctl___security_bsd_see_other_gids", metadata !"", metadata !1292, i32 1363, metadata !1999, i32 1, i32 1, %struct.sysctl_oid* @sysctl___security_bsd_see_other_gids, null} ; [ DW_TAG_variable ] [sysctl___security_bsd_see_other_gids] [line 1363] [local] [def]
!2058 = metadata !{i32 786484, i32 0, null, metadata !"sysctl___security_bsd_see_other_uids", metadata !"sysctl___security_bsd_see_other_uids", metadata !"", metadata !1292, i32 1333, metadata !1999, i32 1, i32 1, %struct.sysctl_oid* @sysctl___security_bsd_see_other_uids, null} ; [ DW_TAG_variable ] [sysctl___security_bsd_see_other_uids] [line 1333] [local] [def]
!2059 = metadata !{i32 786484, i32 0, null, metadata !"sysctl___security_bsd", metadata !"sysctl___security_bsd", metadata !"", metadata !1292, i32 91, metadata !1999, i32 1, i32 1, %struct.sysctl_oid* @sysctl___security_bsd, null} ; [ DW_TAG_variable ] [sysctl___security_bsd] [line 91] [local] [def]
!2060 = metadata !{i32 786484, i32 0, null, metadata !"M_CRED_uninit_sys_uninit", metadata !"M_CRED_uninit_sys_uninit", metadata !"", metadata !1292, i32 89, metadata !2061, i32 1, i32 1, %struct.sysinit* @M_CRED_uninit_sys_uninit, null} ; [ DW_TAG_variable ] [M_CRED_uninit_sys_uninit] [line 89] [local] [def]
!2061 = metadata !{i32 786451, metadata !1198, null, metadata !"sysinit", i32 212, i64 192, i64 64, i32 0, i32 0, null, metadata !2062, i32 0, null, null} ; [ DW_TAG_structure_type ] [sysinit] [line 212, size 192, align 64, offset 0] [from ]
!2062 = metadata !{metadata !2063, metadata !2064, metadata !2065, metadata !2070}
!2063 = metadata !{i32 786445, metadata !1198, metadata !2061, metadata !"subsystem", i32 213, i64 32, i64 32, i64 0, i32 0, metadata !1197} ; [ DW_TAG_member ] [subsystem] [line 213, size 32, align 32, offset 0] [from sysinit_sub_id]
!2064 = metadata !{i32 786445, metadata !1198, metadata !2061, metadata !"order", i32 214, i64 32, i64 32, i64 32, i32 0, metadata !1281} ; [ DW_TAG_member ] [order] [line 214, size 32, align 32, offset 32] [from sysinit_elem_order]
!2065 = metadata !{i32 786445, metadata !1198, metadata !2061, metadata !"func", i32 215, i64 64, i64 64, i64 64, i32 0, metadata !2066} ; [ DW_TAG_member ] [func] [line 215, size 64, align 64, offset 64] [from sysinit_cfunc_t]
!2066 = metadata !{i32 786454, metadata !1198, null, metadata !"sysinit_cfunc_t", i32 210, i64 0, i64 0, i64 0, i32 0, metadata !2067} ; [ DW_TAG_typedef ] [sysinit_cfunc_t] [line 210, size 0, align 0, offset 0] [from ]
!2067 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !2068} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!2068 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !2069, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!2069 = metadata !{null, metadata !1985}
!2070 = metadata !{i32 786445, metadata !1198, metadata !2061, metadata !"udata", i32 216, i64 64, i64 64, i64 128, i32 0, metadata !1985} ; [ DW_TAG_member ] [udata] [line 216, size 64, align 64, offset 128] [from ]
!2071 = metadata !{i32 786484, i32 0, null, metadata !"M_CRED_init_sys_init", metadata !"M_CRED_init_sys_init", metadata !"", metadata !1292, i32 89, metadata !2061, i32 1, i32 1, %struct.sysinit* @M_CRED_init_sys_init, null} ; [ DW_TAG_variable ] [M_CRED_init_sys_init] [line 89] [local] [def]
!2072 = metadata !{i32 786689, metadata !1291, metadata !"td", metadata !1292, i32 16777320, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 104]
!2073 = metadata !{i32 104, i32 0, metadata !1291, null}
!2074 = metadata !{i32 786689, metadata !1291, metadata !"uap", metadata !1292, i32 33554536, metadata !1295, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 104]
!2075 = metadata !{i32 786688, metadata !1291, metadata !"p", metadata !1292, i32 106, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 106]
!2076 = metadata !{i32 106, i32 0, metadata !1291, null}
!2077 = metadata !{i32 108, i32 0, metadata !1291, null}
!2078 = metadata !{i32 114, i32 0, metadata !1291, null}
!2079 = metadata !{i32 786689, metadata !1299, metadata !"td", metadata !1292, i32 16777340, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 124]
!2080 = metadata !{i32 124, i32 0, metadata !1299, null}
!2081 = metadata !{i32 786689, metadata !1299, metadata !"uap", metadata !1292, i32 33554556, metadata !1302, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 124]
!2082 = metadata !{i32 786688, metadata !1299, metadata !"p", metadata !1292, i32 126, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 126]
!2083 = metadata !{i32 126, i32 0, metadata !1299, null}
!2084 = metadata !{i32 128, i32 0, metadata !1299, null}
!2085 = metadata !{i32 129, i32 0, metadata !1299, null}
!2086 = metadata !{i32 130, i32 0, metadata !1299, null}
!2087 = metadata !{i32 131, i32 0, metadata !1299, null}
!2088 = metadata !{i32 786689, metadata !1306, metadata !"td", metadata !1292, i32 16777359, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 143]
!2089 = metadata !{i32 143, i32 0, metadata !1306, null}
!2090 = metadata !{i32 786689, metadata !1306, metadata !"uap", metadata !1292, i32 33554575, metadata !1309, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 143]
!2091 = metadata !{i32 786688, metadata !1306, metadata !"p", metadata !1292, i32 145, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 145]
!2092 = metadata !{i32 145, i32 0, metadata !1306, null}
!2093 = metadata !{i32 147, i32 0, metadata !1306, null}
!2094 = metadata !{i32 148, i32 0, metadata !1306, null}
!2095 = metadata !{i32 149, i32 0, metadata !1306, null}
!2096 = metadata !{i32 150, i32 0, metadata !1306, null}
!2097 = metadata !{i32 786689, metadata !1313, metadata !"td", metadata !1292, i32 16777376, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 160]
!2098 = metadata !{i32 160, i32 0, metadata !1313, null}
!2099 = metadata !{i32 786689, metadata !1313, metadata !"uap", metadata !1292, i32 33554592, metadata !1316, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 160]
!2100 = metadata !{i32 786688, metadata !1313, metadata !"p", metadata !1292, i32 162, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 162]
!2101 = metadata !{i32 162, i32 0, metadata !1313, null}
!2102 = metadata !{i32 786688, metadata !1313, metadata !"error", metadata !1292, i32 163, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 163]
!2103 = metadata !{i32 163, i32 0, metadata !1313, null}
!2104 = metadata !{i32 165, i32 0, metadata !1313, null}
!2105 = metadata !{i32 166, i32 0, metadata !2106, null}
!2106 = metadata !{i32 786443, metadata !1, metadata !1313, i32 165, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2107 = metadata !{i32 167, i32 0, metadata !2106, null}
!2108 = metadata !{i32 168, i32 0, metadata !2106, null}
!2109 = metadata !{i32 169, i32 0, metadata !2110, null}
!2110 = metadata !{i32 786443, metadata !1, metadata !1313, i32 168, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2111 = metadata !{i32 170, i32 0, metadata !2110, null}
!2112 = metadata !{i32 171, i32 0, metadata !2110, null}
!2113 = metadata !{i32 172, i32 0, metadata !2110, null}
!2114 = metadata !{i32 173, i32 0, metadata !2110, null}
!2115 = metadata !{i32 174, i32 0, metadata !2116, null}
!2116 = metadata !{i32 786443, metadata !1, metadata !2110, i32 173, i32 0, i32 2} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2117 = metadata !{i32 175, i32 0, metadata !2116, null}
!2118 = metadata !{i32 178, i32 0, metadata !1313, null}
!2119 = metadata !{i32 179, i32 0, metadata !1313, null}
!2120 = metadata !{i32 180, i32 0, metadata !1313, null}
!2121 = metadata !{i32 181, i32 0, metadata !1313, null}
!2122 = metadata !{i32 786689, metadata !1560, metadata !"td", metadata !1292, i32 16778645, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 1429]
!2123 = metadata !{i32 1429, i32 0, metadata !1560, null}
!2124 = metadata !{i32 786689, metadata !1560, metadata !"p", metadata !1292, i32 33555861, metadata !11, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [p] [line 1429]
!2125 = metadata !{i32 1433, i32 0, metadata !1560, null}
!2126 = metadata !{i32 1433, i32 0, metadata !2127, null}
!2127 = metadata !{i32 786443, metadata !1, metadata !1560, i32 1433, i32 0, i32 63} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2128 = metadata !{i32 1434, i32 0, metadata !1560, null}
!2129 = metadata !{i32 1435, i32 0, metadata !1560, null}
!2130 = metadata !{i32 786689, metadata !1326, metadata !"td", metadata !1292, i32 16777408, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 192]
!2131 = metadata !{i32 192, i32 0, metadata !1326, null}
!2132 = metadata !{i32 786689, metadata !1326, metadata !"uap", metadata !1292, i32 33554624, metadata !1329, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 192]
!2133 = metadata !{i32 786688, metadata !1326, metadata !"p", metadata !1292, i32 194, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 194]
!2134 = metadata !{i32 194, i32 0, metadata !1326, null}
!2135 = metadata !{i32 786688, metadata !1326, metadata !"error", metadata !1292, i32 195, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 195]
!2136 = metadata !{i32 195, i32 0, metadata !1326, null}
!2137 = metadata !{i32 197, i32 0, metadata !1326, null}
!2138 = metadata !{i32 198, i32 0, metadata !2139, null}
!2139 = metadata !{i32 786443, metadata !1, metadata !1326, i32 197, i32 0, i32 3} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2140 = metadata !{i32 199, i32 0, metadata !2139, null}
!2141 = metadata !{i32 200, i32 0, metadata !2139, null}
!2142 = metadata !{i32 201, i32 0, metadata !2143, null}
!2143 = metadata !{i32 786443, metadata !1, metadata !1326, i32 200, i32 0, i32 4} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2144 = metadata !{i32 202, i32 0, metadata !2143, null}
!2145 = metadata !{i32 203, i32 0, metadata !2143, null}
!2146 = metadata !{i32 204, i32 0, metadata !2143, null}
!2147 = metadata !{i32 205, i32 0, metadata !2143, null}
!2148 = metadata !{i32 206, i32 0, metadata !2149, null}
!2149 = metadata !{i32 786443, metadata !1, metadata !2143, i32 205, i32 0, i32 5} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2150 = metadata !{i32 207, i32 0, metadata !2149, null}
!2151 = metadata !{i32 210, i32 0, metadata !1326, null}
!2152 = metadata !{i32 211, i32 0, metadata !1326, null}
!2153 = metadata !{i32 212, i32 0, metadata !1326, null}
!2154 = metadata !{i32 213, i32 0, metadata !1326, null}
!2155 = metadata !{i32 786689, metadata !1335, metadata !"td", metadata !1292, i32 16777438, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 222]
!2156 = metadata !{i32 222, i32 0, metadata !1335, null}
!2157 = metadata !{i32 786689, metadata !1335, metadata !"uap", metadata !1292, i32 33554654, metadata !1338, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 222]
!2158 = metadata !{i32 225, i32 0, metadata !1335, null}
!2159 = metadata !{i32 229, i32 0, metadata !1335, null}
!2160 = metadata !{i32 786689, metadata !1342, metadata !"td", metadata !1292, i32 16777455, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 239]
!2161 = metadata !{i32 239, i32 0, metadata !1342, null}
!2162 = metadata !{i32 786689, metadata !1342, metadata !"uap", metadata !1292, i32 33554671, metadata !1345, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 239]
!2163 = metadata !{i32 242, i32 0, metadata !1342, null}
!2164 = metadata !{i32 243, i32 0, metadata !1342, null}
!2165 = metadata !{i32 786689, metadata !1349, metadata !"td", metadata !1292, i32 16777469, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 253]
!2166 = metadata !{i32 253, i32 0, metadata !1349, null}
!2167 = metadata !{i32 786689, metadata !1349, metadata !"uap", metadata !1292, i32 33554685, metadata !1352, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 253]
!2168 = metadata !{i32 256, i32 0, metadata !1349, null}
!2169 = metadata !{i32 260, i32 0, metadata !1349, null}
!2170 = metadata !{i32 786689, metadata !1356, metadata !"td", metadata !1292, i32 16777491, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 275]
!2171 = metadata !{i32 275, i32 0, metadata !1356, null}
!2172 = metadata !{i32 786689, metadata !1356, metadata !"uap", metadata !1292, i32 33554707, metadata !1359, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 275]
!2173 = metadata !{i32 278, i32 0, metadata !1356, null}
!2174 = metadata !{i32 279, i32 0, metadata !1356, null}
!2175 = metadata !{i32 786689, metadata !1363, metadata !"td", metadata !1292, i32 16777505, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 289]
!2176 = metadata !{i32 289, i32 0, metadata !1363, null}
!2177 = metadata !{i32 786689, metadata !1363, metadata !"uap", metadata !1292, i32 33554721, metadata !1366, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 289]
!2178 = metadata !{i32 786688, metadata !1363, metadata !"groups", metadata !1292, i32 291, metadata !509, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [groups] [line 291]
!2179 = metadata !{i32 291, i32 0, metadata !1363, null}
!2180 = metadata !{i32 786688, metadata !1363, metadata !"ngrp", metadata !1292, i32 292, metadata !36, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [ngrp] [line 292]
!2181 = metadata !{i32 292, i32 0, metadata !1363, null}
!2182 = metadata !{i32 786688, metadata !1363, metadata !"error", metadata !1292, i32 293, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 293]
!2183 = metadata !{i32 293, i32 0, metadata !1363, null}
!2184 = metadata !{i32 295, i32 0, metadata !1363, null}
!2185 = metadata !{i32 296, i32 0, metadata !2186, null}
!2186 = metadata !{i32 786443, metadata !1, metadata !1363, i32 295, i32 0, i32 6} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2187 = metadata !{i32 297, i32 0, metadata !2186, null}
!2188 = metadata !{i32 299, i32 0, metadata !2186, null}
!2189 = metadata !{i32 300, i32 0, metadata !2186, null}
!2190 = metadata !{i32 301, i32 0, metadata !1363, null}
!2191 = metadata !{i32 302, i32 0, metadata !1363, null}
!2192 = metadata !{i32 303, i32 0, metadata !1363, null}
!2193 = metadata !{i32 304, i32 0, metadata !1363, null}
!2194 = metadata !{i32 305, i32 0, metadata !1363, null}
!2195 = metadata !{i32 306, i32 0, metadata !1363, null}
!2196 = metadata !{i32 307, i32 0, metadata !1363, null}
!2197 = metadata !{i32 308, i32 0, metadata !1363, null}
!2198 = metadata !{i32 309, i32 0, metadata !1363, null}
!2199 = metadata !{i32 311, i32 0, metadata !1363, null}
!2200 = metadata !{i32 312, i32 0, metadata !1363, null}
!2201 = metadata !{i32 313, i32 0, metadata !1363, null}
!2202 = metadata !{i32 786689, metadata !1375, metadata !"td", metadata !1292, i32 16777532, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 316]
!2203 = metadata !{i32 316, i32 0, metadata !1375, null}
!2204 = metadata !{i32 786689, metadata !1375, metadata !"ngrp", metadata !1292, i32 33554748, metadata !1378, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [ngrp] [line 316]
!2205 = metadata !{i32 786689, metadata !1375, metadata !"groups", metadata !1292, i32 50331964, metadata !509, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [groups] [line 316]
!2206 = metadata !{i32 786688, metadata !1375, metadata !"cred", metadata !1292, i32 318, metadata !253, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [cred] [line 318]
!2207 = metadata !{i32 318, i32 0, metadata !1375, null}
!2208 = metadata !{i32 320, i32 0, metadata !1375, null}
!2209 = metadata !{i32 321, i32 0, metadata !1375, null}
!2210 = metadata !{i32 322, i32 0, metadata !2211, null}
!2211 = metadata !{i32 786443, metadata !1, metadata !1375, i32 321, i32 0, i32 7} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2212 = metadata !{i32 323, i32 0, metadata !2211, null}
!2213 = metadata !{i32 325, i32 0, metadata !1375, null}
!2214 = metadata !{i32 326, i32 0, metadata !1375, null}
!2215 = metadata !{i32 327, i32 0, metadata !1375, null}
!2216 = metadata !{i32 328, i32 0, metadata !1375, null}
!2217 = metadata !{i32 329, i32 0, metadata !1375, null}
!2218 = metadata !{i32 786689, metadata !1379, metadata !"td", metadata !1292, i32 16777555, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 339]
!2219 = metadata !{i32 339, i32 0, metadata !1379, null}
!2220 = metadata !{i32 786689, metadata !1379, metadata !"uap", metadata !1292, i32 33554771, metadata !1382, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 339]
!2221 = metadata !{i32 786688, metadata !1379, metadata !"pgrp", metadata !1292, i32 341, metadata !1033, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [pgrp] [line 341]
!2222 = metadata !{i32 341, i32 0, metadata !1379, null}
!2223 = metadata !{i32 786688, metadata !1379, metadata !"error", metadata !1292, i32 342, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 342]
!2224 = metadata !{i32 342, i32 0, metadata !1379, null}
!2225 = metadata !{i32 786688, metadata !1379, metadata !"p", metadata !1292, i32 343, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 343]
!2226 = metadata !{i32 343, i32 0, metadata !1379, null}
!2227 = metadata !{i32 786688, metadata !1379, metadata !"newpgrp", metadata !1292, i32 344, metadata !1033, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [newpgrp] [line 344]
!2228 = metadata !{i32 344, i32 0, metadata !1379, null}
!2229 = metadata !{i32 786688, metadata !1379, metadata !"newsess", metadata !1292, i32 345, metadata !1047, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [newsess] [line 345]
!2230 = metadata !{i32 345, i32 0, metadata !1379, null}
!2231 = metadata !{i32 347, i32 0, metadata !1379, null}
!2232 = metadata !{i32 348, i32 0, metadata !1379, null}
!2233 = metadata !{i32 350, i32 0, metadata !1379, null}
!2234 = metadata !{i32 351, i32 0, metadata !1379, null}
!2235 = metadata !{i32 353, i32 0, metadata !1379, null}
!2236 = metadata !{i32 355, i32 0, metadata !1379, null}
!2237 = metadata !{i32 356, i32 0, metadata !2238, null}
!2238 = metadata !{i32 786443, metadata !1, metadata !1379, i32 355, i32 0, i32 8} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2239 = metadata !{i32 357, i32 0, metadata !2238, null}
!2240 = metadata !{i32 358, i32 0, metadata !2238, null}
!2241 = metadata !{i32 359, i32 0, metadata !2238, null}
!2242 = metadata !{i32 360, i32 0, metadata !2243, null}
!2243 = metadata !{i32 786443, metadata !1, metadata !1379, i32 359, i32 0, i32 9} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2244 = metadata !{i32 361, i32 0, metadata !2243, null}
!2245 = metadata !{i32 362, i32 0, metadata !2243, null}
!2246 = metadata !{i32 363, i32 0, metadata !2243, null}
!2247 = metadata !{i32 366, i32 0, metadata !1379, null}
!2248 = metadata !{i32 368, i32 0, metadata !1379, null}
!2249 = metadata !{i32 369, i32 0, metadata !1379, null}
!2250 = metadata !{i32 370, i32 0, metadata !1379, null}
!2251 = metadata !{i32 371, i32 0, metadata !1379, null}
!2252 = metadata !{i32 373, i32 0, metadata !1379, null}
!2253 = metadata !{i32 786689, metadata !1386, metadata !"td", metadata !1292, i32 16777613, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 397]
!2254 = metadata !{i32 397, i32 0, metadata !1386, null}
!2255 = metadata !{i32 786689, metadata !1386, metadata !"uap", metadata !1292, i32 33554829, metadata !1389, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 397]
!2256 = metadata !{i32 786688, metadata !1386, metadata !"curp", metadata !1292, i32 399, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [curp] [line 399]
!2257 = metadata !{i32 399, i32 0, metadata !1386, null}
!2258 = metadata !{i32 786688, metadata !1386, metadata !"targp", metadata !1292, i32 400, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [targp] [line 400]
!2259 = metadata !{i32 400, i32 0, metadata !1386, null}
!2260 = metadata !{i32 786688, metadata !1386, metadata !"pgrp", metadata !1292, i32 401, metadata !1033, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [pgrp] [line 401]
!2261 = metadata !{i32 401, i32 0, metadata !1386, null}
!2262 = metadata !{i32 786688, metadata !1386, metadata !"error", metadata !1292, i32 402, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 402]
!2263 = metadata !{i32 402, i32 0, metadata !1386, null}
!2264 = metadata !{i32 786688, metadata !1386, metadata !"newpgrp", metadata !1292, i32 403, metadata !1033, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [newpgrp] [line 403]
!2265 = metadata !{i32 403, i32 0, metadata !1386, null}
!2266 = metadata !{i32 405, i32 0, metadata !1386, null}
!2267 = metadata !{i32 406, i32 0, metadata !1386, null}
!2268 = metadata !{i32 408, i32 0, metadata !1386, null}
!2269 = metadata !{i32 410, i32 0, metadata !1386, null}
!2270 = metadata !{i32 412, i32 0, metadata !1386, null}
!2271 = metadata !{i32 413, i32 0, metadata !1386, null}
!2272 = metadata !{i32 414, i32 0, metadata !2273, null}
!2273 = metadata !{i32 786443, metadata !1, metadata !1386, i32 413, i32 0, i32 10} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2274 = metadata !{i32 415, i32 0, metadata !2275, null}
!2275 = metadata !{i32 786443, metadata !1, metadata !2273, i32 414, i32 0, i32 11} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2276 = metadata !{i32 416, i32 0, metadata !2275, null}
!2277 = metadata !{i32 418, i32 0, metadata !2273, null}
!2278 = metadata !{i32 419, i32 0, metadata !2279, null}
!2279 = metadata !{i32 786443, metadata !1, metadata !2273, i32 418, i32 0, i32 12} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2280 = metadata !{i32 420, i32 0, metadata !2279, null}
!2281 = metadata !{i32 421, i32 0, metadata !2279, null}
!2282 = metadata !{i32 423, i32 0, metadata !2273, null}
!2283 = metadata !{i32 424, i32 0, metadata !2284, null}
!2284 = metadata !{i32 786443, metadata !1, metadata !2273, i32 423, i32 0, i32 13} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2285 = metadata !{i32 425, i32 0, metadata !2284, null}
!2286 = metadata !{i32 427, i32 0, metadata !2273, null}
!2287 = metadata !{i32 429, i32 0, metadata !2288, null}
!2288 = metadata !{i32 786443, metadata !1, metadata !2273, i32 428, i32 0, i32 14} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2289 = metadata !{i32 430, i32 0, metadata !2288, null}
!2290 = metadata !{i32 431, i32 0, metadata !2288, null}
!2291 = metadata !{i32 433, i32 0, metadata !2273, null}
!2292 = metadata !{i32 434, i32 0, metadata !2293, null}
!2293 = metadata !{i32 786443, metadata !1, metadata !2273, i32 433, i32 0, i32 15} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2294 = metadata !{i32 435, i32 0, metadata !2293, null}
!2295 = metadata !{i32 436, i32 0, metadata !2293, null}
!2296 = metadata !{i32 438, i32 0, metadata !2273, null}
!2297 = metadata !{i32 439, i32 0, metadata !2273, null}
!2298 = metadata !{i32 440, i32 0, metadata !1386, null}
!2299 = metadata !{i32 441, i32 0, metadata !1386, null}
!2300 = metadata !{i32 442, i32 0, metadata !2301, null}
!2301 = metadata !{i32 786443, metadata !1, metadata !1386, i32 441, i32 0, i32 16} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2302 = metadata !{i32 443, i32 0, metadata !2301, null}
!2303 = metadata !{i32 445, i32 0, metadata !1386, null}
!2304 = metadata !{i32 446, i32 0, metadata !1386, null}
!2305 = metadata !{i32 447, i32 0, metadata !1386, null}
!2306 = metadata !{i32 448, i32 0, metadata !2307, null}
!2307 = metadata !{i32 786443, metadata !1, metadata !1386, i32 447, i32 0, i32 17} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2308 = metadata !{i32 449, i32 0, metadata !2309, null}
!2309 = metadata !{i32 786443, metadata !1, metadata !2307, i32 448, i32 0, i32 18} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2310 = metadata !{i32 451, i32 0, metadata !2309, null}
!2311 = metadata !{i32 452, i32 0, metadata !2309, null}
!2312 = metadata !{i32 453, i32 0, metadata !2309, null}
!2313 = metadata !{i32 454, i32 0, metadata !2307, null}
!2314 = metadata !{i32 455, i32 0, metadata !2307, null}
!2315 = metadata !{i32 456, i32 0, metadata !2316, null}
!2316 = metadata !{i32 786443, metadata !1, metadata !1386, i32 455, i32 0, i32 19} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2317 = metadata !{i32 457, i32 0, metadata !2318, null}
!2318 = metadata !{i32 786443, metadata !1, metadata !2316, i32 456, i32 0, i32 20} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2319 = metadata !{i32 458, i32 0, metadata !2318, null}
!2320 = metadata !{i32 460, i32 0, metadata !2316, null}
!2321 = metadata !{i32 462, i32 0, metadata !2322, null}
!2322 = metadata !{i32 786443, metadata !1, metadata !2316, i32 461, i32 0, i32 21} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2323 = metadata !{i32 463, i32 0, metadata !2322, null}
!2324 = metadata !{i32 464, i32 0, metadata !2322, null}
!2325 = metadata !{i32 466, i32 0, metadata !2316, null}
!2326 = metadata !{i32 467, i32 0, metadata !2316, null}
!2327 = metadata !{i32 470, i32 0, metadata !1386, null}
!2328 = metadata !{i32 471, i32 0, metadata !1386, null}
!2329 = metadata !{i32 471, i32 0, metadata !2330, null}
!2330 = metadata !{i32 786443, metadata !1, metadata !1386, i32 471, i32 0, i32 22} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2331 = metadata !{i32 473, i32 0, metadata !1386, null}
!2332 = metadata !{i32 474, i32 0, metadata !1386, null}
!2333 = metadata !{i32 475, i32 0, metadata !1386, null}
!2334 = metadata !{i32 476, i32 0, metadata !1386, null}
!2335 = metadata !{i32 786689, metadata !1398, metadata !"td", metadata !1292, i32 16777713, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 497]
!2336 = metadata !{i32 497, i32 0, metadata !1398, null}
!2337 = metadata !{i32 786689, metadata !1398, metadata !"uap", metadata !1292, i32 33554929, metadata !1401, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 497]
!2338 = metadata !{i32 786688, metadata !1398, metadata !"p", metadata !1292, i32 499, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 499]
!2339 = metadata !{i32 499, i32 0, metadata !1398, null}
!2340 = metadata !{i32 786688, metadata !1398, metadata !"newcred", metadata !1292, i32 500, metadata !253, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [newcred] [line 500]
!2341 = metadata !{i32 500, i32 0, metadata !1398, null}
!2342 = metadata !{i32 786688, metadata !1398, metadata !"oldcred", metadata !1292, i32 500, metadata !253, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [oldcred] [line 500]
!2343 = metadata !{i32 786688, metadata !1398, metadata !"uid", metadata !1292, i32 501, metadata !258, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [uid] [line 501]
!2344 = metadata !{i32 501, i32 0, metadata !1398, null}
!2345 = metadata !{i32 786688, metadata !1398, metadata !"uip", metadata !1292, i32 502, metadata !267, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [uip] [line 502]
!2346 = metadata !{i32 502, i32 0, metadata !1398, null}
!2347 = metadata !{i32 786688, metadata !1398, metadata !"error", metadata !1292, i32 503, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 503]
!2348 = metadata !{i32 503, i32 0, metadata !1398, null}
!2349 = metadata !{i32 505, i32 0, metadata !1398, null}
!2350 = metadata !{i32 506, i32 0, metadata !1398, null}
!2351 = metadata !{i32 506, i32 0, metadata !2352, null}
!2352 = metadata !{i32 786443, metadata !1, metadata !1398, i32 506, i32 0, i32 23} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2353 = metadata !{i32 507, i32 0, metadata !1398, null}
!2354 = metadata !{i32 508, i32 0, metadata !1398, null}
!2355 = metadata !{i32 509, i32 0, metadata !1398, null}
!2356 = metadata !{i32 513, i32 0, metadata !1398, null}
!2357 = metadata !{i32 516, i32 0, metadata !1398, null}
!2358 = metadata !{i32 517, i32 0, metadata !1398, null}
!2359 = metadata !{i32 518, i32 0, metadata !1398, null}
!2360 = metadata !{i32 538, i32 0, metadata !1398, null}
!2361 = metadata !{i32 545, i32 0, metadata !1398, null}
!2362 = metadata !{i32 546, i32 0, metadata !1398, null}
!2363 = metadata !{i32 564, i32 0, metadata !2364, null}
!2364 = metadata !{i32 786443, metadata !1, metadata !1398, i32 560, i32 0, i32 24} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2365 = metadata !{i32 565, i32 0, metadata !2366, null}
!2366 = metadata !{i32 786443, metadata !1, metadata !2364, i32 564, i32 0, i32 25} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2367 = metadata !{i32 566, i32 0, metadata !2366, null}
!2368 = metadata !{i32 567, i32 0, metadata !2366, null}
!2369 = metadata !{i32 575, i32 0, metadata !2364, null}
!2370 = metadata !{i32 576, i32 0, metadata !2371, null}
!2371 = metadata !{i32 786443, metadata !1, metadata !2364, i32 575, i32 0, i32 26} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2372 = metadata !{i32 577, i32 0, metadata !2371, null}
!2373 = metadata !{i32 578, i32 0, metadata !2371, null}
!2374 = metadata !{i32 584, i32 0, metadata !1398, null}
!2375 = metadata !{i32 585, i32 0, metadata !2376, null}
!2376 = metadata !{i32 786443, metadata !1, metadata !1398, i32 584, i32 0, i32 27} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2377 = metadata !{i32 586, i32 0, metadata !2376, null}
!2378 = metadata !{i32 587, i32 0, metadata !2376, null}
!2379 = metadata !{i32 588, i32 0, metadata !1398, null}
!2380 = metadata !{i32 589, i32 0, metadata !1398, null}
!2381 = metadata !{i32 593, i32 0, metadata !1398, null}
!2382 = metadata !{i32 594, i32 0, metadata !1398, null}
!2383 = metadata !{i32 595, i32 0, metadata !1398, null}
!2384 = metadata !{i32 598, i32 0, metadata !1398, null}
!2385 = metadata !{i32 599, i32 0, metadata !1398, null}
!2386 = metadata !{i32 600, i32 0, metadata !1398, null}
!2387 = metadata !{i32 601, i32 0, metadata !1398, null}
!2388 = metadata !{i32 602, i32 0, metadata !1398, null}
!2389 = metadata !{i32 786688, metadata !2390, metadata !"td", metadata !1979, i32 234, metadata !18, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [td] [line 234]
!2390 = metadata !{i32 786443, metadata !1978, metadata !1977} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA/./machine/pcpu.h]
!2391 = metadata !{i32 234, i32 0, metadata !2390, null}
!2392 = metadata !{i32 236, i32 0, metadata !2390, null}
!2393 = metadata !{i32 417311}
!2394 = metadata !{i32 238, i32 0, metadata !2390, null}
!2395 = metadata !{i32 786688, metadata !1880, metadata !"cr", metadata !1292, i32 1809, metadata !253, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [cr] [line 1809]
!2396 = metadata !{i32 1809, i32 0, metadata !1880, null}
!2397 = metadata !{i32 1811, i32 0, metadata !1880, null}
!2398 = metadata !{i32 1812, i32 0, metadata !1880, null}
!2399 = metadata !{i32 1814, i32 0, metadata !1880, null}
!2400 = metadata !{i32 1817, i32 0, metadata !1880, null}
!2401 = metadata !{i32 1819, i32 0, metadata !1880, null}
!2402 = metadata !{i32 1820, i32 0, metadata !1880, null}
!2403 = metadata !{i32 786689, metadata !1911, metadata !"p", metadata !1292, i32 16779172, metadata !11, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [p] [line 1956]
!2404 = metadata !{i32 1956, i32 0, metadata !1911, null}
!2405 = metadata !{i32 786689, metadata !1911, metadata !"cr", metadata !1292, i32 33556388, metadata !253, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [cr] [line 1956]
!2406 = metadata !{i32 786688, metadata !1911, metadata !"oldcred", metadata !1292, i32 1958, metadata !253, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [oldcred] [line 1958]
!2407 = metadata !{i32 1958, i32 0, metadata !1911, null}
!2408 = metadata !{i32 786688, metadata !1911, metadata !"groups", metadata !1292, i32 1959, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [groups] [line 1959]
!2409 = metadata !{i32 1959, i32 0, metadata !1911, null}
!2410 = metadata !{i32 1961, i32 0, metadata !1911, null}
!2411 = metadata !{i32 1963, i32 0, metadata !1911, null}
!2412 = metadata !{i32 1964, i32 0, metadata !1911, null}
!2413 = metadata !{i32 1965, i32 0, metadata !2414, null}
!2414 = metadata !{i32 786443, metadata !1, metadata !1911, i32 1964, i32 0, i32 83} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2415 = metadata !{i32 1966, i32 0, metadata !2414, null}
!2416 = metadata !{i32 1967, i32 0, metadata !2414, null}
!2417 = metadata !{i32 1968, i32 0, metadata !2414, null}
!2418 = metadata !{i32 1969, i32 0, metadata !2414, null}
!2419 = metadata !{i32 1970, i32 0, metadata !2414, null}
!2420 = metadata !{i32 1971, i32 0, metadata !1911, null}
!2421 = metadata !{i32 1973, i32 0, metadata !1911, null}
!2422 = metadata !{i32 786689, metadata !1947, metadata !"newcred", metadata !1292, i32 16779413, metadata !253, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [newcred] [line 2197]
!2423 = metadata !{i32 2197, i32 0, metadata !1947, null}
!2424 = metadata !{i32 786689, metadata !1947, metadata !"ruip", metadata !1292, i32 33556629, metadata !267, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [ruip] [line 2197]
!2425 = metadata !{i32 786688, metadata !1947, metadata !"ruid", metadata !1292, i32 2200, metadata !258, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [ruid] [line 2200]
!2426 = metadata !{i32 2200, i32 0, metadata !1947, null}
!2427 = metadata !{i32 2201, i32 0, metadata !1947, null}
!2428 = metadata !{i32 2207, i32 0, metadata !1947, null}
!2429 = metadata !{i32 2210, i32 0, metadata !1947, null}
!2430 = metadata !{i32 2211, i32 0, metadata !1947, null}
!2431 = metadata !{i32 2212, i32 0, metadata !1947, null}
!2432 = metadata !{i32 2213, i32 0, metadata !1947, null}
!2433 = metadata !{i32 2214, i32 0, metadata !1947, null}
!2434 = metadata !{i32 2215, i32 0, metadata !1947, null}
!2435 = metadata !{i32 2216, i32 0, metadata !1947, null}
!2436 = metadata !{i32 786689, metadata !1938, metadata !"p", metadata !1292, i32 16779345, metadata !11, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [p] [line 2129]
!2437 = metadata !{i32 2129, i32 0, metadata !1938, null}
!2438 = metadata !{i32 2132, i32 0, metadata !1938, null}
!2439 = metadata !{i32 2133, i32 0, metadata !1938, null}
!2440 = metadata !{i32 2134, i32 0, metadata !1938, null}
!2441 = metadata !{i32 2135, i32 0, metadata !1938, null}
!2442 = metadata !{i32 2136, i32 0, metadata !1938, null}
!2443 = metadata !{i32 786689, metadata !1949, metadata !"newcred", metadata !1292, i32 16779463, metadata !253, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [newcred] [line 2247]
!2444 = metadata !{i32 2247, i32 0, metadata !1949, null}
!2445 = metadata !{i32 786689, metadata !1949, metadata !"svuid", metadata !1292, i32 33556679, metadata !258, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [svuid] [line 2247]
!2446 = metadata !{i32 2250, i32 0, metadata !1949, null}
!2447 = metadata !{i32 2256, i32 0, metadata !1949, null}
!2448 = metadata !{i32 2259, i32 0, metadata !1949, null}
!2449 = metadata !{i32 2260, i32 0, metadata !1949, null}
!2450 = metadata !{i32 786689, metadata !1941, metadata !"newcred", metadata !1292, i32 16779361, metadata !253, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [newcred] [line 2145]
!2451 = metadata !{i32 2145, i32 0, metadata !1941, null}
!2452 = metadata !{i32 786689, metadata !1941, metadata !"euip", metadata !1292, i32 33556577, metadata !267, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [euip] [line 2145]
!2453 = metadata !{i32 786688, metadata !1941, metadata !"euid", metadata !1292, i32 2147, metadata !258, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [euid] [line 2147]
!2454 = metadata !{i32 2147, i32 0, metadata !1941, null}
!2455 = metadata !{i32 2150, i32 0, metadata !1941, null}
!2456 = metadata !{i32 2151, i32 0, metadata !1941, null}
!2457 = metadata !{i32 2157, i32 0, metadata !1941, null}
!2458 = metadata !{i32 2160, i32 0, metadata !1941, null}
!2459 = metadata !{i32 2161, i32 0, metadata !1941, null}
!2460 = metadata !{i32 2162, i32 0, metadata !1941, null}
!2461 = metadata !{i32 2163, i32 0, metadata !1941, null}
!2462 = metadata !{i32 2164, i32 0, metadata !1941, null}
!2463 = metadata !{i32 786689, metadata !1886, metadata !"cr", metadata !1292, i32 16779054, metadata !253, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [cr] [line 1838]
!2464 = metadata !{i32 1838, i32 0, metadata !1886, null}
!2465 = metadata !{i32 1841, i32 0, metadata !1886, null}
!2466 = metadata !{i32 1841, i32 0, metadata !2467, null}
!2467 = metadata !{i32 786443, metadata !1, metadata !1886, i32 1841, i32 0, i32 79} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2468 = metadata !{i32 1842, i32 0, metadata !1886, null}
!2469 = metadata !{i32 1842, i32 0, metadata !2470, null}
!2470 = metadata !{i32 786443, metadata !1, metadata !1886, i32 1842, i32 0, i32 80} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2471 = metadata !{i32 1843, i32 6, metadata !1886, null}
!2472 = metadata !{i32 1849, i32 0, metadata !2473, null}
!2473 = metadata !{i32 786443, metadata !1, metadata !1886, i32 1843, i32 0, i32 81} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2474 = metadata !{i32 1850, i32 0, metadata !2473, null}
!2475 = metadata !{i32 1851, i32 0, metadata !2473, null}
!2476 = metadata !{i32 1852, i32 0, metadata !2473, null}
!2477 = metadata !{i32 1856, i32 0, metadata !2473, null}
!2478 = metadata !{i32 1857, i32 0, metadata !2473, null}
!2479 = metadata !{i32 1858, i32 0, metadata !2473, null}
!2480 = metadata !{i32 1859, i32 0, metadata !2473, null}
!2481 = metadata !{i32 1861, i32 0, metadata !2473, null}
!2482 = metadata !{i32 1864, i32 0, metadata !2473, null}
!2483 = metadata !{i32 1866, i32 0, metadata !2473, null}
!2484 = metadata !{i32 1867, i32 0, metadata !2473, null}
!2485 = metadata !{i32 1868, i32 0, metadata !2473, null}
!2486 = metadata !{i32 1869, i32 0, metadata !1886, null}
!2487 = metadata !{i32 786689, metadata !1407, metadata !"td", metadata !1292, i32 16777827, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 611]
!2488 = metadata !{i32 611, i32 0, metadata !1407, null}
!2489 = metadata !{i32 786689, metadata !1407, metadata !"uap", metadata !1292, i32 33555043, metadata !1410, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 611]
!2490 = metadata !{i32 786688, metadata !1407, metadata !"p", metadata !1292, i32 613, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 613]
!2491 = metadata !{i32 613, i32 0, metadata !1407, null}
!2492 = metadata !{i32 786688, metadata !1407, metadata !"newcred", metadata !1292, i32 614, metadata !253, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [newcred] [line 614]
!2493 = metadata !{i32 614, i32 0, metadata !1407, null}
!2494 = metadata !{i32 786688, metadata !1407, metadata !"oldcred", metadata !1292, i32 614, metadata !253, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [oldcred] [line 614]
!2495 = metadata !{i32 786688, metadata !1407, metadata !"euid", metadata !1292, i32 615, metadata !258, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [euid] [line 615]
!2496 = metadata !{i32 615, i32 0, metadata !1407, null}
!2497 = metadata !{i32 786688, metadata !1407, metadata !"euip", metadata !1292, i32 616, metadata !267, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [euip] [line 616]
!2498 = metadata !{i32 616, i32 0, metadata !1407, null}
!2499 = metadata !{i32 786688, metadata !1407, metadata !"error", metadata !1292, i32 617, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 617]
!2500 = metadata !{i32 617, i32 0, metadata !1407, null}
!2501 = metadata !{i32 619, i32 0, metadata !1407, null}
!2502 = metadata !{i32 620, i32 0, metadata !1407, null}
!2503 = metadata !{i32 620, i32 0, metadata !2504, null}
!2504 = metadata !{i32 786443, metadata !1, metadata !1407, i32 620, i32 0, i32 28} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2505 = metadata !{i32 621, i32 0, metadata !1407, null}
!2506 = metadata !{i32 622, i32 0, metadata !1407, null}
!2507 = metadata !{i32 623, i32 0, metadata !1407, null}
!2508 = metadata !{i32 627, i32 0, metadata !1407, null}
!2509 = metadata !{i32 630, i32 0, metadata !1407, null}
!2510 = metadata !{i32 631, i32 0, metadata !1407, null}
!2511 = metadata !{i32 632, i32 0, metadata !1407, null}
!2512 = metadata !{i32 635, i32 0, metadata !1407, null}
!2513 = metadata !{i32 637, i32 0, metadata !1407, null}
!2514 = metadata !{i32 638, i32 0, metadata !1407, null}
!2515 = metadata !{i32 643, i32 0, metadata !1407, null}
!2516 = metadata !{i32 644, i32 0, metadata !2517, null}
!2517 = metadata !{i32 786443, metadata !1, metadata !1407, i32 643, i32 0, i32 29} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2518 = metadata !{i32 645, i32 0, metadata !2517, null}
!2519 = metadata !{i32 646, i32 0, metadata !2517, null}
!2520 = metadata !{i32 647, i32 0, metadata !1407, null}
!2521 = metadata !{i32 648, i32 0, metadata !1407, null}
!2522 = metadata !{i32 649, i32 0, metadata !1407, null}
!2523 = metadata !{i32 650, i32 0, metadata !1407, null}
!2524 = metadata !{i32 651, i32 0, metadata !1407, null}
!2525 = metadata !{i32 654, i32 0, metadata !1407, null}
!2526 = metadata !{i32 655, i32 0, metadata !1407, null}
!2527 = metadata !{i32 656, i32 0, metadata !1407, null}
!2528 = metadata !{i32 657, i32 0, metadata !1407, null}
!2529 = metadata !{i32 658, i32 0, metadata !1407, null}
!2530 = metadata !{i32 786689, metadata !1416, metadata !"td", metadata !1292, i32 16777883, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 667]
!2531 = metadata !{i32 667, i32 0, metadata !1416, null}
!2532 = metadata !{i32 786689, metadata !1416, metadata !"uap", metadata !1292, i32 33555099, metadata !1419, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 667]
!2533 = metadata !{i32 786688, metadata !1416, metadata !"p", metadata !1292, i32 669, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 669]
!2534 = metadata !{i32 669, i32 0, metadata !1416, null}
!2535 = metadata !{i32 786688, metadata !1416, metadata !"newcred", metadata !1292, i32 670, metadata !253, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [newcred] [line 670]
!2536 = metadata !{i32 670, i32 0, metadata !1416, null}
!2537 = metadata !{i32 786688, metadata !1416, metadata !"oldcred", metadata !1292, i32 670, metadata !253, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [oldcred] [line 670]
!2538 = metadata !{i32 786688, metadata !1416, metadata !"gid", metadata !1292, i32 671, metadata !263, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [gid] [line 671]
!2539 = metadata !{i32 671, i32 0, metadata !1416, null}
!2540 = metadata !{i32 786688, metadata !1416, metadata !"error", metadata !1292, i32 672, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 672]
!2541 = metadata !{i32 672, i32 0, metadata !1416, null}
!2542 = metadata !{i32 674, i32 0, metadata !1416, null}
!2543 = metadata !{i32 675, i32 0, metadata !1416, null}
!2544 = metadata !{i32 675, i32 0, metadata !2545, null}
!2545 = metadata !{i32 786443, metadata !1, metadata !1416, i32 675, i32 0, i32 30} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2546 = metadata !{i32 676, i32 0, metadata !1416, null}
!2547 = metadata !{i32 677, i32 0, metadata !1416, null}
!2548 = metadata !{i32 678, i32 0, metadata !1416, null}
!2549 = metadata !{i32 681, i32 0, metadata !1416, null}
!2550 = metadata !{i32 682, i32 0, metadata !1416, null}
!2551 = metadata !{i32 683, i32 0, metadata !1416, null}
!2552 = metadata !{i32 697, i32 0, metadata !1416, null}
!2553 = metadata !{i32 704, i32 0, metadata !1416, null}
!2554 = metadata !{i32 705, i32 0, metadata !1416, null}
!2555 = metadata !{i32 723, i32 0, metadata !2556, null}
!2556 = metadata !{i32 786443, metadata !1, metadata !1416, i32 719, i32 0, i32 31} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2557 = metadata !{i32 724, i32 0, metadata !2558, null}
!2558 = metadata !{i32 786443, metadata !1, metadata !2556, i32 723, i32 0, i32 32} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2559 = metadata !{i32 725, i32 0, metadata !2558, null}
!2560 = metadata !{i32 726, i32 0, metadata !2558, null}
!2561 = metadata !{i32 734, i32 0, metadata !2556, null}
!2562 = metadata !{i32 735, i32 0, metadata !2563, null}
!2563 = metadata !{i32 786443, metadata !1, metadata !2556, i32 734, i32 0, i32 33} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2564 = metadata !{i32 736, i32 0, metadata !2563, null}
!2565 = metadata !{i32 737, i32 0, metadata !2563, null}
!2566 = metadata !{i32 743, i32 0, metadata !1416, null}
!2567 = metadata !{i32 744, i32 0, metadata !2568, null}
!2568 = metadata !{i32 786443, metadata !1, metadata !1416, i32 743, i32 0, i32 34} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2569 = metadata !{i32 745, i32 0, metadata !2568, null}
!2570 = metadata !{i32 746, i32 0, metadata !2568, null}
!2571 = metadata !{i32 747, i32 0, metadata !1416, null}
!2572 = metadata !{i32 748, i32 0, metadata !1416, null}
!2573 = metadata !{i32 749, i32 0, metadata !1416, null}
!2574 = metadata !{i32 750, i32 0, metadata !1416, null}
!2575 = metadata !{i32 753, i32 0, metadata !1416, null}
!2576 = metadata !{i32 754, i32 0, metadata !1416, null}
!2577 = metadata !{i32 755, i32 0, metadata !1416, null}
!2578 = metadata !{i32 756, i32 0, metadata !1416, null}
!2579 = metadata !{i32 786689, metadata !1948, metadata !"newcred", metadata !1292, i32 16779441, metadata !253, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [newcred] [line 2225]
!2580 = metadata !{i32 2225, i32 0, metadata !1948, null}
!2581 = metadata !{i32 786689, metadata !1948, metadata !"rgid", metadata !1292, i32 33556657, metadata !263, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [rgid] [line 2225]
!2582 = metadata !{i32 2228, i32 0, metadata !1948, null}
!2583 = metadata !{i32 2234, i32 0, metadata !1948, null}
!2584 = metadata !{i32 2237, i32 0, metadata !1948, null}
!2585 = metadata !{i32 2238, i32 0, metadata !1948, null}
!2586 = metadata !{i32 786689, metadata !1952, metadata !"newcred", metadata !1292, i32 16779485, metadata !253, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [newcred] [line 2269]
!2587 = metadata !{i32 2269, i32 0, metadata !1952, null}
!2588 = metadata !{i32 786689, metadata !1952, metadata !"svgid", metadata !1292, i32 33556701, metadata !263, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [svgid] [line 2269]
!2589 = metadata !{i32 2272, i32 0, metadata !1952, null}
!2590 = metadata !{i32 2278, i32 0, metadata !1952, null}
!2591 = metadata !{i32 2281, i32 0, metadata !1952, null}
!2592 = metadata !{i32 2282, i32 0, metadata !1952, null}
!2593 = metadata !{i32 786689, metadata !1944, metadata !"newcred", metadata !1292, i32 16779389, metadata !253, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [newcred] [line 2173]
!2594 = metadata !{i32 2173, i32 0, metadata !1944, null}
!2595 = metadata !{i32 786689, metadata !1944, metadata !"egid", metadata !1292, i32 33556605, metadata !263, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [egid] [line 2173]
!2596 = metadata !{i32 2176, i32 0, metadata !1944, null}
!2597 = metadata !{i32 2182, i32 0, metadata !1944, null}
!2598 = metadata !{i32 2185, i32 0, metadata !1944, null}
!2599 = metadata !{i32 2186, i32 0, metadata !1944, null}
!2600 = metadata !{i32 786689, metadata !1425, metadata !"td", metadata !1292, i32 16777981, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 765]
!2601 = metadata !{i32 765, i32 0, metadata !1425, null}
!2602 = metadata !{i32 786689, metadata !1425, metadata !"uap", metadata !1292, i32 33555197, metadata !1428, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 765]
!2603 = metadata !{i32 786688, metadata !1425, metadata !"p", metadata !1292, i32 767, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 767]
!2604 = metadata !{i32 767, i32 0, metadata !1425, null}
!2605 = metadata !{i32 786688, metadata !1425, metadata !"newcred", metadata !1292, i32 768, metadata !253, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [newcred] [line 768]
!2606 = metadata !{i32 768, i32 0, metadata !1425, null}
!2607 = metadata !{i32 786688, metadata !1425, metadata !"oldcred", metadata !1292, i32 768, metadata !253, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [oldcred] [line 768]
!2608 = metadata !{i32 786688, metadata !1425, metadata !"egid", metadata !1292, i32 769, metadata !263, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [egid] [line 769]
!2609 = metadata !{i32 769, i32 0, metadata !1425, null}
!2610 = metadata !{i32 786688, metadata !1425, metadata !"error", metadata !1292, i32 770, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 770]
!2611 = metadata !{i32 770, i32 0, metadata !1425, null}
!2612 = metadata !{i32 772, i32 0, metadata !1425, null}
!2613 = metadata !{i32 773, i32 0, metadata !1425, null}
!2614 = metadata !{i32 773, i32 0, metadata !2615, null}
!2615 = metadata !{i32 786443, metadata !1, metadata !1425, i32 773, i32 0, i32 35} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2616 = metadata !{i32 774, i32 0, metadata !1425, null}
!2617 = metadata !{i32 775, i32 0, metadata !1425, null}
!2618 = metadata !{i32 776, i32 0, metadata !1425, null}
!2619 = metadata !{i32 779, i32 0, metadata !1425, null}
!2620 = metadata !{i32 780, i32 0, metadata !1425, null}
!2621 = metadata !{i32 781, i32 0, metadata !1425, null}
!2622 = metadata !{i32 784, i32 0, metadata !1425, null}
!2623 = metadata !{i32 786, i32 0, metadata !1425, null}
!2624 = metadata !{i32 787, i32 0, metadata !1425, null}
!2625 = metadata !{i32 789, i32 0, metadata !1425, null}
!2626 = metadata !{i32 790, i32 0, metadata !2627, null}
!2627 = metadata !{i32 786443, metadata !1, metadata !1425, i32 789, i32 0, i32 36} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2628 = metadata !{i32 791, i32 0, metadata !2627, null}
!2629 = metadata !{i32 792, i32 0, metadata !2627, null}
!2630 = metadata !{i32 793, i32 0, metadata !1425, null}
!2631 = metadata !{i32 794, i32 0, metadata !1425, null}
!2632 = metadata !{i32 795, i32 0, metadata !1425, null}
!2633 = metadata !{i32 796, i32 0, metadata !1425, null}
!2634 = metadata !{i32 799, i32 0, metadata !1425, null}
!2635 = metadata !{i32 800, i32 0, metadata !1425, null}
!2636 = metadata !{i32 801, i32 0, metadata !1425, null}
!2637 = metadata !{i32 802, i32 0, metadata !1425, null}
!2638 = metadata !{i32 786689, metadata !1434, metadata !"td", metadata !1292, i32 16778028, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 812]
!2639 = metadata !{i32 812, i32 0, metadata !1434, null}
!2640 = metadata !{i32 786689, metadata !1434, metadata !"uap", metadata !1292, i32 33555244, metadata !1437, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 812]
!2641 = metadata !{i32 786688, metadata !1434, metadata !"groups", metadata !1292, i32 814, metadata !509, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [groups] [line 814]
!2642 = metadata !{i32 814, i32 0, metadata !1434, null}
!2643 = metadata !{i32 786688, metadata !1434, metadata !"error", metadata !1292, i32 815, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 815]
!2644 = metadata !{i32 815, i32 0, metadata !1434, null}
!2645 = metadata !{i32 817, i32 0, metadata !1434, null}
!2646 = metadata !{i32 818, i32 0, metadata !1434, null}
!2647 = metadata !{i32 819, i32 0, metadata !1434, null}
!2648 = metadata !{i32 820, i32 0, metadata !1434, null}
!2649 = metadata !{i32 821, i32 0, metadata !1434, null}
!2650 = metadata !{i32 822, i32 0, metadata !1434, null}
!2651 = metadata !{i32 823, i32 0, metadata !1434, null}
!2652 = metadata !{i32 825, i32 0, metadata !1434, null}
!2653 = metadata !{i32 826, i32 0, metadata !1434, null}
!2654 = metadata !{i32 827, i32 0, metadata !1434, null}
!2655 = metadata !{i32 786689, metadata !1446, metadata !"td", metadata !1292, i32 16778046, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 830]
!2656 = metadata !{i32 830, i32 0, metadata !1446, null}
!2657 = metadata !{i32 786689, metadata !1446, metadata !"ngrp", metadata !1292, i32 33555262, metadata !36, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [ngrp] [line 830]
!2658 = metadata !{i32 786689, metadata !1446, metadata !"groups", metadata !1292, i32 50332478, metadata !509, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [groups] [line 830]
!2659 = metadata !{i32 786688, metadata !1446, metadata !"p", metadata !1292, i32 832, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 832]
!2660 = metadata !{i32 832, i32 0, metadata !1446, null}
!2661 = metadata !{i32 786688, metadata !1446, metadata !"newcred", metadata !1292, i32 833, metadata !253, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [newcred] [line 833]
!2662 = metadata !{i32 833, i32 0, metadata !1446, null}
!2663 = metadata !{i32 786688, metadata !1446, metadata !"oldcred", metadata !1292, i32 833, metadata !253, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [oldcred] [line 833]
!2664 = metadata !{i32 786688, metadata !1446, metadata !"error", metadata !1292, i32 834, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 834]
!2665 = metadata !{i32 834, i32 0, metadata !1446, null}
!2666 = metadata !{i32 836, i32 0, metadata !1446, null}
!2667 = metadata !{i32 837, i32 0, metadata !1446, null}
!2668 = metadata !{i32 838, i32 0, metadata !1446, null}
!2669 = metadata !{i32 838, i32 0, metadata !2670, null}
!2670 = metadata !{i32 786443, metadata !1, metadata !1446, i32 838, i32 0, i32 37} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2671 = metadata !{i32 839, i32 0, metadata !1446, null}
!2672 = metadata !{i32 840, i32 0, metadata !1446, null}
!2673 = metadata !{i32 841, i32 0, metadata !1446, null}
!2674 = metadata !{i32 842, i32 0, metadata !1446, null}
!2675 = metadata !{i32 845, i32 0, metadata !1446, null}
!2676 = metadata !{i32 846, i32 0, metadata !1446, null}
!2677 = metadata !{i32 847, i32 0, metadata !1446, null}
!2678 = metadata !{i32 850, i32 0, metadata !1446, null}
!2679 = metadata !{i32 851, i32 0, metadata !1446, null}
!2680 = metadata !{i32 852, i32 0, metadata !1446, null}
!2681 = metadata !{i32 854, i32 0, metadata !1446, null}
!2682 = metadata !{i32 861, i32 0, metadata !2683, null}
!2683 = metadata !{i32 786443, metadata !1, metadata !1446, i32 854, i32 0, i32 38} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2684 = metadata !{i32 862, i32 0, metadata !2683, null}
!2685 = metadata !{i32 863, i32 0, metadata !2686, null}
!2686 = metadata !{i32 786443, metadata !1, metadata !1446, i32 862, i32 0, i32 39} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2687 = metadata !{i32 865, i32 0, metadata !1446, null}
!2688 = metadata !{i32 866, i32 0, metadata !1446, null}
!2689 = metadata !{i32 867, i32 0, metadata !1446, null}
!2690 = metadata !{i32 868, i32 0, metadata !1446, null}
!2691 = metadata !{i32 869, i32 0, metadata !1446, null}
!2692 = metadata !{i32 872, i32 0, metadata !1446, null}
!2693 = metadata !{i32 873, i32 0, metadata !1446, null}
!2694 = metadata !{i32 874, i32 0, metadata !1446, null}
!2695 = metadata !{i32 875, i32 0, metadata !1446, null}
!2696 = metadata !{i32 786689, metadata !1954, metadata !"cr", metadata !1292, i32 16779196, metadata !253, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [cr] [line 1980]
!2697 = metadata !{i32 1980, i32 0, metadata !1954, null}
!2698 = metadata !{i32 786689, metadata !1954, metadata !"n", metadata !1292, i32 33556412, metadata !93, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [n] [line 1980]
!2699 = metadata !{i32 786688, metadata !1954, metadata !"cnt", metadata !1292, i32 1982, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [cnt] [line 1982]
!2700 = metadata !{i32 1982, i32 0, metadata !1954, null}
!2701 = metadata !{i32 1985, i32 0, metadata !1954, null}
!2702 = metadata !{i32 1986, i32 0, metadata !1954, null}
!2703 = metadata !{i32 1997, i32 0, metadata !1954, null}
!2704 = metadata !{i32 1998, i32 0, metadata !2705, null}
!2705 = metadata !{i32 786443, metadata !1, metadata !1954, i32 1997, i32 0, i32 89} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2706 = metadata !{i32 1999, i32 0, metadata !2705, null}
!2707 = metadata !{i32 2001, i32 0, metadata !2705, null}
!2708 = metadata !{i32 2003, i32 0, metadata !2705, null}
!2709 = metadata !{i32 2004, i32 0, metadata !2705, null}
!2710 = metadata !{i32 2005, i32 0, metadata !2705, null}
!2711 = metadata !{i32 2006, i32 0, metadata !1954, null}
!2712 = metadata !{i32 2009, i32 0, metadata !1954, null}
!2713 = metadata !{i32 2010, i32 0, metadata !1954, null}
!2714 = metadata !{i32 2012, i32 0, metadata !1954, null}
!2715 = metadata !{i32 2013, i32 0, metadata !1954, null}
!2716 = metadata !{i32 786689, metadata !1953, metadata !"cr", metadata !1292, i32 16779239, metadata !253, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [cr] [line 2023]
!2717 = metadata !{i32 2023, i32 0, metadata !1953, null}
!2718 = metadata !{i32 786689, metadata !1953, metadata !"ngrp", metadata !1292, i32 33556455, metadata !93, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [ngrp] [line 2023]
!2719 = metadata !{i32 786689, metadata !1953, metadata !"groups", metadata !1292, i32 50333671, metadata !509, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [groups] [line 2023]
!2720 = metadata !{i32 786688, metadata !1953, metadata !"i", metadata !1292, i32 2025, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 2025]
!2721 = metadata !{i32 2025, i32 0, metadata !1953, null}
!2722 = metadata !{i32 786688, metadata !1953, metadata !"j", metadata !1292, i32 2026, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [j] [line 2026]
!2723 = metadata !{i32 2026, i32 0, metadata !1953, null}
!2724 = metadata !{i32 786688, metadata !1953, metadata !"g", metadata !1292, i32 2027, metadata !263, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [g] [line 2027]
!2725 = metadata !{i32 2027, i32 0, metadata !1953, null}
!2726 = metadata !{i32 2029, i32 0, metadata !1953, null}
!2727 = metadata !{i32 2029, i32 0, metadata !2728, null}
!2728 = metadata !{i32 786443, metadata !1, metadata !1953, i32 2029, i32 0, i32 85} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2729 = metadata !{i32 2031, i32 0, metadata !1953, null}
!2730 = metadata !{i32 2032, i32 0, metadata !1953, null}
!2731 = metadata !{i32 2042, i32 0, metadata !2732, null}
!2732 = metadata !{i32 786443, metadata !1, metadata !1953, i32 2042, i32 0, i32 86} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2733 = metadata !{i32 2043, i32 0, metadata !2734, null}
!2734 = metadata !{i32 786443, metadata !1, metadata !2732, i32 2042, i32 0, i32 87} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2735 = metadata !{i32 2044, i32 0, metadata !2736, null}
!2736 = metadata !{i32 786443, metadata !1, metadata !2734, i32 2044, i32 0, i32 88} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2737 = metadata !{i32 2045, i32 0, metadata !2736, null}
!2738 = metadata !{i32 2046, i32 0, metadata !2734, null}
!2739 = metadata !{i32 2047, i32 0, metadata !2734, null}
!2740 = metadata !{i32 2048, i32 0, metadata !1953, null}
!2741 = metadata !{i32 786689, metadata !1449, metadata !"td", metadata !1292, i32 16778101, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 885]
!2742 = metadata !{i32 885, i32 0, metadata !1449, null}
!2743 = metadata !{i32 786689, metadata !1449, metadata !"uap", metadata !1292, i32 33555317, metadata !1452, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 885]
!2744 = metadata !{i32 786688, metadata !1449, metadata !"p", metadata !1292, i32 887, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 887]
!2745 = metadata !{i32 887, i32 0, metadata !1449, null}
!2746 = metadata !{i32 786688, metadata !1449, metadata !"newcred", metadata !1292, i32 888, metadata !253, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [newcred] [line 888]
!2747 = metadata !{i32 888, i32 0, metadata !1449, null}
!2748 = metadata !{i32 786688, metadata !1449, metadata !"oldcred", metadata !1292, i32 888, metadata !253, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [oldcred] [line 888]
!2749 = metadata !{i32 786688, metadata !1449, metadata !"euid", metadata !1292, i32 889, metadata !258, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [euid] [line 889]
!2750 = metadata !{i32 889, i32 0, metadata !1449, null}
!2751 = metadata !{i32 786688, metadata !1449, metadata !"ruid", metadata !1292, i32 889, metadata !258, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [ruid] [line 889]
!2752 = metadata !{i32 786688, metadata !1449, metadata !"euip", metadata !1292, i32 890, metadata !267, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [euip] [line 890]
!2753 = metadata !{i32 890, i32 0, metadata !1449, null}
!2754 = metadata !{i32 786688, metadata !1449, metadata !"ruip", metadata !1292, i32 890, metadata !267, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [ruip] [line 890]
!2755 = metadata !{i32 786688, metadata !1449, metadata !"error", metadata !1292, i32 891, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 891]
!2756 = metadata !{i32 891, i32 0, metadata !1449, null}
!2757 = metadata !{i32 893, i32 0, metadata !1449, null}
!2758 = metadata !{i32 894, i32 0, metadata !1449, null}
!2759 = metadata !{i32 895, i32 0, metadata !1449, null}
!2760 = metadata !{i32 895, i32 0, metadata !2761, null}
!2761 = metadata !{i32 786443, metadata !1, metadata !1449, i32 895, i32 0, i32 40} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2762 = metadata !{i32 896, i32 0, metadata !1449, null}
!2763 = metadata !{i32 896, i32 0, metadata !2764, null}
!2764 = metadata !{i32 786443, metadata !1, metadata !1449, i32 896, i32 0, i32 41} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2765 = metadata !{i32 897, i32 0, metadata !1449, null}
!2766 = metadata !{i32 898, i32 0, metadata !1449, null}
!2767 = metadata !{i32 899, i32 0, metadata !1449, null}
!2768 = metadata !{i32 900, i32 0, metadata !1449, null}
!2769 = metadata !{i32 901, i32 0, metadata !1449, null}
!2770 = metadata !{i32 904, i32 0, metadata !1449, null}
!2771 = metadata !{i32 905, i32 0, metadata !1449, null}
!2772 = metadata !{i32 906, i32 0, metadata !1449, null}
!2773 = metadata !{i32 909, i32 0, metadata !1449, null}
!2774 = metadata !{i32 913, i32 0, metadata !1449, null}
!2775 = metadata !{i32 914, i32 0, metadata !1449, null}
!2776 = metadata !{i32 916, i32 0, metadata !1449, null}
!2777 = metadata !{i32 917, i32 0, metadata !2778, null}
!2778 = metadata !{i32 786443, metadata !1, metadata !1449, i32 916, i32 0, i32 42} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2779 = metadata !{i32 918, i32 0, metadata !2778, null}
!2780 = metadata !{i32 919, i32 0, metadata !2778, null}
!2781 = metadata !{i32 920, i32 0, metadata !1449, null}
!2782 = metadata !{i32 921, i32 0, metadata !2783, null}
!2783 = metadata !{i32 786443, metadata !1, metadata !1449, i32 920, i32 0, i32 43} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2784 = metadata !{i32 922, i32 0, metadata !2783, null}
!2785 = metadata !{i32 923, i32 0, metadata !2783, null}
!2786 = metadata !{i32 924, i32 0, metadata !1449, null}
!2787 = metadata !{i32 926, i32 0, metadata !2788, null}
!2788 = metadata !{i32 786443, metadata !1, metadata !1449, i32 925, i32 0, i32 44} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2789 = metadata !{i32 927, i32 0, metadata !2788, null}
!2790 = metadata !{i32 928, i32 0, metadata !2788, null}
!2791 = metadata !{i32 929, i32 0, metadata !1449, null}
!2792 = metadata !{i32 930, i32 0, metadata !1449, null}
!2793 = metadata !{i32 934, i32 0, metadata !1449, null}
!2794 = metadata !{i32 935, i32 0, metadata !1449, null}
!2795 = metadata !{i32 936, i32 0, metadata !1449, null}
!2796 = metadata !{i32 937, i32 0, metadata !1449, null}
!2797 = metadata !{i32 940, i32 0, metadata !1449, null}
!2798 = metadata !{i32 941, i32 0, metadata !1449, null}
!2799 = metadata !{i32 942, i32 0, metadata !1449, null}
!2800 = metadata !{i32 943, i32 0, metadata !1449, null}
!2801 = metadata !{i32 944, i32 0, metadata !1449, null}
!2802 = metadata !{i32 945, i32 0, metadata !1449, null}
!2803 = metadata !{i32 786689, metadata !1461, metadata !"td", metadata !1292, i32 16778171, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 955]
!2804 = metadata !{i32 955, i32 0, metadata !1461, null}
!2805 = metadata !{i32 786689, metadata !1461, metadata !"uap", metadata !1292, i32 33555387, metadata !1464, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 955]
!2806 = metadata !{i32 786688, metadata !1461, metadata !"p", metadata !1292, i32 957, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 957]
!2807 = metadata !{i32 957, i32 0, metadata !1461, null}
!2808 = metadata !{i32 786688, metadata !1461, metadata !"newcred", metadata !1292, i32 958, metadata !253, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [newcred] [line 958]
!2809 = metadata !{i32 958, i32 0, metadata !1461, null}
!2810 = metadata !{i32 786688, metadata !1461, metadata !"oldcred", metadata !1292, i32 958, metadata !253, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [oldcred] [line 958]
!2811 = metadata !{i32 786688, metadata !1461, metadata !"egid", metadata !1292, i32 959, metadata !263, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [egid] [line 959]
!2812 = metadata !{i32 959, i32 0, metadata !1461, null}
!2813 = metadata !{i32 786688, metadata !1461, metadata !"rgid", metadata !1292, i32 959, metadata !263, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [rgid] [line 959]
!2814 = metadata !{i32 786688, metadata !1461, metadata !"error", metadata !1292, i32 960, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 960]
!2815 = metadata !{i32 960, i32 0, metadata !1461, null}
!2816 = metadata !{i32 962, i32 0, metadata !1461, null}
!2817 = metadata !{i32 963, i32 0, metadata !1461, null}
!2818 = metadata !{i32 964, i32 0, metadata !1461, null}
!2819 = metadata !{i32 964, i32 0, metadata !2820, null}
!2820 = metadata !{i32 786443, metadata !1, metadata !1461, i32 964, i32 0, i32 45} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2821 = metadata !{i32 965, i32 0, metadata !1461, null}
!2822 = metadata !{i32 965, i32 0, metadata !2823, null}
!2823 = metadata !{i32 786443, metadata !1, metadata !1461, i32 965, i32 0, i32 46} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2824 = metadata !{i32 966, i32 0, metadata !1461, null}
!2825 = metadata !{i32 967, i32 0, metadata !1461, null}
!2826 = metadata !{i32 968, i32 0, metadata !1461, null}
!2827 = metadata !{i32 971, i32 0, metadata !1461, null}
!2828 = metadata !{i32 972, i32 0, metadata !1461, null}
!2829 = metadata !{i32 973, i32 0, metadata !1461, null}
!2830 = metadata !{i32 976, i32 0, metadata !1461, null}
!2831 = metadata !{i32 980, i32 0, metadata !1461, null}
!2832 = metadata !{i32 981, i32 0, metadata !1461, null}
!2833 = metadata !{i32 983, i32 0, metadata !1461, null}
!2834 = metadata !{i32 984, i32 0, metadata !2835, null}
!2835 = metadata !{i32 786443, metadata !1, metadata !1461, i32 983, i32 0, i32 47} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2836 = metadata !{i32 985, i32 0, metadata !2835, null}
!2837 = metadata !{i32 986, i32 0, metadata !2835, null}
!2838 = metadata !{i32 987, i32 0, metadata !1461, null}
!2839 = metadata !{i32 988, i32 0, metadata !2840, null}
!2840 = metadata !{i32 786443, metadata !1, metadata !1461, i32 987, i32 0, i32 48} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2841 = metadata !{i32 989, i32 0, metadata !2840, null}
!2842 = metadata !{i32 990, i32 0, metadata !2840, null}
!2843 = metadata !{i32 991, i32 0, metadata !1461, null}
!2844 = metadata !{i32 993, i32 0, metadata !2845, null}
!2845 = metadata !{i32 786443, metadata !1, metadata !1461, i32 992, i32 0, i32 49} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2846 = metadata !{i32 994, i32 0, metadata !2845, null}
!2847 = metadata !{i32 995, i32 0, metadata !2845, null}
!2848 = metadata !{i32 996, i32 0, metadata !1461, null}
!2849 = metadata !{i32 997, i32 0, metadata !1461, null}
!2850 = metadata !{i32 998, i32 0, metadata !1461, null}
!2851 = metadata !{i32 999, i32 0, metadata !1461, null}
!2852 = metadata !{i32 1002, i32 0, metadata !1461, null}
!2853 = metadata !{i32 1003, i32 0, metadata !1461, null}
!2854 = metadata !{i32 1004, i32 0, metadata !1461, null}
!2855 = metadata !{i32 1005, i32 0, metadata !1461, null}
!2856 = metadata !{i32 786689, metadata !1473, metadata !"td", metadata !1292, i32 16778236, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 1020]
!2857 = metadata !{i32 1020, i32 0, metadata !1473, null}
!2858 = metadata !{i32 786689, metadata !1473, metadata !"uap", metadata !1292, i32 33555452, metadata !1476, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 1020]
!2859 = metadata !{i32 786688, metadata !1473, metadata !"p", metadata !1292, i32 1022, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 1022]
!2860 = metadata !{i32 1022, i32 0, metadata !1473, null}
!2861 = metadata !{i32 786688, metadata !1473, metadata !"newcred", metadata !1292, i32 1023, metadata !253, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [newcred] [line 1023]
!2862 = metadata !{i32 1023, i32 0, metadata !1473, null}
!2863 = metadata !{i32 786688, metadata !1473, metadata !"oldcred", metadata !1292, i32 1023, metadata !253, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [oldcred] [line 1023]
!2864 = metadata !{i32 786688, metadata !1473, metadata !"euid", metadata !1292, i32 1024, metadata !258, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [euid] [line 1024]
!2865 = metadata !{i32 1024, i32 0, metadata !1473, null}
!2866 = metadata !{i32 786688, metadata !1473, metadata !"ruid", metadata !1292, i32 1024, metadata !258, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [ruid] [line 1024]
!2867 = metadata !{i32 786688, metadata !1473, metadata !"suid", metadata !1292, i32 1024, metadata !258, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [suid] [line 1024]
!2868 = metadata !{i32 786688, metadata !1473, metadata !"euip", metadata !1292, i32 1025, metadata !267, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [euip] [line 1025]
!2869 = metadata !{i32 1025, i32 0, metadata !1473, null}
!2870 = metadata !{i32 786688, metadata !1473, metadata !"ruip", metadata !1292, i32 1025, metadata !267, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [ruip] [line 1025]
!2871 = metadata !{i32 786688, metadata !1473, metadata !"error", metadata !1292, i32 1026, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 1026]
!2872 = metadata !{i32 1026, i32 0, metadata !1473, null}
!2873 = metadata !{i32 1028, i32 0, metadata !1473, null}
!2874 = metadata !{i32 1029, i32 0, metadata !1473, null}
!2875 = metadata !{i32 1030, i32 0, metadata !1473, null}
!2876 = metadata !{i32 1031, i32 0, metadata !1473, null}
!2877 = metadata !{i32 1031, i32 0, metadata !2878, null}
!2878 = metadata !{i32 786443, metadata !1, metadata !1473, i32 1031, i32 0, i32 50} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2879 = metadata !{i32 1032, i32 0, metadata !1473, null}
!2880 = metadata !{i32 1032, i32 0, metadata !2881, null}
!2881 = metadata !{i32 786443, metadata !1, metadata !1473, i32 1032, i32 0, i32 51} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2882 = metadata !{i32 1033, i32 0, metadata !1473, null}
!2883 = metadata !{i32 1033, i32 0, metadata !2884, null}
!2884 = metadata !{i32 786443, metadata !1, metadata !1473, i32 1033, i32 0, i32 52} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2885 = metadata !{i32 1034, i32 0, metadata !1473, null}
!2886 = metadata !{i32 1035, i32 0, metadata !1473, null}
!2887 = metadata !{i32 1036, i32 0, metadata !1473, null}
!2888 = metadata !{i32 1037, i32 0, metadata !1473, null}
!2889 = metadata !{i32 1038, i32 0, metadata !1473, null}
!2890 = metadata !{i32 1041, i32 0, metadata !1473, null}
!2891 = metadata !{i32 1042, i32 0, metadata !1473, null}
!2892 = metadata !{i32 1043, i32 0, metadata !1473, null}
!2893 = metadata !{i32 1046, i32 0, metadata !1473, null}
!2894 = metadata !{i32 1055, i32 0, metadata !1473, null}
!2895 = metadata !{i32 1056, i32 0, metadata !1473, null}
!2896 = metadata !{i32 1058, i32 0, metadata !1473, null}
!2897 = metadata !{i32 1059, i32 0, metadata !2898, null}
!2898 = metadata !{i32 786443, metadata !1, metadata !1473, i32 1058, i32 0, i32 53} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2899 = metadata !{i32 1060, i32 0, metadata !2898, null}
!2900 = metadata !{i32 1061, i32 0, metadata !2898, null}
!2901 = metadata !{i32 1062, i32 0, metadata !1473, null}
!2902 = metadata !{i32 1063, i32 0, metadata !2903, null}
!2903 = metadata !{i32 786443, metadata !1, metadata !1473, i32 1062, i32 0, i32 54} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2904 = metadata !{i32 1064, i32 0, metadata !2903, null}
!2905 = metadata !{i32 1065, i32 0, metadata !2903, null}
!2906 = metadata !{i32 1066, i32 0, metadata !1473, null}
!2907 = metadata !{i32 1067, i32 0, metadata !2908, null}
!2908 = metadata !{i32 786443, metadata !1, metadata !1473, i32 1066, i32 0, i32 55} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2909 = metadata !{i32 1068, i32 0, metadata !2908, null}
!2910 = metadata !{i32 1069, i32 0, metadata !2908, null}
!2911 = metadata !{i32 1070, i32 0, metadata !1473, null}
!2912 = metadata !{i32 1071, i32 0, metadata !1473, null}
!2913 = metadata !{i32 1075, i32 0, metadata !1473, null}
!2914 = metadata !{i32 1076, i32 0, metadata !1473, null}
!2915 = metadata !{i32 1077, i32 0, metadata !1473, null}
!2916 = metadata !{i32 1078, i32 0, metadata !1473, null}
!2917 = metadata !{i32 1081, i32 0, metadata !1473, null}
!2918 = metadata !{i32 1082, i32 0, metadata !1473, null}
!2919 = metadata !{i32 1083, i32 0, metadata !1473, null}
!2920 = metadata !{i32 1084, i32 0, metadata !1473, null}
!2921 = metadata !{i32 1085, i32 0, metadata !1473, null}
!2922 = metadata !{i32 1087, i32 0, metadata !1473, null}
!2923 = metadata !{i32 786689, metadata !1488, metadata !"td", metadata !1292, i32 16778318, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 1102]
!2924 = metadata !{i32 1102, i32 0, metadata !1488, null}
!2925 = metadata !{i32 786689, metadata !1488, metadata !"uap", metadata !1292, i32 33555534, metadata !1491, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 1102]
!2926 = metadata !{i32 786688, metadata !1488, metadata !"p", metadata !1292, i32 1104, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 1104]
!2927 = metadata !{i32 1104, i32 0, metadata !1488, null}
!2928 = metadata !{i32 786688, metadata !1488, metadata !"newcred", metadata !1292, i32 1105, metadata !253, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [newcred] [line 1105]
!2929 = metadata !{i32 1105, i32 0, metadata !1488, null}
!2930 = metadata !{i32 786688, metadata !1488, metadata !"oldcred", metadata !1292, i32 1105, metadata !253, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [oldcred] [line 1105]
!2931 = metadata !{i32 786688, metadata !1488, metadata !"egid", metadata !1292, i32 1106, metadata !263, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [egid] [line 1106]
!2932 = metadata !{i32 1106, i32 0, metadata !1488, null}
!2933 = metadata !{i32 786688, metadata !1488, metadata !"rgid", metadata !1292, i32 1106, metadata !263, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [rgid] [line 1106]
!2934 = metadata !{i32 786688, metadata !1488, metadata !"sgid", metadata !1292, i32 1106, metadata !263, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [sgid] [line 1106]
!2935 = metadata !{i32 786688, metadata !1488, metadata !"error", metadata !1292, i32 1107, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 1107]
!2936 = metadata !{i32 1107, i32 0, metadata !1488, null}
!2937 = metadata !{i32 1109, i32 0, metadata !1488, null}
!2938 = metadata !{i32 1110, i32 0, metadata !1488, null}
!2939 = metadata !{i32 1111, i32 0, metadata !1488, null}
!2940 = metadata !{i32 1112, i32 0, metadata !1488, null}
!2941 = metadata !{i32 1112, i32 0, metadata !2942, null}
!2942 = metadata !{i32 786443, metadata !1, metadata !1488, i32 1112, i32 0, i32 56} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2943 = metadata !{i32 1113, i32 0, metadata !1488, null}
!2944 = metadata !{i32 1113, i32 0, metadata !2945, null}
!2945 = metadata !{i32 786443, metadata !1, metadata !1488, i32 1113, i32 0, i32 57} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2946 = metadata !{i32 1114, i32 0, metadata !1488, null}
!2947 = metadata !{i32 1114, i32 0, metadata !2948, null}
!2948 = metadata !{i32 786443, metadata !1, metadata !1488, i32 1114, i32 0, i32 58} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2949 = metadata !{i32 1115, i32 0, metadata !1488, null}
!2950 = metadata !{i32 1116, i32 0, metadata !1488, null}
!2951 = metadata !{i32 1117, i32 0, metadata !1488, null}
!2952 = metadata !{i32 1120, i32 0, metadata !1488, null}
!2953 = metadata !{i32 1121, i32 0, metadata !1488, null}
!2954 = metadata !{i32 1122, i32 0, metadata !1488, null}
!2955 = metadata !{i32 1125, i32 0, metadata !1488, null}
!2956 = metadata !{i32 1134, i32 0, metadata !1488, null}
!2957 = metadata !{i32 1135, i32 0, metadata !1488, null}
!2958 = metadata !{i32 1137, i32 0, metadata !1488, null}
!2959 = metadata !{i32 1138, i32 0, metadata !2960, null}
!2960 = metadata !{i32 786443, metadata !1, metadata !1488, i32 1137, i32 0, i32 59} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2961 = metadata !{i32 1139, i32 0, metadata !2960, null}
!2962 = metadata !{i32 1140, i32 0, metadata !2960, null}
!2963 = metadata !{i32 1141, i32 0, metadata !1488, null}
!2964 = metadata !{i32 1142, i32 0, metadata !2965, null}
!2965 = metadata !{i32 786443, metadata !1, metadata !1488, i32 1141, i32 0, i32 60} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2966 = metadata !{i32 1143, i32 0, metadata !2965, null}
!2967 = metadata !{i32 1144, i32 0, metadata !2965, null}
!2968 = metadata !{i32 1145, i32 0, metadata !1488, null}
!2969 = metadata !{i32 1146, i32 0, metadata !2970, null}
!2970 = metadata !{i32 786443, metadata !1, metadata !1488, i32 1145, i32 0, i32 61} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!2971 = metadata !{i32 1147, i32 0, metadata !2970, null}
!2972 = metadata !{i32 1148, i32 0, metadata !2970, null}
!2973 = metadata !{i32 1149, i32 0, metadata !1488, null}
!2974 = metadata !{i32 1150, i32 0, metadata !1488, null}
!2975 = metadata !{i32 1151, i32 0, metadata !1488, null}
!2976 = metadata !{i32 1152, i32 0, metadata !1488, null}
!2977 = metadata !{i32 1155, i32 0, metadata !1488, null}
!2978 = metadata !{i32 1156, i32 0, metadata !1488, null}
!2979 = metadata !{i32 1157, i32 0, metadata !1488, null}
!2980 = metadata !{i32 1158, i32 0, metadata !1488, null}
!2981 = metadata !{i32 786689, metadata !1503, metadata !"td", metadata !1292, i32 16778385, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 1169]
!2982 = metadata !{i32 1169, i32 0, metadata !1503, null}
!2983 = metadata !{i32 786689, metadata !1503, metadata !"uap", metadata !1292, i32 33555601, metadata !1506, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 1169]
!2984 = metadata !{i32 786688, metadata !1503, metadata !"cred", metadata !1292, i32 1171, metadata !253, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [cred] [line 1171]
!2985 = metadata !{i32 1171, i32 0, metadata !1503, null}
!2986 = metadata !{i32 786688, metadata !1503, metadata !"error1", metadata !1292, i32 1172, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error1] [line 1172]
!2987 = metadata !{i32 1172, i32 0, metadata !1503, null}
!2988 = metadata !{i32 786688, metadata !1503, metadata !"error2", metadata !1292, i32 1172, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error2] [line 1172]
!2989 = metadata !{i32 786688, metadata !1503, metadata !"error3", metadata !1292, i32 1172, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error3] [line 1172]
!2990 = metadata !{i32 1174, i32 0, metadata !1503, null}
!2991 = metadata !{i32 1175, i32 0, metadata !1503, null}
!2992 = metadata !{i32 1176, i32 0, metadata !1503, null}
!2993 = metadata !{i32 1178, i32 0, metadata !1503, null}
!2994 = metadata !{i32 1179, i32 0, metadata !1503, null}
!2995 = metadata !{i32 1181, i32 0, metadata !1503, null}
!2996 = metadata !{i32 1182, i32 0, metadata !1503, null}
!2997 = metadata !{i32 1184, i32 0, metadata !1503, null}
!2998 = metadata !{i32 786689, metadata !1519, metadata !"td", metadata !1292, i32 16778412, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 1196]
!2999 = metadata !{i32 1196, i32 0, metadata !1519, null}
!3000 = metadata !{i32 786689, metadata !1519, metadata !"uap", metadata !1292, i32 33555628, metadata !1522, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 1196]
!3001 = metadata !{i32 786688, metadata !1519, metadata !"cred", metadata !1292, i32 1198, metadata !253, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [cred] [line 1198]
!3002 = metadata !{i32 1198, i32 0, metadata !1519, null}
!3003 = metadata !{i32 786688, metadata !1519, metadata !"error1", metadata !1292, i32 1199, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error1] [line 1199]
!3004 = metadata !{i32 1199, i32 0, metadata !1519, null}
!3005 = metadata !{i32 786688, metadata !1519, metadata !"error2", metadata !1292, i32 1199, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error2] [line 1199]
!3006 = metadata !{i32 786688, metadata !1519, metadata !"error3", metadata !1292, i32 1199, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error3] [line 1199]
!3007 = metadata !{i32 1201, i32 0, metadata !1519, null}
!3008 = metadata !{i32 1202, i32 0, metadata !1519, null}
!3009 = metadata !{i32 1203, i32 0, metadata !1519, null}
!3010 = metadata !{i32 1205, i32 0, metadata !1519, null}
!3011 = metadata !{i32 1206, i32 0, metadata !1519, null}
!3012 = metadata !{i32 1208, i32 0, metadata !1519, null}
!3013 = metadata !{i32 1209, i32 0, metadata !1519, null}
!3014 = metadata !{i32 1211, i32 0, metadata !1519, null}
!3015 = metadata !{i32 786689, metadata !1534, metadata !"td", metadata !1292, i32 16778437, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 1221]
!3016 = metadata !{i32 1221, i32 0, metadata !1534, null}
!3017 = metadata !{i32 786689, metadata !1534, metadata !"uap", metadata !1292, i32 33555653, metadata !1537, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 1221]
!3018 = metadata !{i32 786688, metadata !1534, metadata !"p", metadata !1292, i32 1223, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 1223]
!3019 = metadata !{i32 1223, i32 0, metadata !1534, null}
!3020 = metadata !{i32 1233, i32 0, metadata !1534, null}
!3021 = metadata !{i32 1234, i32 0, metadata !1534, null}
!3022 = metadata !{i32 1235, i32 0, metadata !1534, null}
!3023 = metadata !{i32 1236, i32 0, metadata !1534, null}
!3024 = metadata !{i32 786689, metadata !1541, metadata !"td", metadata !1292, i32 16778456, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 1240]
!3025 = metadata !{i32 1240, i32 0, metadata !1541, null}
!3026 = metadata !{i32 786689, metadata !1541, metadata !"uap", metadata !1292, i32 33555672, metadata !1544, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 1240]
!3027 = metadata !{i32 1262, i32 0, metadata !1541, null}
!3028 = metadata !{i32 786689, metadata !1550, metadata !"gid", metadata !1292, i32 16778486, metadata !263, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [gid] [line 1270]
!3029 = metadata !{i32 1270, i32 0, metadata !1550, null}
!3030 = metadata !{i32 786689, metadata !1550, metadata !"cred", metadata !1292, i32 33555702, metadata !253, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [cred] [line 1270]
!3031 = metadata !{i32 786688, metadata !1550, metadata !"l", metadata !1292, i32 1272, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [l] [line 1272]
!3032 = metadata !{i32 1272, i32 0, metadata !1550, null}
!3033 = metadata !{i32 786688, metadata !1550, metadata !"h", metadata !1292, i32 1273, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [h] [line 1273]
!3034 = metadata !{i32 1273, i32 0, metadata !1550, null}
!3035 = metadata !{i32 786688, metadata !1550, metadata !"m", metadata !1292, i32 1274, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [m] [line 1274]
!3036 = metadata !{i32 1274, i32 0, metadata !1550, null}
!3037 = metadata !{i32 1276, i32 0, metadata !1550, null}
!3038 = metadata !{i32 1277, i32 0, metadata !1550, null}
!3039 = metadata !{i32 1284, i32 0, metadata !1550, null}
!3040 = metadata !{i32 1285, i32 0, metadata !1550, null}
!3041 = metadata !{i32 1286, i32 0, metadata !1550, null}
!3042 = metadata !{i32 1287, i32 0, metadata !3043, null}
!3043 = metadata !{i32 786443, metadata !1, metadata !1550, i32 1286, i32 0, i32 62} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!3044 = metadata !{i32 1288, i32 0, metadata !3043, null}
!3045 = metadata !{i32 1289, i32 0, metadata !3043, null}
!3046 = metadata !{i32 1291, i32 0, metadata !3043, null}
!3047 = metadata !{i32 1292, i32 0, metadata !3043, null}
!3048 = metadata !{i32 1293, i32 0, metadata !1550, null}
!3049 = metadata !{i32 1294, i32 0, metadata !1550, null}
!3050 = metadata !{i32 1296, i32 0, metadata !1550, null}
!3051 = metadata !{i32 786689, metadata !1553, metadata !"cr", metadata !1292, i32 16778529, metadata !253, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [cr] [line 1313]
!3052 = metadata !{i32 1313, i32 0, metadata !1553, null}
!3053 = metadata !{i32 786689, metadata !1553, metadata !"level", metadata !1292, i32 33555745, metadata !93, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [level] [line 1313]
!3054 = metadata !{i32 1316, i32 0, metadata !1553, null}
!3055 = metadata !{i32 786689, metadata !1556, metadata !"cr", metadata !1292, i32 16778536, metadata !253, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [cr] [line 1320]
!3056 = metadata !{i32 1320, i32 0, metadata !1556, null}
!3057 = metadata !{i32 786689, metadata !1556, metadata !"level", metadata !1292, i32 33555752, metadata !93, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [level] [line 1320]
!3058 = metadata !{i32 1323, i32 0, metadata !1556, null}
!3059 = metadata !{i32 786689, metadata !1557, metadata !"u1", metadata !1292, i32 16778620, metadata !253, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [u1] [line 1404]
!3060 = metadata !{i32 1404, i32 0, metadata !1557, null}
!3061 = metadata !{i32 786689, metadata !1557, metadata !"u2", metadata !1292, i32 33555836, metadata !253, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [u2] [line 1404]
!3062 = metadata !{i32 786688, metadata !1557, metadata !"error", metadata !1292, i32 1406, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 1406]
!3063 = metadata !{i32 1406, i32 0, metadata !1557, null}
!3064 = metadata !{i32 1408, i32 0, metadata !1557, null}
!3065 = metadata !{i32 1409, i32 0, metadata !1557, null}
!3066 = metadata !{i32 1411, i32 0, metadata !1557, null}
!3067 = metadata !{i32 1412, i32 0, metadata !1557, null}
!3068 = metadata !{i32 1414, i32 0, metadata !1557, null}
!3069 = metadata !{i32 1415, i32 0, metadata !1557, null}
!3070 = metadata !{i32 1416, i32 0, metadata !1557, null}
!3071 = metadata !{i32 1417, i32 0, metadata !1557, null}
!3072 = metadata !{i32 1418, i32 0, metadata !1557, null}
!3073 = metadata !{i32 1419, i32 0, metadata !1557, null}
!3074 = metadata !{i32 786689, metadata !1976, metadata !"u1", metadata !1292, i32 16778562, metadata !253, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [u1] [line 1346]
!3075 = metadata !{i32 1346, i32 0, metadata !1976, null}
!3076 = metadata !{i32 786689, metadata !1976, metadata !"u2", metadata !1292, i32 33555778, metadata !253, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [u2] [line 1346]
!3077 = metadata !{i32 1349, i32 0, metadata !1976, null}
!3078 = metadata !{i32 1350, i32 0, metadata !3079, null}
!3079 = metadata !{i32 786443, metadata !1, metadata !1976, i32 1349, i32 0, i32 96} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!3080 = metadata !{i32 1351, i32 0, metadata !3079, null}
!3081 = metadata !{i32 1352, i32 0, metadata !3079, null}
!3082 = metadata !{i32 1353, i32 0, metadata !1976, null}
!3083 = metadata !{i32 786689, metadata !1975, metadata !"u1", metadata !1292, i32 16778592, metadata !253, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [u1] [line 1376]
!3084 = metadata !{i32 1376, i32 0, metadata !1975, null}
!3085 = metadata !{i32 786689, metadata !1975, metadata !"u2", metadata !1292, i32 33555808, metadata !253, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [u2] [line 1376]
!3086 = metadata !{i32 786688, metadata !3087, metadata !"i", metadata !1292, i32 1378, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 1378]
!3087 = metadata !{i32 786443, metadata !1, metadata !1975} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!3088 = metadata !{i32 1378, i32 0, metadata !3087, null}
!3089 = metadata !{i32 786688, metadata !3087, metadata !"match", metadata !1292, i32 1378, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [match] [line 1378]
!3090 = metadata !{i32 1380, i32 0, metadata !3087, null}
!3091 = metadata !{i32 1381, i32 0, metadata !3092, null}
!3092 = metadata !{i32 786443, metadata !1, metadata !3087, i32 1380, i32 0, i32 92} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!3093 = metadata !{i32 1382, i32 0, metadata !3094, null}
!3094 = metadata !{i32 786443, metadata !1, metadata !3092, i32 1382, i32 0, i32 93} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!3095 = metadata !{i32 1383, i32 0, metadata !3096, null}
!3096 = metadata !{i32 786443, metadata !1, metadata !3094, i32 1382, i32 0, i32 94} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!3097 = metadata !{i32 1384, i32 0, metadata !3096, null}
!3098 = metadata !{i32 1385, i32 0, metadata !3096, null}
!3099 = metadata !{i32 1386, i32 0, metadata !3096, null}
!3100 = metadata !{i32 1387, i32 0, metadata !3096, null}
!3101 = metadata !{i32 1388, i32 0, metadata !3092, null}
!3102 = metadata !{i32 1389, i32 0, metadata !3103, null}
!3103 = metadata !{i32 786443, metadata !1, metadata !3092, i32 1388, i32 0, i32 95} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!3104 = metadata !{i32 1390, i32 0, metadata !3103, null}
!3105 = metadata !{i32 1391, i32 0, metadata !3103, null}
!3106 = metadata !{i32 1392, i32 0, metadata !3092, null}
!3107 = metadata !{i32 1393, i32 0, metadata !3087, null}
!3108 = metadata !{i32 786689, metadata !1563, metadata !"cred", metadata !1292, i32 16778675, metadata !253, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [cred] [line 1459]
!3109 = metadata !{i32 1459, i32 0, metadata !1563, null}
!3110 = metadata !{i32 786689, metadata !1563, metadata !"proc", metadata !1292, i32 33555891, metadata !11, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [proc] [line 1459]
!3111 = metadata !{i32 786689, metadata !1563, metadata !"signum", metadata !1292, i32 50333107, metadata !93, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [signum] [line 1459]
!3112 = metadata !{i32 786688, metadata !1563, metadata !"error", metadata !1292, i32 1461, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 1461]
!3113 = metadata !{i32 1461, i32 0, metadata !1563, null}
!3114 = metadata !{i32 1463, i32 0, metadata !1563, null}
!3115 = metadata !{i32 1468, i32 0, metadata !1563, null}
!3116 = metadata !{i32 1469, i32 0, metadata !1563, null}
!3117 = metadata !{i32 1470, i32 0, metadata !1563, null}
!3118 = metadata !{i32 1472, i32 0, metadata !1563, null}
!3119 = metadata !{i32 1473, i32 0, metadata !1563, null}
!3120 = metadata !{i32 1475, i32 0, metadata !1563, null}
!3121 = metadata !{i32 1476, i32 0, metadata !1563, null}
!3122 = metadata !{i32 1477, i32 0, metadata !1563, null}
!3123 = metadata !{i32 1478, i32 0, metadata !1563, null}
!3124 = metadata !{i32 1485, i32 0, metadata !1563, null}
!3125 = metadata !{i32 1486, i32 0, metadata !3126, null}
!3126 = metadata !{i32 786443, metadata !1, metadata !1563, i32 1485, i32 0, i32 64} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!3127 = metadata !{i32 1503, i32 0, metadata !3128, null}
!3128 = metadata !{i32 786443, metadata !1, metadata !3126, i32 1486, i32 0, i32 65} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!3129 = metadata !{i32 1506, i32 0, metadata !3128, null}
!3130 = metadata !{i32 1507, i32 0, metadata !3128, null}
!3131 = metadata !{i32 1508, i32 0, metadata !3128, null}
!3132 = metadata !{i32 1509, i32 0, metadata !3128, null}
!3133 = metadata !{i32 1510, i32 0, metadata !3126, null}
!3134 = metadata !{i32 1516, i32 0, metadata !1563, null}
!3135 = metadata !{i32 1520, i32 0, metadata !3136, null}
!3136 = metadata !{i32 786443, metadata !1, metadata !1563, i32 1519, i32 0, i32 66} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!3137 = metadata !{i32 1521, i32 0, metadata !3136, null}
!3138 = metadata !{i32 1522, i32 0, metadata !3136, null}
!3139 = metadata !{i32 1523, i32 0, metadata !3136, null}
!3140 = metadata !{i32 1525, i32 0, metadata !1563, null}
!3141 = metadata !{i32 1526, i32 0, metadata !1563, null}
!3142 = metadata !{i32 786689, metadata !1566, metadata !"td", metadata !1292, i32 16778753, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 1537]
!3143 = metadata !{i32 1537, i32 0, metadata !1566, null}
!3144 = metadata !{i32 786689, metadata !1566, metadata !"p", metadata !1292, i32 33555969, metadata !11, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [p] [line 1537]
!3145 = metadata !{i32 786689, metadata !1566, metadata !"signum", metadata !1292, i32 50333185, metadata !93, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [signum] [line 1537]
!3146 = metadata !{i32 1540, i32 0, metadata !1566, null}
!3147 = metadata !{i32 1540, i32 0, metadata !3148, null}
!3148 = metadata !{i32 786443, metadata !1, metadata !1566, i32 1540, i32 0, i32 67} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!3149 = metadata !{i32 1541, i32 0, metadata !1566, null}
!3150 = metadata !{i32 1542, i32 0, metadata !1566, null}
!3151 = metadata !{i32 1543, i32 0, metadata !1566, null}
!3152 = metadata !{i32 1551, i32 0, metadata !1566, null}
!3153 = metadata !{i32 1552, i32 0, metadata !1566, null}
!3154 = metadata !{i32 1562, i32 0, metadata !1566, null}
!3155 = metadata !{i32 1564, i32 0, metadata !1566, null}
!3156 = metadata !{i32 1566, i32 0, metadata !1566, null}
!3157 = metadata !{i32 1567, i32 0, metadata !1566, null}
!3158 = metadata !{i32 786689, metadata !1569, metadata !"td", metadata !1292, i32 16778794, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 1578]
!3159 = metadata !{i32 1578, i32 0, metadata !1569, null}
!3160 = metadata !{i32 786689, metadata !1569, metadata !"p", metadata !1292, i32 33556010, metadata !11, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [p] [line 1578]
!3161 = metadata !{i32 786688, metadata !1569, metadata !"error", metadata !1292, i32 1580, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 1580]
!3162 = metadata !{i32 1580, i32 0, metadata !1569, null}
!3163 = metadata !{i32 1582, i32 0, metadata !1569, null}
!3164 = metadata !{i32 1582, i32 0, metadata !3165, null}
!3165 = metadata !{i32 786443, metadata !1, metadata !1569, i32 1582, i32 0, i32 68} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!3166 = metadata !{i32 1583, i32 0, metadata !1569, null}
!3167 = metadata !{i32 1584, i32 0, metadata !1569, null}
!3168 = metadata !{i32 1585, i32 0, metadata !1569, null}
!3169 = metadata !{i32 1586, i32 0, metadata !1569, null}
!3170 = metadata !{i32 1587, i32 0, metadata !1569, null}
!3171 = metadata !{i32 1589, i32 0, metadata !1569, null}
!3172 = metadata !{i32 1590, i32 0, metadata !1569, null}
!3173 = metadata !{i32 1592, i32 0, metadata !1569, null}
!3174 = metadata !{i32 1593, i32 0, metadata !1569, null}
!3175 = metadata !{i32 1594, i32 0, metadata !1569, null}
!3176 = metadata !{i32 1595, i32 0, metadata !1569, null}
!3177 = metadata !{i32 1596, i32 0, metadata !1569, null}
!3178 = metadata !{i32 1598, i32 0, metadata !3179, null}
!3179 = metadata !{i32 786443, metadata !1, metadata !1569, i32 1597, i32 0, i32 69} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!3180 = metadata !{i32 1599, i32 0, metadata !3179, null}
!3181 = metadata !{i32 1600, i32 0, metadata !3179, null}
!3182 = metadata !{i32 1601, i32 0, metadata !3179, null}
!3183 = metadata !{i32 1602, i32 0, metadata !1569, null}
!3184 = metadata !{i32 1603, i32 0, metadata !1569, null}
!3185 = metadata !{i32 786689, metadata !1570, metadata !"td", metadata !1292, i32 16778846, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 1630]
!3186 = metadata !{i32 1630, i32 0, metadata !1570, null}
!3187 = metadata !{i32 786689, metadata !1570, metadata !"p", metadata !1292, i32 33556062, metadata !11, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [p] [line 1630]
!3188 = metadata !{i32 786688, metadata !1570, metadata !"credentialchanged", metadata !1292, i32 1632, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [credentialchanged] [line 1632]
!3189 = metadata !{i32 1632, i32 0, metadata !1570, null}
!3190 = metadata !{i32 786688, metadata !1570, metadata !"error", metadata !1292, i32 1632, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 1632]
!3191 = metadata !{i32 786688, metadata !1570, metadata !"grpsubset", metadata !1292, i32 1632, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [grpsubset] [line 1632]
!3192 = metadata !{i32 786688, metadata !1570, metadata !"i", metadata !1292, i32 1632, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 1632]
!3193 = metadata !{i32 786688, metadata !1570, metadata !"uidsubset", metadata !1292, i32 1632, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [uidsubset] [line 1632]
!3194 = metadata !{i32 1634, i32 0, metadata !1570, null}
!3195 = metadata !{i32 1634, i32 0, metadata !3196, null}
!3196 = metadata !{i32 786443, metadata !1, metadata !1570, i32 1634, i32 0, i32 70} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!3197 = metadata !{i32 1635, i32 0, metadata !1570, null}
!3198 = metadata !{i32 1636, i32 0, metadata !1570, null}
!3199 = metadata !{i32 1637, i32 0, metadata !3200, null}
!3200 = metadata !{i32 786443, metadata !1, metadata !1570, i32 1636, i32 0, i32 71} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!3201 = metadata !{i32 1638, i32 0, metadata !3200, null}
!3202 = metadata !{i32 1639, i32 0, metadata !3200, null}
!3203 = metadata !{i32 1640, i32 0, metadata !3200, null}
!3204 = metadata !{i32 1641, i32 0, metadata !1570, null}
!3205 = metadata !{i32 1642, i32 0, metadata !1570, null}
!3206 = metadata !{i32 1643, i32 0, metadata !1570, null}
!3207 = metadata !{i32 1644, i32 0, metadata !1570, null}
!3208 = metadata !{i32 1646, i32 0, metadata !1570, null}
!3209 = metadata !{i32 1647, i32 0, metadata !1570, null}
!3210 = metadata !{i32 1649, i32 0, metadata !1570, null}
!3211 = metadata !{i32 1650, i32 0, metadata !1570, null}
!3212 = metadata !{i32 1651, i32 0, metadata !1570, null}
!3213 = metadata !{i32 1652, i32 0, metadata !1570, null}
!3214 = metadata !{i32 1658, i32 0, metadata !1570, null}
!3215 = metadata !{i32 1659, i32 0, metadata !3216, null}
!3216 = metadata !{i32 786443, metadata !1, metadata !1570, i32 1659, i32 0, i32 72} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!3217 = metadata !{i32 1660, i32 0, metadata !3218, null}
!3218 = metadata !{i32 786443, metadata !1, metadata !3216, i32 1659, i32 0, i32 73} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!3219 = metadata !{i32 1661, i32 0, metadata !3220, null}
!3220 = metadata !{i32 786443, metadata !1, metadata !3218, i32 1660, i32 0, i32 74} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!3221 = metadata !{i32 1662, i32 0, metadata !3220, null}
!3222 = metadata !{i32 1664, i32 0, metadata !3218, null}
!3223 = metadata !{i32 1665, i32 0, metadata !1570, null}
!3224 = metadata !{i32 1666, i32 0, metadata !1570, null}
!3225 = metadata !{i32 1667, i32 0, metadata !1570, null}
!3226 = metadata !{i32 1673, i32 0, metadata !1570, null}
!3227 = metadata !{i32 1680, i32 0, metadata !1570, null}
!3228 = metadata !{i32 1687, i32 0, metadata !1570, null}
!3229 = metadata !{i32 1688, i32 0, metadata !3230, null}
!3230 = metadata !{i32 786443, metadata !1, metadata !1570, i32 1687, i32 0, i32 75} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!3231 = metadata !{i32 1689, i32 0, metadata !3230, null}
!3232 = metadata !{i32 1690, i32 0, metadata !3230, null}
!3233 = metadata !{i32 1691, i32 0, metadata !3230, null}
!3234 = metadata !{i32 1693, i32 0, metadata !1570, null}
!3235 = metadata !{i32 1694, i32 0, metadata !3236, null}
!3236 = metadata !{i32 786443, metadata !1, metadata !1570, i32 1693, i32 0, i32 76} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!3237 = metadata !{i32 1695, i32 0, metadata !3236, null}
!3238 = metadata !{i32 1696, i32 0, metadata !3236, null}
!3239 = metadata !{i32 1697, i32 0, metadata !3236, null}
!3240 = metadata !{i32 1700, i32 0, metadata !1570, null}
!3241 = metadata !{i32 1701, i32 0, metadata !3242, null}
!3242 = metadata !{i32 786443, metadata !1, metadata !1570, i32 1700, i32 0, i32 77} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!3243 = metadata !{i32 1702, i32 0, metadata !3242, null}
!3244 = metadata !{i32 1703, i32 0, metadata !3242, null}
!3245 = metadata !{i32 1704, i32 0, metadata !3242, null}
!3246 = metadata !{i32 1713, i32 0, metadata !1570, null}
!3247 = metadata !{i32 1714, i32 0, metadata !1570, null}
!3248 = metadata !{i32 1716, i32 0, metadata !1570, null}
!3249 = metadata !{i32 1717, i32 0, metadata !1570, null}
!3250 = metadata !{i32 786689, metadata !1571, metadata !"cred", metadata !1292, i32 16778940, metadata !253, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [cred] [line 1724]
!3251 = metadata !{i32 1724, i32 0, metadata !1571, null}
!3252 = metadata !{i32 786689, metadata !1571, metadata !"so", metadata !1292, i32 33556156, metadata !1574, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [so] [line 1724]
!3253 = metadata !{i32 786688, metadata !1571, metadata !"error", metadata !1292, i32 1726, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 1726]
!3254 = metadata !{i32 1726, i32 0, metadata !1571, null}
!3255 = metadata !{i32 1728, i32 0, metadata !1571, null}
!3256 = metadata !{i32 1729, i32 0, metadata !1571, null}
!3257 = metadata !{i32 1730, i32 0, metadata !1571, null}
!3258 = metadata !{i32 1732, i32 0, metadata !1571, null}
!3259 = metadata !{i32 1733, i32 0, metadata !1571, null}
!3260 = metadata !{i32 1734, i32 0, metadata !1571, null}
!3261 = metadata !{i32 1736, i32 0, metadata !1571, null}
!3262 = metadata !{i32 1737, i32 0, metadata !1571, null}
!3263 = metadata !{i32 1738, i32 0, metadata !1571, null}
!3264 = metadata !{i32 1739, i32 0, metadata !1571, null}
!3265 = metadata !{i32 1741, i32 0, metadata !1571, null}
!3266 = metadata !{i32 1742, i32 0, metadata !1571, null}
!3267 = metadata !{i32 786689, metadata !1703, metadata !"cred", metadata !1292, i32 16778966, metadata !253, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [cred] [line 1750]
!3268 = metadata !{i32 1750, i32 0, metadata !1703, null}
!3269 = metadata !{i32 786689, metadata !1703, metadata !"inp", metadata !1292, i32 33556182, metadata !1706, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [inp] [line 1750]
!3270 = metadata !{i32 786688, metadata !1703, metadata !"error", metadata !1292, i32 1752, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 1752]
!3271 = metadata !{i32 1752, i32 0, metadata !1703, null}
!3272 = metadata !{i32 1754, i32 0, metadata !1703, null}
!3273 = metadata !{i32 1755, i32 0, metadata !1703, null}
!3274 = metadata !{i32 1756, i32 0, metadata !1703, null}
!3275 = metadata !{i32 1758, i32 0, metadata !1703, null}
!3276 = metadata !{i32 1759, i32 0, metadata !1703, null}
!3277 = metadata !{i32 1760, i32 0, metadata !1703, null}
!3278 = metadata !{i32 1761, i32 0, metadata !1703, null}
!3279 = metadata !{i32 1763, i32 0, metadata !1703, null}
!3280 = metadata !{i32 1764, i32 0, metadata !1703, null}
!3281 = metadata !{i32 1765, i32 0, metadata !1703, null}
!3282 = metadata !{i32 1766, i32 0, metadata !1703, null}
!3283 = metadata !{i32 1768, i32 0, metadata !1703, null}
!3284 = metadata !{i32 1769, i32 0, metadata !1703, null}
!3285 = metadata !{i32 786689, metadata !1879, metadata !"td", metadata !1292, i32 16778998, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 1782]
!3286 = metadata !{i32 1782, i32 0, metadata !1879, null}
!3287 = metadata !{i32 786689, metadata !1879, metadata !"p", metadata !1292, i32 33556214, metadata !11, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [p] [line 1782]
!3288 = metadata !{i32 786688, metadata !1879, metadata !"error", metadata !1292, i32 1784, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 1784]
!3289 = metadata !{i32 1784, i32 0, metadata !1879, null}
!3290 = metadata !{i32 1786, i32 0, metadata !1879, null}
!3291 = metadata !{i32 1786, i32 0, metadata !3292, null}
!3292 = metadata !{i32 786443, metadata !1, metadata !1879, i32 1786, i32 0, i32 78} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!3293 = metadata !{i32 1787, i32 0, metadata !1879, null}
!3294 = metadata !{i32 1788, i32 0, metadata !1879, null}
!3295 = metadata !{i32 1789, i32 0, metadata !1879, null}
!3296 = metadata !{i32 1791, i32 0, metadata !1879, null}
!3297 = metadata !{i32 1792, i32 0, metadata !1879, null}
!3298 = metadata !{i32 1800, i32 0, metadata !1879, null}
!3299 = metadata !{i32 1801, i32 0, metadata !1879, null}
!3300 = metadata !{i32 786689, metadata !1974, metadata !"count", metadata !1959, i32 16777261, metadata !1962, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [count] [line 45]
!3301 = metadata !{i32 45, i32 0, metadata !1974, null}
!3302 = metadata !{i32 786689, metadata !1974, metadata !"value", metadata !1959, i32 33554477, metadata !36, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [value] [line 45]
!3303 = metadata !{i32 48, i32 0, metadata !3304, null}
!3304 = metadata !{i32 786443, metadata !1958, metadata !1974} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/refcount.h]
!3305 = metadata !{i32 49, i32 0, metadata !3304, null}
!3306 = metadata !{i32 786689, metadata !1883, metadata !"cr", metadata !1292, i32 16779043, metadata !253, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [cr] [line 1827]
!3307 = metadata !{i32 1827, i32 0, metadata !1883, null}
!3308 = metadata !{i32 1830, i32 0, metadata !1883, null}
!3309 = metadata !{i32 1831, i32 0, metadata !1883, null}
!3310 = metadata !{i32 786689, metadata !1968, metadata !"count", metadata !1959, i32 16777268, metadata !1962, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [count] [line 52]
!3311 = metadata !{i32 52, i32 0, metadata !1968, null}
!3312 = metadata !{i32 55, i32 0, metadata !3313, null}
!3313 = metadata !{i32 786443, metadata !1958, metadata !1968} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/refcount.h]
!3314 = metadata !{i32 55, i32 0, metadata !3315, null}
!3315 = metadata !{i32 786443, metadata !1958, metadata !3313, i32 55, i32 0, i32 91} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/refcount.h]
!3316 = metadata !{i32 56, i32 0, metadata !3313, null}
!3317 = metadata !{i32 57, i32 0, metadata !3313, null}
!3318 = metadata !{i32 786689, metadata !1957, metadata !"count", metadata !1959, i32 16777276, metadata !1962, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [count] [line 60]
!3319 = metadata !{i32 60, i32 0, metadata !1957, null}
!3320 = metadata !{i32 786688, metadata !3321, metadata !"old", metadata !1959, i32 62, metadata !36, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [old] [line 62]
!3321 = metadata !{i32 786443, metadata !1958, metadata !1957} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/refcount.h]
!3322 = metadata !{i32 62, i32 0, metadata !3321, null}
!3323 = metadata !{i32 65, i32 8, metadata !3321, null}
!3324 = metadata !{i32 66, i32 0, metadata !3321, null}
!3325 = metadata !{i32 66, i32 0, metadata !3326, null}
!3326 = metadata !{i32 786443, metadata !1958, metadata !3321, i32 66, i32 0, i32 90} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/sys/refcount.h]
!3327 = metadata !{i32 67, i32 0, metadata !3321, null}
!3328 = metadata !{i32 786689, metadata !1889, metadata !"cr", metadata !1292, i32 16779091, metadata !253, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [cr] [line 1875]
!3329 = metadata !{i32 1875, i32 0, metadata !1889, null}
!3330 = metadata !{i32 1878, i32 0, metadata !1889, null}
!3331 = metadata !{i32 786689, metadata !1892, metadata !"dest", metadata !1292, i32 16779101, metadata !253, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [dest] [line 1885]
!3332 = metadata !{i32 1885, i32 0, metadata !1892, null}
!3333 = metadata !{i32 786689, metadata !1892, metadata !"src", metadata !1292, i32 33556317, metadata !253, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [src] [line 1885]
!3334 = metadata !{i32 1888, i32 0, metadata !1892, null}
!3335 = metadata !{i32 1888, i32 0, metadata !3336, null}
!3336 = metadata !{i32 786443, metadata !1, metadata !1892, i32 1888, i32 0, i32 82} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!3337 = metadata !{i32 1889, i32 0, metadata !1892, null}
!3338 = metadata !{i32 1892, i32 0, metadata !1892, null}
!3339 = metadata !{i32 1893, i32 0, metadata !1892, null}
!3340 = metadata !{i32 1894, i32 0, metadata !1892, null}
!3341 = metadata !{i32 1895, i32 0, metadata !1892, null}
!3342 = metadata !{i32 1896, i32 0, metadata !1892, null}
!3343 = metadata !{i32 1898, i32 0, metadata !1892, null}
!3344 = metadata !{i32 1901, i32 0, metadata !1892, null}
!3345 = metadata !{i32 1903, i32 0, metadata !1892, null}
!3346 = metadata !{i32 786689, metadata !1914, metadata !"cr", metadata !1292, i32 16779271, metadata !253, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [cr] [line 2055]
!3347 = metadata !{i32 2055, i32 0, metadata !1914, null}
!3348 = metadata !{i32 786689, metadata !1914, metadata !"ngrp", metadata !1292, i32 33556487, metadata !93, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [ngrp] [line 2055]
!3349 = metadata !{i32 786689, metadata !1914, metadata !"groups", metadata !1292, i32 50333703, metadata !509, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [groups] [line 2055]
!3350 = metadata !{i32 2058, i32 0, metadata !1914, null}
!3351 = metadata !{i32 2059, i32 0, metadata !1914, null}
!3352 = metadata !{i32 2061, i32 0, metadata !1914, null}
!3353 = metadata !{i32 2062, i32 0, metadata !1914, null}
!3354 = metadata !{i32 2063, i32 0, metadata !1914, null}
!3355 = metadata !{i32 786689, metadata !1895, metadata !"cr", metadata !1292, i32 16779125, metadata !253, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [cr] [line 1909]
!3356 = metadata !{i32 1909, i32 0, metadata !1895, null}
!3357 = metadata !{i32 786688, metadata !1895, metadata !"newcr", metadata !1292, i32 1911, metadata !253, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [newcr] [line 1911]
!3358 = metadata !{i32 1911, i32 0, metadata !1895, null}
!3359 = metadata !{i32 1913, i32 0, metadata !1895, null}
!3360 = metadata !{i32 1914, i32 0, metadata !1895, null}
!3361 = metadata !{i32 1915, i32 0, metadata !1895, null}
!3362 = metadata !{i32 786689, metadata !1896, metadata !"cr", metadata !1292, i32 16779138, metadata !253, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [cr] [line 1922]
!3363 = metadata !{i32 1922, i32 0, metadata !1896, null}
!3364 = metadata !{i32 786689, metadata !1896, metadata !"xcr", metadata !1292, i32 33556354, metadata !1899, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [xcr] [line 1922]
!3365 = metadata !{i32 786688, metadata !1896, metadata !"ngroups", metadata !1292, i32 1924, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [ngroups] [line 1924]
!3366 = metadata !{i32 1924, i32 0, metadata !1896, null}
!3367 = metadata !{i32 1926, i32 0, metadata !1896, null}
!3368 = metadata !{i32 1927, i32 0, metadata !1896, null}
!3369 = metadata !{i32 1928, i32 0, metadata !1896, null}
!3370 = metadata !{i32 1930, i32 0, metadata !1896, null}
!3371 = metadata !{i32 1931, i32 0, metadata !1896, null}
!3372 = metadata !{i32 1932, i32 0, metadata !1896, null}
!3373 = metadata !{i32 1934, i32 0, metadata !1896, null}
!3374 = metadata !{i32 786689, metadata !1908, metadata !"td", metadata !1292, i32 16779157, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 1941]
!3375 = metadata !{i32 1941, i32 0, metadata !1908, null}
!3376 = metadata !{i32 786688, metadata !1908, metadata !"p", metadata !1292, i32 1943, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 1943]
!3377 = metadata !{i32 1943, i32 0, metadata !1908, null}
!3378 = metadata !{i32 786688, metadata !1908, metadata !"cred", metadata !1292, i32 1944, metadata !253, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [cred] [line 1944]
!3379 = metadata !{i32 1944, i32 0, metadata !1908, null}
!3380 = metadata !{i32 1946, i32 0, metadata !1908, null}
!3381 = metadata !{i32 1947, i32 0, metadata !1908, null}
!3382 = metadata !{i32 1948, i32 0, metadata !1908, null}
!3383 = metadata !{i32 1949, i32 0, metadata !1908, null}
!3384 = metadata !{i32 1950, i32 0, metadata !1908, null}
!3385 = metadata !{i32 1951, i32 0, metadata !1908, null}
!3386 = metadata !{i32 1952, i32 0, metadata !1908, null}
!3387 = metadata !{i32 1953, i32 0, metadata !1908, null}
!3388 = metadata !{i32 786689, metadata !1917, metadata !"td", metadata !1292, i32 16779292, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 2076]
!3389 = metadata !{i32 2076, i32 0, metadata !1917, null}
!3390 = metadata !{i32 786689, metadata !1917, metadata !"uap", metadata !1292, i32 33556508, metadata !1920, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 2076]
!3391 = metadata !{i32 786688, metadata !1917, metadata !"error", metadata !1292, i32 2078, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 2078]
!3392 = metadata !{i32 2078, i32 0, metadata !1917, null}
!3393 = metadata !{i32 786688, metadata !1917, metadata !"login", metadata !1292, i32 2079, metadata !467, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [login] [line 2079]
!3394 = metadata !{i32 2079, i32 0, metadata !1917, null}
!3395 = metadata !{i32 786688, metadata !1917, metadata !"p", metadata !1292, i32 2080, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 2080]
!3396 = metadata !{i32 2080, i32 0, metadata !1917, null}
!3397 = metadata !{i32 2082, i32 0, metadata !1917, null}
!3398 = metadata !{i32 2083, i32 0, metadata !1917, null}
!3399 = metadata !{i32 2084, i32 0, metadata !1917, null}
!3400 = metadata !{i32 2085, i32 0, metadata !1917, null}
!3401 = metadata !{i32 2086, i32 0, metadata !1917, null}
!3402 = metadata !{i32 2087, i32 0, metadata !1917, null}
!3403 = metadata !{i32 2088, i32 0, metadata !1917, null}
!3404 = metadata !{i32 2089, i32 0, metadata !1917, null}
!3405 = metadata !{i32 2090, i32 0, metadata !1917, null}
!3406 = metadata !{i32 2091, i32 0, metadata !1917, null}
!3407 = metadata !{i32 2092, i32 0, metadata !1917, null}
!3408 = metadata !{i32 2093, i32 0, metadata !1917, null}
!3409 = metadata !{i32 786689, metadata !1929, metadata !"td", metadata !1292, i32 16779321, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 2105]
!3410 = metadata !{i32 2105, i32 0, metadata !1929, null}
!3411 = metadata !{i32 786689, metadata !1929, metadata !"uap", metadata !1292, i32 33556537, metadata !1932, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 2105]
!3412 = metadata !{i32 786688, metadata !1929, metadata !"p", metadata !1292, i32 2107, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 2107]
!3413 = metadata !{i32 2107, i32 0, metadata !1929, null}
!3414 = metadata !{i32 786688, metadata !1929, metadata !"error", metadata !1292, i32 2108, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 2108]
!3415 = metadata !{i32 2108, i32 0, metadata !1929, null}
!3416 = metadata !{i32 786688, metadata !1929, metadata !"logintmp", metadata !1292, i32 2109, metadata !467, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [logintmp] [line 2109]
!3417 = metadata !{i32 2109, i32 0, metadata !1929, null}
!3418 = metadata !{i32 2111, i32 0, metadata !1929, null}
!3419 = metadata !{i32 2112, i32 0, metadata !1929, null}
!3420 = metadata !{i32 2113, i32 0, metadata !1929, null}
!3421 = metadata !{i32 2114, i32 0, metadata !1929, null}
!3422 = metadata !{i32 2115, i32 0, metadata !1929, null}
!3423 = metadata !{i32 2116, i32 0, metadata !1929, null}
!3424 = metadata !{i32 2117, i32 0, metadata !1929, null}
!3425 = metadata !{i32 2118, i32 0, metadata !3426, null}
!3426 = metadata !{i32 786443, metadata !1, metadata !1929, i32 2117, i32 0, i32 84} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA//usr/home/robert/p4/projects/ctsrd/tesla/src/sys/kern/kern_prot.c]
!3427 = metadata !{i32 2119, i32 0, metadata !3426, null}
!3428 = metadata !{i32 2120, i32 0, metadata !3426, null}
!3429 = metadata !{i32 2122, i32 0, metadata !3426, null}
!3430 = metadata !{i32 2123, i32 0, metadata !3426, null}
!3431 = metadata !{i32 2124, i32 0, metadata !3426, null}
!3432 = metadata !{i32 2125, i32 0, metadata !1929, null}
!3433 = metadata !{i32 2126, i32 0, metadata !1929, null}
!3434 = metadata !{i32 786689, metadata !1963, metadata !"p", metadata !1965, i32 16777397, metadata !1962, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [p] [line 181]
!3435 = metadata !{i32 181, i32 0, metadata !1963, null}
!3436 = metadata !{i32 786689, metadata !1963, metadata !"v", metadata !1965, i32 33554613, metadata !36, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [v] [line 181]
!3437 = metadata !{i32 184, i32 0, metadata !3438, null}
!3438 = metadata !{i32 786443, metadata !1964, metadata !1963} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA/./machine/atomic.h]
!3439 = metadata !{i32 203985}
!3440 = metadata !{i32 192, i32 0, metadata !3438, null}
!3441 = metadata !{i32 786689, metadata !1971, metadata !"p", metadata !1965, i32 16777498, metadata !1962, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [p] [line 282]
!3442 = metadata !{i32 282, i32 0, metadata !1971, null}
!3443 = metadata !{i32 786689, metadata !1971, metadata !"v", metadata !1965, i32 33554714, metadata !36, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [v] [line 282]
!3444 = metadata !{i32 282, i32 0, metadata !3445, null}
!3445 = metadata !{i32 786443, metadata !1964, metadata !1971} ; [ DW_TAG_lexical_block ] [/usr/obj/usr/home/robert/p4/projects/ctsrd/tesla/src/sys/TESLA/./machine/atomic.h]
!3446 = metadata !{i32 -2147262600}
