; ModuleID = '/home/jra40/P4/tesla/sys/kern/kern_cpuset.c'
; RUN: tesla instrument %s -tesla-manifest %p/Inputs/kern_cpuset.tesla -o %t
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-freebsd10.0"

module asm ".ident\09\22$FreeBSD: head/sys/kern/kern_cpuset.c 239923 2012-08-30 21:22:47Z attilio $\22"
module asm ".globl __start_set_pcpu"
module asm ".globl __stop_set_pcpu"
module asm ".globl __start_set_sysctl_set"
module asm ".globl __stop_set_sysctl_set"
module asm ".globl __start_set_sysinit_set"
module asm ".globl __stop_set_sysinit_set"
module asm ".globl __start_set_sysinit_set"
module asm ".globl __stop_set_sysinit_set"
module asm ".globl __start_set_sysuninit_set"
module asm ".globl __stop_set_sysuninit_set"

%struct.sysctl_oid = type { %struct.sysctl_oid_list*, %struct.anon, i32, i32, i8*, i64, i8*, i32 (%struct.sysctl_oid*, i8*, i64, %struct.sysctl_req*)*, i8*, i32, i32, i8* }
%struct.sysctl_oid_list = type { %struct.sysctl_oid* }
%struct.anon = type { %struct.sysctl_oid* }
%struct.sysctl_req = type { %struct.thread*, i32, i8*, i64, i64, i32 (%struct.sysctl_req*, i8*, i64)*, i8*, i64, i64, i32 (%struct.sysctl_req*, i8*, i64)*, i64, i32 }
%struct.thread = type { %struct.mtx*, %struct.proc*, %struct.anon.35, %struct.anon.36, %struct.anon.37, %struct.anon.38, %struct.anon.39, %struct.cpuset*, %struct.seltd*, %struct.sleepqueue*, %struct.turnstile*, %struct.rl_q_entry*, %struct.umtx_q*, i32, %struct.sigqueue, i8, i32, i32, i32, i32, i32, i8*, i8*, i8, i8, i8, i8, i16, i16, i16, i16, %struct.turnstile*, i8*, %struct.anon.40, %struct.lock_list_entry*, i32, i32, %struct.ucred*, i32, i32, i32, i32, i32, %struct.rusage, %struct.rusage_ext, i64, i64, i32, i32, i32, i32, i32, %struct.__sigset, i32, %struct.sigaltstack, i32, i64, i32, [20 x i8], %struct.file*, i32, %struct.ksiginfo, i32, %struct.osd, %struct.vm_map_entry*, i32, i32, i32, i32, %struct.__sigset, i8, i8, i8, i8, i8, i8, %struct.pcb*, i32, [2 x i64], %struct.callout, %struct.trapframe*, %struct.vm_object*, i64, i32, i32, %struct.mdthread, %struct.td_sched*, %struct.kaudit_record*, [2 x %struct.lpohead], %struct.kdtrace_thread*, i32, %struct.vnet*, i8*, %struct.trapframe*, %struct.proc*, %struct.vm_page**, i32, %struct.tesla_store* }
%struct.mtx = type { %struct.lock_object, i64 }
%struct.lock_object = type { i8*, i32, i32, %struct.witness* }
%struct.witness = type opaque
%struct.proc = type { %struct.anon.0, %struct.anon.1, %struct.mtx, %struct.ucred*, %struct.filedesc*, %struct.filedesc_to_leader*, %struct.pstats*, %struct.plimit*, %struct.callout, %struct.sigacts*, i32, i32, i32, %struct.anon.13, %struct.anon.14, %struct.proc*, %struct.anon.15, %struct.anon.16, %struct.mtx, %struct.ksiginfo*, %struct.sigqueue, i32, %struct.vmspace*, i32, %struct.itimerval, %struct.rusage, %struct.rusage_ext, %struct.rusage_ext, i32, i32, i32, %struct.vnode*, %struct.ucred*, %struct.vnode*, i32, %struct.sigiolst, i32, i32, i64, i32, i32, i8, i8, %struct.nlminfo*, %struct.kaioinfo*, %struct.thread*, i32, %struct.thread*, i32, i32, %struct.itimers*, %struct.procdesc*, i32, i32, [20 x i8], %struct.pgrp*, %struct.sysentvec*, %struct.pargs*, i64, i8, i32, i16, %struct.knlist, i32, %struct.mdproc, %struct.callout, i16, %struct.proc*, %struct.proc*, i8*, %struct.label*, %struct.p_sched*, %struct.anon.31, %struct.anon.32, %struct.kdtrace_proc*, %struct.cv, %struct.cv, i64, %struct.racct*, i8, %struct.anon.33, %struct.anon.34 }
%struct.anon.0 = type { %struct.proc*, %struct.proc** }
%struct.anon.1 = type { %struct.thread*, %struct.thread** }
%struct.ucred = type { i32, i32, i32, i32, i32, i32, i32, %struct.uidinfo*, %struct.uidinfo*, %struct.prison*, %struct.loginclass*, i32, [2 x i8*], %struct.label*, %struct.auditinfo_addr, i32*, i32 }
%struct.uidinfo = type opaque
%struct.prison = type { %struct.anon.2, i32, i32, i32, i32, %struct.anon.3, %struct.anon.4, %struct.prison*, %struct.mtx, %struct.task, %struct.osd, %struct.cpuset*, %struct.vnet*, %struct.vnode*, i32, i32, %struct.in_addr*, %struct.in6_addr*, %struct.prison_racct*, [3 x i8*], i32, i32, i32, i32, i32, i32, [4 x i32], i64, [256 x i8], [1024 x i8], [256 x i8], [256 x i8], [64 x i8] }
%struct.anon.2 = type { %struct.prison*, %struct.prison** }
%struct.anon.3 = type { %struct.prison* }
%struct.anon.4 = type { %struct.prison*, %struct.prison** }
%struct.task = type { %struct.anon.5, i16, i16, void (i8*, i32)*, i8* }
%struct.anon.5 = type { %struct.task* }
%struct.osd = type { i32, i8**, %struct.anon.6 }
%struct.anon.6 = type { %struct.osd*, %struct.osd** }
%struct.cpuset = type { %struct._cpuset, i32, i32, i32, %struct.cpuset*, %struct.anon.7, %struct.anon.8, %struct.setlist }
%struct._cpuset = type { [1 x i64] }
%struct.anon.7 = type { %struct.cpuset*, %struct.cpuset** }
%struct.anon.8 = type { %struct.cpuset*, %struct.cpuset** }
%struct.setlist = type { %struct.cpuset* }
%struct.vnet = type opaque
%struct.vnode = type opaque
%struct.in_addr = type opaque
%struct.in6_addr = type opaque
%struct.prison_racct = type { %struct.anon.9, [256 x i8], i32, %struct.racct* }
%struct.anon.9 = type { %struct.prison_racct*, %struct.prison_racct** }
%struct.racct = type opaque
%struct.loginclass = type opaque
%struct.label = type opaque
%struct.auditinfo_addr = type { i32, %struct.au_mask, %struct.au_tid_addr, i32, i64 }
%struct.au_mask = type { i32, i32 }
%struct.au_tid_addr = type { i32, i32, [4 x i32] }
%struct.filedesc = type opaque
%struct.filedesc_to_leader = type opaque
%struct.pstats = type opaque
%struct.plimit = type opaque
%struct.callout = type { %union.anon, i64, i64, i8*, void (i8*)*, %struct.lock_object*, i32, i32 }
%union.anon = type { %struct.anon.10 }
%struct.anon.10 = type { %struct.callout*, %struct.callout** }
%struct.sigacts = type { [128 x void (i32)*], [128 x %struct.__sigset], %struct.__sigset, %struct.__sigset, %struct.__sigset, %struct.__sigset, %struct.__sigset, %struct.__sigset, %struct.__sigset, %struct.__sigset, %struct.__sigset, %struct.__sigset, i32, i32, %struct.mtx }
%struct.__sigset = type { [4 x i32] }
%struct.anon.13 = type { %struct.proc*, %struct.proc** }
%struct.anon.14 = type { %struct.proc*, %struct.proc** }
%struct.anon.15 = type { %struct.proc*, %struct.proc** }
%struct.anon.16 = type { %struct.proc* }
%struct.ksiginfo = type { %struct.anon.17, %struct.__siginfo, i32, %struct.sigqueue* }
%struct.anon.17 = type { %struct.ksiginfo*, %struct.ksiginfo** }
%struct.__siginfo = type { i32, i32, i32, i32, i32, i32, i8*, %union.sigval, %union.anon.18 }
%union.sigval = type { i8* }
%union.anon.18 = type { %struct.anon.23 }
%struct.anon.23 = type { i64, [7 x i32] }
%struct.sigqueue = type { %struct.__sigset, %struct.__sigset, %struct.anon.24, %struct.proc*, i32 }
%struct.anon.24 = type { %struct.ksiginfo*, %struct.ksiginfo** }
%struct.vmspace = type opaque
%struct.itimerval = type { %struct.timeval, %struct.timeval }
%struct.timeval = type { i64, i64 }
%struct.rusage = type { %struct.timeval, %struct.timeval, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64 }
%struct.rusage_ext = type { i64, i64, i64, i64, i64, i64, i64 }
%struct.sigiolst = type { %struct.sigio* }
%struct.sigio = type { %union.anon.25, %struct.anon.26, %struct.sigio**, %struct.ucred*, i32 }
%union.anon.25 = type { %struct.proc* }
%struct.anon.26 = type { %struct.sigio* }
%struct.nlminfo = type opaque
%struct.kaioinfo = type opaque
%struct.itimers = type opaque
%struct.procdesc = type opaque
%struct.pgrp = type { %struct.anon.41, %struct.anon.42, %struct.session*, %struct.sigiolst, i32, i32, %struct.mtx }
%struct.anon.41 = type { %struct.pgrp*, %struct.pgrp** }
%struct.anon.42 = type { %struct.proc* }
%struct.session = type { i32, %struct.proc*, %struct.vnode*, %struct.cdev_priv*, %struct.tty*, i32, [40 x i8], %struct.mtx }
%struct.cdev_priv = type opaque
%struct.tty = type opaque
%struct.sysentvec = type opaque
%struct.pargs = type { i32, i32, [1 x i8] }
%struct.knlist = type { %struct.klist, void (i8*)*, void (i8*)*, void (i8*)*, void (i8*)*, i8* }
%struct.klist = type { %struct.knote* }
%struct.knote = type { %struct.anon.27, %struct.anon.28, %struct.knlist*, %struct.anon.29, %struct.kqueue*, %struct.kevent, i32, i32, i64, %union.anon.30, %struct.filterops*, i8*, i32 }
%struct.anon.27 = type { %struct.knote* }
%struct.anon.28 = type { %struct.knote* }
%struct.anon.29 = type { %struct.knote*, %struct.knote** }
%struct.kqueue = type opaque
%struct.kevent = type { i64, i16, i16, i32, i64, i8* }
%union.anon.30 = type { %struct.file* }
%struct.file = type opaque
%struct.filterops = type { i32, i32 (%struct.knote*)*, void (%struct.knote*)*, i32 (%struct.knote*, i64)*, void (%struct.knote*, %struct.kevent*, i64)* }
%struct.mdproc = type { %struct.proc_ldt*, %struct.system_segment_descriptor }
%struct.proc_ldt = type { i8*, i32 }
%struct.system_segment_descriptor = type <{ [16 x i8] }>
%struct.p_sched = type opaque
%struct.anon.31 = type { %struct.ktr_request*, %struct.ktr_request** }
%struct.ktr_request = type opaque
%struct.anon.32 = type { %struct.mqueue_notifier* }
%struct.mqueue_notifier = type opaque
%struct.kdtrace_proc = type opaque
%struct.cv = type { i8*, i32 }
%struct.anon.33 = type { %struct.proc*, %struct.proc** }
%struct.anon.34 = type { %struct.proc* }
%struct.anon.35 = type { %struct.thread*, %struct.thread** }
%struct.anon.36 = type { %struct.thread*, %struct.thread** }
%struct.anon.37 = type { %struct.thread*, %struct.thread** }
%struct.anon.38 = type { %struct.thread*, %struct.thread** }
%struct.anon.39 = type { %struct.thread*, %struct.thread** }
%struct.seltd = type opaque
%struct.sleepqueue = type opaque
%struct.turnstile = type opaque
%struct.rl_q_entry = type opaque
%struct.umtx_q = type opaque
%struct.anon.40 = type { %struct.turnstile* }
%struct.lock_list_entry = type opaque
%struct.sigaltstack = type { i8*, i64, i32 }
%struct.vm_map_entry = type opaque
%struct.pcb = type opaque
%struct.trapframe = type { i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32, i16, i16, i64, i32, i16, i16, i64, i64, i64, i64, i64, i64 }
%struct.vm_object = type opaque
%struct.mdthread = type { i32, i64, i64 }
%struct.td_sched = type opaque
%struct.kaudit_record = type opaque
%struct.lpohead = type { %struct.lock_profile_object* }
%struct.lock_profile_object = type opaque
%struct.kdtrace_thread = type opaque
%struct.vm_page = type opaque
%struct.tesla_store = type opaque
%struct.uma_zone = type opaque
%struct.unrhdr = type opaque
%struct.sysinit = type { i32, i32, void (i8*)*, i8* }
%struct.malloc_type = type { %struct.malloc_type*, i64, i8*, i8* }
%struct.command_table = type { %struct.command* }
%struct.command = type { i8*, void (i64, i32, i64, i8*)*, i32, %struct.command_table*, %struct.anon.43 }
%struct.anon.43 = type { %struct.command*, %struct.command** }
%struct.sx = type { %struct.lock_object, i64 }
%struct.__tesla_locality = type {}
%struct.cpuset_args = type { [0 x i8], i32*, [0 x i8] }
%struct.cpuset_setid_args = type { [0 x i8], i32, [4 x i8], [0 x i8], i64, [0 x i8], [0 x i8], i32, [4 x i8] }
%struct.cpuset_getid_args = type { [0 x i8], i32, [4 x i8], [0 x i8], i32, [4 x i8], [0 x i8], i64, [0 x i8], [0 x i8], i32*, [0 x i8] }
%struct.cpuset_getaffinity_args = type { [0 x i8], i32, [4 x i8], [0 x i8], i32, [4 x i8], [0 x i8], i64, [0 x i8], [0 x i8], i64, [0 x i8], [0 x i8], %struct._cpuset*, [0 x i8] }
%struct.cpuset_setaffinity_args = type { [0 x i8], i32, [4 x i8], [0 x i8], i32, [4 x i8], [0 x i8], i64, [0 x i8], [0 x i8], i64, [0 x i8], [0 x i8], %struct._cpuset*, [0 x i8] }

@sysctl___kern_sched_cpusetsize = internal global %struct.sysctl_oid { %struct.sysctl_oid_list* @sysctl__kern_sched_children, %struct.anon zeroinitializer, i32 -1, i32 -2147221502, i8* null, i64 8, i8* getelementptr inbounds ([11 x i8]* @.str24, i32 0, i32 0), i32 (%struct.sysctl_oid*, i8*, i64, %struct.sysctl_req*)* @sysctl_handle_int, i8* getelementptr inbounds ([2 x i8]* @.str25, i32 0, i32 0), i32 0, i32 0, i8* getelementptr inbounds ([17 x i8]* @.str26, i32 0, i32 0) }, align 8
@__set_sysctl_set_sym_sysctl___kern_sched_cpusetsize = internal constant i8* bitcast (%struct.sysctl_oid* @sysctl___kern_sched_cpusetsize to i8*), section "set_sysctl_set", align 8
@cpuset_lock = internal global %struct.mtx zeroinitializer, align 8
@.emptystring = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str = private unnamed_addr constant [44 x i8] c"/home/jra40/P4/tesla/sys/kern/kern_cpuset.c\00", align 1
@.str1 = private unnamed_addr constant [34 x i8] c"Bad link elm %p next->prev != elm\00", align 1
@.str2 = private unnamed_addr constant [34 x i8] c"Bad link elm %p prev->next != elm\00", align 1
@cpuset_zone = internal global %struct.uma_zone* null, align 8
@cpuset_unr = internal global %struct.unrhdr* null, align 8
@.str3 = private unnamed_addr constant [5 x i8] c"%lx,\00", align 1
@.str4 = private unnamed_addr constant [4 x i8] c"%lx\00", align 1
@.str5 = private unnamed_addr constant [2 x i8] c",\00", align 1
@.str6 = private unnamed_addr constant [7 x i8] c"cpuset\00", align 1
@cpuset_ids = internal global %struct.setlist zeroinitializer, align 8
@.str7 = private unnamed_addr constant [37 x i8] c"Bad list head %p first->prev != head\00", align 1
@cpuset_zero = internal global %struct.cpuset* null, align 8
@cpuset_root = common global %struct._cpuset* null, align 8
@.str8 = private unnamed_addr constant [32 x i8] c"Error creating default set: %d\0A\00", align 1
@.str9 = private unnamed_addr constant [19 x i8] c"[%s:%d] invalid pr\00", align 1
@__func__.cpuset_create_root = private unnamed_addr constant [19 x i8] c"cpuset_create_root\00", align 1
@.str10 = private unnamed_addr constant [21 x i8] c"[%s:%d] invalid setp\00", align 1
@.str11 = private unnamed_addr constant [44 x i8] c"[%s:%d] cpuset_create returned invalid data\00", align 1
@.str12 = private unnamed_addr constant [21 x i8] c"[%s:%d] invalid proc\00", align 1
@__func__.cpuset_setproc_update_set = private unnamed_addr constant [26 x i8] c"cpuset_setproc_update_set\00", align 1
@.str13 = private unnamed_addr constant [20 x i8] c"[%s:%d] invalid set\00", align 1
@cpuset_sys_init = internal global %struct.sysinit { i32 251658240, i32 268435455, void (i8*)* @cpuset_init, i8* null }, align 8
@__set_sysinit_set_sym_cpuset_sys_init = internal constant i8* bitcast (%struct.sysinit* @cpuset_sys_init to i8*), section "set_sysinit_set", align 8
@M_TEMP = external global [1 x %struct.malloc_type]
@cpusets_show_sys_init = internal global %struct.sysinit { i32 33554432, i32 268435455, void (i8*)* @cpusets_show_add, i8* null }, align 8
@__set_sysinit_set_sym_cpusets_show_sys_init = internal constant i8* bitcast (%struct.sysinit* @cpusets_show_sys_init to i8*), section "set_sysinit_set", align 8
@cpusets_show_sys_uninit = internal global %struct.sysinit { i32 33554432, i32 268435455, void (i8*)* @cpusets_show_del, i8* null }, align 8
@__set_sysuninit_set_sym_cpusets_show_sys_uninit = internal constant i8* bitcast (%struct.sysinit* @cpusets_show_sys_uninit to i8*), section "set_sysuninit_set", align 8
@db_show_table = external global %struct.command_table
@cpusets_show = internal global %struct.command { i8* getelementptr inbounds ([8 x i8]* @.str14, i32 0, i32 0), void (i64, i32, i64, i8*)* @db_show_cpusets, i32 0, %struct.command_table* null, %struct.anon.43 zeroinitializer }, align 8
@.str14 = private unnamed_addr constant [8 x i8] c"cpusets\00", align 1
@.str15 = private unnamed_addr constant [51 x i8] c"set=%p id=%-6u ref=%-6d flags=0x%04x parent id=%d\0A\00", align 1
@.str16 = private unnamed_addr constant [8 x i8] c"  mask=\00", align 1
@.str17 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str18 = private unnamed_addr constant [4 x i8] c",%d\00", align 1
@.str19 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@db_pager_quit = external global i32
@.str20 = private unnamed_addr constant [19 x i8] c"[%s:%d] td is NULL\00", align 1
@__func__.cpuset_lookup = private unnamed_addr constant [14 x i8] c"cpuset_lookup\00", align 1
@all_cpus = external global %struct._cpuset
@.str21 = private unnamed_addr constant [32 x i8] c"Can't set initial cpuset mask.\0A\00", align 1
@allprison_lock = external global %struct.sx
@.str22 = private unnamed_addr constant [21 x i8] c"negative refcount %p\00", align 1
@.str23 = private unnamed_addr constant [23 x i8] c"refcount %p overflowed\00", align 1
@sysctl__kern_sched_children = external global %struct.sysctl_oid_list
@.str24 = private unnamed_addr constant [11 x i8] c"cpusetsize\00", align 1
@.str25 = private unnamed_addr constant [2 x i8] c"I\00", align 1
@.str26 = private unnamed_addr constant [17 x i8] c"sizeof(cpuset_t)\00", align 1
@llvm.used = appending global [4 x i8*] [i8* bitcast (i8** @__set_sysctl_set_sym_sysctl___kern_sched_cpusetsize to i8*), i8* bitcast (i8** @__set_sysinit_set_sym_cpuset_sys_init to i8*), i8* bitcast (i8** @__set_sysinit_set_sym_cpusets_show_sys_init to i8*), i8* bitcast (i8** @__set_sysuninit_set_sym_cpusets_show_sys_uninit to i8*)], section "llvm.metadata"

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define %struct.cpuset* @cpuset_ref(%struct.cpuset* %set) #0 {
entry:
  %set.addr = alloca %struct.cpuset*, align 8
  store %struct.cpuset* %set, %struct.cpuset** %set.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %set.addr}, metadata !1411), !dbg !1412
  %0 = load %struct.cpuset** %set.addr, align 8, !dbg !1413
  %cs_ref = getelementptr inbounds %struct.cpuset* %0, i32 0, i32 1, !dbg !1413
  call void @refcount_acquire(i32* %cs_ref) #7, !dbg !1413
  %1 = load %struct.cpuset** %set.addr, align 8, !dbg !1414
  ret %struct.cpuset* %1, !dbg !1414
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata) #1

; Function Attrs: inlinehint noimplicitfloat noredzone nounwind ssp
define internal void @refcount_acquire(i32* %count) #2 {
entry:
  %count.addr = alloca i32*, align 8
  store i32* %count, i32** %count.addr, align 8
  call void @llvm.dbg.declare(metadata !{i32** %count.addr}, metadata !1415), !dbg !1416
  br label %do.body, !dbg !1417

do.body:                                          ; preds = %entry
  %0 = load i32** %count.addr, align 8, !dbg !1419
  %1 = load volatile i32* %0, align 4, !dbg !1419
  %cmp = icmp ult i32 %1, -1, !dbg !1419
  %lnot = xor i1 %cmp, true, !dbg !1419
  %lnot.ext = zext i1 %lnot to i32, !dbg !1419
  %conv = sext i32 %lnot.ext to i64, !dbg !1419
  %expval = call i64 @llvm.expect.i64(i64 %conv, i64 0), !dbg !1419
  %tobool = icmp ne i64 %expval, 0, !dbg !1419
  br i1 %tobool, label %if.then, label %if.end, !dbg !1419

if.then:                                          ; preds = %do.body
  %2 = load i32** %count.addr, align 8, !dbg !1419
  call void (i8*, ...)* @kassert_panic(i8* getelementptr inbounds ([23 x i8]* @.str23, i32 0, i32 0), i32* %2) #7, !dbg !1419
  br label %if.end, !dbg !1419

if.end:                                           ; preds = %if.then, %do.body
  br label %do.end, !dbg !1419

do.end:                                           ; preds = %if.end
  %3 = load i32** %count.addr, align 8, !dbg !1421
  call void @atomic_add_barr_int(i32* %3, i32 1) #7, !dbg !1421
  ret void, !dbg !1422
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define void @cpuset_rel(%struct.cpuset* %set) #0 {
entry:
  %set.addr = alloca %struct.cpuset*, align 8
  %id = alloca i32, align 4
  store %struct.cpuset* %set, %struct.cpuset** %set.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %set.addr}, metadata !1423), !dbg !1424
  call void @llvm.dbg.declare(metadata !{i32* %id}, metadata !1425), !dbg !1426
  %0 = load %struct.cpuset** %set.addr, align 8, !dbg !1427
  %cs_ref = getelementptr inbounds %struct.cpuset* %0, i32 0, i32 1, !dbg !1427
  %call = call i32 @refcount_release(i32* %cs_ref) #7, !dbg !1427
  %cmp = icmp eq i32 %call, 0, !dbg !1427
  br i1 %cmp, label %if.then, label %if.end, !dbg !1427

if.then:                                          ; preds = %entry
  br label %if.end77, !dbg !1428

if.end:                                           ; preds = %entry
  call void @__mtx_lock_spin_flags(i64* getelementptr inbounds (%struct.mtx* @cpuset_lock, i32 0, i32 1), i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 173) #7, !dbg !1429
  br label %do.body, !dbg !1430

do.body:                                          ; preds = %if.end
  br label %do.body1, !dbg !1431

do.body1:                                         ; preds = %do.body
  %1 = load %struct.cpuset** %set.addr, align 8, !dbg !1433
  %cs_siblings = getelementptr inbounds %struct.cpuset* %1, i32 0, i32 6, !dbg !1433
  %le_next = getelementptr inbounds %struct.anon.8* %cs_siblings, i32 0, i32 0, !dbg !1433
  %2 = load %struct.cpuset** %le_next, align 8, !dbg !1433
  %cmp2 = icmp ne %struct.cpuset* %2, null, !dbg !1433
  br i1 %cmp2, label %land.lhs.true, label %if.end10, !dbg !1433

land.lhs.true:                                    ; preds = %do.body1
  %3 = load %struct.cpuset** %set.addr, align 8, !dbg !1433
  %cs_siblings3 = getelementptr inbounds %struct.cpuset* %3, i32 0, i32 6, !dbg !1433
  %le_next4 = getelementptr inbounds %struct.anon.8* %cs_siblings3, i32 0, i32 0, !dbg !1433
  %4 = load %struct.cpuset** %le_next4, align 8, !dbg !1433
  %cs_siblings5 = getelementptr inbounds %struct.cpuset* %4, i32 0, i32 6, !dbg !1433
  %le_prev = getelementptr inbounds %struct.anon.8* %cs_siblings5, i32 0, i32 1, !dbg !1433
  %5 = load %struct.cpuset*** %le_prev, align 8, !dbg !1433
  %6 = load %struct.cpuset** %set.addr, align 8, !dbg !1433
  %cs_siblings6 = getelementptr inbounds %struct.cpuset* %6, i32 0, i32 6, !dbg !1433
  %le_next7 = getelementptr inbounds %struct.anon.8* %cs_siblings6, i32 0, i32 0, !dbg !1433
  %cmp8 = icmp ne %struct.cpuset** %5, %le_next7, !dbg !1433
  br i1 %cmp8, label %if.then9, label %if.end10, !dbg !1433

if.then9:                                         ; preds = %land.lhs.true
  %7 = load %struct.cpuset** %set.addr, align 8, !dbg !1433
  call void (i8*, ...)* @panic(i8* getelementptr inbounds ([34 x i8]* @.str1, i32 0, i32 0), %struct.cpuset* %7) #8, !dbg !1433
  unreachable, !dbg !1433

if.end10:                                         ; preds = %land.lhs.true, %do.body1
  br label %do.end, !dbg !1433

do.end:                                           ; preds = %if.end10
  br label %do.body11, !dbg !1431

do.body11:                                        ; preds = %do.end
  %8 = load %struct.cpuset** %set.addr, align 8, !dbg !1435
  %cs_siblings12 = getelementptr inbounds %struct.cpuset* %8, i32 0, i32 6, !dbg !1435
  %le_prev13 = getelementptr inbounds %struct.anon.8* %cs_siblings12, i32 0, i32 1, !dbg !1435
  %9 = load %struct.cpuset*** %le_prev13, align 8, !dbg !1435
  %10 = load %struct.cpuset** %9, align 8, !dbg !1435
  %11 = load %struct.cpuset** %set.addr, align 8, !dbg !1435
  %cmp14 = icmp ne %struct.cpuset* %10, %11, !dbg !1435
  br i1 %cmp14, label %if.then15, label %if.end16, !dbg !1435

if.then15:                                        ; preds = %do.body11
  %12 = load %struct.cpuset** %set.addr, align 8, !dbg !1435
  call void (i8*, ...)* @panic(i8* getelementptr inbounds ([34 x i8]* @.str2, i32 0, i32 0), %struct.cpuset* %12) #8, !dbg !1435
  unreachable, !dbg !1435

if.end16:                                         ; preds = %do.body11
  br label %do.end17, !dbg !1435

do.end17:                                         ; preds = %if.end16
  %13 = load %struct.cpuset** %set.addr, align 8, !dbg !1431
  %cs_siblings18 = getelementptr inbounds %struct.cpuset* %13, i32 0, i32 6, !dbg !1431
  %le_next19 = getelementptr inbounds %struct.anon.8* %cs_siblings18, i32 0, i32 0, !dbg !1431
  %14 = load %struct.cpuset** %le_next19, align 8, !dbg !1431
  %cmp20 = icmp ne %struct.cpuset* %14, null, !dbg !1431
  br i1 %cmp20, label %if.then21, label %if.end28, !dbg !1431

if.then21:                                        ; preds = %do.end17
  %15 = load %struct.cpuset** %set.addr, align 8, !dbg !1431
  %cs_siblings22 = getelementptr inbounds %struct.cpuset* %15, i32 0, i32 6, !dbg !1431
  %le_prev23 = getelementptr inbounds %struct.anon.8* %cs_siblings22, i32 0, i32 1, !dbg !1431
  %16 = load %struct.cpuset*** %le_prev23, align 8, !dbg !1431
  %17 = load %struct.cpuset** %set.addr, align 8, !dbg !1431
  %cs_siblings24 = getelementptr inbounds %struct.cpuset* %17, i32 0, i32 6, !dbg !1431
  %le_next25 = getelementptr inbounds %struct.anon.8* %cs_siblings24, i32 0, i32 0, !dbg !1431
  %18 = load %struct.cpuset** %le_next25, align 8, !dbg !1431
  %cs_siblings26 = getelementptr inbounds %struct.cpuset* %18, i32 0, i32 6, !dbg !1431
  %le_prev27 = getelementptr inbounds %struct.anon.8* %cs_siblings26, i32 0, i32 1, !dbg !1431
  store %struct.cpuset** %16, %struct.cpuset*** %le_prev27, align 8, !dbg !1431
  br label %if.end28, !dbg !1431

if.end28:                                         ; preds = %if.then21, %do.end17
  %19 = load %struct.cpuset** %set.addr, align 8, !dbg !1431
  %cs_siblings29 = getelementptr inbounds %struct.cpuset* %19, i32 0, i32 6, !dbg !1431
  %le_next30 = getelementptr inbounds %struct.anon.8* %cs_siblings29, i32 0, i32 0, !dbg !1431
  %20 = load %struct.cpuset** %le_next30, align 8, !dbg !1431
  %21 = load %struct.cpuset** %set.addr, align 8, !dbg !1431
  %cs_siblings31 = getelementptr inbounds %struct.cpuset* %21, i32 0, i32 6, !dbg !1431
  %le_prev32 = getelementptr inbounds %struct.anon.8* %cs_siblings31, i32 0, i32 1, !dbg !1431
  %22 = load %struct.cpuset*** %le_prev32, align 8, !dbg !1431
  store %struct.cpuset* %20, %struct.cpuset** %22, align 8, !dbg !1431
  br label %do.end33, !dbg !1431

do.end33:                                         ; preds = %if.end28
  %23 = load %struct.cpuset** %set.addr, align 8, !dbg !1437
  %cs_id = getelementptr inbounds %struct.cpuset* %23, i32 0, i32 3, !dbg !1437
  %24 = load i32* %cs_id, align 4, !dbg !1437
  store i32 %24, i32* %id, align 4, !dbg !1437
  %25 = load i32* %id, align 4, !dbg !1438
  %cmp34 = icmp ne i32 %25, -1, !dbg !1438
  br i1 %cmp34, label %if.then35, label %if.end74, !dbg !1438

if.then35:                                        ; preds = %do.end33
  br label %do.body36, !dbg !1439

do.body36:                                        ; preds = %if.then35
  br label %do.body37, !dbg !1440

do.body37:                                        ; preds = %do.body36
  %26 = load %struct.cpuset** %set.addr, align 8, !dbg !1442
  %cs_link = getelementptr inbounds %struct.cpuset* %26, i32 0, i32 5, !dbg !1442
  %le_next38 = getelementptr inbounds %struct.anon.7* %cs_link, i32 0, i32 0, !dbg !1442
  %27 = load %struct.cpuset** %le_next38, align 8, !dbg !1442
  %cmp39 = icmp ne %struct.cpuset* %27, null, !dbg !1442
  br i1 %cmp39, label %land.lhs.true40, label %if.end49, !dbg !1442

land.lhs.true40:                                  ; preds = %do.body37
  %28 = load %struct.cpuset** %set.addr, align 8, !dbg !1442
  %cs_link41 = getelementptr inbounds %struct.cpuset* %28, i32 0, i32 5, !dbg !1442
  %le_next42 = getelementptr inbounds %struct.anon.7* %cs_link41, i32 0, i32 0, !dbg !1442
  %29 = load %struct.cpuset** %le_next42, align 8, !dbg !1442
  %cs_link43 = getelementptr inbounds %struct.cpuset* %29, i32 0, i32 5, !dbg !1442
  %le_prev44 = getelementptr inbounds %struct.anon.7* %cs_link43, i32 0, i32 1, !dbg !1442
  %30 = load %struct.cpuset*** %le_prev44, align 8, !dbg !1442
  %31 = load %struct.cpuset** %set.addr, align 8, !dbg !1442
  %cs_link45 = getelementptr inbounds %struct.cpuset* %31, i32 0, i32 5, !dbg !1442
  %le_next46 = getelementptr inbounds %struct.anon.7* %cs_link45, i32 0, i32 0, !dbg !1442
  %cmp47 = icmp ne %struct.cpuset** %30, %le_next46, !dbg !1442
  br i1 %cmp47, label %if.then48, label %if.end49, !dbg !1442

if.then48:                                        ; preds = %land.lhs.true40
  %32 = load %struct.cpuset** %set.addr, align 8, !dbg !1442
  call void (i8*, ...)* @panic(i8* getelementptr inbounds ([34 x i8]* @.str1, i32 0, i32 0), %struct.cpuset* %32) #8, !dbg !1442
  unreachable, !dbg !1442

if.end49:                                         ; preds = %land.lhs.true40, %do.body37
  br label %do.end50, !dbg !1442

do.end50:                                         ; preds = %if.end49
  br label %do.body51, !dbg !1440

do.body51:                                        ; preds = %do.end50
  %33 = load %struct.cpuset** %set.addr, align 8, !dbg !1444
  %cs_link52 = getelementptr inbounds %struct.cpuset* %33, i32 0, i32 5, !dbg !1444
  %le_prev53 = getelementptr inbounds %struct.anon.7* %cs_link52, i32 0, i32 1, !dbg !1444
  %34 = load %struct.cpuset*** %le_prev53, align 8, !dbg !1444
  %35 = load %struct.cpuset** %34, align 8, !dbg !1444
  %36 = load %struct.cpuset** %set.addr, align 8, !dbg !1444
  %cmp54 = icmp ne %struct.cpuset* %35, %36, !dbg !1444
  br i1 %cmp54, label %if.then55, label %if.end56, !dbg !1444

if.then55:                                        ; preds = %do.body51
  %37 = load %struct.cpuset** %set.addr, align 8, !dbg !1444
  call void (i8*, ...)* @panic(i8* getelementptr inbounds ([34 x i8]* @.str2, i32 0, i32 0), %struct.cpuset* %37) #8, !dbg !1444
  unreachable, !dbg !1444

if.end56:                                         ; preds = %do.body51
  br label %do.end57, !dbg !1444

do.end57:                                         ; preds = %if.end56
  %38 = load %struct.cpuset** %set.addr, align 8, !dbg !1440
  %cs_link58 = getelementptr inbounds %struct.cpuset* %38, i32 0, i32 5, !dbg !1440
  %le_next59 = getelementptr inbounds %struct.anon.7* %cs_link58, i32 0, i32 0, !dbg !1440
  %39 = load %struct.cpuset** %le_next59, align 8, !dbg !1440
  %cmp60 = icmp ne %struct.cpuset* %39, null, !dbg !1440
  br i1 %cmp60, label %if.then61, label %if.end68, !dbg !1440

if.then61:                                        ; preds = %do.end57
  %40 = load %struct.cpuset** %set.addr, align 8, !dbg !1440
  %cs_link62 = getelementptr inbounds %struct.cpuset* %40, i32 0, i32 5, !dbg !1440
  %le_prev63 = getelementptr inbounds %struct.anon.7* %cs_link62, i32 0, i32 1, !dbg !1440
  %41 = load %struct.cpuset*** %le_prev63, align 8, !dbg !1440
  %42 = load %struct.cpuset** %set.addr, align 8, !dbg !1440
  %cs_link64 = getelementptr inbounds %struct.cpuset* %42, i32 0, i32 5, !dbg !1440
  %le_next65 = getelementptr inbounds %struct.anon.7* %cs_link64, i32 0, i32 0, !dbg !1440
  %43 = load %struct.cpuset** %le_next65, align 8, !dbg !1440
  %cs_link66 = getelementptr inbounds %struct.cpuset* %43, i32 0, i32 5, !dbg !1440
  %le_prev67 = getelementptr inbounds %struct.anon.7* %cs_link66, i32 0, i32 1, !dbg !1440
  store %struct.cpuset** %41, %struct.cpuset*** %le_prev67, align 8, !dbg !1440
  br label %if.end68, !dbg !1440

if.end68:                                         ; preds = %if.then61, %do.end57
  %44 = load %struct.cpuset** %set.addr, align 8, !dbg !1440
  %cs_link69 = getelementptr inbounds %struct.cpuset* %44, i32 0, i32 5, !dbg !1440
  %le_next70 = getelementptr inbounds %struct.anon.7* %cs_link69, i32 0, i32 0, !dbg !1440
  %45 = load %struct.cpuset** %le_next70, align 8, !dbg !1440
  %46 = load %struct.cpuset** %set.addr, align 8, !dbg !1440
  %cs_link71 = getelementptr inbounds %struct.cpuset* %46, i32 0, i32 5, !dbg !1440
  %le_prev72 = getelementptr inbounds %struct.anon.7* %cs_link71, i32 0, i32 1, !dbg !1440
  %47 = load %struct.cpuset*** %le_prev72, align 8, !dbg !1440
  store %struct.cpuset* %45, %struct.cpuset** %47, align 8, !dbg !1440
  br label %do.end73, !dbg !1440

do.end73:                                         ; preds = %if.end68
  br label %if.end74, !dbg !1440

if.end74:                                         ; preds = %do.end73, %do.end33
  call void @__mtx_unlock_spin_flags(i64* getelementptr inbounds (%struct.mtx* @cpuset_lock, i32 0, i32 1), i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 178) #7, !dbg !1446
  %48 = load %struct.cpuset** %set.addr, align 8, !dbg !1447
  %cs_parent = getelementptr inbounds %struct.cpuset* %48, i32 0, i32 4, !dbg !1447
  %49 = load %struct.cpuset** %cs_parent, align 8, !dbg !1447
  call void @cpuset_rel(%struct.cpuset* %49) #7, !dbg !1447
  %50 = load %struct.uma_zone** @cpuset_zone, align 8, !dbg !1448
  %51 = load %struct.cpuset** %set.addr, align 8, !dbg !1448
  %52 = bitcast %struct.cpuset* %51 to i8*, !dbg !1448
  call void @uma_zfree(%struct.uma_zone* %50, i8* %52) #7, !dbg !1448
  %53 = load i32* %id, align 4, !dbg !1449
  %cmp75 = icmp ne i32 %53, -1, !dbg !1449
  br i1 %cmp75, label %if.then76, label %if.end77, !dbg !1449

if.then76:                                        ; preds = %if.end74
  %54 = load %struct.unrhdr** @cpuset_unr, align 8, !dbg !1450
  %55 = load i32* %id, align 4, !dbg !1450
  call void @free_unr(%struct.unrhdr* %54, i32 %55) #7, !dbg !1450
  br label %if.end77, !dbg !1450

if.end77:                                         ; preds = %if.then, %if.then76, %if.end74
  ret void, !dbg !1450
}

; Function Attrs: inlinehint noimplicitfloat noredzone nounwind ssp
define internal i32 @refcount_release(i32* %count) #2 {
entry:
  %count.addr = alloca i32*, align 8
  %old = alloca i32, align 4
  store i32* %count, i32** %count.addr, align 8
  call void @llvm.dbg.declare(metadata !{i32** %count.addr}, metadata !1451), !dbg !1452
  call void @llvm.dbg.declare(metadata !{i32* %old}, metadata !1453), !dbg !1455
  %0 = load i32** %count.addr, align 8, !dbg !1456
  %call = call i32 @atomic_fetchadd_int(i32* %0, i32 -1) #7, !dbg !1456
  store i32 %call, i32* %old, align 4, !dbg !1456
  br label %do.body, !dbg !1457

do.body:                                          ; preds = %entry
  %1 = load i32* %old, align 4, !dbg !1458
  %cmp = icmp ugt i32 %1, 0, !dbg !1458
  %lnot = xor i1 %cmp, true, !dbg !1458
  %lnot.ext = zext i1 %lnot to i32, !dbg !1458
  %conv = sext i32 %lnot.ext to i64, !dbg !1458
  %expval = call i64 @llvm.expect.i64(i64 %conv, i64 0), !dbg !1458
  %tobool = icmp ne i64 %expval, 0, !dbg !1458
  br i1 %tobool, label %if.then, label %if.end, !dbg !1458

if.then:                                          ; preds = %do.body
  %2 = load i32** %count.addr, align 8, !dbg !1458
  call void (i8*, ...)* @kassert_panic(i8* getelementptr inbounds ([21 x i8]* @.str22, i32 0, i32 0), i32* %2) #7, !dbg !1458
  br label %if.end, !dbg !1458

if.end:                                           ; preds = %if.then, %do.body
  br label %do.end, !dbg !1458

do.end:                                           ; preds = %if.end
  %3 = load i32* %old, align 4, !dbg !1460
  %cmp1 = icmp eq i32 %3, 1, !dbg !1460
  %conv2 = zext i1 %cmp1 to i32, !dbg !1460
  ret i32 %conv2, !dbg !1460
}

; Function Attrs: noimplicitfloat noredzone
declare void @__mtx_lock_spin_flags(i64*, i32, i8*, i32) #3

; Function Attrs: noimplicitfloat noredzone noreturn
declare void @panic(i8*, ...) #4

; Function Attrs: noimplicitfloat noredzone
declare void @__mtx_unlock_spin_flags(i64*, i32, i8*, i32) #3

; Function Attrs: inlinehint noimplicitfloat noredzone nounwind ssp
define internal void @uma_zfree(%struct.uma_zone* %zone, i8* %item) #2 {
entry:
  %zone.addr = alloca %struct.uma_zone*, align 8
  %item.addr = alloca i8*, align 8
  store %struct.uma_zone* %zone, %struct.uma_zone** %zone.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.uma_zone** %zone.addr}, metadata !1461), !dbg !1462
  store i8* %item, i8** %item.addr, align 8
  call void @llvm.dbg.declare(metadata !{i8** %item.addr}, metadata !1463), !dbg !1462
  %0 = load %struct.uma_zone** %zone.addr, align 8, !dbg !1464
  %1 = load i8** %item.addr, align 8, !dbg !1464
  call void @uma_zfree_arg(%struct.uma_zone* %0, i8* %1, i8* null) #7, !dbg !1464
  ret void, !dbg !1466
}

; Function Attrs: noimplicitfloat noredzone
declare void @free_unr(%struct.unrhdr*, i32) #3

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @cpusetobj_ffs(%struct._cpuset* %set) #0 {
entry:
  %set.addr = alloca %struct._cpuset*, align 8
  %i = alloca i64, align 8
  %cbit = alloca i32, align 4
  store %struct._cpuset* %set, %struct._cpuset** %set.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct._cpuset** %set.addr}, metadata !1467), !dbg !1468
  call void @llvm.dbg.declare(metadata !{i64* %i}, metadata !1469), !dbg !1470
  call void @llvm.dbg.declare(metadata !{i32* %cbit}, metadata !1471), !dbg !1472
  store i32 0, i32* %cbit, align 4, !dbg !1473
  store i64 0, i64* %i, align 8, !dbg !1474
  br label %for.cond, !dbg !1474

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i64* %i, align 8, !dbg !1474
  %cmp = icmp ult i64 %0, 1, !dbg !1474
  br i1 %cmp, label %for.body, label %for.end, !dbg !1474

for.body:                                         ; preds = %for.cond
  %1 = load i64* %i, align 8, !dbg !1476
  %2 = load %struct._cpuset** %set.addr, align 8, !dbg !1476
  %__bits = getelementptr inbounds %struct._cpuset* %2, i32 0, i32 0, !dbg !1476
  %arrayidx = getelementptr inbounds [1 x i64]* %__bits, i32 0, i64 %1, !dbg !1476
  %3 = load i64* %arrayidx, align 8, !dbg !1476
  %cmp1 = icmp ne i64 %3, 0, !dbg !1476
  br i1 %cmp1, label %if.then, label %if.end, !dbg !1476

if.then:                                          ; preds = %for.body
  %4 = load i64* %i, align 8, !dbg !1478
  %5 = load %struct._cpuset** %set.addr, align 8, !dbg !1478
  %__bits2 = getelementptr inbounds %struct._cpuset* %5, i32 0, i32 0, !dbg !1478
  %arrayidx3 = getelementptr inbounds [1 x i64]* %__bits2, i32 0, i64 %4, !dbg !1478
  %6 = load i64* %arrayidx3, align 8, !dbg !1478
  %call = call i32 @ffsl(i64 %6) #7, !dbg !1478
  store i32 %call, i32* %cbit, align 4, !dbg !1478
  %7 = load i64* %i, align 8, !dbg !1480
  %mul = mul i64 %7, 64, !dbg !1480
  %8 = load i32* %cbit, align 4, !dbg !1480
  %conv = sext i32 %8 to i64, !dbg !1480
  %add = add i64 %conv, %mul, !dbg !1480
  %conv4 = trunc i64 %add to i32, !dbg !1480
  store i32 %conv4, i32* %cbit, align 4, !dbg !1480
  br label %for.end, !dbg !1481

if.end:                                           ; preds = %for.body
  br label %for.inc, !dbg !1482

for.inc:                                          ; preds = %if.end
  %9 = load i64* %i, align 8, !dbg !1474
  %inc = add i64 %9, 1, !dbg !1474
  store i64 %inc, i64* %i, align 8, !dbg !1474
  br label %for.cond, !dbg !1474

for.end:                                          ; preds = %if.then, %for.cond
  %10 = load i32* %cbit, align 4, !dbg !1483
  ret i32 %10, !dbg !1483
}

; Function Attrs: inlinehint noimplicitfloat noredzone nounwind ssp
define internal i32 @ffsl(i64 %mask) #2 {
entry:
  %mask.addr = alloca i64, align 8
  store i64 %mask, i64* %mask.addr, align 8
  call void @llvm.dbg.declare(metadata !{i64* %mask.addr}, metadata !1484), !dbg !1485
  %0 = load i64* %mask.addr, align 8, !dbg !1486
  %cmp = icmp eq i64 %0, 0, !dbg !1486
  br i1 %cmp, label %cond.true, label %cond.false, !dbg !1486

cond.true:                                        ; preds = %entry
  %1 = load i64* %mask.addr, align 8, !dbg !1486
  br label %cond.end, !dbg !1486

cond.false:                                       ; preds = %entry
  %2 = load i64* %mask.addr, align 8, !dbg !1488
  %call = call i64 @bsfq(i64 %2) #7, !dbg !1488
  %conv = trunc i64 %call to i32, !dbg !1488
  %add = add nsw i32 %conv, 1, !dbg !1488
  %conv1 = sext i32 %add to i64, !dbg !1488
  br label %cond.end, !dbg !1488

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi i64 [ %1, %cond.true ], [ %conv1, %cond.false ], !dbg !1488
  %conv2 = trunc i64 %cond to i32, !dbg !1488
  ret i32 %conv2, !dbg !1488
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i8* @cpusetobj_strprint(i8* %buf, %struct._cpuset* %set) #0 {
entry:
  %buf.addr = alloca i8*, align 8
  %set.addr = alloca %struct._cpuset*, align 8
  %tbuf = alloca i8*, align 8
  %i = alloca i64, align 8
  %bytesp = alloca i64, align 8
  %bufsiz = alloca i64, align 8
  store i8* %buf, i8** %buf.addr, align 8
  call void @llvm.dbg.declare(metadata !{i8** %buf.addr}, metadata !1489), !dbg !1490
  store %struct._cpuset* %set, %struct._cpuset** %set.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct._cpuset** %set.addr}, metadata !1491), !dbg !1490
  call void @llvm.dbg.declare(metadata !{i8** %tbuf}, metadata !1492), !dbg !1493
  call void @llvm.dbg.declare(metadata !{i64* %i}, metadata !1494), !dbg !1495
  call void @llvm.dbg.declare(metadata !{i64* %bytesp}, metadata !1496), !dbg !1495
  call void @llvm.dbg.declare(metadata !{i64* %bufsiz}, metadata !1497), !dbg !1495
  %0 = load i8** %buf.addr, align 8, !dbg !1498
  store i8* %0, i8** %tbuf, align 8, !dbg !1498
  store i64 0, i64* %bytesp, align 8, !dbg !1499
  store i64 18, i64* %bufsiz, align 8, !dbg !1500
  store i64 0, i64* %i, align 8, !dbg !1501
  br label %for.cond, !dbg !1501

for.cond:                                         ; preds = %for.inc, %entry
  %1 = load i64* %i, align 8, !dbg !1501
  %cmp = icmp ult i64 %1, 0, !dbg !1501
  br i1 %cmp, label %for.body, label %for.end, !dbg !1501

for.body:                                         ; preds = %for.cond
  %2 = load i8** %tbuf, align 8, !dbg !1503
  %3 = load i64* %bufsiz, align 8, !dbg !1503
  %4 = load i64* %i, align 8, !dbg !1503
  %5 = load %struct._cpuset** %set.addr, align 8, !dbg !1503
  %__bits = getelementptr inbounds %struct._cpuset* %5, i32 0, i32 0, !dbg !1503
  %arrayidx = getelementptr inbounds [1 x i64]* %__bits, i32 0, i64 %4, !dbg !1503
  %6 = load i64* %arrayidx, align 8, !dbg !1503
  %call = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %2, i64 %3, i8* getelementptr inbounds ([5 x i8]* @.str3, i32 0, i32 0), i64 %6) #7, !dbg !1503
  %conv = sext i32 %call to i64, !dbg !1503
  store i64 %conv, i64* %bytesp, align 8, !dbg !1503
  %7 = load i64* %bytesp, align 8, !dbg !1505
  %8 = load i64* %bufsiz, align 8, !dbg !1505
  %sub = sub i64 %8, %7, !dbg !1505
  store i64 %sub, i64* %bufsiz, align 8, !dbg !1505
  %9 = load i64* %bytesp, align 8, !dbg !1506
  %10 = load i8** %tbuf, align 8, !dbg !1506
  %add.ptr = getelementptr inbounds i8* %10, i64 %9, !dbg !1506
  store i8* %add.ptr, i8** %tbuf, align 8, !dbg !1506
  br label %for.inc, !dbg !1507

for.inc:                                          ; preds = %for.body
  %11 = load i64* %i, align 8, !dbg !1501
  %inc = add i64 %11, 1, !dbg !1501
  store i64 %inc, i64* %i, align 8, !dbg !1501
  br label %for.cond, !dbg !1501

for.end:                                          ; preds = %for.cond
  %12 = load i8** %tbuf, align 8, !dbg !1508
  %13 = load i64* %bufsiz, align 8, !dbg !1508
  %14 = load %struct._cpuset** %set.addr, align 8, !dbg !1508
  %__bits1 = getelementptr inbounds %struct._cpuset* %14, i32 0, i32 0, !dbg !1508
  %arrayidx2 = getelementptr inbounds [1 x i64]* %__bits1, i32 0, i64 0, !dbg !1508
  %15 = load i64* %arrayidx2, align 8, !dbg !1508
  %call3 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %12, i64 %13, i8* getelementptr inbounds ([4 x i8]* @.str4, i32 0, i32 0), i64 %15) #7, !dbg !1508
  %16 = load i8** %buf.addr, align 8, !dbg !1509
  ret i8* %16, !dbg !1509
}

; Function Attrs: noimplicitfloat noredzone
declare i32 @snprintf(i8*, i64, i8*, ...) #3

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @cpusetobj_strscan(%struct._cpuset* %set, i8* %buf) #0 {
entry:
  %retval = alloca i32, align 4
  %set.addr = alloca %struct._cpuset*, align 8
  %buf.addr = alloca i8*, align 8
  %nwords = alloca i32, align 4
  %i = alloca i32, align 4
  %ret = alloca i32, align 4
  %__i = alloca i64, align 8
  store %struct._cpuset* %set, %struct._cpuset** %set.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct._cpuset** %set.addr}, metadata !1510), !dbg !1511
  store i8* %buf, i8** %buf.addr, align 8
  call void @llvm.dbg.declare(metadata !{i8** %buf.addr}, metadata !1512), !dbg !1511
  call void @llvm.dbg.declare(metadata !{i32* %nwords}, metadata !1513), !dbg !1514
  call void @llvm.dbg.declare(metadata !{i32* %i}, metadata !1515), !dbg !1516
  call void @llvm.dbg.declare(metadata !{i32* %ret}, metadata !1517), !dbg !1516
  %0 = load i8** %buf.addr, align 8, !dbg !1518
  %call = call i64 @strlen(i8* %0) #7, !dbg !1518
  %cmp = icmp ugt i64 %call, 17, !dbg !1518
  br i1 %cmp, label %if.then, label %if.end, !dbg !1518

if.then:                                          ; preds = %entry
  store i32 -1, i32* %retval, !dbg !1519
  br label %return, !dbg !1519

if.end:                                           ; preds = %entry
  store i32 1, i32* %nwords, align 4, !dbg !1520
  store i32 0, i32* %i, align 4, !dbg !1521
  br label %for.cond, !dbg !1521

for.cond:                                         ; preds = %for.inc, %if.end
  %1 = load i32* %i, align 4, !dbg !1521
  %idxprom = sext i32 %1 to i64, !dbg !1521
  %2 = load i8** %buf.addr, align 8, !dbg !1521
  %arrayidx = getelementptr inbounds i8* %2, i64 %idxprom, !dbg !1521
  %3 = load i8* %arrayidx, align 1, !dbg !1521
  %conv = sext i8 %3 to i32, !dbg !1521
  %cmp1 = icmp ne i32 %conv, 0, !dbg !1521
  br i1 %cmp1, label %for.body, label %for.end, !dbg !1521

for.body:                                         ; preds = %for.cond
  %4 = load i32* %i, align 4, !dbg !1523
  %idxprom3 = sext i32 %4 to i64, !dbg !1523
  %5 = load i8** %buf.addr, align 8, !dbg !1523
  %arrayidx4 = getelementptr inbounds i8* %5, i64 %idxprom3, !dbg !1523
  %6 = load i8* %arrayidx4, align 1, !dbg !1523
  %conv5 = sext i8 %6 to i32, !dbg !1523
  %cmp6 = icmp eq i32 %conv5, 44, !dbg !1523
  br i1 %cmp6, label %if.then8, label %if.end9, !dbg !1523

if.then8:                                         ; preds = %for.body
  %7 = load i32* %nwords, align 4, !dbg !1524
  %inc = add i32 %7, 1, !dbg !1524
  store i32 %inc, i32* %nwords, align 4, !dbg !1524
  br label %if.end9, !dbg !1524

if.end9:                                          ; preds = %if.then8, %for.body
  br label %for.inc, !dbg !1524

for.inc:                                          ; preds = %if.end9
  %8 = load i32* %i, align 4, !dbg !1521
  %inc10 = add nsw i32 %8, 1, !dbg !1521
  store i32 %inc10, i32* %i, align 4, !dbg !1521
  br label %for.cond, !dbg !1521

for.end:                                          ; preds = %for.cond
  %9 = load i32* %nwords, align 4, !dbg !1525
  %conv11 = zext i32 %9 to i64, !dbg !1525
  %cmp12 = icmp ugt i64 %conv11, 1, !dbg !1525
  br i1 %cmp12, label %if.then14, label %if.end15, !dbg !1525

if.then14:                                        ; preds = %for.end
  store i32 -1, i32* %retval, !dbg !1526
  br label %return, !dbg !1526

if.end15:                                         ; preds = %for.end
  br label %do.body, !dbg !1527

do.body:                                          ; preds = %if.end15
  call void @llvm.dbg.declare(metadata !{i64* %__i}, metadata !1528), !dbg !1530
  store i64 0, i64* %__i, align 8, !dbg !1531
  br label %for.cond16, !dbg !1531

for.cond16:                                       ; preds = %for.inc21, %do.body
  %10 = load i64* %__i, align 8, !dbg !1531
  %cmp17 = icmp ult i64 %10, 1, !dbg !1531
  br i1 %cmp17, label %for.body19, label %for.end23, !dbg !1531

for.body19:                                       ; preds = %for.cond16
  %11 = load i64* %__i, align 8, !dbg !1531
  %12 = load %struct._cpuset** %set.addr, align 8, !dbg !1531
  %__bits = getelementptr inbounds %struct._cpuset* %12, i32 0, i32 0, !dbg !1531
  %arrayidx20 = getelementptr inbounds [1 x i64]* %__bits, i32 0, i64 %11, !dbg !1531
  store i64 0, i64* %arrayidx20, align 8, !dbg !1531
  br label %for.inc21, !dbg !1531

for.inc21:                                        ; preds = %for.body19
  %13 = load i64* %__i, align 8, !dbg !1531
  %inc22 = add i64 %13, 1, !dbg !1531
  store i64 %inc22, i64* %__i, align 8, !dbg !1531
  br label %for.cond16, !dbg !1531

for.end23:                                        ; preds = %for.cond16
  br label %do.end, !dbg !1530

do.end:                                           ; preds = %for.end23
  store i32 0, i32* %i, align 4, !dbg !1533
  br label %for.cond24, !dbg !1533

for.cond24:                                       ; preds = %for.inc43, %do.end
  %14 = load i32* %i, align 4, !dbg !1533
  %15 = load i32* %nwords, align 4, !dbg !1533
  %sub = sub i32 %15, 1, !dbg !1533
  %cmp25 = icmp ult i32 %14, %sub, !dbg !1533
  br i1 %cmp25, label %for.body27, label %for.end45, !dbg !1533

for.body27:                                       ; preds = %for.cond24
  %16 = load i8** %buf.addr, align 8, !dbg !1535
  %17 = load i32* %i, align 4, !dbg !1535
  %idxprom28 = sext i32 %17 to i64, !dbg !1535
  %18 = load %struct._cpuset** %set.addr, align 8, !dbg !1535
  %__bits29 = getelementptr inbounds %struct._cpuset* %18, i32 0, i32 0, !dbg !1535
  %arrayidx30 = getelementptr inbounds [1 x i64]* %__bits29, i32 0, i64 %idxprom28, !dbg !1535
  %call31 = call i32 (i8*, i8*, ...)* @sscanf(i8* %16, i8* getelementptr inbounds ([5 x i8]* @.str3, i32 0, i32 0), i64* %arrayidx30) #7, !dbg !1535
  store i32 %call31, i32* %ret, align 4, !dbg !1535
  %19 = load i32* %ret, align 4, !dbg !1537
  %cmp32 = icmp eq i32 %19, 0, !dbg !1537
  br i1 %cmp32, label %if.then36, label %lor.lhs.false, !dbg !1537

lor.lhs.false:                                    ; preds = %for.body27
  %20 = load i32* %ret, align 4, !dbg !1537
  %cmp34 = icmp eq i32 %20, -1, !dbg !1537
  br i1 %cmp34, label %if.then36, label %if.end37, !dbg !1537

if.then36:                                        ; preds = %lor.lhs.false, %for.body27
  store i32 -1, i32* %retval, !dbg !1538
  br label %return, !dbg !1538

if.end37:                                         ; preds = %lor.lhs.false
  %21 = load i8** %buf.addr, align 8, !dbg !1539
  %call38 = call i8* @strstr(i8* %21, i8* getelementptr inbounds ([2 x i8]* @.str5, i32 0, i32 0)) #7, !dbg !1539
  store i8* %call38, i8** %buf.addr, align 8, !dbg !1539
  %22 = load i8** %buf.addr, align 8, !dbg !1540
  %cmp39 = icmp eq i8* %22, null, !dbg !1540
  br i1 %cmp39, label %if.then41, label %if.end42, !dbg !1540

if.then41:                                        ; preds = %if.end37
  store i32 -1, i32* %retval, !dbg !1541
  br label %return, !dbg !1541

if.end42:                                         ; preds = %if.end37
  %23 = load i8** %buf.addr, align 8, !dbg !1542
  %incdec.ptr = getelementptr inbounds i8* %23, i32 1, !dbg !1542
  store i8* %incdec.ptr, i8** %buf.addr, align 8, !dbg !1542
  br label %for.inc43, !dbg !1543

for.inc43:                                        ; preds = %if.end42
  %24 = load i32* %i, align 4, !dbg !1533
  %inc44 = add nsw i32 %24, 1, !dbg !1533
  store i32 %inc44, i32* %i, align 4, !dbg !1533
  br label %for.cond24, !dbg !1533

for.end45:                                        ; preds = %for.cond24
  %25 = load i8** %buf.addr, align 8, !dbg !1544
  %26 = load i32* %nwords, align 4, !dbg !1544
  %sub46 = sub i32 %26, 1, !dbg !1544
  %idxprom47 = zext i32 %sub46 to i64, !dbg !1544
  %27 = load %struct._cpuset** %set.addr, align 8, !dbg !1544
  %__bits48 = getelementptr inbounds %struct._cpuset* %27, i32 0, i32 0, !dbg !1544
  %arrayidx49 = getelementptr inbounds [1 x i64]* %__bits48, i32 0, i64 %idxprom47, !dbg !1544
  %call50 = call i32 (i8*, i8*, ...)* @sscanf(i8* %25, i8* getelementptr inbounds ([4 x i8]* @.str4, i32 0, i32 0), i64* %arrayidx49) #7, !dbg !1544
  store i32 %call50, i32* %ret, align 4, !dbg !1544
  %28 = load i32* %ret, align 4, !dbg !1545
  %cmp51 = icmp eq i32 %28, 0, !dbg !1545
  br i1 %cmp51, label %if.then56, label %lor.lhs.false53, !dbg !1545

lor.lhs.false53:                                  ; preds = %for.end45
  %29 = load i32* %ret, align 4, !dbg !1545
  %cmp54 = icmp eq i32 %29, -1, !dbg !1545
  br i1 %cmp54, label %if.then56, label %if.end57, !dbg !1545

if.then56:                                        ; preds = %lor.lhs.false53, %for.end45
  store i32 -1, i32* %retval, !dbg !1546
  br label %return, !dbg !1546

if.end57:                                         ; preds = %lor.lhs.false53
  store i32 0, i32* %retval, !dbg !1547
  br label %return, !dbg !1547

return:                                           ; preds = %if.end57, %if.then56, %if.then41, %if.then36, %if.then14, %if.then
  %30 = load i32* %retval, !dbg !1547
  ret i32 %30, !dbg !1547
}

; Function Attrs: noimplicitfloat noredzone
declare i64 @strlen(i8*) #3

; Function Attrs: noimplicitfloat noredzone
declare i32 @sscanf(i8*, i8*, ...) #3

; Function Attrs: noimplicitfloat noredzone
declare i8* @strstr(i8*, i8*) #3

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @cpuset_setthread(i32 %id, %struct._cpuset* %mask) #0 {
entry:
  %id.addr = alloca i32, align 4
  %mask.addr = alloca %struct._cpuset*, align 8
  %nset = alloca %struct.cpuset*, align 8
  %set = alloca %struct.cpuset*, align 8
  %td = alloca %struct.thread*, align 8
  %p = alloca %struct.proc*, align 8
  %error = alloca i32, align 4
  store i32 %id, i32* %id.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %id.addr}, metadata !1548), !dbg !1549
  store %struct._cpuset* %mask, %struct._cpuset** %mask.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct._cpuset** %mask.addr}, metadata !1550), !dbg !1549
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %nset}, metadata !1551), !dbg !1552
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %set}, metadata !1553), !dbg !1554
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td}, metadata !1555), !dbg !1556
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p}, metadata !1557), !dbg !1558
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !1559), !dbg !1560
  %0 = load %struct.uma_zone** @cpuset_zone, align 8, !dbg !1561
  %call = call i8* @uma_zalloc(%struct.uma_zone* %0, i32 2) #7, !dbg !1561
  %1 = bitcast i8* %call to %struct.cpuset*, !dbg !1561
  store %struct.cpuset* %1, %struct.cpuset** %nset, align 8, !dbg !1561
  %2 = load i32* %id.addr, align 4, !dbg !1562
  %conv = sext i32 %2 to i64, !dbg !1562
  %call1 = call i32 @cpuset_which(i32 1, i64 %conv, %struct.proc** %p, %struct.thread** %td, %struct.cpuset** %set) #7, !dbg !1562
  store i32 %call1, i32* %error, align 4, !dbg !1562
  %3 = load i32* %error, align 4, !dbg !1563
  %tobool = icmp ne i32 %3, 0, !dbg !1563
  br i1 %tobool, label %if.then, label %if.end, !dbg !1563

if.then:                                          ; preds = %entry
  br label %out, !dbg !1564

if.end:                                           ; preds = %entry
  call void (i8*, i8*, i32, i32, %struct.__tesla_locality*, ...)* @__tesla_inline_assertion(i8* getelementptr inbounds ([1 x i8]* @.emptystring, i32 0, i32 0), i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 720, i32 0, %struct.__tesla_locality* null, i32 0, i32 0, i32 1) #7, !dbg !1565
  store %struct.cpuset* null, %struct.cpuset** %set, align 8, !dbg !1566
  %4 = load %struct.thread** %td, align 8, !dbg !1567
  call void @thread_lock_flags_(%struct.thread* %4, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 723) #7, !dbg !1567
  %5 = load %struct.thread** %td, align 8, !dbg !1568
  %td_cpuset = getelementptr inbounds %struct.thread* %5, i32 0, i32 7, !dbg !1568
  %6 = load %struct.cpuset** %td_cpuset, align 8, !dbg !1568
  %7 = load %struct.cpuset** %nset, align 8, !dbg !1568
  %8 = load %struct._cpuset** %mask.addr, align 8, !dbg !1568
  %call2 = call i32 @cpuset_shadow(%struct.cpuset* %6, %struct.cpuset* %7, %struct._cpuset* %8) #7, !dbg !1568
  store i32 %call2, i32* %error, align 4, !dbg !1568
  %9 = load i32* %error, align 4, !dbg !1569
  %cmp = icmp eq i32 %9, 0, !dbg !1569
  br i1 %cmp, label %if.then4, label %if.end7, !dbg !1569

if.then4:                                         ; preds = %if.end
  %10 = load %struct.thread** %td, align 8, !dbg !1570
  %td_cpuset5 = getelementptr inbounds %struct.thread* %10, i32 0, i32 7, !dbg !1570
  %11 = load %struct.cpuset** %td_cpuset5, align 8, !dbg !1570
  store %struct.cpuset* %11, %struct.cpuset** %set, align 8, !dbg !1570
  %12 = load %struct.cpuset** %nset, align 8, !dbg !1572
  %13 = load %struct.thread** %td, align 8, !dbg !1572
  %td_cpuset6 = getelementptr inbounds %struct.thread* %13, i32 0, i32 7, !dbg !1572
  store %struct.cpuset* %12, %struct.cpuset** %td_cpuset6, align 8, !dbg !1572
  %14 = load %struct.thread** %td, align 8, !dbg !1573
  call void @sched_affinity(%struct.thread* %14) #7, !dbg !1573
  store %struct.cpuset* null, %struct.cpuset** %nset, align 8, !dbg !1574
  br label %if.end7, !dbg !1575

if.end7:                                          ; preds = %if.then4, %if.end
  %15 = load %struct.thread** %td, align 8, !dbg !1576
  %td_lock = getelementptr inbounds %struct.thread* %15, i32 0, i32 0, !dbg !1576
  %16 = load volatile %struct.mtx** %td_lock, align 8, !dbg !1576
  %mtx_lock = getelementptr inbounds %struct.mtx* %16, i32 0, i32 1, !dbg !1576
  call void @__mtx_unlock_spin_flags(i64* %mtx_lock, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 731) #7, !dbg !1576
  %17 = load %struct.proc** %p, align 8, !dbg !1577
  %p_mtx = getelementptr inbounds %struct.proc* %17, i32 0, i32 18, !dbg !1577
  %mtx_lock8 = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !1577
  call void @__mtx_unlock_flags(i64* %mtx_lock8, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 732) #7, !dbg !1577
  %18 = load %struct.cpuset** %set, align 8, !dbg !1578
  %tobool9 = icmp ne %struct.cpuset* %18, null, !dbg !1578
  br i1 %tobool9, label %if.then10, label %if.end11, !dbg !1578

if.then10:                                        ; preds = %if.end7
  %19 = load %struct.cpuset** %set, align 8, !dbg !1579
  call void @cpuset_rel(%struct.cpuset* %19) #7, !dbg !1579
  br label %if.end11, !dbg !1579

if.end11:                                         ; preds = %if.then10, %if.end7
  br label %out, !dbg !1579

out:                                              ; preds = %if.end11, %if.then
  %20 = load %struct.cpuset** %nset, align 8, !dbg !1580
  %tobool12 = icmp ne %struct.cpuset* %20, null, !dbg !1580
  br i1 %tobool12, label %if.then13, label %if.end14, !dbg !1580

if.then13:                                        ; preds = %out
  %21 = load %struct.uma_zone** @cpuset_zone, align 8, !dbg !1581
  %22 = load %struct.cpuset** %nset, align 8, !dbg !1581
  %23 = bitcast %struct.cpuset* %22 to i8*, !dbg !1581
  call void @uma_zfree(%struct.uma_zone* %21, i8* %23) #7, !dbg !1581
  br label %if.end14, !dbg !1581

if.end14:                                         ; preds = %if.then13, %out
  %24 = load i32* %error, align 4, !dbg !1582
  ret i32 %24, !dbg !1582
}

; Function Attrs: inlinehint noimplicitfloat noredzone nounwind ssp
define internal i8* @uma_zalloc(%struct.uma_zone* %zone, i32 %flags) #2 {
entry:
  %zone.addr = alloca %struct.uma_zone*, align 8
  %flags.addr = alloca i32, align 4
  store %struct.uma_zone* %zone, %struct.uma_zone** %zone.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.uma_zone** %zone.addr}, metadata !1583), !dbg !1584
  store i32 %flags, i32* %flags.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %flags.addr}, metadata !1585), !dbg !1584
  %0 = load %struct.uma_zone** %zone.addr, align 8, !dbg !1586
  %1 = load i32* %flags.addr, align 4, !dbg !1586
  %call = call i8* @uma_zalloc_arg(%struct.uma_zone* %0, i8* null, i32 %1) #7, !dbg !1586
  ret i8* %call, !dbg !1586
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define internal i32 @cpuset_which(i32 %which, i64 %id, %struct.proc** %pp, %struct.thread** %tdp, %struct.cpuset** %setp) #0 {
entry:
  %retval = alloca i32, align 4
  %which.addr = alloca i32, align 4
  %id.addr = alloca i64, align 8
  %pp.addr = alloca %struct.proc**, align 8
  %tdp.addr = alloca %struct.thread**, align 8
  %setp.addr = alloca %struct.cpuset**, align 8
  %set = alloca %struct.cpuset*, align 8
  %td = alloca %struct.thread*, align 8
  %p = alloca %struct.proc*, align 8
  %error = alloca i32, align 4
  %pr = alloca %struct.prison*, align 8
  store i32 %which, i32* %which.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %which.addr}, metadata !1588), !dbg !1589
  store i64 %id, i64* %id.addr, align 8
  call void @llvm.dbg.declare(metadata !{i64* %id.addr}, metadata !1590), !dbg !1589
  store %struct.proc** %pp, %struct.proc*** %pp.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.proc*** %pp.addr}, metadata !1591), !dbg !1589
  store %struct.thread** %tdp, %struct.thread*** %tdp.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread*** %tdp.addr}, metadata !1592), !dbg !1589
  store %struct.cpuset** %setp, %struct.cpuset*** %setp.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.cpuset*** %setp.addr}, metadata !1593), !dbg !1594
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %set}, metadata !1595), !dbg !1596
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td}, metadata !1597), !dbg !1598
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p}, metadata !1599), !dbg !1600
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !1601), !dbg !1602
  store %struct.proc* null, %struct.proc** %p, align 8, !dbg !1603
  %0 = load %struct.proc*** %pp.addr, align 8, !dbg !1603
  store %struct.proc* null, %struct.proc** %0, align 8, !dbg !1603
  store %struct.thread* null, %struct.thread** %td, align 8, !dbg !1604
  %1 = load %struct.thread*** %tdp.addr, align 8, !dbg !1604
  store %struct.thread* null, %struct.thread** %1, align 8, !dbg !1604
  store %struct.cpuset* null, %struct.cpuset** %set, align 8, !dbg !1605
  %2 = load %struct.cpuset*** %setp.addr, align 8, !dbg !1605
  store %struct.cpuset* null, %struct.cpuset** %2, align 8, !dbg !1605
  %3 = load i32* %which.addr, align 4, !dbg !1606
  switch i32 %3, label %sw.default [
    i32 2, label %sw.bb
    i32 1, label %sw.bb8
    i32 3, label %sw.bb27
    i32 5, label %sw.bb42
    i32 4, label %sw.bb54
  ], !dbg !1606

sw.bb:                                            ; preds = %entry
  %4 = load i64* %id.addr, align 8, !dbg !1607
  %cmp = icmp eq i64 %4, -1, !dbg !1607
  br i1 %cmp, label %if.then, label %if.end, !dbg !1607

if.then:                                          ; preds = %sw.bb
  %call = call %struct.thread* @__curthread() #9, !dbg !1609
  %td_proc = getelementptr inbounds %struct.thread* %call, i32 0, i32 1, !dbg !1609
  %5 = load %struct.proc** %td_proc, align 8, !dbg !1609
  %p_mtx = getelementptr inbounds %struct.proc* %5, i32 0, i32 18, !dbg !1609
  %mtx_lock = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !1609
  call void @__mtx_lock_flags(i64* %mtx_lock, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 413) #7, !dbg !1609
  %call1 = call %struct.thread* @__curthread() #9, !dbg !1611
  %td_proc2 = getelementptr inbounds %struct.thread* %call1, i32 0, i32 1, !dbg !1611
  %6 = load %struct.proc** %td_proc2, align 8, !dbg !1611
  store %struct.proc* %6, %struct.proc** %p, align 8, !dbg !1611
  br label %sw.epilog, !dbg !1612

if.end:                                           ; preds = %sw.bb
  %7 = load i64* %id.addr, align 8, !dbg !1613
  %conv = trunc i64 %7 to i32, !dbg !1613
  %call3 = call %struct.proc* @pfind(i32 %conv) #7, !dbg !1613
  store %struct.proc* %call3, %struct.proc** %p, align 8, !dbg !1613
  %cmp4 = icmp eq %struct.proc* %call3, null, !dbg !1613
  br i1 %cmp4, label %if.then6, label %if.end7, !dbg !1613

if.then6:                                         ; preds = %if.end
  store i32 3, i32* %retval, !dbg !1614
  br label %return, !dbg !1614

if.end7:                                          ; preds = %if.end
  br label %sw.epilog, !dbg !1615

sw.bb8:                                           ; preds = %entry
  %8 = load i64* %id.addr, align 8, !dbg !1616
  %cmp9 = icmp eq i64 %8, -1, !dbg !1616
  br i1 %cmp9, label %if.then11, label %if.end19, !dbg !1616

if.then11:                                        ; preds = %sw.bb8
  %call12 = call %struct.thread* @__curthread() #9, !dbg !1617
  %td_proc13 = getelementptr inbounds %struct.thread* %call12, i32 0, i32 1, !dbg !1617
  %9 = load %struct.proc** %td_proc13, align 8, !dbg !1617
  %p_mtx14 = getelementptr inbounds %struct.proc* %9, i32 0, i32 18, !dbg !1617
  %mtx_lock15 = getelementptr inbounds %struct.mtx* %p_mtx14, i32 0, i32 1, !dbg !1617
  call void @__mtx_lock_flags(i64* %mtx_lock15, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 422) #7, !dbg !1617
  %call16 = call %struct.thread* @__curthread() #9, !dbg !1619
  %td_proc17 = getelementptr inbounds %struct.thread* %call16, i32 0, i32 1, !dbg !1619
  %10 = load %struct.proc** %td_proc17, align 8, !dbg !1619
  store %struct.proc* %10, %struct.proc** %p, align 8, !dbg !1619
  %call18 = call %struct.thread* @__curthread() #9, !dbg !1620
  store %struct.thread* %call18, %struct.thread** %td, align 8, !dbg !1620
  br label %sw.epilog, !dbg !1621

if.end19:                                         ; preds = %sw.bb8
  %11 = load i64* %id.addr, align 8, !dbg !1622
  %conv20 = trunc i64 %11 to i32, !dbg !1622
  %call21 = call %struct.thread* @tdfind(i32 %conv20, i32 -1) #7, !dbg !1622
  store %struct.thread* %call21, %struct.thread** %td, align 8, !dbg !1622
  %12 = load %struct.thread** %td, align 8, !dbg !1623
  %cmp22 = icmp eq %struct.thread* %12, null, !dbg !1623
  br i1 %cmp22, label %if.then24, label %if.end25, !dbg !1623

if.then24:                                        ; preds = %if.end19
  store i32 3, i32* %retval, !dbg !1624
  br label %return, !dbg !1624

if.end25:                                         ; preds = %if.end19
  %13 = load %struct.thread** %td, align 8, !dbg !1625
  %td_proc26 = getelementptr inbounds %struct.thread* %13, i32 0, i32 1, !dbg !1625
  %14 = load %struct.proc** %td_proc26, align 8, !dbg !1625
  store %struct.proc* %14, %struct.proc** %p, align 8, !dbg !1625
  br label %sw.epilog, !dbg !1626

sw.bb27:                                          ; preds = %entry
  %15 = load i64* %id.addr, align 8, !dbg !1627
  %cmp28 = icmp eq i64 %15, -1, !dbg !1627
  br i1 %cmp28, label %if.then30, label %if.else, !dbg !1627

if.then30:                                        ; preds = %sw.bb27
  %call31 = call %struct.thread* @__curthread() #9, !dbg !1628
  call void @thread_lock_flags_(%struct.thread* %call31, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 434) #7, !dbg !1628
  %call32 = call %struct.thread* @__curthread() #9, !dbg !1630
  %td_cpuset = getelementptr inbounds %struct.thread* %call32, i32 0, i32 7, !dbg !1630
  %16 = load %struct.cpuset** %td_cpuset, align 8, !dbg !1630
  %call33 = call %struct.cpuset* @cpuset_refbase(%struct.cpuset* %16) #7, !dbg !1630
  store %struct.cpuset* %call33, %struct.cpuset** %set, align 8, !dbg !1630
  %call34 = call %struct.thread* @__curthread() #9, !dbg !1631
  %td_lock = getelementptr inbounds %struct.thread* %call34, i32 0, i32 0, !dbg !1631
  %17 = load volatile %struct.mtx** %td_lock, align 8, !dbg !1631
  %mtx_lock35 = getelementptr inbounds %struct.mtx* %17, i32 0, i32 1, !dbg !1631
  call void @__mtx_unlock_spin_flags(i64* %mtx_lock35, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 436) #7, !dbg !1631
  br label %if.end39, !dbg !1632

if.else:                                          ; preds = %sw.bb27
  %18 = load i64* %id.addr, align 8, !dbg !1633
  %conv36 = trunc i64 %18 to i32, !dbg !1633
  %call37 = call %struct.thread* @__curthread() #9, !dbg !1634
  %call38 = call %struct.cpuset* @cpuset_lookup(i32 %conv36, %struct.thread* %call37) #7, !dbg !1634
  store %struct.cpuset* %call38, %struct.cpuset** %set, align 8, !dbg !1634
  br label %if.end39

if.end39:                                         ; preds = %if.else, %if.then30
  %19 = load %struct.cpuset** %set, align 8, !dbg !1635
  %tobool = icmp ne %struct.cpuset* %19, null, !dbg !1635
  br i1 %tobool, label %if.then40, label %if.end41, !dbg !1635

if.then40:                                        ; preds = %if.end39
  %20 = load %struct.cpuset** %set, align 8, !dbg !1636
  %21 = load %struct.cpuset*** %setp.addr, align 8, !dbg !1636
  store %struct.cpuset* %20, %struct.cpuset** %21, align 8, !dbg !1636
  store i32 0, i32* %retval, !dbg !1638
  br label %return, !dbg !1638

if.end41:                                         ; preds = %if.end39
  store i32 3, i32* %retval, !dbg !1639
  br label %return, !dbg !1639

sw.bb42:                                          ; preds = %entry
  call void @llvm.dbg.declare(metadata !{%struct.prison** %pr}, metadata !1640), !dbg !1642
  %call43 = call i32 @_sx_slock(%struct.sx* @allprison_lock, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 449) #7, !dbg !1643
  %call44 = call %struct.thread* @__curthread() #9, !dbg !1644
  %td_ucred = getelementptr inbounds %struct.thread* %call44, i32 0, i32 37, !dbg !1644
  %22 = load %struct.ucred** %td_ucred, align 8, !dbg !1644
  %cr_prison = getelementptr inbounds %struct.ucred* %22, i32 0, i32 9, !dbg !1644
  %23 = load %struct.prison** %cr_prison, align 8, !dbg !1644
  %24 = load i64* %id.addr, align 8, !dbg !1644
  %conv45 = trunc i64 %24 to i32, !dbg !1644
  %call46 = call %struct.prison* @prison_find_child(%struct.prison* %23, i32 %conv45) #7, !dbg !1644
  store %struct.prison* %call46, %struct.prison** %pr, align 8, !dbg !1644
  call void @_sx_sunlock(%struct.sx* @allprison_lock, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 451) #7, !dbg !1645
  %25 = load %struct.prison** %pr, align 8, !dbg !1646
  %cmp47 = icmp eq %struct.prison* %25, null, !dbg !1646
  br i1 %cmp47, label %if.then49, label %if.end50, !dbg !1646

if.then49:                                        ; preds = %sw.bb42
  store i32 3, i32* %retval, !dbg !1647
  br label %return, !dbg !1647

if.end50:                                         ; preds = %sw.bb42
  %26 = load %struct.prison** %pr, align 8, !dbg !1648
  %pr_cpuset = getelementptr inbounds %struct.prison* %26, i32 0, i32 11, !dbg !1648
  %27 = load %struct.cpuset** %pr_cpuset, align 8, !dbg !1648
  %call51 = call %struct.cpuset* @cpuset_ref(%struct.cpuset* %27) #7, !dbg !1648
  %28 = load %struct.prison** %pr, align 8, !dbg !1649
  %pr_cpuset52 = getelementptr inbounds %struct.prison* %28, i32 0, i32 11, !dbg !1649
  %29 = load %struct.cpuset** %pr_cpuset52, align 8, !dbg !1649
  %30 = load %struct.cpuset*** %setp.addr, align 8, !dbg !1649
  store %struct.cpuset* %29, %struct.cpuset** %30, align 8, !dbg !1649
  %31 = load %struct.prison** %pr, align 8, !dbg !1650
  %pr_mtx = getelementptr inbounds %struct.prison* %31, i32 0, i32 8, !dbg !1650
  %mtx_lock53 = getelementptr inbounds %struct.mtx* %pr_mtx, i32 0, i32 1, !dbg !1650
  call void @__mtx_unlock_flags(i64* %mtx_lock53, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 456) #7, !dbg !1650
  store i32 0, i32* %retval, !dbg !1651
  br label %return, !dbg !1651

sw.bb54:                                          ; preds = %entry
  store i32 0, i32* %retval, !dbg !1652
  br label %return, !dbg !1652

sw.default:                                       ; preds = %entry
  store i32 22, i32* %retval, !dbg !1653
  br label %return, !dbg !1653

sw.epilog:                                        ; preds = %if.end25, %if.then11, %if.end7, %if.then
  %call55 = call %struct.thread* @__curthread() #9, !dbg !1654
  %32 = load %struct.proc** %p, align 8, !dbg !1654
  %call56 = call i32 @p_cansched(%struct.thread* %call55, %struct.proc* %32) #7, !dbg !1654
  store i32 %call56, i32* %error, align 4, !dbg !1654
  %33 = load i32* %error, align 4, !dbg !1655
  %tobool57 = icmp ne i32 %33, 0, !dbg !1655
  br i1 %tobool57, label %if.then58, label %if.end61, !dbg !1655

if.then58:                                        ; preds = %sw.epilog
  %34 = load %struct.proc** %p, align 8, !dbg !1656
  %p_mtx59 = getelementptr inbounds %struct.proc* %34, i32 0, i32 18, !dbg !1656
  %mtx_lock60 = getelementptr inbounds %struct.mtx* %p_mtx59, i32 0, i32 1, !dbg !1656
  call void @__mtx_unlock_flags(i64* %mtx_lock60, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 466) #7, !dbg !1656
  %35 = load i32* %error, align 4, !dbg !1658
  store i32 %35, i32* %retval, !dbg !1658
  br label %return, !dbg !1658

if.end61:                                         ; preds = %sw.epilog
  %36 = load %struct.thread** %td, align 8, !dbg !1659
  %cmp62 = icmp eq %struct.thread* %36, null, !dbg !1659
  br i1 %cmp62, label %if.then64, label %if.end65, !dbg !1659

if.then64:                                        ; preds = %if.end61
  %37 = load %struct.proc** %p, align 8, !dbg !1660
  %p_threads = getelementptr inbounds %struct.proc* %37, i32 0, i32 1, !dbg !1660
  %tqh_first = getelementptr inbounds %struct.anon.1* %p_threads, i32 0, i32 0, !dbg !1660
  %38 = load %struct.thread** %tqh_first, align 8, !dbg !1660
  store %struct.thread* %38, %struct.thread** %td, align 8, !dbg !1660
  br label %if.end65, !dbg !1660

if.end65:                                         ; preds = %if.then64, %if.end61
  %39 = load %struct.proc** %p, align 8, !dbg !1661
  %40 = load %struct.proc*** %pp.addr, align 8, !dbg !1661
  store %struct.proc* %39, %struct.proc** %40, align 8, !dbg !1661
  %41 = load %struct.thread** %td, align 8, !dbg !1662
  %42 = load %struct.thread*** %tdp.addr, align 8, !dbg !1662
  store %struct.thread* %41, %struct.thread** %42, align 8, !dbg !1662
  store i32 0, i32* %retval, !dbg !1663
  br label %return, !dbg !1663

return:                                           ; preds = %if.end65, %if.then58, %sw.default, %sw.bb54, %if.end50, %if.then49, %if.end41, %if.then40, %if.then24, %if.then6
  %43 = load i32* %retval, !dbg !1664
  ret i32 %43, !dbg !1664
}

; Function Attrs: noimplicitfloat noredzone
declare void @__tesla_inline_assertion(i8*, i8*, i32, i32, %struct.__tesla_locality*, ...) #3

; Function Attrs: noimplicitfloat noredzone
declare void @thread_lock_flags_(%struct.thread*, i32, i8*, i32) #3

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define internal i32 @cpuset_shadow(%struct.cpuset* %set, %struct.cpuset* %fset, %struct._cpuset* %mask) #0 {
entry:
  %retval = alloca i32, align 4
  %set.addr = alloca %struct.cpuset*, align 8
  %fset.addr = alloca %struct.cpuset*, align 8
  %mask.addr = alloca %struct._cpuset*, align 8
  %parent = alloca %struct.cpuset*, align 8
  %__i = alloca i64, align 8
  store %struct.cpuset* %set, %struct.cpuset** %set.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %set.addr}, metadata !1665), !dbg !1666
  store %struct.cpuset* %fset, %struct.cpuset** %fset.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %fset.addr}, metadata !1667), !dbg !1666
  store %struct._cpuset* %mask, %struct._cpuset** %mask.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct._cpuset** %mask.addr}, metadata !1668), !dbg !1666
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %parent}, metadata !1669), !dbg !1671
  %0 = load %struct.cpuset** %set.addr, align 8, !dbg !1672
  %cs_id = getelementptr inbounds %struct.cpuset* %0, i32 0, i32 3, !dbg !1672
  %1 = load i32* %cs_id, align 4, !dbg !1672
  %cmp = icmp eq i32 %1, -1, !dbg !1672
  br i1 %cmp, label %if.then, label %if.else, !dbg !1672

if.then:                                          ; preds = %entry
  %2 = load %struct.cpuset** %set.addr, align 8, !dbg !1673
  %cs_parent = getelementptr inbounds %struct.cpuset* %2, i32 0, i32 4, !dbg !1673
  %3 = load %struct.cpuset** %cs_parent, align 8, !dbg !1673
  store %struct.cpuset* %3, %struct.cpuset** %parent, align 8, !dbg !1673
  br label %if.end, !dbg !1673

if.else:                                          ; preds = %entry
  %4 = load %struct.cpuset** %set.addr, align 8, !dbg !1674
  store %struct.cpuset* %4, %struct.cpuset** %parent, align 8, !dbg !1674
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  call void @llvm.dbg.declare(metadata !{i64* %__i}, metadata !1675), !dbg !1677
  store i64 0, i64* %__i, align 8, !dbg !1678
  br label %for.cond, !dbg !1678

for.cond:                                         ; preds = %for.inc, %if.end
  %5 = load i64* %__i, align 8, !dbg !1678
  %cmp1 = icmp ult i64 %5, 1, !dbg !1678
  br i1 %cmp1, label %for.body, label %for.end, !dbg !1678

for.body:                                         ; preds = %for.cond
  %6 = load i64* %__i, align 8, !dbg !1678
  %7 = load %struct._cpuset** %mask.addr, align 8, !dbg !1678
  %__bits = getelementptr inbounds %struct._cpuset* %7, i32 0, i32 0, !dbg !1678
  %arrayidx = getelementptr inbounds [1 x i64]* %__bits, i32 0, i64 %6, !dbg !1678
  %8 = load i64* %arrayidx, align 8, !dbg !1678
  %9 = load i64* %__i, align 8, !dbg !1678
  %10 = load %struct.cpuset** %parent, align 8, !dbg !1678
  %cs_mask = getelementptr inbounds %struct.cpuset* %10, i32 0, i32 0, !dbg !1678
  %__bits2 = getelementptr inbounds %struct._cpuset* %cs_mask, i32 0, i32 0, !dbg !1678
  %arrayidx3 = getelementptr inbounds [1 x i64]* %__bits2, i32 0, i64 %9, !dbg !1678
  %11 = load i64* %arrayidx3, align 8, !dbg !1678
  %and = and i64 %8, %11, !dbg !1678
  %12 = load i64* %__i, align 8, !dbg !1678
  %13 = load %struct._cpuset** %mask.addr, align 8, !dbg !1678
  %__bits4 = getelementptr inbounds %struct._cpuset* %13, i32 0, i32 0, !dbg !1678
  %arrayidx5 = getelementptr inbounds [1 x i64]* %__bits4, i32 0, i64 %12, !dbg !1678
  %14 = load i64* %arrayidx5, align 8, !dbg !1678
  %cmp6 = icmp ne i64 %and, %14, !dbg !1678
  br i1 %cmp6, label %if.then7, label %if.end8, !dbg !1678

if.then7:                                         ; preds = %for.body
  br label %for.end, !dbg !1678

if.end8:                                          ; preds = %for.body
  br label %for.inc, !dbg !1678

for.inc:                                          ; preds = %if.end8
  %15 = load i64* %__i, align 8, !dbg !1678
  %inc = add i64 %15, 1, !dbg !1678
  store i64 %inc, i64* %__i, align 8, !dbg !1678
  br label %for.cond, !dbg !1678

for.end:                                          ; preds = %if.then7, %for.cond
  %16 = load i64* %__i, align 8, !dbg !1678
  %cmp9 = icmp eq i64 %16, 1, !dbg !1678
  br i1 %cmp9, label %if.end11, label %if.then10, !dbg !1677

if.then10:                                        ; preds = %for.end
  store i32 11, i32* %retval, !dbg !1680
  br label %return, !dbg !1680

if.end11:                                         ; preds = %for.end
  %17 = load %struct.cpuset** %fset.addr, align 8, !dbg !1681
  %18 = load %struct.cpuset** %parent, align 8, !dbg !1681
  %19 = load %struct._cpuset** %mask.addr, align 8, !dbg !1681
  %call = call i32 @_cpuset_create(%struct.cpuset* %17, %struct.cpuset* %18, %struct._cpuset* %19, i32 -1) #7, !dbg !1681
  store i32 %call, i32* %retval, !dbg !1681
  br label %return, !dbg !1681

return:                                           ; preds = %if.end11, %if.then10
  %20 = load i32* %retval, !dbg !1682
  ret i32 %20, !dbg !1682
}

; Function Attrs: noimplicitfloat noredzone
declare void @sched_affinity(%struct.thread*) #3

; Function Attrs: noimplicitfloat noredzone
declare void @__mtx_unlock_flags(i64*, i32, i8*, i32) #3

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define %struct.cpuset* @cpuset_thread0() #0 {
entry:
  %set = alloca %struct.cpuset*, align 8
  %error = alloca i32, align 4
  %__i = alloca i64, align 8
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %set}, metadata !1683), !dbg !1684
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !1685), !dbg !1686
  %call = call %struct.uma_zone* @uma_zcreate(i8* getelementptr inbounds ([7 x i8]* @.str6, i32 0, i32 0), i64 72, i32 (i8*, i32, i8*, i32)* null, void (i8*, i32, i8*)* null, i32 (i8*, i32, i32)* null, void (i8*, i32)* null, i32 7, i32 0) #7, !dbg !1687
  store %struct.uma_zone* %call, %struct.uma_zone** @cpuset_zone, align 8, !dbg !1687
  call void @_mtx_init(i64* getelementptr inbounds (%struct.mtx* @cpuset_lock, i32 0, i32 1), i8* getelementptr inbounds ([7 x i8]* @.str6, i32 0, i32 0), i8* null, i32 5) #7, !dbg !1688
  %0 = load %struct.uma_zone** @cpuset_zone, align 8, !dbg !1689
  %call1 = call i8* @uma_zalloc(%struct.uma_zone* %0, i32 258) #7, !dbg !1689
  %1 = bitcast i8* %call1 to %struct.cpuset*, !dbg !1689
  store %struct.cpuset* %1, %struct.cpuset** %set, align 8, !dbg !1689
  br label %do.body, !dbg !1690

do.body:                                          ; preds = %entry
  call void @llvm.dbg.declare(metadata !{i64* %__i}, metadata !1691), !dbg !1693
  store i64 0, i64* %__i, align 8, !dbg !1694
  br label %for.cond, !dbg !1694

for.cond:                                         ; preds = %for.inc, %do.body
  %2 = load i64* %__i, align 8, !dbg !1694
  %cmp = icmp ult i64 %2, 1, !dbg !1694
  br i1 %cmp, label %for.body, label %for.end, !dbg !1694

for.body:                                         ; preds = %for.cond
  %3 = load i64* %__i, align 8, !dbg !1694
  %4 = load %struct.cpuset** %set, align 8, !dbg !1694
  %cs_mask = getelementptr inbounds %struct.cpuset* %4, i32 0, i32 0, !dbg !1694
  %__bits = getelementptr inbounds %struct._cpuset* %cs_mask, i32 0, i32 0, !dbg !1694
  %arrayidx = getelementptr inbounds [1 x i64]* %__bits, i32 0, i64 %3, !dbg !1694
  store i64 -1, i64* %arrayidx, align 8, !dbg !1694
  br label %for.inc, !dbg !1694

for.inc:                                          ; preds = %for.body
  %5 = load i64* %__i, align 8, !dbg !1694
  %inc = add i64 %5, 1, !dbg !1694
  store i64 %inc, i64* %__i, align 8, !dbg !1694
  br label %for.cond, !dbg !1694

for.end:                                          ; preds = %for.cond
  br label %do.end, !dbg !1693

do.end:                                           ; preds = %for.end
  br label %do.body2, !dbg !1696

do.body2:                                         ; preds = %do.end
  %6 = load %struct.cpuset** %set, align 8, !dbg !1697
  %cs_children = getelementptr inbounds %struct.cpuset* %6, i32 0, i32 7, !dbg !1697
  %lh_first = getelementptr inbounds %struct.setlist* %cs_children, i32 0, i32 0, !dbg !1697
  store %struct.cpuset* null, %struct.cpuset** %lh_first, align 8, !dbg !1697
  br label %do.end3, !dbg !1697

do.end3:                                          ; preds = %do.body2
  br label %do.body4, !dbg !1699

do.body4:                                         ; preds = %do.end3
  br label %do.body5, !dbg !1700

do.body5:                                         ; preds = %do.body4
  %7 = load %struct.cpuset** getelementptr inbounds (%struct.setlist* @cpuset_ids, i32 0, i32 0), align 8, !dbg !1702
  %cmp6 = icmp ne %struct.cpuset* %7, null, !dbg !1702
  br i1 %cmp6, label %land.lhs.true, label %if.end, !dbg !1702

land.lhs.true:                                    ; preds = %do.body5
  %8 = load %struct.cpuset** getelementptr inbounds (%struct.setlist* @cpuset_ids, i32 0, i32 0), align 8, !dbg !1702
  %cs_link = getelementptr inbounds %struct.cpuset* %8, i32 0, i32 5, !dbg !1702
  %le_prev = getelementptr inbounds %struct.anon.7* %cs_link, i32 0, i32 1, !dbg !1702
  %9 = load %struct.cpuset*** %le_prev, align 8, !dbg !1702
  %cmp7 = icmp ne %struct.cpuset** %9, getelementptr inbounds (%struct.setlist* @cpuset_ids, i32 0, i32 0), !dbg !1702
  br i1 %cmp7, label %if.then, label %if.end, !dbg !1702

if.then:                                          ; preds = %land.lhs.true
  call void (i8*, ...)* @panic(i8* getelementptr inbounds ([37 x i8]* @.str7, i32 0, i32 0), %struct.setlist* @cpuset_ids) #8, !dbg !1702
  unreachable, !dbg !1702

if.end:                                           ; preds = %land.lhs.true, %do.body5
  br label %do.end8, !dbg !1702

do.end8:                                          ; preds = %if.end
  %10 = load %struct.cpuset** getelementptr inbounds (%struct.setlist* @cpuset_ids, i32 0, i32 0), align 8, !dbg !1700
  %11 = load %struct.cpuset** %set, align 8, !dbg !1700
  %cs_link9 = getelementptr inbounds %struct.cpuset* %11, i32 0, i32 5, !dbg !1700
  %le_next = getelementptr inbounds %struct.anon.7* %cs_link9, i32 0, i32 0, !dbg !1700
  store %struct.cpuset* %10, %struct.cpuset** %le_next, align 8, !dbg !1700
  %cmp10 = icmp ne %struct.cpuset* %10, null, !dbg !1700
  br i1 %cmp10, label %if.then11, label %if.end16, !dbg !1700

if.then11:                                        ; preds = %do.end8
  %12 = load %struct.cpuset** %set, align 8, !dbg !1700
  %cs_link12 = getelementptr inbounds %struct.cpuset* %12, i32 0, i32 5, !dbg !1700
  %le_next13 = getelementptr inbounds %struct.anon.7* %cs_link12, i32 0, i32 0, !dbg !1700
  %13 = load %struct.cpuset** getelementptr inbounds (%struct.setlist* @cpuset_ids, i32 0, i32 0), align 8, !dbg !1700
  %cs_link14 = getelementptr inbounds %struct.cpuset* %13, i32 0, i32 5, !dbg !1700
  %le_prev15 = getelementptr inbounds %struct.anon.7* %cs_link14, i32 0, i32 1, !dbg !1700
  store %struct.cpuset** %le_next13, %struct.cpuset*** %le_prev15, align 8, !dbg !1700
  br label %if.end16, !dbg !1700

if.end16:                                         ; preds = %if.then11, %do.end8
  %14 = load %struct.cpuset** %set, align 8, !dbg !1700
  store %struct.cpuset* %14, %struct.cpuset** getelementptr inbounds (%struct.setlist* @cpuset_ids, i32 0, i32 0), align 8, !dbg !1700
  %15 = load %struct.cpuset** %set, align 8, !dbg !1700
  %cs_link17 = getelementptr inbounds %struct.cpuset* %15, i32 0, i32 5, !dbg !1700
  %le_prev18 = getelementptr inbounds %struct.anon.7* %cs_link17, i32 0, i32 1, !dbg !1700
  store %struct.cpuset** getelementptr inbounds (%struct.setlist* @cpuset_ids, i32 0, i32 0), %struct.cpuset*** %le_prev18, align 8, !dbg !1700
  br label %do.end19, !dbg !1700

do.end19:                                         ; preds = %if.end16
  %16 = load %struct.cpuset** %set, align 8, !dbg !1704
  %cs_ref = getelementptr inbounds %struct.cpuset* %16, i32 0, i32 1, !dbg !1704
  store volatile i32 1, i32* %cs_ref, align 4, !dbg !1704
  %17 = load %struct.cpuset** %set, align 8, !dbg !1705
  %cs_flags = getelementptr inbounds %struct.cpuset* %17, i32 0, i32 2, !dbg !1705
  store i32 1, i32* %cs_flags, align 4, !dbg !1705
  %18 = load %struct.cpuset** %set, align 8, !dbg !1706
  store %struct.cpuset* %18, %struct.cpuset** @cpuset_zero, align 8, !dbg !1706
  %19 = load %struct.cpuset** %set, align 8, !dbg !1707
  %cs_mask20 = getelementptr inbounds %struct.cpuset* %19, i32 0, i32 0, !dbg !1707
  store %struct._cpuset* %cs_mask20, %struct._cpuset** @cpuset_root, align 8, !dbg !1707
  %20 = load %struct.uma_zone** @cpuset_zone, align 8, !dbg !1708
  %call21 = call i8* @uma_zalloc(%struct.uma_zone* %20, i32 2) #7, !dbg !1708
  %21 = bitcast i8* %call21 to %struct.cpuset*, !dbg !1708
  store %struct.cpuset* %21, %struct.cpuset** %set, align 8, !dbg !1708
  %22 = load %struct.cpuset** %set, align 8, !dbg !1709
  %23 = load %struct.cpuset** @cpuset_zero, align 8, !dbg !1709
  %24 = load %struct.cpuset** @cpuset_zero, align 8, !dbg !1709
  %cs_mask22 = getelementptr inbounds %struct.cpuset* %24, i32 0, i32 0, !dbg !1709
  %call23 = call i32 @_cpuset_create(%struct.cpuset* %22, %struct.cpuset* %23, %struct._cpuset* %cs_mask22, i32 1) #7, !dbg !1709
  store i32 %call23, i32* %error, align 4, !dbg !1709
  br label %do.body24, !dbg !1710

do.body24:                                        ; preds = %do.end19
  %25 = load i32* %error, align 4, !dbg !1711
  %cmp25 = icmp eq i32 %25, 0, !dbg !1711
  %lnot = xor i1 %cmp25, true, !dbg !1711
  %lnot.ext = zext i1 %lnot to i32, !dbg !1711
  %conv = sext i32 %lnot.ext to i64, !dbg !1711
  %expval = call i64 @llvm.expect.i64(i64 %conv, i64 0), !dbg !1711
  %tobool = icmp ne i64 %expval, 0, !dbg !1711
  br i1 %tobool, label %if.then26, label %if.end27, !dbg !1711

if.then26:                                        ; preds = %do.body24
  %26 = load i32* %error, align 4, !dbg !1711
  call void (i8*, ...)* @kassert_panic(i8* getelementptr inbounds ([32 x i8]* @.str8, i32 0, i32 0), i32 %26) #7, !dbg !1711
  br label %if.end27, !dbg !1711

if.end27:                                         ; preds = %if.then26, %do.body24
  br label %do.end28, !dbg !1711

do.end28:                                         ; preds = %if.end27
  %call29 = call %struct.unrhdr* @new_unrhdr(i32 2, i32 2147483647, %struct.mtx* null) #7, !dbg !1713
  store %struct.unrhdr* %call29, %struct.unrhdr** @cpuset_unr, align 8, !dbg !1713
  %27 = load %struct.cpuset** %set, align 8, !dbg !1714
  ret %struct.cpuset* %27, !dbg !1714
}

; Function Attrs: noimplicitfloat noredzone
declare %struct.uma_zone* @uma_zcreate(i8*, i64, i32 (i8*, i32, i8*, i32)*, void (i8*, i32, i8*)*, i32 (i8*, i32, i32)*, void (i8*, i32)*, i32, i32) #3

; Function Attrs: noimplicitfloat noredzone
declare void @_mtx_init(i64*, i8*, i8*, i32) #3

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define internal i32 @_cpuset_create(%struct.cpuset* %set, %struct.cpuset* %parent, %struct._cpuset* %mask, i32 %id) #0 {
entry:
  %retval = alloca i32, align 4
  %set.addr = alloca %struct.cpuset*, align 8
  %parent.addr = alloca %struct.cpuset*, align 8
  %mask.addr = alloca %struct._cpuset*, align 8
  %id.addr = alloca i32, align 4
  %__i = alloca i64, align 8
  %__i9 = alloca i64, align 8
  store %struct.cpuset* %set, %struct.cpuset** %set.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %set.addr}, metadata !1715), !dbg !1716
  store %struct.cpuset* %parent, %struct.cpuset** %parent.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %parent.addr}, metadata !1717), !dbg !1716
  store %struct._cpuset* %mask, %struct._cpuset** %mask.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct._cpuset** %mask.addr}, metadata !1718), !dbg !1716
  store i32 %id, i32* %id.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %id.addr}, metadata !1719), !dbg !1720
  call void @llvm.dbg.declare(metadata !{i64* %__i}, metadata !1721), !dbg !1723
  store i64 0, i64* %__i, align 8, !dbg !1724
  br label %for.cond, !dbg !1724

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i64* %__i, align 8, !dbg !1724
  %cmp = icmp ult i64 %0, 1, !dbg !1724
  br i1 %cmp, label %for.body, label %for.end, !dbg !1724

for.body:                                         ; preds = %for.cond
  %1 = load i64* %__i, align 8, !dbg !1724
  %2 = load %struct._cpuset** %mask.addr, align 8, !dbg !1724
  %__bits = getelementptr inbounds %struct._cpuset* %2, i32 0, i32 0, !dbg !1724
  %arrayidx = getelementptr inbounds [1 x i64]* %__bits, i32 0, i64 %1, !dbg !1724
  %3 = load i64* %arrayidx, align 8, !dbg !1724
  %4 = load i64* %__i, align 8, !dbg !1724
  %5 = load %struct.cpuset** %parent.addr, align 8, !dbg !1724
  %cs_mask = getelementptr inbounds %struct.cpuset* %5, i32 0, i32 0, !dbg !1724
  %__bits1 = getelementptr inbounds %struct._cpuset* %cs_mask, i32 0, i32 0, !dbg !1724
  %arrayidx2 = getelementptr inbounds [1 x i64]* %__bits1, i32 0, i64 %4, !dbg !1724
  %6 = load i64* %arrayidx2, align 8, !dbg !1724
  %and = and i64 %3, %6, !dbg !1724
  %cmp3 = icmp ne i64 %and, 0, !dbg !1724
  br i1 %cmp3, label %if.then, label %if.end, !dbg !1724

if.then:                                          ; preds = %for.body
  br label %for.end, !dbg !1724

if.end:                                           ; preds = %for.body
  br label %for.inc, !dbg !1724

for.inc:                                          ; preds = %if.end
  %7 = load i64* %__i, align 8, !dbg !1724
  %inc = add i64 %7, 1, !dbg !1724
  store i64 %inc, i64* %__i, align 8, !dbg !1724
  br label %for.cond, !dbg !1724

for.end:                                          ; preds = %if.then, %for.cond
  %8 = load i64* %__i, align 8, !dbg !1724
  %cmp4 = icmp ne i64 %8, 1, !dbg !1724
  br i1 %cmp4, label %if.end6, label %if.then5, !dbg !1723

if.then5:                                         ; preds = %for.end
  store i32 11, i32* %retval, !dbg !1726
  br label %return, !dbg !1726

if.end6:                                          ; preds = %for.end
  %9 = load %struct.cpuset** %set.addr, align 8, !dbg !1727
  %cs_mask7 = getelementptr inbounds %struct.cpuset* %9, i32 0, i32 0, !dbg !1727
  %10 = load %struct._cpuset** %mask.addr, align 8, !dbg !1727
  %11 = bitcast %struct._cpuset* %cs_mask7 to i8*, !dbg !1727
  %12 = bitcast %struct._cpuset* %10 to i8*, !dbg !1727
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %11, i8* %12, i64 8, i32 8, i1 false), !dbg !1727
  br label %do.body, !dbg !1728

do.body:                                          ; preds = %if.end6
  %13 = load %struct.cpuset** %set.addr, align 8, !dbg !1729
  %cs_children = getelementptr inbounds %struct.cpuset* %13, i32 0, i32 7, !dbg !1729
  %lh_first = getelementptr inbounds %struct.setlist* %cs_children, i32 0, i32 0, !dbg !1729
  store %struct.cpuset* null, %struct.cpuset** %lh_first, align 8, !dbg !1729
  br label %do.end, !dbg !1729

do.end:                                           ; preds = %do.body
  %14 = load %struct.cpuset** %set.addr, align 8, !dbg !1731
  %cs_ref = getelementptr inbounds %struct.cpuset* %14, i32 0, i32 1, !dbg !1731
  call void @refcount_init(i32* %cs_ref, i32 1) #7, !dbg !1731
  %15 = load %struct.cpuset** %set.addr, align 8, !dbg !1732
  %cs_flags = getelementptr inbounds %struct.cpuset* %15, i32 0, i32 2, !dbg !1732
  store i32 0, i32* %cs_flags, align 4, !dbg !1732
  call void @__mtx_lock_spin_flags(i64* getelementptr inbounds (%struct.mtx* @cpuset_lock, i32 0, i32 1), i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 266) #7, !dbg !1733
  br label %do.body8, !dbg !1734

do.body8:                                         ; preds = %do.end
  call void @llvm.dbg.declare(metadata !{i64* %__i9}, metadata !1735), !dbg !1737
  store i64 0, i64* %__i9, align 8, !dbg !1738
  br label %for.cond10, !dbg !1738

for.cond10:                                       ; preds = %for.inc20, %do.body8
  %16 = load i64* %__i9, align 8, !dbg !1738
  %cmp11 = icmp ult i64 %16, 1, !dbg !1738
  br i1 %cmp11, label %for.body12, label %for.end22, !dbg !1738

for.body12:                                       ; preds = %for.cond10
  %17 = load i64* %__i9, align 8, !dbg !1738
  %18 = load %struct.cpuset** %parent.addr, align 8, !dbg !1738
  %cs_mask13 = getelementptr inbounds %struct.cpuset* %18, i32 0, i32 0, !dbg !1738
  %__bits14 = getelementptr inbounds %struct._cpuset* %cs_mask13, i32 0, i32 0, !dbg !1738
  %arrayidx15 = getelementptr inbounds [1 x i64]* %__bits14, i32 0, i64 %17, !dbg !1738
  %19 = load i64* %arrayidx15, align 8, !dbg !1738
  %20 = load i64* %__i9, align 8, !dbg !1738
  %21 = load %struct.cpuset** %set.addr, align 8, !dbg !1738
  %cs_mask16 = getelementptr inbounds %struct.cpuset* %21, i32 0, i32 0, !dbg !1738
  %__bits17 = getelementptr inbounds %struct._cpuset* %cs_mask16, i32 0, i32 0, !dbg !1738
  %arrayidx18 = getelementptr inbounds [1 x i64]* %__bits17, i32 0, i64 %20, !dbg !1738
  %22 = load i64* %arrayidx18, align 8, !dbg !1738
  %and19 = and i64 %22, %19, !dbg !1738
  store i64 %and19, i64* %arrayidx18, align 8, !dbg !1738
  br label %for.inc20, !dbg !1738

for.inc20:                                        ; preds = %for.body12
  %23 = load i64* %__i9, align 8, !dbg !1738
  %inc21 = add i64 %23, 1, !dbg !1738
  store i64 %inc21, i64* %__i9, align 8, !dbg !1738
  br label %for.cond10, !dbg !1738

for.end22:                                        ; preds = %for.cond10
  br label %do.end23, !dbg !1737

do.end23:                                         ; preds = %for.end22
  %24 = load i32* %id.addr, align 4, !dbg !1740
  %25 = load %struct.cpuset** %set.addr, align 8, !dbg !1740
  %cs_id = getelementptr inbounds %struct.cpuset* %25, i32 0, i32 3, !dbg !1740
  store i32 %24, i32* %cs_id, align 4, !dbg !1740
  %26 = load %struct.cpuset** %parent.addr, align 8, !dbg !1741
  %call = call %struct.cpuset* @cpuset_ref(%struct.cpuset* %26) #7, !dbg !1741
  %27 = load %struct.cpuset** %set.addr, align 8, !dbg !1741
  %cs_parent = getelementptr inbounds %struct.cpuset* %27, i32 0, i32 4, !dbg !1741
  store %struct.cpuset* %call, %struct.cpuset** %cs_parent, align 8, !dbg !1741
  br label %do.body24, !dbg !1742

do.body24:                                        ; preds = %do.end23
  br label %do.body25, !dbg !1743

do.body25:                                        ; preds = %do.body24
  %28 = load %struct.cpuset** %parent.addr, align 8, !dbg !1745
  %cs_children26 = getelementptr inbounds %struct.cpuset* %28, i32 0, i32 7, !dbg !1745
  %lh_first27 = getelementptr inbounds %struct.setlist* %cs_children26, i32 0, i32 0, !dbg !1745
  %29 = load %struct.cpuset** %lh_first27, align 8, !dbg !1745
  %cmp28 = icmp ne %struct.cpuset* %29, null, !dbg !1745
  br i1 %cmp28, label %land.lhs.true, label %if.end36, !dbg !1745

land.lhs.true:                                    ; preds = %do.body25
  %30 = load %struct.cpuset** %parent.addr, align 8, !dbg !1745
  %cs_children29 = getelementptr inbounds %struct.cpuset* %30, i32 0, i32 7, !dbg !1745
  %lh_first30 = getelementptr inbounds %struct.setlist* %cs_children29, i32 0, i32 0, !dbg !1745
  %31 = load %struct.cpuset** %lh_first30, align 8, !dbg !1745
  %cs_siblings = getelementptr inbounds %struct.cpuset* %31, i32 0, i32 6, !dbg !1745
  %le_prev = getelementptr inbounds %struct.anon.8* %cs_siblings, i32 0, i32 1, !dbg !1745
  %32 = load %struct.cpuset*** %le_prev, align 8, !dbg !1745
  %33 = load %struct.cpuset** %parent.addr, align 8, !dbg !1745
  %cs_children31 = getelementptr inbounds %struct.cpuset* %33, i32 0, i32 7, !dbg !1745
  %lh_first32 = getelementptr inbounds %struct.setlist* %cs_children31, i32 0, i32 0, !dbg !1745
  %cmp33 = icmp ne %struct.cpuset** %32, %lh_first32, !dbg !1745
  br i1 %cmp33, label %if.then34, label %if.end36, !dbg !1745

if.then34:                                        ; preds = %land.lhs.true
  %34 = load %struct.cpuset** %parent.addr, align 8, !dbg !1745
  %cs_children35 = getelementptr inbounds %struct.cpuset* %34, i32 0, i32 7, !dbg !1745
  call void (i8*, ...)* @panic(i8* getelementptr inbounds ([37 x i8]* @.str7, i32 0, i32 0), %struct.setlist* %cs_children35) #8, !dbg !1745
  unreachable, !dbg !1745

if.end36:                                         ; preds = %land.lhs.true, %do.body25
  br label %do.end37, !dbg !1745

do.end37:                                         ; preds = %if.end36
  %35 = load %struct.cpuset** %parent.addr, align 8, !dbg !1743
  %cs_children38 = getelementptr inbounds %struct.cpuset* %35, i32 0, i32 7, !dbg !1743
  %lh_first39 = getelementptr inbounds %struct.setlist* %cs_children38, i32 0, i32 0, !dbg !1743
  %36 = load %struct.cpuset** %lh_first39, align 8, !dbg !1743
  %37 = load %struct.cpuset** %set.addr, align 8, !dbg !1743
  %cs_siblings40 = getelementptr inbounds %struct.cpuset* %37, i32 0, i32 6, !dbg !1743
  %le_next = getelementptr inbounds %struct.anon.8* %cs_siblings40, i32 0, i32 0, !dbg !1743
  store %struct.cpuset* %36, %struct.cpuset** %le_next, align 8, !dbg !1743
  %cmp41 = icmp ne %struct.cpuset* %36, null, !dbg !1743
  br i1 %cmp41, label %if.then42, label %if.end49, !dbg !1743

if.then42:                                        ; preds = %do.end37
  %38 = load %struct.cpuset** %set.addr, align 8, !dbg !1743
  %cs_siblings43 = getelementptr inbounds %struct.cpuset* %38, i32 0, i32 6, !dbg !1743
  %le_next44 = getelementptr inbounds %struct.anon.8* %cs_siblings43, i32 0, i32 0, !dbg !1743
  %39 = load %struct.cpuset** %parent.addr, align 8, !dbg !1743
  %cs_children45 = getelementptr inbounds %struct.cpuset* %39, i32 0, i32 7, !dbg !1743
  %lh_first46 = getelementptr inbounds %struct.setlist* %cs_children45, i32 0, i32 0, !dbg !1743
  %40 = load %struct.cpuset** %lh_first46, align 8, !dbg !1743
  %cs_siblings47 = getelementptr inbounds %struct.cpuset* %40, i32 0, i32 6, !dbg !1743
  %le_prev48 = getelementptr inbounds %struct.anon.8* %cs_siblings47, i32 0, i32 1, !dbg !1743
  store %struct.cpuset** %le_next44, %struct.cpuset*** %le_prev48, align 8, !dbg !1743
  br label %if.end49, !dbg !1743

if.end49:                                         ; preds = %if.then42, %do.end37
  %41 = load %struct.cpuset** %set.addr, align 8, !dbg !1743
  %42 = load %struct.cpuset** %parent.addr, align 8, !dbg !1743
  %cs_children50 = getelementptr inbounds %struct.cpuset* %42, i32 0, i32 7, !dbg !1743
  %lh_first51 = getelementptr inbounds %struct.setlist* %cs_children50, i32 0, i32 0, !dbg !1743
  store %struct.cpuset* %41, %struct.cpuset** %lh_first51, align 8, !dbg !1743
  %43 = load %struct.cpuset** %parent.addr, align 8, !dbg !1743
  %cs_children52 = getelementptr inbounds %struct.cpuset* %43, i32 0, i32 7, !dbg !1743
  %lh_first53 = getelementptr inbounds %struct.setlist* %cs_children52, i32 0, i32 0, !dbg !1743
  %44 = load %struct.cpuset** %set.addr, align 8, !dbg !1743
  %cs_siblings54 = getelementptr inbounds %struct.cpuset* %44, i32 0, i32 6, !dbg !1743
  %le_prev55 = getelementptr inbounds %struct.anon.8* %cs_siblings54, i32 0, i32 1, !dbg !1743
  store %struct.cpuset** %lh_first53, %struct.cpuset*** %le_prev55, align 8, !dbg !1743
  br label %do.end56, !dbg !1743

do.end56:                                         ; preds = %if.end49
  %45 = load %struct.cpuset** %set.addr, align 8, !dbg !1747
  %cs_id57 = getelementptr inbounds %struct.cpuset* %45, i32 0, i32 3, !dbg !1747
  %46 = load i32* %cs_id57, align 4, !dbg !1747
  %cmp58 = icmp ne i32 %46, -1, !dbg !1747
  br i1 %cmp58, label %if.then59, label %if.end81, !dbg !1747

if.then59:                                        ; preds = %do.end56
  br label %do.body60, !dbg !1748

do.body60:                                        ; preds = %if.then59
  br label %do.body61, !dbg !1749

do.body61:                                        ; preds = %do.body60
  %47 = load %struct.cpuset** getelementptr inbounds (%struct.setlist* @cpuset_ids, i32 0, i32 0), align 8, !dbg !1751
  %cmp62 = icmp ne %struct.cpuset* %47, null, !dbg !1751
  br i1 %cmp62, label %land.lhs.true63, label %if.end67, !dbg !1751

land.lhs.true63:                                  ; preds = %do.body61
  %48 = load %struct.cpuset** getelementptr inbounds (%struct.setlist* @cpuset_ids, i32 0, i32 0), align 8, !dbg !1751
  %cs_link = getelementptr inbounds %struct.cpuset* %48, i32 0, i32 5, !dbg !1751
  %le_prev64 = getelementptr inbounds %struct.anon.7* %cs_link, i32 0, i32 1, !dbg !1751
  %49 = load %struct.cpuset*** %le_prev64, align 8, !dbg !1751
  %cmp65 = icmp ne %struct.cpuset** %49, getelementptr inbounds (%struct.setlist* @cpuset_ids, i32 0, i32 0), !dbg !1751
  br i1 %cmp65, label %if.then66, label %if.end67, !dbg !1751

if.then66:                                        ; preds = %land.lhs.true63
  call void (i8*, ...)* @panic(i8* getelementptr inbounds ([37 x i8]* @.str7, i32 0, i32 0), %struct.setlist* @cpuset_ids) #8, !dbg !1751
  unreachable, !dbg !1751

if.end67:                                         ; preds = %land.lhs.true63, %do.body61
  br label %do.end68, !dbg !1751

do.end68:                                         ; preds = %if.end67
  %50 = load %struct.cpuset** getelementptr inbounds (%struct.setlist* @cpuset_ids, i32 0, i32 0), align 8, !dbg !1749
  %51 = load %struct.cpuset** %set.addr, align 8, !dbg !1749
  %cs_link69 = getelementptr inbounds %struct.cpuset* %51, i32 0, i32 5, !dbg !1749
  %le_next70 = getelementptr inbounds %struct.anon.7* %cs_link69, i32 0, i32 0, !dbg !1749
  store %struct.cpuset* %50, %struct.cpuset** %le_next70, align 8, !dbg !1749
  %cmp71 = icmp ne %struct.cpuset* %50, null, !dbg !1749
  br i1 %cmp71, label %if.then72, label %if.end77, !dbg !1749

if.then72:                                        ; preds = %do.end68
  %52 = load %struct.cpuset** %set.addr, align 8, !dbg !1749
  %cs_link73 = getelementptr inbounds %struct.cpuset* %52, i32 0, i32 5, !dbg !1749
  %le_next74 = getelementptr inbounds %struct.anon.7* %cs_link73, i32 0, i32 0, !dbg !1749
  %53 = load %struct.cpuset** getelementptr inbounds (%struct.setlist* @cpuset_ids, i32 0, i32 0), align 8, !dbg !1749
  %cs_link75 = getelementptr inbounds %struct.cpuset* %53, i32 0, i32 5, !dbg !1749
  %le_prev76 = getelementptr inbounds %struct.anon.7* %cs_link75, i32 0, i32 1, !dbg !1749
  store %struct.cpuset** %le_next74, %struct.cpuset*** %le_prev76, align 8, !dbg !1749
  br label %if.end77, !dbg !1749

if.end77:                                         ; preds = %if.then72, %do.end68
  %54 = load %struct.cpuset** %set.addr, align 8, !dbg !1749
  store %struct.cpuset* %54, %struct.cpuset** getelementptr inbounds (%struct.setlist* @cpuset_ids, i32 0, i32 0), align 8, !dbg !1749
  %55 = load %struct.cpuset** %set.addr, align 8, !dbg !1749
  %cs_link78 = getelementptr inbounds %struct.cpuset* %55, i32 0, i32 5, !dbg !1749
  %le_prev79 = getelementptr inbounds %struct.anon.7* %cs_link78, i32 0, i32 1, !dbg !1749
  store %struct.cpuset** getelementptr inbounds (%struct.setlist* @cpuset_ids, i32 0, i32 0), %struct.cpuset*** %le_prev79, align 8, !dbg !1749
  br label %do.end80, !dbg !1749

do.end80:                                         ; preds = %if.end77
  br label %if.end81, !dbg !1749

if.end81:                                         ; preds = %do.end80, %do.end56
  call void @__mtx_unlock_spin_flags(i64* getelementptr inbounds (%struct.mtx* @cpuset_lock, i32 0, i32 1), i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 273) #7, !dbg !1753
  store i32 0, i32* %retval, !dbg !1754
  br label %return, !dbg !1754

return:                                           ; preds = %if.end81, %if.then5
  %56 = load i32* %retval, !dbg !1754
  ret i32 %56, !dbg !1754
}

; Function Attrs: nounwind readnone
declare i64 @llvm.expect.i64(i64, i64) #1

; Function Attrs: noimplicitfloat noredzone
declare void @kassert_panic(i8*, ...) #3

; Function Attrs: noimplicitfloat noredzone
declare %struct.unrhdr* @new_unrhdr(i32, i32, %struct.mtx*) #3

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @cpuset_create_root(%struct.prison* %pr, %struct.cpuset** %setp) #0 {
entry:
  %retval = alloca i32, align 4
  %pr.addr = alloca %struct.prison*, align 8
  %setp.addr = alloca %struct.cpuset**, align 8
  %set = alloca %struct.cpuset*, align 8
  %error = alloca i32, align 4
  store %struct.prison* %pr, %struct.prison** %pr.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.prison** %pr.addr}, metadata !1755), !dbg !1756
  store %struct.cpuset** %setp, %struct.cpuset*** %setp.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.cpuset*** %setp.addr}, metadata !1757), !dbg !1756
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %set}, metadata !1758), !dbg !1759
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !1760), !dbg !1761
  br label %do.body, !dbg !1762

do.body:                                          ; preds = %entry
  %0 = load %struct.prison** %pr.addr, align 8, !dbg !1763
  %cmp = icmp ne %struct.prison* %0, null, !dbg !1763
  %lnot = xor i1 %cmp, true, !dbg !1763
  %lnot.ext = zext i1 %lnot to i32, !dbg !1763
  %conv = sext i32 %lnot.ext to i64, !dbg !1763
  %expval = call i64 @llvm.expect.i64(i64 %conv, i64 0), !dbg !1763
  %tobool = icmp ne i64 %expval, 0, !dbg !1763
  br i1 %tobool, label %if.then, label %if.end, !dbg !1763

if.then:                                          ; preds = %do.body
  call void (i8*, ...)* @kassert_panic(i8* getelementptr inbounds ([19 x i8]* @.str9, i32 0, i32 0), i8* getelementptr inbounds ([19 x i8]* @__func__.cpuset_create_root, i32 0, i32 0), i32 802) #7, !dbg !1763
  br label %if.end, !dbg !1763

if.end:                                           ; preds = %if.then, %do.body
  br label %do.end, !dbg !1763

do.end:                                           ; preds = %if.end
  br label %do.body1, !dbg !1765

do.body1:                                         ; preds = %do.end
  %1 = load %struct.cpuset*** %setp.addr, align 8, !dbg !1766
  %cmp2 = icmp ne %struct.cpuset** %1, null, !dbg !1766
  %lnot4 = xor i1 %cmp2, true, !dbg !1766
  %lnot.ext5 = zext i1 %lnot4 to i32, !dbg !1766
  %conv6 = sext i32 %lnot.ext5 to i64, !dbg !1766
  %expval7 = call i64 @llvm.expect.i64(i64 %conv6, i64 0), !dbg !1766
  %tobool8 = icmp ne i64 %expval7, 0, !dbg !1766
  br i1 %tobool8, label %if.then9, label %if.end10, !dbg !1766

if.then9:                                         ; preds = %do.body1
  call void (i8*, ...)* @kassert_panic(i8* getelementptr inbounds ([21 x i8]* @.str10, i32 0, i32 0), i8* getelementptr inbounds ([19 x i8]* @__func__.cpuset_create_root, i32 0, i32 0), i32 803) #7, !dbg !1766
  br label %if.end10, !dbg !1766

if.end10:                                         ; preds = %if.then9, %do.body1
  br label %do.end11, !dbg !1766

do.end11:                                         ; preds = %if.end10
  %2 = load %struct.cpuset*** %setp.addr, align 8, !dbg !1768
  %3 = load %struct.prison** %pr.addr, align 8, !dbg !1768
  %pr_cpuset = getelementptr inbounds %struct.prison* %3, i32 0, i32 11, !dbg !1768
  %4 = load %struct.cpuset** %pr_cpuset, align 8, !dbg !1768
  %5 = load %struct.prison** %pr.addr, align 8, !dbg !1768
  %pr_cpuset12 = getelementptr inbounds %struct.prison* %5, i32 0, i32 11, !dbg !1768
  %6 = load %struct.cpuset** %pr_cpuset12, align 8, !dbg !1768
  %cs_mask = getelementptr inbounds %struct.cpuset* %6, i32 0, i32 0, !dbg !1768
  %call = call i32 @cpuset_create(%struct.cpuset** %2, %struct.cpuset* %4, %struct._cpuset* %cs_mask) #7, !dbg !1768
  store i32 %call, i32* %error, align 4, !dbg !1768
  %7 = load i32* %error, align 4, !dbg !1769
  %tobool13 = icmp ne i32 %7, 0, !dbg !1769
  br i1 %tobool13, label %if.then14, label %if.end15, !dbg !1769

if.then14:                                        ; preds = %do.end11
  %8 = load i32* %error, align 4, !dbg !1770
  store i32 %8, i32* %retval, !dbg !1770
  br label %return, !dbg !1770

if.end15:                                         ; preds = %do.end11
  br label %do.body16, !dbg !1771

do.body16:                                        ; preds = %if.end15
  %9 = load %struct.cpuset*** %setp.addr, align 8, !dbg !1772
  %10 = load %struct.cpuset** %9, align 8, !dbg !1772
  %cmp17 = icmp ne %struct.cpuset* %10, null, !dbg !1772
  %lnot19 = xor i1 %cmp17, true, !dbg !1772
  %lnot.ext20 = zext i1 %lnot19 to i32, !dbg !1772
  %conv21 = sext i32 %lnot.ext20 to i64, !dbg !1772
  %expval22 = call i64 @llvm.expect.i64(i64 %conv21, i64 0), !dbg !1772
  %tobool23 = icmp ne i64 %expval22, 0, !dbg !1772
  br i1 %tobool23, label %if.then24, label %if.end25, !dbg !1772

if.then24:                                        ; preds = %do.body16
  call void (i8*, ...)* @kassert_panic(i8* getelementptr inbounds ([44 x i8]* @.str11, i32 0, i32 0), i8* getelementptr inbounds ([19 x i8]* @__func__.cpuset_create_root, i32 0, i32 0), i32 810) #7, !dbg !1772
  br label %if.end25, !dbg !1772

if.end25:                                         ; preds = %if.then24, %do.body16
  br label %do.end26, !dbg !1772

do.end26:                                         ; preds = %if.end25
  %11 = load %struct.cpuset*** %setp.addr, align 8, !dbg !1774
  %12 = load %struct.cpuset** %11, align 8, !dbg !1774
  store %struct.cpuset* %12, %struct.cpuset** %set, align 8, !dbg !1774
  %13 = load %struct.cpuset** %set, align 8, !dbg !1775
  %cs_flags = getelementptr inbounds %struct.cpuset* %13, i32 0, i32 2, !dbg !1775
  %14 = load i32* %cs_flags, align 4, !dbg !1775
  %or = or i32 %14, 1, !dbg !1775
  store i32 %or, i32* %cs_flags, align 4, !dbg !1775
  store i32 0, i32* %retval, !dbg !1776
  br label %return, !dbg !1776

return:                                           ; preds = %do.end26, %if.then14
  %15 = load i32* %retval, !dbg !1777
  ret i32 %15, !dbg !1777
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define internal i32 @cpuset_create(%struct.cpuset** %setp, %struct.cpuset* %parent, %struct._cpuset* %mask) #0 {
entry:
  %retval = alloca i32, align 4
  %setp.addr = alloca %struct.cpuset**, align 8
  %parent.addr = alloca %struct.cpuset*, align 8
  %mask.addr = alloca %struct._cpuset*, align 8
  %set = alloca %struct.cpuset*, align 8
  %id = alloca i32, align 4
  %error = alloca i32, align 4
  store %struct.cpuset** %setp, %struct.cpuset*** %setp.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.cpuset*** %setp.addr}, metadata !1778), !dbg !1779
  store %struct.cpuset* %parent, %struct.cpuset** %parent.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %parent.addr}, metadata !1780), !dbg !1779
  store %struct._cpuset* %mask, %struct._cpuset** %mask.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct._cpuset** %mask.addr}, metadata !1781), !dbg !1779
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %set}, metadata !1782), !dbg !1783
  call void @llvm.dbg.declare(metadata !{i32* %id}, metadata !1784), !dbg !1785
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !1786), !dbg !1787
  %0 = load %struct.unrhdr** @cpuset_unr, align 8, !dbg !1788
  %call = call i32 @alloc_unr(%struct.unrhdr* %0) #7, !dbg !1788
  store i32 %call, i32* %id, align 4, !dbg !1788
  %1 = load i32* %id, align 4, !dbg !1789
  %cmp = icmp eq i32 %1, -1, !dbg !1789
  br i1 %cmp, label %if.then, label %if.end, !dbg !1789

if.then:                                          ; preds = %entry
  store i32 23, i32* %retval, !dbg !1790
  br label %return, !dbg !1790

if.end:                                           ; preds = %entry
  %2 = load %struct.uma_zone** @cpuset_zone, align 8, !dbg !1791
  %call1 = call i8* @uma_zalloc(%struct.uma_zone* %2, i32 2) #7, !dbg !1791
  %3 = bitcast i8* %call1 to %struct.cpuset*, !dbg !1791
  store %struct.cpuset* %3, %struct.cpuset** %set, align 8, !dbg !1791
  %4 = load %struct.cpuset*** %setp.addr, align 8, !dbg !1791
  store %struct.cpuset* %3, %struct.cpuset** %4, align 8, !dbg !1791
  %5 = load %struct.cpuset** %set, align 8, !dbg !1792
  %6 = load %struct.cpuset** %parent.addr, align 8, !dbg !1792
  %7 = load %struct._cpuset** %mask.addr, align 8, !dbg !1792
  %8 = load i32* %id, align 4, !dbg !1792
  %call2 = call i32 @_cpuset_create(%struct.cpuset* %5, %struct.cpuset* %6, %struct._cpuset* %7, i32 %8) #7, !dbg !1792
  store i32 %call2, i32* %error, align 4, !dbg !1792
  %9 = load i32* %error, align 4, !dbg !1793
  %cmp3 = icmp eq i32 %9, 0, !dbg !1793
  br i1 %cmp3, label %if.then4, label %if.end5, !dbg !1793

if.then4:                                         ; preds = %if.end
  store i32 0, i32* %retval, !dbg !1794
  br label %return, !dbg !1794

if.end5:                                          ; preds = %if.end
  %10 = load %struct.unrhdr** @cpuset_unr, align 8, !dbg !1795
  %11 = load i32* %id, align 4, !dbg !1795
  call void @free_unr(%struct.unrhdr* %10, i32 %11) #7, !dbg !1795
  %12 = load %struct.uma_zone** @cpuset_zone, align 8, !dbg !1796
  %13 = load %struct.cpuset** %set, align 8, !dbg !1796
  %14 = bitcast %struct.cpuset* %13 to i8*, !dbg !1796
  call void @uma_zfree(%struct.uma_zone* %12, i8* %14) #7, !dbg !1796
  %15 = load i32* %error, align 4, !dbg !1797
  store i32 %15, i32* %retval, !dbg !1797
  br label %return, !dbg !1797

return:                                           ; preds = %if.end5, %if.then4, %if.then
  %16 = load i32* %retval, !dbg !1798
  ret i32 %16, !dbg !1798
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @cpuset_setproc_update_set(%struct.proc* %p, %struct.cpuset* %set) #0 {
entry:
  %retval = alloca i32, align 4
  %p.addr = alloca %struct.proc*, align 8
  %set.addr = alloca %struct.cpuset*, align 8
  %error = alloca i32, align 4
  store %struct.proc* %p, %struct.proc** %p.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p.addr}, metadata !1799), !dbg !1800
  store %struct.cpuset* %set, %struct.cpuset** %set.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %set.addr}, metadata !1801), !dbg !1800
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !1802), !dbg !1803
  br label %do.body, !dbg !1804

do.body:                                          ; preds = %entry
  %0 = load %struct.proc** %p.addr, align 8, !dbg !1805
  %cmp = icmp ne %struct.proc* %0, null, !dbg !1805
  %lnot = xor i1 %cmp, true, !dbg !1805
  %lnot.ext = zext i1 %lnot to i32, !dbg !1805
  %conv = sext i32 %lnot.ext to i64, !dbg !1805
  %expval = call i64 @llvm.expect.i64(i64 %conv, i64 0), !dbg !1805
  %tobool = icmp ne i64 %expval, 0, !dbg !1805
  br i1 %tobool, label %if.then, label %if.end, !dbg !1805

if.then:                                          ; preds = %do.body
  call void (i8*, ...)* @kassert_panic(i8* getelementptr inbounds ([21 x i8]* @.str12, i32 0, i32 0), i8* getelementptr inbounds ([26 x i8]* @__func__.cpuset_setproc_update_set, i32 0, i32 0), i32 824) #7, !dbg !1805
  br label %if.end, !dbg !1805

if.end:                                           ; preds = %if.then, %do.body
  br label %do.end, !dbg !1805

do.end:                                           ; preds = %if.end
  br label %do.body1, !dbg !1807

do.body1:                                         ; preds = %do.end
  %1 = load %struct.cpuset** %set.addr, align 8, !dbg !1808
  %cmp2 = icmp ne %struct.cpuset* %1, null, !dbg !1808
  %lnot4 = xor i1 %cmp2, true, !dbg !1808
  %lnot.ext5 = zext i1 %lnot4 to i32, !dbg !1808
  %conv6 = sext i32 %lnot.ext5 to i64, !dbg !1808
  %expval7 = call i64 @llvm.expect.i64(i64 %conv6, i64 0), !dbg !1808
  %tobool8 = icmp ne i64 %expval7, 0, !dbg !1808
  br i1 %tobool8, label %if.then9, label %if.end10, !dbg !1808

if.then9:                                         ; preds = %do.body1
  call void (i8*, ...)* @kassert_panic(i8* getelementptr inbounds ([20 x i8]* @.str13, i32 0, i32 0), i8* getelementptr inbounds ([26 x i8]* @__func__.cpuset_setproc_update_set, i32 0, i32 0), i32 825) #7, !dbg !1808
  br label %if.end10, !dbg !1808

if.end10:                                         ; preds = %if.then9, %do.body1
  br label %do.end11, !dbg !1808

do.end11:                                         ; preds = %if.end10
  %2 = load %struct.cpuset** %set.addr, align 8, !dbg !1810
  %call = call %struct.cpuset* @cpuset_ref(%struct.cpuset* %2) #7, !dbg !1810
  %3 = load %struct.proc** %p.addr, align 8, !dbg !1811
  %p_pid = getelementptr inbounds %struct.proc* %3, i32 0, i32 12, !dbg !1811
  %4 = load i32* %p_pid, align 4, !dbg !1811
  %5 = load %struct.cpuset** %set.addr, align 8, !dbg !1811
  %call12 = call i32 @cpuset_setproc(i32 %4, %struct.cpuset* %5, %struct._cpuset* null) #7, !dbg !1811
  store i32 %call12, i32* %error, align 4, !dbg !1811
  %6 = load i32* %error, align 4, !dbg !1812
  %tobool13 = icmp ne i32 %6, 0, !dbg !1812
  br i1 %tobool13, label %if.then14, label %if.end15, !dbg !1812

if.then14:                                        ; preds = %do.end11
  %7 = load i32* %error, align 4, !dbg !1813
  store i32 %7, i32* %retval, !dbg !1813
  br label %return, !dbg !1813

if.end15:                                         ; preds = %do.end11
  %8 = load %struct.cpuset** %set.addr, align 8, !dbg !1814
  call void @cpuset_rel(%struct.cpuset* %8) #7, !dbg !1814
  store i32 0, i32* %retval, !dbg !1815
  br label %return, !dbg !1815

return:                                           ; preds = %if.end15, %if.then14
  %9 = load i32* %retval, !dbg !1816
  ret i32 %9, !dbg !1816
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define internal i32 @cpuset_setproc(i32 %pid, %struct.cpuset* %set, %struct._cpuset* %mask) #0 {
entry:
  %pid.addr = alloca i32, align 4
  %set.addr = alloca %struct.cpuset*, align 8
  %mask.addr = alloca %struct._cpuset*, align 8
  %freelist = alloca %struct.setlist, align 8
  %droplist = alloca %struct.setlist, align 8
  %tdset = alloca %struct.cpuset*, align 8
  %nset = alloca %struct.cpuset*, align 8
  %td = alloca %struct.thread*, align 8
  %p = alloca %struct.proc*, align 8
  %threads = alloca i32, align 4
  %nfree = alloca i32, align 4
  %error = alloca i32, align 4
  %__i = alloca i64, align 8
  %__i75 = alloca i64, align 8
  store i32 %pid, i32* %pid.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %pid.addr}, metadata !1817), !dbg !1818
  store %struct.cpuset* %set, %struct.cpuset** %set.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %set.addr}, metadata !1819), !dbg !1818
  store %struct._cpuset* %mask, %struct._cpuset** %mask.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct._cpuset** %mask.addr}, metadata !1820), !dbg !1818
  call void @llvm.dbg.declare(metadata !{%struct.setlist* %freelist}, metadata !1821), !dbg !1822
  call void @llvm.dbg.declare(metadata !{%struct.setlist* %droplist}, metadata !1823), !dbg !1824
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %tdset}, metadata !1825), !dbg !1826
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %nset}, metadata !1827), !dbg !1828
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td}, metadata !1829), !dbg !1830
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p}, metadata !1831), !dbg !1832
  call void @llvm.dbg.declare(metadata !{i32* %threads}, metadata !1833), !dbg !1834
  call void @llvm.dbg.declare(metadata !{i32* %nfree}, metadata !1835), !dbg !1836
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !1837), !dbg !1838
  br label %do.body, !dbg !1839

do.body:                                          ; preds = %entry
  %lh_first = getelementptr inbounds %struct.setlist* %freelist, i32 0, i32 0, !dbg !1840
  store %struct.cpuset* null, %struct.cpuset** %lh_first, align 8, !dbg !1840
  br label %do.end, !dbg !1840

do.end:                                           ; preds = %do.body
  br label %do.body1, !dbg !1842

do.body1:                                         ; preds = %do.end
  %lh_first2 = getelementptr inbounds %struct.setlist* %droplist, i32 0, i32 0, !dbg !1843
  store %struct.cpuset* null, %struct.cpuset** %lh_first2, align 8, !dbg !1843
  br label %do.end3, !dbg !1843

do.end3:                                          ; preds = %do.body1
  store i32 0, i32* %nfree, align 4, !dbg !1845
  br label %for.cond, !dbg !1846

for.cond:                                         ; preds = %for.end, %do.end3
  %0 = load i32* %pid.addr, align 4, !dbg !1848
  %conv = sext i32 %0 to i64, !dbg !1848
  %call = call i32 @cpuset_which(i32 2, i64 %conv, %struct.proc** %p, %struct.thread** %td, %struct.cpuset** %nset) #7, !dbg !1848
  store i32 %call, i32* %error, align 4, !dbg !1848
  %1 = load i32* %error, align 4, !dbg !1850
  %tobool = icmp ne i32 %1, 0, !dbg !1850
  br i1 %tobool, label %if.then, label %if.end, !dbg !1850

if.then:                                          ; preds = %for.cond
  br label %out, !dbg !1851

if.end:                                           ; preds = %for.cond
  %2 = load i32* %nfree, align 4, !dbg !1852
  %3 = load %struct.proc** %p, align 8, !dbg !1852
  %p_numthreads = getelementptr inbounds %struct.proc* %3, i32 0, i32 63, !dbg !1852
  %4 = load i32* %p_numthreads, align 4, !dbg !1852
  %cmp = icmp sge i32 %2, %4, !dbg !1852
  br i1 %cmp, label %if.then5, label %if.end6, !dbg !1852

if.then5:                                         ; preds = %if.end
  br label %for.end40, !dbg !1853

if.end6:                                          ; preds = %if.end
  %5 = load %struct.proc** %p, align 8, !dbg !1854
  %p_numthreads7 = getelementptr inbounds %struct.proc* %5, i32 0, i32 63, !dbg !1854
  %6 = load i32* %p_numthreads7, align 4, !dbg !1854
  store i32 %6, i32* %threads, align 4, !dbg !1854
  %7 = load %struct.proc** %p, align 8, !dbg !1855
  %p_mtx = getelementptr inbounds %struct.proc* %7, i32 0, i32 18, !dbg !1855
  %mtx_lock = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !1855
  call void @__mtx_unlock_flags(i64* %mtx_lock, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 537) #7, !dbg !1855
  br label %for.cond8, !dbg !1856

for.cond8:                                        ; preds = %for.inc, %if.end6
  %8 = load i32* %nfree, align 4, !dbg !1856
  %9 = load i32* %threads, align 4, !dbg !1856
  %cmp9 = icmp slt i32 %8, %9, !dbg !1856
  br i1 %cmp9, label %for.body, label %for.end, !dbg !1856

for.body:                                         ; preds = %for.cond8
  %10 = load %struct.uma_zone** @cpuset_zone, align 8, !dbg !1858
  %call11 = call i8* @uma_zalloc(%struct.uma_zone* %10, i32 2) #7, !dbg !1858
  %11 = bitcast i8* %call11 to %struct.cpuset*, !dbg !1858
  store %struct.cpuset* %11, %struct.cpuset** %nset, align 8, !dbg !1858
  br label %do.body12, !dbg !1860

do.body12:                                        ; preds = %for.body
  br label %do.body13, !dbg !1861

do.body13:                                        ; preds = %do.body12
  %lh_first14 = getelementptr inbounds %struct.setlist* %freelist, i32 0, i32 0, !dbg !1863
  %12 = load %struct.cpuset** %lh_first14, align 8, !dbg !1863
  %cmp15 = icmp ne %struct.cpuset* %12, null, !dbg !1863
  br i1 %cmp15, label %land.lhs.true, label %if.end22, !dbg !1863

land.lhs.true:                                    ; preds = %do.body13
  %lh_first17 = getelementptr inbounds %struct.setlist* %freelist, i32 0, i32 0, !dbg !1863
  %13 = load %struct.cpuset** %lh_first17, align 8, !dbg !1863
  %cs_link = getelementptr inbounds %struct.cpuset* %13, i32 0, i32 5, !dbg !1863
  %le_prev = getelementptr inbounds %struct.anon.7* %cs_link, i32 0, i32 1, !dbg !1863
  %14 = load %struct.cpuset*** %le_prev, align 8, !dbg !1863
  %lh_first18 = getelementptr inbounds %struct.setlist* %freelist, i32 0, i32 0, !dbg !1863
  %cmp19 = icmp ne %struct.cpuset** %14, %lh_first18, !dbg !1863
  br i1 %cmp19, label %if.then21, label %if.end22, !dbg !1863

if.then21:                                        ; preds = %land.lhs.true
  call void (i8*, ...)* @panic(i8* getelementptr inbounds ([37 x i8]* @.str7, i32 0, i32 0), %struct.setlist* %freelist) #8, !dbg !1863
  unreachable, !dbg !1863

if.end22:                                         ; preds = %land.lhs.true, %do.body13
  br label %do.end23, !dbg !1863

do.end23:                                         ; preds = %if.end22
  %lh_first24 = getelementptr inbounds %struct.setlist* %freelist, i32 0, i32 0, !dbg !1861
  %15 = load %struct.cpuset** %lh_first24, align 8, !dbg !1861
  %16 = load %struct.cpuset** %nset, align 8, !dbg !1861
  %cs_link25 = getelementptr inbounds %struct.cpuset* %16, i32 0, i32 5, !dbg !1861
  %le_next = getelementptr inbounds %struct.anon.7* %cs_link25, i32 0, i32 0, !dbg !1861
  store %struct.cpuset* %15, %struct.cpuset** %le_next, align 8, !dbg !1861
  %cmp26 = icmp ne %struct.cpuset* %15, null, !dbg !1861
  br i1 %cmp26, label %if.then28, label %if.end34, !dbg !1861

if.then28:                                        ; preds = %do.end23
  %17 = load %struct.cpuset** %nset, align 8, !dbg !1861
  %cs_link29 = getelementptr inbounds %struct.cpuset* %17, i32 0, i32 5, !dbg !1861
  %le_next30 = getelementptr inbounds %struct.anon.7* %cs_link29, i32 0, i32 0, !dbg !1861
  %lh_first31 = getelementptr inbounds %struct.setlist* %freelist, i32 0, i32 0, !dbg !1861
  %18 = load %struct.cpuset** %lh_first31, align 8, !dbg !1861
  %cs_link32 = getelementptr inbounds %struct.cpuset* %18, i32 0, i32 5, !dbg !1861
  %le_prev33 = getelementptr inbounds %struct.anon.7* %cs_link32, i32 0, i32 1, !dbg !1861
  store %struct.cpuset** %le_next30, %struct.cpuset*** %le_prev33, align 8, !dbg !1861
  br label %if.end34, !dbg !1861

if.end34:                                         ; preds = %if.then28, %do.end23
  %19 = load %struct.cpuset** %nset, align 8, !dbg !1861
  %lh_first35 = getelementptr inbounds %struct.setlist* %freelist, i32 0, i32 0, !dbg !1861
  store %struct.cpuset* %19, %struct.cpuset** %lh_first35, align 8, !dbg !1861
  %lh_first36 = getelementptr inbounds %struct.setlist* %freelist, i32 0, i32 0, !dbg !1861
  %20 = load %struct.cpuset** %nset, align 8, !dbg !1861
  %cs_link37 = getelementptr inbounds %struct.cpuset* %20, i32 0, i32 5, !dbg !1861
  %le_prev38 = getelementptr inbounds %struct.anon.7* %cs_link37, i32 0, i32 1, !dbg !1861
  store %struct.cpuset** %lh_first36, %struct.cpuset*** %le_prev38, align 8, !dbg !1861
  br label %do.end39, !dbg !1861

do.end39:                                         ; preds = %if.end34
  br label %for.inc, !dbg !1865

for.inc:                                          ; preds = %do.end39
  %21 = load i32* %nfree, align 4, !dbg !1856
  %inc = add nsw i32 %21, 1, !dbg !1856
  store i32 %inc, i32* %nfree, align 4, !dbg !1856
  br label %for.cond8, !dbg !1856

for.end:                                          ; preds = %for.cond8
  br label %for.cond, !dbg !1866

for.end40:                                        ; preds = %if.then5
  %22 = load %struct.proc** %p, align 8, !dbg !1867
  %p_mtx41 = getelementptr inbounds %struct.proc* %22, i32 0, i32 18, !dbg !1867
  %mtx_lock42 = getelementptr inbounds %struct.mtx* %p_mtx41, i32 0, i32 1, !dbg !1867
  call void @__mtx_assert(i64* %mtx_lock42, i32 4, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 543) #7, !dbg !1867
  store i32 0, i32* %error, align 4, !dbg !1868
  %23 = load %struct.proc** %p, align 8, !dbg !1869
  %p_threads = getelementptr inbounds %struct.proc* %23, i32 0, i32 1, !dbg !1869
  %tqh_first = getelementptr inbounds %struct.anon.1* %p_threads, i32 0, i32 0, !dbg !1869
  %24 = load %struct.thread** %tqh_first, align 8, !dbg !1869
  store %struct.thread* %24, %struct.thread** %td, align 8, !dbg !1869
  br label %for.cond43, !dbg !1869

for.cond43:                                       ; preds = %for.inc104, %for.end40
  %25 = load %struct.thread** %td, align 8, !dbg !1869
  %tobool44 = icmp ne %struct.thread* %25, null, !dbg !1869
  br i1 %tobool44, label %for.body45, label %for.end105, !dbg !1869

for.body45:                                       ; preds = %for.cond43
  %26 = load %struct.thread** %td, align 8, !dbg !1871
  call void @thread_lock_flags_(%struct.thread* %26, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 551) #7, !dbg !1871
  %27 = load %struct.thread** %td, align 8, !dbg !1873
  %td_cpuset = getelementptr inbounds %struct.thread* %27, i32 0, i32 7, !dbg !1873
  %28 = load %struct.cpuset** %td_cpuset, align 8, !dbg !1873
  store %struct.cpuset* %28, %struct.cpuset** %tdset, align 8, !dbg !1873
  %29 = load %struct._cpuset** %mask.addr, align 8, !dbg !1874
  %tobool46 = icmp ne %struct._cpuset* %29, null, !dbg !1874
  br i1 %tobool46, label %if.then47, label %if.else, !dbg !1874

if.then47:                                        ; preds = %for.body45
  %30 = load %struct.cpuset** %tdset, align 8, !dbg !1875
  %cs_id = getelementptr inbounds %struct.cpuset* %30, i32 0, i32 3, !dbg !1875
  %31 = load i32* %cs_id, align 4, !dbg !1875
  %cmp48 = icmp eq i32 %31, -1, !dbg !1875
  br i1 %cmp48, label %if.then50, label %if.end51, !dbg !1875

if.then50:                                        ; preds = %if.then47
  %32 = load %struct.cpuset** %tdset, align 8, !dbg !1877
  %cs_parent = getelementptr inbounds %struct.cpuset* %32, i32 0, i32 4, !dbg !1877
  %33 = load %struct.cpuset** %cs_parent, align 8, !dbg !1877
  store %struct.cpuset* %33, %struct.cpuset** %tdset, align 8, !dbg !1877
  br label %if.end51, !dbg !1877

if.end51:                                         ; preds = %if.then50, %if.then47
  call void @llvm.dbg.declare(metadata !{i64* %__i}, metadata !1878), !dbg !1880
  store i64 0, i64* %__i, align 8, !dbg !1881
  br label %for.cond52, !dbg !1881

for.cond52:                                       ; preds = %for.inc64, %if.end51
  %34 = load i64* %__i, align 8, !dbg !1881
  %cmp53 = icmp ult i64 %34, 1, !dbg !1881
  br i1 %cmp53, label %for.body55, label %for.end66, !dbg !1881

for.body55:                                       ; preds = %for.cond52
  %35 = load i64* %__i, align 8, !dbg !1881
  %36 = load %struct._cpuset** %mask.addr, align 8, !dbg !1881
  %__bits = getelementptr inbounds %struct._cpuset* %36, i32 0, i32 0, !dbg !1881
  %arrayidx = getelementptr inbounds [1 x i64]* %__bits, i32 0, i64 %35, !dbg !1881
  %37 = load i64* %arrayidx, align 8, !dbg !1881
  %38 = load i64* %__i, align 8, !dbg !1881
  %39 = load %struct.cpuset** %tdset, align 8, !dbg !1881
  %cs_mask = getelementptr inbounds %struct.cpuset* %39, i32 0, i32 0, !dbg !1881
  %__bits56 = getelementptr inbounds %struct._cpuset* %cs_mask, i32 0, i32 0, !dbg !1881
  %arrayidx57 = getelementptr inbounds [1 x i64]* %__bits56, i32 0, i64 %38, !dbg !1881
  %40 = load i64* %arrayidx57, align 8, !dbg !1881
  %and = and i64 %37, %40, !dbg !1881
  %41 = load i64* %__i, align 8, !dbg !1881
  %42 = load %struct._cpuset** %mask.addr, align 8, !dbg !1881
  %__bits58 = getelementptr inbounds %struct._cpuset* %42, i32 0, i32 0, !dbg !1881
  %arrayidx59 = getelementptr inbounds [1 x i64]* %__bits58, i32 0, i64 %41, !dbg !1881
  %43 = load i64* %arrayidx59, align 8, !dbg !1881
  %cmp60 = icmp ne i64 %and, %43, !dbg !1881
  br i1 %cmp60, label %if.then62, label %if.end63, !dbg !1881

if.then62:                                        ; preds = %for.body55
  br label %for.end66, !dbg !1881

if.end63:                                         ; preds = %for.body55
  br label %for.inc64, !dbg !1881

for.inc64:                                        ; preds = %if.end63
  %44 = load i64* %__i, align 8, !dbg !1881
  %inc65 = add i64 %44, 1, !dbg !1881
  store i64 %inc65, i64* %__i, align 8, !dbg !1881
  br label %for.cond52, !dbg !1881

for.end66:                                        ; preds = %if.then62, %for.cond52
  %45 = load i64* %__i, align 8, !dbg !1881
  %cmp67 = icmp eq i64 %45, 1, !dbg !1881
  br i1 %cmp67, label %if.end70, label %if.then69, !dbg !1880

if.then69:                                        ; preds = %for.end66
  store i32 11, i32* %error, align 4, !dbg !1883
  br label %if.end70, !dbg !1883

if.end70:                                         ; preds = %if.then69, %for.end66
  br label %if.end99, !dbg !1884

if.else:                                          ; preds = %for.body45
  %46 = load %struct.cpuset** %tdset, align 8, !dbg !1885
  %cs_id71 = getelementptr inbounds %struct.cpuset* %46, i32 0, i32 3, !dbg !1885
  %47 = load i32* %cs_id71, align 4, !dbg !1885
  %cmp72 = icmp eq i32 %47, -1, !dbg !1885
  br i1 %cmp72, label %if.then74, label %if.end98, !dbg !1885

if.then74:                                        ; preds = %if.else
  call void @llvm.dbg.declare(metadata !{i64* %__i75}, metadata !1886), !dbg !1889
  store i64 0, i64* %__i75, align 8, !dbg !1890
  br label %for.cond76, !dbg !1890

for.cond76:                                       ; preds = %for.inc91, %if.then74
  %48 = load i64* %__i75, align 8, !dbg !1890
  %cmp77 = icmp ult i64 %48, 1, !dbg !1890
  br i1 %cmp77, label %for.body79, label %for.end93, !dbg !1890

for.body79:                                       ; preds = %for.cond76
  %49 = load i64* %__i75, align 8, !dbg !1890
  %50 = load %struct.cpuset** %tdset, align 8, !dbg !1890
  %cs_mask80 = getelementptr inbounds %struct.cpuset* %50, i32 0, i32 0, !dbg !1890
  %__bits81 = getelementptr inbounds %struct._cpuset* %cs_mask80, i32 0, i32 0, !dbg !1890
  %arrayidx82 = getelementptr inbounds [1 x i64]* %__bits81, i32 0, i64 %49, !dbg !1890
  %51 = load i64* %arrayidx82, align 8, !dbg !1890
  %52 = load i64* %__i75, align 8, !dbg !1890
  %53 = load %struct.cpuset** %set.addr, align 8, !dbg !1890
  %cs_mask83 = getelementptr inbounds %struct.cpuset* %53, i32 0, i32 0, !dbg !1890
  %__bits84 = getelementptr inbounds %struct._cpuset* %cs_mask83, i32 0, i32 0, !dbg !1890
  %arrayidx85 = getelementptr inbounds [1 x i64]* %__bits84, i32 0, i64 %52, !dbg !1890
  %54 = load i64* %arrayidx85, align 8, !dbg !1890
  %and86 = and i64 %51, %54, !dbg !1890
  %cmp87 = icmp ne i64 %and86, 0, !dbg !1890
  br i1 %cmp87, label %if.then89, label %if.end90, !dbg !1890

if.then89:                                        ; preds = %for.body79
  br label %for.end93, !dbg !1890

if.end90:                                         ; preds = %for.body79
  br label %for.inc91, !dbg !1890

for.inc91:                                        ; preds = %if.end90
  %55 = load i64* %__i75, align 8, !dbg !1890
  %inc92 = add i64 %55, 1, !dbg !1890
  store i64 %inc92, i64* %__i75, align 8, !dbg !1890
  br label %for.cond76, !dbg !1890

for.end93:                                        ; preds = %if.then89, %for.cond76
  %56 = load i64* %__i75, align 8, !dbg !1890
  %cmp94 = icmp ne i64 %56, 1, !dbg !1890
  br i1 %cmp94, label %if.end97, label %if.then96, !dbg !1889

if.then96:                                        ; preds = %for.end93
  store i32 11, i32* %error, align 4, !dbg !1892
  br label %if.end97, !dbg !1892

if.end97:                                         ; preds = %if.then96, %for.end93
  br label %if.end98, !dbg !1893

if.end98:                                         ; preds = %if.end97, %if.else
  br label %if.end99

if.end99:                                         ; preds = %if.end98, %if.end70
  %57 = load %struct.thread** %td, align 8, !dbg !1894
  %td_lock = getelementptr inbounds %struct.thread* %57, i32 0, i32 0, !dbg !1894
  %58 = load volatile %struct.mtx** %td_lock, align 8, !dbg !1894
  %mtx_lock100 = getelementptr inbounds %struct.mtx* %58, i32 0, i32 1, !dbg !1894
  call void @__mtx_unlock_spin_flags(i64* %mtx_lock100, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 571) #7, !dbg !1894
  %59 = load i32* %error, align 4, !dbg !1895
  %tobool101 = icmp ne i32 %59, 0, !dbg !1895
  br i1 %tobool101, label %if.then102, label %if.end103, !dbg !1895

if.then102:                                       ; preds = %if.end99
  br label %unlock_out, !dbg !1896

if.end103:                                        ; preds = %if.end99
  br label %for.inc104, !dbg !1897

for.inc104:                                       ; preds = %if.end103
  %60 = load %struct.thread** %td, align 8, !dbg !1869
  %td_plist = getelementptr inbounds %struct.thread* %60, i32 0, i32 2, !dbg !1869
  %tqe_next = getelementptr inbounds %struct.anon.35* %td_plist, i32 0, i32 0, !dbg !1869
  %61 = load %struct.thread** %tqe_next, align 8, !dbg !1869
  store %struct.thread* %61, %struct.thread** %td, align 8, !dbg !1869
  br label %for.cond43, !dbg !1869

for.end105:                                       ; preds = %for.cond43
  %62 = load %struct.proc** %p, align 8, !dbg !1898
  %p_threads106 = getelementptr inbounds %struct.proc* %62, i32 0, i32 1, !dbg !1898
  %tqh_first107 = getelementptr inbounds %struct.anon.1* %p_threads106, i32 0, i32 0, !dbg !1898
  %63 = load %struct.thread** %tqh_first107, align 8, !dbg !1898
  store %struct.thread* %63, %struct.thread** %td, align 8, !dbg !1898
  br label %for.cond108, !dbg !1898

for.cond108:                                      ; preds = %for.inc211, %for.end105
  %64 = load %struct.thread** %td, align 8, !dbg !1898
  %tobool109 = icmp ne %struct.thread* %64, null, !dbg !1898
  br i1 %tobool109, label %for.body110, label %for.end214, !dbg !1898

for.body110:                                      ; preds = %for.cond108
  %65 = load %struct.thread** %td, align 8, !dbg !1900
  call void @thread_lock_flags_(%struct.thread* %65, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 581) #7, !dbg !1900
  %66 = load %struct.thread** %td, align 8, !dbg !1902
  %td_cpuset111 = getelementptr inbounds %struct.thread* %66, i32 0, i32 7, !dbg !1902
  %67 = load %struct.cpuset** %td_cpuset111, align 8, !dbg !1902
  store %struct.cpuset* %67, %struct.cpuset** %tdset, align 8, !dbg !1902
  %68 = load %struct.cpuset** %tdset, align 8, !dbg !1903
  %cs_id112 = getelementptr inbounds %struct.cpuset* %68, i32 0, i32 3, !dbg !1903
  %69 = load i32* %cs_id112, align 4, !dbg !1903
  %cmp113 = icmp eq i32 %69, -1, !dbg !1903
  br i1 %cmp113, label %if.then116, label %lor.lhs.false, !dbg !1903

lor.lhs.false:                                    ; preds = %for.body110
  %70 = load %struct._cpuset** %mask.addr, align 8, !dbg !1903
  %tobool115 = icmp ne %struct._cpuset* %70, null, !dbg !1903
  br i1 %tobool115, label %if.then116, label %if.else205, !dbg !1903

if.then116:                                       ; preds = %lor.lhs.false, %for.body110
  %lh_first117 = getelementptr inbounds %struct.setlist* %freelist, i32 0, i32 0, !dbg !1904
  %71 = load %struct.cpuset** %lh_first117, align 8, !dbg !1904
  store %struct.cpuset* %71, %struct.cpuset** %nset, align 8, !dbg !1904
  br label %do.body118, !dbg !1906

do.body118:                                       ; preds = %if.then116
  br label %do.body119, !dbg !1907

do.body119:                                       ; preds = %do.body118
  %72 = load %struct.cpuset** %nset, align 8, !dbg !1909
  %cs_link120 = getelementptr inbounds %struct.cpuset* %72, i32 0, i32 5, !dbg !1909
  %le_next121 = getelementptr inbounds %struct.anon.7* %cs_link120, i32 0, i32 0, !dbg !1909
  %73 = load %struct.cpuset** %le_next121, align 8, !dbg !1909
  %cmp122 = icmp ne %struct.cpuset* %73, null, !dbg !1909
  br i1 %cmp122, label %land.lhs.true124, label %if.end134, !dbg !1909

land.lhs.true124:                                 ; preds = %do.body119
  %74 = load %struct.cpuset** %nset, align 8, !dbg !1909
  %cs_link125 = getelementptr inbounds %struct.cpuset* %74, i32 0, i32 5, !dbg !1909
  %le_next126 = getelementptr inbounds %struct.anon.7* %cs_link125, i32 0, i32 0, !dbg !1909
  %75 = load %struct.cpuset** %le_next126, align 8, !dbg !1909
  %cs_link127 = getelementptr inbounds %struct.cpuset* %75, i32 0, i32 5, !dbg !1909
  %le_prev128 = getelementptr inbounds %struct.anon.7* %cs_link127, i32 0, i32 1, !dbg !1909
  %76 = load %struct.cpuset*** %le_prev128, align 8, !dbg !1909
  %77 = load %struct.cpuset** %nset, align 8, !dbg !1909
  %cs_link129 = getelementptr inbounds %struct.cpuset* %77, i32 0, i32 5, !dbg !1909
  %le_next130 = getelementptr inbounds %struct.anon.7* %cs_link129, i32 0, i32 0, !dbg !1909
  %cmp131 = icmp ne %struct.cpuset** %76, %le_next130, !dbg !1909
  br i1 %cmp131, label %if.then133, label %if.end134, !dbg !1909

if.then133:                                       ; preds = %land.lhs.true124
  %78 = load %struct.cpuset** %nset, align 8, !dbg !1909
  call void (i8*, ...)* @panic(i8* getelementptr inbounds ([34 x i8]* @.str1, i32 0, i32 0), %struct.cpuset* %78) #8, !dbg !1909
  unreachable, !dbg !1909

if.end134:                                        ; preds = %land.lhs.true124, %do.body119
  br label %do.end135, !dbg !1909

do.end135:                                        ; preds = %if.end134
  br label %do.body136, !dbg !1907

do.body136:                                       ; preds = %do.end135
  %79 = load %struct.cpuset** %nset, align 8, !dbg !1911
  %cs_link137 = getelementptr inbounds %struct.cpuset* %79, i32 0, i32 5, !dbg !1911
  %le_prev138 = getelementptr inbounds %struct.anon.7* %cs_link137, i32 0, i32 1, !dbg !1911
  %80 = load %struct.cpuset*** %le_prev138, align 8, !dbg !1911
  %81 = load %struct.cpuset** %80, align 8, !dbg !1911
  %82 = load %struct.cpuset** %nset, align 8, !dbg !1911
  %cmp139 = icmp ne %struct.cpuset* %81, %82, !dbg !1911
  br i1 %cmp139, label %if.then141, label %if.end142, !dbg !1911

if.then141:                                       ; preds = %do.body136
  %83 = load %struct.cpuset** %nset, align 8, !dbg !1911
  call void (i8*, ...)* @panic(i8* getelementptr inbounds ([34 x i8]* @.str2, i32 0, i32 0), %struct.cpuset* %83) #8, !dbg !1911
  unreachable, !dbg !1911

if.end142:                                        ; preds = %do.body136
  br label %do.end143, !dbg !1911

do.end143:                                        ; preds = %if.end142
  %84 = load %struct.cpuset** %nset, align 8, !dbg !1907
  %cs_link144 = getelementptr inbounds %struct.cpuset* %84, i32 0, i32 5, !dbg !1907
  %le_next145 = getelementptr inbounds %struct.anon.7* %cs_link144, i32 0, i32 0, !dbg !1907
  %85 = load %struct.cpuset** %le_next145, align 8, !dbg !1907
  %cmp146 = icmp ne %struct.cpuset* %85, null, !dbg !1907
  br i1 %cmp146, label %if.then148, label %if.end155, !dbg !1907

if.then148:                                       ; preds = %do.end143
  %86 = load %struct.cpuset** %nset, align 8, !dbg !1907
  %cs_link149 = getelementptr inbounds %struct.cpuset* %86, i32 0, i32 5, !dbg !1907
  %le_prev150 = getelementptr inbounds %struct.anon.7* %cs_link149, i32 0, i32 1, !dbg !1907
  %87 = load %struct.cpuset*** %le_prev150, align 8, !dbg !1907
  %88 = load %struct.cpuset** %nset, align 8, !dbg !1907
  %cs_link151 = getelementptr inbounds %struct.cpuset* %88, i32 0, i32 5, !dbg !1907
  %le_next152 = getelementptr inbounds %struct.anon.7* %cs_link151, i32 0, i32 0, !dbg !1907
  %89 = load %struct.cpuset** %le_next152, align 8, !dbg !1907
  %cs_link153 = getelementptr inbounds %struct.cpuset* %89, i32 0, i32 5, !dbg !1907
  %le_prev154 = getelementptr inbounds %struct.anon.7* %cs_link153, i32 0, i32 1, !dbg !1907
  store %struct.cpuset** %87, %struct.cpuset*** %le_prev154, align 8, !dbg !1907
  br label %if.end155, !dbg !1907

if.end155:                                        ; preds = %if.then148, %do.end143
  %90 = load %struct.cpuset** %nset, align 8, !dbg !1907
  %cs_link156 = getelementptr inbounds %struct.cpuset* %90, i32 0, i32 5, !dbg !1907
  %le_next157 = getelementptr inbounds %struct.anon.7* %cs_link156, i32 0, i32 0, !dbg !1907
  %91 = load %struct.cpuset** %le_next157, align 8, !dbg !1907
  %92 = load %struct.cpuset** %nset, align 8, !dbg !1907
  %cs_link158 = getelementptr inbounds %struct.cpuset* %92, i32 0, i32 5, !dbg !1907
  %le_prev159 = getelementptr inbounds %struct.anon.7* %cs_link158, i32 0, i32 1, !dbg !1907
  %93 = load %struct.cpuset*** %le_prev159, align 8, !dbg !1907
  store %struct.cpuset* %91, %struct.cpuset** %93, align 8, !dbg !1907
  br label %do.end160, !dbg !1907

do.end160:                                        ; preds = %if.end155
  %94 = load %struct._cpuset** %mask.addr, align 8, !dbg !1913
  %tobool161 = icmp ne %struct._cpuset* %94, null, !dbg !1913
  br i1 %tobool161, label %if.then162, label %if.else164, !dbg !1913

if.then162:                                       ; preds = %do.end160
  %95 = load %struct.cpuset** %tdset, align 8, !dbg !1914
  %96 = load %struct.cpuset** %nset, align 8, !dbg !1914
  %97 = load %struct._cpuset** %mask.addr, align 8, !dbg !1914
  %call163 = call i32 @cpuset_shadow(%struct.cpuset* %95, %struct.cpuset* %96, %struct._cpuset* %97) #7, !dbg !1914
  store i32 %call163, i32* %error, align 4, !dbg !1914
  br label %if.end167, !dbg !1914

if.else164:                                       ; preds = %do.end160
  %98 = load %struct.cpuset** %nset, align 8, !dbg !1915
  %99 = load %struct.cpuset** %set.addr, align 8, !dbg !1915
  %100 = load %struct.cpuset** %tdset, align 8, !dbg !1915
  %cs_mask165 = getelementptr inbounds %struct.cpuset* %100, i32 0, i32 0, !dbg !1915
  %call166 = call i32 @_cpuset_create(%struct.cpuset* %98, %struct.cpuset* %99, %struct._cpuset* %cs_mask165, i32 -1) #7, !dbg !1915
  store i32 %call166, i32* %error, align 4, !dbg !1915
  br label %if.end167

if.end167:                                        ; preds = %if.else164, %if.then162
  %101 = load i32* %error, align 4, !dbg !1916
  %tobool168 = icmp ne i32 %101, 0, !dbg !1916
  br i1 %tobool168, label %if.then169, label %if.end204, !dbg !1916

if.then169:                                       ; preds = %if.end167
  br label %do.body170, !dbg !1917

do.body170:                                       ; preds = %if.then169
  br label %do.body171, !dbg !1919

do.body171:                                       ; preds = %do.body170
  %lh_first172 = getelementptr inbounds %struct.setlist* %freelist, i32 0, i32 0, !dbg !1921
  %102 = load %struct.cpuset** %lh_first172, align 8, !dbg !1921
  %cmp173 = icmp ne %struct.cpuset* %102, null, !dbg !1921
  br i1 %cmp173, label %land.lhs.true175, label %if.end183, !dbg !1921

land.lhs.true175:                                 ; preds = %do.body171
  %lh_first176 = getelementptr inbounds %struct.setlist* %freelist, i32 0, i32 0, !dbg !1921
  %103 = load %struct.cpuset** %lh_first176, align 8, !dbg !1921
  %cs_link177 = getelementptr inbounds %struct.cpuset* %103, i32 0, i32 5, !dbg !1921
  %le_prev178 = getelementptr inbounds %struct.anon.7* %cs_link177, i32 0, i32 1, !dbg !1921
  %104 = load %struct.cpuset*** %le_prev178, align 8, !dbg !1921
  %lh_first179 = getelementptr inbounds %struct.setlist* %freelist, i32 0, i32 0, !dbg !1921
  %cmp180 = icmp ne %struct.cpuset** %104, %lh_first179, !dbg !1921
  br i1 %cmp180, label %if.then182, label %if.end183, !dbg !1921

if.then182:                                       ; preds = %land.lhs.true175
  call void (i8*, ...)* @panic(i8* getelementptr inbounds ([37 x i8]* @.str7, i32 0, i32 0), %struct.setlist* %freelist) #8, !dbg !1921
  unreachable, !dbg !1921

if.end183:                                        ; preds = %land.lhs.true175, %do.body171
  br label %do.end184, !dbg !1921

do.end184:                                        ; preds = %if.end183
  %lh_first185 = getelementptr inbounds %struct.setlist* %freelist, i32 0, i32 0, !dbg !1919
  %105 = load %struct.cpuset** %lh_first185, align 8, !dbg !1919
  %106 = load %struct.cpuset** %nset, align 8, !dbg !1919
  %cs_link186 = getelementptr inbounds %struct.cpuset* %106, i32 0, i32 5, !dbg !1919
  %le_next187 = getelementptr inbounds %struct.anon.7* %cs_link186, i32 0, i32 0, !dbg !1919
  store %struct.cpuset* %105, %struct.cpuset** %le_next187, align 8, !dbg !1919
  %cmp188 = icmp ne %struct.cpuset* %105, null, !dbg !1919
  br i1 %cmp188, label %if.then190, label %if.end196, !dbg !1919

if.then190:                                       ; preds = %do.end184
  %107 = load %struct.cpuset** %nset, align 8, !dbg !1919
  %cs_link191 = getelementptr inbounds %struct.cpuset* %107, i32 0, i32 5, !dbg !1919
  %le_next192 = getelementptr inbounds %struct.anon.7* %cs_link191, i32 0, i32 0, !dbg !1919
  %lh_first193 = getelementptr inbounds %struct.setlist* %freelist, i32 0, i32 0, !dbg !1919
  %108 = load %struct.cpuset** %lh_first193, align 8, !dbg !1919
  %cs_link194 = getelementptr inbounds %struct.cpuset* %108, i32 0, i32 5, !dbg !1919
  %le_prev195 = getelementptr inbounds %struct.anon.7* %cs_link194, i32 0, i32 1, !dbg !1919
  store %struct.cpuset** %le_next192, %struct.cpuset*** %le_prev195, align 8, !dbg !1919
  br label %if.end196, !dbg !1919

if.end196:                                        ; preds = %if.then190, %do.end184
  %109 = load %struct.cpuset** %nset, align 8, !dbg !1919
  %lh_first197 = getelementptr inbounds %struct.setlist* %freelist, i32 0, i32 0, !dbg !1919
  store %struct.cpuset* %109, %struct.cpuset** %lh_first197, align 8, !dbg !1919
  %lh_first198 = getelementptr inbounds %struct.setlist* %freelist, i32 0, i32 0, !dbg !1919
  %110 = load %struct.cpuset** %nset, align 8, !dbg !1919
  %cs_link199 = getelementptr inbounds %struct.cpuset* %110, i32 0, i32 5, !dbg !1919
  %le_prev200 = getelementptr inbounds %struct.anon.7* %cs_link199, i32 0, i32 1, !dbg !1919
  store %struct.cpuset** %lh_first198, %struct.cpuset*** %le_prev200, align 8, !dbg !1919
  br label %do.end201, !dbg !1919

do.end201:                                        ; preds = %if.end196
  %111 = load %struct.thread** %td, align 8, !dbg !1923
  %td_lock202 = getelementptr inbounds %struct.thread* %111, i32 0, i32 0, !dbg !1923
  %112 = load volatile %struct.mtx** %td_lock202, align 8, !dbg !1923
  %mtx_lock203 = getelementptr inbounds %struct.mtx* %112, i32 0, i32 1, !dbg !1923
  call void @__mtx_unlock_spin_flags(i64* %mtx_lock203, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 601) #7, !dbg !1923
  br label %for.end214, !dbg !1924

if.end204:                                        ; preds = %if.end167
  br label %if.end207, !dbg !1925

if.else205:                                       ; preds = %lor.lhs.false
  %113 = load %struct.cpuset** %set.addr, align 8, !dbg !1926
  %call206 = call %struct.cpuset* @cpuset_ref(%struct.cpuset* %113) #7, !dbg !1926
  store %struct.cpuset* %call206, %struct.cpuset** %nset, align 8, !dbg !1926
  br label %if.end207

if.end207:                                        ; preds = %if.else205, %if.end204
  %114 = load %struct.cpuset** %tdset, align 8, !dbg !1927
  call void @cpuset_rel_defer(%struct.setlist* %droplist, %struct.cpuset* %114) #7, !dbg !1927
  %115 = load %struct.cpuset** %nset, align 8, !dbg !1928
  %116 = load %struct.thread** %td, align 8, !dbg !1928
  %td_cpuset208 = getelementptr inbounds %struct.thread* %116, i32 0, i32 7, !dbg !1928
  store %struct.cpuset* %115, %struct.cpuset** %td_cpuset208, align 8, !dbg !1928
  %117 = load %struct.thread** %td, align 8, !dbg !1929
  call void @sched_affinity(%struct.thread* %117) #7, !dbg !1929
  %118 = load %struct.thread** %td, align 8, !dbg !1930
  %td_lock209 = getelementptr inbounds %struct.thread* %118, i32 0, i32 0, !dbg !1930
  %119 = load volatile %struct.mtx** %td_lock209, align 8, !dbg !1930
  %mtx_lock210 = getelementptr inbounds %struct.mtx* %119, i32 0, i32 1, !dbg !1930
  call void @__mtx_unlock_spin_flags(i64* %mtx_lock210, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 609) #7, !dbg !1930
  br label %for.inc211, !dbg !1931

for.inc211:                                       ; preds = %if.end207
  %120 = load %struct.thread** %td, align 8, !dbg !1898
  %td_plist212 = getelementptr inbounds %struct.thread* %120, i32 0, i32 2, !dbg !1898
  %tqe_next213 = getelementptr inbounds %struct.anon.35* %td_plist212, i32 0, i32 0, !dbg !1898
  %121 = load %struct.thread** %tqe_next213, align 8, !dbg !1898
  store %struct.thread* %121, %struct.thread** %td, align 8, !dbg !1898
  br label %for.cond108, !dbg !1898

for.end214:                                       ; preds = %do.end201, %for.cond108
  br label %unlock_out, !dbg !1932

unlock_out:                                       ; preds = %for.end214, %if.then102
  %122 = load %struct.proc** %p, align 8, !dbg !1933
  %p_mtx215 = getelementptr inbounds %struct.proc* %122, i32 0, i32 18, !dbg !1933
  %mtx_lock216 = getelementptr inbounds %struct.mtx* %p_mtx215, i32 0, i32 1, !dbg !1933
  call void @__mtx_unlock_flags(i64* %mtx_lock216, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 612) #7, !dbg !1933
  br label %out, !dbg !1933

out:                                              ; preds = %unlock_out, %if.then
  br label %while.cond, !dbg !1934

while.cond:                                       ; preds = %while.body, %out
  %lh_first217 = getelementptr inbounds %struct.setlist* %droplist, i32 0, i32 0, !dbg !1934
  %123 = load %struct.cpuset** %lh_first217, align 8, !dbg !1934
  store %struct.cpuset* %123, %struct.cpuset** %nset, align 8, !dbg !1934
  %cmp218 = icmp ne %struct.cpuset* %123, null, !dbg !1934
  br i1 %cmp218, label %while.body, label %while.end, !dbg !1934

while.body:                                       ; preds = %while.cond
  %124 = load %struct.cpuset** %nset, align 8, !dbg !1935
  call void @cpuset_rel_complete(%struct.cpuset* %124) #7, !dbg !1935
  br label %while.cond, !dbg !1935

while.end:                                        ; preds = %while.cond
  br label %while.cond220, !dbg !1936

while.cond220:                                    ; preds = %do.end267, %while.end
  %lh_first221 = getelementptr inbounds %struct.setlist* %freelist, i32 0, i32 0, !dbg !1936
  %125 = load %struct.cpuset** %lh_first221, align 8, !dbg !1936
  store %struct.cpuset* %125, %struct.cpuset** %nset, align 8, !dbg !1936
  %cmp222 = icmp ne %struct.cpuset* %125, null, !dbg !1936
  br i1 %cmp222, label %while.body224, label %while.end268, !dbg !1936

while.body224:                                    ; preds = %while.cond220
  br label %do.body225, !dbg !1937

do.body225:                                       ; preds = %while.body224
  br label %do.body226, !dbg !1939

do.body226:                                       ; preds = %do.body225
  %126 = load %struct.cpuset** %nset, align 8, !dbg !1941
  %cs_link227 = getelementptr inbounds %struct.cpuset* %126, i32 0, i32 5, !dbg !1941
  %le_next228 = getelementptr inbounds %struct.anon.7* %cs_link227, i32 0, i32 0, !dbg !1941
  %127 = load %struct.cpuset** %le_next228, align 8, !dbg !1941
  %cmp229 = icmp ne %struct.cpuset* %127, null, !dbg !1941
  br i1 %cmp229, label %land.lhs.true231, label %if.end241, !dbg !1941

land.lhs.true231:                                 ; preds = %do.body226
  %128 = load %struct.cpuset** %nset, align 8, !dbg !1941
  %cs_link232 = getelementptr inbounds %struct.cpuset* %128, i32 0, i32 5, !dbg !1941
  %le_next233 = getelementptr inbounds %struct.anon.7* %cs_link232, i32 0, i32 0, !dbg !1941
  %129 = load %struct.cpuset** %le_next233, align 8, !dbg !1941
  %cs_link234 = getelementptr inbounds %struct.cpuset* %129, i32 0, i32 5, !dbg !1941
  %le_prev235 = getelementptr inbounds %struct.anon.7* %cs_link234, i32 0, i32 1, !dbg !1941
  %130 = load %struct.cpuset*** %le_prev235, align 8, !dbg !1941
  %131 = load %struct.cpuset** %nset, align 8, !dbg !1941
  %cs_link236 = getelementptr inbounds %struct.cpuset* %131, i32 0, i32 5, !dbg !1941
  %le_next237 = getelementptr inbounds %struct.anon.7* %cs_link236, i32 0, i32 0, !dbg !1941
  %cmp238 = icmp ne %struct.cpuset** %130, %le_next237, !dbg !1941
  br i1 %cmp238, label %if.then240, label %if.end241, !dbg !1941

if.then240:                                       ; preds = %land.lhs.true231
  %132 = load %struct.cpuset** %nset, align 8, !dbg !1941
  call void (i8*, ...)* @panic(i8* getelementptr inbounds ([34 x i8]* @.str1, i32 0, i32 0), %struct.cpuset* %132) #8, !dbg !1941
  unreachable, !dbg !1941

if.end241:                                        ; preds = %land.lhs.true231, %do.body226
  br label %do.end242, !dbg !1941

do.end242:                                        ; preds = %if.end241
  br label %do.body243, !dbg !1939

do.body243:                                       ; preds = %do.end242
  %133 = load %struct.cpuset** %nset, align 8, !dbg !1943
  %cs_link244 = getelementptr inbounds %struct.cpuset* %133, i32 0, i32 5, !dbg !1943
  %le_prev245 = getelementptr inbounds %struct.anon.7* %cs_link244, i32 0, i32 1, !dbg !1943
  %134 = load %struct.cpuset*** %le_prev245, align 8, !dbg !1943
  %135 = load %struct.cpuset** %134, align 8, !dbg !1943
  %136 = load %struct.cpuset** %nset, align 8, !dbg !1943
  %cmp246 = icmp ne %struct.cpuset* %135, %136, !dbg !1943
  br i1 %cmp246, label %if.then248, label %if.end249, !dbg !1943

if.then248:                                       ; preds = %do.body243
  %137 = load %struct.cpuset** %nset, align 8, !dbg !1943
  call void (i8*, ...)* @panic(i8* getelementptr inbounds ([34 x i8]* @.str2, i32 0, i32 0), %struct.cpuset* %137) #8, !dbg !1943
  unreachable, !dbg !1943

if.end249:                                        ; preds = %do.body243
  br label %do.end250, !dbg !1943

do.end250:                                        ; preds = %if.end249
  %138 = load %struct.cpuset** %nset, align 8, !dbg !1939
  %cs_link251 = getelementptr inbounds %struct.cpuset* %138, i32 0, i32 5, !dbg !1939
  %le_next252 = getelementptr inbounds %struct.anon.7* %cs_link251, i32 0, i32 0, !dbg !1939
  %139 = load %struct.cpuset** %le_next252, align 8, !dbg !1939
  %cmp253 = icmp ne %struct.cpuset* %139, null, !dbg !1939
  br i1 %cmp253, label %if.then255, label %if.end262, !dbg !1939

if.then255:                                       ; preds = %do.end250
  %140 = load %struct.cpuset** %nset, align 8, !dbg !1939
  %cs_link256 = getelementptr inbounds %struct.cpuset* %140, i32 0, i32 5, !dbg !1939
  %le_prev257 = getelementptr inbounds %struct.anon.7* %cs_link256, i32 0, i32 1, !dbg !1939
  %141 = load %struct.cpuset*** %le_prev257, align 8, !dbg !1939
  %142 = load %struct.cpuset** %nset, align 8, !dbg !1939
  %cs_link258 = getelementptr inbounds %struct.cpuset* %142, i32 0, i32 5, !dbg !1939
  %le_next259 = getelementptr inbounds %struct.anon.7* %cs_link258, i32 0, i32 0, !dbg !1939
  %143 = load %struct.cpuset** %le_next259, align 8, !dbg !1939
  %cs_link260 = getelementptr inbounds %struct.cpuset* %143, i32 0, i32 5, !dbg !1939
  %le_prev261 = getelementptr inbounds %struct.anon.7* %cs_link260, i32 0, i32 1, !dbg !1939
  store %struct.cpuset** %141, %struct.cpuset*** %le_prev261, align 8, !dbg !1939
  br label %if.end262, !dbg !1939

if.end262:                                        ; preds = %if.then255, %do.end250
  %144 = load %struct.cpuset** %nset, align 8, !dbg !1939
  %cs_link263 = getelementptr inbounds %struct.cpuset* %144, i32 0, i32 5, !dbg !1939
  %le_next264 = getelementptr inbounds %struct.anon.7* %cs_link263, i32 0, i32 0, !dbg !1939
  %145 = load %struct.cpuset** %le_next264, align 8, !dbg !1939
  %146 = load %struct.cpuset** %nset, align 8, !dbg !1939
  %cs_link265 = getelementptr inbounds %struct.cpuset* %146, i32 0, i32 5, !dbg !1939
  %le_prev266 = getelementptr inbounds %struct.anon.7* %cs_link265, i32 0, i32 1, !dbg !1939
  %147 = load %struct.cpuset*** %le_prev266, align 8, !dbg !1939
  store %struct.cpuset* %145, %struct.cpuset** %147, align 8, !dbg !1939
  br label %do.end267, !dbg !1939

do.end267:                                        ; preds = %if.end262
  %148 = load %struct.uma_zone** @cpuset_zone, align 8, !dbg !1945
  %149 = load %struct.cpuset** %nset, align 8, !dbg !1945
  %150 = bitcast %struct.cpuset* %149 to i8*, !dbg !1945
  call void @uma_zfree(%struct.uma_zone* %148, i8* %150) #7, !dbg !1945
  br label %while.cond220, !dbg !1946

while.end268:                                     ; preds = %while.cond220
  %151 = load i32* %error, align 4, !dbg !1947
  ret i32 %151, !dbg !1947
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys_cpuset(%struct.thread* %td, %struct.cpuset_args* %uap) #0 {
entry:
  %retval = alloca i32, align 4
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.cpuset_args*, align 8
  %root = alloca %struct.cpuset*, align 8
  %set = alloca %struct.cpuset*, align 8
  %error = alloca i32, align 4
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !1948), !dbg !1949
  store %struct.cpuset_args* %uap, %struct.cpuset_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.cpuset_args** %uap.addr}, metadata !1950), !dbg !1949
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %root}, metadata !1951), !dbg !1952
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %set}, metadata !1953), !dbg !1954
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !1955), !dbg !1956
  %0 = load %struct.thread** %td.addr, align 8, !dbg !1957
  call void @thread_lock_flags_(%struct.thread* %0, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 863) #7, !dbg !1957
  %1 = load %struct.thread** %td.addr, align 8, !dbg !1958
  %td_cpuset = getelementptr inbounds %struct.thread* %1, i32 0, i32 7, !dbg !1958
  %2 = load %struct.cpuset** %td_cpuset, align 8, !dbg !1958
  %call = call %struct.cpuset* @cpuset_refroot(%struct.cpuset* %2) #7, !dbg !1958
  store %struct.cpuset* %call, %struct.cpuset** %root, align 8, !dbg !1958
  %3 = load %struct.thread** %td.addr, align 8, !dbg !1959
  %td_lock = getelementptr inbounds %struct.thread* %3, i32 0, i32 0, !dbg !1959
  %4 = load volatile %struct.mtx** %td_lock, align 8, !dbg !1959
  %mtx_lock = getelementptr inbounds %struct.mtx* %4, i32 0, i32 1, !dbg !1959
  call void @__mtx_unlock_spin_flags(i64* %mtx_lock, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 865) #7, !dbg !1959
  %5 = load %struct.cpuset** %root, align 8, !dbg !1960
  %6 = load %struct.cpuset** %root, align 8, !dbg !1960
  %cs_mask = getelementptr inbounds %struct.cpuset* %6, i32 0, i32 0, !dbg !1960
  %call1 = call i32 @cpuset_create(%struct.cpuset** %set, %struct.cpuset* %5, %struct._cpuset* %cs_mask) #7, !dbg !1960
  store i32 %call1, i32* %error, align 4, !dbg !1960
  %7 = load %struct.cpuset** %root, align 8, !dbg !1961
  call void @cpuset_rel(%struct.cpuset* %7) #7, !dbg !1961
  %8 = load i32* %error, align 4, !dbg !1962
  %tobool = icmp ne i32 %8, 0, !dbg !1962
  br i1 %tobool, label %if.then, label %if.end, !dbg !1962

if.then:                                          ; preds = %entry
  %9 = load i32* %error, align 4, !dbg !1963
  store i32 %9, i32* %retval, !dbg !1963
  br label %return, !dbg !1963

if.end:                                           ; preds = %entry
  %10 = load %struct.cpuset** %set, align 8, !dbg !1964
  %cs_id = getelementptr inbounds %struct.cpuset* %10, i32 0, i32 3, !dbg !1964
  %11 = bitcast i32* %cs_id to i8*, !dbg !1964
  %12 = load %struct.cpuset_args** %uap.addr, align 8, !dbg !1964
  %setid = getelementptr inbounds %struct.cpuset_args* %12, i32 0, i32 1, !dbg !1964
  %13 = load i32** %setid, align 8, !dbg !1964
  %14 = bitcast i32* %13 to i8*, !dbg !1964
  %call2 = call i32 @copyout(i8* %11, i8* %14, i64 4) #7, !dbg !1964
  store i32 %call2, i32* %error, align 4, !dbg !1964
  %15 = load i32* %error, align 4, !dbg !1965
  %cmp = icmp eq i32 %15, 0, !dbg !1965
  br i1 %cmp, label %if.then3, label %if.end5, !dbg !1965

if.then3:                                         ; preds = %if.end
  %16 = load %struct.cpuset** %set, align 8, !dbg !1966
  %call4 = call i32 @cpuset_setproc(i32 -1, %struct.cpuset* %16, %struct._cpuset* null) #7, !dbg !1966
  store i32 %call4, i32* %error, align 4, !dbg !1966
  br label %if.end5, !dbg !1966

if.end5:                                          ; preds = %if.then3, %if.end
  %17 = load %struct.cpuset** %set, align 8, !dbg !1967
  call void @cpuset_rel(%struct.cpuset* %17) #7, !dbg !1967
  %18 = load i32* %error, align 4, !dbg !1968
  store i32 %18, i32* %retval, !dbg !1968
  br label %return, !dbg !1968

return:                                           ; preds = %if.end5, %if.then
  %19 = load i32* %retval, !dbg !1969
  ret i32 %19, !dbg !1969
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define internal %struct.cpuset* @cpuset_refroot(%struct.cpuset* %set) #0 {
entry:
  %set.addr = alloca %struct.cpuset*, align 8
  store %struct.cpuset* %set, %struct.cpuset** %set.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %set.addr}, metadata !1970), !dbg !1971
  br label %for.cond, !dbg !1972

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load %struct.cpuset** %set.addr, align 8, !dbg !1972
  %cs_parent = getelementptr inbounds %struct.cpuset* %0, i32 0, i32 4, !dbg !1972
  %1 = load %struct.cpuset** %cs_parent, align 8, !dbg !1972
  %cmp = icmp ne %struct.cpuset* %1, null, !dbg !1972
  br i1 %cmp, label %for.body, label %for.end, !dbg !1972

for.body:                                         ; preds = %for.cond
  %2 = load %struct.cpuset** %set.addr, align 8, !dbg !1974
  %cs_flags = getelementptr inbounds %struct.cpuset* %2, i32 0, i32 2, !dbg !1974
  %3 = load i32* %cs_flags, align 4, !dbg !1974
  %and = and i32 %3, 1, !dbg !1974
  %tobool = icmp ne i32 %and, 0, !dbg !1974
  br i1 %tobool, label %if.then, label %if.end, !dbg !1974

if.then:                                          ; preds = %for.body
  br label %for.end, !dbg !1975

if.end:                                           ; preds = %for.body
  br label %for.inc, !dbg !1975

for.inc:                                          ; preds = %if.end
  %4 = load %struct.cpuset** %set.addr, align 8, !dbg !1972
  %cs_parent1 = getelementptr inbounds %struct.cpuset* %4, i32 0, i32 4, !dbg !1972
  %5 = load %struct.cpuset** %cs_parent1, align 8, !dbg !1972
  store %struct.cpuset* %5, %struct.cpuset** %set.addr, align 8, !dbg !1972
  br label %for.cond, !dbg !1972

for.end:                                          ; preds = %if.then, %for.cond
  %6 = load %struct.cpuset** %set.addr, align 8, !dbg !1976
  %call = call %struct.cpuset* @cpuset_ref(%struct.cpuset* %6) #7, !dbg !1976
  %7 = load %struct.cpuset** %set.addr, align 8, !dbg !1977
  ret %struct.cpuset* %7, !dbg !1977
}

; Function Attrs: noimplicitfloat noredzone
declare i32 @copyout(i8*, i8*, i64) #3

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys_cpuset_setid(%struct.thread* %td, %struct.cpuset_setid_args* %uap) #0 {
entry:
  %retval = alloca i32, align 4
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.cpuset_setid_args*, align 8
  %set = alloca %struct.cpuset*, align 8
  %error = alloca i32, align 4
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !1978), !dbg !1979
  store %struct.cpuset_setid_args* %uap, %struct.cpuset_setid_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.cpuset_setid_args** %uap.addr}, metadata !1980), !dbg !1979
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %set}, metadata !1981), !dbg !1982
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !1983), !dbg !1984
  %0 = load %struct.cpuset_setid_args** %uap.addr, align 8, !dbg !1985
  %which = getelementptr inbounds %struct.cpuset_setid_args* %0, i32 0, i32 1, !dbg !1985
  %1 = load i32* %which, align 4, !dbg !1985
  %cmp = icmp ne i32 %1, 2, !dbg !1985
  br i1 %cmp, label %if.then, label %if.end, !dbg !1985

if.then:                                          ; preds = %entry
  store i32 22, i32* %retval, !dbg !1986
  br label %return, !dbg !1986

if.end:                                           ; preds = %entry
  %2 = load %struct.cpuset_setid_args** %uap.addr, align 8, !dbg !1987
  %setid = getelementptr inbounds %struct.cpuset_setid_args* %2, i32 0, i32 7, !dbg !1987
  %3 = load i32* %setid, align 4, !dbg !1987
  %4 = load %struct.thread** %td.addr, align 8, !dbg !1987
  %call = call %struct.cpuset* @cpuset_lookup(i32 %3, %struct.thread* %4) #7, !dbg !1987
  store %struct.cpuset* %call, %struct.cpuset** %set, align 8, !dbg !1987
  %5 = load %struct.cpuset** %set, align 8, !dbg !1988
  %cmp1 = icmp eq %struct.cpuset* %5, null, !dbg !1988
  br i1 %cmp1, label %if.then2, label %if.end3, !dbg !1988

if.then2:                                         ; preds = %if.end
  store i32 3, i32* %retval, !dbg !1989
  br label %return, !dbg !1989

if.end3:                                          ; preds = %if.end
  %6 = load %struct.cpuset_setid_args** %uap.addr, align 8, !dbg !1990
  %id = getelementptr inbounds %struct.cpuset_setid_args* %6, i32 0, i32 4, !dbg !1990
  %7 = load i64* %id, align 8, !dbg !1990
  %conv = trunc i64 %7 to i32, !dbg !1990
  %8 = load %struct.cpuset** %set, align 8, !dbg !1990
  %call4 = call i32 @cpuset_setproc(i32 %conv, %struct.cpuset* %8, %struct._cpuset* null) #7, !dbg !1990
  store i32 %call4, i32* %error, align 4, !dbg !1990
  %9 = load %struct.cpuset** %set, align 8, !dbg !1991
  call void @cpuset_rel(%struct.cpuset* %9) #7, !dbg !1991
  %10 = load i32* %error, align 4, !dbg !1992
  store i32 %10, i32* %retval, !dbg !1992
  br label %return, !dbg !1992

return:                                           ; preds = %if.end3, %if.then2, %if.then
  %11 = load i32* %retval, !dbg !1993
  ret i32 %11, !dbg !1993
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define internal %struct.cpuset* @cpuset_lookup(i32 %setid, %struct.thread* %td) #0 {
entry:
  %retval = alloca %struct.cpuset*, align 8
  %setid.addr = alloca i32, align 4
  %td.addr = alloca %struct.thread*, align 8
  %set = alloca %struct.cpuset*, align 8
  %jset = alloca %struct.cpuset*, align 8
  %tset = alloca %struct.cpuset*, align 8
  store i32 %setid, i32* %setid.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %setid.addr}, metadata !1994), !dbg !1995
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !1996), !dbg !1995
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %set}, metadata !1997), !dbg !1998
  %0 = load i32* %setid.addr, align 4, !dbg !1999
  %cmp = icmp eq i32 %0, -1, !dbg !1999
  br i1 %cmp, label %if.then, label %if.end, !dbg !1999

if.then:                                          ; preds = %entry
  store %struct.cpuset* null, %struct.cpuset** %retval, !dbg !2000
  br label %return, !dbg !2000

if.end:                                           ; preds = %entry
  call void @__mtx_lock_spin_flags(i64* getelementptr inbounds (%struct.mtx* @cpuset_lock, i32 0, i32 1), i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 225) #7, !dbg !2001
  %1 = load %struct.cpuset** getelementptr inbounds (%struct.setlist* @cpuset_ids, i32 0, i32 0), align 8, !dbg !2002
  store %struct.cpuset* %1, %struct.cpuset** %set, align 8, !dbg !2002
  br label %for.cond, !dbg !2002

for.cond:                                         ; preds = %for.inc, %if.end
  %2 = load %struct.cpuset** %set, align 8, !dbg !2002
  %tobool = icmp ne %struct.cpuset* %2, null, !dbg !2002
  br i1 %tobool, label %for.body, label %for.end, !dbg !2002

for.body:                                         ; preds = %for.cond
  %3 = load %struct.cpuset** %set, align 8, !dbg !2004
  %cs_id = getelementptr inbounds %struct.cpuset* %3, i32 0, i32 3, !dbg !2004
  %4 = load i32* %cs_id, align 4, !dbg !2004
  %5 = load i32* %setid.addr, align 4, !dbg !2004
  %cmp1 = icmp eq i32 %4, %5, !dbg !2004
  br i1 %cmp1, label %if.then2, label %if.end3, !dbg !2004

if.then2:                                         ; preds = %for.body
  br label %for.end, !dbg !2005

if.end3:                                          ; preds = %for.body
  br label %for.inc, !dbg !2005

for.inc:                                          ; preds = %if.end3
  %6 = load %struct.cpuset** %set, align 8, !dbg !2002
  %cs_link = getelementptr inbounds %struct.cpuset* %6, i32 0, i32 5, !dbg !2002
  %le_next = getelementptr inbounds %struct.anon.7* %cs_link, i32 0, i32 0, !dbg !2002
  %7 = load %struct.cpuset** %le_next, align 8, !dbg !2002
  store %struct.cpuset* %7, %struct.cpuset** %set, align 8, !dbg !2002
  br label %for.cond, !dbg !2002

for.end:                                          ; preds = %if.then2, %for.cond
  %8 = load %struct.cpuset** %set, align 8, !dbg !2006
  %tobool4 = icmp ne %struct.cpuset* %8, null, !dbg !2006
  br i1 %tobool4, label %if.then5, label %if.end6, !dbg !2006

if.then5:                                         ; preds = %for.end
  %9 = load %struct.cpuset** %set, align 8, !dbg !2007
  %call = call %struct.cpuset* @cpuset_ref(%struct.cpuset* %9) #7, !dbg !2007
  br label %if.end6, !dbg !2007

if.end6:                                          ; preds = %if.then5, %for.end
  call void @__mtx_unlock_spin_flags(i64* getelementptr inbounds (%struct.mtx* @cpuset_lock, i32 0, i32 1), i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 231) #7, !dbg !2008
  br label %do.body, !dbg !2009

do.body:                                          ; preds = %if.end6
  %10 = load %struct.thread** %td.addr, align 8, !dbg !2010
  %cmp7 = icmp ne %struct.thread* %10, null, !dbg !2010
  %lnot = xor i1 %cmp7, true, !dbg !2010
  %lnot.ext = zext i1 %lnot to i32, !dbg !2010
  %conv = sext i32 %lnot.ext to i64, !dbg !2010
  %expval = call i64 @llvm.expect.i64(i64 %conv, i64 0), !dbg !2010
  %tobool8 = icmp ne i64 %expval, 0, !dbg !2010
  br i1 %tobool8, label %if.then9, label %if.end10, !dbg !2010

if.then9:                                         ; preds = %do.body
  call void (i8*, ...)* @kassert_panic(i8* getelementptr inbounds ([19 x i8]* @.str20, i32 0, i32 0), i8* getelementptr inbounds ([14 x i8]* @__func__.cpuset_lookup, i32 0, i32 0), i32 233) #7, !dbg !2010
  br label %if.end10, !dbg !2010

if.end10:                                         ; preds = %if.then9, %do.body
  br label %do.end, !dbg !2010

do.end:                                           ; preds = %if.end10
  %11 = load %struct.cpuset** %set, align 8, !dbg !2012
  %cmp11 = icmp ne %struct.cpuset* %11, null, !dbg !2012
  br i1 %cmp11, label %land.lhs.true, label %if.end31, !dbg !2012

land.lhs.true:                                    ; preds = %do.end
  %12 = load %struct.thread** %td.addr, align 8, !dbg !2012
  %td_ucred = getelementptr inbounds %struct.thread* %12, i32 0, i32 37, !dbg !2012
  %13 = load %struct.ucred** %td_ucred, align 8, !dbg !2012
  %call13 = call i32 @jailed(%struct.ucred* %13) #7, !dbg !2012
  %tobool14 = icmp ne i32 %call13, 0, !dbg !2012
  br i1 %tobool14, label %if.then15, label %if.end31, !dbg !2012

if.then15:                                        ; preds = %land.lhs.true
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %jset}, metadata !2013), !dbg !2015
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %tset}, metadata !2016), !dbg !2015
  %14 = load %struct.thread** %td.addr, align 8, !dbg !2017
  %td_ucred16 = getelementptr inbounds %struct.thread* %14, i32 0, i32 37, !dbg !2017
  %15 = load %struct.ucred** %td_ucred16, align 8, !dbg !2017
  %cr_prison = getelementptr inbounds %struct.ucred* %15, i32 0, i32 9, !dbg !2017
  %16 = load %struct.prison** %cr_prison, align 8, !dbg !2017
  %pr_cpuset = getelementptr inbounds %struct.prison* %16, i32 0, i32 11, !dbg !2017
  %17 = load %struct.cpuset** %pr_cpuset, align 8, !dbg !2017
  store %struct.cpuset* %17, %struct.cpuset** %jset, align 8, !dbg !2017
  %18 = load %struct.cpuset** %set, align 8, !dbg !2018
  store %struct.cpuset* %18, %struct.cpuset** %tset, align 8, !dbg !2018
  br label %for.cond17, !dbg !2018

for.cond17:                                       ; preds = %for.inc25, %if.then15
  %19 = load %struct.cpuset** %tset, align 8, !dbg !2018
  %cmp18 = icmp ne %struct.cpuset* %19, null, !dbg !2018
  br i1 %cmp18, label %for.body20, label %for.end26, !dbg !2018

for.body20:                                       ; preds = %for.cond17
  %20 = load %struct.cpuset** %tset, align 8, !dbg !2020
  %21 = load %struct.cpuset** %jset, align 8, !dbg !2020
  %cmp21 = icmp eq %struct.cpuset* %20, %21, !dbg !2020
  br i1 %cmp21, label %if.then23, label %if.end24, !dbg !2020

if.then23:                                        ; preds = %for.body20
  br label %for.end26, !dbg !2021

if.end24:                                         ; preds = %for.body20
  br label %for.inc25, !dbg !2021

for.inc25:                                        ; preds = %if.end24
  %22 = load %struct.cpuset** %tset, align 8, !dbg !2018
  %cs_parent = getelementptr inbounds %struct.cpuset* %22, i32 0, i32 4, !dbg !2018
  %23 = load %struct.cpuset** %cs_parent, align 8, !dbg !2018
  store %struct.cpuset* %23, %struct.cpuset** %tset, align 8, !dbg !2018
  br label %for.cond17, !dbg !2018

for.end26:                                        ; preds = %if.then23, %for.cond17
  %24 = load %struct.cpuset** %tset, align 8, !dbg !2022
  %cmp27 = icmp eq %struct.cpuset* %24, null, !dbg !2022
  br i1 %cmp27, label %if.then29, label %if.end30, !dbg !2022

if.then29:                                        ; preds = %for.end26
  %25 = load %struct.cpuset** %set, align 8, !dbg !2023
  call void @cpuset_rel(%struct.cpuset* %25) #7, !dbg !2023
  store %struct.cpuset* null, %struct.cpuset** %set, align 8, !dbg !2025
  br label %if.end30, !dbg !2026

if.end30:                                         ; preds = %if.then29, %for.end26
  br label %if.end31, !dbg !2027

if.end31:                                         ; preds = %if.end30, %land.lhs.true, %do.end
  %26 = load %struct.cpuset** %set, align 8, !dbg !2028
  store %struct.cpuset* %26, %struct.cpuset** %retval, !dbg !2028
  br label %return, !dbg !2028

return:                                           ; preds = %if.end31, %if.then
  %27 = load %struct.cpuset** %retval, !dbg !2029
  ret %struct.cpuset* %27, !dbg !2029
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys_cpuset_getid(%struct.thread* %td, %struct.cpuset_getid_args* %uap) #0 {
entry:
  %retval = alloca i32, align 4
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.cpuset_getid_args*, align 8
  %nset = alloca %struct.cpuset*, align 8
  %set = alloca %struct.cpuset*, align 8
  %ttd = alloca %struct.thread*, align 8
  %p = alloca %struct.proc*, align 8
  %id = alloca i32, align 4
  %error = alloca i32, align 4
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !2030), !dbg !2031
  store %struct.cpuset_getid_args* %uap, %struct.cpuset_getid_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.cpuset_getid_args** %uap.addr}, metadata !2032), !dbg !2031
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %nset}, metadata !2033), !dbg !2034
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %set}, metadata !2035), !dbg !2036
  call void @llvm.dbg.declare(metadata !{%struct.thread** %ttd}, metadata !2037), !dbg !2038
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p}, metadata !2039), !dbg !2040
  call void @llvm.dbg.declare(metadata !{i32* %id}, metadata !2041), !dbg !2042
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !2043), !dbg !2044
  %0 = load %struct.cpuset_getid_args** %uap.addr, align 8, !dbg !2045
  %level = getelementptr inbounds %struct.cpuset_getid_args* %0, i32 0, i32 1, !dbg !2045
  %1 = load i32* %level, align 4, !dbg !2045
  %cmp = icmp eq i32 %1, 3, !dbg !2045
  br i1 %cmp, label %land.lhs.true, label %if.end, !dbg !2045

land.lhs.true:                                    ; preds = %entry
  %2 = load %struct.cpuset_getid_args** %uap.addr, align 8, !dbg !2045
  %which = getelementptr inbounds %struct.cpuset_getid_args* %2, i32 0, i32 4, !dbg !2045
  %3 = load i32* %which, align 4, !dbg !2045
  %cmp1 = icmp ne i32 %3, 3, !dbg !2045
  br i1 %cmp1, label %if.then, label %if.end, !dbg !2045

if.then:                                          ; preds = %land.lhs.true
  store i32 22, i32* %retval, !dbg !2046
  br label %return, !dbg !2046

if.end:                                           ; preds = %land.lhs.true, %entry
  %4 = load %struct.cpuset_getid_args** %uap.addr, align 8, !dbg !2047
  %which2 = getelementptr inbounds %struct.cpuset_getid_args* %4, i32 0, i32 4, !dbg !2047
  %5 = load i32* %which2, align 4, !dbg !2047
  %6 = load %struct.cpuset_getid_args** %uap.addr, align 8, !dbg !2047
  %id3 = getelementptr inbounds %struct.cpuset_getid_args* %6, i32 0, i32 7, !dbg !2047
  %7 = load i64* %id3, align 8, !dbg !2047
  %call = call i32 @cpuset_which(i32 %5, i64 %7, %struct.proc** %p, %struct.thread** %ttd, %struct.cpuset** %set) #7, !dbg !2047
  store i32 %call, i32* %error, align 4, !dbg !2047
  %8 = load i32* %error, align 4, !dbg !2048
  %tobool = icmp ne i32 %8, 0, !dbg !2048
  br i1 %tobool, label %if.then4, label %if.end5, !dbg !2048

if.then4:                                         ; preds = %if.end
  %9 = load i32* %error, align 4, !dbg !2049
  store i32 %9, i32* %retval, !dbg !2049
  br label %return, !dbg !2049

if.end5:                                          ; preds = %if.end
  %10 = load %struct.cpuset_getid_args** %uap.addr, align 8, !dbg !2050
  %which6 = getelementptr inbounds %struct.cpuset_getid_args* %10, i32 0, i32 4, !dbg !2050
  %11 = load i32* %which6, align 4, !dbg !2050
  switch i32 %11, label %sw.epilog [
    i32 1, label %sw.bb
    i32 2, label %sw.bb
    i32 3, label %sw.bb9
    i32 5, label %sw.bb9
    i32 4, label %sw.bb10
  ], !dbg !2050

sw.bb:                                            ; preds = %if.end5, %if.end5
  %12 = load %struct.thread** %ttd, align 8, !dbg !2051
  call void @thread_lock_flags_(%struct.thread* %12, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 929) #7, !dbg !2051
  %13 = load %struct.thread** %ttd, align 8, !dbg !2053
  %td_cpuset = getelementptr inbounds %struct.thread* %13, i32 0, i32 7, !dbg !2053
  %14 = load %struct.cpuset** %td_cpuset, align 8, !dbg !2053
  %call7 = call %struct.cpuset* @cpuset_refbase(%struct.cpuset* %14) #7, !dbg !2053
  store %struct.cpuset* %call7, %struct.cpuset** %set, align 8, !dbg !2053
  %15 = load %struct.thread** %ttd, align 8, !dbg !2054
  %td_lock = getelementptr inbounds %struct.thread* %15, i32 0, i32 0, !dbg !2054
  %16 = load volatile %struct.mtx** %td_lock, align 8, !dbg !2054
  %mtx_lock = getelementptr inbounds %struct.mtx* %16, i32 0, i32 1, !dbg !2054
  call void @__mtx_unlock_spin_flags(i64* %mtx_lock, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 931) #7, !dbg !2054
  %17 = load %struct.proc** %p, align 8, !dbg !2055
  %p_mtx = getelementptr inbounds %struct.proc* %17, i32 0, i32 18, !dbg !2055
  %mtx_lock8 = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !2055
  call void @__mtx_unlock_flags(i64* %mtx_lock8, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 932) #7, !dbg !2055
  br label %sw.epilog, !dbg !2056

sw.bb9:                                           ; preds = %if.end5, %if.end5
  br label %sw.epilog, !dbg !2057

sw.bb10:                                          ; preds = %if.end5
  store i32 22, i32* %retval, !dbg !2058
  br label %return, !dbg !2058

sw.epilog:                                        ; preds = %if.end5, %sw.bb9, %sw.bb
  %18 = load %struct.cpuset_getid_args** %uap.addr, align 8, !dbg !2059
  %level11 = getelementptr inbounds %struct.cpuset_getid_args* %18, i32 0, i32 1, !dbg !2059
  %19 = load i32* %level11, align 4, !dbg !2059
  switch i32 %19, label %sw.epilog16 [
    i32 1, label %sw.bb12
    i32 2, label %sw.bb14
    i32 3, label %sw.bb15
  ], !dbg !2059

sw.bb12:                                          ; preds = %sw.epilog
  %20 = load %struct.cpuset** %set, align 8, !dbg !2060
  %call13 = call %struct.cpuset* @cpuset_refroot(%struct.cpuset* %20) #7, !dbg !2060
  store %struct.cpuset* %call13, %struct.cpuset** %nset, align 8, !dbg !2060
  %21 = load %struct.cpuset** %set, align 8, !dbg !2062
  call void @cpuset_rel(%struct.cpuset* %21) #7, !dbg !2062
  %22 = load %struct.cpuset** %nset, align 8, !dbg !2063
  store %struct.cpuset* %22, %struct.cpuset** %set, align 8, !dbg !2063
  br label %sw.epilog16, !dbg !2064

sw.bb14:                                          ; preds = %sw.epilog
  br label %sw.epilog16, !dbg !2065

sw.bb15:                                          ; preds = %sw.epilog
  br label %sw.epilog16, !dbg !2066

sw.epilog16:                                      ; preds = %sw.epilog, %sw.bb15, %sw.bb14, %sw.bb12
  %23 = load %struct.cpuset** %set, align 8, !dbg !2067
  %cs_id = getelementptr inbounds %struct.cpuset* %23, i32 0, i32 3, !dbg !2067
  %24 = load i32* %cs_id, align 4, !dbg !2067
  store i32 %24, i32* %id, align 4, !dbg !2067
  %25 = load %struct.cpuset** %set, align 8, !dbg !2068
  call void @cpuset_rel(%struct.cpuset* %25) #7, !dbg !2068
  %26 = load i32* %error, align 4, !dbg !2069
  %cmp17 = icmp eq i32 %26, 0, !dbg !2069
  br i1 %cmp17, label %if.then18, label %if.end20, !dbg !2069

if.then18:                                        ; preds = %sw.epilog16
  %27 = bitcast i32* %id to i8*, !dbg !2070
  %28 = load %struct.cpuset_getid_args** %uap.addr, align 8, !dbg !2070
  %setid = getelementptr inbounds %struct.cpuset_getid_args* %28, i32 0, i32 10, !dbg !2070
  %29 = load i32** %setid, align 8, !dbg !2070
  %30 = bitcast i32* %29 to i8*, !dbg !2070
  %call19 = call i32 @copyout(i8* %27, i8* %30, i64 4) #7, !dbg !2070
  store i32 %call19, i32* %error, align 4, !dbg !2070
  br label %if.end20, !dbg !2070

if.end20:                                         ; preds = %if.then18, %sw.epilog16
  %31 = load i32* %error, align 4, !dbg !2071
  store i32 %31, i32* %retval, !dbg !2071
  br label %return, !dbg !2071

return:                                           ; preds = %if.end20, %sw.bb10, %if.then4, %if.then
  %32 = load i32* %retval, !dbg !2072
  ret i32 %32, !dbg !2072
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define internal %struct.cpuset* @cpuset_refbase(%struct.cpuset* %set) #0 {
entry:
  %set.addr = alloca %struct.cpuset*, align 8
  store %struct.cpuset* %set, %struct.cpuset** %set.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %set.addr}, metadata !2073), !dbg !2074
  %0 = load %struct.cpuset** %set.addr, align 8, !dbg !2075
  %cs_id = getelementptr inbounds %struct.cpuset* %0, i32 0, i32 3, !dbg !2075
  %1 = load i32* %cs_id, align 4, !dbg !2075
  %cmp = icmp eq i32 %1, -1, !dbg !2075
  br i1 %cmp, label %if.then, label %if.end, !dbg !2075

if.then:                                          ; preds = %entry
  %2 = load %struct.cpuset** %set.addr, align 8, !dbg !2077
  %cs_parent = getelementptr inbounds %struct.cpuset* %2, i32 0, i32 4, !dbg !2077
  %3 = load %struct.cpuset** %cs_parent, align 8, !dbg !2077
  store %struct.cpuset* %3, %struct.cpuset** %set.addr, align 8, !dbg !2077
  br label %if.end, !dbg !2077

if.end:                                           ; preds = %if.then, %entry
  %4 = load %struct.cpuset** %set.addr, align 8, !dbg !2078
  %call = call %struct.cpuset* @cpuset_ref(%struct.cpuset* %4) #7, !dbg !2078
  %5 = load %struct.cpuset** %set.addr, align 8, !dbg !2079
  ret %struct.cpuset* %5, !dbg !2079
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys_cpuset_getaffinity(%struct.thread* %td, %struct.cpuset_getaffinity_args* %uap) #0 {
entry:
  %retval = alloca i32, align 4
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.cpuset_getaffinity_args*, align 8
  %ttd = alloca %struct.thread*, align 8
  %nset = alloca %struct.cpuset*, align 8
  %set = alloca %struct.cpuset*, align 8
  %p = alloca %struct.proc*, align 8
  %mask = alloca %struct._cpuset*, align 8
  %error = alloca i32, align 4
  %size = alloca i64, align 8
  %__i = alloca i64, align 8
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !2080), !dbg !2081
  store %struct.cpuset_getaffinity_args* %uap, %struct.cpuset_getaffinity_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.cpuset_getaffinity_args** %uap.addr}, metadata !2082), !dbg !2081
  call void @llvm.dbg.declare(metadata !{%struct.thread** %ttd}, metadata !2083), !dbg !2084
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %nset}, metadata !2085), !dbg !2086
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %set}, metadata !2087), !dbg !2088
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p}, metadata !2089), !dbg !2090
  call void @llvm.dbg.declare(metadata !{%struct._cpuset** %mask}, metadata !2091), !dbg !2092
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !2093), !dbg !2094
  call void @llvm.dbg.declare(metadata !{i64* %size}, metadata !2095), !dbg !2096
  %0 = load %struct.cpuset_getaffinity_args** %uap.addr, align 8, !dbg !2097
  %cpusetsize = getelementptr inbounds %struct.cpuset_getaffinity_args* %0, i32 0, i32 10, !dbg !2097
  %1 = load i64* %cpusetsize, align 8, !dbg !2097
  %cmp = icmp ult i64 %1, 8, !dbg !2097
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !2097

lor.lhs.false:                                    ; preds = %entry
  %2 = load %struct.cpuset_getaffinity_args** %uap.addr, align 8, !dbg !2097
  %cpusetsize1 = getelementptr inbounds %struct.cpuset_getaffinity_args* %2, i32 0, i32 10, !dbg !2097
  %3 = load i64* %cpusetsize1, align 8, !dbg !2097
  %cmp2 = icmp ugt i64 %3, 16, !dbg !2097
  br i1 %cmp2, label %if.then, label %if.end, !dbg !2097

if.then:                                          ; preds = %lor.lhs.false, %entry
  store i32 34, i32* %retval, !dbg !2098
  br label %return, !dbg !2098

if.end:                                           ; preds = %lor.lhs.false
  %4 = load %struct.cpuset_getaffinity_args** %uap.addr, align 8, !dbg !2099
  %cpusetsize3 = getelementptr inbounds %struct.cpuset_getaffinity_args* %4, i32 0, i32 10, !dbg !2099
  %5 = load i64* %cpusetsize3, align 8, !dbg !2099
  store i64 %5, i64* %size, align 8, !dbg !2099
  %6 = load i64* %size, align 8, !dbg !2100
  %call = call noalias i8* @malloc(i64 %6, %struct.malloc_type* getelementptr inbounds ([1 x %struct.malloc_type]* @M_TEMP, i32 0, i32 0), i32 258) #7, !dbg !2100
  %7 = bitcast i8* %call to %struct._cpuset*, !dbg !2100
  store %struct._cpuset* %7, %struct._cpuset** %mask, align 8, !dbg !2100
  %8 = load %struct.cpuset_getaffinity_args** %uap.addr, align 8, !dbg !2101
  %which = getelementptr inbounds %struct.cpuset_getaffinity_args* %8, i32 0, i32 4, !dbg !2101
  %9 = load i32* %which, align 4, !dbg !2101
  %10 = load %struct.cpuset_getaffinity_args** %uap.addr, align 8, !dbg !2101
  %id = getelementptr inbounds %struct.cpuset_getaffinity_args* %10, i32 0, i32 7, !dbg !2101
  %11 = load i64* %id, align 8, !dbg !2101
  %call4 = call i32 @cpuset_which(i32 %9, i64 %11, %struct.proc** %p, %struct.thread** %ttd, %struct.cpuset** %set) #7, !dbg !2101
  store i32 %call4, i32* %error, align 4, !dbg !2101
  %12 = load i32* %error, align 4, !dbg !2102
  %tobool = icmp ne i32 %12, 0, !dbg !2102
  br i1 %tobool, label %if.then5, label %if.end6, !dbg !2102

if.then5:                                         ; preds = %if.end
  br label %out, !dbg !2103

if.end6:                                          ; preds = %if.end
  %13 = load %struct.cpuset_getaffinity_args** %uap.addr, align 8, !dbg !2104
  %level = getelementptr inbounds %struct.cpuset_getaffinity_args* %13, i32 0, i32 1, !dbg !2104
  %14 = load i32* %level, align 4, !dbg !2104
  switch i32 %14, label %sw.default [
    i32 1, label %sw.bb
    i32 2, label %sw.bb
    i32 3, label %sw.bb18
  ], !dbg !2104

sw.bb:                                            ; preds = %if.end6, %if.end6
  %15 = load %struct.cpuset_getaffinity_args** %uap.addr, align 8, !dbg !2105
  %which7 = getelementptr inbounds %struct.cpuset_getaffinity_args* %15, i32 0, i32 4, !dbg !2105
  %16 = load i32* %which7, align 4, !dbg !2105
  switch i32 %16, label %sw.epilog [
    i32 1, label %sw.bb8
    i32 2, label %sw.bb8
    i32 3, label %sw.bb10
    i32 5, label %sw.bb10
    i32 4, label %sw.bb11
  ], !dbg !2105

sw.bb8:                                           ; preds = %sw.bb, %sw.bb
  %17 = load %struct.thread** %ttd, align 8, !dbg !2107
  call void @thread_lock_flags_(%struct.thread* %17, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 993) #7, !dbg !2107
  %18 = load %struct.thread** %ttd, align 8, !dbg !2109
  %td_cpuset = getelementptr inbounds %struct.thread* %18, i32 0, i32 7, !dbg !2109
  %19 = load %struct.cpuset** %td_cpuset, align 8, !dbg !2109
  %call9 = call %struct.cpuset* @cpuset_ref(%struct.cpuset* %19) #7, !dbg !2109
  store %struct.cpuset* %call9, %struct.cpuset** %set, align 8, !dbg !2109
  %20 = load %struct.thread** %ttd, align 8, !dbg !2110
  %td_lock = getelementptr inbounds %struct.thread* %20, i32 0, i32 0, !dbg !2110
  %21 = load volatile %struct.mtx** %td_lock, align 8, !dbg !2110
  %mtx_lock = getelementptr inbounds %struct.mtx* %21, i32 0, i32 1, !dbg !2110
  call void @__mtx_unlock_spin_flags(i64* %mtx_lock, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 995) #7, !dbg !2110
  br label %sw.epilog, !dbg !2111

sw.bb10:                                          ; preds = %sw.bb, %sw.bb
  br label %sw.epilog, !dbg !2112

sw.bb11:                                          ; preds = %sw.bb
  store i32 22, i32* %error, align 4, !dbg !2113
  br label %out, !dbg !2114

sw.epilog:                                        ; preds = %sw.bb, %sw.bb10, %sw.bb8
  %22 = load %struct.cpuset_getaffinity_args** %uap.addr, align 8, !dbg !2115
  %level12 = getelementptr inbounds %struct.cpuset_getaffinity_args* %22, i32 0, i32 1, !dbg !2115
  %23 = load i32* %level12, align 4, !dbg !2115
  %cmp13 = icmp eq i32 %23, 1, !dbg !2115
  br i1 %cmp13, label %if.then14, label %if.else, !dbg !2115

if.then14:                                        ; preds = %sw.epilog
  %24 = load %struct.cpuset** %set, align 8, !dbg !2116
  %call15 = call %struct.cpuset* @cpuset_refroot(%struct.cpuset* %24) #7, !dbg !2116
  store %struct.cpuset* %call15, %struct.cpuset** %nset, align 8, !dbg !2116
  br label %if.end17, !dbg !2116

if.else:                                          ; preds = %sw.epilog
  %25 = load %struct.cpuset** %set, align 8, !dbg !2117
  %call16 = call %struct.cpuset* @cpuset_refbase(%struct.cpuset* %25) #7, !dbg !2117
  store %struct.cpuset* %call16, %struct.cpuset** %nset, align 8, !dbg !2117
  br label %if.end17

if.end17:                                         ; preds = %if.else, %if.then14
  %26 = load %struct._cpuset** %mask, align 8, !dbg !2118
  %27 = load %struct.cpuset** %nset, align 8, !dbg !2118
  %cs_mask = getelementptr inbounds %struct.cpuset* %27, i32 0, i32 0, !dbg !2118
  %28 = bitcast %struct._cpuset* %26 to i8*, !dbg !2118
  %29 = bitcast %struct._cpuset* %cs_mask to i8*, !dbg !2118
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %28, i8* %29, i64 8, i32 8, i1 false), !dbg !2118
  %30 = load %struct.cpuset** %nset, align 8, !dbg !2119
  call void @cpuset_rel(%struct.cpuset* %30) #7, !dbg !2119
  br label %sw.epilog44, !dbg !2120

sw.bb18:                                          ; preds = %if.end6
  %31 = load %struct.cpuset_getaffinity_args** %uap.addr, align 8, !dbg !2121
  %which19 = getelementptr inbounds %struct.cpuset_getaffinity_args* %31, i32 0, i32 4, !dbg !2121
  %32 = load i32* %which19, align 4, !dbg !2121
  switch i32 %32, label %sw.epilog43 [
    i32 1, label %sw.bb20
    i32 2, label %sw.bb25
    i32 3, label %sw.bb38
    i32 5, label %sw.bb38
    i32 4, label %sw.bb40
  ], !dbg !2121

sw.bb20:                                          ; preds = %sw.bb18
  %33 = load %struct.thread** %ttd, align 8, !dbg !2122
  call void @thread_lock_flags_(%struct.thread* %33, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 1014) #7, !dbg !2122
  %34 = load %struct._cpuset** %mask, align 8, !dbg !2124
  %35 = load %struct.thread** %ttd, align 8, !dbg !2124
  %td_cpuset21 = getelementptr inbounds %struct.thread* %35, i32 0, i32 7, !dbg !2124
  %36 = load %struct.cpuset** %td_cpuset21, align 8, !dbg !2124
  %cs_mask22 = getelementptr inbounds %struct.cpuset* %36, i32 0, i32 0, !dbg !2124
  %37 = bitcast %struct._cpuset* %34 to i8*, !dbg !2124
  %38 = bitcast %struct._cpuset* %cs_mask22 to i8*, !dbg !2124
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %37, i8* %38, i64 8, i32 8, i1 false), !dbg !2124
  %39 = load %struct.thread** %ttd, align 8, !dbg !2125
  %td_lock23 = getelementptr inbounds %struct.thread* %39, i32 0, i32 0, !dbg !2125
  %40 = load volatile %struct.mtx** %td_lock23, align 8, !dbg !2125
  %mtx_lock24 = getelementptr inbounds %struct.mtx* %40, i32 0, i32 1, !dbg !2125
  call void @__mtx_unlock_spin_flags(i64* %mtx_lock24, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 1016) #7, !dbg !2125
  br label %sw.epilog43, !dbg !2126

sw.bb25:                                          ; preds = %sw.bb18
  %41 = load %struct.proc** %p, align 8, !dbg !2127
  %p_threads = getelementptr inbounds %struct.proc* %41, i32 0, i32 1, !dbg !2127
  %tqh_first = getelementptr inbounds %struct.anon.1* %p_threads, i32 0, i32 0, !dbg !2127
  %42 = load %struct.thread** %tqh_first, align 8, !dbg !2127
  store %struct.thread* %42, %struct.thread** %ttd, align 8, !dbg !2127
  br label %for.cond, !dbg !2127

for.cond:                                         ; preds = %for.inc36, %sw.bb25
  %43 = load %struct.thread** %ttd, align 8, !dbg !2127
  %tobool26 = icmp ne %struct.thread* %43, null, !dbg !2127
  br i1 %tobool26, label %for.body, label %for.end37, !dbg !2127

for.body:                                         ; preds = %for.cond
  %44 = load %struct.thread** %ttd, align 8, !dbg !2129
  call void @thread_lock_flags_(%struct.thread* %44, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 1020) #7, !dbg !2129
  br label %do.body, !dbg !2131

do.body:                                          ; preds = %for.body
  call void @llvm.dbg.declare(metadata !{i64* %__i}, metadata !2132), !dbg !2134
  store i64 0, i64* %__i, align 8, !dbg !2135
  br label %for.cond27, !dbg !2135

for.cond27:                                       ; preds = %for.inc, %do.body
  %45 = load i64* %__i, align 8, !dbg !2135
  %cmp28 = icmp ult i64 %45, 1, !dbg !2135
  br i1 %cmp28, label %for.body29, label %for.end, !dbg !2135

for.body29:                                       ; preds = %for.cond27
  %46 = load i64* %__i, align 8, !dbg !2135
  %47 = load %struct.thread** %ttd, align 8, !dbg !2135
  %td_cpuset30 = getelementptr inbounds %struct.thread* %47, i32 0, i32 7, !dbg !2135
  %48 = load %struct.cpuset** %td_cpuset30, align 8, !dbg !2135
  %cs_mask31 = getelementptr inbounds %struct.cpuset* %48, i32 0, i32 0, !dbg !2135
  %__bits = getelementptr inbounds %struct._cpuset* %cs_mask31, i32 0, i32 0, !dbg !2135
  %arrayidx = getelementptr inbounds [1 x i64]* %__bits, i32 0, i64 %46, !dbg !2135
  %49 = load i64* %arrayidx, align 8, !dbg !2135
  %50 = load i64* %__i, align 8, !dbg !2135
  %51 = load %struct._cpuset** %mask, align 8, !dbg !2135
  %__bits32 = getelementptr inbounds %struct._cpuset* %51, i32 0, i32 0, !dbg !2135
  %arrayidx33 = getelementptr inbounds [1 x i64]* %__bits32, i32 0, i64 %50, !dbg !2135
  %52 = load i64* %arrayidx33, align 8, !dbg !2135
  %or = or i64 %52, %49, !dbg !2135
  store i64 %or, i64* %arrayidx33, align 8, !dbg !2135
  br label %for.inc, !dbg !2135

for.inc:                                          ; preds = %for.body29
  %53 = load i64* %__i, align 8, !dbg !2135
  %inc = add i64 %53, 1, !dbg !2135
  store i64 %inc, i64* %__i, align 8, !dbg !2135
  br label %for.cond27, !dbg !2135

for.end:                                          ; preds = %for.cond27
  br label %do.end, !dbg !2134

do.end:                                           ; preds = %for.end
  %54 = load %struct.thread** %ttd, align 8, !dbg !2137
  %td_lock34 = getelementptr inbounds %struct.thread* %54, i32 0, i32 0, !dbg !2137
  %55 = load volatile %struct.mtx** %td_lock34, align 8, !dbg !2137
  %mtx_lock35 = getelementptr inbounds %struct.mtx* %55, i32 0, i32 1, !dbg !2137
  call void @__mtx_unlock_spin_flags(i64* %mtx_lock35, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 1022) #7, !dbg !2137
  br label %for.inc36, !dbg !2138

for.inc36:                                        ; preds = %do.end
  %56 = load %struct.thread** %ttd, align 8, !dbg !2127
  %td_plist = getelementptr inbounds %struct.thread* %56, i32 0, i32 2, !dbg !2127
  %tqe_next = getelementptr inbounds %struct.anon.35* %td_plist, i32 0, i32 0, !dbg !2127
  %57 = load %struct.thread** %tqe_next, align 8, !dbg !2127
  store %struct.thread* %57, %struct.thread** %ttd, align 8, !dbg !2127
  br label %for.cond, !dbg !2127

for.end37:                                        ; preds = %for.cond
  br label %sw.epilog43, !dbg !2139

sw.bb38:                                          ; preds = %sw.bb18, %sw.bb18
  %58 = load %struct._cpuset** %mask, align 8, !dbg !2140
  %59 = load %struct.cpuset** %set, align 8, !dbg !2140
  %cs_mask39 = getelementptr inbounds %struct.cpuset* %59, i32 0, i32 0, !dbg !2140
  %60 = bitcast %struct._cpuset* %58 to i8*, !dbg !2140
  %61 = bitcast %struct._cpuset* %cs_mask39 to i8*, !dbg !2140
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %60, i8* %61, i64 8, i32 8, i1 false), !dbg !2140
  br label %sw.epilog43, !dbg !2141

sw.bb40:                                          ; preds = %sw.bb18
  %62 = load %struct.cpuset_getaffinity_args** %uap.addr, align 8, !dbg !2142
  %id41 = getelementptr inbounds %struct.cpuset_getaffinity_args* %62, i32 0, i32 7, !dbg !2142
  %63 = load i64* %id41, align 8, !dbg !2142
  %conv = trunc i64 %63 to i32, !dbg !2142
  %64 = load %struct._cpuset** %mask, align 8, !dbg !2142
  %65 = bitcast %struct._cpuset* %64 to i8*, !dbg !2142
  %call42 = call i32 @intr_getaffinity(i32 %conv, i8* %65) #7, !dbg !2142
  store i32 %call42, i32* %error, align 4, !dbg !2142
  br label %sw.epilog43, !dbg !2143

sw.epilog43:                                      ; preds = %sw.bb18, %sw.bb40, %sw.bb38, %for.end37, %sw.bb20
  br label %sw.epilog44, !dbg !2144

sw.default:                                       ; preds = %if.end6
  store i32 22, i32* %error, align 4, !dbg !2145
  br label %sw.epilog44, !dbg !2146

sw.epilog44:                                      ; preds = %sw.default, %sw.epilog43, %if.end17
  %66 = load %struct.cpuset** %set, align 8, !dbg !2147
  %tobool45 = icmp ne %struct.cpuset* %66, null, !dbg !2147
  br i1 %tobool45, label %if.then46, label %if.end47, !dbg !2147

if.then46:                                        ; preds = %sw.epilog44
  %67 = load %struct.cpuset** %set, align 8, !dbg !2148
  call void @cpuset_rel(%struct.cpuset* %67) #7, !dbg !2148
  br label %if.end47, !dbg !2148

if.end47:                                         ; preds = %if.then46, %sw.epilog44
  %68 = load %struct.proc** %p, align 8, !dbg !2149
  %tobool48 = icmp ne %struct.proc* %68, null, !dbg !2149
  br i1 %tobool48, label %if.then49, label %if.end51, !dbg !2149

if.then49:                                        ; preds = %if.end47
  %69 = load %struct.proc** %p, align 8, !dbg !2150
  %p_mtx = getelementptr inbounds %struct.proc* %69, i32 0, i32 18, !dbg !2150
  %mtx_lock50 = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !2150
  call void @__mtx_unlock_flags(i64* %mtx_lock50, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 1041) #7, !dbg !2150
  br label %if.end51, !dbg !2150

if.end51:                                         ; preds = %if.then49, %if.end47
  %70 = load i32* %error, align 4, !dbg !2151
  %cmp52 = icmp eq i32 %70, 0, !dbg !2151
  br i1 %cmp52, label %if.then54, label %if.end57, !dbg !2151

if.then54:                                        ; preds = %if.end51
  %71 = load %struct._cpuset** %mask, align 8, !dbg !2152
  %72 = bitcast %struct._cpuset* %71 to i8*, !dbg !2152
  %73 = load %struct.cpuset_getaffinity_args** %uap.addr, align 8, !dbg !2152
  %mask55 = getelementptr inbounds %struct.cpuset_getaffinity_args* %73, i32 0, i32 13, !dbg !2152
  %74 = load %struct._cpuset** %mask55, align 8, !dbg !2152
  %75 = bitcast %struct._cpuset* %74 to i8*, !dbg !2152
  %76 = load i64* %size, align 8, !dbg !2152
  %call56 = call i32 @copyout(i8* %72, i8* %75, i64 %76) #7, !dbg !2152
  store i32 %call56, i32* %error, align 4, !dbg !2152
  br label %if.end57, !dbg !2152

if.end57:                                         ; preds = %if.then54, %if.end51
  br label %out, !dbg !2152

out:                                              ; preds = %if.end57, %sw.bb11, %if.then5
  %77 = load %struct._cpuset** %mask, align 8, !dbg !2153
  %78 = bitcast %struct._cpuset* %77 to i8*, !dbg !2153
  call void @free(i8* %78, %struct.malloc_type* getelementptr inbounds ([1 x %struct.malloc_type]* @M_TEMP, i32 0, i32 0)) #7, !dbg !2153
  %79 = load i32* %error, align 4, !dbg !2154
  store i32 %79, i32* %retval, !dbg !2154
  br label %return, !dbg !2154

return:                                           ; preds = %out, %if.then
  %80 = load i32* %retval, !dbg !2155
  ret i32 %80, !dbg !2155
}

; Function Attrs: noimplicitfloat noredzone
declare noalias i8* @malloc(i64, %struct.malloc_type*, i32) #3

; Function Attrs: nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture, i64, i32, i1) #5

; Function Attrs: noimplicitfloat noredzone
declare i32 @intr_getaffinity(i32, i8*) #3

; Function Attrs: noimplicitfloat noredzone
declare void @free(i8*, %struct.malloc_type*) #3

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define i32 @sys_cpuset_setaffinity(%struct.thread* %td, %struct.cpuset_setaffinity_args* %uap) #0 {
entry:
  %retval = alloca i32, align 4
  %td.addr = alloca %struct.thread*, align 8
  %uap.addr = alloca %struct.cpuset_setaffinity_args*, align 8
  %nset = alloca %struct.cpuset*, align 8
  %set = alloca %struct.cpuset*, align 8
  %ttd = alloca %struct.thread*, align 8
  %p = alloca %struct.proc*, align 8
  %mask = alloca %struct._cpuset*, align 8
  %error = alloca i32, align 4
  %end = alloca i8*, align 8
  %cp = alloca i8*, align 8
  store %struct.thread* %td, %struct.thread** %td.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td.addr}, metadata !2156), !dbg !2157
  store %struct.cpuset_setaffinity_args* %uap, %struct.cpuset_setaffinity_args** %uap.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.cpuset_setaffinity_args** %uap.addr}, metadata !2158), !dbg !2157
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %nset}, metadata !2159), !dbg !2160
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %set}, metadata !2161), !dbg !2162
  call void @llvm.dbg.declare(metadata !{%struct.thread** %ttd}, metadata !2163), !dbg !2164
  call void @llvm.dbg.declare(metadata !{%struct.proc** %p}, metadata !2165), !dbg !2166
  call void @llvm.dbg.declare(metadata !{%struct._cpuset** %mask}, metadata !2167), !dbg !2168
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !2169), !dbg !2170
  %0 = load %struct.cpuset_setaffinity_args** %uap.addr, align 8, !dbg !2171
  %cpusetsize = getelementptr inbounds %struct.cpuset_setaffinity_args* %0, i32 0, i32 10, !dbg !2171
  %1 = load i64* %cpusetsize, align 8, !dbg !2171
  %cmp = icmp ult i64 %1, 8, !dbg !2171
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !2171

lor.lhs.false:                                    ; preds = %entry
  %2 = load %struct.cpuset_setaffinity_args** %uap.addr, align 8, !dbg !2171
  %cpusetsize1 = getelementptr inbounds %struct.cpuset_setaffinity_args* %2, i32 0, i32 10, !dbg !2171
  %3 = load i64* %cpusetsize1, align 8, !dbg !2171
  %cmp2 = icmp ugt i64 %3, 16, !dbg !2171
  br i1 %cmp2, label %if.then, label %if.end, !dbg !2171

if.then:                                          ; preds = %lor.lhs.false, %entry
  store i32 34, i32* %retval, !dbg !2172
  br label %return, !dbg !2172

if.end:                                           ; preds = %lor.lhs.false
  %4 = load %struct.cpuset_setaffinity_args** %uap.addr, align 8, !dbg !2173
  %cpusetsize3 = getelementptr inbounds %struct.cpuset_setaffinity_args* %4, i32 0, i32 10, !dbg !2173
  %5 = load i64* %cpusetsize3, align 8, !dbg !2173
  %call = call noalias i8* @malloc(i64 %5, %struct.malloc_type* getelementptr inbounds ([1 x %struct.malloc_type]* @M_TEMP, i32 0, i32 0), i32 258) #7, !dbg !2173
  %6 = bitcast i8* %call to %struct._cpuset*, !dbg !2173
  store %struct._cpuset* %6, %struct._cpuset** %mask, align 8, !dbg !2173
  %7 = load %struct.cpuset_setaffinity_args** %uap.addr, align 8, !dbg !2174
  %mask4 = getelementptr inbounds %struct.cpuset_setaffinity_args* %7, i32 0, i32 13, !dbg !2174
  %8 = load %struct._cpuset** %mask4, align 8, !dbg !2174
  %9 = bitcast %struct._cpuset* %8 to i8*, !dbg !2174
  %10 = load %struct._cpuset** %mask, align 8, !dbg !2174
  %11 = bitcast %struct._cpuset* %10 to i8*, !dbg !2174
  %12 = load %struct.cpuset_setaffinity_args** %uap.addr, align 8, !dbg !2174
  %cpusetsize5 = getelementptr inbounds %struct.cpuset_setaffinity_args* %12, i32 0, i32 10, !dbg !2174
  %13 = load i64* %cpusetsize5, align 8, !dbg !2174
  %call6 = call i32 @copyin(i8* %9, i8* %11, i64 %13) #7, !dbg !2174
  store i32 %call6, i32* %error, align 4, !dbg !2174
  %14 = load i32* %error, align 4, !dbg !2175
  %tobool = icmp ne i32 %14, 0, !dbg !2175
  br i1 %tobool, label %if.then7, label %if.end8, !dbg !2175

if.then7:                                         ; preds = %if.end
  br label %out, !dbg !2176

if.end8:                                          ; preds = %if.end
  %15 = load %struct.cpuset_setaffinity_args** %uap.addr, align 8, !dbg !2177
  %cpusetsize9 = getelementptr inbounds %struct.cpuset_setaffinity_args* %15, i32 0, i32 10, !dbg !2177
  %16 = load i64* %cpusetsize9, align 8, !dbg !2177
  %cmp10 = icmp ugt i64 %16, 8, !dbg !2177
  br i1 %cmp10, label %if.then11, label %if.end19, !dbg !2177

if.then11:                                        ; preds = %if.end8
  call void @llvm.dbg.declare(metadata !{i8** %end}, metadata !2178), !dbg !2180
  call void @llvm.dbg.declare(metadata !{i8** %cp}, metadata !2181), !dbg !2182
  %17 = load %struct._cpuset** %mask, align 8, !dbg !2183
  %__bits = getelementptr inbounds %struct._cpuset* %17, i32 0, i32 0, !dbg !2183
  %18 = bitcast [1 x i64]* %__bits to i8*, !dbg !2183
  store i8* %18, i8** %cp, align 8, !dbg !2183
  store i8* %18, i8** %end, align 8, !dbg !2183
  %19 = load %struct.cpuset_setaffinity_args** %uap.addr, align 8, !dbg !2184
  %cpusetsize12 = getelementptr inbounds %struct.cpuset_setaffinity_args* %19, i32 0, i32 10, !dbg !2184
  %20 = load i64* %cpusetsize12, align 8, !dbg !2184
  %21 = load i8** %end, align 8, !dbg !2184
  %add.ptr = getelementptr inbounds i8* %21, i64 %20, !dbg !2184
  store i8* %add.ptr, i8** %end, align 8, !dbg !2184
  %22 = load i8** %cp, align 8, !dbg !2185
  %add.ptr13 = getelementptr inbounds i8* %22, i64 8, !dbg !2185
  store i8* %add.ptr13, i8** %cp, align 8, !dbg !2185
  br label %while.cond, !dbg !2186

while.cond:                                       ; preds = %if.end18, %if.then11
  %23 = load i8** %cp, align 8, !dbg !2186
  %24 = load i8** %end, align 8, !dbg !2186
  %cmp14 = icmp ne i8* %23, %24, !dbg !2186
  br i1 %cmp14, label %while.body, label %while.end, !dbg !2186

while.body:                                       ; preds = %while.cond
  %25 = load i8** %cp, align 8, !dbg !2187
  %incdec.ptr = getelementptr inbounds i8* %25, i32 1, !dbg !2187
  store i8* %incdec.ptr, i8** %cp, align 8, !dbg !2187
  %26 = load i8* %25, align 1, !dbg !2187
  %conv = sext i8 %26 to i32, !dbg !2187
  %cmp15 = icmp ne i32 %conv, 0, !dbg !2187
  br i1 %cmp15, label %if.then17, label %if.end18, !dbg !2187

if.then17:                                        ; preds = %while.body
  store i32 22, i32* %error, align 4, !dbg !2188
  br label %out, !dbg !2190

if.end18:                                         ; preds = %while.body
  br label %while.cond, !dbg !2191

while.end:                                        ; preds = %while.cond
  br label %if.end19, !dbg !2192

if.end19:                                         ; preds = %while.end, %if.end8
  %27 = load %struct.cpuset_setaffinity_args** %uap.addr, align 8, !dbg !2193
  %level = getelementptr inbounds %struct.cpuset_setaffinity_args* %27, i32 0, i32 1, !dbg !2193
  %28 = load i32* %level, align 4, !dbg !2193
  switch i32 %28, label %sw.default62 [
    i32 1, label %sw.bb
    i32 2, label %sw.bb
    i32 3, label %sw.bb38
  ], !dbg !2193

sw.bb:                                            ; preds = %if.end19, %if.end19
  %29 = load %struct.cpuset_setaffinity_args** %uap.addr, align 8, !dbg !2194
  %which = getelementptr inbounds %struct.cpuset_setaffinity_args* %29, i32 0, i32 4, !dbg !2194
  %30 = load i32* %which, align 4, !dbg !2194
  %31 = load %struct.cpuset_setaffinity_args** %uap.addr, align 8, !dbg !2194
  %id = getelementptr inbounds %struct.cpuset_setaffinity_args* %31, i32 0, i32 7, !dbg !2194
  %32 = load i64* %id, align 8, !dbg !2194
  %call20 = call i32 @cpuset_which(i32 %30, i64 %32, %struct.proc** %p, %struct.thread** %ttd, %struct.cpuset** %set) #7, !dbg !2194
  store i32 %call20, i32* %error, align 4, !dbg !2194
  %33 = load i32* %error, align 4, !dbg !2196
  %tobool21 = icmp ne i32 %33, 0, !dbg !2196
  br i1 %tobool21, label %if.then22, label %if.end23, !dbg !2196

if.then22:                                        ; preds = %sw.bb
  br label %sw.epilog63, !dbg !2197

if.end23:                                         ; preds = %sw.bb
  %34 = load %struct.cpuset_setaffinity_args** %uap.addr, align 8, !dbg !2198
  %which24 = getelementptr inbounds %struct.cpuset_setaffinity_args* %34, i32 0, i32 4, !dbg !2198
  %35 = load i32* %which24, align 4, !dbg !2198
  switch i32 %35, label %sw.epilog [
    i32 1, label %sw.bb25
    i32 2, label %sw.bb25
    i32 3, label %sw.bb28
    i32 5, label %sw.bb28
    i32 4, label %sw.bb29
  ], !dbg !2198

sw.bb25:                                          ; preds = %if.end23, %if.end23
  %36 = load %struct.thread** %ttd, align 8, !dbg !2199
  call void @thread_lock_flags_(%struct.thread* %36, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 1101) #7, !dbg !2199
  %37 = load %struct.thread** %ttd, align 8, !dbg !2201
  %td_cpuset = getelementptr inbounds %struct.thread* %37, i32 0, i32 7, !dbg !2201
  %38 = load %struct.cpuset** %td_cpuset, align 8, !dbg !2201
  %call26 = call %struct.cpuset* @cpuset_ref(%struct.cpuset* %38) #7, !dbg !2201
  store %struct.cpuset* %call26, %struct.cpuset** %set, align 8, !dbg !2201
  %39 = load %struct.thread** %ttd, align 8, !dbg !2202
  %td_lock = getelementptr inbounds %struct.thread* %39, i32 0, i32 0, !dbg !2202
  %40 = load volatile %struct.mtx** %td_lock, align 8, !dbg !2202
  %mtx_lock = getelementptr inbounds %struct.mtx* %40, i32 0, i32 1, !dbg !2202
  call void @__mtx_unlock_spin_flags(i64* %mtx_lock, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 1103) #7, !dbg !2202
  %41 = load %struct.proc** %p, align 8, !dbg !2203
  %p_mtx = getelementptr inbounds %struct.proc* %41, i32 0, i32 18, !dbg !2203
  %mtx_lock27 = getelementptr inbounds %struct.mtx* %p_mtx, i32 0, i32 1, !dbg !2203
  call void @__mtx_unlock_flags(i64* %mtx_lock27, i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 1104) #7, !dbg !2203
  br label %sw.epilog, !dbg !2204

sw.bb28:                                          ; preds = %if.end23, %if.end23
  br label %sw.epilog, !dbg !2205

sw.bb29:                                          ; preds = %if.end23
  store i32 22, i32* %error, align 4, !dbg !2206
  br label %out, !dbg !2207

sw.epilog:                                        ; preds = %if.end23, %sw.bb28, %sw.bb25
  %42 = load %struct.cpuset_setaffinity_args** %uap.addr, align 8, !dbg !2208
  %level30 = getelementptr inbounds %struct.cpuset_setaffinity_args* %42, i32 0, i32 1, !dbg !2208
  %43 = load i32* %level30, align 4, !dbg !2208
  %cmp31 = icmp eq i32 %43, 1, !dbg !2208
  br i1 %cmp31, label %if.then33, label %if.else, !dbg !2208

if.then33:                                        ; preds = %sw.epilog
  %44 = load %struct.cpuset** %set, align 8, !dbg !2209
  %call34 = call %struct.cpuset* @cpuset_refroot(%struct.cpuset* %44) #7, !dbg !2209
  store %struct.cpuset* %call34, %struct.cpuset** %nset, align 8, !dbg !2209
  br label %if.end36, !dbg !2209

if.else:                                          ; preds = %sw.epilog
  %45 = load %struct.cpuset** %set, align 8, !dbg !2210
  %call35 = call %struct.cpuset* @cpuset_refbase(%struct.cpuset* %45) #7, !dbg !2210
  store %struct.cpuset* %call35, %struct.cpuset** %nset, align 8, !dbg !2210
  br label %if.end36

if.end36:                                         ; preds = %if.else, %if.then33
  %46 = load %struct.cpuset** %nset, align 8, !dbg !2211
  %47 = load %struct._cpuset** %mask, align 8, !dbg !2211
  %call37 = call i32 @cpuset_modify(%struct.cpuset* %46, %struct._cpuset* %47) #7, !dbg !2211
  store i32 %call37, i32* %error, align 4, !dbg !2211
  %48 = load %struct.cpuset** %nset, align 8, !dbg !2212
  call void @cpuset_rel(%struct.cpuset* %48) #7, !dbg !2212
  %49 = load %struct.cpuset** %set, align 8, !dbg !2213
  call void @cpuset_rel(%struct.cpuset* %49) #7, !dbg !2213
  br label %sw.epilog63, !dbg !2214

sw.bb38:                                          ; preds = %if.end19
  %50 = load %struct.cpuset_setaffinity_args** %uap.addr, align 8, !dbg !2215
  %which39 = getelementptr inbounds %struct.cpuset_setaffinity_args* %50, i32 0, i32 4, !dbg !2215
  %51 = load i32* %which39, align 4, !dbg !2215
  switch i32 %51, label %sw.default [
    i32 1, label %sw.bb40
    i32 2, label %sw.bb44
    i32 3, label %sw.bb48
    i32 5, label %sw.bb48
    i32 4, label %sw.bb57
  ], !dbg !2215

sw.bb40:                                          ; preds = %sw.bb38
  %52 = load %struct.cpuset_setaffinity_args** %uap.addr, align 8, !dbg !2216
  %id41 = getelementptr inbounds %struct.cpuset_setaffinity_args* %52, i32 0, i32 7, !dbg !2216
  %53 = load i64* %id41, align 8, !dbg !2216
  %conv42 = trunc i64 %53 to i32, !dbg !2216
  %54 = load %struct._cpuset** %mask, align 8, !dbg !2216
  %call43 = call i32 @cpuset_setthread(i32 %conv42, %struct._cpuset* %54) #7, !dbg !2216
  store i32 %call43, i32* %error, align 4, !dbg !2216
  br label %sw.epilog61, !dbg !2218

sw.bb44:                                          ; preds = %sw.bb38
  %55 = load %struct.cpuset_setaffinity_args** %uap.addr, align 8, !dbg !2219
  %id45 = getelementptr inbounds %struct.cpuset_setaffinity_args* %55, i32 0, i32 7, !dbg !2219
  %56 = load i64* %id45, align 8, !dbg !2219
  %conv46 = trunc i64 %56 to i32, !dbg !2219
  %57 = load %struct._cpuset** %mask, align 8, !dbg !2219
  %call47 = call i32 @cpuset_setproc(i32 %conv46, %struct.cpuset* null, %struct._cpuset* %57) #7, !dbg !2219
  store i32 %call47, i32* %error, align 4, !dbg !2219
  br label %sw.epilog61, !dbg !2220

sw.bb48:                                          ; preds = %sw.bb38, %sw.bb38
  %58 = load %struct.cpuset_setaffinity_args** %uap.addr, align 8, !dbg !2221
  %which49 = getelementptr inbounds %struct.cpuset_setaffinity_args* %58, i32 0, i32 4, !dbg !2221
  %59 = load i32* %which49, align 4, !dbg !2221
  %60 = load %struct.cpuset_setaffinity_args** %uap.addr, align 8, !dbg !2221
  %id50 = getelementptr inbounds %struct.cpuset_setaffinity_args* %60, i32 0, i32 7, !dbg !2221
  %61 = load i64* %id50, align 8, !dbg !2221
  %call51 = call i32 @cpuset_which(i32 %59, i64 %61, %struct.proc** %p, %struct.thread** %ttd, %struct.cpuset** %set) #7, !dbg !2221
  store i32 %call51, i32* %error, align 4, !dbg !2221
  %62 = load i32* %error, align 4, !dbg !2222
  %cmp52 = icmp eq i32 %62, 0, !dbg !2222
  br i1 %cmp52, label %if.then54, label %if.end56, !dbg !2222

if.then54:                                        ; preds = %sw.bb48
  %63 = load %struct.cpuset** %set, align 8, !dbg !2223
  %64 = load %struct._cpuset** %mask, align 8, !dbg !2223
  %call55 = call i32 @cpuset_modify(%struct.cpuset* %63, %struct._cpuset* %64) #7, !dbg !2223
  store i32 %call55, i32* %error, align 4, !dbg !2223
  %65 = load %struct.cpuset** %set, align 8, !dbg !2225
  call void @cpuset_rel(%struct.cpuset* %65) #7, !dbg !2225
  br label %if.end56, !dbg !2226

if.end56:                                         ; preds = %if.then54, %sw.bb48
  br label %sw.epilog61, !dbg !2227

sw.bb57:                                          ; preds = %sw.bb38
  %66 = load %struct.cpuset_setaffinity_args** %uap.addr, align 8, !dbg !2228
  %id58 = getelementptr inbounds %struct.cpuset_setaffinity_args* %66, i32 0, i32 7, !dbg !2228
  %67 = load i64* %id58, align 8, !dbg !2228
  %conv59 = trunc i64 %67 to i32, !dbg !2228
  %68 = load %struct._cpuset** %mask, align 8, !dbg !2228
  %69 = bitcast %struct._cpuset* %68 to i8*, !dbg !2228
  %call60 = call i32 @intr_setaffinity(i32 %conv59, i8* %69) #7, !dbg !2228
  store i32 %call60, i32* %error, align 4, !dbg !2228
  br label %sw.epilog61, !dbg !2229

sw.default:                                       ; preds = %sw.bb38
  store i32 22, i32* %error, align 4, !dbg !2230
  br label %sw.epilog61, !dbg !2231

sw.epilog61:                                      ; preds = %sw.default, %sw.bb57, %if.end56, %sw.bb44, %sw.bb40
  br label %sw.epilog63, !dbg !2232

sw.default62:                                     ; preds = %if.end19
  store i32 22, i32* %error, align 4, !dbg !2233
  br label %sw.epilog63, !dbg !2234

sw.epilog63:                                      ; preds = %sw.default62, %sw.epilog61, %if.end36, %if.then22
  br label %out, !dbg !2235

out:                                              ; preds = %sw.epilog63, %sw.bb29, %if.then17, %if.then7
  %70 = load %struct._cpuset** %mask, align 8, !dbg !2236
  %71 = bitcast %struct._cpuset* %70 to i8*, !dbg !2236
  call void @free(i8* %71, %struct.malloc_type* getelementptr inbounds ([1 x %struct.malloc_type]* @M_TEMP, i32 0, i32 0)) #7, !dbg !2236
  %72 = load i32* %error, align 4, !dbg !2237
  store i32 %72, i32* %retval, !dbg !2237
  br label %return, !dbg !2237

return:                                           ; preds = %out, %if.then
  %73 = load i32* %retval, !dbg !2238
  ret i32 %73, !dbg !2238
}

; Function Attrs: noimplicitfloat noredzone
declare i32 @copyin(i8*, i8*, i64) #3

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define internal i32 @cpuset_modify(%struct.cpuset* %set, %struct._cpuset* %mask) #0 {
entry:
  %retval = alloca i32, align 4
  %set.addr = alloca %struct.cpuset*, align 8
  %mask.addr = alloca %struct._cpuset*, align 8
  %root = alloca %struct.cpuset*, align 8
  %error = alloca i32, align 4
  %__i = alloca i64, align 8
  store %struct.cpuset* %set, %struct.cpuset** %set.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %set.addr}, metadata !2239), !dbg !2240
  store %struct._cpuset* %mask, %struct._cpuset** %mask.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct._cpuset** %mask.addr}, metadata !2241), !dbg !2240
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %root}, metadata !2242), !dbg !2243
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !2244), !dbg !2245
  %call = call %struct.thread* @__curthread() #9, !dbg !2246
  %call1 = call i32 @priv_check(%struct.thread* %call, i32 206) #7, !dbg !2246
  store i32 %call1, i32* %error, align 4, !dbg !2246
  %0 = load i32* %error, align 4, !dbg !2247
  %tobool = icmp ne i32 %0, 0, !dbg !2247
  br i1 %tobool, label %if.then, label %if.end, !dbg !2247

if.then:                                          ; preds = %entry
  %1 = load i32* %error, align 4, !dbg !2248
  store i32 %1, i32* %retval, !dbg !2248
  br label %return, !dbg !2248

if.end:                                           ; preds = %entry
  %call2 = call %struct.thread* @__curthread() #9, !dbg !2249
  %td_ucred = getelementptr inbounds %struct.thread* %call2, i32 0, i32 37, !dbg !2249
  %2 = load %struct.ucred** %td_ucred, align 8, !dbg !2249
  %call3 = call i32 @jailed(%struct.ucred* %2) #7, !dbg !2249
  %tobool4 = icmp ne i32 %call3, 0, !dbg !2249
  br i1 %tobool4, label %land.lhs.true, label %if.end7, !dbg !2249

land.lhs.true:                                    ; preds = %if.end
  %3 = load %struct.cpuset** %set.addr, align 8, !dbg !2249
  %cs_flags = getelementptr inbounds %struct.cpuset* %3, i32 0, i32 2, !dbg !2249
  %4 = load i32* %cs_flags, align 4, !dbg !2249
  %and = and i32 %4, 1, !dbg !2249
  %tobool5 = icmp ne i32 %and, 0, !dbg !2249
  br i1 %tobool5, label %if.then6, label %if.end7, !dbg !2249

if.then6:                                         ; preds = %land.lhs.true
  store i32 1, i32* %retval, !dbg !2250
  br label %return, !dbg !2250

if.end7:                                          ; preds = %land.lhs.true, %if.end
  %5 = load %struct.cpuset** %set.addr, align 8, !dbg !2251
  %cs_parent = getelementptr inbounds %struct.cpuset* %5, i32 0, i32 4, !dbg !2251
  %6 = load %struct.cpuset** %cs_parent, align 8, !dbg !2251
  store %struct.cpuset* %6, %struct.cpuset** %root, align 8, !dbg !2251
  %7 = load %struct.cpuset** %root, align 8, !dbg !2252
  %tobool8 = icmp ne %struct.cpuset* %7, null, !dbg !2252
  br i1 %tobool8, label %land.lhs.true9, label %if.end20, !dbg !2252

land.lhs.true9:                                   ; preds = %if.end7
  call void @llvm.dbg.declare(metadata !{i64* %__i}, metadata !2253), !dbg !2255
  store i64 0, i64* %__i, align 8, !dbg !2256
  br label %for.cond, !dbg !2256

for.cond:                                         ; preds = %for.inc, %land.lhs.true9
  %8 = load i64* %__i, align 8, !dbg !2256
  %cmp = icmp ult i64 %8, 1, !dbg !2256
  br i1 %cmp, label %for.body, label %for.end, !dbg !2256

for.body:                                         ; preds = %for.cond
  %9 = load i64* %__i, align 8, !dbg !2256
  %10 = load %struct._cpuset** %mask.addr, align 8, !dbg !2256
  %__bits = getelementptr inbounds %struct._cpuset* %10, i32 0, i32 0, !dbg !2256
  %arrayidx = getelementptr inbounds [1 x i64]* %__bits, i32 0, i64 %9, !dbg !2256
  %11 = load i64* %arrayidx, align 8, !dbg !2256
  %12 = load i64* %__i, align 8, !dbg !2256
  %13 = load %struct.cpuset** %root, align 8, !dbg !2256
  %cs_mask = getelementptr inbounds %struct.cpuset* %13, i32 0, i32 0, !dbg !2256
  %__bits10 = getelementptr inbounds %struct._cpuset* %cs_mask, i32 0, i32 0, !dbg !2256
  %arrayidx11 = getelementptr inbounds [1 x i64]* %__bits10, i32 0, i64 %12, !dbg !2256
  %14 = load i64* %arrayidx11, align 8, !dbg !2256
  %and12 = and i64 %11, %14, !dbg !2256
  %15 = load i64* %__i, align 8, !dbg !2256
  %16 = load %struct._cpuset** %mask.addr, align 8, !dbg !2256
  %__bits13 = getelementptr inbounds %struct._cpuset* %16, i32 0, i32 0, !dbg !2256
  %arrayidx14 = getelementptr inbounds [1 x i64]* %__bits13, i32 0, i64 %15, !dbg !2256
  %17 = load i64* %arrayidx14, align 8, !dbg !2256
  %cmp15 = icmp ne i64 %and12, %17, !dbg !2256
  br i1 %cmp15, label %if.then16, label %if.end17, !dbg !2256

if.then16:                                        ; preds = %for.body
  br label %for.end, !dbg !2256

if.end17:                                         ; preds = %for.body
  br label %for.inc, !dbg !2256

for.inc:                                          ; preds = %if.end17
  %18 = load i64* %__i, align 8, !dbg !2256
  %inc = add i64 %18, 1, !dbg !2256
  store i64 %inc, i64* %__i, align 8, !dbg !2256
  br label %for.cond, !dbg !2256

for.end:                                          ; preds = %if.then16, %for.cond
  %19 = load i64* %__i, align 8, !dbg !2256
  %cmp18 = icmp eq i64 %19, 1, !dbg !2256
  br i1 %cmp18, label %if.end20, label %if.then19, !dbg !2255

if.then19:                                        ; preds = %for.end
  store i32 22, i32* %retval, !dbg !2258
  br label %return, !dbg !2258

if.end20:                                         ; preds = %for.end, %if.end7
  call void @__mtx_lock_spin_flags(i64* getelementptr inbounds (%struct.mtx* @cpuset_lock, i32 0, i32 1), i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 375) #7, !dbg !2259
  %20 = load %struct.cpuset** %set.addr, align 8, !dbg !2260
  %21 = load %struct._cpuset** %mask.addr, align 8, !dbg !2260
  %call21 = call i32 @cpuset_testupdate(%struct.cpuset* %20, %struct._cpuset* %21) #7, !dbg !2260
  store i32 %call21, i32* %error, align 4, !dbg !2260
  %22 = load i32* %error, align 4, !dbg !2261
  %tobool22 = icmp ne i32 %22, 0, !dbg !2261
  br i1 %tobool22, label %if.then23, label %if.end24, !dbg !2261

if.then23:                                        ; preds = %if.end20
  br label %out, !dbg !2262

if.end24:                                         ; preds = %if.end20
  %23 = load %struct.cpuset** %set.addr, align 8, !dbg !2263
  %24 = load %struct._cpuset** %mask.addr, align 8, !dbg !2263
  call void @cpuset_update(%struct.cpuset* %23, %struct._cpuset* %24) #7, !dbg !2263
  %25 = load %struct.cpuset** %set.addr, align 8, !dbg !2264
  %cs_mask25 = getelementptr inbounds %struct.cpuset* %25, i32 0, i32 0, !dbg !2264
  %26 = load %struct._cpuset** %mask.addr, align 8, !dbg !2264
  %27 = bitcast %struct._cpuset* %cs_mask25 to i8*, !dbg !2264
  %28 = bitcast %struct._cpuset* %26 to i8*, !dbg !2264
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %27, i8* %28, i64 8, i32 8, i1 false), !dbg !2264
  br label %out, !dbg !2264

out:                                              ; preds = %if.end24, %if.then23
  call void @__mtx_unlock_spin_flags(i64* getelementptr inbounds (%struct.mtx* @cpuset_lock, i32 0, i32 1), i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 382) #7, !dbg !2265
  %29 = load i32* %error, align 4, !dbg !2266
  store i32 %29, i32* %retval, !dbg !2266
  br label %return, !dbg !2266

return:                                           ; preds = %out, %if.then19, %if.then6, %if.then
  %30 = load i32* %retval, !dbg !2267
  ret i32 %30, !dbg !2267
}

; Function Attrs: noimplicitfloat noredzone
declare i32 @intr_setaffinity(i32, i8*) #3

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define internal void @cpusets_show_del(i8* %arg) #0 {
entry:
  %arg.addr = alloca i8*, align 8
  store i8* %arg, i8** %arg.addr, align 8
  call void @llvm.dbg.declare(metadata !{i8** %arg.addr}, metadata !2268), !dbg !2269
  call void @db_command_unregister(%struct.command_table* @db_show_table, %struct.command* @cpusets_show) #7, !dbg !2269
  ret void, !dbg !2269
}

; Function Attrs: noimplicitfloat noredzone
declare void @db_command_unregister(%struct.command_table*, %struct.command*) #3

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define internal void @db_show_cpusets(i64 %addr, i32 %have_addr, i64 %count, i8* %modif) #0 {
entry:
  %addr.addr = alloca i64, align 8
  %have_addr.addr = alloca i32, align 4
  %count.addr = alloca i64, align 8
  %modif.addr = alloca i8*, align 8
  %set = alloca %struct.cpuset*, align 8
  %cpu = alloca i32, align 4
  %once = alloca i32, align 4
  store i64 %addr, i64* %addr.addr, align 8
  call void @llvm.dbg.declare(metadata !{i64* %addr.addr}, metadata !2270), !dbg !2271
  store i32 %have_addr, i32* %have_addr.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %have_addr.addr}, metadata !2272), !dbg !2271
  store i64 %count, i64* %count.addr, align 8
  call void @llvm.dbg.declare(metadata !{i64* %count.addr}, metadata !2273), !dbg !2271
  store i8* %modif, i8** %modif.addr, align 8
  call void @llvm.dbg.declare(metadata !{i8** %modif.addr}, metadata !2274), !dbg !2271
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %set}, metadata !2275), !dbg !2276
  call void @llvm.dbg.declare(metadata !{i32* %cpu}, metadata !2277), !dbg !2278
  call void @llvm.dbg.declare(metadata !{i32* %once}, metadata !2279), !dbg !2278
  %0 = load %struct.cpuset** getelementptr inbounds (%struct.setlist* @cpuset_ids, i32 0, i32 0), align 8, !dbg !2280
  store %struct.cpuset* %0, %struct.cpuset** %set, align 8, !dbg !2280
  br label %for.cond, !dbg !2280

for.cond:                                         ; preds = %for.inc19, %entry
  %1 = load %struct.cpuset** %set, align 8, !dbg !2280
  %tobool = icmp ne %struct.cpuset* %1, null, !dbg !2280
  br i1 %tobool, label %for.body, label %for.end20, !dbg !2280

for.body:                                         ; preds = %for.cond
  %2 = load %struct.cpuset** %set, align 8, !dbg !2282
  %3 = load %struct.cpuset** %set, align 8, !dbg !2282
  %cs_id = getelementptr inbounds %struct.cpuset* %3, i32 0, i32 3, !dbg !2282
  %4 = load i32* %cs_id, align 4, !dbg !2282
  %5 = load %struct.cpuset** %set, align 8, !dbg !2282
  %cs_ref = getelementptr inbounds %struct.cpuset* %5, i32 0, i32 1, !dbg !2282
  %6 = load volatile i32* %cs_ref, align 4, !dbg !2282
  %7 = load %struct.cpuset** %set, align 8, !dbg !2282
  %cs_flags = getelementptr inbounds %struct.cpuset* %7, i32 0, i32 2, !dbg !2282
  %8 = load i32* %cs_flags, align 4, !dbg !2282
  %9 = load %struct.cpuset** %set, align 8, !dbg !2282
  %cs_parent = getelementptr inbounds %struct.cpuset* %9, i32 0, i32 4, !dbg !2282
  %10 = load %struct.cpuset** %cs_parent, align 8, !dbg !2282
  %cmp = icmp ne %struct.cpuset* %10, null, !dbg !2282
  br i1 %cmp, label %cond.true, label %cond.false, !dbg !2282

cond.true:                                        ; preds = %for.body
  %11 = load %struct.cpuset** %set, align 8, !dbg !2282
  %cs_parent1 = getelementptr inbounds %struct.cpuset* %11, i32 0, i32 4, !dbg !2282
  %12 = load %struct.cpuset** %cs_parent1, align 8, !dbg !2282
  %cs_id2 = getelementptr inbounds %struct.cpuset* %12, i32 0, i32 3, !dbg !2282
  %13 = load i32* %cs_id2, align 4, !dbg !2282
  br label %cond.end, !dbg !2282

cond.false:                                       ; preds = %for.body
  br label %cond.end, !dbg !2282

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi i32 [ %13, %cond.true ], [ 0, %cond.false ], !dbg !2282
  %call = call i32 (i8*, ...)* @db_printf(i8* getelementptr inbounds ([51 x i8]* @.str15, i32 0, i32 0), %struct.cpuset* %2, i32 %4, i32 %6, i32 %8, i32 %cond) #7, !dbg !2282
  %call3 = call i32 (i8*, ...)* @db_printf(i8* getelementptr inbounds ([8 x i8]* @.str16, i32 0, i32 0)) #7, !dbg !2284
  store i32 0, i32* %once, align 4, !dbg !2285
  store i32 0, i32* %cpu, align 4, !dbg !2285
  br label %for.cond4, !dbg !2285

for.cond4:                                        ; preds = %for.inc, %cond.end
  %14 = load i32* %cpu, align 4, !dbg !2285
  %cmp5 = icmp slt i32 %14, 64, !dbg !2285
  br i1 %cmp5, label %for.body6, label %for.end, !dbg !2285

for.body6:                                        ; preds = %for.cond4
  %15 = load %struct.cpuset** %set, align 8, !dbg !2287
  %cs_mask = getelementptr inbounds %struct.cpuset* %15, i32 0, i32 0, !dbg !2287
  %__bits = getelementptr inbounds %struct._cpuset* %cs_mask, i32 0, i32 0, !dbg !2287
  %arrayidx = getelementptr inbounds [1 x i64]* %__bits, i32 0, i64 0, !dbg !2287
  %16 = load i64* %arrayidx, align 8, !dbg !2287
  %17 = load i32* %cpu, align 4, !dbg !2287
  %conv = sext i32 %17 to i64, !dbg !2287
  %shl = shl i64 1, %conv, !dbg !2287
  %and = and i64 %16, %shl, !dbg !2287
  %cmp7 = icmp ne i64 %and, 0, !dbg !2287
  br i1 %cmp7, label %if.then, label %if.end14, !dbg !2287

if.then:                                          ; preds = %for.body6
  %18 = load i32* %once, align 4, !dbg !2289
  %cmp9 = icmp eq i32 %18, 0, !dbg !2289
  br i1 %cmp9, label %if.then11, label %if.else, !dbg !2289

if.then11:                                        ; preds = %if.then
  %19 = load i32* %cpu, align 4, !dbg !2291
  %call12 = call i32 (i8*, ...)* @db_printf(i8* getelementptr inbounds ([3 x i8]* @.str17, i32 0, i32 0), i32 %19) #7, !dbg !2291
  store i32 1, i32* %once, align 4, !dbg !2293
  br label %if.end, !dbg !2294

if.else:                                          ; preds = %if.then
  %20 = load i32* %cpu, align 4, !dbg !2295
  %call13 = call i32 (i8*, ...)* @db_printf(i8* getelementptr inbounds ([4 x i8]* @.str18, i32 0, i32 0), i32 %20) #7, !dbg !2295
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then11
  br label %if.end14, !dbg !2296

if.end14:                                         ; preds = %if.end, %for.body6
  br label %for.inc, !dbg !2297

for.inc:                                          ; preds = %if.end14
  %21 = load i32* %cpu, align 4, !dbg !2285
  %inc = add nsw i32 %21, 1, !dbg !2285
  store i32 %inc, i32* %cpu, align 4, !dbg !2285
  br label %for.cond4, !dbg !2285

for.end:                                          ; preds = %for.cond4
  %call15 = call i32 (i8*, ...)* @db_printf(i8* getelementptr inbounds ([2 x i8]* @.str19, i32 0, i32 0)) #7, !dbg !2298
  %22 = load volatile i32* @db_pager_quit, align 4, !dbg !2299
  %tobool16 = icmp ne i32 %22, 0, !dbg !2299
  br i1 %tobool16, label %if.then17, label %if.end18, !dbg !2299

if.then17:                                        ; preds = %for.end
  br label %for.end20, !dbg !2300

if.end18:                                         ; preds = %for.end
  br label %for.inc19, !dbg !2301

for.inc19:                                        ; preds = %if.end18
  %23 = load %struct.cpuset** %set, align 8, !dbg !2280
  %cs_link = getelementptr inbounds %struct.cpuset* %23, i32 0, i32 5, !dbg !2280
  %le_next = getelementptr inbounds %struct.anon.7* %cs_link, i32 0, i32 0, !dbg !2280
  %24 = load %struct.cpuset** %le_next, align 8, !dbg !2280
  store %struct.cpuset* %24, %struct.cpuset** %set, align 8, !dbg !2280
  br label %for.cond, !dbg !2280

for.end20:                                        ; preds = %if.then17, %for.cond
  ret void, !dbg !2302
}

; Function Attrs: noimplicitfloat noredzone
declare i32 @db_printf(i8*, ...) #3

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define internal void @cpusets_show_add(i8* %arg) #0 {
entry:
  %arg.addr = alloca i8*, align 8
  store i8* %arg, i8** %arg.addr, align 8
  call void @llvm.dbg.declare(metadata !{i8** %arg.addr}, metadata !2303), !dbg !2304
  call void @db_command_register(%struct.command_table* @db_show_table, %struct.command* @cpusets_show) #7, !dbg !2304
  ret void, !dbg !2304
}

; Function Attrs: noimplicitfloat noredzone
declare void @db_command_register(%struct.command_table*, %struct.command*) #3

; Function Attrs: noimplicitfloat noredzone
declare i32 @priv_check(%struct.thread*, i32) #3

; Function Attrs: inlinehint noimplicitfloat noredzone nounwind readnone ssp
define internal %struct.thread* @__curthread() #6 {
entry:
  %td = alloca %struct.thread*, align 8
  call void @llvm.dbg.declare(metadata !{%struct.thread** %td}, metadata !2305), !dbg !2307
  %0 = call %struct.thread* asm "movq %gs:$1,$0", "=r,*m,~{dirflag},~{fpsr},~{flags}"(i8* null) #5, !dbg !2308, !srcloc !2309
  store %struct.thread* %0, %struct.thread** %td, align 8, !dbg !2308
  %1 = load %struct.thread** %td, align 8, !dbg !2310
  ret %struct.thread* %1, !dbg !2310
}

; Function Attrs: noimplicitfloat noredzone
declare i32 @jailed(%struct.ucred*) #3

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define internal i32 @cpuset_testupdate(%struct.cpuset* %set, %struct._cpuset* %mask) #0 {
entry:
  %retval = alloca i32, align 4
  %set.addr = alloca %struct.cpuset*, align 8
  %mask.addr = alloca %struct._cpuset*, align 8
  %nset = alloca %struct.cpuset*, align 8
  %newmask = alloca %struct._cpuset, align 8
  %error = alloca i32, align 4
  %__i = alloca i64, align 8
  %__i11 = alloca i64, align 8
  store %struct.cpuset* %set, %struct.cpuset** %set.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %set.addr}, metadata !2311), !dbg !2312
  store %struct._cpuset* %mask, %struct._cpuset** %mask.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct._cpuset** %mask.addr}, metadata !2313), !dbg !2312
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %nset}, metadata !2314), !dbg !2315
  call void @llvm.dbg.declare(metadata !{%struct._cpuset* %newmask}, metadata !2316), !dbg !2317
  call void @llvm.dbg.declare(metadata !{i32* %error}, metadata !2318), !dbg !2319
  call void @__mtx_assert(i64* getelementptr inbounds (%struct.mtx* @cpuset_lock, i32 0, i32 1), i32 4, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 315) #7, !dbg !2320
  %0 = load %struct.cpuset** %set.addr, align 8, !dbg !2321
  %cs_flags = getelementptr inbounds %struct.cpuset* %0, i32 0, i32 2, !dbg !2321
  %1 = load i32* %cs_flags, align 4, !dbg !2321
  %and = and i32 %1, 2, !dbg !2321
  %tobool = icmp ne i32 %and, 0, !dbg !2321
  br i1 %tobool, label %if.then, label %if.end, !dbg !2321

if.then:                                          ; preds = %entry
  store i32 1, i32* %retval, !dbg !2322
  br label %return, !dbg !2322

if.end:                                           ; preds = %entry
  call void @llvm.dbg.declare(metadata !{i64* %__i}, metadata !2323), !dbg !2325
  store i64 0, i64* %__i, align 8, !dbg !2326
  br label %for.cond, !dbg !2326

for.cond:                                         ; preds = %for.inc, %if.end
  %2 = load i64* %__i, align 8, !dbg !2326
  %cmp = icmp ult i64 %2, 1, !dbg !2326
  br i1 %cmp, label %for.body, label %for.end, !dbg !2326

for.body:                                         ; preds = %for.cond
  %3 = load i64* %__i, align 8, !dbg !2326
  %4 = load %struct._cpuset** %mask.addr, align 8, !dbg !2326
  %__bits = getelementptr inbounds %struct._cpuset* %4, i32 0, i32 0, !dbg !2326
  %arrayidx = getelementptr inbounds [1 x i64]* %__bits, i32 0, i64 %3, !dbg !2326
  %5 = load i64* %arrayidx, align 8, !dbg !2326
  %6 = load i64* %__i, align 8, !dbg !2326
  %7 = load %struct.cpuset** %set.addr, align 8, !dbg !2326
  %cs_mask = getelementptr inbounds %struct.cpuset* %7, i32 0, i32 0, !dbg !2326
  %__bits1 = getelementptr inbounds %struct._cpuset* %cs_mask, i32 0, i32 0, !dbg !2326
  %arrayidx2 = getelementptr inbounds [1 x i64]* %__bits1, i32 0, i64 %6, !dbg !2326
  %8 = load i64* %arrayidx2, align 8, !dbg !2326
  %and3 = and i64 %5, %8, !dbg !2326
  %cmp4 = icmp ne i64 %and3, 0, !dbg !2326
  br i1 %cmp4, label %if.then5, label %if.end6, !dbg !2326

if.then5:                                         ; preds = %for.body
  br label %for.end, !dbg !2326

if.end6:                                          ; preds = %for.body
  br label %for.inc, !dbg !2326

for.inc:                                          ; preds = %if.end6
  %9 = load i64* %__i, align 8, !dbg !2326
  %inc = add i64 %9, 1, !dbg !2326
  store i64 %inc, i64* %__i, align 8, !dbg !2326
  br label %for.cond, !dbg !2326

for.end:                                          ; preds = %if.then5, %for.cond
  %10 = load i64* %__i, align 8, !dbg !2326
  %cmp7 = icmp ne i64 %10, 1, !dbg !2326
  br i1 %cmp7, label %if.end9, label %if.then8, !dbg !2325

if.then8:                                         ; preds = %for.end
  store i32 11, i32* %retval, !dbg !2328
  br label %return, !dbg !2328

if.end9:                                          ; preds = %for.end
  %11 = load %struct.cpuset** %set.addr, align 8, !dbg !2329
  %cs_mask10 = getelementptr inbounds %struct.cpuset* %11, i32 0, i32 0, !dbg !2329
  %12 = bitcast %struct._cpuset* %newmask to i8*, !dbg !2329
  %13 = bitcast %struct._cpuset* %cs_mask10 to i8*, !dbg !2329
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %12, i8* %13, i64 8, i32 8, i1 false), !dbg !2329
  br label %do.body, !dbg !2330

do.body:                                          ; preds = %if.end9
  call void @llvm.dbg.declare(metadata !{i64* %__i11}, metadata !2331), !dbg !2333
  store i64 0, i64* %__i11, align 8, !dbg !2334
  br label %for.cond12, !dbg !2334

for.cond12:                                       ; preds = %for.inc20, %do.body
  %14 = load i64* %__i11, align 8, !dbg !2334
  %cmp13 = icmp ult i64 %14, 1, !dbg !2334
  br i1 %cmp13, label %for.body14, label %for.end22, !dbg !2334

for.body14:                                       ; preds = %for.cond12
  %15 = load i64* %__i11, align 8, !dbg !2334
  %16 = load %struct._cpuset** %mask.addr, align 8, !dbg !2334
  %__bits15 = getelementptr inbounds %struct._cpuset* %16, i32 0, i32 0, !dbg !2334
  %arrayidx16 = getelementptr inbounds [1 x i64]* %__bits15, i32 0, i64 %15, !dbg !2334
  %17 = load i64* %arrayidx16, align 8, !dbg !2334
  %18 = load i64* %__i11, align 8, !dbg !2334
  %__bits17 = getelementptr inbounds %struct._cpuset* %newmask, i32 0, i32 0, !dbg !2334
  %arrayidx18 = getelementptr inbounds [1 x i64]* %__bits17, i32 0, i64 %18, !dbg !2334
  %19 = load i64* %arrayidx18, align 8, !dbg !2334
  %and19 = and i64 %19, %17, !dbg !2334
  store i64 %and19, i64* %arrayidx18, align 8, !dbg !2334
  br label %for.inc20, !dbg !2334

for.inc20:                                        ; preds = %for.body14
  %20 = load i64* %__i11, align 8, !dbg !2334
  %inc21 = add i64 %20, 1, !dbg !2334
  store i64 %inc21, i64* %__i11, align 8, !dbg !2334
  br label %for.cond12, !dbg !2334

for.end22:                                        ; preds = %for.cond12
  br label %do.end, !dbg !2333

do.end:                                           ; preds = %for.end22
  store i32 0, i32* %error, align 4, !dbg !2336
  %21 = load %struct.cpuset** %set.addr, align 8, !dbg !2337
  %cs_children = getelementptr inbounds %struct.cpuset* %21, i32 0, i32 7, !dbg !2337
  %lh_first = getelementptr inbounds %struct.setlist* %cs_children, i32 0, i32 0, !dbg !2337
  %22 = load %struct.cpuset** %lh_first, align 8, !dbg !2337
  store %struct.cpuset* %22, %struct.cpuset** %nset, align 8, !dbg !2337
  br label %for.cond23, !dbg !2337

for.cond23:                                       ; preds = %for.inc29, %do.end
  %23 = load %struct.cpuset** %nset, align 8, !dbg !2337
  %tobool24 = icmp ne %struct.cpuset* %23, null, !dbg !2337
  br i1 %tobool24, label %for.body25, label %for.end30, !dbg !2337

for.body25:                                       ; preds = %for.cond23
  %24 = load %struct.cpuset** %nset, align 8, !dbg !2339
  %call = call i32 @cpuset_testupdate(%struct.cpuset* %24, %struct._cpuset* %newmask) #7, !dbg !2339
  store i32 %call, i32* %error, align 4, !dbg !2339
  %cmp26 = icmp ne i32 %call, 0, !dbg !2339
  br i1 %cmp26, label %if.then27, label %if.end28, !dbg !2339

if.then27:                                        ; preds = %for.body25
  br label %for.end30, !dbg !2340

if.end28:                                         ; preds = %for.body25
  br label %for.inc29, !dbg !2340

for.inc29:                                        ; preds = %if.end28
  %25 = load %struct.cpuset** %nset, align 8, !dbg !2337
  %cs_siblings = getelementptr inbounds %struct.cpuset* %25, i32 0, i32 6, !dbg !2337
  %le_next = getelementptr inbounds %struct.anon.8* %cs_siblings, i32 0, i32 0, !dbg !2337
  %26 = load %struct.cpuset** %le_next, align 8, !dbg !2337
  store %struct.cpuset* %26, %struct.cpuset** %nset, align 8, !dbg !2337
  br label %for.cond23, !dbg !2337

for.end30:                                        ; preds = %if.then27, %for.cond23
  %27 = load i32* %error, align 4, !dbg !2341
  store i32 %27, i32* %retval, !dbg !2341
  br label %return, !dbg !2341

return:                                           ; preds = %for.end30, %if.then8, %if.then
  %28 = load i32* %retval, !dbg !2342
  ret i32 %28, !dbg !2342
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define internal void @cpuset_update(%struct.cpuset* %set, %struct._cpuset* %mask) #0 {
entry:
  %set.addr = alloca %struct.cpuset*, align 8
  %mask.addr = alloca %struct._cpuset*, align 8
  %nset = alloca %struct.cpuset*, align 8
  %__i = alloca i64, align 8
  store %struct.cpuset* %set, %struct.cpuset** %set.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %set.addr}, metadata !2343), !dbg !2344
  store %struct._cpuset* %mask, %struct._cpuset** %mask.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct._cpuset** %mask.addr}, metadata !2345), !dbg !2344
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %nset}, metadata !2346), !dbg !2347
  call void @__mtx_assert(i64* getelementptr inbounds (%struct.mtx* @cpuset_lock, i32 0, i32 1), i32 4, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 337) #7, !dbg !2348
  br label %do.body, !dbg !2349

do.body:                                          ; preds = %entry
  call void @llvm.dbg.declare(metadata !{i64* %__i}, metadata !2350), !dbg !2352
  store i64 0, i64* %__i, align 8, !dbg !2353
  br label %for.cond, !dbg !2353

for.cond:                                         ; preds = %for.inc, %do.body
  %0 = load i64* %__i, align 8, !dbg !2353
  %cmp = icmp ult i64 %0, 1, !dbg !2353
  br i1 %cmp, label %for.body, label %for.end, !dbg !2353

for.body:                                         ; preds = %for.cond
  %1 = load i64* %__i, align 8, !dbg !2353
  %2 = load %struct._cpuset** %mask.addr, align 8, !dbg !2353
  %__bits = getelementptr inbounds %struct._cpuset* %2, i32 0, i32 0, !dbg !2353
  %arrayidx = getelementptr inbounds [1 x i64]* %__bits, i32 0, i64 %1, !dbg !2353
  %3 = load i64* %arrayidx, align 8, !dbg !2353
  %4 = load i64* %__i, align 8, !dbg !2353
  %5 = load %struct.cpuset** %set.addr, align 8, !dbg !2353
  %cs_mask = getelementptr inbounds %struct.cpuset* %5, i32 0, i32 0, !dbg !2353
  %__bits1 = getelementptr inbounds %struct._cpuset* %cs_mask, i32 0, i32 0, !dbg !2353
  %arrayidx2 = getelementptr inbounds [1 x i64]* %__bits1, i32 0, i64 %4, !dbg !2353
  %6 = load i64* %arrayidx2, align 8, !dbg !2353
  %and = and i64 %6, %3, !dbg !2353
  store i64 %and, i64* %arrayidx2, align 8, !dbg !2353
  br label %for.inc, !dbg !2353

for.inc:                                          ; preds = %for.body
  %7 = load i64* %__i, align 8, !dbg !2353
  %inc = add i64 %7, 1, !dbg !2353
  store i64 %inc, i64* %__i, align 8, !dbg !2353
  br label %for.cond, !dbg !2353

for.end:                                          ; preds = %for.cond
  br label %do.end, !dbg !2352

do.end:                                           ; preds = %for.end
  %8 = load %struct.cpuset** %set.addr, align 8, !dbg !2355
  %cs_children = getelementptr inbounds %struct.cpuset* %8, i32 0, i32 7, !dbg !2355
  %lh_first = getelementptr inbounds %struct.setlist* %cs_children, i32 0, i32 0, !dbg !2355
  %9 = load %struct.cpuset** %lh_first, align 8, !dbg !2355
  store %struct.cpuset* %9, %struct.cpuset** %nset, align 8, !dbg !2355
  br label %for.cond3, !dbg !2355

for.cond3:                                        ; preds = %for.inc6, %do.end
  %10 = load %struct.cpuset** %nset, align 8, !dbg !2355
  %tobool = icmp ne %struct.cpuset* %10, null, !dbg !2355
  br i1 %tobool, label %for.body4, label %for.end7, !dbg !2355

for.body4:                                        ; preds = %for.cond3
  %11 = load %struct.cpuset** %nset, align 8, !dbg !2357
  %12 = load %struct.cpuset** %set.addr, align 8, !dbg !2357
  %cs_mask5 = getelementptr inbounds %struct.cpuset* %12, i32 0, i32 0, !dbg !2357
  call void @cpuset_update(%struct.cpuset* %11, %struct._cpuset* %cs_mask5) #7, !dbg !2357
  br label %for.inc6, !dbg !2357

for.inc6:                                         ; preds = %for.body4
  %13 = load %struct.cpuset** %nset, align 8, !dbg !2355
  %cs_siblings = getelementptr inbounds %struct.cpuset* %13, i32 0, i32 6, !dbg !2355
  %le_next = getelementptr inbounds %struct.anon.8* %cs_siblings, i32 0, i32 0, !dbg !2355
  %14 = load %struct.cpuset** %le_next, align 8, !dbg !2355
  store %struct.cpuset* %14, %struct.cpuset** %nset, align 8, !dbg !2355
  br label %for.cond3, !dbg !2355

for.end7:                                         ; preds = %for.cond3
  ret void, !dbg !2358
}

; Function Attrs: noimplicitfloat noredzone
declare void @__mtx_assert(i64*, i32, i8*, i32) #3

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define internal void @cpuset_init(i8* %arg) #0 {
entry:
  %arg.addr = alloca i8*, align 8
  %mask = alloca %struct._cpuset, align 8
  store i8* %arg, i8** %arg.addr, align 8
  call void @llvm.dbg.declare(metadata !{i8** %arg.addr}, metadata !2359), !dbg !2360
  call void @llvm.dbg.declare(metadata !{%struct._cpuset* %mask}, metadata !2361), !dbg !2362
  %0 = bitcast %struct._cpuset* %mask to i8*, !dbg !2363
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %0, i8* bitcast (%struct._cpuset* @all_cpus to i8*), i64 8, i32 8, i1 false), !dbg !2363
  %1 = load %struct.cpuset** @cpuset_zero, align 8, !dbg !2364
  %call = call i32 @cpuset_modify(%struct.cpuset* %1, %struct._cpuset* %mask) #7, !dbg !2364
  %tobool = icmp ne i32 %call, 0, !dbg !2364
  br i1 %tobool, label %if.then, label %if.end, !dbg !2364

if.then:                                          ; preds = %entry
  call void (i8*, ...)* @panic(i8* getelementptr inbounds ([32 x i8]* @.str21, i32 0, i32 0)) #8, !dbg !2365
  unreachable, !dbg !2365

if.end:                                           ; preds = %entry
  %2 = load %struct.cpuset** @cpuset_zero, align 8, !dbg !2366
  %cs_flags = getelementptr inbounds %struct.cpuset* %2, i32 0, i32 2, !dbg !2366
  %3 = load i32* %cs_flags, align 4, !dbg !2366
  %or = or i32 %3, 2, !dbg !2366
  store i32 %or, i32* %cs_flags, align 4, !dbg !2366
  ret void, !dbg !2367
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define internal void @cpuset_rel_defer(%struct.setlist* %head, %struct.cpuset* %set) #0 {
entry:
  %head.addr = alloca %struct.setlist*, align 8
  %set.addr = alloca %struct.cpuset*, align 8
  store %struct.setlist* %head, %struct.setlist** %head.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.setlist** %head.addr}, metadata !2368), !dbg !2369
  store %struct.cpuset* %set, %struct.cpuset** %set.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %set.addr}, metadata !2370), !dbg !2369
  %0 = load %struct.cpuset** %set.addr, align 8, !dbg !2371
  %cs_ref = getelementptr inbounds %struct.cpuset* %0, i32 0, i32 1, !dbg !2371
  %call = call i32 @refcount_release(i32* %cs_ref) #7, !dbg !2371
  %cmp = icmp eq i32 %call, 0, !dbg !2371
  br i1 %cmp, label %if.then, label %if.end, !dbg !2371

if.then:                                          ; preds = %entry
  br label %return, !dbg !2372

if.end:                                           ; preds = %entry
  call void @__mtx_lock_spin_flags(i64* getelementptr inbounds (%struct.mtx* @cpuset_lock, i32 0, i32 1), i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 195) #7, !dbg !2373
  br label %do.body, !dbg !2374

do.body:                                          ; preds = %if.end
  br label %do.body1, !dbg !2375

do.body1:                                         ; preds = %do.body
  %1 = load %struct.cpuset** %set.addr, align 8, !dbg !2377
  %cs_siblings = getelementptr inbounds %struct.cpuset* %1, i32 0, i32 6, !dbg !2377
  %le_next = getelementptr inbounds %struct.anon.8* %cs_siblings, i32 0, i32 0, !dbg !2377
  %2 = load %struct.cpuset** %le_next, align 8, !dbg !2377
  %cmp2 = icmp ne %struct.cpuset* %2, null, !dbg !2377
  br i1 %cmp2, label %land.lhs.true, label %if.end10, !dbg !2377

land.lhs.true:                                    ; preds = %do.body1
  %3 = load %struct.cpuset** %set.addr, align 8, !dbg !2377
  %cs_siblings3 = getelementptr inbounds %struct.cpuset* %3, i32 0, i32 6, !dbg !2377
  %le_next4 = getelementptr inbounds %struct.anon.8* %cs_siblings3, i32 0, i32 0, !dbg !2377
  %4 = load %struct.cpuset** %le_next4, align 8, !dbg !2377
  %cs_siblings5 = getelementptr inbounds %struct.cpuset* %4, i32 0, i32 6, !dbg !2377
  %le_prev = getelementptr inbounds %struct.anon.8* %cs_siblings5, i32 0, i32 1, !dbg !2377
  %5 = load %struct.cpuset*** %le_prev, align 8, !dbg !2377
  %6 = load %struct.cpuset** %set.addr, align 8, !dbg !2377
  %cs_siblings6 = getelementptr inbounds %struct.cpuset* %6, i32 0, i32 6, !dbg !2377
  %le_next7 = getelementptr inbounds %struct.anon.8* %cs_siblings6, i32 0, i32 0, !dbg !2377
  %cmp8 = icmp ne %struct.cpuset** %5, %le_next7, !dbg !2377
  br i1 %cmp8, label %if.then9, label %if.end10, !dbg !2377

if.then9:                                         ; preds = %land.lhs.true
  %7 = load %struct.cpuset** %set.addr, align 8, !dbg !2377
  call void (i8*, ...)* @panic(i8* getelementptr inbounds ([34 x i8]* @.str1, i32 0, i32 0), %struct.cpuset* %7) #8, !dbg !2377
  unreachable, !dbg !2377

if.end10:                                         ; preds = %land.lhs.true, %do.body1
  br label %do.end, !dbg !2377

do.end:                                           ; preds = %if.end10
  br label %do.body11, !dbg !2375

do.body11:                                        ; preds = %do.end
  %8 = load %struct.cpuset** %set.addr, align 8, !dbg !2379
  %cs_siblings12 = getelementptr inbounds %struct.cpuset* %8, i32 0, i32 6, !dbg !2379
  %le_prev13 = getelementptr inbounds %struct.anon.8* %cs_siblings12, i32 0, i32 1, !dbg !2379
  %9 = load %struct.cpuset*** %le_prev13, align 8, !dbg !2379
  %10 = load %struct.cpuset** %9, align 8, !dbg !2379
  %11 = load %struct.cpuset** %set.addr, align 8, !dbg !2379
  %cmp14 = icmp ne %struct.cpuset* %10, %11, !dbg !2379
  br i1 %cmp14, label %if.then15, label %if.end16, !dbg !2379

if.then15:                                        ; preds = %do.body11
  %12 = load %struct.cpuset** %set.addr, align 8, !dbg !2379
  call void (i8*, ...)* @panic(i8* getelementptr inbounds ([34 x i8]* @.str2, i32 0, i32 0), %struct.cpuset* %12) #8, !dbg !2379
  unreachable, !dbg !2379

if.end16:                                         ; preds = %do.body11
  br label %do.end17, !dbg !2379

do.end17:                                         ; preds = %if.end16
  %13 = load %struct.cpuset** %set.addr, align 8, !dbg !2375
  %cs_siblings18 = getelementptr inbounds %struct.cpuset* %13, i32 0, i32 6, !dbg !2375
  %le_next19 = getelementptr inbounds %struct.anon.8* %cs_siblings18, i32 0, i32 0, !dbg !2375
  %14 = load %struct.cpuset** %le_next19, align 8, !dbg !2375
  %cmp20 = icmp ne %struct.cpuset* %14, null, !dbg !2375
  br i1 %cmp20, label %if.then21, label %if.end28, !dbg !2375

if.then21:                                        ; preds = %do.end17
  %15 = load %struct.cpuset** %set.addr, align 8, !dbg !2375
  %cs_siblings22 = getelementptr inbounds %struct.cpuset* %15, i32 0, i32 6, !dbg !2375
  %le_prev23 = getelementptr inbounds %struct.anon.8* %cs_siblings22, i32 0, i32 1, !dbg !2375
  %16 = load %struct.cpuset*** %le_prev23, align 8, !dbg !2375
  %17 = load %struct.cpuset** %set.addr, align 8, !dbg !2375
  %cs_siblings24 = getelementptr inbounds %struct.cpuset* %17, i32 0, i32 6, !dbg !2375
  %le_next25 = getelementptr inbounds %struct.anon.8* %cs_siblings24, i32 0, i32 0, !dbg !2375
  %18 = load %struct.cpuset** %le_next25, align 8, !dbg !2375
  %cs_siblings26 = getelementptr inbounds %struct.cpuset* %18, i32 0, i32 6, !dbg !2375
  %le_prev27 = getelementptr inbounds %struct.anon.8* %cs_siblings26, i32 0, i32 1, !dbg !2375
  store %struct.cpuset** %16, %struct.cpuset*** %le_prev27, align 8, !dbg !2375
  br label %if.end28, !dbg !2375

if.end28:                                         ; preds = %if.then21, %do.end17
  %19 = load %struct.cpuset** %set.addr, align 8, !dbg !2375
  %cs_siblings29 = getelementptr inbounds %struct.cpuset* %19, i32 0, i32 6, !dbg !2375
  %le_next30 = getelementptr inbounds %struct.anon.8* %cs_siblings29, i32 0, i32 0, !dbg !2375
  %20 = load %struct.cpuset** %le_next30, align 8, !dbg !2375
  %21 = load %struct.cpuset** %set.addr, align 8, !dbg !2375
  %cs_siblings31 = getelementptr inbounds %struct.cpuset* %21, i32 0, i32 6, !dbg !2375
  %le_prev32 = getelementptr inbounds %struct.anon.8* %cs_siblings31, i32 0, i32 1, !dbg !2375
  %22 = load %struct.cpuset*** %le_prev32, align 8, !dbg !2375
  store %struct.cpuset* %20, %struct.cpuset** %22, align 8, !dbg !2375
  br label %do.end33, !dbg !2375

do.end33:                                         ; preds = %if.end28
  %23 = load %struct.cpuset** %set.addr, align 8, !dbg !2381
  %cs_id = getelementptr inbounds %struct.cpuset* %23, i32 0, i32 3, !dbg !2381
  %24 = load i32* %cs_id, align 4, !dbg !2381
  %cmp34 = icmp ne i32 %24, -1, !dbg !2381
  br i1 %cmp34, label %if.then35, label %if.end74, !dbg !2381

if.then35:                                        ; preds = %do.end33
  br label %do.body36, !dbg !2382

do.body36:                                        ; preds = %if.then35
  br label %do.body37, !dbg !2383

do.body37:                                        ; preds = %do.body36
  %25 = load %struct.cpuset** %set.addr, align 8, !dbg !2385
  %cs_link = getelementptr inbounds %struct.cpuset* %25, i32 0, i32 5, !dbg !2385
  %le_next38 = getelementptr inbounds %struct.anon.7* %cs_link, i32 0, i32 0, !dbg !2385
  %26 = load %struct.cpuset** %le_next38, align 8, !dbg !2385
  %cmp39 = icmp ne %struct.cpuset* %26, null, !dbg !2385
  br i1 %cmp39, label %land.lhs.true40, label %if.end49, !dbg !2385

land.lhs.true40:                                  ; preds = %do.body37
  %27 = load %struct.cpuset** %set.addr, align 8, !dbg !2385
  %cs_link41 = getelementptr inbounds %struct.cpuset* %27, i32 0, i32 5, !dbg !2385
  %le_next42 = getelementptr inbounds %struct.anon.7* %cs_link41, i32 0, i32 0, !dbg !2385
  %28 = load %struct.cpuset** %le_next42, align 8, !dbg !2385
  %cs_link43 = getelementptr inbounds %struct.cpuset* %28, i32 0, i32 5, !dbg !2385
  %le_prev44 = getelementptr inbounds %struct.anon.7* %cs_link43, i32 0, i32 1, !dbg !2385
  %29 = load %struct.cpuset*** %le_prev44, align 8, !dbg !2385
  %30 = load %struct.cpuset** %set.addr, align 8, !dbg !2385
  %cs_link45 = getelementptr inbounds %struct.cpuset* %30, i32 0, i32 5, !dbg !2385
  %le_next46 = getelementptr inbounds %struct.anon.7* %cs_link45, i32 0, i32 0, !dbg !2385
  %cmp47 = icmp ne %struct.cpuset** %29, %le_next46, !dbg !2385
  br i1 %cmp47, label %if.then48, label %if.end49, !dbg !2385

if.then48:                                        ; preds = %land.lhs.true40
  %31 = load %struct.cpuset** %set.addr, align 8, !dbg !2385
  call void (i8*, ...)* @panic(i8* getelementptr inbounds ([34 x i8]* @.str1, i32 0, i32 0), %struct.cpuset* %31) #8, !dbg !2385
  unreachable, !dbg !2385

if.end49:                                         ; preds = %land.lhs.true40, %do.body37
  br label %do.end50, !dbg !2385

do.end50:                                         ; preds = %if.end49
  br label %do.body51, !dbg !2383

do.body51:                                        ; preds = %do.end50
  %32 = load %struct.cpuset** %set.addr, align 8, !dbg !2387
  %cs_link52 = getelementptr inbounds %struct.cpuset* %32, i32 0, i32 5, !dbg !2387
  %le_prev53 = getelementptr inbounds %struct.anon.7* %cs_link52, i32 0, i32 1, !dbg !2387
  %33 = load %struct.cpuset*** %le_prev53, align 8, !dbg !2387
  %34 = load %struct.cpuset** %33, align 8, !dbg !2387
  %35 = load %struct.cpuset** %set.addr, align 8, !dbg !2387
  %cmp54 = icmp ne %struct.cpuset* %34, %35, !dbg !2387
  br i1 %cmp54, label %if.then55, label %if.end56, !dbg !2387

if.then55:                                        ; preds = %do.body51
  %36 = load %struct.cpuset** %set.addr, align 8, !dbg !2387
  call void (i8*, ...)* @panic(i8* getelementptr inbounds ([34 x i8]* @.str2, i32 0, i32 0), %struct.cpuset* %36) #8, !dbg !2387
  unreachable, !dbg !2387

if.end56:                                         ; preds = %do.body51
  br label %do.end57, !dbg !2387

do.end57:                                         ; preds = %if.end56
  %37 = load %struct.cpuset** %set.addr, align 8, !dbg !2383
  %cs_link58 = getelementptr inbounds %struct.cpuset* %37, i32 0, i32 5, !dbg !2383
  %le_next59 = getelementptr inbounds %struct.anon.7* %cs_link58, i32 0, i32 0, !dbg !2383
  %38 = load %struct.cpuset** %le_next59, align 8, !dbg !2383
  %cmp60 = icmp ne %struct.cpuset* %38, null, !dbg !2383
  br i1 %cmp60, label %if.then61, label %if.end68, !dbg !2383

if.then61:                                        ; preds = %do.end57
  %39 = load %struct.cpuset** %set.addr, align 8, !dbg !2383
  %cs_link62 = getelementptr inbounds %struct.cpuset* %39, i32 0, i32 5, !dbg !2383
  %le_prev63 = getelementptr inbounds %struct.anon.7* %cs_link62, i32 0, i32 1, !dbg !2383
  %40 = load %struct.cpuset*** %le_prev63, align 8, !dbg !2383
  %41 = load %struct.cpuset** %set.addr, align 8, !dbg !2383
  %cs_link64 = getelementptr inbounds %struct.cpuset* %41, i32 0, i32 5, !dbg !2383
  %le_next65 = getelementptr inbounds %struct.anon.7* %cs_link64, i32 0, i32 0, !dbg !2383
  %42 = load %struct.cpuset** %le_next65, align 8, !dbg !2383
  %cs_link66 = getelementptr inbounds %struct.cpuset* %42, i32 0, i32 5, !dbg !2383
  %le_prev67 = getelementptr inbounds %struct.anon.7* %cs_link66, i32 0, i32 1, !dbg !2383
  store %struct.cpuset** %40, %struct.cpuset*** %le_prev67, align 8, !dbg !2383
  br label %if.end68, !dbg !2383

if.end68:                                         ; preds = %if.then61, %do.end57
  %43 = load %struct.cpuset** %set.addr, align 8, !dbg !2383
  %cs_link69 = getelementptr inbounds %struct.cpuset* %43, i32 0, i32 5, !dbg !2383
  %le_next70 = getelementptr inbounds %struct.anon.7* %cs_link69, i32 0, i32 0, !dbg !2383
  %44 = load %struct.cpuset** %le_next70, align 8, !dbg !2383
  %45 = load %struct.cpuset** %set.addr, align 8, !dbg !2383
  %cs_link71 = getelementptr inbounds %struct.cpuset* %45, i32 0, i32 5, !dbg !2383
  %le_prev72 = getelementptr inbounds %struct.anon.7* %cs_link71, i32 0, i32 1, !dbg !2383
  %46 = load %struct.cpuset*** %le_prev72, align 8, !dbg !2383
  store %struct.cpuset* %44, %struct.cpuset** %46, align 8, !dbg !2383
  br label %do.end73, !dbg !2383

do.end73:                                         ; preds = %if.end68
  br label %if.end74, !dbg !2383

if.end74:                                         ; preds = %do.end73, %do.end33
  br label %do.body75, !dbg !2389

do.body75:                                        ; preds = %if.end74
  br label %do.body76, !dbg !2390

do.body76:                                        ; preds = %do.body75
  %47 = load %struct.setlist** %head.addr, align 8, !dbg !2392
  %lh_first = getelementptr inbounds %struct.setlist* %47, i32 0, i32 0, !dbg !2392
  %48 = load %struct.cpuset** %lh_first, align 8, !dbg !2392
  %cmp77 = icmp ne %struct.cpuset* %48, null, !dbg !2392
  br i1 %cmp77, label %land.lhs.true78, label %if.end85, !dbg !2392

land.lhs.true78:                                  ; preds = %do.body76
  %49 = load %struct.setlist** %head.addr, align 8, !dbg !2392
  %lh_first79 = getelementptr inbounds %struct.setlist* %49, i32 0, i32 0, !dbg !2392
  %50 = load %struct.cpuset** %lh_first79, align 8, !dbg !2392
  %cs_link80 = getelementptr inbounds %struct.cpuset* %50, i32 0, i32 5, !dbg !2392
  %le_prev81 = getelementptr inbounds %struct.anon.7* %cs_link80, i32 0, i32 1, !dbg !2392
  %51 = load %struct.cpuset*** %le_prev81, align 8, !dbg !2392
  %52 = load %struct.setlist** %head.addr, align 8, !dbg !2392
  %lh_first82 = getelementptr inbounds %struct.setlist* %52, i32 0, i32 0, !dbg !2392
  %cmp83 = icmp ne %struct.cpuset** %51, %lh_first82, !dbg !2392
  br i1 %cmp83, label %if.then84, label %if.end85, !dbg !2392

if.then84:                                        ; preds = %land.lhs.true78
  %53 = load %struct.setlist** %head.addr, align 8, !dbg !2392
  call void (i8*, ...)* @panic(i8* getelementptr inbounds ([37 x i8]* @.str7, i32 0, i32 0), %struct.setlist* %53) #8, !dbg !2392
  unreachable, !dbg !2392

if.end85:                                         ; preds = %land.lhs.true78, %do.body76
  br label %do.end86, !dbg !2392

do.end86:                                         ; preds = %if.end85
  %54 = load %struct.setlist** %head.addr, align 8, !dbg !2390
  %lh_first87 = getelementptr inbounds %struct.setlist* %54, i32 0, i32 0, !dbg !2390
  %55 = load %struct.cpuset** %lh_first87, align 8, !dbg !2390
  %56 = load %struct.cpuset** %set.addr, align 8, !dbg !2390
  %cs_link88 = getelementptr inbounds %struct.cpuset* %56, i32 0, i32 5, !dbg !2390
  %le_next89 = getelementptr inbounds %struct.anon.7* %cs_link88, i32 0, i32 0, !dbg !2390
  store %struct.cpuset* %55, %struct.cpuset** %le_next89, align 8, !dbg !2390
  %cmp90 = icmp ne %struct.cpuset* %55, null, !dbg !2390
  br i1 %cmp90, label %if.then91, label %if.end97, !dbg !2390

if.then91:                                        ; preds = %do.end86
  %57 = load %struct.cpuset** %set.addr, align 8, !dbg !2390
  %cs_link92 = getelementptr inbounds %struct.cpuset* %57, i32 0, i32 5, !dbg !2390
  %le_next93 = getelementptr inbounds %struct.anon.7* %cs_link92, i32 0, i32 0, !dbg !2390
  %58 = load %struct.setlist** %head.addr, align 8, !dbg !2390
  %lh_first94 = getelementptr inbounds %struct.setlist* %58, i32 0, i32 0, !dbg !2390
  %59 = load %struct.cpuset** %lh_first94, align 8, !dbg !2390
  %cs_link95 = getelementptr inbounds %struct.cpuset* %59, i32 0, i32 5, !dbg !2390
  %le_prev96 = getelementptr inbounds %struct.anon.7* %cs_link95, i32 0, i32 1, !dbg !2390
  store %struct.cpuset** %le_next93, %struct.cpuset*** %le_prev96, align 8, !dbg !2390
  br label %if.end97, !dbg !2390

if.end97:                                         ; preds = %if.then91, %do.end86
  %60 = load %struct.cpuset** %set.addr, align 8, !dbg !2390
  %61 = load %struct.setlist** %head.addr, align 8, !dbg !2390
  %lh_first98 = getelementptr inbounds %struct.setlist* %61, i32 0, i32 0, !dbg !2390
  store %struct.cpuset* %60, %struct.cpuset** %lh_first98, align 8, !dbg !2390
  %62 = load %struct.setlist** %head.addr, align 8, !dbg !2390
  %lh_first99 = getelementptr inbounds %struct.setlist* %62, i32 0, i32 0, !dbg !2390
  %63 = load %struct.cpuset** %set.addr, align 8, !dbg !2390
  %cs_link100 = getelementptr inbounds %struct.cpuset* %63, i32 0, i32 5, !dbg !2390
  %le_prev101 = getelementptr inbounds %struct.anon.7* %cs_link100, i32 0, i32 1, !dbg !2390
  store %struct.cpuset** %lh_first99, %struct.cpuset*** %le_prev101, align 8, !dbg !2390
  br label %do.end102, !dbg !2390

do.end102:                                        ; preds = %if.end97
  call void @__mtx_unlock_spin_flags(i64* getelementptr inbounds (%struct.mtx* @cpuset_lock, i32 0, i32 1), i32 0, i8* getelementptr inbounds ([44 x i8]* @.str, i32 0, i32 0), i32 200) #7, !dbg !2394
  br label %return, !dbg !2394

return:                                           ; preds = %do.end102, %if.then
  ret void, !dbg !2394
}

; Function Attrs: noimplicitfloat noredzone nounwind ssp
define internal void @cpuset_rel_complete(%struct.cpuset* %set) #0 {
entry:
  %set.addr = alloca %struct.cpuset*, align 8
  store %struct.cpuset* %set, %struct.cpuset** %set.addr, align 8
  call void @llvm.dbg.declare(metadata !{%struct.cpuset** %set.addr}, metadata !2395), !dbg !2396
  br label %do.body, !dbg !2397

do.body:                                          ; preds = %entry
  br label %do.body1, !dbg !2398

do.body1:                                         ; preds = %do.body
  %0 = load %struct.cpuset** %set.addr, align 8, !dbg !2400
  %cs_link = getelementptr inbounds %struct.cpuset* %0, i32 0, i32 5, !dbg !2400
  %le_next = getelementptr inbounds %struct.anon.7* %cs_link, i32 0, i32 0, !dbg !2400
  %1 = load %struct.cpuset** %le_next, align 8, !dbg !2400
  %cmp = icmp ne %struct.cpuset* %1, null, !dbg !2400
  br i1 %cmp, label %land.lhs.true, label %if.end, !dbg !2400

land.lhs.true:                                    ; preds = %do.body1
  %2 = load %struct.cpuset** %set.addr, align 8, !dbg !2400
  %cs_link2 = getelementptr inbounds %struct.cpuset* %2, i32 0, i32 5, !dbg !2400
  %le_next3 = getelementptr inbounds %struct.anon.7* %cs_link2, i32 0, i32 0, !dbg !2400
  %3 = load %struct.cpuset** %le_next3, align 8, !dbg !2400
  %cs_link4 = getelementptr inbounds %struct.cpuset* %3, i32 0, i32 5, !dbg !2400
  %le_prev = getelementptr inbounds %struct.anon.7* %cs_link4, i32 0, i32 1, !dbg !2400
  %4 = load %struct.cpuset*** %le_prev, align 8, !dbg !2400
  %5 = load %struct.cpuset** %set.addr, align 8, !dbg !2400
  %cs_link5 = getelementptr inbounds %struct.cpuset* %5, i32 0, i32 5, !dbg !2400
  %le_next6 = getelementptr inbounds %struct.anon.7* %cs_link5, i32 0, i32 0, !dbg !2400
  %cmp7 = icmp ne %struct.cpuset** %4, %le_next6, !dbg !2400
  br i1 %cmp7, label %if.then, label %if.end, !dbg !2400

if.then:                                          ; preds = %land.lhs.true
  %6 = load %struct.cpuset** %set.addr, align 8, !dbg !2400
  call void (i8*, ...)* @panic(i8* getelementptr inbounds ([34 x i8]* @.str1, i32 0, i32 0), %struct.cpuset* %6) #8, !dbg !2400
  unreachable, !dbg !2400

if.end:                                           ; preds = %land.lhs.true, %do.body1
  br label %do.end, !dbg !2400

do.end:                                           ; preds = %if.end
  br label %do.body8, !dbg !2398

do.body8:                                         ; preds = %do.end
  %7 = load %struct.cpuset** %set.addr, align 8, !dbg !2402
  %cs_link9 = getelementptr inbounds %struct.cpuset* %7, i32 0, i32 5, !dbg !2402
  %le_prev10 = getelementptr inbounds %struct.anon.7* %cs_link9, i32 0, i32 1, !dbg !2402
  %8 = load %struct.cpuset*** %le_prev10, align 8, !dbg !2402
  %9 = load %struct.cpuset** %8, align 8, !dbg !2402
  %10 = load %struct.cpuset** %set.addr, align 8, !dbg !2402
  %cmp11 = icmp ne %struct.cpuset* %9, %10, !dbg !2402
  br i1 %cmp11, label %if.then12, label %if.end13, !dbg !2402

if.then12:                                        ; preds = %do.body8
  %11 = load %struct.cpuset** %set.addr, align 8, !dbg !2402
  call void (i8*, ...)* @panic(i8* getelementptr inbounds ([34 x i8]* @.str2, i32 0, i32 0), %struct.cpuset* %11) #8, !dbg !2402
  unreachable, !dbg !2402

if.end13:                                         ; preds = %do.body8
  br label %do.end14, !dbg !2402

do.end14:                                         ; preds = %if.end13
  %12 = load %struct.cpuset** %set.addr, align 8, !dbg !2398
  %cs_link15 = getelementptr inbounds %struct.cpuset* %12, i32 0, i32 5, !dbg !2398
  %le_next16 = getelementptr inbounds %struct.anon.7* %cs_link15, i32 0, i32 0, !dbg !2398
  %13 = load %struct.cpuset** %le_next16, align 8, !dbg !2398
  %cmp17 = icmp ne %struct.cpuset* %13, null, !dbg !2398
  br i1 %cmp17, label %if.then18, label %if.end25, !dbg !2398

if.then18:                                        ; preds = %do.end14
  %14 = load %struct.cpuset** %set.addr, align 8, !dbg !2398
  %cs_link19 = getelementptr inbounds %struct.cpuset* %14, i32 0, i32 5, !dbg !2398
  %le_prev20 = getelementptr inbounds %struct.anon.7* %cs_link19, i32 0, i32 1, !dbg !2398
  %15 = load %struct.cpuset*** %le_prev20, align 8, !dbg !2398
  %16 = load %struct.cpuset** %set.addr, align 8, !dbg !2398
  %cs_link21 = getelementptr inbounds %struct.cpuset* %16, i32 0, i32 5, !dbg !2398
  %le_next22 = getelementptr inbounds %struct.anon.7* %cs_link21, i32 0, i32 0, !dbg !2398
  %17 = load %struct.cpuset** %le_next22, align 8, !dbg !2398
  %cs_link23 = getelementptr inbounds %struct.cpuset* %17, i32 0, i32 5, !dbg !2398
  %le_prev24 = getelementptr inbounds %struct.anon.7* %cs_link23, i32 0, i32 1, !dbg !2398
  store %struct.cpuset** %15, %struct.cpuset*** %le_prev24, align 8, !dbg !2398
  br label %if.end25, !dbg !2398

if.end25:                                         ; preds = %if.then18, %do.end14
  %18 = load %struct.cpuset** %set.addr, align 8, !dbg !2398
  %cs_link26 = getelementptr inbounds %struct.cpuset* %18, i32 0, i32 5, !dbg !2398
  %le_next27 = getelementptr inbounds %struct.anon.7* %cs_link26, i32 0, i32 0, !dbg !2398
  %19 = load %struct.cpuset** %le_next27, align 8, !dbg !2398
  %20 = load %struct.cpuset** %set.addr, align 8, !dbg !2398
  %cs_link28 = getelementptr inbounds %struct.cpuset* %20, i32 0, i32 5, !dbg !2398
  %le_prev29 = getelementptr inbounds %struct.anon.7* %cs_link28, i32 0, i32 1, !dbg !2398
  %21 = load %struct.cpuset*** %le_prev29, align 8, !dbg !2398
  store %struct.cpuset* %19, %struct.cpuset** %21, align 8, !dbg !2398
  br label %do.end30, !dbg !2398

do.end30:                                         ; preds = %if.end25
  %22 = load %struct.cpuset** %set.addr, align 8, !dbg !2404
  %cs_parent = getelementptr inbounds %struct.cpuset* %22, i32 0, i32 4, !dbg !2404
  %23 = load %struct.cpuset** %cs_parent, align 8, !dbg !2404
  call void @cpuset_rel(%struct.cpuset* %23) #7, !dbg !2404
  %24 = load %struct.uma_zone** @cpuset_zone, align 8, !dbg !2405
  %25 = load %struct.cpuset** %set.addr, align 8, !dbg !2405
  %26 = bitcast %struct.cpuset* %25 to i8*, !dbg !2405
  call void @uma_zfree(%struct.uma_zone* %24, i8* %26) #7, !dbg !2405
  ret void, !dbg !2406
}

; Function Attrs: noimplicitfloat noredzone
declare i32 @alloc_unr(%struct.unrhdr*) #3

; Function Attrs: inlinehint noimplicitfloat noredzone nounwind ssp
define internal void @refcount_init(i32* %count, i32 %value) #2 {
entry:
  %count.addr = alloca i32*, align 8
  %value.addr = alloca i32, align 4
  store i32* %count, i32** %count.addr, align 8
  call void @llvm.dbg.declare(metadata !{i32** %count.addr}, metadata !2407), !dbg !2408
  store i32 %value, i32* %value.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %value.addr}, metadata !2409), !dbg !2408
  %0 = load i32* %value.addr, align 4, !dbg !2410
  %1 = load i32** %count.addr, align 8, !dbg !2410
  store volatile i32 %0, i32* %1, align 4, !dbg !2410
  ret void, !dbg !2412
}

; Function Attrs: noimplicitfloat noredzone
declare void @__mtx_lock_flags(i64*, i32, i8*, i32) #3

; Function Attrs: noimplicitfloat noredzone
declare %struct.proc* @pfind(i32) #3

; Function Attrs: noimplicitfloat noredzone
declare %struct.thread* @tdfind(i32, i32) #3

; Function Attrs: noimplicitfloat noredzone
declare i32 @_sx_slock(%struct.sx*, i32, i8*, i32) #3

; Function Attrs: noimplicitfloat noredzone
declare %struct.prison* @prison_find_child(%struct.prison*, i32) #3

; Function Attrs: noimplicitfloat noredzone
declare void @_sx_sunlock(%struct.sx*, i8*, i32) #3

; Function Attrs: noimplicitfloat noredzone
declare i32 @p_cansched(%struct.thread*, %struct.proc*) #3

; Function Attrs: noimplicitfloat noredzone
declare i8* @uma_zalloc_arg(%struct.uma_zone*, i8*, i32) #3

; Function Attrs: inlinehint noimplicitfloat noredzone nounwind ssp
define internal i64 @bsfq(i64 %mask) #2 {
entry:
  %mask.addr = alloca i64, align 8
  %result = alloca i64, align 8
  store i64 %mask, i64* %mask.addr, align 8
  call void @llvm.dbg.declare(metadata !{i64* %mask.addr}, metadata !2413), !dbg !2414
  call void @llvm.dbg.declare(metadata !{i64* %result}, metadata !2415), !dbg !2416
  %0 = load i64* %mask.addr, align 8, !dbg !2417
  %1 = call i64 asm sideeffect "bsfq $1,$0", "=r,rm,~{dirflag},~{fpsr},~{flags}"(i64 %0) #5, !dbg !2417, !srcloc !2418
  store i64 %1, i64* %result, align 8, !dbg !2417
  %2 = load i64* %result, align 8, !dbg !2419
  ret i64 %2, !dbg !2419
}

; Function Attrs: noimplicitfloat noredzone
declare void @uma_zfree_arg(%struct.uma_zone*, i8*, i8*) #3

; Function Attrs: inlinehint noimplicitfloat noredzone nounwind ssp
define internal i32 @atomic_fetchadd_int(i32* %p, i32 %v) #2 {
entry:
  %p.addr = alloca i32*, align 8
  %v.addr = alloca i32, align 4
  store i32* %p, i32** %p.addr, align 8
  call void @llvm.dbg.declare(metadata !{i32** %p.addr}, metadata !2420), !dbg !2421
  store i32 %v, i32* %v.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %v.addr}, metadata !2422), !dbg !2421
  %0 = load i32* %v.addr, align 4, !dbg !2423
  %1 = load i32** %p.addr, align 8, !dbg !2423
  %2 = load i32** %p.addr, align 8, !dbg !2423
  %3 = call i32 asm sideeffect "\09lock ; \09\09\09xaddl\09$0, $1 ;\09# atomic_fetchadd_int", "=r,=*m,*m,0,~{cc},~{dirflag},~{fpsr},~{flags}"(i32* %1, i32* %2, i32 %0) #5, !dbg !2423, !srcloc !2425
  store i32 %3, i32* %v.addr, align 4, !dbg !2423
  %4 = load i32* %v.addr, align 4, !dbg !2426
  ret i32 %4, !dbg !2426
}

; Function Attrs: inlinehint noimplicitfloat noredzone nounwind ssp
define internal void @atomic_add_barr_int(i32* %p, i32 %v) #2 {
entry:
  %p.addr = alloca i32*, align 8
  %v.addr = alloca i32, align 4
  store i32* %p, i32** %p.addr, align 8
  call void @llvm.dbg.declare(metadata !{i32** %p.addr}, metadata !2427), !dbg !2428
  store i32 %v, i32* %v.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %v.addr}, metadata !2429), !dbg !2428
  %0 = load i32** %p.addr, align 8, !dbg !2430
  %1 = load i32* %v.addr, align 4, !dbg !2430
  %2 = load i32** %p.addr, align 8, !dbg !2430
  call void asm sideeffect "lock ; addl $1,$0", "=*m,ir,*m,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32* %0, i32 %1, i32* %2) #5, !dbg !2430, !srcloc !2432
  ret void, !dbg !2430
}

; Function Attrs: noimplicitfloat noredzone
declare i32 @sysctl_handle_int(%struct.sysctl_oid*, i8*, i64, %struct.sysctl_req*) #3

attributes #0 = { noimplicitfloat noredzone nounwind ssp "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf"="true" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { inlinehint noimplicitfloat noredzone nounwind ssp "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf"="true" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { noimplicitfloat noredzone "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf"="true" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { noimplicitfloat noredzone noreturn "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf"="true" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind }
attributes #6 = { inlinehint noimplicitfloat noredzone nounwind readnone ssp "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf"="true" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #7 = { nobuiltin noimplicitfloat noredzone }
attributes #8 = { nobuiltin noimplicitfloat noredzone noreturn }
attributes #9 = { nobuiltin noimplicitfloat noredzone nounwind readnone }

!llvm.dbg.cu = !{!0}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"clang version 3.3 (186022)", i1 false, metadata !"", i32 0, metadata !2, metadata !1102, metadata !1103, metadata !1314, metadata !1102, metadata !""} ; [ DW_TAG_compile_unit ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c] [DW_LANG_C99]
!1 = metadata !{metadata !"/home/jra40/P4/tesla/sys/kern/kern_cpuset.c", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!2 = metadata !{metadata !3, metadata !528, metadata !1010, metadata !1094}
!3 = metadata !{i32 786436, metadata !4, metadata !5, metadata !"", i32 502, i64 32, i64 32, i32 0, i32 0, null, metadata !1006, i32 0, i32 0} ; [ DW_TAG_enumeration_type ] [line 502, size 32, align 32, offset 0] [from ]
!4 = metadata !{metadata !"/home/jra40/P4/tesla/sys/sys/proc.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!5 = metadata !{i32 786451, metadata !4, null, metadata !"proc", i32 485, i64 9664, i64 64, i32 0, i32 0, null, metadata !6, i32 0, null, null} ; [ DW_TAG_structure_type ] [proc] [line 485, size 9664, align 64, offset 0] [from ]
!6 = metadata !{metadata !7, metadata !14, metadata !657, metadata !658, metadata !659, metadata !662, metadata !665, metadata !668, metadata !671, metadata !672, metadata !700, metadata !701, metadata !702, metadata !703, metadata !708, metadata !713, metadata !714, metadata !719, metadata !723, metadata !724, metadata !725, metadata !726, metadata !727, metadata !730, metadata !731, metadata !737, metadata !738, metadata !739, metadata !740, metadata !741, metadata !742, metadata !743, metadata !744, metadata !745, metadata !746, metadata !747, metadata !805, metadata !806, metadata !807, metadata !808, metadata !809, metadata !810, metadata !811, metadata !812, metadata !815, metadata !818, metadata !819, metadata !820, metadata !821, metadata !822, metadata !823, metadata !826, metadata !829, metadata !830, metadata !831, metadata !832, metadata !833, metadata !836, metadata !844, metadata !847, metadata !849, metadata !850, metadata !851, metadata !934, metadata !935, metadata !961, metadata !962, metadata !963, metadata !964, metadata !965, metadata !966, metadata !967, metadata !970, metadata !978, metadata !984, metadata !987, metadata !993, metadata !994, metadata !995, metadata !996, metadata !997, metadata !1002}
!7 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_list", i32 486, i64 128, i64 64, i64 0, i32 0, metadata !8} ; [ DW_TAG_member ] [p_list] [line 486, size 128, align 64, offset 0] [from ]
!8 = metadata !{i32 786451, metadata !4, metadata !5, metadata !"", i32 486, i64 128, i64 64, i32 0, i32 0, null, metadata !9, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 486, size 128, align 64, offset 0] [from ]
!9 = metadata !{metadata !10, metadata !12}
!10 = metadata !{i32 786445, metadata !4, metadata !8, metadata !"le_next", i32 486, i64 64, i64 64, i64 0, i32 0, metadata !11} ; [ DW_TAG_member ] [le_next] [line 486, size 64, align 64, offset 0] [from ]
!11 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !5} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from proc]
!12 = metadata !{i32 786445, metadata !4, metadata !8, metadata !"le_prev", i32 486, i64 64, i64 64, i64 64, i32 0, metadata !13} ; [ DW_TAG_member ] [le_prev] [line 486, size 64, align 64, offset 64] [from ]
!13 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !11} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!14 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_threads", i32 487, i64 128, i64 64, i64 128, i32 0, metadata !15} ; [ DW_TAG_member ] [p_threads] [line 487, size 128, align 64, offset 128] [from ]
!15 = metadata !{i32 786451, metadata !4, metadata !5, metadata !"", i32 487, i64 128, i64 64, i32 0, i32 0, null, metadata !16, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 487, size 128, align 64, offset 0] [from ]
!16 = metadata !{metadata !17, metadata !656}
!17 = metadata !{i32 786445, metadata !4, metadata !15, metadata !"tqh_first", i32 487, i64 64, i64 64, i64 0, i32 0, metadata !18} ; [ DW_TAG_member ] [tqh_first] [line 487, size 64, align 64, offset 0] [from ]
!18 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !19} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from thread]
!19 = metadata !{i32 786451, metadata !4, null, metadata !"thread", i32 205, i64 9088, i64 64, i32 0, i32 0, null, metadata !20, i32 0, null, null} ; [ DW_TAG_structure_type ] [thread] [line 205, size 9088, align 64, offset 0] [from ]
!20 = metadata !{metadata !21, metadata !49, metadata !50, metadata !56, metadata !61, metadata !66, metadata !71, metadata !76, metadata !113, metadata !116, metadata !119, metadata !122, metadata !125, metadata !128, metadata !132, metadata !220, metadata !223, metadata !224, metadata !225, metadata !226, metadata !227, metadata !228, metadata !229, metadata !230, metadata !231, metadata !232, metadata !234, metadata !235, metadata !237, metadata !238, metadata !239, metadata !240, metadata !241, metadata !242, metadata !246, metadata !250, metadata !251, metadata !252, metadata !428, metadata !429, metadata !430, metadata !431, metadata !432, metadata !433, metadata !464, metadata !475, metadata !476, metadata !477, metadata !478, metadata !479, metadata !480, metadata !481, metadata !482, metadata !483, metadata !484, metadata !493, metadata !494, metadata !496, metadata !497, metadata !501, metadata !505, metadata !506, metadata !507, metadata !508, metadata !509, metadata !512, metadata !513, metadata !514, metadata !515, metadata !516, metadata !517, metadata !518, metadata !519, metadata !520, metadata !521, metadata !522, metadata !523, metadata !527, metadata !535, metadata !539, metadata !574, metadata !610, metadata !613, metadata !616, metadata !617, metadata !618, metadata !625, metadata !628, metadata !631, metadata !639, metadata !642, metadata !643, metadata !644, metadata !645, metadata !646, metadata !647, metadata !652, metadata !653}
!21 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_lock", i32 206, i64 64, i64 64, i64 0, i32 0, metadata !22} ; [ DW_TAG_member ] [td_lock] [line 206, size 64, align 64, offset 0] [from ]
!22 = metadata !{i32 786485, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !23} ; [ DW_TAG_volatile_type ] [line 0, size 0, align 0, offset 0] [from ]
!23 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !24} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from mtx]
!24 = metadata !{i32 786451, metadata !25, null, metadata !"mtx", i32 45, i64 256, i64 64, i32 0, i32 0, null, metadata !26, i32 0, null, null} ; [ DW_TAG_structure_type ] [mtx] [line 45, size 256, align 64, offset 0] [from ]
!25 = metadata !{metadata !"/home/jra40/P4/tesla/sys/sys/_mutex.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!26 = metadata !{metadata !27, metadata !43}
!27 = metadata !{i32 786445, metadata !25, metadata !24, metadata !"lock_object", i32 46, i64 192, i64 64, i64 0, i32 0, metadata !28} ; [ DW_TAG_member ] [lock_object] [line 46, size 192, align 64, offset 0] [from lock_object]
!28 = metadata !{i32 786451, metadata !29, null, metadata !"lock_object", i32 34, i64 192, i64 64, i32 0, i32 0, null, metadata !30, i32 0, null, null} ; [ DW_TAG_structure_type ] [lock_object] [line 34, size 192, align 64, offset 0] [from ]
!29 = metadata !{metadata !"/home/jra40/P4/tesla/sys/sys/_lock.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!30 = metadata !{metadata !31, metadata !35, metadata !39, metadata !40}
!31 = metadata !{i32 786445, metadata !29, metadata !28, metadata !"lo_name", i32 35, i64 64, i64 64, i64 0, i32 0, metadata !32} ; [ DW_TAG_member ] [lo_name] [line 35, size 64, align 64, offset 0] [from ]
!32 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !33} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!33 = metadata !{i32 786470, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !34} ; [ DW_TAG_const_type ] [line 0, size 0, align 0, offset 0] [from char]
!34 = metadata !{i32 786468, null, null, metadata !"char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ] [char] [line 0, size 8, align 8, offset 0, enc DW_ATE_signed_char]
!35 = metadata !{i32 786445, metadata !29, metadata !28, metadata !"lo_flags", i32 36, i64 32, i64 32, i64 64, i32 0, metadata !36} ; [ DW_TAG_member ] [lo_flags] [line 36, size 32, align 32, offset 64] [from u_int]
!36 = metadata !{i32 786454, metadata !37, null, metadata !"u_int", i32 52, i64 0, i64 0, i64 0, i32 0, metadata !38} ; [ DW_TAG_typedef ] [u_int] [line 52, size 0, align 0, offset 0] [from unsigned int]
!37 = metadata !{metadata !"/home/jra40/P4/tesla/sys/sys/cpuset.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!38 = metadata !{i32 786468, null, null, metadata !"unsigned int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [unsigned int] [line 0, size 32, align 32, offset 0, enc DW_ATE_unsigned]
!39 = metadata !{i32 786445, metadata !29, metadata !28, metadata !"lo_data", i32 37, i64 32, i64 32, i64 96, i32 0, metadata !36} ; [ DW_TAG_member ] [lo_data] [line 37, size 32, align 32, offset 96] [from u_int]
!40 = metadata !{i32 786445, metadata !29, metadata !28, metadata !"lo_witness", i32 38, i64 64, i64 64, i64 128, i32 0, metadata !41} ; [ DW_TAG_member ] [lo_witness] [line 38, size 64, align 64, offset 128] [from ]
!41 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !42} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from witness]
!42 = metadata !{i32 786451, metadata !29, null, metadata !"witness", i32 38, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [witness] [line 38, size 0, align 0, offset 0] [fwd] [from ]
!43 = metadata !{i32 786445, metadata !25, metadata !24, metadata !"mtx_lock", i32 47, i64 64, i64 64, i64 192, i32 0, metadata !44} ; [ DW_TAG_member ] [mtx_lock] [line 47, size 64, align 64, offset 192] [from ]
!44 = metadata !{i32 786485, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !45} ; [ DW_TAG_volatile_type ] [line 0, size 0, align 0, offset 0] [from uintptr_t]
!45 = metadata !{i32 786454, metadata !25, null, metadata !"uintptr_t", i32 78, i64 0, i64 0, i64 0, i32 0, metadata !46} ; [ DW_TAG_typedef ] [uintptr_t] [line 78, size 0, align 0, offset 0] [from __uintptr_t]
!46 = metadata !{i32 786454, metadata !25, null, metadata !"__uintptr_t", i32 108, i64 0, i64 0, i64 0, i32 0, metadata !47} ; [ DW_TAG_typedef ] [__uintptr_t] [line 108, size 0, align 0, offset 0] [from __uint64_t]
!47 = metadata !{i32 786454, metadata !1, null, metadata !"__uint64_t", i32 59, i64 0, i64 0, i64 0, i32 0, metadata !48} ; [ DW_TAG_typedef ] [__uint64_t] [line 59, size 0, align 0, offset 0] [from long unsigned int]
!48 = metadata !{i32 786468, null, null, metadata !"long unsigned int", i32 0, i64 64, i64 64, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [long unsigned int] [line 0, size 64, align 64, offset 0, enc DW_ATE_unsigned]
!49 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_proc", i32 207, i64 64, i64 64, i64 64, i32 0, metadata !11} ; [ DW_TAG_member ] [td_proc] [line 207, size 64, align 64, offset 64] [from ]
!50 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_plist", i32 208, i64 128, i64 64, i64 128, i32 0, metadata !51} ; [ DW_TAG_member ] [td_plist] [line 208, size 128, align 64, offset 128] [from ]
!51 = metadata !{i32 786451, metadata !4, metadata !19, metadata !"", i32 208, i64 128, i64 64, i32 0, i32 0, null, metadata !52, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 208, size 128, align 64, offset 0] [from ]
!52 = metadata !{metadata !53, metadata !54}
!53 = metadata !{i32 786445, metadata !4, metadata !51, metadata !"tqe_next", i32 208, i64 64, i64 64, i64 0, i32 0, metadata !18} ; [ DW_TAG_member ] [tqe_next] [line 208, size 64, align 64, offset 0] [from ]
!54 = metadata !{i32 786445, metadata !4, metadata !51, metadata !"tqe_prev", i32 208, i64 64, i64 64, i64 64, i32 0, metadata !55} ; [ DW_TAG_member ] [tqe_prev] [line 208, size 64, align 64, offset 64] [from ]
!55 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !18} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!56 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_runq", i32 209, i64 128, i64 64, i64 256, i32 0, metadata !57} ; [ DW_TAG_member ] [td_runq] [line 209, size 128, align 64, offset 256] [from ]
!57 = metadata !{i32 786451, metadata !4, metadata !19, metadata !"", i32 209, i64 128, i64 64, i32 0, i32 0, null, metadata !58, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 209, size 128, align 64, offset 0] [from ]
!58 = metadata !{metadata !59, metadata !60}
!59 = metadata !{i32 786445, metadata !4, metadata !57, metadata !"tqe_next", i32 209, i64 64, i64 64, i64 0, i32 0, metadata !18} ; [ DW_TAG_member ] [tqe_next] [line 209, size 64, align 64, offset 0] [from ]
!60 = metadata !{i32 786445, metadata !4, metadata !57, metadata !"tqe_prev", i32 209, i64 64, i64 64, i64 64, i32 0, metadata !55} ; [ DW_TAG_member ] [tqe_prev] [line 209, size 64, align 64, offset 64] [from ]
!61 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_slpq", i32 210, i64 128, i64 64, i64 384, i32 0, metadata !62} ; [ DW_TAG_member ] [td_slpq] [line 210, size 128, align 64, offset 384] [from ]
!62 = metadata !{i32 786451, metadata !4, metadata !19, metadata !"", i32 210, i64 128, i64 64, i32 0, i32 0, null, metadata !63, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 210, size 128, align 64, offset 0] [from ]
!63 = metadata !{metadata !64, metadata !65}
!64 = metadata !{i32 786445, metadata !4, metadata !62, metadata !"tqe_next", i32 210, i64 64, i64 64, i64 0, i32 0, metadata !18} ; [ DW_TAG_member ] [tqe_next] [line 210, size 64, align 64, offset 0] [from ]
!65 = metadata !{i32 786445, metadata !4, metadata !62, metadata !"tqe_prev", i32 210, i64 64, i64 64, i64 64, i32 0, metadata !55} ; [ DW_TAG_member ] [tqe_prev] [line 210, size 64, align 64, offset 64] [from ]
!66 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_lockq", i32 211, i64 128, i64 64, i64 512, i32 0, metadata !67} ; [ DW_TAG_member ] [td_lockq] [line 211, size 128, align 64, offset 512] [from ]
!67 = metadata !{i32 786451, metadata !4, metadata !19, metadata !"", i32 211, i64 128, i64 64, i32 0, i32 0, null, metadata !68, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 211, size 128, align 64, offset 0] [from ]
!68 = metadata !{metadata !69, metadata !70}
!69 = metadata !{i32 786445, metadata !4, metadata !67, metadata !"tqe_next", i32 211, i64 64, i64 64, i64 0, i32 0, metadata !18} ; [ DW_TAG_member ] [tqe_next] [line 211, size 64, align 64, offset 0] [from ]
!70 = metadata !{i32 786445, metadata !4, metadata !67, metadata !"tqe_prev", i32 211, i64 64, i64 64, i64 64, i32 0, metadata !55} ; [ DW_TAG_member ] [tqe_prev] [line 211, size 64, align 64, offset 64] [from ]
!71 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_hash", i32 212, i64 128, i64 64, i64 640, i32 0, metadata !72} ; [ DW_TAG_member ] [td_hash] [line 212, size 128, align 64, offset 640] [from ]
!72 = metadata !{i32 786451, metadata !4, metadata !19, metadata !"", i32 212, i64 128, i64 64, i32 0, i32 0, null, metadata !73, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 212, size 128, align 64, offset 0] [from ]
!73 = metadata !{metadata !74, metadata !75}
!74 = metadata !{i32 786445, metadata !4, metadata !72, metadata !"le_next", i32 212, i64 64, i64 64, i64 0, i32 0, metadata !18} ; [ DW_TAG_member ] [le_next] [line 212, size 64, align 64, offset 0] [from ]
!75 = metadata !{i32 786445, metadata !4, metadata !72, metadata !"le_prev", i32 212, i64 64, i64 64, i64 64, i32 0, metadata !55} ; [ DW_TAG_member ] [le_prev] [line 212, size 64, align 64, offset 64] [from ]
!76 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_cpuset", i32 213, i64 64, i64 64, i64 768, i32 0, metadata !77} ; [ DW_TAG_member ] [td_cpuset] [line 213, size 64, align 64, offset 768] [from ]
!77 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !78} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from cpuset]
!78 = metadata !{i32 786451, metadata !37, null, metadata !"cpuset", i32 97, i64 576, i64 64, i32 0, i32 0, null, metadata !79, i32 0, null, null} ; [ DW_TAG_structure_type ] [cpuset] [line 97, size 576, align 64, offset 0] [from ]
!79 = metadata !{metadata !80, metadata !90, metadata !92, metadata !94, metadata !97, metadata !98, metadata !104, metadata !109}
!80 = metadata !{i32 786445, metadata !37, metadata !78, metadata !"cs_mask", i32 98, i64 64, i64 64, i64 0, i32 0, metadata !81} ; [ DW_TAG_member ] [cs_mask] [line 98, size 64, align 64, offset 0] [from cpuset_t]
!81 = metadata !{i32 786454, metadata !37, null, metadata !"cpuset_t", i32 51, i64 0, i64 0, i64 0, i32 0, metadata !82} ; [ DW_TAG_typedef ] [cpuset_t] [line 51, size 0, align 0, offset 0] [from _cpuset]
!82 = metadata !{i32 786451, metadata !83, null, metadata !"_cpuset", i32 50, i64 64, i64 64, i32 0, i32 0, null, metadata !84, i32 0, null, null} ; [ DW_TAG_structure_type ] [_cpuset] [line 50, size 64, align 64, offset 0] [from ]
!83 = metadata !{metadata !"/home/jra40/P4/tesla/sys/sys/_cpuset.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!84 = metadata !{metadata !85}
!85 = metadata !{i32 786445, metadata !83, metadata !82, metadata !"__bits", i32 50, i64 64, i64 64, i64 0, i32 0, metadata !86} ; [ DW_TAG_member ] [__bits] [line 50, size 64, align 64, offset 0] [from ]
!86 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 64, i64 64, i32 0, i32 0, metadata !87, metadata !88, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 64, align 64, offset 0] [from long int]
!87 = metadata !{i32 786468, null, null, metadata !"long int", i32 0, i64 64, i64 64, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [long int] [line 0, size 64, align 64, offset 0, enc DW_ATE_signed]
!88 = metadata !{metadata !89}
!89 = metadata !{i32 786465, i64 0, i64 1}        ; [ DW_TAG_subrange_type ] [0, 0]
!90 = metadata !{i32 786445, metadata !37, metadata !78, metadata !"cs_ref", i32 99, i64 32, i64 32, i64 64, i32 0, metadata !91} ; [ DW_TAG_member ] [cs_ref] [line 99, size 32, align 32, offset 64] [from ]
!91 = metadata !{i32 786485, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !36} ; [ DW_TAG_volatile_type ] [line 0, size 0, align 0, offset 0] [from u_int]
!92 = metadata !{i32 786445, metadata !37, metadata !78, metadata !"cs_flags", i32 100, i64 32, i64 32, i64 96, i32 0, metadata !93} ; [ DW_TAG_member ] [cs_flags] [line 100, size 32, align 32, offset 96] [from int]
!93 = metadata !{i32 786468, null, null, metadata !"int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [int] [line 0, size 32, align 32, offset 0, enc DW_ATE_signed]
!94 = metadata !{i32 786445, metadata !37, metadata !78, metadata !"cs_id", i32 101, i64 32, i64 32, i64 128, i32 0, metadata !95} ; [ DW_TAG_member ] [cs_id] [line 101, size 32, align 32, offset 128] [from cpusetid_t]
!95 = metadata !{i32 786454, metadata !37, null, metadata !"cpusetid_t", i32 84, i64 0, i64 0, i64 0, i32 0, metadata !96} ; [ DW_TAG_typedef ] [cpusetid_t] [line 84, size 0, align 0, offset 0] [from __cpusetid_t]
!96 = metadata !{i32 786454, metadata !37, null, metadata !"__cpusetid_t", i32 68, i64 0, i64 0, i64 0, i32 0, metadata !93} ; [ DW_TAG_typedef ] [__cpusetid_t] [line 68, size 0, align 0, offset 0] [from int]
!97 = metadata !{i32 786445, metadata !37, metadata !78, metadata !"cs_parent", i32 102, i64 64, i64 64, i64 192, i32 0, metadata !77} ; [ DW_TAG_member ] [cs_parent] [line 102, size 64, align 64, offset 192] [from ]
!98 = metadata !{i32 786445, metadata !37, metadata !78, metadata !"cs_link", i32 103, i64 128, i64 64, i64 256, i32 0, metadata !99} ; [ DW_TAG_member ] [cs_link] [line 103, size 128, align 64, offset 256] [from ]
!99 = metadata !{i32 786451, metadata !37, metadata !78, metadata !"", i32 103, i64 128, i64 64, i32 0, i32 0, null, metadata !100, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 103, size 128, align 64, offset 0] [from ]
!100 = metadata !{metadata !101, metadata !102}
!101 = metadata !{i32 786445, metadata !37, metadata !99, metadata !"le_next", i32 103, i64 64, i64 64, i64 0, i32 0, metadata !77} ; [ DW_TAG_member ] [le_next] [line 103, size 64, align 64, offset 0] [from ]
!102 = metadata !{i32 786445, metadata !37, metadata !99, metadata !"le_prev", i32 103, i64 64, i64 64, i64 64, i32 0, metadata !103} ; [ DW_TAG_member ] [le_prev] [line 103, size 64, align 64, offset 64] [from ]
!103 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !77} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!104 = metadata !{i32 786445, metadata !37, metadata !78, metadata !"cs_siblings", i32 104, i64 128, i64 64, i64 384, i32 0, metadata !105} ; [ DW_TAG_member ] [cs_siblings] [line 104, size 128, align 64, offset 384] [from ]
!105 = metadata !{i32 786451, metadata !37, metadata !78, metadata !"", i32 104, i64 128, i64 64, i32 0, i32 0, null, metadata !106, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 104, size 128, align 64, offset 0] [from ]
!106 = metadata !{metadata !107, metadata !108}
!107 = metadata !{i32 786445, metadata !37, metadata !105, metadata !"le_next", i32 104, i64 64, i64 64, i64 0, i32 0, metadata !77} ; [ DW_TAG_member ] [le_next] [line 104, size 64, align 64, offset 0] [from ]
!108 = metadata !{i32 786445, metadata !37, metadata !105, metadata !"le_prev", i32 104, i64 64, i64 64, i64 64, i32 0, metadata !103} ; [ DW_TAG_member ] [le_prev] [line 104, size 64, align 64, offset 64] [from ]
!109 = metadata !{i32 786445, metadata !37, metadata !78, metadata !"cs_children", i32 105, i64 64, i64 64, i64 512, i32 0, metadata !110} ; [ DW_TAG_member ] [cs_children] [line 105, size 64, align 64, offset 512] [from setlist]
!110 = metadata !{i32 786451, metadata !37, null, metadata !"setlist", i32 84, i64 64, i64 64, i32 0, i32 0, null, metadata !111, i32 0, null, null} ; [ DW_TAG_structure_type ] [setlist] [line 84, size 64, align 64, offset 0] [from ]
!111 = metadata !{metadata !112}
!112 = metadata !{i32 786445, metadata !37, metadata !110, metadata !"lh_first", i32 84, i64 64, i64 64, i64 0, i32 0, metadata !77} ; [ DW_TAG_member ] [lh_first] [line 84, size 64, align 64, offset 0] [from ]
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
!129 = metadata !{i32 786454, metadata !1, null, metadata !"lwpid_t", i32 155, i64 0, i64 0, i64 0, i32 0, metadata !130} ; [ DW_TAG_typedef ] [lwpid_t] [line 155, size 0, align 0, offset 0] [from __lwpid_t]
!130 = metadata !{i32 786454, metadata !1, null, metadata !"__lwpid_t", i32 49, i64 0, i64 0, i64 0, i32 0, metadata !131} ; [ DW_TAG_typedef ] [__lwpid_t] [line 49, size 0, align 0, offset 0] [from __int32_t]
!131 = metadata !{i32 786454, metadata !1, null, metadata !"__int32_t", i32 55, i64 0, i64 0, i64 0, i32 0, metadata !93} ; [ DW_TAG_typedef ] [__int32_t] [line 55, size 0, align 0, offset 0] [from int]
!132 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_sigqueue", i32 220, i64 512, i64 64, i64 1216, i32 0, metadata !133} ; [ DW_TAG_member ] [td_sigqueue] [line 220, size 512, align 64, offset 1216] [from sigqueue_t]
!133 = metadata !{i32 786454, metadata !4, null, metadata !"sigqueue_t", i32 248, i64 0, i64 0, i64 0, i32 0, metadata !134} ; [ DW_TAG_typedef ] [sigqueue_t] [line 248, size 0, align 0, offset 0] [from sigqueue]
!134 = metadata !{i32 786451, metadata !135, null, metadata !"sigqueue", i32 242, i64 512, i64 64, i32 0, i32 0, null, metadata !136, i32 0, null, null} ; [ DW_TAG_structure_type ] [sigqueue] [line 242, size 512, align 64, offset 0] [from ]
!135 = metadata !{metadata !"/home/jra40/P4/tesla/sys/sys/signalvar.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!136 = metadata !{metadata !137, metadata !149, metadata !150, metadata !218, metadata !219}
!137 = metadata !{i32 786445, metadata !135, metadata !134, metadata !"sq_signals", i32 243, i64 128, i64 32, i64 0, i32 0, metadata !138} ; [ DW_TAG_member ] [sq_signals] [line 243, size 128, align 32, offset 0] [from sigset_t]
!138 = metadata !{i32 786454, metadata !135, null, metadata !"sigset_t", i32 49, i64 0, i64 0, i64 0, i32 0, metadata !139} ; [ DW_TAG_typedef ] [sigset_t] [line 49, size 0, align 0, offset 0] [from __sigset_t]
!139 = metadata !{i32 786454, metadata !135, null, metadata !"__sigset_t", i32 53, i64 0, i64 0, i64 0, i32 0, metadata !140} ; [ DW_TAG_typedef ] [__sigset_t] [line 53, size 0, align 0, offset 0] [from __sigset]
!140 = metadata !{i32 786451, metadata !141, null, metadata !"__sigset", i32 51, i64 128, i64 32, i32 0, i32 0, null, metadata !142, i32 0, null, null} ; [ DW_TAG_structure_type ] [__sigset] [line 51, size 128, align 32, offset 0] [from ]
!141 = metadata !{metadata !"/home/jra40/P4/tesla/sys/sys/_sigset.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!142 = metadata !{metadata !143}
!143 = metadata !{i32 786445, metadata !141, metadata !140, metadata !"__bits", i32 52, i64 128, i64 32, i64 0, i32 0, metadata !144} ; [ DW_TAG_member ] [__bits] [line 52, size 128, align 32, offset 0] [from ]
!144 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 128, i64 32, i32 0, i32 0, metadata !145, metadata !147, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 128, align 32, offset 0] [from __uint32_t]
!145 = metadata !{i32 786454, metadata !146, null, metadata !"__uint32_t", i32 56, i64 0, i64 0, i64 0, i32 0, metadata !38} ; [ DW_TAG_typedef ] [__uint32_t] [line 56, size 0, align 0, offset 0] [from unsigned int]
!146 = metadata !{metadata !"/home/jra40/P4/tesla/sys/sys/ucred.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!147 = metadata !{metadata !148}
!148 = metadata !{i32 786465, i64 0, i64 4}       ; [ DW_TAG_subrange_type ] [0, 3]
!149 = metadata !{i32 786445, metadata !135, metadata !134, metadata !"sq_kill", i32 244, i64 128, i64 32, i64 128, i32 0, metadata !138} ; [ DW_TAG_member ] [sq_kill] [line 244, size 128, align 32, offset 128] [from sigset_t]
!150 = metadata !{i32 786445, metadata !135, metadata !134, metadata !"sq_list", i32 245, i64 128, i64 64, i64 256, i32 0, metadata !151} ; [ DW_TAG_member ] [sq_list] [line 245, size 128, align 64, offset 256] [from ]
!151 = metadata !{i32 786451, metadata !135, metadata !134, metadata !"", i32 245, i64 128, i64 64, i32 0, i32 0, null, metadata !152, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 245, size 128, align 64, offset 0] [from ]
!152 = metadata !{metadata !153, metadata !217}
!153 = metadata !{i32 786445, metadata !135, metadata !151, metadata !"tqh_first", i32 245, i64 64, i64 64, i64 0, i32 0, metadata !154} ; [ DW_TAG_member ] [tqh_first] [line 245, size 64, align 64, offset 0] [from ]
!154 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !155} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ksiginfo]
!155 = metadata !{i32 786451, metadata !135, null, metadata !"ksiginfo", i32 211, i64 896, i64 64, i32 0, i32 0, null, metadata !156, i32 0, null, null} ; [ DW_TAG_structure_type ] [ksiginfo] [line 211, size 896, align 64, offset 0] [from ]
!156 = metadata !{metadata !157, metadata !163, metadata !214, metadata !215}
!157 = metadata !{i32 786445, metadata !135, metadata !155, metadata !"ksi_link", i32 212, i64 128, i64 64, i64 0, i32 0, metadata !158} ; [ DW_TAG_member ] [ksi_link] [line 212, size 128, align 64, offset 0] [from ]
!158 = metadata !{i32 786451, metadata !135, metadata !155, metadata !"", i32 212, i64 128, i64 64, i32 0, i32 0, null, metadata !159, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 212, size 128, align 64, offset 0] [from ]
!159 = metadata !{metadata !160, metadata !161}
!160 = metadata !{i32 786445, metadata !135, metadata !158, metadata !"tqe_next", i32 212, i64 64, i64 64, i64 0, i32 0, metadata !154} ; [ DW_TAG_member ] [tqe_next] [line 212, size 64, align 64, offset 0] [from ]
!161 = metadata !{i32 786445, metadata !135, metadata !158, metadata !"tqe_prev", i32 212, i64 64, i64 64, i64 64, i32 0, metadata !162} ; [ DW_TAG_member ] [tqe_prev] [line 212, size 64, align 64, offset 64] [from ]
!162 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !154} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!163 = metadata !{i32 786445, metadata !135, metadata !155, metadata !"ksi_info", i32 213, i64 640, i64 64, i64 128, i32 0, metadata !164} ; [ DW_TAG_member ] [ksi_info] [line 213, size 640, align 64, offset 128] [from siginfo_t]
!164 = metadata !{i32 786454, metadata !135, null, metadata !"siginfo_t", i32 230, i64 0, i64 0, i64 0, i32 0, metadata !165} ; [ DW_TAG_typedef ] [siginfo_t] [line 230, size 0, align 0, offset 0] [from __siginfo]
!165 = metadata !{i32 786451, metadata !166, null, metadata !"__siginfo", i32 196, i64 640, i64 64, i32 0, i32 0, null, metadata !167, i32 0, null, null} ; [ DW_TAG_structure_type ] [__siginfo] [line 196, size 640, align 64, offset 0] [from ]
!166 = metadata !{metadata !"/home/jra40/P4/tesla/sys/sys/signal.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!167 = metadata !{metadata !168, metadata !169, metadata !170, metadata !171, metadata !174, metadata !176, metadata !177, metadata !179, metadata !186}
!168 = metadata !{i32 786445, metadata !166, metadata !165, metadata !"si_signo", i32 197, i64 32, i64 32, i64 0, i32 0, metadata !93} ; [ DW_TAG_member ] [si_signo] [line 197, size 32, align 32, offset 0] [from int]
!169 = metadata !{i32 786445, metadata !166, metadata !165, metadata !"si_errno", i32 198, i64 32, i64 32, i64 32, i32 0, metadata !93} ; [ DW_TAG_member ] [si_errno] [line 198, size 32, align 32, offset 32] [from int]
!170 = metadata !{i32 786445, metadata !166, metadata !165, metadata !"si_code", i32 205, i64 32, i64 32, i64 64, i32 0, metadata !93} ; [ DW_TAG_member ] [si_code] [line 205, size 32, align 32, offset 64] [from int]
!171 = metadata !{i32 786445, metadata !166, metadata !165, metadata !"si_pid", i32 206, i64 32, i64 32, i64 96, i32 0, metadata !172} ; [ DW_TAG_member ] [si_pid] [line 206, size 32, align 32, offset 96] [from __pid_t]
!172 = metadata !{i32 786454, metadata !173, null, metadata !"__pid_t", i32 55, i64 0, i64 0, i64 0, i32 0, metadata !131} ; [ DW_TAG_typedef ] [__pid_t] [line 55, size 0, align 0, offset 0] [from __int32_t]
!173 = metadata !{metadata !"/home/jra40/P4/tesla/sys/bsm/audit.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!174 = metadata !{i32 786445, metadata !166, metadata !165, metadata !"si_uid", i32 207, i64 32, i64 32, i64 128, i32 0, metadata !175} ; [ DW_TAG_member ] [si_uid] [line 207, size 32, align 32, offset 128] [from __uid_t]
!175 = metadata !{i32 786454, metadata !146, null, metadata !"__uid_t", i32 64, i64 0, i64 0, i64 0, i32 0, metadata !145} ; [ DW_TAG_typedef ] [__uid_t] [line 64, size 0, align 0, offset 0] [from __uint32_t]
!176 = metadata !{i32 786445, metadata !166, metadata !165, metadata !"si_status", i32 208, i64 32, i64 32, i64 160, i32 0, metadata !93} ; [ DW_TAG_member ] [si_status] [line 208, size 32, align 32, offset 160] [from int]
!177 = metadata !{i32 786445, metadata !166, metadata !165, metadata !"si_addr", i32 209, i64 64, i64 64, i64 192, i32 0, metadata !178} ; [ DW_TAG_member ] [si_addr] [line 209, size 64, align 64, offset 192] [from ]
!178 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!179 = metadata !{i32 786445, metadata !166, metadata !165, metadata !"si_value", i32 210, i64 64, i64 64, i64 256, i32 0, metadata !180} ; [ DW_TAG_member ] [si_value] [line 210, size 64, align 64, offset 256] [from sigval]
!180 = metadata !{i32 786455, metadata !166, null, metadata !"sigval", i32 152, i64 64, i64 64, i64 0, i32 0, null, metadata !181, i32 0, i32 0, null} ; [ DW_TAG_union_type ] [sigval] [line 152, size 64, align 64, offset 0] [from ]
!181 = metadata !{metadata !182, metadata !183, metadata !184, metadata !185}
!182 = metadata !{i32 786445, metadata !166, metadata !180, metadata !"sival_int", i32 154, i64 32, i64 32, i64 0, i32 0, metadata !93} ; [ DW_TAG_member ] [sival_int] [line 154, size 32, align 32, offset 0] [from int]
!183 = metadata !{i32 786445, metadata !166, metadata !180, metadata !"sival_ptr", i32 155, i64 64, i64 64, i64 0, i32 0, metadata !178} ; [ DW_TAG_member ] [sival_ptr] [line 155, size 64, align 64, offset 0] [from ]
!184 = metadata !{i32 786445, metadata !166, metadata !180, metadata !"sigval_int", i32 157, i64 32, i64 32, i64 0, i32 0, metadata !93} ; [ DW_TAG_member ] [sigval_int] [line 157, size 32, align 32, offset 0] [from int]
!185 = metadata !{i32 786445, metadata !166, metadata !180, metadata !"sigval_ptr", i32 158, i64 64, i64 64, i64 0, i32 0, metadata !178} ; [ DW_TAG_member ] [sigval_ptr] [line 158, size 64, align 64, offset 0] [from ]
!186 = metadata !{i32 786445, metadata !166, metadata !165, metadata !"_reason", i32 229, i64 320, i64 64, i64 320, i32 0, metadata !187} ; [ DW_TAG_member ] [_reason] [line 229, size 320, align 64, offset 320] [from ]
!187 = metadata !{i32 786455, metadata !166, metadata !165, metadata !"", i32 211, i64 320, i64 64, i64 0, i32 0, null, metadata !188, i32 0, i32 0, null} ; [ DW_TAG_union_type ] [line 211, size 320, align 64, offset 0] [from ]
!188 = metadata !{metadata !189, metadata !193, metadata !198, metadata !202, metadata !206}
!189 = metadata !{i32 786445, metadata !166, metadata !187, metadata !"_fault", i32 214, i64 32, i64 32, i64 0, i32 0, metadata !190} ; [ DW_TAG_member ] [_fault] [line 214, size 32, align 32, offset 0] [from ]
!190 = metadata !{i32 786451, metadata !166, metadata !187, metadata !"", i32 212, i64 32, i64 32, i32 0, i32 0, null, metadata !191, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 212, size 32, align 32, offset 0] [from ]
!191 = metadata !{metadata !192}
!192 = metadata !{i32 786445, metadata !166, metadata !190, metadata !"_trapno", i32 213, i64 32, i64 32, i64 0, i32 0, metadata !93} ; [ DW_TAG_member ] [_trapno] [line 213, size 32, align 32, offset 0] [from int]
!193 = metadata !{i32 786445, metadata !166, metadata !187, metadata !"_timer", i32 218, i64 64, i64 32, i64 0, i32 0, metadata !194} ; [ DW_TAG_member ] [_timer] [line 218, size 64, align 32, offset 0] [from ]
!194 = metadata !{i32 786451, metadata !166, metadata !187, metadata !"", i32 215, i64 64, i64 32, i32 0, i32 0, null, metadata !195, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 215, size 64, align 32, offset 0] [from ]
!195 = metadata !{metadata !196, metadata !197}
!196 = metadata !{i32 786445, metadata !166, metadata !194, metadata !"_timerid", i32 216, i64 32, i64 32, i64 0, i32 0, metadata !93} ; [ DW_TAG_member ] [_timerid] [line 216, size 32, align 32, offset 0] [from int]
!197 = metadata !{i32 786445, metadata !166, metadata !194, metadata !"_overrun", i32 217, i64 32, i64 32, i64 32, i32 0, metadata !93} ; [ DW_TAG_member ] [_overrun] [line 217, size 32, align 32, offset 32] [from int]
!198 = metadata !{i32 786445, metadata !166, metadata !187, metadata !"_mesgq", i32 221, i64 32, i64 32, i64 0, i32 0, metadata !199} ; [ DW_TAG_member ] [_mesgq] [line 221, size 32, align 32, offset 0] [from ]
!199 = metadata !{i32 786451, metadata !166, metadata !187, metadata !"", i32 219, i64 32, i64 32, i32 0, i32 0, null, metadata !200, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 219, size 32, align 32, offset 0] [from ]
!200 = metadata !{metadata !201}
!201 = metadata !{i32 786445, metadata !166, metadata !199, metadata !"_mqd", i32 220, i64 32, i64 32, i64 0, i32 0, metadata !93} ; [ DW_TAG_member ] [_mqd] [line 220, size 32, align 32, offset 0] [from int]
!202 = metadata !{i32 786445, metadata !166, metadata !187, metadata !"_poll", i32 224, i64 64, i64 64, i64 0, i32 0, metadata !203} ; [ DW_TAG_member ] [_poll] [line 224, size 64, align 64, offset 0] [from ]
!203 = metadata !{i32 786451, metadata !166, metadata !187, metadata !"", i32 222, i64 64, i64 64, i32 0, i32 0, null, metadata !204, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 222, size 64, align 64, offset 0] [from ]
!204 = metadata !{metadata !205}
!205 = metadata !{i32 786445, metadata !166, metadata !203, metadata !"_band", i32 223, i64 64, i64 64, i64 0, i32 0, metadata !87} ; [ DW_TAG_member ] [_band] [line 223, size 64, align 64, offset 0] [from long int]
!206 = metadata !{i32 786445, metadata !166, metadata !187, metadata !"__spare__", i32 228, i64 320, i64 64, i64 0, i32 0, metadata !207} ; [ DW_TAG_member ] [__spare__] [line 228, size 320, align 64, offset 0] [from ]
!207 = metadata !{i32 786451, metadata !166, metadata !187, metadata !"", i32 225, i64 320, i64 64, i32 0, i32 0, null, metadata !208, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 225, size 320, align 64, offset 0] [from ]
!208 = metadata !{metadata !209, metadata !210}
!209 = metadata !{i32 786445, metadata !166, metadata !207, metadata !"__spare1__", i32 226, i64 64, i64 64, i64 0, i32 0, metadata !87} ; [ DW_TAG_member ] [__spare1__] [line 226, size 64, align 64, offset 0] [from long int]
!210 = metadata !{i32 786445, metadata !166, metadata !207, metadata !"__spare2__", i32 227, i64 224, i64 32, i64 64, i32 0, metadata !211} ; [ DW_TAG_member ] [__spare2__] [line 227, size 224, align 32, offset 64] [from ]
!211 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 224, i64 32, i32 0, i32 0, metadata !93, metadata !212, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 224, align 32, offset 0] [from int]
!212 = metadata !{metadata !213}
!213 = metadata !{i32 786465, i64 0, i64 7}       ; [ DW_TAG_subrange_type ] [0, 6]
!214 = metadata !{i32 786445, metadata !135, metadata !155, metadata !"ksi_flags", i32 214, i64 32, i64 32, i64 768, i32 0, metadata !93} ; [ DW_TAG_member ] [ksi_flags] [line 214, size 32, align 32, offset 768] [from int]
!215 = metadata !{i32 786445, metadata !135, metadata !155, metadata !"ksi_sigq", i32 215, i64 64, i64 64, i64 832, i32 0, metadata !216} ; [ DW_TAG_member ] [ksi_sigq] [line 215, size 64, align 64, offset 832] [from ]
!216 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !134} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from sigqueue]
!217 = metadata !{i32 786445, metadata !135, metadata !151, metadata !"tqh_last", i32 245, i64 64, i64 64, i64 64, i32 0, metadata !162} ; [ DW_TAG_member ] [tqh_last] [line 245, size 64, align 64, offset 64] [from ]
!218 = metadata !{i32 786445, metadata !135, metadata !134, metadata !"sq_proc", i32 246, i64 64, i64 64, i64 384, i32 0, metadata !11} ; [ DW_TAG_member ] [sq_proc] [line 246, size 64, align 64, offset 384] [from ]
!219 = metadata !{i32 786445, metadata !135, metadata !134, metadata !"sq_flags", i32 247, i64 32, i64 32, i64 448, i32 0, metadata !93} ; [ DW_TAG_member ] [sq_flags] [line 247, size 32, align 32, offset 448] [from int]
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
!249 = metadata !{metadata !"/home/jra40/P4/tesla/sys/sys/lock.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!250 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_intr_nesting_level", i32 245, i64 32, i64 32, i64 2432, i32 0, metadata !93} ; [ DW_TAG_member ] [td_intr_nesting_level] [line 245, size 32, align 32, offset 2432] [from int]
!251 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_pinned", i32 246, i64 32, i64 32, i64 2464, i32 0, metadata !93} ; [ DW_TAG_member ] [td_pinned] [line 246, size 32, align 32, offset 2464] [from int]
!252 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_ucred", i32 247, i64 64, i64 64, i64 2496, i32 0, metadata !253} ; [ DW_TAG_member ] [td_ucred] [line 247, size 64, align 64, offset 2496] [from ]
!253 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !254} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ucred]
!254 = metadata !{i32 786451, metadata !146, null, metadata !"ucred", i32 47, i64 1280, i64 64, i32 0, i32 0, null, metadata !255, i32 0, null, null} ; [ DW_TAG_structure_type ] [ucred] [line 47, size 1280, align 64, offset 0] [from ]
!255 = metadata !{metadata !256, metadata !257, metadata !259, metadata !260, metadata !261, metadata !262, metadata !265, metadata !266, metadata !269, metadata !270, metadata !386, metadata !389, metadata !390, metadata !394, metadata !397, metadata !425, metadata !427}
!256 = metadata !{i32 786445, metadata !146, metadata !254, metadata !"cr_ref", i32 48, i64 32, i64 32, i64 0, i32 0, metadata !36} ; [ DW_TAG_member ] [cr_ref] [line 48, size 32, align 32, offset 0] [from u_int]
!257 = metadata !{i32 786445, metadata !146, metadata !254, metadata !"cr_uid", i32 50, i64 32, i64 32, i64 32, i32 0, metadata !258} ; [ DW_TAG_member ] [cr_uid] [line 50, size 32, align 32, offset 32] [from uid_t]
!258 = metadata !{i32 786454, metadata !146, null, metadata !"uid_t", i32 228, i64 0, i64 0, i64 0, i32 0, metadata !175} ; [ DW_TAG_typedef ] [uid_t] [line 228, size 0, align 0, offset 0] [from __uid_t]
!259 = metadata !{i32 786445, metadata !146, metadata !254, metadata !"cr_ruid", i32 51, i64 32, i64 32, i64 64, i32 0, metadata !258} ; [ DW_TAG_member ] [cr_ruid] [line 51, size 32, align 32, offset 64] [from uid_t]
!260 = metadata !{i32 786445, metadata !146, metadata !254, metadata !"cr_svuid", i32 52, i64 32, i64 32, i64 96, i32 0, metadata !258} ; [ DW_TAG_member ] [cr_svuid] [line 52, size 32, align 32, offset 96] [from uid_t]
!261 = metadata !{i32 786445, metadata !146, metadata !254, metadata !"cr_ngroups", i32 53, i64 32, i64 32, i64 128, i32 0, metadata !93} ; [ DW_TAG_member ] [cr_ngroups] [line 53, size 32, align 32, offset 128] [from int]
!262 = metadata !{i32 786445, metadata !146, metadata !254, metadata !"cr_rgid", i32 54, i64 32, i64 32, i64 160, i32 0, metadata !263} ; [ DW_TAG_member ] [cr_rgid] [line 54, size 32, align 32, offset 160] [from gid_t]
!263 = metadata !{i32 786454, metadata !146, null, metadata !"gid_t", i32 125, i64 0, i64 0, i64 0, i32 0, metadata !264} ; [ DW_TAG_typedef ] [gid_t] [line 125, size 0, align 0, offset 0] [from __gid_t]
!264 = metadata !{i32 786454, metadata !146, null, metadata !"__gid_t", i32 45, i64 0, i64 0, i64 0, i32 0, metadata !145} ; [ DW_TAG_typedef ] [__gid_t] [line 45, size 0, align 0, offset 0] [from __uint32_t]
!265 = metadata !{i32 786445, metadata !146, metadata !254, metadata !"cr_svgid", i32 55, i64 32, i64 32, i64 192, i32 0, metadata !263} ; [ DW_TAG_member ] [cr_svgid] [line 55, size 32, align 32, offset 192] [from gid_t]
!266 = metadata !{i32 786445, metadata !146, metadata !254, metadata !"cr_uidinfo", i32 56, i64 64, i64 64, i64 256, i32 0, metadata !267} ; [ DW_TAG_member ] [cr_uidinfo] [line 56, size 64, align 64, offset 256] [from ]
!267 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !268} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from uidinfo]
!268 = metadata !{i32 786451, metadata !146, null, metadata !"uidinfo", i32 56, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [uidinfo] [line 56, size 0, align 0, offset 0] [fwd] [from ]
!269 = metadata !{i32 786445, metadata !146, metadata !254, metadata !"cr_ruidinfo", i32 57, i64 64, i64 64, i64 320, i32 0, metadata !267} ; [ DW_TAG_member ] [cr_ruidinfo] [line 57, size 64, align 64, offset 320] [from ]
!270 = metadata !{i32 786445, metadata !146, metadata !254, metadata !"cr_prison", i32 58, i64 64, i64 64, i64 384, i32 0, metadata !271} ; [ DW_TAG_member ] [cr_prison] [line 58, size 64, align 64, offset 384] [from ]
!271 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !272} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from prison]
!272 = metadata !{i32 786451, metadata !273, null, metadata !"prison", i32 153, i64 17152, i64 64, i32 0, i32 0, null, metadata !274, i32 0, null, null} ; [ DW_TAG_structure_type ] [prison] [line 153, size 17152, align 64, offset 0] [from ]
!273 = metadata !{metadata !"/home/jra40/P4/tesla/sys/sys/jail.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!274 = metadata !{metadata !275, metadata !281, metadata !282, metadata !283, metadata !284, metadata !285, metadata !289, metadata !294, metadata !295, metadata !296, metadata !315, metadata !329, metadata !330, metadata !333, metadata !336, metadata !337, metadata !338, metadata !341, metadata !344, metadata !362, metadata !366, metadata !367, metadata !368, metadata !369, metadata !370, metadata !371, metadata !372, metadata !374, metadata !375, metadata !376, metadata !380, metadata !381, metadata !382}
!275 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_list", i32 154, i64 128, i64 64, i64 0, i32 0, metadata !276} ; [ DW_TAG_member ] [pr_list] [line 154, size 128, align 64, offset 0] [from ]
!276 = metadata !{i32 786451, metadata !273, metadata !272, metadata !"", i32 154, i64 128, i64 64, i32 0, i32 0, null, metadata !277, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 154, size 128, align 64, offset 0] [from ]
!277 = metadata !{metadata !278, metadata !279}
!278 = metadata !{i32 786445, metadata !273, metadata !276, metadata !"tqe_next", i32 154, i64 64, i64 64, i64 0, i32 0, metadata !271} ; [ DW_TAG_member ] [tqe_next] [line 154, size 64, align 64, offset 0] [from ]
!279 = metadata !{i32 786445, metadata !273, metadata !276, metadata !"tqe_prev", i32 154, i64 64, i64 64, i64 64, i32 0, metadata !280} ; [ DW_TAG_member ] [tqe_prev] [line 154, size 64, align 64, offset 64] [from ]
!280 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !271} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!281 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_id", i32 155, i64 32, i64 32, i64 128, i32 0, metadata !93} ; [ DW_TAG_member ] [pr_id] [line 155, size 32, align 32, offset 128] [from int]
!282 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_ref", i32 156, i64 32, i64 32, i64 160, i32 0, metadata !93} ; [ DW_TAG_member ] [pr_ref] [line 156, size 32, align 32, offset 160] [from int]
!283 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_uref", i32 157, i64 32, i64 32, i64 192, i32 0, metadata !93} ; [ DW_TAG_member ] [pr_uref] [line 157, size 32, align 32, offset 192] [from int]
!284 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_flags", i32 158, i64 32, i64 32, i64 224, i32 0, metadata !38} ; [ DW_TAG_member ] [pr_flags] [line 158, size 32, align 32, offset 224] [from unsigned int]
!285 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_children", i32 159, i64 64, i64 64, i64 256, i32 0, metadata !286} ; [ DW_TAG_member ] [pr_children] [line 159, size 64, align 64, offset 256] [from ]
!286 = metadata !{i32 786451, metadata !273, metadata !272, metadata !"", i32 159, i64 64, i64 64, i32 0, i32 0, null, metadata !287, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 159, size 64, align 64, offset 0] [from ]
!287 = metadata !{metadata !288}
!288 = metadata !{i32 786445, metadata !273, metadata !286, metadata !"lh_first", i32 159, i64 64, i64 64, i64 0, i32 0, metadata !271} ; [ DW_TAG_member ] [lh_first] [line 159, size 64, align 64, offset 0] [from ]
!289 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_sibling", i32 160, i64 128, i64 64, i64 320, i32 0, metadata !290} ; [ DW_TAG_member ] [pr_sibling] [line 160, size 128, align 64, offset 320] [from ]
!290 = metadata !{i32 786451, metadata !273, metadata !272, metadata !"", i32 160, i64 128, i64 64, i32 0, i32 0, null, metadata !291, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 160, size 128, align 64, offset 0] [from ]
!291 = metadata !{metadata !292, metadata !293}
!292 = metadata !{i32 786445, metadata !273, metadata !290, metadata !"le_next", i32 160, i64 64, i64 64, i64 0, i32 0, metadata !271} ; [ DW_TAG_member ] [le_next] [line 160, size 64, align 64, offset 0] [from ]
!293 = metadata !{i32 786445, metadata !273, metadata !290, metadata !"le_prev", i32 160, i64 64, i64 64, i64 64, i32 0, metadata !280} ; [ DW_TAG_member ] [le_prev] [line 160, size 64, align 64, offset 64] [from ]
!294 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_parent", i32 161, i64 64, i64 64, i64 448, i32 0, metadata !271} ; [ DW_TAG_member ] [pr_parent] [line 161, size 64, align 64, offset 448] [from ]
!295 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_mtx", i32 162, i64 256, i64 64, i64 512, i32 0, metadata !24} ; [ DW_TAG_member ] [pr_mtx] [line 162, size 256, align 64, offset 512] [from mtx]
!296 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_task", i32 163, i64 256, i64 64, i64 768, i32 0, metadata !297} ; [ DW_TAG_member ] [pr_task] [line 163, size 256, align 64, offset 768] [from task]
!297 = metadata !{i32 786451, metadata !298, null, metadata !"task", i32 46, i64 256, i64 64, i32 0, i32 0, null, metadata !299, i32 0, null, null} ; [ DW_TAG_structure_type ] [task] [line 46, size 256, align 64, offset 0] [from ]
!298 = metadata !{metadata !"/home/jra40/P4/tesla/sys/sys/_task.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!299 = metadata !{metadata !300, metadata !305, metadata !308, metadata !309, metadata !314}
!300 = metadata !{i32 786445, metadata !298, metadata !297, metadata !"ta_link", i32 47, i64 64, i64 64, i64 0, i32 0, metadata !301} ; [ DW_TAG_member ] [ta_link] [line 47, size 64, align 64, offset 0] [from ]
!301 = metadata !{i32 786451, metadata !298, metadata !297, metadata !"", i32 47, i64 64, i64 64, i32 0, i32 0, null, metadata !302, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 47, size 64, align 64, offset 0] [from ]
!302 = metadata !{metadata !303}
!303 = metadata !{i32 786445, metadata !298, metadata !301, metadata !"stqe_next", i32 47, i64 64, i64 64, i64 0, i32 0, metadata !304} ; [ DW_TAG_member ] [stqe_next] [line 47, size 64, align 64, offset 0] [from ]
!304 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !297} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from task]
!305 = metadata !{i32 786445, metadata !298, metadata !297, metadata !"ta_pending", i32 48, i64 16, i64 16, i64 64, i32 0, metadata !306} ; [ DW_TAG_member ] [ta_pending] [line 48, size 16, align 16, offset 64] [from u_short]
!306 = metadata !{i32 786454, metadata !298, null, metadata !"u_short", i32 51, i64 0, i64 0, i64 0, i32 0, metadata !307} ; [ DW_TAG_typedef ] [u_short] [line 51, size 0, align 0, offset 0] [from unsigned short]
!307 = metadata !{i32 786468, null, null, metadata !"unsigned short", i32 0, i64 16, i64 16, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [unsigned short] [line 0, size 16, align 16, offset 0, enc DW_ATE_unsigned]
!308 = metadata !{i32 786445, metadata !298, metadata !297, metadata !"ta_priority", i32 49, i64 16, i64 16, i64 80, i32 0, metadata !306} ; [ DW_TAG_member ] [ta_priority] [line 49, size 16, align 16, offset 80] [from u_short]
!309 = metadata !{i32 786445, metadata !298, metadata !297, metadata !"ta_func", i32 50, i64 64, i64 64, i64 128, i32 0, metadata !310} ; [ DW_TAG_member ] [ta_func] [line 50, size 64, align 64, offset 128] [from ]
!310 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !311} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from task_fn_t]
!311 = metadata !{i32 786454, metadata !298, null, metadata !"task_fn_t", i32 44, i64 0, i64 0, i64 0, i32 0, metadata !312} ; [ DW_TAG_typedef ] [task_fn_t] [line 44, size 0, align 0, offset 0] [from ]
!312 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !313, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!313 = metadata !{null, metadata !178, metadata !93}
!314 = metadata !{i32 786445, metadata !298, metadata !297, metadata !"ta_context", i32 51, i64 64, i64 64, i64 192, i32 0, metadata !178} ; [ DW_TAG_member ] [ta_context] [line 51, size 64, align 64, offset 192] [from ]
!315 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_osd", i32 164, i64 256, i64 64, i64 1024, i32 0, metadata !316} ; [ DW_TAG_member ] [pr_osd] [line 164, size 256, align 64, offset 1024] [from osd]
!316 = metadata !{i32 786451, metadata !317, null, metadata !"osd", i32 39, i64 256, i64 64, i32 0, i32 0, null, metadata !318, i32 0, null, null} ; [ DW_TAG_structure_type ] [osd] [line 39, size 256, align 64, offset 0] [from ]
!317 = metadata !{metadata !"/home/jra40/P4/tesla/sys/sys/osd.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!318 = metadata !{metadata !319, metadata !320, metadata !322}
!319 = metadata !{i32 786445, metadata !317, metadata !316, metadata !"osd_nslots", i32 40, i64 32, i64 32, i64 0, i32 0, metadata !36} ; [ DW_TAG_member ] [osd_nslots] [line 40, size 32, align 32, offset 0] [from u_int]
!320 = metadata !{i32 786445, metadata !317, metadata !316, metadata !"osd_slots", i32 41, i64 64, i64 64, i64 64, i32 0, metadata !321} ; [ DW_TAG_member ] [osd_slots] [line 41, size 64, align 64, offset 64] [from ]
!321 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !178} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!322 = metadata !{i32 786445, metadata !317, metadata !316, metadata !"osd_next", i32 42, i64 128, i64 64, i64 128, i32 0, metadata !323} ; [ DW_TAG_member ] [osd_next] [line 42, size 128, align 64, offset 128] [from ]
!323 = metadata !{i32 786451, metadata !317, metadata !316, metadata !"", i32 42, i64 128, i64 64, i32 0, i32 0, null, metadata !324, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 42, size 128, align 64, offset 0] [from ]
!324 = metadata !{metadata !325, metadata !327}
!325 = metadata !{i32 786445, metadata !317, metadata !323, metadata !"le_next", i32 42, i64 64, i64 64, i64 0, i32 0, metadata !326} ; [ DW_TAG_member ] [le_next] [line 42, size 64, align 64, offset 0] [from ]
!326 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !316} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from osd]
!327 = metadata !{i32 786445, metadata !317, metadata !323, metadata !"le_prev", i32 42, i64 64, i64 64, i64 64, i32 0, metadata !328} ; [ DW_TAG_member ] [le_prev] [line 42, size 64, align 64, offset 64] [from ]
!328 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !326} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!329 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_cpuset", i32 165, i64 64, i64 64, i64 1280, i32 0, metadata !77} ; [ DW_TAG_member ] [pr_cpuset] [line 165, size 64, align 64, offset 1280] [from ]
!330 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_vnet", i32 166, i64 64, i64 64, i64 1344, i32 0, metadata !331} ; [ DW_TAG_member ] [pr_vnet] [line 166, size 64, align 64, offset 1344] [from ]
!331 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !332} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from vnet]
!332 = metadata !{i32 786451, metadata !273, null, metadata !"vnet", i32 166, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [vnet] [line 166, size 0, align 0, offset 0] [fwd] [from ]
!333 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_root", i32 167, i64 64, i64 64, i64 1408, i32 0, metadata !334} ; [ DW_TAG_member ] [pr_root] [line 167, size 64, align 64, offset 1408] [from ]
!334 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !335} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from vnode]
!335 = metadata !{i32 786451, metadata !273, null, metadata !"vnode", i32 167, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [vnode] [line 167, size 0, align 0, offset 0] [fwd] [from ]
!336 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_ip4s", i32 168, i64 32, i64 32, i64 1472, i32 0, metadata !93} ; [ DW_TAG_member ] [pr_ip4s] [line 168, size 32, align 32, offset 1472] [from int]
!337 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_ip6s", i32 169, i64 32, i64 32, i64 1504, i32 0, metadata !93} ; [ DW_TAG_member ] [pr_ip6s] [line 169, size 32, align 32, offset 1504] [from int]
!338 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_ip4", i32 170, i64 64, i64 64, i64 1536, i32 0, metadata !339} ; [ DW_TAG_member ] [pr_ip4] [line 170, size 64, align 64, offset 1536] [from ]
!339 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !340} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from in_addr]
!340 = metadata !{i32 786451, metadata !273, null, metadata !"in_addr", i32 49, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [in_addr] [line 49, size 0, align 0, offset 0] [fwd] [from ]
!341 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_ip6", i32 171, i64 64, i64 64, i64 1600, i32 0, metadata !342} ; [ DW_TAG_member ] [pr_ip6] [line 171, size 64, align 64, offset 1600] [from ]
!342 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !343} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from in6_addr]
!343 = metadata !{i32 786451, metadata !273, null, metadata !"in6_addr", i32 50, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [in6_addr] [line 50, size 0, align 0, offset 0] [fwd] [from ]
!344 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_prison_racct", i32 172, i64 64, i64 64, i64 1664, i32 0, metadata !345} ; [ DW_TAG_member ] [pr_prison_racct] [line 172, size 64, align 64, offset 1664] [from ]
!345 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !346} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from prison_racct]
!346 = metadata !{i32 786451, metadata !273, null, metadata !"prison_racct", i32 189, i64 2304, i64 64, i32 0, i32 0, null, metadata !347, i32 0, null, null} ; [ DW_TAG_structure_type ] [prison_racct] [line 189, size 2304, align 64, offset 0] [from ]
!347 = metadata !{metadata !348, metadata !354, metadata !358, metadata !359}
!348 = metadata !{i32 786445, metadata !273, metadata !346, metadata !"prr_next", i32 190, i64 128, i64 64, i64 0, i32 0, metadata !349} ; [ DW_TAG_member ] [prr_next] [line 190, size 128, align 64, offset 0] [from ]
!349 = metadata !{i32 786451, metadata !273, metadata !346, metadata !"", i32 190, i64 128, i64 64, i32 0, i32 0, null, metadata !350, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 190, size 128, align 64, offset 0] [from ]
!350 = metadata !{metadata !351, metadata !352}
!351 = metadata !{i32 786445, metadata !273, metadata !349, metadata !"le_next", i32 190, i64 64, i64 64, i64 0, i32 0, metadata !345} ; [ DW_TAG_member ] [le_next] [line 190, size 64, align 64, offset 0] [from ]
!352 = metadata !{i32 786445, metadata !273, metadata !349, metadata !"le_prev", i32 190, i64 64, i64 64, i64 64, i32 0, metadata !353} ; [ DW_TAG_member ] [le_prev] [line 190, size 64, align 64, offset 64] [from ]
!353 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !345} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!354 = metadata !{i32 786445, metadata !273, metadata !346, metadata !"prr_name", i32 191, i64 2048, i64 8, i64 128, i32 0, metadata !355} ; [ DW_TAG_member ] [prr_name] [line 191, size 2048, align 8, offset 128] [from ]
!355 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 2048, i64 8, i32 0, i32 0, metadata !34, metadata !356, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 2048, align 8, offset 0] [from char]
!356 = metadata !{metadata !357}
!357 = metadata !{i32 786465, i64 0, i64 256}     ; [ DW_TAG_subrange_type ] [0, 255]
!358 = metadata !{i32 786445, metadata !273, metadata !346, metadata !"prr_refcount", i32 192, i64 32, i64 32, i64 2176, i32 0, metadata !36} ; [ DW_TAG_member ] [prr_refcount] [line 192, size 32, align 32, offset 2176] [from u_int]
!359 = metadata !{i32 786445, metadata !273, metadata !346, metadata !"prr_racct", i32 193, i64 64, i64 64, i64 2240, i32 0, metadata !360} ; [ DW_TAG_member ] [prr_racct] [line 193, size 64, align 64, offset 2240] [from ]
!360 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !361} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from racct]
!361 = metadata !{i32 786451, metadata !273, null, metadata !"racct", i32 138, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [racct] [line 138, size 0, align 0, offset 0] [fwd] [from ]
!362 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_sparep", i32 173, i64 192, i64 64, i64 1728, i32 0, metadata !363} ; [ DW_TAG_member ] [pr_sparep] [line 173, size 192, align 64, offset 1728] [from ]
!363 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 192, i64 64, i32 0, i32 0, metadata !178, metadata !364, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 192, align 64, offset 0] [from ]
!364 = metadata !{metadata !365}
!365 = metadata !{i32 786465, i64 0, i64 3}       ; [ DW_TAG_subrange_type ] [0, 2]
!366 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_childcount", i32 174, i64 32, i64 32, i64 1920, i32 0, metadata !93} ; [ DW_TAG_member ] [pr_childcount] [line 174, size 32, align 32, offset 1920] [from int]
!367 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_childmax", i32 175, i64 32, i64 32, i64 1952, i32 0, metadata !93} ; [ DW_TAG_member ] [pr_childmax] [line 175, size 32, align 32, offset 1952] [from int]
!368 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_allow", i32 176, i64 32, i64 32, i64 1984, i32 0, metadata !38} ; [ DW_TAG_member ] [pr_allow] [line 176, size 32, align 32, offset 1984] [from unsigned int]
!369 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_securelevel", i32 177, i64 32, i64 32, i64 2016, i32 0, metadata !93} ; [ DW_TAG_member ] [pr_securelevel] [line 177, size 32, align 32, offset 2016] [from int]
!370 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_enforce_statfs", i32 178, i64 32, i64 32, i64 2048, i32 0, metadata !93} ; [ DW_TAG_member ] [pr_enforce_statfs] [line 178, size 32, align 32, offset 2048] [from int]
!371 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_devfs_rsnum", i32 179, i64 32, i64 32, i64 2080, i32 0, metadata !93} ; [ DW_TAG_member ] [pr_devfs_rsnum] [line 179, size 32, align 32, offset 2080] [from int]
!372 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_spare", i32 180, i64 128, i64 32, i64 2112, i32 0, metadata !373} ; [ DW_TAG_member ] [pr_spare] [line 180, size 128, align 32, offset 2112] [from ]
!373 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 128, i64 32, i32 0, i32 0, metadata !93, metadata !147, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 128, align 32, offset 0] [from int]
!374 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_hostid", i32 181, i64 64, i64 64, i64 2240, i32 0, metadata !48} ; [ DW_TAG_member ] [pr_hostid] [line 181, size 64, align 64, offset 2240] [from long unsigned int]
!375 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_name", i32 182, i64 2048, i64 8, i64 2304, i32 0, metadata !355} ; [ DW_TAG_member ] [pr_name] [line 182, size 2048, align 8, offset 2304] [from ]
!376 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_path", i32 183, i64 8192, i64 8, i64 4352, i32 0, metadata !377} ; [ DW_TAG_member ] [pr_path] [line 183, size 8192, align 8, offset 4352] [from ]
!377 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 8192, i64 8, i32 0, i32 0, metadata !34, metadata !378, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 8192, align 8, offset 0] [from char]
!378 = metadata !{metadata !379}
!379 = metadata !{i32 786465, i64 0, i64 1024}    ; [ DW_TAG_subrange_type ] [0, 1023]
!380 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_hostname", i32 184, i64 2048, i64 8, i64 12544, i32 0, metadata !355} ; [ DW_TAG_member ] [pr_hostname] [line 184, size 2048, align 8, offset 12544] [from ]
!381 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_domainname", i32 185, i64 2048, i64 8, i64 14592, i32 0, metadata !355} ; [ DW_TAG_member ] [pr_domainname] [line 185, size 2048, align 8, offset 14592] [from ]
!382 = metadata !{i32 786445, metadata !273, metadata !272, metadata !"pr_hostuuid", i32 186, i64 512, i64 8, i64 16640, i32 0, metadata !383} ; [ DW_TAG_member ] [pr_hostuuid] [line 186, size 512, align 8, offset 16640] [from ]
!383 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 512, i64 8, i32 0, i32 0, metadata !34, metadata !384, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 512, align 8, offset 0] [from char]
!384 = metadata !{metadata !385}
!385 = metadata !{i32 786465, i64 0, i64 64}      ; [ DW_TAG_subrange_type ] [0, 63]
!386 = metadata !{i32 786445, metadata !146, metadata !254, metadata !"cr_loginclass", i32 59, i64 64, i64 64, i64 448, i32 0, metadata !387} ; [ DW_TAG_member ] [cr_loginclass] [line 59, size 64, align 64, offset 448] [from ]
!387 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !388} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from loginclass]
!388 = metadata !{i32 786451, metadata !146, null, metadata !"loginclass", i32 38, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [loginclass] [line 38, size 0, align 0, offset 0] [fwd] [from ]
!389 = metadata !{i32 786445, metadata !146, metadata !254, metadata !"cr_flags", i32 60, i64 32, i64 32, i64 512, i32 0, metadata !36} ; [ DW_TAG_member ] [cr_flags] [line 60, size 32, align 32, offset 512] [from u_int]
!390 = metadata !{i32 786445, metadata !146, metadata !254, metadata !"cr_pspare2", i32 61, i64 128, i64 64, i64 576, i32 0, metadata !391} ; [ DW_TAG_member ] [cr_pspare2] [line 61, size 128, align 64, offset 576] [from ]
!391 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 128, i64 64, i32 0, i32 0, metadata !178, metadata !392, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 128, align 64, offset 0] [from ]
!392 = metadata !{metadata !393}
!393 = metadata !{i32 786465, i64 0, i64 2}       ; [ DW_TAG_subrange_type ] [0, 1]
!394 = metadata !{i32 786445, metadata !146, metadata !254, metadata !"cr_label", i32 63, i64 64, i64 64, i64 704, i32 0, metadata !395} ; [ DW_TAG_member ] [cr_label] [line 63, size 64, align 64, offset 704] [from ]
!395 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !396} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from label]
!396 = metadata !{i32 786451, metadata !146, null, metadata !"label", i32 63, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [label] [line 63, size 0, align 0, offset 0] [fwd] [from ]
!397 = metadata !{i32 786445, metadata !146, metadata !254, metadata !"cr_audit", i32 64, i64 384, i64 64, i64 768, i32 0, metadata !398} ; [ DW_TAG_member ] [cr_audit] [line 64, size 384, align 64, offset 768] [from auditinfo_addr]
!398 = metadata !{i32 786451, metadata !173, null, metadata !"auditinfo_addr", i32 205, i64 384, i64 64, i32 0, i32 0, null, metadata !399, i32 0, null, null} ; [ DW_TAG_structure_type ] [auditinfo_addr] [line 205, size 384, align 64, offset 0] [from ]
!399 = metadata !{metadata !400, metadata !402, metadata !408, metadata !419, metadata !422}
!400 = metadata !{i32 786445, metadata !173, metadata !398, metadata !"ai_auid", i32 206, i64 32, i64 32, i64 0, i32 0, metadata !401} ; [ DW_TAG_member ] [ai_auid] [line 206, size 32, align 32, offset 0] [from au_id_t]
!401 = metadata !{i32 786454, metadata !173, null, metadata !"au_id_t", i32 171, i64 0, i64 0, i64 0, i32 0, metadata !258} ; [ DW_TAG_typedef ] [au_id_t] [line 171, size 0, align 0, offset 0] [from uid_t]
!402 = metadata !{i32 786445, metadata !173, metadata !398, metadata !"ai_mask", i32 207, i64 64, i64 32, i64 32, i32 0, metadata !403} ; [ DW_TAG_member ] [ai_mask] [line 207, size 64, align 32, offset 32] [from au_mask_t]
!403 = metadata !{i32 786454, metadata !173, null, metadata !"au_mask_t", i32 195, i64 0, i64 0, i64 0, i32 0, metadata !404} ; [ DW_TAG_typedef ] [au_mask_t] [line 195, size 0, align 0, offset 0] [from au_mask]
!404 = metadata !{i32 786451, metadata !173, null, metadata !"au_mask", i32 191, i64 64, i64 32, i32 0, i32 0, null, metadata !405, i32 0, null, null} ; [ DW_TAG_structure_type ] [au_mask] [line 191, size 64, align 32, offset 0] [from ]
!405 = metadata !{metadata !406, metadata !407}
!406 = metadata !{i32 786445, metadata !173, metadata !404, metadata !"am_success", i32 192, i64 32, i64 32, i64 0, i32 0, metadata !38} ; [ DW_TAG_member ] [am_success] [line 192, size 32, align 32, offset 0] [from unsigned int]
!407 = metadata !{i32 786445, metadata !173, metadata !404, metadata !"am_failure", i32 193, i64 32, i64 32, i64 32, i32 0, metadata !38} ; [ DW_TAG_member ] [am_failure] [line 193, size 32, align 32, offset 32] [from unsigned int]
!408 = metadata !{i32 786445, metadata !173, metadata !398, metadata !"ai_termid", i32 208, i64 192, i64 32, i64 96, i32 0, metadata !409} ; [ DW_TAG_member ] [ai_termid] [line 208, size 192, align 32, offset 96] [from au_tid_addr_t]
!409 = metadata !{i32 786454, metadata !173, null, metadata !"au_tid_addr_t", i32 189, i64 0, i64 0, i64 0, i32 0, metadata !410} ; [ DW_TAG_typedef ] [au_tid_addr_t] [line 189, size 0, align 0, offset 0] [from au_tid_addr]
!410 = metadata !{i32 786451, metadata !173, null, metadata !"au_tid_addr", i32 184, i64 192, i64 32, i32 0, i32 0, null, metadata !411, i32 0, null, null} ; [ DW_TAG_structure_type ] [au_tid_addr] [line 184, size 192, align 32, offset 0] [from ]
!411 = metadata !{metadata !412, metadata !415, metadata !417}
!412 = metadata !{i32 786445, metadata !173, metadata !410, metadata !"at_port", i32 185, i64 32, i64 32, i64 0, i32 0, metadata !413} ; [ DW_TAG_member ] [at_port] [line 185, size 32, align 32, offset 0] [from dev_t]
!413 = metadata !{i32 786454, metadata !173, null, metadata !"dev_t", i32 107, i64 0, i64 0, i64 0, i32 0, metadata !414} ; [ DW_TAG_typedef ] [dev_t] [line 107, size 0, align 0, offset 0] [from __dev_t]
!414 = metadata !{i32 786454, metadata !173, null, metadata !"__dev_t", i32 103, i64 0, i64 0, i64 0, i32 0, metadata !145} ; [ DW_TAG_typedef ] [__dev_t] [line 103, size 0, align 0, offset 0] [from __uint32_t]
!415 = metadata !{i32 786445, metadata !173, metadata !410, metadata !"at_type", i32 186, i64 32, i64 32, i64 32, i32 0, metadata !416} ; [ DW_TAG_member ] [at_type] [line 186, size 32, align 32, offset 32] [from u_int32_t]
!416 = metadata !{i32 786454, metadata !173, null, metadata !"u_int32_t", i32 67, i64 0, i64 0, i64 0, i32 0, metadata !145} ; [ DW_TAG_typedef ] [u_int32_t] [line 67, size 0, align 0, offset 0] [from __uint32_t]
!417 = metadata !{i32 786445, metadata !173, metadata !410, metadata !"at_addr", i32 187, i64 128, i64 32, i64 64, i32 0, metadata !418} ; [ DW_TAG_member ] [at_addr] [line 187, size 128, align 32, offset 64] [from ]
!418 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 128, i64 32, i32 0, i32 0, metadata !416, metadata !147, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 128, align 32, offset 0] [from u_int32_t]
!419 = metadata !{i32 786445, metadata !173, metadata !398, metadata !"ai_asid", i32 209, i64 32, i64 32, i64 288, i32 0, metadata !420} ; [ DW_TAG_member ] [ai_asid] [line 209, size 32, align 32, offset 288] [from au_asid_t]
!420 = metadata !{i32 786454, metadata !173, null, metadata !"au_asid_t", i32 172, i64 0, i64 0, i64 0, i32 0, metadata !421} ; [ DW_TAG_typedef ] [au_asid_t] [line 172, size 0, align 0, offset 0] [from pid_t]
!421 = metadata !{i32 786454, metadata !173, null, metadata !"pid_t", i32 180, i64 0, i64 0, i64 0, i32 0, metadata !172} ; [ DW_TAG_typedef ] [pid_t] [line 180, size 0, align 0, offset 0] [from __pid_t]
!422 = metadata !{i32 786445, metadata !173, metadata !398, metadata !"ai_flags", i32 210, i64 64, i64 64, i64 320, i32 0, metadata !423} ; [ DW_TAG_member ] [ai_flags] [line 210, size 64, align 64, offset 320] [from au_asflgs_t]
!423 = metadata !{i32 786454, metadata !173, null, metadata !"au_asflgs_t", i32 176, i64 0, i64 0, i64 0, i32 0, metadata !424} ; [ DW_TAG_typedef ] [au_asflgs_t] [line 176, size 0, align 0, offset 0] [from u_int64_t]
!424 = metadata !{i32 786454, metadata !173, null, metadata !"u_int64_t", i32 68, i64 0, i64 0, i64 0, i32 0, metadata !47} ; [ DW_TAG_typedef ] [u_int64_t] [line 68, size 0, align 0, offset 0] [from __uint64_t]
!425 = metadata !{i32 786445, metadata !146, metadata !254, metadata !"cr_groups", i32 65, i64 64, i64 64, i64 1152, i32 0, metadata !426} ; [ DW_TAG_member ] [cr_groups] [line 65, size 64, align 64, offset 1152] [from ]
!426 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !263} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from gid_t]
!427 = metadata !{i32 786445, metadata !146, metadata !254, metadata !"cr_agroups", i32 66, i64 32, i64 32, i64 1216, i32 0, metadata !93} ; [ DW_TAG_member ] [cr_agroups] [line 66, size 32, align 32, offset 1216] [from int]
!428 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_estcpu", i32 248, i64 32, i64 32, i64 2560, i32 0, metadata !36} ; [ DW_TAG_member ] [td_estcpu] [line 248, size 32, align 32, offset 2560] [from u_int]
!429 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_slptick", i32 249, i64 32, i64 32, i64 2592, i32 0, metadata !93} ; [ DW_TAG_member ] [td_slptick] [line 249, size 32, align 32, offset 2592] [from int]
!430 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_blktick", i32 250, i64 32, i64 32, i64 2624, i32 0, metadata !93} ; [ DW_TAG_member ] [td_blktick] [line 250, size 32, align 32, offset 2624] [from int]
!431 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_swvoltick", i32 251, i64 32, i64 32, i64 2656, i32 0, metadata !93} ; [ DW_TAG_member ] [td_swvoltick] [line 251, size 32, align 32, offset 2656] [from int]
!432 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_cow", i32 252, i64 32, i64 32, i64 2688, i32 0, metadata !36} ; [ DW_TAG_member ] [td_cow] [line 252, size 32, align 32, offset 2688] [from u_int]
!433 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_ru", i32 253, i64 1152, i64 64, i64 2752, i32 0, metadata !434} ; [ DW_TAG_member ] [td_ru] [line 253, size 1152, align 64, offset 2752] [from rusage]
!434 = metadata !{i32 786451, metadata !435, null, metadata !"rusage", i32 61, i64 1152, i64 64, i32 0, i32 0, null, metadata !436, i32 0, null, null} ; [ DW_TAG_structure_type ] [rusage] [line 61, size 1152, align 64, offset 0] [from ]
!435 = metadata !{metadata !"/home/jra40/P4/tesla/sys/sys/resource.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!436 = metadata !{metadata !437, metadata !449, metadata !450, metadata !451, metadata !452, metadata !453, metadata !454, metadata !455, metadata !456, metadata !457, metadata !458, metadata !459, metadata !460, metadata !461, metadata !462, metadata !463}
!437 = metadata !{i32 786445, metadata !435, metadata !434, metadata !"ru_utime", i32 62, i64 128, i64 64, i64 0, i32 0, metadata !438} ; [ DW_TAG_member ] [ru_utime] [line 62, size 128, align 64, offset 0] [from timeval]
!438 = metadata !{i32 786451, metadata !439, null, metadata !"timeval", i32 47, i64 128, i64 64, i32 0, i32 0, null, metadata !440, i32 0, null, null} ; [ DW_TAG_structure_type ] [timeval] [line 47, size 128, align 64, offset 0] [from ]
!439 = metadata !{metadata !"/home/jra40/P4/tesla/sys/sys/_timeval.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!440 = metadata !{metadata !441, metadata !446}
!441 = metadata !{i32 786445, metadata !439, metadata !438, metadata !"tv_sec", i32 48, i64 64, i64 64, i64 0, i32 0, metadata !442} ; [ DW_TAG_member ] [tv_sec] [line 48, size 64, align 64, offset 0] [from time_t]
!442 = metadata !{i32 786454, metadata !439, null, metadata !"time_t", i32 211, i64 0, i64 0, i64 0, i32 0, metadata !443} ; [ DW_TAG_typedef ] [time_t] [line 211, size 0, align 0, offset 0] [from __time_t]
!443 = metadata !{i32 786454, metadata !439, null, metadata !"__time_t", i32 106, i64 0, i64 0, i64 0, i32 0, metadata !444} ; [ DW_TAG_typedef ] [__time_t] [line 106, size 0, align 0, offset 0] [from __int64_t]
!444 = metadata !{i32 786454, metadata !445, null, metadata !"__int64_t", i32 58, i64 0, i64 0, i64 0, i32 0, metadata !87} ; [ DW_TAG_typedef ] [__int64_t] [line 58, size 0, align 0, offset 0] [from long int]
!445 = metadata !{metadata !"/home/jra40/P4/tesla/sys/sys/_callout.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!446 = metadata !{i32 786445, metadata !439, metadata !438, metadata !"tv_usec", i32 49, i64 64, i64 64, i64 64, i32 0, metadata !447} ; [ DW_TAG_member ] [tv_usec] [line 49, size 64, align 64, offset 64] [from suseconds_t]
!447 = metadata !{i32 786454, metadata !439, null, metadata !"suseconds_t", i32 206, i64 0, i64 0, i64 0, i32 0, metadata !448} ; [ DW_TAG_typedef ] [suseconds_t] [line 206, size 0, align 0, offset 0] [from __suseconds_t]
!448 = metadata !{i32 786454, metadata !439, null, metadata !"__suseconds_t", i32 61, i64 0, i64 0, i64 0, i32 0, metadata !87} ; [ DW_TAG_typedef ] [__suseconds_t] [line 61, size 0, align 0, offset 0] [from long int]
!449 = metadata !{i32 786445, metadata !435, metadata !434, metadata !"ru_stime", i32 63, i64 128, i64 64, i64 128, i32 0, metadata !438} ; [ DW_TAG_member ] [ru_stime] [line 63, size 128, align 64, offset 128] [from timeval]
!450 = metadata !{i32 786445, metadata !435, metadata !434, metadata !"ru_maxrss", i32 64, i64 64, i64 64, i64 256, i32 0, metadata !87} ; [ DW_TAG_member ] [ru_maxrss] [line 64, size 64, align 64, offset 256] [from long int]
!451 = metadata !{i32 786445, metadata !435, metadata !434, metadata !"ru_ixrss", i32 66, i64 64, i64 64, i64 320, i32 0, metadata !87} ; [ DW_TAG_member ] [ru_ixrss] [line 66, size 64, align 64, offset 320] [from long int]
!452 = metadata !{i32 786445, metadata !435, metadata !434, metadata !"ru_idrss", i32 67, i64 64, i64 64, i64 384, i32 0, metadata !87} ; [ DW_TAG_member ] [ru_idrss] [line 67, size 64, align 64, offset 384] [from long int]
!453 = metadata !{i32 786445, metadata !435, metadata !434, metadata !"ru_isrss", i32 68, i64 64, i64 64, i64 448, i32 0, metadata !87} ; [ DW_TAG_member ] [ru_isrss] [line 68, size 64, align 64, offset 448] [from long int]
!454 = metadata !{i32 786445, metadata !435, metadata !434, metadata !"ru_minflt", i32 69, i64 64, i64 64, i64 512, i32 0, metadata !87} ; [ DW_TAG_member ] [ru_minflt] [line 69, size 64, align 64, offset 512] [from long int]
!455 = metadata !{i32 786445, metadata !435, metadata !434, metadata !"ru_majflt", i32 70, i64 64, i64 64, i64 576, i32 0, metadata !87} ; [ DW_TAG_member ] [ru_majflt] [line 70, size 64, align 64, offset 576] [from long int]
!456 = metadata !{i32 786445, metadata !435, metadata !434, metadata !"ru_nswap", i32 71, i64 64, i64 64, i64 640, i32 0, metadata !87} ; [ DW_TAG_member ] [ru_nswap] [line 71, size 64, align 64, offset 640] [from long int]
!457 = metadata !{i32 786445, metadata !435, metadata !434, metadata !"ru_inblock", i32 72, i64 64, i64 64, i64 704, i32 0, metadata !87} ; [ DW_TAG_member ] [ru_inblock] [line 72, size 64, align 64, offset 704] [from long int]
!458 = metadata !{i32 786445, metadata !435, metadata !434, metadata !"ru_oublock", i32 73, i64 64, i64 64, i64 768, i32 0, metadata !87} ; [ DW_TAG_member ] [ru_oublock] [line 73, size 64, align 64, offset 768] [from long int]
!459 = metadata !{i32 786445, metadata !435, metadata !434, metadata !"ru_msgsnd", i32 74, i64 64, i64 64, i64 832, i32 0, metadata !87} ; [ DW_TAG_member ] [ru_msgsnd] [line 74, size 64, align 64, offset 832] [from long int]
!460 = metadata !{i32 786445, metadata !435, metadata !434, metadata !"ru_msgrcv", i32 75, i64 64, i64 64, i64 896, i32 0, metadata !87} ; [ DW_TAG_member ] [ru_msgrcv] [line 75, size 64, align 64, offset 896] [from long int]
!461 = metadata !{i32 786445, metadata !435, metadata !434, metadata !"ru_nsignals", i32 76, i64 64, i64 64, i64 960, i32 0, metadata !87} ; [ DW_TAG_member ] [ru_nsignals] [line 76, size 64, align 64, offset 960] [from long int]
!462 = metadata !{i32 786445, metadata !435, metadata !434, metadata !"ru_nvcsw", i32 77, i64 64, i64 64, i64 1024, i32 0, metadata !87} ; [ DW_TAG_member ] [ru_nvcsw] [line 77, size 64, align 64, offset 1024] [from long int]
!463 = metadata !{i32 786445, metadata !435, metadata !434, metadata !"ru_nivcsw", i32 78, i64 64, i64 64, i64 1088, i32 0, metadata !87} ; [ DW_TAG_member ] [ru_nivcsw] [line 78, size 64, align 64, offset 1088] [from long int]
!464 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_rux", i32 254, i64 448, i64 64, i64 3904, i32 0, metadata !465} ; [ DW_TAG_member ] [td_rux] [line 254, size 448, align 64, offset 3904] [from rusage_ext]
!465 = metadata !{i32 786451, metadata !4, null, metadata !"rusage_ext", i32 190, i64 448, i64 64, i32 0, i32 0, null, metadata !466, i32 0, null, null} ; [ DW_TAG_structure_type ] [rusage_ext] [line 190, size 448, align 64, offset 0] [from ]
!466 = metadata !{metadata !467, metadata !469, metadata !470, metadata !471, metadata !472, metadata !473, metadata !474}
!467 = metadata !{i32 786445, metadata !4, metadata !465, metadata !"rux_runtime", i32 191, i64 64, i64 64, i64 0, i32 0, metadata !468} ; [ DW_TAG_member ] [rux_runtime] [line 191, size 64, align 64, offset 0] [from uint64_t]
!468 = metadata !{i32 786454, metadata !4, null, metadata !"uint64_t", i32 69, i64 0, i64 0, i64 0, i32 0, metadata !47} ; [ DW_TAG_typedef ] [uint64_t] [line 69, size 0, align 0, offset 0] [from __uint64_t]
!469 = metadata !{i32 786445, metadata !4, metadata !465, metadata !"rux_uticks", i32 192, i64 64, i64 64, i64 64, i32 0, metadata !468} ; [ DW_TAG_member ] [rux_uticks] [line 192, size 64, align 64, offset 64] [from uint64_t]
!470 = metadata !{i32 786445, metadata !4, metadata !465, metadata !"rux_sticks", i32 193, i64 64, i64 64, i64 128, i32 0, metadata !468} ; [ DW_TAG_member ] [rux_sticks] [line 193, size 64, align 64, offset 128] [from uint64_t]
!471 = metadata !{i32 786445, metadata !4, metadata !465, metadata !"rux_iticks", i32 194, i64 64, i64 64, i64 192, i32 0, metadata !468} ; [ DW_TAG_member ] [rux_iticks] [line 194, size 64, align 64, offset 192] [from uint64_t]
!472 = metadata !{i32 786445, metadata !4, metadata !465, metadata !"rux_uu", i32 195, i64 64, i64 64, i64 256, i32 0, metadata !468} ; [ DW_TAG_member ] [rux_uu] [line 195, size 64, align 64, offset 256] [from uint64_t]
!473 = metadata !{i32 786445, metadata !4, metadata !465, metadata !"rux_su", i32 196, i64 64, i64 64, i64 320, i32 0, metadata !468} ; [ DW_TAG_member ] [rux_su] [line 196, size 64, align 64, offset 320] [from uint64_t]
!474 = metadata !{i32 786445, metadata !4, metadata !465, metadata !"rux_tu", i32 197, i64 64, i64 64, i64 384, i32 0, metadata !468} ; [ DW_TAG_member ] [rux_tu] [line 197, size 64, align 64, offset 384] [from uint64_t]
!475 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_incruntime", i32 255, i64 64, i64 64, i64 4352, i32 0, metadata !468} ; [ DW_TAG_member ] [td_incruntime] [line 255, size 64, align 64, offset 4352] [from uint64_t]
!476 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_runtime", i32 256, i64 64, i64 64, i64 4416, i32 0, metadata !468} ; [ DW_TAG_member ] [td_runtime] [line 256, size 64, align 64, offset 4416] [from uint64_t]
!477 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_pticks", i32 257, i64 32, i64 32, i64 4480, i32 0, metadata !36} ; [ DW_TAG_member ] [td_pticks] [line 257, size 32, align 32, offset 4480] [from u_int]
!478 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_sticks", i32 258, i64 32, i64 32, i64 4512, i32 0, metadata !36} ; [ DW_TAG_member ] [td_sticks] [line 258, size 32, align 32, offset 4512] [from u_int]
!479 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_iticks", i32 259, i64 32, i64 32, i64 4544, i32 0, metadata !36} ; [ DW_TAG_member ] [td_iticks] [line 259, size 32, align 32, offset 4544] [from u_int]
!480 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_uticks", i32 260, i64 32, i64 32, i64 4576, i32 0, metadata !36} ; [ DW_TAG_member ] [td_uticks] [line 260, size 32, align 32, offset 4576] [from u_int]
!481 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_intrval", i32 261, i64 32, i64 32, i64 4608, i32 0, metadata !93} ; [ DW_TAG_member ] [td_intrval] [line 261, size 32, align 32, offset 4608] [from int]
!482 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_oldsigmask", i32 262, i64 128, i64 32, i64 4640, i32 0, metadata !138} ; [ DW_TAG_member ] [td_oldsigmask] [line 262, size 128, align 32, offset 4640] [from sigset_t]
!483 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_generation", i32 263, i64 32, i64 32, i64 4768, i32 0, metadata !91} ; [ DW_TAG_member ] [td_generation] [line 263, size 32, align 32, offset 4768] [from ]
!484 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_sigstk", i32 264, i64 192, i64 64, i64 4800, i32 0, metadata !485} ; [ DW_TAG_member ] [td_sigstk] [line 264, size 192, align 64, offset 4800] [from stack_t]
!485 = metadata !{i32 786454, metadata !4, null, metadata !"stack_t", i32 368, i64 0, i64 0, i64 0, i32 0, metadata !486} ; [ DW_TAG_typedef ] [stack_t] [line 368, size 0, align 0, offset 0] [from sigaltstack]
!486 = metadata !{i32 786451, metadata !166, null, metadata !"sigaltstack", i32 361, i64 192, i64 64, i32 0, i32 0, null, metadata !487, i32 0, null, null} ; [ DW_TAG_structure_type ] [sigaltstack] [line 361, size 192, align 64, offset 0] [from ]
!487 = metadata !{metadata !488, metadata !490, metadata !492}
!488 = metadata !{i32 786445, metadata !166, metadata !486, metadata !"ss_sp", i32 365, i64 64, i64 64, i64 0, i32 0, metadata !489} ; [ DW_TAG_member ] [ss_sp] [line 365, size 64, align 64, offset 0] [from ]
!489 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !34} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from char]
!490 = metadata !{i32 786445, metadata !166, metadata !486, metadata !"ss_size", i32 366, i64 64, i64 64, i64 64, i32 0, metadata !491} ; [ DW_TAG_member ] [ss_size] [line 366, size 64, align 64, offset 64] [from __size_t]
!491 = metadata !{i32 786454, metadata !1, null, metadata !"__size_t", i32 104, i64 0, i64 0, i64 0, i32 0, metadata !47} ; [ DW_TAG_typedef ] [__size_t] [line 104, size 0, align 0, offset 0] [from __uint64_t]
!492 = metadata !{i32 786445, metadata !166, metadata !486, metadata !"ss_flags", i32 367, i64 32, i64 32, i64 128, i32 0, metadata !93} ; [ DW_TAG_member ] [ss_flags] [line 367, size 32, align 32, offset 128] [from int]
!493 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_xsig", i32 265, i64 32, i64 32, i64 4992, i32 0, metadata !93} ; [ DW_TAG_member ] [td_xsig] [line 265, size 32, align 32, offset 4992] [from int]
!494 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_profil_addr", i32 266, i64 64, i64 64, i64 5056, i32 0, metadata !495} ; [ DW_TAG_member ] [td_profil_addr] [line 266, size 64, align 64, offset 5056] [from u_long]
!495 = metadata !{i32 786454, metadata !4, null, metadata !"u_long", i32 53, i64 0, i64 0, i64 0, i32 0, metadata !48} ; [ DW_TAG_typedef ] [u_long] [line 53, size 0, align 0, offset 0] [from long unsigned int]
!496 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_profil_ticks", i32 267, i64 32, i64 32, i64 5120, i32 0, metadata !36} ; [ DW_TAG_member ] [td_profil_ticks] [line 267, size 32, align 32, offset 5120] [from u_int]
!497 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_name", i32 268, i64 160, i64 8, i64 5152, i32 0, metadata !498} ; [ DW_TAG_member ] [td_name] [line 268, size 160, align 8, offset 5152] [from ]
!498 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 160, i64 8, i32 0, i32 0, metadata !34, metadata !499, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 160, align 8, offset 0] [from char]
!499 = metadata !{metadata !500}
!500 = metadata !{i32 786465, i64 0, i64 20}      ; [ DW_TAG_subrange_type ] [0, 19]
!501 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_fpop", i32 269, i64 64, i64 64, i64 5312, i32 0, metadata !502} ; [ DW_TAG_member ] [td_fpop] [line 269, size 64, align 64, offset 5312] [from ]
!502 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !503} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from file]
!503 = metadata !{i32 786451, metadata !504, null, metadata !"file", i32 211, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [file] [line 211, size 0, align 0, offset 0] [fwd] [from ]
!504 = metadata !{metadata !"/home/jra40/P4/tesla/sys/sys/event.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!505 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_dbgflags", i32 270, i64 32, i64 32, i64 5376, i32 0, metadata !93} ; [ DW_TAG_member ] [td_dbgflags] [line 270, size 32, align 32, offset 5376] [from int]
!506 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_dbgksi", i32 271, i64 896, i64 64, i64 5440, i32 0, metadata !155} ; [ DW_TAG_member ] [td_dbgksi] [line 271, size 896, align 64, offset 5440] [from ksiginfo]
!507 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_ng_outbound", i32 272, i64 32, i64 32, i64 6336, i32 0, metadata !93} ; [ DW_TAG_member ] [td_ng_outbound] [line 272, size 32, align 32, offset 6336] [from int]
!508 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_osd", i32 273, i64 256, i64 64, i64 6400, i32 0, metadata !316} ; [ DW_TAG_member ] [td_osd] [line 273, size 256, align 64, offset 6400] [from osd]
!509 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_map_def_user", i32 274, i64 64, i64 64, i64 6656, i32 0, metadata !510} ; [ DW_TAG_member ] [td_map_def_user] [line 274, size 64, align 64, offset 6656] [from ]
!510 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !511} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from vm_map_entry]
!511 = metadata !{i32 786451, metadata !4, null, metadata !"vm_map_entry", i32 274, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [vm_map_entry] [line 274, size 0, align 0, offset 0] [fwd] [from ]
!512 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_dbg_forked", i32 275, i64 32, i64 32, i64 6720, i32 0, metadata !421} ; [ DW_TAG_member ] [td_dbg_forked] [line 275, size 32, align 32, offset 6720] [from pid_t]
!513 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_vp_reserv", i32 276, i64 32, i64 32, i64 6752, i32 0, metadata !36} ; [ DW_TAG_member ] [td_vp_reserv] [line 276, size 32, align 32, offset 6752] [from u_int]
!514 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_no_sleeping", i32 277, i64 32, i64 32, i64 6784, i32 0, metadata !93} ; [ DW_TAG_member ] [td_no_sleeping] [line 277, size 32, align 32, offset 6784] [from int]
!515 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_dom_rr_idx", i32 278, i64 32, i64 32, i64 6816, i32 0, metadata !93} ; [ DW_TAG_member ] [td_dom_rr_idx] [line 278, size 32, align 32, offset 6816] [from int]
!516 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_sigmask", i32 283, i64 128, i64 32, i64 6848, i32 0, metadata !138} ; [ DW_TAG_member ] [td_sigmask] [line 283, size 128, align 32, offset 6848] [from sigset_t]
!517 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_rqindex", i32 284, i64 8, i64 8, i64 6976, i32 0, metadata !221} ; [ DW_TAG_member ] [td_rqindex] [line 284, size 8, align 8, offset 6976] [from u_char]
!518 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_base_pri", i32 285, i64 8, i64 8, i64 6984, i32 0, metadata !221} ; [ DW_TAG_member ] [td_base_pri] [line 285, size 8, align 8, offset 6984] [from u_char]
!519 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_priority", i32 286, i64 8, i64 8, i64 6992, i32 0, metadata !221} ; [ DW_TAG_member ] [td_priority] [line 286, size 8, align 8, offset 6992] [from u_char]
!520 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_pri_class", i32 287, i64 8, i64 8, i64 7000, i32 0, metadata !221} ; [ DW_TAG_member ] [td_pri_class] [line 287, size 8, align 8, offset 7000] [from u_char]
!521 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_user_pri", i32 288, i64 8, i64 8, i64 7008, i32 0, metadata !221} ; [ DW_TAG_member ] [td_user_pri] [line 288, size 8, align 8, offset 7008] [from u_char]
!522 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_base_user_pri", i32 289, i64 8, i64 8, i64 7016, i32 0, metadata !221} ; [ DW_TAG_member ] [td_base_user_pri] [line 289, size 8, align 8, offset 7016] [from u_char]
!523 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_pcb", i32 296, i64 64, i64 64, i64 7040, i32 0, metadata !524} ; [ DW_TAG_member ] [td_pcb] [line 296, size 64, align 64, offset 7040] [from ]
!524 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !525} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from pcb]
!525 = metadata !{i32 786451, metadata !526, null, metadata !"pcb", i32 246, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [pcb] [line 246, size 0, align 0, offset 0] [fwd] [from ]
!526 = metadata !{metadata !"./machine/pcpu.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!527 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_state", i32 303, i64 32, i64 32, i64 7104, i32 0, metadata !528} ; [ DW_TAG_member ] [td_state] [line 303, size 32, align 32, offset 7104] [from ]
!528 = metadata !{i32 786436, metadata !4, metadata !19, metadata !"", i32 297, i64 32, i64 32, i32 0, i32 0, null, metadata !529, i32 0, i32 0} ; [ DW_TAG_enumeration_type ] [line 297, size 32, align 32, offset 0] [from ]
!529 = metadata !{metadata !530, metadata !531, metadata !532, metadata !533, metadata !534}
!530 = metadata !{i32 786472, metadata !"TDS_INACTIVE", i64 0} ; [ DW_TAG_enumerator ] [TDS_INACTIVE :: 0]
!531 = metadata !{i32 786472, metadata !"TDS_INHIBITED", i64 1} ; [ DW_TAG_enumerator ] [TDS_INHIBITED :: 1]
!532 = metadata !{i32 786472, metadata !"TDS_CAN_RUN", i64 2} ; [ DW_TAG_enumerator ] [TDS_CAN_RUN :: 2]
!533 = metadata !{i32 786472, metadata !"TDS_RUNQ", i64 3} ; [ DW_TAG_enumerator ] [TDS_RUNQ :: 3]
!534 = metadata !{i32 786472, metadata !"TDS_RUNNING", i64 4} ; [ DW_TAG_enumerator ] [TDS_RUNNING :: 4]
!535 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_retval", i32 304, i64 128, i64 64, i64 7168, i32 0, metadata !536} ; [ DW_TAG_member ] [td_retval] [line 304, size 128, align 64, offset 7168] [from ]
!536 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 128, i64 64, i32 0, i32 0, metadata !537, metadata !392, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 128, align 64, offset 0] [from register_t]
!537 = metadata !{i32 786454, metadata !4, null, metadata !"register_t", i32 184, i64 0, i64 0, i64 0, i32 0, metadata !538} ; [ DW_TAG_typedef ] [register_t] [line 184, size 0, align 0, offset 0] [from __register_t]
!538 = metadata !{i32 786454, metadata !4, null, metadata !"__register_t", i32 102, i64 0, i64 0, i64 0, i32 0, metadata !444} ; [ DW_TAG_typedef ] [__register_t] [line 102, size 0, align 0, offset 0] [from __int64_t]
!539 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_slpcallout", i32 305, i64 512, i64 64, i64 7296, i32 0, metadata !540} ; [ DW_TAG_member ] [td_slpcallout] [line 305, size 512, align 64, offset 7296] [from callout]
!540 = metadata !{i32 786451, metadata !445, null, metadata !"callout", i32 49, i64 512, i64 64, i32 0, i32 0, null, metadata !541, i32 0, null, null} ; [ DW_TAG_structure_type ] [callout] [line 49, size 512, align 64, offset 0] [from ]
!541 = metadata !{metadata !542, metadata !561, metadata !563, metadata !564, metadata !565, metadata !569, metadata !571, metadata !572}
!542 = metadata !{i32 786445, metadata !445, metadata !540, metadata !"c_links", i32 54, i64 128, i64 64, i64 0, i32 0, metadata !543} ; [ DW_TAG_member ] [c_links] [line 54, size 128, align 64, offset 0] [from ]
!543 = metadata !{i32 786455, metadata !445, metadata !540, metadata !"", i32 50, i64 128, i64 64, i64 0, i32 0, null, metadata !544, i32 0, i32 0, null} ; [ DW_TAG_union_type ] [line 50, size 128, align 64, offset 0] [from ]
!544 = metadata !{metadata !545, metadata !552, metadata !556}
!545 = metadata !{i32 786445, metadata !445, metadata !543, metadata !"le", i32 51, i64 128, i64 64, i64 0, i32 0, metadata !546} ; [ DW_TAG_member ] [le] [line 51, size 128, align 64, offset 0] [from ]
!546 = metadata !{i32 786451, metadata !445, metadata !543, metadata !"", i32 51, i64 128, i64 64, i32 0, i32 0, null, metadata !547, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 51, size 128, align 64, offset 0] [from ]
!547 = metadata !{metadata !548, metadata !550}
!548 = metadata !{i32 786445, metadata !445, metadata !546, metadata !"le_next", i32 51, i64 64, i64 64, i64 0, i32 0, metadata !549} ; [ DW_TAG_member ] [le_next] [line 51, size 64, align 64, offset 0] [from ]
!549 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !540} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from callout]
!550 = metadata !{i32 786445, metadata !445, metadata !546, metadata !"le_prev", i32 51, i64 64, i64 64, i64 64, i32 0, metadata !551} ; [ DW_TAG_member ] [le_prev] [line 51, size 64, align 64, offset 64] [from ]
!551 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !549} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!552 = metadata !{i32 786445, metadata !445, metadata !543, metadata !"sle", i32 52, i64 64, i64 64, i64 0, i32 0, metadata !553} ; [ DW_TAG_member ] [sle] [line 52, size 64, align 64, offset 0] [from ]
!553 = metadata !{i32 786451, metadata !445, metadata !543, metadata !"", i32 52, i64 64, i64 64, i32 0, i32 0, null, metadata !554, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 52, size 64, align 64, offset 0] [from ]
!554 = metadata !{metadata !555}
!555 = metadata !{i32 786445, metadata !445, metadata !553, metadata !"sle_next", i32 52, i64 64, i64 64, i64 0, i32 0, metadata !549} ; [ DW_TAG_member ] [sle_next] [line 52, size 64, align 64, offset 0] [from ]
!556 = metadata !{i32 786445, metadata !445, metadata !543, metadata !"tqe", i32 53, i64 128, i64 64, i64 0, i32 0, metadata !557} ; [ DW_TAG_member ] [tqe] [line 53, size 128, align 64, offset 0] [from ]
!557 = metadata !{i32 786451, metadata !445, metadata !543, metadata !"", i32 53, i64 128, i64 64, i32 0, i32 0, null, metadata !558, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 53, size 128, align 64, offset 0] [from ]
!558 = metadata !{metadata !559, metadata !560}
!559 = metadata !{i32 786445, metadata !445, metadata !557, metadata !"tqe_next", i32 53, i64 64, i64 64, i64 0, i32 0, metadata !549} ; [ DW_TAG_member ] [tqe_next] [line 53, size 64, align 64, offset 0] [from ]
!560 = metadata !{i32 786445, metadata !445, metadata !557, metadata !"tqe_prev", i32 53, i64 64, i64 64, i64 64, i32 0, metadata !551} ; [ DW_TAG_member ] [tqe_prev] [line 53, size 64, align 64, offset 64] [from ]
!561 = metadata !{i32 786445, metadata !445, metadata !540, metadata !"c_time", i32 55, i64 64, i64 64, i64 128, i32 0, metadata !562} ; [ DW_TAG_member ] [c_time] [line 55, size 64, align 64, offset 128] [from sbintime_t]
!562 = metadata !{i32 786454, metadata !445, null, metadata !"sbintime_t", i32 191, i64 0, i64 0, i64 0, i32 0, metadata !444} ; [ DW_TAG_typedef ] [sbintime_t] [line 191, size 0, align 0, offset 0] [from __int64_t]
!563 = metadata !{i32 786445, metadata !445, metadata !540, metadata !"c_precision", i32 56, i64 64, i64 64, i64 192, i32 0, metadata !562} ; [ DW_TAG_member ] [c_precision] [line 56, size 64, align 64, offset 192] [from sbintime_t]
!564 = metadata !{i32 786445, metadata !445, metadata !540, metadata !"c_arg", i32 57, i64 64, i64 64, i64 256, i32 0, metadata !178} ; [ DW_TAG_member ] [c_arg] [line 57, size 64, align 64, offset 256] [from ]
!565 = metadata !{i32 786445, metadata !445, metadata !540, metadata !"c_func", i32 58, i64 64, i64 64, i64 320, i32 0, metadata !566} ; [ DW_TAG_member ] [c_func] [line 58, size 64, align 64, offset 320] [from ]
!566 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !567} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!567 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !568, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!568 = metadata !{null, metadata !178}
!569 = metadata !{i32 786445, metadata !445, metadata !540, metadata !"c_lock", i32 59, i64 64, i64 64, i64 384, i32 0, metadata !570} ; [ DW_TAG_member ] [c_lock] [line 59, size 64, align 64, offset 384] [from ]
!570 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !28} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from lock_object]
!571 = metadata !{i32 786445, metadata !445, metadata !540, metadata !"c_flags", i32 60, i64 32, i64 32, i64 448, i32 0, metadata !93} ; [ DW_TAG_member ] [c_flags] [line 60, size 32, align 32, offset 448] [from int]
!572 = metadata !{i32 786445, metadata !445, metadata !540, metadata !"c_cpu", i32 61, i64 32, i64 32, i64 480, i32 0, metadata !573} ; [ DW_TAG_member ] [c_cpu] [line 61, size 32, align 32, offset 480] [from ]
!573 = metadata !{i32 786485, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !93} ; [ DW_TAG_volatile_type ] [line 0, size 0, align 0, offset 0] [from int]
!574 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_frame", i32 306, i64 64, i64 64, i64 7808, i32 0, metadata !575} ; [ DW_TAG_member ] [td_frame] [line 306, size 64, align 64, offset 7808] [from ]
!575 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !576} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from trapframe]
!576 = metadata !{i32 786451, metadata !577, null, metadata !"trapframe", i32 111, i64 1536, i64 64, i32 0, i32 0, null, metadata !578, i32 0, null, null} ; [ DW_TAG_structure_type ] [trapframe] [line 111, size 1536, align 64, offset 0] [from ]
!577 = metadata !{metadata !"./x86/frame.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!578 = metadata !{metadata !579, metadata !580, metadata !581, metadata !582, metadata !583, metadata !584, metadata !585, metadata !586, metadata !587, metadata !588, metadata !589, metadata !590, metadata !591, metadata !592, metadata !593, metadata !594, metadata !596, metadata !599, metadata !600, metadata !601, metadata !602, metadata !603, metadata !604, metadata !605, metadata !606, metadata !607, metadata !608, metadata !609}
!579 = metadata !{i32 786445, metadata !577, metadata !576, metadata !"tf_rdi", i32 112, i64 64, i64 64, i64 0, i32 0, metadata !537} ; [ DW_TAG_member ] [tf_rdi] [line 112, size 64, align 64, offset 0] [from register_t]
!580 = metadata !{i32 786445, metadata !577, metadata !576, metadata !"tf_rsi", i32 113, i64 64, i64 64, i64 64, i32 0, metadata !537} ; [ DW_TAG_member ] [tf_rsi] [line 113, size 64, align 64, offset 64] [from register_t]
!581 = metadata !{i32 786445, metadata !577, metadata !576, metadata !"tf_rdx", i32 114, i64 64, i64 64, i64 128, i32 0, metadata !537} ; [ DW_TAG_member ] [tf_rdx] [line 114, size 64, align 64, offset 128] [from register_t]
!582 = metadata !{i32 786445, metadata !577, metadata !576, metadata !"tf_rcx", i32 115, i64 64, i64 64, i64 192, i32 0, metadata !537} ; [ DW_TAG_member ] [tf_rcx] [line 115, size 64, align 64, offset 192] [from register_t]
!583 = metadata !{i32 786445, metadata !577, metadata !576, metadata !"tf_r8", i32 116, i64 64, i64 64, i64 256, i32 0, metadata !537} ; [ DW_TAG_member ] [tf_r8] [line 116, size 64, align 64, offset 256] [from register_t]
!584 = metadata !{i32 786445, metadata !577, metadata !576, metadata !"tf_r9", i32 117, i64 64, i64 64, i64 320, i32 0, metadata !537} ; [ DW_TAG_member ] [tf_r9] [line 117, size 64, align 64, offset 320] [from register_t]
!585 = metadata !{i32 786445, metadata !577, metadata !576, metadata !"tf_rax", i32 118, i64 64, i64 64, i64 384, i32 0, metadata !537} ; [ DW_TAG_member ] [tf_rax] [line 118, size 64, align 64, offset 384] [from register_t]
!586 = metadata !{i32 786445, metadata !577, metadata !576, metadata !"tf_rbx", i32 119, i64 64, i64 64, i64 448, i32 0, metadata !537} ; [ DW_TAG_member ] [tf_rbx] [line 119, size 64, align 64, offset 448] [from register_t]
!587 = metadata !{i32 786445, metadata !577, metadata !576, metadata !"tf_rbp", i32 120, i64 64, i64 64, i64 512, i32 0, metadata !537} ; [ DW_TAG_member ] [tf_rbp] [line 120, size 64, align 64, offset 512] [from register_t]
!588 = metadata !{i32 786445, metadata !577, metadata !576, metadata !"tf_r10", i32 121, i64 64, i64 64, i64 576, i32 0, metadata !537} ; [ DW_TAG_member ] [tf_r10] [line 121, size 64, align 64, offset 576] [from register_t]
!589 = metadata !{i32 786445, metadata !577, metadata !576, metadata !"tf_r11", i32 122, i64 64, i64 64, i64 640, i32 0, metadata !537} ; [ DW_TAG_member ] [tf_r11] [line 122, size 64, align 64, offset 640] [from register_t]
!590 = metadata !{i32 786445, metadata !577, metadata !576, metadata !"tf_r12", i32 123, i64 64, i64 64, i64 704, i32 0, metadata !537} ; [ DW_TAG_member ] [tf_r12] [line 123, size 64, align 64, offset 704] [from register_t]
!591 = metadata !{i32 786445, metadata !577, metadata !576, metadata !"tf_r13", i32 124, i64 64, i64 64, i64 768, i32 0, metadata !537} ; [ DW_TAG_member ] [tf_r13] [line 124, size 64, align 64, offset 768] [from register_t]
!592 = metadata !{i32 786445, metadata !577, metadata !576, metadata !"tf_r14", i32 125, i64 64, i64 64, i64 832, i32 0, metadata !537} ; [ DW_TAG_member ] [tf_r14] [line 125, size 64, align 64, offset 832] [from register_t]
!593 = metadata !{i32 786445, metadata !577, metadata !576, metadata !"tf_r15", i32 126, i64 64, i64 64, i64 896, i32 0, metadata !537} ; [ DW_TAG_member ] [tf_r15] [line 126, size 64, align 64, offset 896] [from register_t]
!594 = metadata !{i32 786445, metadata !577, metadata !576, metadata !"tf_trapno", i32 127, i64 32, i64 32, i64 960, i32 0, metadata !595} ; [ DW_TAG_member ] [tf_trapno] [line 127, size 32, align 32, offset 960] [from uint32_t]
!595 = metadata !{i32 786454, metadata !577, null, metadata !"uint32_t", i32 64, i64 0, i64 0, i64 0, i32 0, metadata !145} ; [ DW_TAG_typedef ] [uint32_t] [line 64, size 0, align 0, offset 0] [from __uint32_t]
!596 = metadata !{i32 786445, metadata !577, metadata !576, metadata !"tf_fs", i32 128, i64 16, i64 16, i64 992, i32 0, metadata !597} ; [ DW_TAG_member ] [tf_fs] [line 128, size 16, align 16, offset 992] [from uint16_t]
!597 = metadata !{i32 786454, metadata !577, null, metadata !"uint16_t", i32 59, i64 0, i64 0, i64 0, i32 0, metadata !598} ; [ DW_TAG_typedef ] [uint16_t] [line 59, size 0, align 0, offset 0] [from __uint16_t]
!598 = metadata !{i32 786454, metadata !577, null, metadata !"__uint16_t", i32 54, i64 0, i64 0, i64 0, i32 0, metadata !307} ; [ DW_TAG_typedef ] [__uint16_t] [line 54, size 0, align 0, offset 0] [from unsigned short]
!599 = metadata !{i32 786445, metadata !577, metadata !576, metadata !"tf_gs", i32 129, i64 16, i64 16, i64 1008, i32 0, metadata !597} ; [ DW_TAG_member ] [tf_gs] [line 129, size 16, align 16, offset 1008] [from uint16_t]
!600 = metadata !{i32 786445, metadata !577, metadata !576, metadata !"tf_addr", i32 130, i64 64, i64 64, i64 1024, i32 0, metadata !537} ; [ DW_TAG_member ] [tf_addr] [line 130, size 64, align 64, offset 1024] [from register_t]
!601 = metadata !{i32 786445, metadata !577, metadata !576, metadata !"tf_flags", i32 131, i64 32, i64 32, i64 1088, i32 0, metadata !595} ; [ DW_TAG_member ] [tf_flags] [line 131, size 32, align 32, offset 1088] [from uint32_t]
!602 = metadata !{i32 786445, metadata !577, metadata !576, metadata !"tf_es", i32 132, i64 16, i64 16, i64 1120, i32 0, metadata !597} ; [ DW_TAG_member ] [tf_es] [line 132, size 16, align 16, offset 1120] [from uint16_t]
!603 = metadata !{i32 786445, metadata !577, metadata !576, metadata !"tf_ds", i32 133, i64 16, i64 16, i64 1136, i32 0, metadata !597} ; [ DW_TAG_member ] [tf_ds] [line 133, size 16, align 16, offset 1136] [from uint16_t]
!604 = metadata !{i32 786445, metadata !577, metadata !576, metadata !"tf_err", i32 135, i64 64, i64 64, i64 1152, i32 0, metadata !537} ; [ DW_TAG_member ] [tf_err] [line 135, size 64, align 64, offset 1152] [from register_t]
!605 = metadata !{i32 786445, metadata !577, metadata !576, metadata !"tf_rip", i32 136, i64 64, i64 64, i64 1216, i32 0, metadata !537} ; [ DW_TAG_member ] [tf_rip] [line 136, size 64, align 64, offset 1216] [from register_t]
!606 = metadata !{i32 786445, metadata !577, metadata !576, metadata !"tf_cs", i32 137, i64 64, i64 64, i64 1280, i32 0, metadata !537} ; [ DW_TAG_member ] [tf_cs] [line 137, size 64, align 64, offset 1280] [from register_t]
!607 = metadata !{i32 786445, metadata !577, metadata !576, metadata !"tf_rflags", i32 138, i64 64, i64 64, i64 1344, i32 0, metadata !537} ; [ DW_TAG_member ] [tf_rflags] [line 138, size 64, align 64, offset 1344] [from register_t]
!608 = metadata !{i32 786445, metadata !577, metadata !576, metadata !"tf_rsp", i32 139, i64 64, i64 64, i64 1408, i32 0, metadata !537} ; [ DW_TAG_member ] [tf_rsp] [line 139, size 64, align 64, offset 1408] [from register_t]
!609 = metadata !{i32 786445, metadata !577, metadata !576, metadata !"tf_ss", i32 140, i64 64, i64 64, i64 1472, i32 0, metadata !537} ; [ DW_TAG_member ] [tf_ss] [line 140, size 64, align 64, offset 1472] [from register_t]
!610 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_kstack_obj", i32 307, i64 64, i64 64, i64 7872, i32 0, metadata !611} ; [ DW_TAG_member ] [td_kstack_obj] [line 307, size 64, align 64, offset 7872] [from ]
!611 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !612} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from vm_object]
!612 = metadata !{i32 786451, metadata !4, null, metadata !"vm_object", i32 307, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [vm_object] [line 307, size 0, align 0, offset 0] [fwd] [from ]
!613 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_kstack", i32 308, i64 64, i64 64, i64 7936, i32 0, metadata !614} ; [ DW_TAG_member ] [td_kstack] [line 308, size 64, align 64, offset 7936] [from vm_offset_t]
!614 = metadata !{i32 786454, metadata !4, null, metadata !"vm_offset_t", i32 237, i64 0, i64 0, i64 0, i32 0, metadata !615} ; [ DW_TAG_typedef ] [vm_offset_t] [line 237, size 0, align 0, offset 0] [from __vm_offset_t]
!615 = metadata !{i32 786454, metadata !4, null, metadata !"__vm_offset_t", i32 130, i64 0, i64 0, i64 0, i32 0, metadata !47} ; [ DW_TAG_typedef ] [__vm_offset_t] [line 130, size 0, align 0, offset 0] [from __uint64_t]
!616 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_kstack_pages", i32 309, i64 32, i64 32, i64 8000, i32 0, metadata !93} ; [ DW_TAG_member ] [td_kstack_pages] [line 309, size 32, align 32, offset 8000] [from int]
!617 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_critnest", i32 310, i64 32, i64 32, i64 8032, i32 0, metadata !91} ; [ DW_TAG_member ] [td_critnest] [line 310, size 32, align 32, offset 8032] [from ]
!618 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_md", i32 311, i64 192, i64 64, i64 8064, i32 0, metadata !619} ; [ DW_TAG_member ] [td_md] [line 311, size 192, align 64, offset 8064] [from mdthread]
!619 = metadata !{i32 786451, metadata !620, null, metadata !"mdthread", i32 46, i64 192, i64 64, i32 0, i32 0, null, metadata !621, i32 0, null, null} ; [ DW_TAG_structure_type ] [mdthread] [line 46, size 192, align 64, offset 0] [from ]
!620 = metadata !{metadata !"./machine/proc.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!621 = metadata !{metadata !622, metadata !623, metadata !624}
!622 = metadata !{i32 786445, metadata !620, metadata !619, metadata !"md_spinlock_count", i32 47, i64 32, i64 32, i64 0, i32 0, metadata !93} ; [ DW_TAG_member ] [md_spinlock_count] [line 47, size 32, align 32, offset 0] [from int]
!623 = metadata !{i32 786445, metadata !620, metadata !619, metadata !"md_saved_flags", i32 48, i64 64, i64 64, i64 64, i32 0, metadata !537} ; [ DW_TAG_member ] [md_saved_flags] [line 48, size 64, align 64, offset 64] [from register_t]
!624 = metadata !{i32 786445, metadata !620, metadata !619, metadata !"md_spurflt_addr", i32 49, i64 64, i64 64, i64 128, i32 0, metadata !537} ; [ DW_TAG_member ] [md_spurflt_addr] [line 49, size 64, align 64, offset 128] [from register_t]
!625 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_sched", i32 312, i64 64, i64 64, i64 8256, i32 0, metadata !626} ; [ DW_TAG_member ] [td_sched] [line 312, size 64, align 64, offset 8256] [from ]
!626 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !627} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from td_sched]
!627 = metadata !{i32 786451, metadata !4, null, metadata !"td_sched", i32 173, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [td_sched] [line 173, size 0, align 0, offset 0] [fwd] [from ]
!628 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_ar", i32 313, i64 64, i64 64, i64 8320, i32 0, metadata !629} ; [ DW_TAG_member ] [td_ar] [line 313, size 64, align 64, offset 8320] [from ]
!629 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !630} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from kaudit_record]
!630 = metadata !{i32 786451, metadata !4, null, metadata !"kaudit_record", i32 162, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [kaudit_record] [line 162, size 0, align 0, offset 0] [fwd] [from ]
!631 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_lprof", i32 314, i64 128, i64 64, i64 8384, i32 0, metadata !632} ; [ DW_TAG_member ] [td_lprof] [line 314, size 128, align 64, offset 8384] [from ]
!632 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 128, i64 64, i32 0, i32 0, metadata !633, metadata !392, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 128, align 64, offset 0] [from lpohead]
!633 = metadata !{i32 786451, metadata !634, null, metadata !"lpohead", i32 35, i64 64, i64 64, i32 0, i32 0, null, metadata !635, i32 0, null, null} ; [ DW_TAG_structure_type ] [lpohead] [line 35, size 64, align 64, offset 0] [from ]
!634 = metadata !{metadata !"/home/jra40/P4/tesla/sys/sys/lock_profile.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!635 = metadata !{metadata !636}
!636 = metadata !{i32 786445, metadata !634, metadata !633, metadata !"lh_first", i32 35, i64 64, i64 64, i64 0, i32 0, metadata !637} ; [ DW_TAG_member ] [lh_first] [line 35, size 64, align 64, offset 0] [from ]
!637 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !638} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from lock_profile_object]
!638 = metadata !{i32 786451, metadata !634, null, metadata !"lock_profile_object", i32 34, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [lock_profile_object] [line 34, size 0, align 0, offset 0] [fwd] [from ]
!639 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_dtrace", i32 315, i64 64, i64 64, i64 8512, i32 0, metadata !640} ; [ DW_TAG_member ] [td_dtrace] [line 315, size 64, align 64, offset 8512] [from ]
!640 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !641} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from kdtrace_thread]
!641 = metadata !{i32 786451, metadata !4, null, metadata !"kdtrace_thread", i32 164, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [kdtrace_thread] [line 164, size 0, align 0, offset 0] [fwd] [from ]
!642 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_errno", i32 316, i64 32, i64 32, i64 8576, i32 0, metadata !93} ; [ DW_TAG_member ] [td_errno] [line 316, size 32, align 32, offset 8576] [from int]
!643 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_vnet", i32 317, i64 64, i64 64, i64 8640, i32 0, metadata !331} ; [ DW_TAG_member ] [td_vnet] [line 317, size 64, align 64, offset 8640] [from ]
!644 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_vnet_lpush", i32 318, i64 64, i64 64, i64 8704, i32 0, metadata !32} ; [ DW_TAG_member ] [td_vnet_lpush] [line 318, size 64, align 64, offset 8704] [from ]
!645 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_intr_frame", i32 319, i64 64, i64 64, i64 8768, i32 0, metadata !575} ; [ DW_TAG_member ] [td_intr_frame] [line 319, size 64, align 64, offset 8768] [from ]
!646 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_rfppwait_p", i32 320, i64 64, i64 64, i64 8832, i32 0, metadata !11} ; [ DW_TAG_member ] [td_rfppwait_p] [line 320, size 64, align 64, offset 8832] [from ]
!647 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_ma", i32 321, i64 64, i64 64, i64 8896, i32 0, metadata !648} ; [ DW_TAG_member ] [td_ma] [line 321, size 64, align 64, offset 8896] [from ]
!648 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !649} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!649 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !650} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from vm_page]
!650 = metadata !{i32 786451, metadata !651, null, metadata !"vm_page", i32 263, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [vm_page] [line 263, size 0, align 0, offset 0] [fwd] [from ]
!651 = metadata !{metadata !"/home/jra40/P4/tesla/sys/sys/types.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!652 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_ma_cnt", i32 322, i64 32, i64 32, i64 8960, i32 0, metadata !93} ; [ DW_TAG_member ] [td_ma_cnt] [line 322, size 32, align 32, offset 8960] [from int]
!653 = metadata !{i32 786445, metadata !4, metadata !19, metadata !"td_tesla", i32 323, i64 64, i64 64, i64 9024, i32 0, metadata !654} ; [ DW_TAG_member ] [td_tesla] [line 323, size 64, align 64, offset 9024] [from ]
!654 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !655} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from tesla_store]
!655 = metadata !{i32 786451, metadata !4, null, metadata !"tesla_store", i32 174, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [tesla_store] [line 174, size 0, align 0, offset 0] [fwd] [from ]
!656 = metadata !{i32 786445, metadata !4, metadata !15, metadata !"tqh_last", i32 487, i64 64, i64 64, i64 64, i32 0, metadata !55} ; [ DW_TAG_member ] [tqh_last] [line 487, size 64, align 64, offset 64] [from ]
!657 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_slock", i32 488, i64 256, i64 64, i64 256, i32 0, metadata !24} ; [ DW_TAG_member ] [p_slock] [line 488, size 256, align 64, offset 256] [from mtx]
!658 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_ucred", i32 489, i64 64, i64 64, i64 512, i32 0, metadata !253} ; [ DW_TAG_member ] [p_ucred] [line 489, size 64, align 64, offset 512] [from ]
!659 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_fd", i32 490, i64 64, i64 64, i64 576, i32 0, metadata !660} ; [ DW_TAG_member ] [p_fd] [line 490, size 64, align 64, offset 576] [from ]
!660 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !661} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from filedesc]
!661 = metadata !{i32 786451, metadata !4, null, metadata !"filedesc", i32 490, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [filedesc] [line 490, size 0, align 0, offset 0] [fwd] [from ]
!662 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_fdtol", i32 491, i64 64, i64 64, i64 640, i32 0, metadata !663} ; [ DW_TAG_member ] [p_fdtol] [line 491, size 64, align 64, offset 640] [from ]
!663 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !664} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from filedesc_to_leader]
!664 = metadata !{i32 786451, metadata !4, null, metadata !"filedesc_to_leader", i32 491, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [filedesc_to_leader] [line 491, size 0, align 0, offset 0] [fwd] [from ]
!665 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_stats", i32 492, i64 64, i64 64, i64 704, i32 0, metadata !666} ; [ DW_TAG_member ] [p_stats] [line 492, size 64, align 64, offset 704] [from ]
!666 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !667} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from pstats]
!667 = metadata !{i32 786451, metadata !4, null, metadata !"pstats", i32 492, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [pstats] [line 492, size 0, align 0, offset 0] [fwd] [from ]
!668 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_limit", i32 493, i64 64, i64 64, i64 768, i32 0, metadata !669} ; [ DW_TAG_member ] [p_limit] [line 493, size 64, align 64, offset 768] [from ]
!669 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !670} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from plimit]
!670 = metadata !{i32 786451, metadata !4, null, metadata !"plimit", i32 493, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [plimit] [line 493, size 0, align 0, offset 0] [fwd] [from ]
!671 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_limco", i32 494, i64 512, i64 64, i64 832, i32 0, metadata !540} ; [ DW_TAG_member ] [p_limco] [line 494, size 512, align 64, offset 832] [from callout]
!672 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_sigacts", i32 495, i64 64, i64 64, i64 1344, i32 0, metadata !673} ; [ DW_TAG_member ] [p_sigacts] [line 495, size 64, align 64, offset 1344] [from ]
!673 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !674} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from sigacts]
!674 = metadata !{i32 786451, metadata !135, null, metadata !"sigacts", i32 52, i64 26176, i64 64, i32 0, i32 0, null, metadata !675, i32 0, null, null} ; [ DW_TAG_structure_type ] [sigacts] [line 52, size 26176, align 64, offset 0] [from ]
!675 = metadata !{metadata !676, metadata !685, metadata !687, metadata !688, metadata !689, metadata !690, metadata !691, metadata !692, metadata !693, metadata !694, metadata !695, metadata !696, metadata !697, metadata !698, metadata !699}
!676 = metadata !{i32 786445, metadata !135, metadata !674, metadata !"ps_sigact", i32 53, i64 8192, i64 64, i64 0, i32 0, metadata !677} ; [ DW_TAG_member ] [ps_sigact] [line 53, size 8192, align 64, offset 0] [from ]
!677 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 8192, i64 64, i32 0, i32 0, metadata !678, metadata !683, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 8192, align 64, offset 0] [from sig_t]
!678 = metadata !{i32 786454, metadata !135, null, metadata !"sig_t", i32 352, i64 0, i64 0, i64 0, i32 0, metadata !679} ; [ DW_TAG_typedef ] [sig_t] [line 352, size 0, align 0, offset 0] [from ]
!679 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !680} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from __sighandler_t]
!680 = metadata !{i32 786454, metadata !135, null, metadata !"__sighandler_t", i32 142, i64 0, i64 0, i64 0, i32 0, metadata !681} ; [ DW_TAG_typedef ] [__sighandler_t] [line 142, size 0, align 0, offset 0] [from ]
!681 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !682, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!682 = metadata !{null, metadata !93}
!683 = metadata !{metadata !684}
!684 = metadata !{i32 786465, i64 0, i64 128}     ; [ DW_TAG_subrange_type ] [0, 127]
!685 = metadata !{i32 786445, metadata !135, metadata !674, metadata !"ps_catchmask", i32 54, i64 16384, i64 32, i64 8192, i32 0, metadata !686} ; [ DW_TAG_member ] [ps_catchmask] [line 54, size 16384, align 32, offset 8192] [from ]
!686 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 16384, i64 32, i32 0, i32 0, metadata !138, metadata !683, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 16384, align 32, offset 0] [from sigset_t]
!687 = metadata !{i32 786445, metadata !135, metadata !674, metadata !"ps_sigonstack", i32 55, i64 128, i64 32, i64 24576, i32 0, metadata !138} ; [ DW_TAG_member ] [ps_sigonstack] [line 55, size 128, align 32, offset 24576] [from sigset_t]
!688 = metadata !{i32 786445, metadata !135, metadata !674, metadata !"ps_sigintr", i32 56, i64 128, i64 32, i64 24704, i32 0, metadata !138} ; [ DW_TAG_member ] [ps_sigintr] [line 56, size 128, align 32, offset 24704] [from sigset_t]
!689 = metadata !{i32 786445, metadata !135, metadata !674, metadata !"ps_sigreset", i32 57, i64 128, i64 32, i64 24832, i32 0, metadata !138} ; [ DW_TAG_member ] [ps_sigreset] [line 57, size 128, align 32, offset 24832] [from sigset_t]
!690 = metadata !{i32 786445, metadata !135, metadata !674, metadata !"ps_signodefer", i32 58, i64 128, i64 32, i64 24960, i32 0, metadata !138} ; [ DW_TAG_member ] [ps_signodefer] [line 58, size 128, align 32, offset 24960] [from sigset_t]
!691 = metadata !{i32 786445, metadata !135, metadata !674, metadata !"ps_siginfo", i32 59, i64 128, i64 32, i64 25088, i32 0, metadata !138} ; [ DW_TAG_member ] [ps_siginfo] [line 59, size 128, align 32, offset 25088] [from sigset_t]
!692 = metadata !{i32 786445, metadata !135, metadata !674, metadata !"ps_sigignore", i32 60, i64 128, i64 32, i64 25216, i32 0, metadata !138} ; [ DW_TAG_member ] [ps_sigignore] [line 60, size 128, align 32, offset 25216] [from sigset_t]
!693 = metadata !{i32 786445, metadata !135, metadata !674, metadata !"ps_sigcatch", i32 61, i64 128, i64 32, i64 25344, i32 0, metadata !138} ; [ DW_TAG_member ] [ps_sigcatch] [line 61, size 128, align 32, offset 25344] [from sigset_t]
!694 = metadata !{i32 786445, metadata !135, metadata !674, metadata !"ps_freebsd4", i32 62, i64 128, i64 32, i64 25472, i32 0, metadata !138} ; [ DW_TAG_member ] [ps_freebsd4] [line 62, size 128, align 32, offset 25472] [from sigset_t]
!695 = metadata !{i32 786445, metadata !135, metadata !674, metadata !"ps_osigset", i32 63, i64 128, i64 32, i64 25600, i32 0, metadata !138} ; [ DW_TAG_member ] [ps_osigset] [line 63, size 128, align 32, offset 25600] [from sigset_t]
!696 = metadata !{i32 786445, metadata !135, metadata !674, metadata !"ps_usertramp", i32 64, i64 128, i64 32, i64 25728, i32 0, metadata !138} ; [ DW_TAG_member ] [ps_usertramp] [line 64, size 128, align 32, offset 25728] [from sigset_t]
!697 = metadata !{i32 786445, metadata !135, metadata !674, metadata !"ps_flag", i32 65, i64 32, i64 32, i64 25856, i32 0, metadata !93} ; [ DW_TAG_member ] [ps_flag] [line 65, size 32, align 32, offset 25856] [from int]
!698 = metadata !{i32 786445, metadata !135, metadata !674, metadata !"ps_refcnt", i32 66, i64 32, i64 32, i64 25888, i32 0, metadata !93} ; [ DW_TAG_member ] [ps_refcnt] [line 66, size 32, align 32, offset 25888] [from int]
!699 = metadata !{i32 786445, metadata !135, metadata !674, metadata !"ps_mtx", i32 67, i64 256, i64 64, i64 25920, i32 0, metadata !24} ; [ DW_TAG_member ] [ps_mtx] [line 67, size 256, align 64, offset 25920] [from mtx]
!700 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_flag", i32 501, i64 32, i64 32, i64 1408, i32 0, metadata !93} ; [ DW_TAG_member ] [p_flag] [line 501, size 32, align 32, offset 1408] [from int]
!701 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_state", i32 506, i64 32, i64 32, i64 1440, i32 0, metadata !3} ; [ DW_TAG_member ] [p_state] [line 506, size 32, align 32, offset 1440] [from ]
!702 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_pid", i32 507, i64 32, i64 32, i64 1472, i32 0, metadata !421} ; [ DW_TAG_member ] [p_pid] [line 507, size 32, align 32, offset 1472] [from pid_t]
!703 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_hash", i32 508, i64 128, i64 64, i64 1536, i32 0, metadata !704} ; [ DW_TAG_member ] [p_hash] [line 508, size 128, align 64, offset 1536] [from ]
!704 = metadata !{i32 786451, metadata !4, metadata !5, metadata !"", i32 508, i64 128, i64 64, i32 0, i32 0, null, metadata !705, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 508, size 128, align 64, offset 0] [from ]
!705 = metadata !{metadata !706, metadata !707}
!706 = metadata !{i32 786445, metadata !4, metadata !704, metadata !"le_next", i32 508, i64 64, i64 64, i64 0, i32 0, metadata !11} ; [ DW_TAG_member ] [le_next] [line 508, size 64, align 64, offset 0] [from ]
!707 = metadata !{i32 786445, metadata !4, metadata !704, metadata !"le_prev", i32 508, i64 64, i64 64, i64 64, i32 0, metadata !13} ; [ DW_TAG_member ] [le_prev] [line 508, size 64, align 64, offset 64] [from ]
!708 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_pglist", i32 509, i64 128, i64 64, i64 1664, i32 0, metadata !709} ; [ DW_TAG_member ] [p_pglist] [line 509, size 128, align 64, offset 1664] [from ]
!709 = metadata !{i32 786451, metadata !4, metadata !5, metadata !"", i32 509, i64 128, i64 64, i32 0, i32 0, null, metadata !710, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 509, size 128, align 64, offset 0] [from ]
!710 = metadata !{metadata !711, metadata !712}
!711 = metadata !{i32 786445, metadata !4, metadata !709, metadata !"le_next", i32 509, i64 64, i64 64, i64 0, i32 0, metadata !11} ; [ DW_TAG_member ] [le_next] [line 509, size 64, align 64, offset 0] [from ]
!712 = metadata !{i32 786445, metadata !4, metadata !709, metadata !"le_prev", i32 509, i64 64, i64 64, i64 64, i32 0, metadata !13} ; [ DW_TAG_member ] [le_prev] [line 509, size 64, align 64, offset 64] [from ]
!713 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_pptr", i32 510, i64 64, i64 64, i64 1792, i32 0, metadata !11} ; [ DW_TAG_member ] [p_pptr] [line 510, size 64, align 64, offset 1792] [from ]
!714 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_sibling", i32 511, i64 128, i64 64, i64 1856, i32 0, metadata !715} ; [ DW_TAG_member ] [p_sibling] [line 511, size 128, align 64, offset 1856] [from ]
!715 = metadata !{i32 786451, metadata !4, metadata !5, metadata !"", i32 511, i64 128, i64 64, i32 0, i32 0, null, metadata !716, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 511, size 128, align 64, offset 0] [from ]
!716 = metadata !{metadata !717, metadata !718}
!717 = metadata !{i32 786445, metadata !4, metadata !715, metadata !"le_next", i32 511, i64 64, i64 64, i64 0, i32 0, metadata !11} ; [ DW_TAG_member ] [le_next] [line 511, size 64, align 64, offset 0] [from ]
!718 = metadata !{i32 786445, metadata !4, metadata !715, metadata !"le_prev", i32 511, i64 64, i64 64, i64 64, i32 0, metadata !13} ; [ DW_TAG_member ] [le_prev] [line 511, size 64, align 64, offset 64] [from ]
!719 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_children", i32 512, i64 64, i64 64, i64 1984, i32 0, metadata !720} ; [ DW_TAG_member ] [p_children] [line 512, size 64, align 64, offset 1984] [from ]
!720 = metadata !{i32 786451, metadata !4, metadata !5, metadata !"", i32 512, i64 64, i64 64, i32 0, i32 0, null, metadata !721, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 512, size 64, align 64, offset 0] [from ]
!721 = metadata !{metadata !722}
!722 = metadata !{i32 786445, metadata !4, metadata !720, metadata !"lh_first", i32 512, i64 64, i64 64, i64 0, i32 0, metadata !11} ; [ DW_TAG_member ] [lh_first] [line 512, size 64, align 64, offset 0] [from ]
!723 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_mtx", i32 513, i64 256, i64 64, i64 2048, i32 0, metadata !24} ; [ DW_TAG_member ] [p_mtx] [line 513, size 256, align 64, offset 2048] [from mtx]
!724 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_ksi", i32 514, i64 64, i64 64, i64 2304, i32 0, metadata !154} ; [ DW_TAG_member ] [p_ksi] [line 514, size 64, align 64, offset 2304] [from ]
!725 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_sigqueue", i32 515, i64 512, i64 64, i64 2368, i32 0, metadata !133} ; [ DW_TAG_member ] [p_sigqueue] [line 515, size 512, align 64, offset 2368] [from sigqueue_t]
!726 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_oppid", i32 520, i64 32, i64 32, i64 2880, i32 0, metadata !421} ; [ DW_TAG_member ] [p_oppid] [line 520, size 32, align 32, offset 2880] [from pid_t]
!727 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_vmspace", i32 521, i64 64, i64 64, i64 2944, i32 0, metadata !728} ; [ DW_TAG_member ] [p_vmspace] [line 521, size 64, align 64, offset 2944] [from ]
!728 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !729} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from vmspace]
!729 = metadata !{i32 786451, metadata !4, null, metadata !"vmspace", i32 521, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [vmspace] [line 521, size 0, align 0, offset 0] [fwd] [from ]
!730 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_swtick", i32 522, i64 32, i64 32, i64 3008, i32 0, metadata !36} ; [ DW_TAG_member ] [p_swtick] [line 522, size 32, align 32, offset 3008] [from u_int]
!731 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_realtimer", i32 523, i64 256, i64 64, i64 3072, i32 0, metadata !732} ; [ DW_TAG_member ] [p_realtimer] [line 523, size 256, align 64, offset 3072] [from itimerval]
!732 = metadata !{i32 786451, metadata !733, null, metadata !"itimerval", i32 319, i64 256, i64 64, i32 0, i32 0, null, metadata !734, i32 0, null, null} ; [ DW_TAG_structure_type ] [itimerval] [line 319, size 256, align 64, offset 0] [from ]
!733 = metadata !{metadata !"/home/jra40/P4/tesla/sys/sys/time.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!734 = metadata !{metadata !735, metadata !736}
!735 = metadata !{i32 786445, metadata !733, metadata !732, metadata !"it_interval", i32 320, i64 128, i64 64, i64 0, i32 0, metadata !438} ; [ DW_TAG_member ] [it_interval] [line 320, size 128, align 64, offset 0] [from timeval]
!736 = metadata !{i32 786445, metadata !733, metadata !732, metadata !"it_value", i32 321, i64 128, i64 64, i64 128, i32 0, metadata !438} ; [ DW_TAG_member ] [it_value] [line 321, size 128, align 64, offset 128] [from timeval]
!737 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_ru", i32 524, i64 1152, i64 64, i64 3328, i32 0, metadata !434} ; [ DW_TAG_member ] [p_ru] [line 524, size 1152, align 64, offset 3328] [from rusage]
!738 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_rux", i32 525, i64 448, i64 64, i64 4480, i32 0, metadata !465} ; [ DW_TAG_member ] [p_rux] [line 525, size 448, align 64, offset 4480] [from rusage_ext]
!739 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_crux", i32 526, i64 448, i64 64, i64 4928, i32 0, metadata !465} ; [ DW_TAG_member ] [p_crux] [line 526, size 448, align 64, offset 4928] [from rusage_ext]
!740 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_profthreads", i32 527, i64 32, i64 32, i64 5376, i32 0, metadata !93} ; [ DW_TAG_member ] [p_profthreads] [line 527, size 32, align 32, offset 5376] [from int]
!741 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_exitthreads", i32 528, i64 32, i64 32, i64 5408, i32 0, metadata !573} ; [ DW_TAG_member ] [p_exitthreads] [line 528, size 32, align 32, offset 5408] [from ]
!742 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_traceflag", i32 529, i64 32, i64 32, i64 5440, i32 0, metadata !93} ; [ DW_TAG_member ] [p_traceflag] [line 529, size 32, align 32, offset 5440] [from int]
!743 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_tracevp", i32 530, i64 64, i64 64, i64 5504, i32 0, metadata !334} ; [ DW_TAG_member ] [p_tracevp] [line 530, size 64, align 64, offset 5504] [from ]
!744 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_tracecred", i32 531, i64 64, i64 64, i64 5568, i32 0, metadata !253} ; [ DW_TAG_member ] [p_tracecred] [line 531, size 64, align 64, offset 5568] [from ]
!745 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_textvp", i32 532, i64 64, i64 64, i64 5632, i32 0, metadata !334} ; [ DW_TAG_member ] [p_textvp] [line 532, size 64, align 64, offset 5632] [from ]
!746 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_lock", i32 533, i64 32, i64 32, i64 5696, i32 0, metadata !36} ; [ DW_TAG_member ] [p_lock] [line 533, size 32, align 32, offset 5696] [from u_int]
!747 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_sigiolst", i32 534, i64 64, i64 64, i64 5760, i32 0, metadata !748} ; [ DW_TAG_member ] [p_sigiolst] [line 534, size 64, align 64, offset 5760] [from sigiolst]
!748 = metadata !{i32 786451, metadata !749, null, metadata !"sigiolst", i32 60, i64 64, i64 64, i32 0, i32 0, null, metadata !750, i32 0, null, null} ; [ DW_TAG_structure_type ] [sigiolst] [line 60, size 64, align 64, offset 0] [from ]
!749 = metadata !{metadata !"/home/jra40/P4/tesla/sys/sys/sigio.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!750 = metadata !{metadata !751}
!751 = metadata !{i32 786445, metadata !749, metadata !748, metadata !"slh_first", i32 60, i64 64, i64 64, i64 0, i32 0, metadata !752} ; [ DW_TAG_member ] [slh_first] [line 60, size 64, align 64, offset 0] [from ]
!752 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !753} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from sigio]
!753 = metadata !{i32 786451, metadata !749, null, metadata !"sigio", i32 46, i64 320, i64 64, i32 0, i32 0, null, metadata !754, i32 0, null, null} ; [ DW_TAG_structure_type ] [sigio] [line 46, size 320, align 64, offset 0] [from ]
!754 = metadata !{metadata !755, metadata !797, metadata !801, metadata !803, metadata !804}
!755 = metadata !{i32 786445, metadata !749, metadata !753, metadata !"sio_u", i32 50, i64 64, i64 64, i64 0, i32 0, metadata !756} ; [ DW_TAG_member ] [sio_u] [line 50, size 64, align 64, offset 0] [from ]
!756 = metadata !{i32 786455, metadata !749, metadata !753, metadata !"", i32 47, i64 64, i64 64, i64 0, i32 0, null, metadata !757, i32 0, i32 0, null} ; [ DW_TAG_union_type ] [line 47, size 64, align 64, offset 0] [from ]
!757 = metadata !{metadata !758, metadata !759}
!758 = metadata !{i32 786445, metadata !749, metadata !756, metadata !"siu_proc", i32 48, i64 64, i64 64, i64 0, i32 0, metadata !11} ; [ DW_TAG_member ] [siu_proc] [line 48, size 64, align 64, offset 0] [from ]
!759 = metadata !{i32 786445, metadata !749, metadata !756, metadata !"siu_pgrp", i32 49, i64 64, i64 64, i64 0, i32 0, metadata !760} ; [ DW_TAG_member ] [siu_pgrp] [line 49, size 64, align 64, offset 0] [from ]
!760 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !761} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from pgrp]
!761 = metadata !{i32 786451, metadata !4, null, metadata !"pgrp", i32 96, i64 640, i64 64, i32 0, i32 0, null, metadata !762, i32 0, null, null} ; [ DW_TAG_structure_type ] [pgrp] [line 96, size 640, align 64, offset 0] [from ]
!762 = metadata !{metadata !763, metadata !769, metadata !773, metadata !793, metadata !794, metadata !795, metadata !796}
!763 = metadata !{i32 786445, metadata !4, metadata !761, metadata !"pg_hash", i32 97, i64 128, i64 64, i64 0, i32 0, metadata !764} ; [ DW_TAG_member ] [pg_hash] [line 97, size 128, align 64, offset 0] [from ]
!764 = metadata !{i32 786451, metadata !4, metadata !761, metadata !"", i32 97, i64 128, i64 64, i32 0, i32 0, null, metadata !765, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 97, size 128, align 64, offset 0] [from ]
!765 = metadata !{metadata !766, metadata !767}
!766 = metadata !{i32 786445, metadata !4, metadata !764, metadata !"le_next", i32 97, i64 64, i64 64, i64 0, i32 0, metadata !760} ; [ DW_TAG_member ] [le_next] [line 97, size 64, align 64, offset 0] [from ]
!767 = metadata !{i32 786445, metadata !4, metadata !764, metadata !"le_prev", i32 97, i64 64, i64 64, i64 64, i32 0, metadata !768} ; [ DW_TAG_member ] [le_prev] [line 97, size 64, align 64, offset 64] [from ]
!768 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !760} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!769 = metadata !{i32 786445, metadata !4, metadata !761, metadata !"pg_members", i32 98, i64 64, i64 64, i64 128, i32 0, metadata !770} ; [ DW_TAG_member ] [pg_members] [line 98, size 64, align 64, offset 128] [from ]
!770 = metadata !{i32 786451, metadata !4, metadata !761, metadata !"", i32 98, i64 64, i64 64, i32 0, i32 0, null, metadata !771, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 98, size 64, align 64, offset 0] [from ]
!771 = metadata !{metadata !772}
!772 = metadata !{i32 786445, metadata !4, metadata !770, metadata !"lh_first", i32 98, i64 64, i64 64, i64 0, i32 0, metadata !11} ; [ DW_TAG_member ] [lh_first] [line 98, size 64, align 64, offset 0] [from ]
!773 = metadata !{i32 786445, metadata !4, metadata !761, metadata !"pg_session", i32 99, i64 64, i64 64, i64 192, i32 0, metadata !774} ; [ DW_TAG_member ] [pg_session] [line 99, size 64, align 64, offset 192] [from ]
!774 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !775} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from session]
!775 = metadata !{i32 786451, metadata !4, null, metadata !"session", i32 76, i64 960, i64 64, i32 0, i32 0, null, metadata !776, i32 0, null, null} ; [ DW_TAG_structure_type ] [session] [line 76, size 960, align 64, offset 0] [from ]
!776 = metadata !{metadata !777, metadata !778, metadata !779, metadata !780, metadata !783, metadata !787, metadata !788, metadata !792}
!777 = metadata !{i32 786445, metadata !4, metadata !775, metadata !"s_count", i32 77, i64 32, i64 32, i64 0, i32 0, metadata !36} ; [ DW_TAG_member ] [s_count] [line 77, size 32, align 32, offset 0] [from u_int]
!778 = metadata !{i32 786445, metadata !4, metadata !775, metadata !"s_leader", i32 78, i64 64, i64 64, i64 64, i32 0, metadata !11} ; [ DW_TAG_member ] [s_leader] [line 78, size 64, align 64, offset 64] [from ]
!779 = metadata !{i32 786445, metadata !4, metadata !775, metadata !"s_ttyvp", i32 79, i64 64, i64 64, i64 128, i32 0, metadata !334} ; [ DW_TAG_member ] [s_ttyvp] [line 79, size 64, align 64, offset 128] [from ]
!780 = metadata !{i32 786445, metadata !4, metadata !775, metadata !"s_ttydp", i32 80, i64 64, i64 64, i64 192, i32 0, metadata !781} ; [ DW_TAG_member ] [s_ttydp] [line 80, size 64, align 64, offset 192] [from ]
!781 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !782} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from cdev_priv]
!782 = metadata !{i32 786451, metadata !4, null, metadata !"cdev_priv", i32 80, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [cdev_priv] [line 80, size 0, align 0, offset 0] [fwd] [from ]
!783 = metadata !{i32 786445, metadata !4, metadata !775, metadata !"s_ttyp", i32 81, i64 64, i64 64, i64 256, i32 0, metadata !784} ; [ DW_TAG_member ] [s_ttyp] [line 81, size 64, align 64, offset 256] [from ]
!784 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !785} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from tty]
!785 = metadata !{i32 786451, metadata !786, null, metadata !"tty", i32 162, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [tty] [line 162, size 0, align 0, offset 0] [fwd] [from ]
!786 = metadata !{metadata !"/home/jra40/P4/tesla/sys/sys/systm.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!787 = metadata !{i32 786445, metadata !4, metadata !775, metadata !"s_sid", i32 82, i64 32, i64 32, i64 320, i32 0, metadata !421} ; [ DW_TAG_member ] [s_sid] [line 82, size 32, align 32, offset 320] [from pid_t]
!788 = metadata !{i32 786445, metadata !4, metadata !775, metadata !"s_login", i32 84, i64 320, i64 8, i64 352, i32 0, metadata !789} ; [ DW_TAG_member ] [s_login] [line 84, size 320, align 8, offset 352] [from ]
!789 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 320, i64 8, i32 0, i32 0, metadata !34, metadata !790, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 320, align 8, offset 0] [from char]
!790 = metadata !{metadata !791}
!791 = metadata !{i32 786465, i64 0, i64 40}      ; [ DW_TAG_subrange_type ] [0, 39]
!792 = metadata !{i32 786445, metadata !4, metadata !775, metadata !"s_mtx", i32 85, i64 256, i64 64, i64 704, i32 0, metadata !24} ; [ DW_TAG_member ] [s_mtx] [line 85, size 256, align 64, offset 704] [from mtx]
!793 = metadata !{i32 786445, metadata !4, metadata !761, metadata !"pg_sigiolst", i32 100, i64 64, i64 64, i64 256, i32 0, metadata !748} ; [ DW_TAG_member ] [pg_sigiolst] [line 100, size 64, align 64, offset 256] [from sigiolst]
!794 = metadata !{i32 786445, metadata !4, metadata !761, metadata !"pg_id", i32 101, i64 32, i64 32, i64 320, i32 0, metadata !421} ; [ DW_TAG_member ] [pg_id] [line 101, size 32, align 32, offset 320] [from pid_t]
!795 = metadata !{i32 786445, metadata !4, metadata !761, metadata !"pg_jobc", i32 102, i64 32, i64 32, i64 352, i32 0, metadata !93} ; [ DW_TAG_member ] [pg_jobc] [line 102, size 32, align 32, offset 352] [from int]
!796 = metadata !{i32 786445, metadata !4, metadata !761, metadata !"pg_mtx", i32 103, i64 256, i64 64, i64 384, i32 0, metadata !24} ; [ DW_TAG_member ] [pg_mtx] [line 103, size 256, align 64, offset 384] [from mtx]
!797 = metadata !{i32 786445, metadata !749, metadata !753, metadata !"sio_pgsigio", i32 51, i64 64, i64 64, i64 64, i32 0, metadata !798} ; [ DW_TAG_member ] [sio_pgsigio] [line 51, size 64, align 64, offset 64] [from ]
!798 = metadata !{i32 786451, metadata !749, metadata !753, metadata !"", i32 51, i64 64, i64 64, i32 0, i32 0, null, metadata !799, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 51, size 64, align 64, offset 0] [from ]
!799 = metadata !{metadata !800}
!800 = metadata !{i32 786445, metadata !749, metadata !798, metadata !"sle_next", i32 51, i64 64, i64 64, i64 0, i32 0, metadata !752} ; [ DW_TAG_member ] [sle_next] [line 51, size 64, align 64, offset 0] [from ]
!801 = metadata !{i32 786445, metadata !749, metadata !753, metadata !"sio_myref", i32 52, i64 64, i64 64, i64 128, i32 0, metadata !802} ; [ DW_TAG_member ] [sio_myref] [line 52, size 64, align 64, offset 128] [from ]
!802 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !752} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!803 = metadata !{i32 786445, metadata !749, metadata !753, metadata !"sio_ucred", i32 54, i64 64, i64 64, i64 192, i32 0, metadata !253} ; [ DW_TAG_member ] [sio_ucred] [line 54, size 64, align 64, offset 192] [from ]
!804 = metadata !{i32 786445, metadata !749, metadata !753, metadata !"sio_pgid", i32 55, i64 32, i64 32, i64 256, i32 0, metadata !421} ; [ DW_TAG_member ] [sio_pgid] [line 55, size 32, align 32, offset 256] [from pid_t]
!805 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_sigparent", i32 535, i64 32, i64 32, i64 5824, i32 0, metadata !93} ; [ DW_TAG_member ] [p_sigparent] [line 535, size 32, align 32, offset 5824] [from int]
!806 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_sig", i32 536, i64 32, i64 32, i64 5856, i32 0, metadata !93} ; [ DW_TAG_member ] [p_sig] [line 536, size 32, align 32, offset 5856] [from int]
!807 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_code", i32 537, i64 64, i64 64, i64 5888, i32 0, metadata !495} ; [ DW_TAG_member ] [p_code] [line 537, size 64, align 64, offset 5888] [from u_long]
!808 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_stops", i32 538, i64 32, i64 32, i64 5952, i32 0, metadata !36} ; [ DW_TAG_member ] [p_stops] [line 538, size 32, align 32, offset 5952] [from u_int]
!809 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_stype", i32 539, i64 32, i64 32, i64 5984, i32 0, metadata !36} ; [ DW_TAG_member ] [p_stype] [line 539, size 32, align 32, offset 5984] [from u_int]
!810 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_step", i32 540, i64 8, i64 8, i64 6016, i32 0, metadata !34} ; [ DW_TAG_member ] [p_step] [line 540, size 8, align 8, offset 6016] [from char]
!811 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_pfsflags", i32 541, i64 8, i64 8, i64 6024, i32 0, metadata !221} ; [ DW_TAG_member ] [p_pfsflags] [line 541, size 8, align 8, offset 6024] [from u_char]
!812 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_nlminfo", i32 542, i64 64, i64 64, i64 6080, i32 0, metadata !813} ; [ DW_TAG_member ] [p_nlminfo] [line 542, size 64, align 64, offset 6080] [from ]
!813 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !814} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from nlminfo]
!814 = metadata !{i32 786451, metadata !4, null, metadata !"nlminfo", i32 166, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [nlminfo] [line 166, size 0, align 0, offset 0] [fwd] [from ]
!815 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_aioinfo", i32 543, i64 64, i64 64, i64 6144, i32 0, metadata !816} ; [ DW_TAG_member ] [p_aioinfo] [line 543, size 64, align 64, offset 6144] [from ]
!816 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !817} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from kaioinfo]
!817 = metadata !{i32 786451, metadata !4, null, metadata !"kaioinfo", i32 161, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [kaioinfo] [line 161, size 0, align 0, offset 0] [fwd] [from ]
!818 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_singlethread", i32 544, i64 64, i64 64, i64 6208, i32 0, metadata !18} ; [ DW_TAG_member ] [p_singlethread] [line 544, size 64, align 64, offset 6208] [from ]
!819 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_suspcount", i32 545, i64 32, i64 32, i64 6272, i32 0, metadata !93} ; [ DW_TAG_member ] [p_suspcount] [line 545, size 32, align 32, offset 6272] [from int]
!820 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_xthread", i32 546, i64 64, i64 64, i64 6336, i32 0, metadata !18} ; [ DW_TAG_member ] [p_xthread] [line 546, size 64, align 64, offset 6336] [from ]
!821 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_boundary_count", i32 547, i64 32, i64 32, i64 6400, i32 0, metadata !93} ; [ DW_TAG_member ] [p_boundary_count] [line 547, size 32, align 32, offset 6400] [from int]
!822 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_pendingcnt", i32 548, i64 32, i64 32, i64 6432, i32 0, metadata !93} ; [ DW_TAG_member ] [p_pendingcnt] [line 548, size 32, align 32, offset 6432] [from int]
!823 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_itimers", i32 549, i64 64, i64 64, i64 6464, i32 0, metadata !824} ; [ DW_TAG_member ] [p_itimers] [line 549, size 64, align 64, offset 6464] [from ]
!824 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !825} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from itimers]
!825 = metadata !{i32 786451, metadata !4, null, metadata !"itimers", i32 549, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [itimers] [line 549, size 0, align 0, offset 0] [fwd] [from ]
!826 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_procdesc", i32 550, i64 64, i64 64, i64 6528, i32 0, metadata !827} ; [ DW_TAG_member ] [p_procdesc] [line 550, size 64, align 64, offset 6528] [from ]
!827 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !828} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from procdesc]
!828 = metadata !{i32 786451, metadata !4, null, metadata !"procdesc", i32 169, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [procdesc] [line 169, size 0, align 0, offset 0] [fwd] [from ]
!829 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_magic", i32 556, i64 32, i64 32, i64 6592, i32 0, metadata !36} ; [ DW_TAG_member ] [p_magic] [line 556, size 32, align 32, offset 6592] [from u_int]
!830 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_osrel", i32 557, i64 32, i64 32, i64 6624, i32 0, metadata !93} ; [ DW_TAG_member ] [p_osrel] [line 557, size 32, align 32, offset 6624] [from int]
!831 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_comm", i32 559, i64 160, i64 8, i64 6656, i32 0, metadata !498} ; [ DW_TAG_member ] [p_comm] [line 559, size 160, align 8, offset 6656] [from ]
!832 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_pgrp", i32 560, i64 64, i64 64, i64 6848, i32 0, metadata !760} ; [ DW_TAG_member ] [p_pgrp] [line 560, size 64, align 64, offset 6848] [from ]
!833 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_sysent", i32 561, i64 64, i64 64, i64 6912, i32 0, metadata !834} ; [ DW_TAG_member ] [p_sysent] [line 561, size 64, align 64, offset 6912] [from ]
!834 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !835} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from sysentvec]
!835 = metadata !{i32 786451, metadata !4, null, metadata !"sysentvec", i32 561, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [sysentvec] [line 561, size 0, align 0, offset 0] [fwd] [from ]
!836 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_args", i32 562, i64 64, i64 64, i64 6976, i32 0, metadata !837} ; [ DW_TAG_member ] [p_args] [line 562, size 64, align 64, offset 6976] [from ]
!837 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !838} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from pargs]
!838 = metadata !{i32 786451, metadata !4, null, metadata !"pargs", i32 109, i64 96, i64 32, i32 0, i32 0, null, metadata !839, i32 0, null, null} ; [ DW_TAG_structure_type ] [pargs] [line 109, size 96, align 32, offset 0] [from ]
!839 = metadata !{metadata !840, metadata !841, metadata !842}
!840 = metadata !{i32 786445, metadata !4, metadata !838, metadata !"ar_ref", i32 110, i64 32, i64 32, i64 0, i32 0, metadata !36} ; [ DW_TAG_member ] [ar_ref] [line 110, size 32, align 32, offset 0] [from u_int]
!841 = metadata !{i32 786445, metadata !4, metadata !838, metadata !"ar_length", i32 111, i64 32, i64 32, i64 32, i32 0, metadata !36} ; [ DW_TAG_member ] [ar_length] [line 111, size 32, align 32, offset 32] [from u_int]
!842 = metadata !{i32 786445, metadata !4, metadata !838, metadata !"ar_args", i32 112, i64 8, i64 8, i64 64, i32 0, metadata !843} ; [ DW_TAG_member ] [ar_args] [line 112, size 8, align 8, offset 64] [from ]
!843 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 8, i64 8, i32 0, i32 0, metadata !221, metadata !88, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 8, align 8, offset 0] [from u_char]
!844 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_cpulimit", i32 563, i64 64, i64 64, i64 7040, i32 0, metadata !845} ; [ DW_TAG_member ] [p_cpulimit] [line 563, size 64, align 64, offset 7040] [from rlim_t]
!845 = metadata !{i32 786454, metadata !4, null, metadata !"rlim_t", i32 187, i64 0, i64 0, i64 0, i32 0, metadata !846} ; [ DW_TAG_typedef ] [rlim_t] [line 187, size 0, align 0, offset 0] [from __rlim_t]
!846 = metadata !{i32 786454, metadata !4, null, metadata !"__rlim_t", i32 56, i64 0, i64 0, i64 0, i32 0, metadata !444} ; [ DW_TAG_typedef ] [__rlim_t] [line 56, size 0, align 0, offset 0] [from __int64_t]
!847 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_nice", i32 564, i64 8, i64 8, i64 7104, i32 0, metadata !848} ; [ DW_TAG_member ] [p_nice] [line 564, size 8, align 8, offset 7104] [from signed char]
!848 = metadata !{i32 786468, null, null, metadata !"signed char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ] [signed char] [line 0, size 8, align 8, offset 0, enc DW_ATE_signed_char]
!849 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_fibnum", i32 565, i64 32, i64 32, i64 7136, i32 0, metadata !93} ; [ DW_TAG_member ] [p_fibnum] [line 565, size 32, align 32, offset 7136] [from int]
!850 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_xstat", i32 569, i64 16, i64 16, i64 7168, i32 0, metadata !306} ; [ DW_TAG_member ] [p_xstat] [line 569, size 16, align 16, offset 7168] [from u_short]
!851 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_klist", i32 570, i64 384, i64 64, i64 7232, i32 0, metadata !852} ; [ DW_TAG_member ] [p_klist] [line 570, size 384, align 64, offset 7232] [from knlist]
!852 = metadata !{i32 786451, metadata !504, null, metadata !"knlist", i32 138, i64 384, i64 64, i32 0, i32 0, null, metadata !853, i32 0, null, null} ; [ DW_TAG_structure_type ] [knlist] [line 138, size 384, align 64, offset 0] [from ]
!853 = metadata !{metadata !854, metadata !929, metadata !930, metadata !931, metadata !932, metadata !933}
!854 = metadata !{i32 786445, metadata !504, metadata !852, metadata !"kl_list", i32 139, i64 64, i64 64, i64 0, i32 0, metadata !855} ; [ DW_TAG_member ] [kl_list] [line 139, size 64, align 64, offset 0] [from klist]
!855 = metadata !{i32 786451, metadata !504, null, metadata !"klist", i32 135, i64 64, i64 64, i32 0, i32 0, null, metadata !856, i32 0, null, null} ; [ DW_TAG_structure_type ] [klist] [line 135, size 64, align 64, offset 0] [from ]
!856 = metadata !{metadata !857}
!857 = metadata !{i32 786445, metadata !504, metadata !855, metadata !"slh_first", i32 135, i64 64, i64 64, i64 0, i32 0, metadata !858} ; [ DW_TAG_member ] [slh_first] [line 135, size 64, align 64, offset 0] [from ]
!858 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !859} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from knote]
!859 = metadata !{i32 786451, metadata !504, null, metadata !"knote", i32 192, i64 1024, i64 64, i32 0, i32 0, null, metadata !860, i32 0, null, null} ; [ DW_TAG_structure_type ] [knote] [line 192, size 1024, align 64, offset 0] [from ]
!860 = metadata !{metadata !861, metadata !865, metadata !869, metadata !871, metadata !877, metadata !880, metadata !891, metadata !892, metadata !893, metadata !894, metadata !905, metadata !927, metadata !928}
!861 = metadata !{i32 786445, metadata !504, metadata !859, metadata !"kn_link", i32 193, i64 64, i64 64, i64 0, i32 0, metadata !862} ; [ DW_TAG_member ] [kn_link] [line 193, size 64, align 64, offset 0] [from ]
!862 = metadata !{i32 786451, metadata !504, metadata !859, metadata !"", i32 193, i64 64, i64 64, i32 0, i32 0, null, metadata !863, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 193, size 64, align 64, offset 0] [from ]
!863 = metadata !{metadata !864}
!864 = metadata !{i32 786445, metadata !504, metadata !862, metadata !"sle_next", i32 193, i64 64, i64 64, i64 0, i32 0, metadata !858} ; [ DW_TAG_member ] [sle_next] [line 193, size 64, align 64, offset 0] [from ]
!865 = metadata !{i32 786445, metadata !504, metadata !859, metadata !"kn_selnext", i32 194, i64 64, i64 64, i64 64, i32 0, metadata !866} ; [ DW_TAG_member ] [kn_selnext] [line 194, size 64, align 64, offset 64] [from ]
!866 = metadata !{i32 786451, metadata !504, metadata !859, metadata !"", i32 194, i64 64, i64 64, i32 0, i32 0, null, metadata !867, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 194, size 64, align 64, offset 0] [from ]
!867 = metadata !{metadata !868}
!868 = metadata !{i32 786445, metadata !504, metadata !866, metadata !"sle_next", i32 194, i64 64, i64 64, i64 0, i32 0, metadata !858} ; [ DW_TAG_member ] [sle_next] [line 194, size 64, align 64, offset 0] [from ]
!869 = metadata !{i32 786445, metadata !504, metadata !859, metadata !"kn_knlist", i32 195, i64 64, i64 64, i64 128, i32 0, metadata !870} ; [ DW_TAG_member ] [kn_knlist] [line 195, size 64, align 64, offset 128] [from ]
!870 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !852} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from knlist]
!871 = metadata !{i32 786445, metadata !504, metadata !859, metadata !"kn_tqe", i32 196, i64 128, i64 64, i64 192, i32 0, metadata !872} ; [ DW_TAG_member ] [kn_tqe] [line 196, size 128, align 64, offset 192] [from ]
!872 = metadata !{i32 786451, metadata !504, metadata !859, metadata !"", i32 196, i64 128, i64 64, i32 0, i32 0, null, metadata !873, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 196, size 128, align 64, offset 0] [from ]
!873 = metadata !{metadata !874, metadata !875}
!874 = metadata !{i32 786445, metadata !504, metadata !872, metadata !"tqe_next", i32 196, i64 64, i64 64, i64 0, i32 0, metadata !858} ; [ DW_TAG_member ] [tqe_next] [line 196, size 64, align 64, offset 0] [from ]
!875 = metadata !{i32 786445, metadata !504, metadata !872, metadata !"tqe_prev", i32 196, i64 64, i64 64, i64 64, i32 0, metadata !876} ; [ DW_TAG_member ] [tqe_prev] [line 196, size 64, align 64, offset 64] [from ]
!876 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !858} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!877 = metadata !{i32 786445, metadata !504, metadata !859, metadata !"kn_kq", i32 197, i64 64, i64 64, i64 320, i32 0, metadata !878} ; [ DW_TAG_member ] [kn_kq] [line 197, size 64, align 64, offset 320] [from ]
!878 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !879} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from kqueue]
!879 = metadata !{i32 786451, metadata !504, null, metadata !"kqueue", i32 136, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [kqueue] [line 136, size 0, align 0, offset 0] [fwd] [from ]
!880 = metadata !{i32 786445, metadata !504, metadata !859, metadata !"kn_kevent", i32 198, i64 256, i64 64, i64 384, i32 0, metadata !881} ; [ DW_TAG_member ] [kn_kevent] [line 198, size 256, align 64, offset 384] [from kevent]
!881 = metadata !{i32 786451, metadata !504, null, metadata !"kevent", i32 57, i64 256, i64 64, i32 0, i32 0, null, metadata !882, i32 0, null, null} ; [ DW_TAG_structure_type ] [kevent] [line 57, size 256, align 64, offset 0] [from ]
!882 = metadata !{metadata !883, metadata !884, metadata !885, metadata !886, metadata !887, metadata !890}
!883 = metadata !{i32 786445, metadata !504, metadata !881, metadata !"ident", i32 58, i64 64, i64 64, i64 0, i32 0, metadata !45} ; [ DW_TAG_member ] [ident] [line 58, size 64, align 64, offset 0] [from uintptr_t]
!884 = metadata !{i32 786445, metadata !504, metadata !881, metadata !"filter", i32 59, i64 16, i64 16, i64 64, i32 0, metadata !236} ; [ DW_TAG_member ] [filter] [line 59, size 16, align 16, offset 64] [from short]
!885 = metadata !{i32 786445, metadata !504, metadata !881, metadata !"flags", i32 60, i64 16, i64 16, i64 80, i32 0, metadata !306} ; [ DW_TAG_member ] [flags] [line 60, size 16, align 16, offset 80] [from u_short]
!886 = metadata !{i32 786445, metadata !504, metadata !881, metadata !"fflags", i32 61, i64 32, i64 32, i64 96, i32 0, metadata !36} ; [ DW_TAG_member ] [fflags] [line 61, size 32, align 32, offset 96] [from u_int]
!887 = metadata !{i32 786445, metadata !504, metadata !881, metadata !"data", i32 62, i64 64, i64 64, i64 128, i32 0, metadata !888} ; [ DW_TAG_member ] [data] [line 62, size 64, align 64, offset 128] [from intptr_t]
!888 = metadata !{i32 786454, metadata !504, null, metadata !"intptr_t", i32 74, i64 0, i64 0, i64 0, i32 0, metadata !889} ; [ DW_TAG_typedef ] [intptr_t] [line 74, size 0, align 0, offset 0] [from __intptr_t]
!889 = metadata !{i32 786454, metadata !504, null, metadata !"__intptr_t", i32 82, i64 0, i64 0, i64 0, i32 0, metadata !444} ; [ DW_TAG_typedef ] [__intptr_t] [line 82, size 0, align 0, offset 0] [from __int64_t]
!890 = metadata !{i32 786445, metadata !504, metadata !881, metadata !"udata", i32 63, i64 64, i64 64, i64 192, i32 0, metadata !178} ; [ DW_TAG_member ] [udata] [line 63, size 64, align 64, offset 192] [from ]
!891 = metadata !{i32 786445, metadata !504, metadata !859, metadata !"kn_status", i32 199, i64 32, i64 32, i64 640, i32 0, metadata !93} ; [ DW_TAG_member ] [kn_status] [line 199, size 32, align 32, offset 640] [from int]
!892 = metadata !{i32 786445, metadata !504, metadata !859, metadata !"kn_sfflags", i32 208, i64 32, i64 32, i64 672, i32 0, metadata !93} ; [ DW_TAG_member ] [kn_sfflags] [line 208, size 32, align 32, offset 672] [from int]
!893 = metadata !{i32 786445, metadata !504, metadata !859, metadata !"kn_sdata", i32 209, i64 64, i64 64, i64 704, i32 0, metadata !888} ; [ DW_TAG_member ] [kn_sdata] [line 209, size 64, align 64, offset 704] [from intptr_t]
!894 = metadata !{i32 786445, metadata !504, metadata !859, metadata !"kn_ptr", i32 215, i64 64, i64 64, i64 768, i32 0, metadata !895} ; [ DW_TAG_member ] [kn_ptr] [line 215, size 64, align 64, offset 768] [from ]
!895 = metadata !{i32 786455, metadata !504, metadata !859, metadata !"", i32 210, i64 64, i64 64, i64 0, i32 0, null, metadata !896, i32 0, i32 0, null} ; [ DW_TAG_union_type ] [line 210, size 64, align 64, offset 0] [from ]
!896 = metadata !{metadata !897, metadata !898, metadata !899, metadata !902}
!897 = metadata !{i32 786445, metadata !504, metadata !895, metadata !"p_fp", i32 211, i64 64, i64 64, i64 0, i32 0, metadata !502} ; [ DW_TAG_member ] [p_fp] [line 211, size 64, align 64, offset 0] [from ]
!898 = metadata !{i32 786445, metadata !504, metadata !895, metadata !"p_proc", i32 212, i64 64, i64 64, i64 0, i32 0, metadata !11} ; [ DW_TAG_member ] [p_proc] [line 212, size 64, align 64, offset 0] [from ]
!899 = metadata !{i32 786445, metadata !504, metadata !895, metadata !"p_aio", i32 213, i64 64, i64 64, i64 0, i32 0, metadata !900} ; [ DW_TAG_member ] [p_aio] [line 213, size 64, align 64, offset 0] [from ]
!900 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !901} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from aiocblist]
!901 = metadata !{i32 786451, metadata !504, null, metadata !"aiocblist", i32 213, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [aiocblist] [line 213, size 0, align 0, offset 0] [fwd] [from ]
!902 = metadata !{i32 786445, metadata !504, metadata !895, metadata !"p_lio", i32 214, i64 64, i64 64, i64 0, i32 0, metadata !903} ; [ DW_TAG_member ] [p_lio] [line 214, size 64, align 64, offset 0] [from ]
!903 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !904} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from aioliojob]
!904 = metadata !{i32 786451, metadata !504, null, metadata !"aioliojob", i32 214, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [aioliojob] [line 214, size 0, align 0, offset 0] [fwd] [from ]
!905 = metadata !{i32 786445, metadata !504, metadata !859, metadata !"kn_fop", i32 216, i64 64, i64 64, i64 832, i32 0, metadata !906} ; [ DW_TAG_member ] [kn_fop] [line 216, size 64, align 64, offset 832] [from ]
!906 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !907} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from filterops]
!907 = metadata !{i32 786451, metadata !504, null, metadata !"filterops", i32 178, i64 320, i64 64, i32 0, i32 0, null, metadata !908, i32 0, null, null} ; [ DW_TAG_structure_type ] [filterops] [line 178, size 320, align 64, offset 0] [from ]
!908 = metadata !{metadata !909, metadata !910, metadata !914, metadata !918, metadata !922}
!909 = metadata !{i32 786445, metadata !504, metadata !907, metadata !"f_isfd", i32 179, i64 32, i64 32, i64 0, i32 0, metadata !93} ; [ DW_TAG_member ] [f_isfd] [line 179, size 32, align 32, offset 0] [from int]
!910 = metadata !{i32 786445, metadata !504, metadata !907, metadata !"f_attach", i32 180, i64 64, i64 64, i64 64, i32 0, metadata !911} ; [ DW_TAG_member ] [f_attach] [line 180, size 64, align 64, offset 64] [from ]
!911 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !912} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!912 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !913, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!913 = metadata !{metadata !93, metadata !858}
!914 = metadata !{i32 786445, metadata !504, metadata !907, metadata !"f_detach", i32 181, i64 64, i64 64, i64 128, i32 0, metadata !915} ; [ DW_TAG_member ] [f_detach] [line 181, size 64, align 64, offset 128] [from ]
!915 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !916} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!916 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !917, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!917 = metadata !{null, metadata !858}
!918 = metadata !{i32 786445, metadata !504, metadata !907, metadata !"f_event", i32 182, i64 64, i64 64, i64 192, i32 0, metadata !919} ; [ DW_TAG_member ] [f_event] [line 182, size 64, align 64, offset 192] [from ]
!919 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !920} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!920 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !921, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!921 = metadata !{metadata !93, metadata !858, metadata !87}
!922 = metadata !{i32 786445, metadata !504, metadata !907, metadata !"f_touch", i32 183, i64 64, i64 64, i64 256, i32 0, metadata !923} ; [ DW_TAG_member ] [f_touch] [line 183, size 64, align 64, offset 256] [from ]
!923 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !924} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!924 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !925, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!925 = metadata !{null, metadata !858, metadata !926, metadata !495}
!926 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !881} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from kevent]
!927 = metadata !{i32 786445, metadata !504, metadata !859, metadata !"kn_hook", i32 217, i64 64, i64 64, i64 896, i32 0, metadata !178} ; [ DW_TAG_member ] [kn_hook] [line 217, size 64, align 64, offset 896] [from ]
!928 = metadata !{i32 786445, metadata !504, metadata !859, metadata !"kn_hookid", i32 218, i64 32, i64 32, i64 960, i32 0, metadata !93} ; [ DW_TAG_member ] [kn_hookid] [line 218, size 32, align 32, offset 960] [from int]
!929 = metadata !{i32 786445, metadata !504, metadata !852, metadata !"kl_lock", i32 140, i64 64, i64 64, i64 64, i32 0, metadata !566} ; [ DW_TAG_member ] [kl_lock] [line 140, size 64, align 64, offset 64] [from ]
!930 = metadata !{i32 786445, metadata !504, metadata !852, metadata !"kl_unlock", i32 141, i64 64, i64 64, i64 128, i32 0, metadata !566} ; [ DW_TAG_member ] [kl_unlock] [line 141, size 64, align 64, offset 128] [from ]
!931 = metadata !{i32 786445, metadata !504, metadata !852, metadata !"kl_assert_locked", i32 142, i64 64, i64 64, i64 192, i32 0, metadata !566} ; [ DW_TAG_member ] [kl_assert_locked] [line 142, size 64, align 64, offset 192] [from ]
!932 = metadata !{i32 786445, metadata !504, metadata !852, metadata !"kl_assert_unlocked", i32 143, i64 64, i64 64, i64 256, i32 0, metadata !566} ; [ DW_TAG_member ] [kl_assert_unlocked] [line 143, size 64, align 64, offset 256] [from ]
!933 = metadata !{i32 786445, metadata !504, metadata !852, metadata !"kl_lockarg", i32 144, i64 64, i64 64, i64 320, i32 0, metadata !178} ; [ DW_TAG_member ] [kl_lockarg] [line 144, size 64, align 64, offset 320] [from ]
!934 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_numthreads", i32 571, i64 32, i64 32, i64 7616, i32 0, metadata !93} ; [ DW_TAG_member ] [p_numthreads] [line 571, size 32, align 32, offset 7616] [from int]
!935 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_md", i32 572, i64 192, i64 64, i64 7680, i32 0, metadata !936} ; [ DW_TAG_member ] [p_md] [line 572, size 192, align 64, offset 7680] [from mdproc]
!936 = metadata !{i32 786451, metadata !620, null, metadata !"mdproc", i32 52, i64 192, i64 64, i32 0, i32 0, null, metadata !937, i32 0, null, null} ; [ DW_TAG_structure_type ] [mdproc] [line 52, size 192, align 64, offset 0] [from ]
!937 = metadata !{metadata !938, metadata !945}
!938 = metadata !{i32 786445, metadata !620, metadata !936, metadata !"md_ldt", i32 53, i64 64, i64 64, i64 0, i32 0, metadata !939} ; [ DW_TAG_member ] [md_ldt] [line 53, size 64, align 64, offset 0] [from ]
!939 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !940} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from proc_ldt]
!940 = metadata !{i32 786451, metadata !620, null, metadata !"proc_ldt", i32 38, i64 128, i64 64, i32 0, i32 0, null, metadata !941, i32 0, null, null} ; [ DW_TAG_structure_type ] [proc_ldt] [line 38, size 128, align 64, offset 0] [from ]
!941 = metadata !{metadata !942, metadata !944}
!942 = metadata !{i32 786445, metadata !620, metadata !940, metadata !"ldt_base", i32 39, i64 64, i64 64, i64 0, i32 0, metadata !943} ; [ DW_TAG_member ] [ldt_base] [line 39, size 64, align 64, offset 0] [from caddr_t]
!943 = metadata !{i32 786454, metadata !620, null, metadata !"caddr_t", i32 74, i64 0, i64 0, i64 0, i32 0, metadata !489} ; [ DW_TAG_typedef ] [caddr_t] [line 74, size 0, align 0, offset 0] [from ]
!944 = metadata !{i32 786445, metadata !620, metadata !940, metadata !"ldt_refcnt", i32 40, i64 32, i64 32, i64 64, i32 0, metadata !93} ; [ DW_TAG_member ] [ldt_refcnt] [line 40, size 32, align 32, offset 64] [from int]
!945 = metadata !{i32 786445, metadata !620, metadata !936, metadata !"md_ldt_sd", i32 54, i64 128, i64 8, i64 64, i32 0, metadata !946} ; [ DW_TAG_member ] [md_ldt_sd] [line 54, size 128, align 8, offset 64] [from system_segment_descriptor]
!946 = metadata !{i32 786451, metadata !947, null, metadata !"system_segment_descriptor", i32 49, i64 128, i64 8, i32 0, i32 0, null, metadata !948, i32 0, null, null} ; [ DW_TAG_structure_type ] [system_segment_descriptor] [line 49, size 128, align 8, offset 0] [from ]
!947 = metadata !{metadata !"./machine/segments.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!948 = metadata !{metadata !949, metadata !950, metadata !951, metadata !952, metadata !953, metadata !954, metadata !955, metadata !956, metadata !957, metadata !958, metadata !959, metadata !960}
!949 = metadata !{i32 786445, metadata !947, metadata !946, metadata !"sd_lolimit", i32 50, i64 16, i64 64, i64 0, i32 0, metadata !424} ; [ DW_TAG_member ] [sd_lolimit] [line 50, size 16, align 64, offset 0] [from u_int64_t]
!950 = metadata !{i32 786445, metadata !947, metadata !946, metadata !"sd_lobase", i32 51, i64 24, i64 64, i64 16, i32 0, metadata !424} ; [ DW_TAG_member ] [sd_lobase] [line 51, size 24, align 64, offset 16] [from u_int64_t]
!951 = metadata !{i32 786445, metadata !947, metadata !946, metadata !"sd_type", i32 52, i64 5, i64 64, i64 40, i32 0, metadata !424} ; [ DW_TAG_member ] [sd_type] [line 52, size 5, align 64, offset 40] [from u_int64_t]
!952 = metadata !{i32 786445, metadata !947, metadata !946, metadata !"sd_dpl", i32 53, i64 2, i64 64, i64 45, i32 0, metadata !424} ; [ DW_TAG_member ] [sd_dpl] [line 53, size 2, align 64, offset 45] [from u_int64_t]
!953 = metadata !{i32 786445, metadata !947, metadata !946, metadata !"sd_p", i32 54, i64 1, i64 64, i64 47, i32 0, metadata !424} ; [ DW_TAG_member ] [sd_p] [line 54, size 1, align 64, offset 47] [from u_int64_t]
!954 = metadata !{i32 786445, metadata !947, metadata !946, metadata !"sd_hilimit", i32 55, i64 4, i64 64, i64 48, i32 0, metadata !424} ; [ DW_TAG_member ] [sd_hilimit] [line 55, size 4, align 64, offset 48] [from u_int64_t]
!955 = metadata !{i32 786445, metadata !947, metadata !946, metadata !"sd_xx0", i32 56, i64 3, i64 64, i64 52, i32 0, metadata !424} ; [ DW_TAG_member ] [sd_xx0] [line 56, size 3, align 64, offset 52] [from u_int64_t]
!956 = metadata !{i32 786445, metadata !947, metadata !946, metadata !"sd_gran", i32 57, i64 1, i64 64, i64 55, i32 0, metadata !424} ; [ DW_TAG_member ] [sd_gran] [line 57, size 1, align 64, offset 55] [from u_int64_t]
!957 = metadata !{i32 786445, metadata !947, metadata !946, metadata !"sd_hibase", i32 58, i64 40, i64 64, i64 56, i32 0, metadata !424} ; [ DW_TAG_member ] [sd_hibase] [line 58, size 40, align 64, offset 56] [from u_int64_t]
!958 = metadata !{i32 786445, metadata !947, metadata !946, metadata !"sd_xx1", i32 59, i64 8, i64 64, i64 96, i32 0, metadata !424} ; [ DW_TAG_member ] [sd_xx1] [line 59, size 8, align 64, offset 96] [from u_int64_t]
!959 = metadata !{i32 786445, metadata !947, metadata !946, metadata !"sd_mbz", i32 60, i64 5, i64 64, i64 104, i32 0, metadata !424} ; [ DW_TAG_member ] [sd_mbz] [line 60, size 5, align 64, offset 104] [from u_int64_t]
!960 = metadata !{i32 786445, metadata !947, metadata !946, metadata !"sd_xx2", i32 61, i64 19, i64 64, i64 109, i32 0, metadata !424} ; [ DW_TAG_member ] [sd_xx2] [line 61, size 19, align 64, offset 109] [from u_int64_t]
!961 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_itcallout", i32 573, i64 512, i64 64, i64 7872, i32 0, metadata !540} ; [ DW_TAG_member ] [p_itcallout] [line 573, size 512, align 64, offset 7872] [from callout]
!962 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_acflag", i32 574, i64 16, i64 16, i64 8384, i32 0, metadata !306} ; [ DW_TAG_member ] [p_acflag] [line 574, size 16, align 16, offset 8384] [from u_short]
!963 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_peers", i32 575, i64 64, i64 64, i64 8448, i32 0, metadata !11} ; [ DW_TAG_member ] [p_peers] [line 575, size 64, align 64, offset 8448] [from ]
!964 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_leader", i32 576, i64 64, i64 64, i64 8512, i32 0, metadata !11} ; [ DW_TAG_member ] [p_leader] [line 576, size 64, align 64, offset 8512] [from ]
!965 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_emuldata", i32 577, i64 64, i64 64, i64 8576, i32 0, metadata !178} ; [ DW_TAG_member ] [p_emuldata] [line 577, size 64, align 64, offset 8576] [from ]
!966 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_label", i32 578, i64 64, i64 64, i64 8640, i32 0, metadata !395} ; [ DW_TAG_member ] [p_label] [line 578, size 64, align 64, offset 8640] [from ]
!967 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_sched", i32 579, i64 64, i64 64, i64 8704, i32 0, metadata !968} ; [ DW_TAG_member ] [p_sched] [line 579, size 64, align 64, offset 8704] [from ]
!968 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !969} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from p_sched]
!969 = metadata !{i32 786451, metadata !4, null, metadata !"p_sched", i32 167, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [p_sched] [line 167, size 0, align 0, offset 0] [fwd] [from ]
!970 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_ktr", i32 580, i64 128, i64 64, i64 8768, i32 0, metadata !971} ; [ DW_TAG_member ] [p_ktr] [line 580, size 128, align 64, offset 8768] [from ]
!971 = metadata !{i32 786451, metadata !4, metadata !5, metadata !"", i32 580, i64 128, i64 64, i32 0, i32 0, null, metadata !972, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 580, size 128, align 64, offset 0] [from ]
!972 = metadata !{metadata !973, metadata !976}
!973 = metadata !{i32 786445, metadata !4, metadata !971, metadata !"stqh_first", i32 580, i64 64, i64 64, i64 0, i32 0, metadata !974} ; [ DW_TAG_member ] [stqh_first] [line 580, size 64, align 64, offset 0] [from ]
!974 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !975} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ktr_request]
!975 = metadata !{i32 786451, metadata !4, null, metadata !"ktr_request", i32 580, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [ktr_request] [line 580, size 0, align 0, offset 0] [fwd] [from ]
!976 = metadata !{i32 786445, metadata !4, metadata !971, metadata !"stqh_last", i32 580, i64 64, i64 64, i64 64, i32 0, metadata !977} ; [ DW_TAG_member ] [stqh_last] [line 580, size 64, align 64, offset 64] [from ]
!977 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !974} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!978 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_mqnotifier", i32 581, i64 64, i64 64, i64 8896, i32 0, metadata !979} ; [ DW_TAG_member ] [p_mqnotifier] [line 581, size 64, align 64, offset 8896] [from ]
!979 = metadata !{i32 786451, metadata !4, metadata !5, metadata !"", i32 581, i64 64, i64 64, i32 0, i32 0, null, metadata !980, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 581, size 64, align 64, offset 0] [from ]
!980 = metadata !{metadata !981}
!981 = metadata !{i32 786445, metadata !4, metadata !979, metadata !"lh_first", i32 581, i64 64, i64 64, i64 0, i32 0, metadata !982} ; [ DW_TAG_member ] [lh_first] [line 581, size 64, align 64, offset 0] [from ]
!982 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !983} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from mqueue_notifier]
!983 = metadata !{i32 786451, metadata !4, null, metadata !"mqueue_notifier", i32 165, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [mqueue_notifier] [line 165, size 0, align 0, offset 0] [fwd] [from ]
!984 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_dtrace", i32 582, i64 64, i64 64, i64 8960, i32 0, metadata !985} ; [ DW_TAG_member ] [p_dtrace] [line 582, size 64, align 64, offset 8960] [from ]
!985 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !986} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from kdtrace_proc]
!986 = metadata !{i32 786451, metadata !4, null, metadata !"kdtrace_proc", i32 163, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [kdtrace_proc] [line 163, size 0, align 0, offset 0] [fwd] [from ]
!987 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_pwait", i32 583, i64 128, i64 64, i64 9024, i32 0, metadata !988} ; [ DW_TAG_member ] [p_pwait] [line 583, size 128, align 64, offset 9024] [from cv]
!988 = metadata !{i32 786451, metadata !989, null, metadata !"cv", i32 46, i64 128, i64 64, i32 0, i32 0, null, metadata !990, i32 0, null, null} ; [ DW_TAG_structure_type ] [cv] [line 46, size 128, align 64, offset 0] [from ]
!989 = metadata !{metadata !"/home/jra40/P4/tesla/sys/sys/condvar.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!990 = metadata !{metadata !991, metadata !992}
!991 = metadata !{i32 786445, metadata !989, metadata !988, metadata !"cv_description", i32 47, i64 64, i64 64, i64 0, i32 0, metadata !32} ; [ DW_TAG_member ] [cv_description] [line 47, size 64, align 64, offset 0] [from ]
!992 = metadata !{i32 786445, metadata !989, metadata !988, metadata !"cv_waiters", i32 48, i64 32, i64 32, i64 64, i32 0, metadata !93} ; [ DW_TAG_member ] [cv_waiters] [line 48, size 32, align 32, offset 64] [from int]
!993 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_dbgwait", i32 584, i64 128, i64 64, i64 9152, i32 0, metadata !988} ; [ DW_TAG_member ] [p_dbgwait] [line 584, size 128, align 64, offset 9152] [from cv]
!994 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_prev_runtime", i32 586, i64 64, i64 64, i64 9280, i32 0, metadata !468} ; [ DW_TAG_member ] [p_prev_runtime] [line 586, size 64, align 64, offset 9280] [from uint64_t]
!995 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_racct", i32 587, i64 64, i64 64, i64 9344, i32 0, metadata !360} ; [ DW_TAG_member ] [p_racct] [line 587, size 64, align 64, offset 9344] [from ]
!996 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_throttled", i32 588, i64 8, i64 8, i64 9408, i32 0, metadata !221} ; [ DW_TAG_member ] [p_throttled] [line 588, size 8, align 8, offset 9408] [from u_char]
!997 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_orphan", i32 595, i64 128, i64 64, i64 9472, i32 0, metadata !998} ; [ DW_TAG_member ] [p_orphan] [line 595, size 128, align 64, offset 9472] [from ]
!998 = metadata !{i32 786451, metadata !4, metadata !5, metadata !"", i32 595, i64 128, i64 64, i32 0, i32 0, null, metadata !999, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 595, size 128, align 64, offset 0] [from ]
!999 = metadata !{metadata !1000, metadata !1001}
!1000 = metadata !{i32 786445, metadata !4, metadata !998, metadata !"le_next", i32 595, i64 64, i64 64, i64 0, i32 0, metadata !11} ; [ DW_TAG_member ] [le_next] [line 595, size 64, align 64, offset 0] [from ]
!1001 = metadata !{i32 786445, metadata !4, metadata !998, metadata !"le_prev", i32 595, i64 64, i64 64, i64 64, i32 0, metadata !13} ; [ DW_TAG_member ] [le_prev] [line 595, size 64, align 64, offset 64] [from ]
!1002 = metadata !{i32 786445, metadata !4, metadata !5, metadata !"p_orphans", i32 596, i64 64, i64 64, i64 9600, i32 0, metadata !1003} ; [ DW_TAG_member ] [p_orphans] [line 596, size 64, align 64, offset 9600] [from ]
!1003 = metadata !{i32 786451, metadata !4, metadata !5, metadata !"", i32 596, i64 64, i64 64, i32 0, i32 0, null, metadata !1004, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 596, size 64, align 64, offset 0] [from ]
!1004 = metadata !{metadata !1005}
!1005 = metadata !{i32 786445, metadata !4, metadata !1003, metadata !"lh_first", i32 596, i64 64, i64 64, i64 0, i32 0, metadata !11} ; [ DW_TAG_member ] [lh_first] [line 596, size 64, align 64, offset 0] [from ]
!1006 = metadata !{metadata !1007, metadata !1008, metadata !1009}
!1007 = metadata !{i32 786472, metadata !"PRS_NEW", i64 0} ; [ DW_TAG_enumerator ] [PRS_NEW :: 0]
!1008 = metadata !{i32 786472, metadata !"PRS_NORMAL", i64 1} ; [ DW_TAG_enumerator ] [PRS_NORMAL :: 1]
!1009 = metadata !{i32 786472, metadata !"PRS_ZOMBIE", i64 2} ; [ DW_TAG_enumerator ] [PRS_ZOMBIE :: 2]
!1010 = metadata !{i32 786436, metadata !1011, null, metadata !"sysinit_sub_id", i32 88, i64 32, i64 32, i32 0, i32 0, null, metadata !1012, i32 0, i32 0} ; [ DW_TAG_enumeration_type ] [sysinit_sub_id] [line 88, size 32, align 32, offset 0] [from ]
!1011 = metadata !{metadata !"/home/jra40/P4/tesla/sys/sys/kernel.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!1012 = metadata !{metadata !1013, metadata !1014, metadata !1015, metadata !1016, metadata !1017, metadata !1018, metadata !1019, metadata !1020, metadata !1021, metadata !1022, metadata !1023, metadata !1024, metadata !1025, metadata !1026, metadata !1027, metadata !1028, metadata !1029, metadata !1030, metadata !1031, metadata !1032, metadata !1033, metadata !1034, metadata !1035, metadata !1036, metadata !1037, metadata !1038, metadata !1039, metadata !1040, metadata !1041, metadata !1042, metadata !1043, metadata !1044, metadata !1045, metadata !1046, metadata !1047, metadata !1048, metadata !1049, metadata !1050, metadata !1051, metadata !1052, metadata !1053, metadata !1054, metadata !1055, metadata !1056, metadata !1057, metadata !1058, metadata !1059, metadata !1060, metadata !1061, metadata !1062, metadata !1063, metadata !1064, metadata !1065, metadata !1066, metadata !1067, metadata !1068, metadata !1069, metadata !1070, metadata !1071, metadata !1072, metadata !1073, metadata !1074, metadata !1075, metadata !1076, metadata !1077, metadata !1078, metadata !1079, metadata !1080, metadata !1081, metadata !1082, metadata !1083, metadata !1084, metadata !1085, metadata !1086, metadata !1087, metadata !1088, metadata !1089, metadata !1090, metadata !1091, metadata !1092, metadata !1093}
!1013 = metadata !{i32 786472, metadata !"SI_SUB_DUMMY", i64 0} ; [ DW_TAG_enumerator ] [SI_SUB_DUMMY :: 0]
!1014 = metadata !{i32 786472, metadata !"SI_SUB_DONE", i64 1} ; [ DW_TAG_enumerator ] [SI_SUB_DONE :: 1]
!1015 = metadata !{i32 786472, metadata !"SI_SUB_TUNABLES", i64 7340032} ; [ DW_TAG_enumerator ] [SI_SUB_TUNABLES :: 7340032]
!1016 = metadata !{i32 786472, metadata !"SI_SUB_COPYRIGHT", i64 8388609} ; [ DW_TAG_enumerator ] [SI_SUB_COPYRIGHT :: 8388609]
!1017 = metadata !{i32 786472, metadata !"SI_SUB_SETTINGS", i64 8912896} ; [ DW_TAG_enumerator ] [SI_SUB_SETTINGS :: 8912896]
!1018 = metadata !{i32 786472, metadata !"SI_SUB_MTX_POOL_STATIC", i64 9437184} ; [ DW_TAG_enumerator ] [SI_SUB_MTX_POOL_STATIC :: 9437184]
!1019 = metadata !{i32 786472, metadata !"SI_SUB_LOCKMGR", i64 9961472} ; [ DW_TAG_enumerator ] [SI_SUB_LOCKMGR :: 9961472]
!1020 = metadata !{i32 786472, metadata !"SI_SUB_VM", i64 16777216} ; [ DW_TAG_enumerator ] [SI_SUB_VM :: 16777216]
!1021 = metadata !{i32 786472, metadata !"SI_SUB_KMEM", i64 25165824} ; [ DW_TAG_enumerator ] [SI_SUB_KMEM :: 25165824]
!1022 = metadata !{i32 786472, metadata !"SI_SUB_KVM_RSRC", i64 27262976} ; [ DW_TAG_enumerator ] [SI_SUB_KVM_RSRC :: 27262976]
!1023 = metadata !{i32 786472, metadata !"SI_SUB_WITNESS", i64 27787264} ; [ DW_TAG_enumerator ] [SI_SUB_WITNESS :: 27787264]
!1024 = metadata !{i32 786472, metadata !"SI_SUB_MTX_POOL_DYNAMIC", i64 28049408} ; [ DW_TAG_enumerator ] [SI_SUB_MTX_POOL_DYNAMIC :: 28049408]
!1025 = metadata !{i32 786472, metadata !"SI_SUB_LOCK", i64 28311552} ; [ DW_TAG_enumerator ] [SI_SUB_LOCK :: 28311552]
!1026 = metadata !{i32 786472, metadata !"SI_SUB_EVENTHANDLER", i64 29360128} ; [ DW_TAG_enumerator ] [SI_SUB_EVENTHANDLER :: 29360128]
!1027 = metadata !{i32 786472, metadata !"SI_SUB_TESLA", i64 29884416} ; [ DW_TAG_enumerator ] [SI_SUB_TESLA :: 29884416]
!1028 = metadata !{i32 786472, metadata !"SI_SUB_VNET_PRELINK", i64 31457280} ; [ DW_TAG_enumerator ] [SI_SUB_VNET_PRELINK :: 31457280]
!1029 = metadata !{i32 786472, metadata !"SI_SUB_KLD", i64 33554432} ; [ DW_TAG_enumerator ] [SI_SUB_KLD :: 33554432]
!1030 = metadata !{i32 786472, metadata !"SI_SUB_CPU", i64 34603008} ; [ DW_TAG_enumerator ] [SI_SUB_CPU :: 34603008]
!1031 = metadata !{i32 786472, metadata !"SI_SUB_RACCT", i64 34668544} ; [ DW_TAG_enumerator ] [SI_SUB_RACCT :: 34668544]
!1032 = metadata !{i32 786472, metadata !"SI_SUB_RANDOM", i64 34734080} ; [ DW_TAG_enumerator ] [SI_SUB_RANDOM :: 34734080]
!1033 = metadata !{i32 786472, metadata !"SI_SUB_KDTRACE", i64 34865152} ; [ DW_TAG_enumerator ] [SI_SUB_KDTRACE :: 34865152]
!1034 = metadata !{i32 786472, metadata !"SI_SUB_MAC", i64 35127296} ; [ DW_TAG_enumerator ] [SI_SUB_MAC :: 35127296]
!1035 = metadata !{i32 786472, metadata !"SI_SUB_MAC_POLICY", i64 35389440} ; [ DW_TAG_enumerator ] [SI_SUB_MAC_POLICY :: 35389440]
!1036 = metadata !{i32 786472, metadata !"SI_SUB_MAC_LATE", i64 35454976} ; [ DW_TAG_enumerator ] [SI_SUB_MAC_LATE :: 35454976]
!1037 = metadata !{i32 786472, metadata !"SI_SUB_VNET", i64 35520512} ; [ DW_TAG_enumerator ] [SI_SUB_VNET :: 35520512]
!1038 = metadata !{i32 786472, metadata !"SI_SUB_INTRINSIC", i64 35651584} ; [ DW_TAG_enumerator ] [SI_SUB_INTRINSIC :: 35651584]
!1039 = metadata !{i32 786472, metadata !"SI_SUB_VM_CONF", i64 36700160} ; [ DW_TAG_enumerator ] [SI_SUB_VM_CONF :: 36700160]
!1040 = metadata !{i32 786472, metadata !"SI_SUB_DDB_SERVICES", i64 37224448} ; [ DW_TAG_enumerator ] [SI_SUB_DDB_SERVICES :: 37224448]
!1041 = metadata !{i32 786472, metadata !"SI_SUB_RUN_QUEUE", i64 37748736} ; [ DW_TAG_enumerator ] [SI_SUB_RUN_QUEUE :: 37748736]
!1042 = metadata !{i32 786472, metadata !"SI_SUB_KTRACE", i64 38273024} ; [ DW_TAG_enumerator ] [SI_SUB_KTRACE :: 38273024]
!1043 = metadata !{i32 786472, metadata !"SI_SUB_OPENSOLARIS", i64 38338560} ; [ DW_TAG_enumerator ] [SI_SUB_OPENSOLARIS :: 38338560]
!1044 = metadata !{i32 786472, metadata !"SI_SUB_CYCLIC", i64 38404096} ; [ DW_TAG_enumerator ] [SI_SUB_CYCLIC :: 38404096]
!1045 = metadata !{i32 786472, metadata !"SI_SUB_AUDIT", i64 38535168} ; [ DW_TAG_enumerator ] [SI_SUB_AUDIT :: 38535168]
!1046 = metadata !{i32 786472, metadata !"SI_SUB_CREATE_INIT", i64 38797312} ; [ DW_TAG_enumerator ] [SI_SUB_CREATE_INIT :: 38797312]
!1047 = metadata !{i32 786472, metadata !"SI_SUB_SCHED_IDLE", i64 39845888} ; [ DW_TAG_enumerator ] [SI_SUB_SCHED_IDLE :: 39845888]
!1048 = metadata !{i32 786472, metadata !"SI_SUB_MBUF", i64 40894464} ; [ DW_TAG_enumerator ] [SI_SUB_MBUF :: 40894464]
!1049 = metadata !{i32 786472, metadata !"SI_SUB_INTR", i64 41943040} ; [ DW_TAG_enumerator ] [SI_SUB_INTR :: 41943040]
!1050 = metadata !{i32 786472, metadata !"SI_SUB_SOFTINTR", i64 41943041} ; [ DW_TAG_enumerator ] [SI_SUB_SOFTINTR :: 41943041]
!1051 = metadata !{i32 786472, metadata !"SI_SUB_ACL", i64 42991616} ; [ DW_TAG_enumerator ] [SI_SUB_ACL :: 42991616]
!1052 = metadata !{i32 786472, metadata !"SI_SUB_DEVFS", i64 49283072} ; [ DW_TAG_enumerator ] [SI_SUB_DEVFS :: 49283072]
!1053 = metadata !{i32 786472, metadata !"SI_SUB_INIT_IF", i64 50331648} ; [ DW_TAG_enumerator ] [SI_SUB_INIT_IF :: 50331648]
!1054 = metadata !{i32 786472, metadata !"SI_SUB_NETGRAPH", i64 50397184} ; [ DW_TAG_enumerator ] [SI_SUB_NETGRAPH :: 50397184]
!1055 = metadata !{i32 786472, metadata !"SI_SUB_DTRACE", i64 50462720} ; [ DW_TAG_enumerator ] [SI_SUB_DTRACE :: 50462720]
!1056 = metadata !{i32 786472, metadata !"SI_SUB_DTRACE_PROVIDER", i64 50626560} ; [ DW_TAG_enumerator ] [SI_SUB_DTRACE_PROVIDER :: 50626560]
!1057 = metadata !{i32 786472, metadata !"SI_SUB_DTRACE_ANON", i64 50905088} ; [ DW_TAG_enumerator ] [SI_SUB_DTRACE_ANON :: 50905088]
!1058 = metadata !{i32 786472, metadata !"SI_SUB_DRIVERS", i64 51380224} ; [ DW_TAG_enumerator ] [SI_SUB_DRIVERS :: 51380224]
!1059 = metadata !{i32 786472, metadata !"SI_SUB_CONFIGURE", i64 58720256} ; [ DW_TAG_enumerator ] [SI_SUB_CONFIGURE :: 58720256]
!1060 = metadata !{i32 786472, metadata !"SI_SUB_VFS", i64 67108864} ; [ DW_TAG_enumerator ] [SI_SUB_VFS :: 67108864]
!1061 = metadata !{i32 786472, metadata !"SI_SUB_CLOCKS", i64 75497472} ; [ DW_TAG_enumerator ] [SI_SUB_CLOCKS :: 75497472]
!1062 = metadata !{i32 786472, metadata !"SI_SUB_CLIST", i64 92274688} ; [ DW_TAG_enumerator ] [SI_SUB_CLIST :: 92274688]
!1063 = metadata !{i32 786472, metadata !"SI_SUB_SYSV_SHM", i64 104857600} ; [ DW_TAG_enumerator ] [SI_SUB_SYSV_SHM :: 104857600]
!1064 = metadata !{i32 786472, metadata !"SI_SUB_SYSV_SEM", i64 109051904} ; [ DW_TAG_enumerator ] [SI_SUB_SYSV_SEM :: 109051904]
!1065 = metadata !{i32 786472, metadata !"SI_SUB_SYSV_MSG", i64 113246208} ; [ DW_TAG_enumerator ] [SI_SUB_SYSV_MSG :: 113246208]
!1066 = metadata !{i32 786472, metadata !"SI_SUB_P1003_1B", i64 115343360} ; [ DW_TAG_enumerator ] [SI_SUB_P1003_1B :: 115343360]
!1067 = metadata !{i32 786472, metadata !"SI_SUB_PSEUDO", i64 117440512} ; [ DW_TAG_enumerator ] [SI_SUB_PSEUDO :: 117440512]
!1068 = metadata !{i32 786472, metadata !"SI_SUB_EXEC", i64 121634816} ; [ DW_TAG_enumerator ] [SI_SUB_EXEC :: 121634816]
!1069 = metadata !{i32 786472, metadata !"SI_SUB_PROTO_BEGIN", i64 134217728} ; [ DW_TAG_enumerator ] [SI_SUB_PROTO_BEGIN :: 134217728]
!1070 = metadata !{i32 786472, metadata !"SI_SUB_PROTO_IF", i64 138412032} ; [ DW_TAG_enumerator ] [SI_SUB_PROTO_IF :: 138412032]
!1071 = metadata !{i32 786472, metadata !"SI_SUB_PROTO_DOMAININIT", i64 140509184} ; [ DW_TAG_enumerator ] [SI_SUB_PROTO_DOMAININIT :: 140509184]
!1072 = metadata !{i32 786472, metadata !"SI_SUB_PROTO_DOMAIN", i64 142606336} ; [ DW_TAG_enumerator ] [SI_SUB_PROTO_DOMAIN :: 142606336]
!1073 = metadata !{i32 786472, metadata !"SI_SUB_PROTO_IFATTACHDOMAIN", i64 142606337} ; [ DW_TAG_enumerator ] [SI_SUB_PROTO_IFATTACHDOMAIN :: 142606337]
!1074 = metadata !{i32 786472, metadata !"SI_SUB_PROTO_END", i64 150994943} ; [ DW_TAG_enumerator ] [SI_SUB_PROTO_END :: 150994943]
!1075 = metadata !{i32 786472, metadata !"SI_SUB_KPROF", i64 150994944} ; [ DW_TAG_enumerator ] [SI_SUB_KPROF :: 150994944]
!1076 = metadata !{i32 786472, metadata !"SI_SUB_KICK_SCHEDULER", i64 167772160} ; [ DW_TAG_enumerator ] [SI_SUB_KICK_SCHEDULER :: 167772160]
!1077 = metadata !{i32 786472, metadata !"SI_SUB_INT_CONFIG_HOOKS", i64 176160768} ; [ DW_TAG_enumerator ] [SI_SUB_INT_CONFIG_HOOKS :: 176160768]
!1078 = metadata !{i32 786472, metadata !"SI_SUB_ROOT_CONF", i64 184549376} ; [ DW_TAG_enumerator ] [SI_SUB_ROOT_CONF :: 184549376]
!1079 = metadata !{i32 786472, metadata !"SI_SUB_DUMP_CONF", i64 186646528} ; [ DW_TAG_enumerator ] [SI_SUB_DUMP_CONF :: 186646528]
!1080 = metadata !{i32 786472, metadata !"SI_SUB_RAID", i64 188219392} ; [ DW_TAG_enumerator ] [SI_SUB_RAID :: 188219392]
!1081 = metadata !{i32 786472, metadata !"SI_SUB_SWAP", i64 201326592} ; [ DW_TAG_enumerator ] [SI_SUB_SWAP :: 201326592]
!1082 = metadata !{i32 786472, metadata !"SI_SUB_INTRINSIC_POST", i64 218103808} ; [ DW_TAG_enumerator ] [SI_SUB_INTRINSIC_POST :: 218103808]
!1083 = metadata !{i32 786472, metadata !"SI_SUB_SYSCALLS", i64 226492416} ; [ DW_TAG_enumerator ] [SI_SUB_SYSCALLS :: 226492416]
!1084 = metadata !{i32 786472, metadata !"SI_SUB_VNET_DONE", i64 230686720} ; [ DW_TAG_enumerator ] [SI_SUB_VNET_DONE :: 230686720]
!1085 = metadata !{i32 786472, metadata !"SI_SUB_KTHREAD_INIT", i64 234881024} ; [ DW_TAG_enumerator ] [SI_SUB_KTHREAD_INIT :: 234881024]
!1086 = metadata !{i32 786472, metadata !"SI_SUB_KTHREAD_PAGE", i64 239075328} ; [ DW_TAG_enumerator ] [SI_SUB_KTHREAD_PAGE :: 239075328]
!1087 = metadata !{i32 786472, metadata !"SI_SUB_KTHREAD_VM", i64 243269632} ; [ DW_TAG_enumerator ] [SI_SUB_KTHREAD_VM :: 243269632]
!1088 = metadata !{i32 786472, metadata !"SI_SUB_KTHREAD_BUF", i64 245366784} ; [ DW_TAG_enumerator ] [SI_SUB_KTHREAD_BUF :: 245366784]
!1089 = metadata !{i32 786472, metadata !"SI_SUB_KTHREAD_UPDATE", i64 247463936} ; [ DW_TAG_enumerator ] [SI_SUB_KTHREAD_UPDATE :: 247463936]
!1090 = metadata !{i32 786472, metadata !"SI_SUB_KTHREAD_IDLE", i64 249561088} ; [ DW_TAG_enumerator ] [SI_SUB_KTHREAD_IDLE :: 249561088]
!1091 = metadata !{i32 786472, metadata !"SI_SUB_SMP", i64 251658240} ; [ DW_TAG_enumerator ] [SI_SUB_SMP :: 251658240]
!1092 = metadata !{i32 786472, metadata !"SI_SUB_RACCTD", i64 252706816} ; [ DW_TAG_enumerator ] [SI_SUB_RACCTD :: 252706816]
!1093 = metadata !{i32 786472, metadata !"SI_SUB_RUN_SCHEDULER", i64 268435455} ; [ DW_TAG_enumerator ] [SI_SUB_RUN_SCHEDULER :: 268435455]
!1094 = metadata !{i32 786436, metadata !1011, null, metadata !"sysinit_elem_order", i32 176, i64 32, i64 32, i32 0, i32 0, null, metadata !1095, i32 0, i32 0} ; [ DW_TAG_enumeration_type ] [sysinit_elem_order] [line 176, size 32, align 32, offset 0] [from ]
!1095 = metadata !{metadata !1096, metadata !1097, metadata !1098, metadata !1099, metadata !1100, metadata !1101}
!1096 = metadata !{i32 786472, metadata !"SI_ORDER_FIRST", i64 0} ; [ DW_TAG_enumerator ] [SI_ORDER_FIRST :: 0]
!1097 = metadata !{i32 786472, metadata !"SI_ORDER_SECOND", i64 1} ; [ DW_TAG_enumerator ] [SI_ORDER_SECOND :: 1]
!1098 = metadata !{i32 786472, metadata !"SI_ORDER_THIRD", i64 2} ; [ DW_TAG_enumerator ] [SI_ORDER_THIRD :: 2]
!1099 = metadata !{i32 786472, metadata !"SI_ORDER_FOURTH", i64 3} ; [ DW_TAG_enumerator ] [SI_ORDER_FOURTH :: 3]
!1100 = metadata !{i32 786472, metadata !"SI_ORDER_MIDDLE", i64 16777216} ; [ DW_TAG_enumerator ] [SI_ORDER_MIDDLE :: 16777216]
!1101 = metadata !{i32 786472, metadata !"SI_ORDER_ANY", i64 268435455} ; [ DW_TAG_enumerator ] [SI_ORDER_ANY :: 268435455]
!1102 = metadata !{i32 0}
!1103 = metadata !{metadata !1104, metadata !1108, metadata !1111, metadata !1116, metadata !1119, metadata !1123, metadata !1126, metadata !1129, metadata !1132, metadata !1135, metadata !1149, metadata !1169, metadata !1189, metadata !1211, metadata !1232, metadata !1233, metadata !1239, metadata !1240, metadata !1243, metadata !1246, metadata !1247, metadata !1251, metadata !1252, metadata !1255, metadata !1256, metadata !1257, metadata !1260, metadata !1261, metadata !1265, metadata !1268, metadata !1271, metadata !1277, metadata !1280, metadata !1283, metadata !1291, metadata !1296, metadata !1299, metadata !1302, metadata !1305, metadata !1310, metadata !1313}
!1104 = metadata !{i32 786478, metadata !1, metadata !1105, metadata !"cpuset_ref", metadata !"cpuset_ref", metadata !"", i32 124, metadata !1106, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, %struct.cpuset* (%struct.cpuset*)* @cpuset_ref, null, null, metadata !1102, i32 125} ; [ DW_TAG_subprogram ] [line 124] [def] [scope 125] [cpuset_ref]
!1105 = metadata !{i32 786473, metadata !1}       ; [ DW_TAG_file_type ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1106 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1107, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1107 = metadata !{metadata !77, metadata !77}
!1108 = metadata !{i32 786478, metadata !1, metadata !1105, metadata !"cpuset_rel", metadata !"cpuset_rel", metadata !"", i32 167, metadata !1109, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (%struct.cpuset*)* @cpuset_rel, null, null, metadata !1102, i32 168} ; [ DW_TAG_subprogram ] [line 167] [def] [scope 168] [cpuset_rel]
!1109 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1110, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1110 = metadata !{null, metadata !77}
!1111 = metadata !{i32 786478, metadata !1, metadata !1105, metadata !"cpusetobj_ffs", metadata !"cpusetobj_ffs", metadata !"", i32 627, metadata !1112, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct._cpuset*)* @cpusetobj_ffs, null, null, metadata !1102, i32 628} ; [ DW_TAG_subprogram ] [line 627] [def] [scope 628] [cpusetobj_ffs]
!1112 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1113, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1113 = metadata !{metadata !93, metadata !1114}
!1114 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1115} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!1115 = metadata !{i32 786470, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !81} ; [ DW_TAG_const_type ] [line 0, size 0, align 0, offset 0] [from cpuset_t]
!1116 = metadata !{i32 786478, metadata !1, metadata !1105, metadata !"cpusetobj_strprint", metadata !"cpusetobj_strprint", metadata !"", i32 648, metadata !1117, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i8* (i8*, %struct._cpuset*)* @cpusetobj_strprint, null, null, metadata !1102, i32 649} ; [ DW_TAG_subprogram ] [line 648] [def] [scope 649] [cpusetobj_strprint]
!1117 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1118, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1118 = metadata !{metadata !489, metadata !489, metadata !1114}
!1119 = metadata !{i32 786478, metadata !1, metadata !1105, metadata !"cpusetobj_strscan", metadata !"cpusetobj_strscan", metadata !"", i32 671, metadata !1120, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct._cpuset*, i8*)* @cpusetobj_strscan, null, null, metadata !1102, i32 672} ; [ DW_TAG_subprogram ] [line 671] [def] [scope 672] [cpusetobj_strscan]
!1120 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1121, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1121 = metadata !{metadata !93, metadata !1122, metadata !32}
!1122 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !81} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from cpuset_t]
!1123 = metadata !{i32 786478, metadata !1, metadata !1105, metadata !"cpuset_setthread", metadata !"cpuset_setthread", metadata !"", i32 707, metadata !1124, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32, %struct._cpuset*)* @cpuset_setthread, null, null, metadata !1102, i32 708} ; [ DW_TAG_subprogram ] [line 707] [def] [scope 708] [cpuset_setthread]
!1124 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1125, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1125 = metadata !{metadata !93, metadata !129, metadata !1122}
!1126 = metadata !{i32 786478, metadata !1, metadata !1105, metadata !"cpuset_thread0", metadata !"cpuset_thread0", metadata !"", i32 753, metadata !1127, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, %struct.cpuset* ()* @cpuset_thread0, null, null, metadata !1102, i32 754} ; [ DW_TAG_subprogram ] [line 753] [def] [scope 754] [cpuset_thread0]
!1127 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1128, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1128 = metadata !{metadata !77}
!1129 = metadata !{i32 786478, metadata !1, metadata !1105, metadata !"cpuset_create_root", metadata !"cpuset_create_root", metadata !"", i32 797, metadata !1130, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.prison*, %struct.cpuset**)* @cpuset_create_root, null, null, metadata !1102, i32 798} ; [ DW_TAG_subprogram ] [line 797] [def] [scope 798] [cpuset_create_root]
!1130 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1131, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1131 = metadata !{metadata !93, metadata !271, metadata !103}
!1132 = metadata !{i32 786478, metadata !1, metadata !1105, metadata !"cpuset_setproc_update_set", metadata !"cpuset_setproc_update_set", metadata !"", i32 820, metadata !1133, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.proc*, %struct.cpuset*)* @cpuset_setproc_update_set, null, null, metadata !1102, i32 821} ; [ DW_TAG_subprogram ] [line 820] [def] [scope 821] [cpuset_setproc_update_set]
!1133 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1134, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1134 = metadata !{metadata !93, metadata !11, metadata !77}
!1135 = metadata !{i32 786478, metadata !1, metadata !1105, metadata !"sys_cpuset", metadata !"sys_cpuset", metadata !"", i32 857, metadata !1136, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.cpuset_args*)* @sys_cpuset, null, null, metadata !1102, i32 858} ; [ DW_TAG_subprogram ] [line 857] [def] [scope 858] [sys_cpuset]
!1136 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1137, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1137 = metadata !{metadata !93, metadata !18, metadata !1138}
!1138 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1139} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from cpuset_args]
!1139 = metadata !{i32 786451, metadata !1140, null, metadata !"cpuset_args", i32 1519, i64 64, i64 64, i32 0, i32 0, null, metadata !1141, i32 0, null, null} ; [ DW_TAG_structure_type ] [cpuset_args] [line 1519, size 64, align 64, offset 0] [from ]
!1140 = metadata !{metadata !"/home/jra40/P4/tesla/sys/sys/sysproto.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!1141 = metadata !{metadata !1142, metadata !1146, metadata !1148}
!1142 = metadata !{i32 786445, metadata !1140, metadata !1139, metadata !"setid_l_", i32 1520, i64 0, i64 8, i64 0, i32 0, metadata !1143} ; [ DW_TAG_member ] [setid_l_] [line 1520, size 0, align 8, offset 0] [from ]
!1143 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 0, i64 8, i32 0, i32 0, metadata !34, metadata !1144, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 0, align 8, offset 0] [from char]
!1144 = metadata !{metadata !1145}
!1145 = metadata !{i32 786465, i64 0, i64 0}      ; [ DW_TAG_subrange_type ] [0, -1]
!1146 = metadata !{i32 786445, metadata !1140, metadata !1139, metadata !"setid", i32 1520, i64 64, i64 64, i64 0, i32 0, metadata !1147} ; [ DW_TAG_member ] [setid] [line 1520, size 64, align 64, offset 0] [from ]
!1147 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !95} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from cpusetid_t]
!1148 = metadata !{i32 786445, metadata !1140, metadata !1139, metadata !"setid_r_", i32 1520, i64 0, i64 8, i64 64, i32 0, metadata !1143} ; [ DW_TAG_member ] [setid_r_] [line 1520, size 0, align 8, offset 64] [from ]
!1149 = metadata !{i32 786478, metadata !1, metadata !1105, metadata !"sys_cpuset_setid", metadata !"sys_cpuset_setid", metadata !"", i32 885, metadata !1150, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.cpuset_setid_args*)* @sys_cpuset_setid, null, null, metadata !1102, i32 886} ; [ DW_TAG_subprogram ] [line 885] [def] [scope 886] [sys_cpuset_setid]
!1150 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1151, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1151 = metadata !{metadata !93, metadata !18, metadata !1152}
!1152 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1153} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from cpuset_setid_args]
!1153 = metadata !{i32 786451, metadata !1140, null, metadata !"cpuset_setid_args", i32 1522, i64 192, i64 64, i32 0, i32 0, null, metadata !1154, i32 0, null, null} ; [ DW_TAG_structure_type ] [cpuset_setid_args] [line 1522, size 192, align 64, offset 0] [from ]
!1154 = metadata !{metadata !1155, metadata !1156, metadata !1159, metadata !1161, metadata !1162, metadata !1165, metadata !1166, metadata !1167, metadata !1168}
!1155 = metadata !{i32 786445, metadata !1140, metadata !1153, metadata !"which_l_", i32 1523, i64 0, i64 8, i64 0, i32 0, metadata !1143} ; [ DW_TAG_member ] [which_l_] [line 1523, size 0, align 8, offset 0] [from ]
!1156 = metadata !{i32 786445, metadata !1140, metadata !1153, metadata !"which", i32 1523, i64 32, i64 32, i64 0, i32 0, metadata !1157} ; [ DW_TAG_member ] [which] [line 1523, size 32, align 32, offset 0] [from cpuwhich_t]
!1157 = metadata !{i32 786454, metadata !1140, null, metadata !"cpuwhich_t", i32 82, i64 0, i64 0, i64 0, i32 0, metadata !1158} ; [ DW_TAG_typedef ] [cpuwhich_t] [line 82, size 0, align 0, offset 0] [from __cpuwhich_t]
!1158 = metadata !{i32 786454, metadata !1140, null, metadata !"__cpuwhich_t", i32 66, i64 0, i64 0, i64 0, i32 0, metadata !93} ; [ DW_TAG_typedef ] [__cpuwhich_t] [line 66, size 0, align 0, offset 0] [from int]
!1159 = metadata !{i32 786445, metadata !1140, metadata !1153, metadata !"which_r_", i32 1523, i64 32, i64 8, i64 32, i32 0, metadata !1160} ; [ DW_TAG_member ] [which_r_] [line 1523, size 32, align 8, offset 32] [from ]
!1160 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 32, i64 8, i32 0, i32 0, metadata !34, metadata !147, i32 0, i32 0} ; [ DW_TAG_array_type ] [line 0, size 32, align 8, offset 0] [from char]
!1161 = metadata !{i32 786445, metadata !1140, metadata !1153, metadata !"id_l_", i32 1524, i64 0, i64 8, i64 64, i32 0, metadata !1143} ; [ DW_TAG_member ] [id_l_] [line 1524, size 0, align 8, offset 64] [from ]
!1162 = metadata !{i32 786445, metadata !1140, metadata !1153, metadata !"id", i32 1524, i64 64, i64 64, i64 64, i32 0, metadata !1163} ; [ DW_TAG_member ] [id] [line 1524, size 64, align 64, offset 64] [from id_t]
!1163 = metadata !{i32 786454, metadata !1140, null, metadata !"id_t", i32 140, i64 0, i64 0, i64 0, i32 0, metadata !1164} ; [ DW_TAG_typedef ] [id_t] [line 140, size 0, align 0, offset 0] [from __id_t]
!1164 = metadata !{i32 786454, metadata !1140, null, metadata !"__id_t", i32 46, i64 0, i64 0, i64 0, i32 0, metadata !444} ; [ DW_TAG_typedef ] [__id_t] [line 46, size 0, align 0, offset 0] [from __int64_t]
!1165 = metadata !{i32 786445, metadata !1140, metadata !1153, metadata !"id_r_", i32 1524, i64 0, i64 8, i64 128, i32 0, metadata !1143} ; [ DW_TAG_member ] [id_r_] [line 1524, size 0, align 8, offset 128] [from ]
!1166 = metadata !{i32 786445, metadata !1140, metadata !1153, metadata !"setid_l_", i32 1525, i64 0, i64 8, i64 128, i32 0, metadata !1143} ; [ DW_TAG_member ] [setid_l_] [line 1525, size 0, align 8, offset 128] [from ]
!1167 = metadata !{i32 786445, metadata !1140, metadata !1153, metadata !"setid", i32 1525, i64 32, i64 32, i64 128, i32 0, metadata !95} ; [ DW_TAG_member ] [setid] [line 1525, size 32, align 32, offset 128] [from cpusetid_t]
!1168 = metadata !{i32 786445, metadata !1140, metadata !1153, metadata !"setid_r_", i32 1525, i64 32, i64 8, i64 160, i32 0, metadata !1160} ; [ DW_TAG_member ] [setid_r_] [line 1525, size 32, align 8, offset 160] [from ]
!1169 = metadata !{i32 786478, metadata !1, metadata !1105, metadata !"sys_cpuset_getid", metadata !"sys_cpuset_getid", metadata !"", i32 912, metadata !1170, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.cpuset_getid_args*)* @sys_cpuset_getid, null, null, metadata !1102, i32 913} ; [ DW_TAG_subprogram ] [line 912] [def] [scope 913] [sys_cpuset_getid]
!1170 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1171, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1171 = metadata !{metadata !93, metadata !18, metadata !1172}
!1172 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1173} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from cpuset_getid_args]
!1173 = metadata !{i32 786451, metadata !1140, null, metadata !"cpuset_getid_args", i32 1527, i64 256, i64 64, i32 0, i32 0, null, metadata !1174, i32 0, null, null} ; [ DW_TAG_structure_type ] [cpuset_getid_args] [line 1527, size 256, align 64, offset 0] [from ]
!1174 = metadata !{metadata !1175, metadata !1176, metadata !1179, metadata !1180, metadata !1181, metadata !1182, metadata !1183, metadata !1184, metadata !1185, metadata !1186, metadata !1187, metadata !1188}
!1175 = metadata !{i32 786445, metadata !1140, metadata !1173, metadata !"level_l_", i32 1528, i64 0, i64 8, i64 0, i32 0, metadata !1143} ; [ DW_TAG_member ] [level_l_] [line 1528, size 0, align 8, offset 0] [from ]
!1176 = metadata !{i32 786445, metadata !1140, metadata !1173, metadata !"level", i32 1528, i64 32, i64 32, i64 0, i32 0, metadata !1177} ; [ DW_TAG_member ] [level] [line 1528, size 32, align 32, offset 0] [from cpulevel_t]
!1177 = metadata !{i32 786454, metadata !1140, null, metadata !"cpulevel_t", i32 83, i64 0, i64 0, i64 0, i32 0, metadata !1178} ; [ DW_TAG_typedef ] [cpulevel_t] [line 83, size 0, align 0, offset 0] [from __cpulevel_t]
!1178 = metadata !{i32 786454, metadata !1140, null, metadata !"__cpulevel_t", i32 67, i64 0, i64 0, i64 0, i32 0, metadata !93} ; [ DW_TAG_typedef ] [__cpulevel_t] [line 67, size 0, align 0, offset 0] [from int]
!1179 = metadata !{i32 786445, metadata !1140, metadata !1173, metadata !"level_r_", i32 1528, i64 32, i64 8, i64 32, i32 0, metadata !1160} ; [ DW_TAG_member ] [level_r_] [line 1528, size 32, align 8, offset 32] [from ]
!1180 = metadata !{i32 786445, metadata !1140, metadata !1173, metadata !"which_l_", i32 1529, i64 0, i64 8, i64 64, i32 0, metadata !1143} ; [ DW_TAG_member ] [which_l_] [line 1529, size 0, align 8, offset 64] [from ]
!1181 = metadata !{i32 786445, metadata !1140, metadata !1173, metadata !"which", i32 1529, i64 32, i64 32, i64 64, i32 0, metadata !1157} ; [ DW_TAG_member ] [which] [line 1529, size 32, align 32, offset 64] [from cpuwhich_t]
!1182 = metadata !{i32 786445, metadata !1140, metadata !1173, metadata !"which_r_", i32 1529, i64 32, i64 8, i64 96, i32 0, metadata !1160} ; [ DW_TAG_member ] [which_r_] [line 1529, size 32, align 8, offset 96] [from ]
!1183 = metadata !{i32 786445, metadata !1140, metadata !1173, metadata !"id_l_", i32 1530, i64 0, i64 8, i64 128, i32 0, metadata !1143} ; [ DW_TAG_member ] [id_l_] [line 1530, size 0, align 8, offset 128] [from ]
!1184 = metadata !{i32 786445, metadata !1140, metadata !1173, metadata !"id", i32 1530, i64 64, i64 64, i64 128, i32 0, metadata !1163} ; [ DW_TAG_member ] [id] [line 1530, size 64, align 64, offset 128] [from id_t]
!1185 = metadata !{i32 786445, metadata !1140, metadata !1173, metadata !"id_r_", i32 1530, i64 0, i64 8, i64 192, i32 0, metadata !1143} ; [ DW_TAG_member ] [id_r_] [line 1530, size 0, align 8, offset 192] [from ]
!1186 = metadata !{i32 786445, metadata !1140, metadata !1173, metadata !"setid_l_", i32 1531, i64 0, i64 8, i64 192, i32 0, metadata !1143} ; [ DW_TAG_member ] [setid_l_] [line 1531, size 0, align 8, offset 192] [from ]
!1187 = metadata !{i32 786445, metadata !1140, metadata !1173, metadata !"setid", i32 1531, i64 64, i64 64, i64 192, i32 0, metadata !1147} ; [ DW_TAG_member ] [setid] [line 1531, size 64, align 64, offset 192] [from ]
!1188 = metadata !{i32 786445, metadata !1140, metadata !1173, metadata !"setid_r_", i32 1531, i64 0, i64 8, i64 256, i32 0, metadata !1143} ; [ DW_TAG_member ] [setid_r_] [line 1531, size 0, align 8, offset 256] [from ]
!1189 = metadata !{i32 786478, metadata !1, metadata !1105, metadata !"sys_cpuset_getaffinity", metadata !"sys_cpuset_getaffinity", metadata !"", i32 969, metadata !1190, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.cpuset_getaffinity_args*)* @sys_cpuset_getaffinity, null, null, metadata !1102, i32 970} ; [ DW_TAG_subprogram ] [line 969] [def] [scope 970] [sys_cpuset_getaffinity]
!1190 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1191, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1191 = metadata !{metadata !93, metadata !18, metadata !1192}
!1192 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1193} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from cpuset_getaffinity_args]
!1193 = metadata !{i32 786451, metadata !1140, null, metadata !"cpuset_getaffinity_args", i32 1533, i64 320, i64 64, i32 0, i32 0, null, metadata !1194, i32 0, null, null} ; [ DW_TAG_structure_type ] [cpuset_getaffinity_args] [line 1533, size 320, align 64, offset 0] [from ]
!1194 = metadata !{metadata !1195, metadata !1196, metadata !1197, metadata !1198, metadata !1199, metadata !1200, metadata !1201, metadata !1202, metadata !1203, metadata !1204, metadata !1205, metadata !1207, metadata !1208, metadata !1209, metadata !1210}
!1195 = metadata !{i32 786445, metadata !1140, metadata !1193, metadata !"level_l_", i32 1534, i64 0, i64 8, i64 0, i32 0, metadata !1143} ; [ DW_TAG_member ] [level_l_] [line 1534, size 0, align 8, offset 0] [from ]
!1196 = metadata !{i32 786445, metadata !1140, metadata !1193, metadata !"level", i32 1534, i64 32, i64 32, i64 0, i32 0, metadata !1177} ; [ DW_TAG_member ] [level] [line 1534, size 32, align 32, offset 0] [from cpulevel_t]
!1197 = metadata !{i32 786445, metadata !1140, metadata !1193, metadata !"level_r_", i32 1534, i64 32, i64 8, i64 32, i32 0, metadata !1160} ; [ DW_TAG_member ] [level_r_] [line 1534, size 32, align 8, offset 32] [from ]
!1198 = metadata !{i32 786445, metadata !1140, metadata !1193, metadata !"which_l_", i32 1535, i64 0, i64 8, i64 64, i32 0, metadata !1143} ; [ DW_TAG_member ] [which_l_] [line 1535, size 0, align 8, offset 64] [from ]
!1199 = metadata !{i32 786445, metadata !1140, metadata !1193, metadata !"which", i32 1535, i64 32, i64 32, i64 64, i32 0, metadata !1157} ; [ DW_TAG_member ] [which] [line 1535, size 32, align 32, offset 64] [from cpuwhich_t]
!1200 = metadata !{i32 786445, metadata !1140, metadata !1193, metadata !"which_r_", i32 1535, i64 32, i64 8, i64 96, i32 0, metadata !1160} ; [ DW_TAG_member ] [which_r_] [line 1535, size 32, align 8, offset 96] [from ]
!1201 = metadata !{i32 786445, metadata !1140, metadata !1193, metadata !"id_l_", i32 1536, i64 0, i64 8, i64 128, i32 0, metadata !1143} ; [ DW_TAG_member ] [id_l_] [line 1536, size 0, align 8, offset 128] [from ]
!1202 = metadata !{i32 786445, metadata !1140, metadata !1193, metadata !"id", i32 1536, i64 64, i64 64, i64 128, i32 0, metadata !1163} ; [ DW_TAG_member ] [id] [line 1536, size 64, align 64, offset 128] [from id_t]
!1203 = metadata !{i32 786445, metadata !1140, metadata !1193, metadata !"id_r_", i32 1536, i64 0, i64 8, i64 192, i32 0, metadata !1143} ; [ DW_TAG_member ] [id_r_] [line 1536, size 0, align 8, offset 192] [from ]
!1204 = metadata !{i32 786445, metadata !1140, metadata !1193, metadata !"cpusetsize_l_", i32 1537, i64 0, i64 8, i64 192, i32 0, metadata !1143} ; [ DW_TAG_member ] [cpusetsize_l_] [line 1537, size 0, align 8, offset 192] [from ]
!1205 = metadata !{i32 786445, metadata !1140, metadata !1193, metadata !"cpusetsize", i32 1537, i64 64, i64 64, i64 192, i32 0, metadata !1206} ; [ DW_TAG_member ] [cpusetsize] [line 1537, size 64, align 64, offset 192] [from size_t]
!1206 = metadata !{i32 786454, metadata !1, null, metadata !"size_t", i32 196, i64 0, i64 0, i64 0, i32 0, metadata !491} ; [ DW_TAG_typedef ] [size_t] [line 196, size 0, align 0, offset 0] [from __size_t]
!1207 = metadata !{i32 786445, metadata !1140, metadata !1193, metadata !"cpusetsize_r_", i32 1537, i64 0, i64 8, i64 256, i32 0, metadata !1143} ; [ DW_TAG_member ] [cpusetsize_r_] [line 1537, size 0, align 8, offset 256] [from ]
!1208 = metadata !{i32 786445, metadata !1140, metadata !1193, metadata !"mask_l_", i32 1538, i64 0, i64 8, i64 256, i32 0, metadata !1143} ; [ DW_TAG_member ] [mask_l_] [line 1538, size 0, align 8, offset 256] [from ]
!1209 = metadata !{i32 786445, metadata !1140, metadata !1193, metadata !"mask", i32 1538, i64 64, i64 64, i64 256, i32 0, metadata !1122} ; [ DW_TAG_member ] [mask] [line 1538, size 64, align 64, offset 256] [from ]
!1210 = metadata !{i32 786445, metadata !1140, metadata !1193, metadata !"mask_r_", i32 1538, i64 0, i64 8, i64 320, i32 0, metadata !1143} ; [ DW_TAG_member ] [mask_r_] [line 1538, size 0, align 8, offset 320] [from ]
!1211 = metadata !{i32 786478, metadata !1, metadata !1105, metadata !"sys_cpuset_setaffinity", metadata !"sys_cpuset_setaffinity", metadata !"", i32 1059, metadata !1212, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.thread*, %struct.cpuset_setaffinity_args*)* @sys_cpuset_setaffinity, null, null, metadata !1102, i32 1060} ; [ DW_TAG_subprogram ] [line 1059] [def] [scope 1060] [sys_cpuset_setaffinity]
!1212 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1213, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1213 = metadata !{metadata !93, metadata !18, metadata !1214}
!1214 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1215} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from cpuset_setaffinity_args]
!1215 = metadata !{i32 786451, metadata !1140, null, metadata !"cpuset_setaffinity_args", i32 1540, i64 320, i64 64, i32 0, i32 0, null, metadata !1216, i32 0, null, null} ; [ DW_TAG_structure_type ] [cpuset_setaffinity_args] [line 1540, size 320, align 64, offset 0] [from ]
!1216 = metadata !{metadata !1217, metadata !1218, metadata !1219, metadata !1220, metadata !1221, metadata !1222, metadata !1223, metadata !1224, metadata !1225, metadata !1226, metadata !1227, metadata !1228, metadata !1229, metadata !1230, metadata !1231}
!1217 = metadata !{i32 786445, metadata !1140, metadata !1215, metadata !"level_l_", i32 1541, i64 0, i64 8, i64 0, i32 0, metadata !1143} ; [ DW_TAG_member ] [level_l_] [line 1541, size 0, align 8, offset 0] [from ]
!1218 = metadata !{i32 786445, metadata !1140, metadata !1215, metadata !"level", i32 1541, i64 32, i64 32, i64 0, i32 0, metadata !1177} ; [ DW_TAG_member ] [level] [line 1541, size 32, align 32, offset 0] [from cpulevel_t]
!1219 = metadata !{i32 786445, metadata !1140, metadata !1215, metadata !"level_r_", i32 1541, i64 32, i64 8, i64 32, i32 0, metadata !1160} ; [ DW_TAG_member ] [level_r_] [line 1541, size 32, align 8, offset 32] [from ]
!1220 = metadata !{i32 786445, metadata !1140, metadata !1215, metadata !"which_l_", i32 1542, i64 0, i64 8, i64 64, i32 0, metadata !1143} ; [ DW_TAG_member ] [which_l_] [line 1542, size 0, align 8, offset 64] [from ]
!1221 = metadata !{i32 786445, metadata !1140, metadata !1215, metadata !"which", i32 1542, i64 32, i64 32, i64 64, i32 0, metadata !1157} ; [ DW_TAG_member ] [which] [line 1542, size 32, align 32, offset 64] [from cpuwhich_t]
!1222 = metadata !{i32 786445, metadata !1140, metadata !1215, metadata !"which_r_", i32 1542, i64 32, i64 8, i64 96, i32 0, metadata !1160} ; [ DW_TAG_member ] [which_r_] [line 1542, size 32, align 8, offset 96] [from ]
!1223 = metadata !{i32 786445, metadata !1140, metadata !1215, metadata !"id_l_", i32 1543, i64 0, i64 8, i64 128, i32 0, metadata !1143} ; [ DW_TAG_member ] [id_l_] [line 1543, size 0, align 8, offset 128] [from ]
!1224 = metadata !{i32 786445, metadata !1140, metadata !1215, metadata !"id", i32 1543, i64 64, i64 64, i64 128, i32 0, metadata !1163} ; [ DW_TAG_member ] [id] [line 1543, size 64, align 64, offset 128] [from id_t]
!1225 = metadata !{i32 786445, metadata !1140, metadata !1215, metadata !"id_r_", i32 1543, i64 0, i64 8, i64 192, i32 0, metadata !1143} ; [ DW_TAG_member ] [id_r_] [line 1543, size 0, align 8, offset 192] [from ]
!1226 = metadata !{i32 786445, metadata !1140, metadata !1215, metadata !"cpusetsize_l_", i32 1544, i64 0, i64 8, i64 192, i32 0, metadata !1143} ; [ DW_TAG_member ] [cpusetsize_l_] [line 1544, size 0, align 8, offset 192] [from ]
!1227 = metadata !{i32 786445, metadata !1140, metadata !1215, metadata !"cpusetsize", i32 1544, i64 64, i64 64, i64 192, i32 0, metadata !1206} ; [ DW_TAG_member ] [cpusetsize] [line 1544, size 64, align 64, offset 192] [from size_t]
!1228 = metadata !{i32 786445, metadata !1140, metadata !1215, metadata !"cpusetsize_r_", i32 1544, i64 0, i64 8, i64 256, i32 0, metadata !1143} ; [ DW_TAG_member ] [cpusetsize_r_] [line 1544, size 0, align 8, offset 256] [from ]
!1229 = metadata !{i32 786445, metadata !1140, metadata !1215, metadata !"mask_l_", i32 1545, i64 0, i64 8, i64 256, i32 0, metadata !1143} ; [ DW_TAG_member ] [mask_l_] [line 1545, size 0, align 8, offset 256] [from ]
!1230 = metadata !{i32 786445, metadata !1140, metadata !1215, metadata !"mask", i32 1545, i64 64, i64 64, i64 256, i32 0, metadata !1114} ; [ DW_TAG_member ] [mask] [line 1545, size 64, align 64, offset 256] [from ]
!1231 = metadata !{i32 786445, metadata !1140, metadata !1215, metadata !"mask_r_", i32 1545, i64 0, i64 8, i64 320, i32 0, metadata !1143} ; [ DW_TAG_member ] [mask_r_] [line 1545, size 0, align 8, offset 320] [from ]
!1232 = metadata !{i32 786478, metadata !1, metadata !1105, metadata !"cpusets_show_del", metadata !"cpusets_show_del", metadata !"", i32 1156, metadata !567, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i8*)* @cpusets_show_del, null, null, metadata !1102, i32 1156} ; [ DW_TAG_subprogram ] [line 1156] [local] [def] [cpusets_show_del]
!1233 = metadata !{i32 786478, metadata !1, metadata !1105, metadata !"db_show_cpusets", metadata !"db_show_cpusets", metadata !"", i32 1156, metadata !1234, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i64, i32, i64, i8*)* @db_show_cpusets, null, null, metadata !1102, i32 1157} ; [ DW_TAG_subprogram ] [line 1156] [local] [def] [scope 1157] [db_show_cpusets]
!1234 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1235, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1235 = metadata !{null, metadata !1236, metadata !1238, metadata !1236, metadata !489}
!1236 = metadata !{i32 786454, metadata !1237, null, metadata !"db_expr_t", i32 36, i64 0, i64 0, i64 0, i32 0, metadata !87} ; [ DW_TAG_typedef ] [db_expr_t] [line 36, size 0, align 0, offset 0] [from long int]
!1237 = metadata !{metadata !"/home/jra40/P4/tesla/sys/ddb/ddb.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!1238 = metadata !{i32 786454, metadata !1237, null, metadata !"boolean_t", i32 244, i64 0, i64 0, i64 0, i32 0, metadata !93} ; [ DW_TAG_typedef ] [boolean_t] [line 244, size 0, align 0, offset 0] [from int]
!1239 = metadata !{i32 786478, metadata !1, metadata !1105, metadata !"cpusets_show_add", metadata !"cpusets_show_add", metadata !"", i32 1156, metadata !567, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i8*)* @cpusets_show_add, null, null, metadata !1102, i32 1156} ; [ DW_TAG_subprogram ] [line 1156] [local] [def] [cpusets_show_add]
!1240 = metadata !{i32 786478, metadata !1, metadata !1105, metadata !"cpuset_modify", metadata !"cpuset_modify", metadata !"", i32 351, metadata !1241, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.cpuset*, %struct._cpuset*)* @cpuset_modify, null, null, metadata !1102, i32 352} ; [ DW_TAG_subprogram ] [line 351] [local] [def] [scope 352] [cpuset_modify]
!1241 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1242, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1242 = metadata !{metadata !93, metadata !77, metadata !1122}
!1243 = metadata !{i32 786478, metadata !1, metadata !1105, metadata !"cpuset_update", metadata !"cpuset_update", metadata !"", i32 333, metadata !1244, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (%struct.cpuset*, %struct._cpuset*)* @cpuset_update, null, null, metadata !1102, i32 334} ; [ DW_TAG_subprogram ] [line 333] [local] [def] [scope 334] [cpuset_update]
!1244 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1245, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1245 = metadata !{null, metadata !77, metadata !1122}
!1246 = metadata !{i32 786478, metadata !1, metadata !1105, metadata !"cpuset_testupdate", metadata !"cpuset_testupdate", metadata !"", i32 309, metadata !1241, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.cpuset*, %struct._cpuset*)* @cpuset_testupdate, null, null, metadata !1102, i32 310} ; [ DW_TAG_subprogram ] [line 309] [local] [def] [scope 310] [cpuset_testupdate]
!1247 = metadata !{i32 786478, metadata !526, metadata !1248, metadata !"__curthread", metadata !"__curthread", metadata !"", i32 232, metadata !1249, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, %struct.thread* ()* @__curthread, null, null, metadata !1102, i32 233} ; [ DW_TAG_subprogram ] [line 232] [local] [def] [scope 233] [__curthread]
!1248 = metadata !{i32 786473, metadata !526}     ; [ DW_TAG_file_type ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA/./machine/pcpu.h]
!1249 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1250, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1250 = metadata !{metadata !18}
!1251 = metadata !{i32 786478, metadata !1, metadata !1105, metadata !"cpuset_refbase", metadata !"cpuset_refbase", metadata !"", i32 153, metadata !1106, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, %struct.cpuset* (%struct.cpuset*)* @cpuset_refbase, null, null, metadata !1102, i32 154} ; [ DW_TAG_subprogram ] [line 153] [local] [def] [scope 154] [cpuset_refbase]
!1252 = metadata !{i32 786478, metadata !1, metadata !1105, metadata !"cpuset_lookup", metadata !"cpuset_lookup", metadata !"", i32 219, metadata !1253, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, %struct.cpuset* (i32, %struct.thread*)* @cpuset_lookup, null, null, metadata !1102, i32 220} ; [ DW_TAG_subprogram ] [line 219] [local] [def] [scope 220] [cpuset_lookup]
!1253 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1254, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1254 = metadata !{metadata !77, metadata !95, metadata !18}
!1255 = metadata !{i32 786478, metadata !1, metadata !1105, metadata !"cpuset_refroot", metadata !"cpuset_refroot", metadata !"", i32 136, metadata !1106, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, %struct.cpuset* (%struct.cpuset*)* @cpuset_refroot, null, null, metadata !1102, i32 137} ; [ DW_TAG_subprogram ] [line 136] [local] [def] [scope 137] [cpuset_refroot]
!1256 = metadata !{i32 786478, metadata !1, metadata !1105, metadata !"cpuset_init", metadata !"cpuset_init", metadata !"", i32 840, metadata !567, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i8*)* @cpuset_init, null, null, metadata !1102, i32 841} ; [ DW_TAG_subprogram ] [line 840] [local] [def] [scope 841] [cpuset_init]
!1257 = metadata !{i32 786478, metadata !1, metadata !1105, metadata !"cpuset_setproc", metadata !"cpuset_setproc", metadata !"", i32 509, metadata !1258, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32, %struct.cpuset*, %struct._cpuset*)* @cpuset_setproc, null, null, metadata !1102, i32 510} ; [ DW_TAG_subprogram ] [line 509] [local] [def] [scope 510] [cpuset_setproc]
!1258 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1259, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1259 = metadata !{metadata !93, metadata !421, metadata !77, metadata !1122}
!1260 = metadata !{i32 786478, metadata !1, metadata !1105, metadata !"cpuset_rel_complete", metadata !"cpuset_rel_complete", metadata !"", i32 208, metadata !1109, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (%struct.cpuset*)* @cpuset_rel_complete, null, null, metadata !1102, i32 209} ; [ DW_TAG_subprogram ] [line 208] [local] [def] [scope 209] [cpuset_rel_complete]
!1261 = metadata !{i32 786478, metadata !1, metadata !1105, metadata !"cpuset_rel_defer", metadata !"cpuset_rel_defer", metadata !"", i32 190, metadata !1262, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (%struct.setlist*, %struct.cpuset*)* @cpuset_rel_defer, null, null, metadata !1102, i32 191} ; [ DW_TAG_subprogram ] [line 190] [local] [def] [scope 191] [cpuset_rel_defer]
!1262 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1263, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1263 = metadata !{null, metadata !1264, metadata !77}
!1264 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !110} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from setlist]
!1265 = metadata !{i32 786478, metadata !1, metadata !1105, metadata !"cpuset_create", metadata !"cpuset_create", metadata !"", i32 284, metadata !1266, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.cpuset**, %struct.cpuset*, %struct._cpuset*)* @cpuset_create, null, null, metadata !1102, i32 285} ; [ DW_TAG_subprogram ] [line 284] [local] [def] [scope 285] [cpuset_create]
!1266 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1267, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1267 = metadata !{metadata !93, metadata !103, metadata !77, metadata !1114}
!1268 = metadata !{i32 786478, metadata !1, metadata !1105, metadata !"_cpuset_create", metadata !"_cpuset_create", metadata !"", i32 256, metadata !1269, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.cpuset*, %struct.cpuset*, %struct._cpuset*, i32)* @_cpuset_create, null, null, metadata !1102, i32 258} ; [ DW_TAG_subprogram ] [line 256] [local] [def] [scope 258] [_cpuset_create]
!1269 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1270, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1270 = metadata !{metadata !93, metadata !77, metadata !77, metadata !1114, metadata !95}
!1271 = metadata !{i32 786478, metadata !1272, metadata !1273, metadata !"refcount_init", metadata !"refcount_init", metadata !"", i32 45, metadata !1274, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i32*, i32)* @refcount_init, null, null, metadata !1102, i32 46} ; [ DW_TAG_subprogram ] [line 45] [local] [def] [scope 46] [refcount_init]
!1272 = metadata !{metadata !"/home/jra40/P4/tesla/sys/sys/refcount.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!1273 = metadata !{i32 786473, metadata !1272}    ; [ DW_TAG_file_type ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/sys/refcount.h]
!1274 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1275, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1275 = metadata !{null, metadata !1276, metadata !36}
!1276 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !91} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!1277 = metadata !{i32 786478, metadata !1, metadata !1105, metadata !"cpuset_shadow", metadata !"cpuset_shadow", metadata !"", i32 482, metadata !1278, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.cpuset*, %struct.cpuset*, %struct._cpuset*)* @cpuset_shadow, null, null, metadata !1102, i32 483} ; [ DW_TAG_subprogram ] [line 482] [local] [def] [scope 483] [cpuset_shadow]
!1278 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1279, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1279 = metadata !{metadata !93, metadata !77, metadata !77, metadata !1114}
!1280 = metadata !{i32 786478, metadata !1, metadata !1105, metadata !"cpuset_which", metadata !"cpuset_which", metadata !"", i32 399, metadata !1281, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32, i64, %struct.proc**, %struct.thread**, %struct.cpuset**)* @cpuset_which, null, null, metadata !1102, i32 401} ; [ DW_TAG_subprogram ] [line 399] [local] [def] [scope 401] [cpuset_which]
!1281 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1282, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1282 = metadata !{metadata !93, metadata !1157, metadata !1163, metadata !13, metadata !55, metadata !103}
!1283 = metadata !{i32 786478, metadata !1284, metadata !1285, metadata !"uma_zalloc", metadata !"uma_zalloc", metadata !"", i32 311, metadata !1286, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, i8* (%struct.uma_zone*, i32)* @uma_zalloc, null, null, metadata !1102, i32 312} ; [ DW_TAG_subprogram ] [line 311] [local] [def] [scope 312] [uma_zalloc]
!1284 = metadata !{metadata !"/home/jra40/P4/tesla/sys/vm/uma.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!1285 = metadata !{i32 786473, metadata !1284}    ; [ DW_TAG_file_type ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/vm/uma.h]
!1286 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1287, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1287 = metadata !{metadata !178, metadata !1288, metadata !93}
!1288 = metadata !{i32 786454, metadata !1, null, metadata !"uma_zone_t", i32 49, i64 0, i64 0, i64 0, i32 0, metadata !1289} ; [ DW_TAG_typedef ] [uma_zone_t] [line 49, size 0, align 0, offset 0] [from ]
!1289 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1290} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from uma_zone]
!1290 = metadata !{i32 786451, metadata !1284, null, metadata !"uma_zone", i32 47, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [uma_zone] [line 47, size 0, align 0, offset 0] [fwd] [from ]
!1291 = metadata !{i32 786478, metadata !1292, metadata !1293, metadata !"ffsl", metadata !"ffsl", metadata !"", i32 152, metadata !1294, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i64)* @ffsl, null, null, metadata !1102, i32 153} ; [ DW_TAG_subprogram ] [line 152] [local] [def] [scope 153] [ffsl]
!1292 = metadata !{metadata !"./machine/cpufunc.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!1293 = metadata !{i32 786473, metadata !1292}    ; [ DW_TAG_file_type ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA/./machine/cpufunc.h]
!1294 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1295, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1295 = metadata !{metadata !93, metadata !87}
!1296 = metadata !{i32 786478, metadata !1292, metadata !1293, metadata !"bsfq", metadata !"bsfq", metadata !"", i32 76, metadata !1297, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, i64 (i64)* @bsfq, null, null, metadata !1102, i32 77} ; [ DW_TAG_subprogram ] [line 76] [local] [def] [scope 77] [bsfq]
!1297 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1298, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1298 = metadata !{metadata !495, metadata !495}
!1299 = metadata !{i32 786478, metadata !1284, metadata !1285, metadata !"uma_zfree", metadata !"uma_zfree", metadata !"", i32 339, metadata !1300, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (%struct.uma_zone*, i8*)* @uma_zfree, null, null, metadata !1102, i32 340} ; [ DW_TAG_subprogram ] [line 339] [local] [def] [scope 340] [uma_zfree]
!1300 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1301, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1301 = metadata !{null, metadata !1288, metadata !178}
!1302 = metadata !{i32 786478, metadata !1272, metadata !1273, metadata !"refcount_release", metadata !"refcount_release", metadata !"", i32 60, metadata !1303, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32*)* @refcount_release, null, null, metadata !1102, i32 61} ; [ DW_TAG_subprogram ] [line 60] [local] [def] [scope 61] [refcount_release]
!1303 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1304, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1304 = metadata !{metadata !93, metadata !1276}
!1305 = metadata !{i32 786478, metadata !1306, metadata !1307, metadata !"atomic_fetchadd_int", metadata !"atomic_fetchadd_int", metadata !"", i32 181, metadata !1308, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32*, i32)* @atomic_fetchadd_int, null, null, metadata !1102, i32 182} ; [ DW_TAG_subprogram ] [line 181] [local] [def] [scope 182] [atomic_fetchadd_int]
!1306 = metadata !{metadata !"./machine/atomic.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!1307 = metadata !{i32 786473, metadata !1306}    ; [ DW_TAG_file_type ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA/./machine/atomic.h]
!1308 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1309, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1309 = metadata !{metadata !36, metadata !1276, metadata !36}
!1310 = metadata !{i32 786478, metadata !1272, metadata !1273, metadata !"refcount_acquire", metadata !"refcount_acquire", metadata !"", i32 52, metadata !1311, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i32*)* @refcount_acquire, null, null, metadata !1102, i32 53} ; [ DW_TAG_subprogram ] [line 52] [local] [def] [scope 53] [refcount_acquire]
!1311 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1312, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1312 = metadata !{null, metadata !1276}
!1313 = metadata !{i32 786478, metadata !1306, metadata !1307, metadata !"atomic_add_barr_int", metadata !"atomic_add_barr_int", metadata !"", i32 282, metadata !1274, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i32*, i32)* @atomic_add_barr_int, null, null, metadata !1102, i32 282} ; [ DW_TAG_subprogram ] [line 282] [local] [def] [atomic_add_barr_int]
!1314 = metadata !{metadata !1315, metadata !1319, metadata !1320, metadata !1321, metadata !1322, metadata !1323, metadata !1324, metadata !1325, metadata !1328, metadata !1329, metadata !1330, metadata !1341, metadata !1361, metadata !1362, metadata !1363}
!1315 = metadata !{i32 786484, i32 0, null, metadata !"__set_sysctl_set_sym_sysctl___kern_sched_cpusetsize", metadata !"__set_sysctl_set_sym_sysctl___kern_sched_cpusetsize", metadata !"", metadata !1105, i32 115, metadata !1316, i32 1, i32 1, i8** @__set_sysctl_set_sym_sysctl___kern_sched_cpusetsize, null} ; [ DW_TAG_variable ] [__set_sysctl_set_sym_sysctl___kern_sched_cpusetsize] [line 115] [local] [def]
!1316 = metadata !{i32 786470, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !1317} ; [ DW_TAG_const_type ] [line 0, size 0, align 0, offset 0] [from ]
!1317 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1318} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!1318 = metadata !{i32 786470, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null} ; [ DW_TAG_const_type ] [line 0, size 0, align 0, offset 0] [from ]
!1319 = metadata !{i32 786484, i32 0, null, metadata !"__set_sysinit_set_sym_cpuset_sys_init", metadata !"__set_sysinit_set_sym_cpuset_sys_init", metadata !"", metadata !1105, i32 849, metadata !1316, i32 1, i32 1, i8** @__set_sysinit_set_sym_cpuset_sys_init, null} ; [ DW_TAG_variable ] [__set_sysinit_set_sym_cpuset_sys_init] [line 849] [local] [def]
!1320 = metadata !{i32 786484, i32 0, null, metadata !"__set_sysinit_set_sym_cpusets_show_sys_init", metadata !"__set_sysinit_set_sym_cpusets_show_sys_init", metadata !"", metadata !1105, i32 1156, metadata !1316, i32 1, i32 1, i8** @__set_sysinit_set_sym_cpusets_show_sys_init, null} ; [ DW_TAG_variable ] [__set_sysinit_set_sym_cpusets_show_sys_init] [line 1156] [local] [def]
!1321 = metadata !{i32 786484, i32 0, null, metadata !"__set_sysuninit_set_sym_cpusets_show_sys_uninit", metadata !"__set_sysuninit_set_sym_cpusets_show_sys_uninit", metadata !"", metadata !1105, i32 1156, metadata !1316, i32 1, i32 1, i8** @__set_sysuninit_set_sym_cpusets_show_sys_uninit, null} ; [ DW_TAG_variable ] [__set_sysuninit_set_sym_cpusets_show_sys_uninit] [line 1156] [local] [def]
!1322 = metadata !{i32 786484, i32 0, null, metadata !"cpuset_zone", metadata !"cpuset_zone", metadata !"", metadata !1105, i32 108, metadata !1288, i32 1, i32 1, %struct.uma_zone** @cpuset_zone, null} ; [ DW_TAG_variable ] [cpuset_zone] [line 108] [local] [def]
!1323 = metadata !{i32 786484, i32 0, null, metadata !"cpuset_lock", metadata !"cpuset_lock", metadata !"", metadata !1105, i32 109, metadata !24, i32 1, i32 1, %struct.mtx* @cpuset_lock, null} ; [ DW_TAG_variable ] [cpuset_lock] [line 109] [local] [def]
!1324 = metadata !{i32 786484, i32 0, null, metadata !"cpuset_ids", metadata !"cpuset_ids", metadata !"", metadata !1105, i32 110, metadata !110, i32 1, i32 1, %struct.setlist* @cpuset_ids, null} ; [ DW_TAG_variable ] [cpuset_ids] [line 110] [local] [def]
!1325 = metadata !{i32 786484, i32 0, null, metadata !"cpuset_unr", metadata !"cpuset_unr", metadata !"", metadata !1105, i32 111, metadata !1326, i32 1, i32 1, %struct.unrhdr** @cpuset_unr, null} ; [ DW_TAG_variable ] [cpuset_unr] [line 111] [local] [def]
!1326 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1327} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from unrhdr]
!1327 = metadata !{i32 786451, metadata !786, null, metadata !"unrhdr", i32 397, i64 0, i64 0, i32 0, i32 4, null, null, i32 0} ; [ DW_TAG_structure_type ] [unrhdr] [line 397, size 0, align 0, offset 0] [fwd] [from ]
!1328 = metadata !{i32 786484, i32 0, null, metadata !"cpuset_zero", metadata !"cpuset_zero", metadata !"", metadata !1105, i32 112, metadata !77, i32 1, i32 1, %struct.cpuset** @cpuset_zero, null} ; [ DW_TAG_variable ] [cpuset_zero] [line 112] [local] [def]
!1329 = metadata !{i32 786484, i32 0, null, metadata !"cpuset_root", metadata !"cpuset_root", metadata !"", metadata !1105, i32 118, metadata !1122, i32 0, i32 1, %struct._cpuset** @cpuset_root, null} ; [ DW_TAG_variable ] [cpuset_root] [line 118] [def]
!1330 = metadata !{i32 786484, i32 0, null, metadata !"cpusets_show_sys_uninit", metadata !"cpusets_show_sys_uninit", metadata !"", metadata !1105, i32 1156, metadata !1331, i32 1, i32 1, %struct.sysinit* @cpusets_show_sys_uninit, null} ; [ DW_TAG_variable ] [cpusets_show_sys_uninit] [line 1156] [local] [def]
!1331 = metadata !{i32 786451, metadata !1011, null, metadata !"sysinit", i32 212, i64 192, i64 64, i32 0, i32 0, null, metadata !1332, i32 0, null, null} ; [ DW_TAG_structure_type ] [sysinit] [line 212, size 192, align 64, offset 0] [from ]
!1332 = metadata !{metadata !1333, metadata !1334, metadata !1335, metadata !1340}
!1333 = metadata !{i32 786445, metadata !1011, metadata !1331, metadata !"subsystem", i32 213, i64 32, i64 32, i64 0, i32 0, metadata !1010} ; [ DW_TAG_member ] [subsystem] [line 213, size 32, align 32, offset 0] [from sysinit_sub_id]
!1334 = metadata !{i32 786445, metadata !1011, metadata !1331, metadata !"order", i32 214, i64 32, i64 32, i64 32, i32 0, metadata !1094} ; [ DW_TAG_member ] [order] [line 214, size 32, align 32, offset 32] [from sysinit_elem_order]
!1335 = metadata !{i32 786445, metadata !1011, metadata !1331, metadata !"func", i32 215, i64 64, i64 64, i64 64, i32 0, metadata !1336} ; [ DW_TAG_member ] [func] [line 215, size 64, align 64, offset 64] [from sysinit_cfunc_t]
!1336 = metadata !{i32 786454, metadata !1011, null, metadata !"sysinit_cfunc_t", i32 210, i64 0, i64 0, i64 0, i32 0, metadata !1337} ; [ DW_TAG_typedef ] [sysinit_cfunc_t] [line 210, size 0, align 0, offset 0] [from ]
!1337 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1338} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!1338 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1339, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1339 = metadata !{null, metadata !1317}
!1340 = metadata !{i32 786445, metadata !1011, metadata !1331, metadata !"udata", i32 216, i64 64, i64 64, i64 128, i32 0, metadata !1317} ; [ DW_TAG_member ] [udata] [line 216, size 64, align 64, offset 128] [from ]
!1341 = metadata !{i32 786484, i32 0, null, metadata !"cpusets_show", metadata !"cpusets_show", metadata !"", metadata !1105, i32 1156, metadata !1342, i32 1, i32 1, %struct.command* @cpusets_show, null} ; [ DW_TAG_variable ] [cpusets_show] [line 1156] [local] [def]
!1342 = metadata !{i32 786451, metadata !1237, null, metadata !"command", i32 103, i64 384, i64 64, i32 0, i32 0, null, metadata !1343, i32 0, null, null} ; [ DW_TAG_structure_type ] [command] [line 103, size 384, align 64, offset 0] [from ]
!1343 = metadata !{metadata !1344, metadata !1345, metadata !1348, metadata !1349, metadata !1355}
!1344 = metadata !{i32 786445, metadata !1237, metadata !1342, metadata !"name", i32 104, i64 64, i64 64, i64 0, i32 0, metadata !489} ; [ DW_TAG_member ] [name] [line 104, size 64, align 64, offset 0] [from ]
!1345 = metadata !{i32 786445, metadata !1237, metadata !1342, metadata !"fcn", i32 105, i64 64, i64 64, i64 64, i32 0, metadata !1346} ; [ DW_TAG_member ] [fcn] [line 105, size 64, align 64, offset 64] [from ]
!1346 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1347} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from db_cmdfcn_t]
!1347 = metadata !{i32 786454, metadata !1237, null, metadata !"db_cmdfcn_t", i32 97, i64 0, i64 0, i64 0, i32 0, metadata !1234} ; [ DW_TAG_typedef ] [db_cmdfcn_t] [line 97, size 0, align 0, offset 0] [from ]
!1348 = metadata !{i32 786445, metadata !1237, metadata !1342, metadata !"flag", i32 106, i64 32, i64 32, i64 128, i32 0, metadata !93} ; [ DW_TAG_member ] [flag] [line 106, size 32, align 32, offset 128] [from int]
!1349 = metadata !{i32 786445, metadata !1237, metadata !1342, metadata !"more", i32 111, i64 64, i64 64, i64 192, i32 0, metadata !1350} ; [ DW_TAG_member ] [more] [line 111, size 64, align 64, offset 192] [from ]
!1350 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1351} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from command_table]
!1351 = metadata !{i32 786451, metadata !1237, null, metadata !"command_table", i32 89, i64 64, i64 64, i32 0, i32 0, null, metadata !1352, i32 0, null, null} ; [ DW_TAG_structure_type ] [command_table] [line 89, size 64, align 64, offset 0] [from ]
!1352 = metadata !{metadata !1353}
!1353 = metadata !{i32 786445, metadata !1237, metadata !1351, metadata !"lh_first", i32 89, i64 64, i64 64, i64 0, i32 0, metadata !1354} ; [ DW_TAG_member ] [lh_first] [line 89, size 64, align 64, offset 0] [from ]
!1354 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1342} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from command]
!1355 = metadata !{i32 786445, metadata !1237, metadata !1342, metadata !"next", i32 112, i64 128, i64 64, i64 256, i32 0, metadata !1356} ; [ DW_TAG_member ] [next] [line 112, size 128, align 64, offset 256] [from ]
!1356 = metadata !{i32 786451, metadata !1237, metadata !1342, metadata !"", i32 112, i64 128, i64 64, i32 0, i32 0, null, metadata !1357, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 112, size 128, align 64, offset 0] [from ]
!1357 = metadata !{metadata !1358, metadata !1359}
!1358 = metadata !{i32 786445, metadata !1237, metadata !1356, metadata !"le_next", i32 112, i64 64, i64 64, i64 0, i32 0, metadata !1354} ; [ DW_TAG_member ] [le_next] [line 112, size 64, align 64, offset 0] [from ]
!1359 = metadata !{i32 786445, metadata !1237, metadata !1356, metadata !"le_prev", i32 112, i64 64, i64 64, i64 64, i32 0, metadata !1360} ; [ DW_TAG_member ] [le_prev] [line 112, size 64, align 64, offset 64] [from ]
!1360 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1354} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!1361 = metadata !{i32 786484, i32 0, null, metadata !"cpusets_show_sys_init", metadata !"cpusets_show_sys_init", metadata !"", metadata !1105, i32 1156, metadata !1331, i32 1, i32 1, %struct.sysinit* @cpusets_show_sys_init, null} ; [ DW_TAG_variable ] [cpusets_show_sys_init] [line 1156] [local] [def]
!1362 = metadata !{i32 786484, i32 0, null, metadata !"cpuset_sys_init", metadata !"cpuset_sys_init", metadata !"", metadata !1105, i32 849, metadata !1331, i32 1, i32 1, %struct.sysinit* @cpuset_sys_init, null} ; [ DW_TAG_variable ] [cpuset_sys_init] [line 849] [local] [def]
!1363 = metadata !{i32 786484, i32 0, null, metadata !"sysctl___kern_sched_cpusetsize", metadata !"sysctl___kern_sched_cpusetsize", metadata !"", metadata !1105, i32 115, metadata !1364, i32 1, i32 1, %struct.sysctl_oid* @sysctl___kern_sched_cpusetsize, null} ; [ DW_TAG_variable ] [sysctl___kern_sched_cpusetsize] [line 115] [local] [def]
!1364 = metadata !{i32 786451, metadata !1365, null, metadata !"sysctl_oid", i32 163, i64 640, i64 64, i32 0, i32 0, null, metadata !1366, i32 0, null, null} ; [ DW_TAG_structure_type ] [sysctl_oid] [line 163, size 640, align 64, offset 0] [from ]
!1365 = metadata !{metadata !"/home/jra40/P4/tesla/sys/sys/sysctl.h", metadata !"/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA"}
!1366 = metadata !{metadata !1367, metadata !1373, metadata !1377, metadata !1378, metadata !1379, metadata !1380, metadata !1381, metadata !1382, metadata !1407, metadata !1408, metadata !1409, metadata !1410}
!1367 = metadata !{i32 786445, metadata !1365, metadata !1364, metadata !"oid_parent", i32 164, i64 64, i64 64, i64 0, i32 0, metadata !1368} ; [ DW_TAG_member ] [oid_parent] [line 164, size 64, align 64, offset 0] [from ]
!1368 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1369} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from sysctl_oid_list]
!1369 = metadata !{i32 786451, metadata !1365, null, metadata !"sysctl_oid_list", i32 157, i64 64, i64 64, i32 0, i32 0, null, metadata !1370, i32 0, null, null} ; [ DW_TAG_structure_type ] [sysctl_oid_list] [line 157, size 64, align 64, offset 0] [from ]
!1370 = metadata !{metadata !1371}
!1371 = metadata !{i32 786445, metadata !1365, metadata !1369, metadata !"slh_first", i32 157, i64 64, i64 64, i64 0, i32 0, metadata !1372} ; [ DW_TAG_member ] [slh_first] [line 157, size 64, align 64, offset 0] [from ]
!1372 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1364} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from sysctl_oid]
!1373 = metadata !{i32 786445, metadata !1365, metadata !1364, metadata !"oid_link", i32 165, i64 64, i64 64, i64 64, i32 0, metadata !1374} ; [ DW_TAG_member ] [oid_link] [line 165, size 64, align 64, offset 64] [from ]
!1374 = metadata !{i32 786451, metadata !1365, metadata !1364, metadata !"", i32 165, i64 64, i64 64, i32 0, i32 0, null, metadata !1375, i32 0, null, null} ; [ DW_TAG_structure_type ] [line 165, size 64, align 64, offset 0] [from ]
!1375 = metadata !{metadata !1376}
!1376 = metadata !{i32 786445, metadata !1365, metadata !1374, metadata !"sle_next", i32 165, i64 64, i64 64, i64 0, i32 0, metadata !1372} ; [ DW_TAG_member ] [sle_next] [line 165, size 64, align 64, offset 0] [from ]
!1377 = metadata !{i32 786445, metadata !1365, metadata !1364, metadata !"oid_number", i32 166, i64 32, i64 32, i64 128, i32 0, metadata !93} ; [ DW_TAG_member ] [oid_number] [line 166, size 32, align 32, offset 128] [from int]
!1378 = metadata !{i32 786445, metadata !1365, metadata !1364, metadata !"oid_kind", i32 167, i64 32, i64 32, i64 160, i32 0, metadata !36} ; [ DW_TAG_member ] [oid_kind] [line 167, size 32, align 32, offset 160] [from u_int]
!1379 = metadata !{i32 786445, metadata !1365, metadata !1364, metadata !"oid_arg1", i32 168, i64 64, i64 64, i64 192, i32 0, metadata !178} ; [ DW_TAG_member ] [oid_arg1] [line 168, size 64, align 64, offset 192] [from ]
!1380 = metadata !{i32 786445, metadata !1365, metadata !1364, metadata !"oid_arg2", i32 169, i64 64, i64 64, i64 256, i32 0, metadata !888} ; [ DW_TAG_member ] [oid_arg2] [line 169, size 64, align 64, offset 256] [from intptr_t]
!1381 = metadata !{i32 786445, metadata !1365, metadata !1364, metadata !"oid_name", i32 170, i64 64, i64 64, i64 320, i32 0, metadata !32} ; [ DW_TAG_member ] [oid_name] [line 170, size 64, align 64, offset 320] [from ]
!1382 = metadata !{i32 786445, metadata !1365, metadata !1364, metadata !"oid_handler", i32 171, i64 64, i64 64, i64 384, i32 0, metadata !1383} ; [ DW_TAG_member ] [oid_handler] [line 171, size 64, align 64, offset 384] [from ]
!1383 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1384} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!1384 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1385, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1385 = metadata !{metadata !93, metadata !1372, metadata !178, metadata !888, metadata !1386}
!1386 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1387} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from sysctl_req]
!1387 = metadata !{i32 786451, metadata !1365, null, metadata !"sysctl_req", i32 142, i64 768, i64 64, i32 0, i32 0, null, metadata !1388, i32 0, null, null} ; [ DW_TAG_structure_type ] [sysctl_req] [line 142, size 768, align 64, offset 0] [from ]
!1388 = metadata !{metadata !1389, metadata !1390, metadata !1391, metadata !1392, metadata !1393, metadata !1394, metadata !1398, metadata !1399, metadata !1400, metadata !1401, metadata !1405, metadata !1406}
!1389 = metadata !{i32 786445, metadata !1365, metadata !1387, metadata !"td", i32 143, i64 64, i64 64, i64 0, i32 0, metadata !18} ; [ DW_TAG_member ] [td] [line 143, size 64, align 64, offset 0] [from ]
!1390 = metadata !{i32 786445, metadata !1365, metadata !1387, metadata !"lock", i32 144, i64 32, i64 32, i64 64, i32 0, metadata !93} ; [ DW_TAG_member ] [lock] [line 144, size 32, align 32, offset 64] [from int]
!1391 = metadata !{i32 786445, metadata !1365, metadata !1387, metadata !"oldptr", i32 145, i64 64, i64 64, i64 128, i32 0, metadata !178} ; [ DW_TAG_member ] [oldptr] [line 145, size 64, align 64, offset 128] [from ]
!1392 = metadata !{i32 786445, metadata !1365, metadata !1387, metadata !"oldlen", i32 146, i64 64, i64 64, i64 192, i32 0, metadata !1206} ; [ DW_TAG_member ] [oldlen] [line 146, size 64, align 64, offset 192] [from size_t]
!1393 = metadata !{i32 786445, metadata !1365, metadata !1387, metadata !"oldidx", i32 147, i64 64, i64 64, i64 256, i32 0, metadata !1206} ; [ DW_TAG_member ] [oldidx] [line 147, size 64, align 64, offset 256] [from size_t]
!1394 = metadata !{i32 786445, metadata !1365, metadata !1387, metadata !"oldfunc", i32 148, i64 64, i64 64, i64 320, i32 0, metadata !1395} ; [ DW_TAG_member ] [oldfunc] [line 148, size 64, align 64, offset 320] [from ]
!1395 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1396} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!1396 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1397, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1397 = metadata !{metadata !93, metadata !1386, metadata !1317, metadata !1206}
!1398 = metadata !{i32 786445, metadata !1365, metadata !1387, metadata !"newptr", i32 149, i64 64, i64 64, i64 384, i32 0, metadata !178} ; [ DW_TAG_member ] [newptr] [line 149, size 64, align 64, offset 384] [from ]
!1399 = metadata !{i32 786445, metadata !1365, metadata !1387, metadata !"newlen", i32 150, i64 64, i64 64, i64 448, i32 0, metadata !1206} ; [ DW_TAG_member ] [newlen] [line 150, size 64, align 64, offset 448] [from size_t]
!1400 = metadata !{i32 786445, metadata !1365, metadata !1387, metadata !"newidx", i32 151, i64 64, i64 64, i64 512, i32 0, metadata !1206} ; [ DW_TAG_member ] [newidx] [line 151, size 64, align 64, offset 512] [from size_t]
!1401 = metadata !{i32 786445, metadata !1365, metadata !1387, metadata !"newfunc", i32 152, i64 64, i64 64, i64 576, i32 0, metadata !1402} ; [ DW_TAG_member ] [newfunc] [line 152, size 64, align 64, offset 576] [from ]
!1402 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !1403} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!1403 = metadata !{i32 786453, i32 0, i32 0, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !1404, i32 0, i32 0} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!1404 = metadata !{metadata !93, metadata !1386, metadata !178, metadata !1206}
!1405 = metadata !{i32 786445, metadata !1365, metadata !1387, metadata !"validlen", i32 153, i64 64, i64 64, i64 640, i32 0, metadata !1206} ; [ DW_TAG_member ] [validlen] [line 153, size 64, align 64, offset 640] [from size_t]
!1406 = metadata !{i32 786445, metadata !1365, metadata !1387, metadata !"flags", i32 154, i64 32, i64 32, i64 704, i32 0, metadata !93} ; [ DW_TAG_member ] [flags] [line 154, size 32, align 32, offset 704] [from int]
!1407 = metadata !{i32 786445, metadata !1365, metadata !1364, metadata !"oid_fmt", i32 172, i64 64, i64 64, i64 448, i32 0, metadata !32} ; [ DW_TAG_member ] [oid_fmt] [line 172, size 64, align 64, offset 448] [from ]
!1408 = metadata !{i32 786445, metadata !1365, metadata !1364, metadata !"oid_refcnt", i32 173, i64 32, i64 32, i64 512, i32 0, metadata !93} ; [ DW_TAG_member ] [oid_refcnt] [line 173, size 32, align 32, offset 512] [from int]
!1409 = metadata !{i32 786445, metadata !1365, metadata !1364, metadata !"oid_running", i32 174, i64 32, i64 32, i64 544, i32 0, metadata !36} ; [ DW_TAG_member ] [oid_running] [line 174, size 32, align 32, offset 544] [from u_int]
!1410 = metadata !{i32 786445, metadata !1365, metadata !1364, metadata !"oid_descr", i32 175, i64 64, i64 64, i64 576, i32 0, metadata !32} ; [ DW_TAG_member ] [oid_descr] [line 175, size 64, align 64, offset 576] [from ]
!1411 = metadata !{i32 786689, metadata !1104, metadata !"set", metadata !1105, i32 16777340, metadata !77, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [set] [line 124]
!1412 = metadata !{i32 124, i32 0, metadata !1104, null}
!1413 = metadata !{i32 127, i32 0, metadata !1104, null}
!1414 = metadata !{i32 128, i32 0, metadata !1104, null}
!1415 = metadata !{i32 786689, metadata !1310, metadata !"count", metadata !1273, i32 16777268, metadata !1276, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [count] [line 52]
!1416 = metadata !{i32 52, i32 0, metadata !1310, null}
!1417 = metadata !{i32 55, i32 0, metadata !1418, null}
!1418 = metadata !{i32 786443, metadata !1272, metadata !1310} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/sys/refcount.h]
!1419 = metadata !{i32 55, i32 0, metadata !1420, null}
!1420 = metadata !{i32 786443, metadata !1272, metadata !1418, i32 55, i32 0, i32 124} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/sys/refcount.h]
!1421 = metadata !{i32 56, i32 0, metadata !1418, null}
!1422 = metadata !{i32 57, i32 0, metadata !1418, null}
!1423 = metadata !{i32 786689, metadata !1108, metadata !"set", metadata !1105, i32 16777383, metadata !77, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [set] [line 167]
!1424 = metadata !{i32 167, i32 0, metadata !1108, null}
!1425 = metadata !{i32 786688, metadata !1108, metadata !"id", metadata !1105, i32 169, metadata !95, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [id] [line 169]
!1426 = metadata !{i32 169, i32 0, metadata !1108, null}
!1427 = metadata !{i32 171, i32 6, metadata !1108, null}
!1428 = metadata !{i32 172, i32 0, metadata !1108, null}
!1429 = metadata !{i32 173, i32 0, metadata !1108, null}
!1430 = metadata !{i32 174, i32 0, metadata !1108, null}
!1431 = metadata !{i32 174, i32 0, metadata !1432, null}
!1432 = metadata !{i32 786443, metadata !1, metadata !1108, i32 174, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1433 = metadata !{i32 174, i32 0, metadata !1434, null}
!1434 = metadata !{i32 786443, metadata !1, metadata !1432, i32 174, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1435 = metadata !{i32 174, i32 0, metadata !1436, null}
!1436 = metadata !{i32 786443, metadata !1, metadata !1432, i32 174, i32 0, i32 2} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1437 = metadata !{i32 175, i32 0, metadata !1108, null}
!1438 = metadata !{i32 176, i32 0, metadata !1108, null}
!1439 = metadata !{i32 177, i32 0, metadata !1108, null}
!1440 = metadata !{i32 177, i32 0, metadata !1441, null}
!1441 = metadata !{i32 786443, metadata !1, metadata !1108, i32 177, i32 0, i32 3} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1442 = metadata !{i32 177, i32 0, metadata !1443, null}
!1443 = metadata !{i32 786443, metadata !1, metadata !1441, i32 177, i32 0, i32 4} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1444 = metadata !{i32 177, i32 0, metadata !1445, null}
!1445 = metadata !{i32 786443, metadata !1, metadata !1441, i32 177, i32 0, i32 5} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1446 = metadata !{i32 178, i32 0, metadata !1108, null}
!1447 = metadata !{i32 179, i32 0, metadata !1108, null}
!1448 = metadata !{i32 180, i32 0, metadata !1108, null}
!1449 = metadata !{i32 181, i32 0, metadata !1108, null}
!1450 = metadata !{i32 182, i32 0, metadata !1108, null}
!1451 = metadata !{i32 786689, metadata !1302, metadata !"count", metadata !1273, i32 16777276, metadata !1276, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [count] [line 60]
!1452 = metadata !{i32 60, i32 0, metadata !1302, null}
!1453 = metadata !{i32 786688, metadata !1454, metadata !"old", metadata !1273, i32 62, metadata !36, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [old] [line 62]
!1454 = metadata !{i32 786443, metadata !1272, metadata !1302} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/sys/refcount.h]
!1455 = metadata !{i32 62, i32 0, metadata !1454, null}
!1456 = metadata !{i32 65, i32 8, metadata !1454, null}
!1457 = metadata !{i32 66, i32 0, metadata !1454, null}
!1458 = metadata !{i32 66, i32 0, metadata !1459, null}
!1459 = metadata !{i32 786443, metadata !1272, metadata !1454, i32 66, i32 0, i32 123} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/sys/refcount.h]
!1460 = metadata !{i32 67, i32 0, metadata !1454, null}
!1461 = metadata !{i32 786689, metadata !1299, metadata !"zone", metadata !1285, i32 16777555, metadata !1288, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [zone] [line 339]
!1462 = metadata !{i32 339, i32 0, metadata !1299, null}
!1463 = metadata !{i32 786689, metadata !1299, metadata !"item", metadata !1285, i32 33554771, metadata !178, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [item] [line 339]
!1464 = metadata !{i32 341, i32 0, metadata !1465, null}
!1465 = metadata !{i32 786443, metadata !1284, metadata !1299} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/vm/uma.h]
!1466 = metadata !{i32 342, i32 0, metadata !1465, null}
!1467 = metadata !{i32 786689, metadata !1111, metadata !"set", metadata !1105, i32 16777843, metadata !1114, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [set] [line 627]
!1468 = metadata !{i32 627, i32 0, metadata !1111, null}
!1469 = metadata !{i32 786688, metadata !1111, metadata !"i", metadata !1105, i32 629, metadata !1206, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 629]
!1470 = metadata !{i32 629, i32 0, metadata !1111, null}
!1471 = metadata !{i32 786688, metadata !1111, metadata !"cbit", metadata !1105, i32 630, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [cbit] [line 630]
!1472 = metadata !{i32 630, i32 0, metadata !1111, null}
!1473 = metadata !{i32 632, i32 0, metadata !1111, null}
!1474 = metadata !{i32 633, i32 0, metadata !1475, null}
!1475 = metadata !{i32 786443, metadata !1, metadata !1111, i32 633, i32 0, i32 6} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1476 = metadata !{i32 634, i32 0, metadata !1477, null}
!1477 = metadata !{i32 786443, metadata !1, metadata !1475, i32 633, i32 0, i32 7} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1478 = metadata !{i32 635, i32 11, metadata !1479, null}
!1479 = metadata !{i32 786443, metadata !1, metadata !1477, i32 634, i32 0, i32 8} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1480 = metadata !{i32 636, i32 0, metadata !1479, null}
!1481 = metadata !{i32 637, i32 0, metadata !1479, null}
!1482 = metadata !{i32 639, i32 0, metadata !1477, null}
!1483 = metadata !{i32 640, i32 0, metadata !1111, null}
!1484 = metadata !{i32 786689, metadata !1291, metadata !"mask", metadata !1293, i32 16777368, metadata !87, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [mask] [line 152]
!1485 = metadata !{i32 152, i32 0, metadata !1291, null}
!1486 = metadata !{i32 154, i32 0, metadata !1487, null}
!1487 = metadata !{i32 786443, metadata !1292, metadata !1291} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA/./machine/cpufunc.h]
!1488 = metadata !{i32 154, i32 34, metadata !1487, null}
!1489 = metadata !{i32 786689, metadata !1116, metadata !"buf", metadata !1105, i32 16777864, metadata !489, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [buf] [line 648]
!1490 = metadata !{i32 648, i32 0, metadata !1116, null}
!1491 = metadata !{i32 786689, metadata !1116, metadata !"set", metadata !1105, i32 33555080, metadata !1114, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [set] [line 648]
!1492 = metadata !{i32 786688, metadata !1116, metadata !"tbuf", metadata !1105, i32 650, metadata !489, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [tbuf] [line 650]
!1493 = metadata !{i32 650, i32 0, metadata !1116, null}
!1494 = metadata !{i32 786688, metadata !1116, metadata !"i", metadata !1105, i32 651, metadata !1206, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 651]
!1495 = metadata !{i32 651, i32 0, metadata !1116, null}
!1496 = metadata !{i32 786688, metadata !1116, metadata !"bytesp", metadata !1105, i32 651, metadata !1206, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [bytesp] [line 651]
!1497 = metadata !{i32 786688, metadata !1116, metadata !"bufsiz", metadata !1105, i32 651, metadata !1206, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [bufsiz] [line 651]
!1498 = metadata !{i32 653, i32 0, metadata !1116, null}
!1499 = metadata !{i32 654, i32 0, metadata !1116, null}
!1500 = metadata !{i32 655, i32 0, metadata !1116, null}
!1501 = metadata !{i32 657, i32 0, metadata !1502, null}
!1502 = metadata !{i32 786443, metadata !1, metadata !1116, i32 657, i32 0, i32 9} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1503 = metadata !{i32 658, i32 0, metadata !1504, null}
!1504 = metadata !{i32 786443, metadata !1, metadata !1502, i32 657, i32 0, i32 10} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1505 = metadata !{i32 659, i32 0, metadata !1504, null}
!1506 = metadata !{i32 660, i32 0, metadata !1504, null}
!1507 = metadata !{i32 661, i32 0, metadata !1504, null}
!1508 = metadata !{i32 662, i32 0, metadata !1116, null}
!1509 = metadata !{i32 663, i32 0, metadata !1116, null}
!1510 = metadata !{i32 786689, metadata !1119, metadata !"set", metadata !1105, i32 16777887, metadata !1122, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [set] [line 671]
!1511 = metadata !{i32 671, i32 0, metadata !1119, null}
!1512 = metadata !{i32 786689, metadata !1119, metadata !"buf", metadata !1105, i32 33555103, metadata !32, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [buf] [line 671]
!1513 = metadata !{i32 786688, metadata !1119, metadata !"nwords", metadata !1105, i32 673, metadata !36, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [nwords] [line 673]
!1514 = metadata !{i32 673, i32 0, metadata !1119, null}
!1515 = metadata !{i32 786688, metadata !1119, metadata !"i", metadata !1105, i32 674, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 674]
!1516 = metadata !{i32 674, i32 0, metadata !1119, null}
!1517 = metadata !{i32 786688, metadata !1119, metadata !"ret", metadata !1105, i32 674, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [ret] [line 674]
!1518 = metadata !{i32 676, i32 0, metadata !1119, null}
!1519 = metadata !{i32 677, i32 0, metadata !1119, null}
!1520 = metadata !{i32 680, i32 0, metadata !1119, null}
!1521 = metadata !{i32 681, i32 0, metadata !1522, null}
!1522 = metadata !{i32 786443, metadata !1, metadata !1119, i32 681, i32 0, i32 11} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1523 = metadata !{i32 682, i32 0, metadata !1522, null}
!1524 = metadata !{i32 683, i32 0, metadata !1522, null}
!1525 = metadata !{i32 684, i32 0, metadata !1119, null}
!1526 = metadata !{i32 685, i32 0, metadata !1119, null}
!1527 = metadata !{i32 687, i32 0, metadata !1119, null}
!1528 = metadata !{i32 786688, metadata !1529, metadata !"__i", metadata !1105, i32 687, metadata !491, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [__i] [line 687]
!1529 = metadata !{i32 786443, metadata !1, metadata !1119, i32 687, i32 0, i32 12} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1530 = metadata !{i32 687, i32 0, metadata !1529, null}
!1531 = metadata !{i32 687, i32 0, metadata !1532, null}
!1532 = metadata !{i32 786443, metadata !1, metadata !1529, i32 687, i32 0, i32 13} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1533 = metadata !{i32 688, i32 0, metadata !1534, null}
!1534 = metadata !{i32 786443, metadata !1, metadata !1119, i32 688, i32 0, i32 14} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1535 = metadata !{i32 689, i32 0, metadata !1536, null}
!1536 = metadata !{i32 786443, metadata !1, metadata !1534, i32 688, i32 0, i32 15} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1537 = metadata !{i32 690, i32 0, metadata !1536, null}
!1538 = metadata !{i32 691, i32 0, metadata !1536, null}
!1539 = metadata !{i32 692, i32 0, metadata !1536, null}
!1540 = metadata !{i32 693, i32 0, metadata !1536, null}
!1541 = metadata !{i32 694, i32 0, metadata !1536, null}
!1542 = metadata !{i32 695, i32 0, metadata !1536, null}
!1543 = metadata !{i32 696, i32 0, metadata !1536, null}
!1544 = metadata !{i32 697, i32 0, metadata !1119, null}
!1545 = metadata !{i32 698, i32 0, metadata !1119, null}
!1546 = metadata !{i32 699, i32 0, metadata !1119, null}
!1547 = metadata !{i32 700, i32 0, metadata !1119, null}
!1548 = metadata !{i32 786689, metadata !1123, metadata !"id", metadata !1105, i32 16777923, metadata !129, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [id] [line 707]
!1549 = metadata !{i32 707, i32 0, metadata !1123, null}
!1550 = metadata !{i32 786689, metadata !1123, metadata !"mask", metadata !1105, i32 33555139, metadata !1122, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [mask] [line 707]
!1551 = metadata !{i32 786688, metadata !1123, metadata !"nset", metadata !1105, i32 709, metadata !77, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [nset] [line 709]
!1552 = metadata !{i32 709, i32 0, metadata !1123, null}
!1553 = metadata !{i32 786688, metadata !1123, metadata !"set", metadata !1105, i32 710, metadata !77, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [set] [line 710]
!1554 = metadata !{i32 710, i32 0, metadata !1123, null}
!1555 = metadata !{i32 786688, metadata !1123, metadata !"td", metadata !1105, i32 711, metadata !18, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [td] [line 711]
!1556 = metadata !{i32 711, i32 0, metadata !1123, null}
!1557 = metadata !{i32 786688, metadata !1123, metadata !"p", metadata !1105, i32 712, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 712]
!1558 = metadata !{i32 712, i32 0, metadata !1123, null}
!1559 = metadata !{i32 786688, metadata !1123, metadata !"error", metadata !1105, i32 713, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 713]
!1560 = metadata !{i32 713, i32 0, metadata !1123, null}
!1561 = metadata !{i32 715, i32 9, metadata !1123, null}
!1562 = metadata !{i32 716, i32 0, metadata !1123, null}
!1563 = metadata !{i32 717, i32 0, metadata !1123, null}
!1564 = metadata !{i32 718, i32 0, metadata !1123, null}
!1565 = metadata !{i32 720, i32 0, metadata !1123, null}
!1566 = metadata !{i32 722, i32 0, metadata !1123, null}
!1567 = metadata !{i32 723, i32 0, metadata !1123, null}
!1568 = metadata !{i32 724, i32 0, metadata !1123, null}
!1569 = metadata !{i32 725, i32 0, metadata !1123, null}
!1570 = metadata !{i32 726, i32 0, metadata !1571, null}
!1571 = metadata !{i32 786443, metadata !1, metadata !1123, i32 725, i32 0, i32 16} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1572 = metadata !{i32 727, i32 0, metadata !1571, null}
!1573 = metadata !{i32 728, i32 0, metadata !1571, null}
!1574 = metadata !{i32 729, i32 0, metadata !1571, null}
!1575 = metadata !{i32 730, i32 0, metadata !1571, null}
!1576 = metadata !{i32 731, i32 0, metadata !1123, null}
!1577 = metadata !{i32 732, i32 0, metadata !1123, null}
!1578 = metadata !{i32 733, i32 0, metadata !1123, null}
!1579 = metadata !{i32 734, i32 0, metadata !1123, null}
!1580 = metadata !{i32 736, i32 0, metadata !1123, null}
!1581 = metadata !{i32 737, i32 0, metadata !1123, null}
!1582 = metadata !{i32 738, i32 0, metadata !1123, null}
!1583 = metadata !{i32 786689, metadata !1283, metadata !"zone", metadata !1285, i32 16777527, metadata !1288, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [zone] [line 311]
!1584 = metadata !{i32 311, i32 0, metadata !1283, null}
!1585 = metadata !{i32 786689, metadata !1283, metadata !"flags", metadata !1285, i32 33554743, metadata !93, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [flags] [line 311]
!1586 = metadata !{i32 313, i32 0, metadata !1587, null}
!1587 = metadata !{i32 786443, metadata !1284, metadata !1283} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/vm/uma.h]
!1588 = metadata !{i32 786689, metadata !1280, metadata !"which", metadata !1105, i32 16777615, metadata !1157, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [which] [line 399]
!1589 = metadata !{i32 399, i32 0, metadata !1280, null}
!1590 = metadata !{i32 786689, metadata !1280, metadata !"id", metadata !1105, i32 33554831, metadata !1163, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [id] [line 399]
!1591 = metadata !{i32 786689, metadata !1280, metadata !"pp", metadata !1105, i32 50332047, metadata !13, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [pp] [line 399]
!1592 = metadata !{i32 786689, metadata !1280, metadata !"tdp", metadata !1105, i32 67109263, metadata !55, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [tdp] [line 399]
!1593 = metadata !{i32 786689, metadata !1280, metadata !"setp", metadata !1105, i32 83886480, metadata !103, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [setp] [line 400]
!1594 = metadata !{i32 400, i32 0, metadata !1280, null}
!1595 = metadata !{i32 786688, metadata !1280, metadata !"set", metadata !1105, i32 402, metadata !77, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [set] [line 402]
!1596 = metadata !{i32 402, i32 0, metadata !1280, null}
!1597 = metadata !{i32 786688, metadata !1280, metadata !"td", metadata !1105, i32 403, metadata !18, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [td] [line 403]
!1598 = metadata !{i32 403, i32 0, metadata !1280, null}
!1599 = metadata !{i32 786688, metadata !1280, metadata !"p", metadata !1105, i32 404, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 404]
!1600 = metadata !{i32 404, i32 0, metadata !1280, null}
!1601 = metadata !{i32 786688, metadata !1280, metadata !"error", metadata !1105, i32 405, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 405]
!1602 = metadata !{i32 405, i32 0, metadata !1280, null}
!1603 = metadata !{i32 407, i32 0, metadata !1280, null}
!1604 = metadata !{i32 408, i32 0, metadata !1280, null}
!1605 = metadata !{i32 409, i32 0, metadata !1280, null}
!1606 = metadata !{i32 410, i32 0, metadata !1280, null}
!1607 = metadata !{i32 412, i32 0, metadata !1608, null}
!1608 = metadata !{i32 786443, metadata !1, metadata !1280, i32 410, i32 0, i32 116} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1609 = metadata !{i32 413, i32 0, metadata !1610, null}
!1610 = metadata !{i32 786443, metadata !1, metadata !1608, i32 412, i32 0, i32 117} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1611 = metadata !{i32 414, i32 8, metadata !1610, null}
!1612 = metadata !{i32 415, i32 0, metadata !1610, null}
!1613 = metadata !{i32 417, i32 0, metadata !1608, null}
!1614 = metadata !{i32 418, i32 0, metadata !1608, null}
!1615 = metadata !{i32 419, i32 0, metadata !1608, null}
!1616 = metadata !{i32 421, i32 0, metadata !1608, null}
!1617 = metadata !{i32 422, i32 0, metadata !1618, null}
!1618 = metadata !{i32 786443, metadata !1, metadata !1608, i32 421, i32 0, i32 118} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1619 = metadata !{i32 423, i32 8, metadata !1618, null}
!1620 = metadata !{i32 424, i32 9, metadata !1618, null}
!1621 = metadata !{i32 425, i32 0, metadata !1618, null}
!1622 = metadata !{i32 427, i32 0, metadata !1608, null}
!1623 = metadata !{i32 428, i32 0, metadata !1608, null}
!1624 = metadata !{i32 429, i32 0, metadata !1608, null}
!1625 = metadata !{i32 430, i32 0, metadata !1608, null}
!1626 = metadata !{i32 431, i32 0, metadata !1608, null}
!1627 = metadata !{i32 433, i32 0, metadata !1608, null}
!1628 = metadata !{i32 434, i32 0, metadata !1629, null}
!1629 = metadata !{i32 786443, metadata !1, metadata !1608, i32 433, i32 0, i32 119} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1630 = metadata !{i32 435, i32 25, metadata !1629, null}
!1631 = metadata !{i32 436, i32 0, metadata !1629, null}
!1632 = metadata !{i32 437, i32 0, metadata !1629, null}
!1633 = metadata !{i32 438, i32 0, metadata !1608, null}
!1634 = metadata !{i32 438, i32 28, metadata !1608, null}
!1635 = metadata !{i32 439, i32 0, metadata !1608, null}
!1636 = metadata !{i32 440, i32 0, metadata !1637, null}
!1637 = metadata !{i32 786443, metadata !1, metadata !1608, i32 439, i32 0, i32 120} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1638 = metadata !{i32 441, i32 0, metadata !1637, null}
!1639 = metadata !{i32 443, i32 0, metadata !1608, null}
!1640 = metadata !{i32 786688, metadata !1641, metadata !"pr", metadata !1105, i32 447, metadata !271, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [pr] [line 447]
!1641 = metadata !{i32 786443, metadata !1, metadata !1608, i32 445, i32 0, i32 121} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1642 = metadata !{i32 447, i32 0, metadata !1641, null}
!1643 = metadata !{i32 449, i32 0, metadata !1641, null}
!1644 = metadata !{i32 450, i32 26, metadata !1641, null}
!1645 = metadata !{i32 451, i32 0, metadata !1641, null}
!1646 = metadata !{i32 452, i32 0, metadata !1641, null}
!1647 = metadata !{i32 453, i32 0, metadata !1641, null}
!1648 = metadata !{i32 454, i32 0, metadata !1641, null}
!1649 = metadata !{i32 455, i32 0, metadata !1641, null}
!1650 = metadata !{i32 456, i32 0, metadata !1641, null}
!1651 = metadata !{i32 457, i32 0, metadata !1641, null}
!1652 = metadata !{i32 460, i32 0, metadata !1608, null}
!1653 = metadata !{i32 462, i32 0, metadata !1608, null}
!1654 = metadata !{i32 464, i32 21, metadata !1280, null}
!1655 = metadata !{i32 465, i32 0, metadata !1280, null}
!1656 = metadata !{i32 466, i32 0, metadata !1657, null}
!1657 = metadata !{i32 786443, metadata !1, metadata !1280, i32 465, i32 0, i32 122} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1658 = metadata !{i32 467, i32 0, metadata !1657, null}
!1659 = metadata !{i32 469, i32 0, metadata !1280, null}
!1660 = metadata !{i32 470, i32 0, metadata !1280, null}
!1661 = metadata !{i32 471, i32 0, metadata !1280, null}
!1662 = metadata !{i32 472, i32 0, metadata !1280, null}
!1663 = metadata !{i32 473, i32 0, metadata !1280, null}
!1664 = metadata !{i32 474, i32 0, metadata !1280, null}
!1665 = metadata !{i32 786689, metadata !1277, metadata !"set", metadata !1105, i32 16777698, metadata !77, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [set] [line 482]
!1666 = metadata !{i32 482, i32 0, metadata !1277, null}
!1667 = metadata !{i32 786689, metadata !1277, metadata !"fset", metadata !1105, i32 33554914, metadata !77, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [fset] [line 482]
!1668 = metadata !{i32 786689, metadata !1277, metadata !"mask", metadata !1105, i32 50332130, metadata !1114, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [mask] [line 482]
!1669 = metadata !{i32 786688, metadata !1670, metadata !"parent", metadata !1105, i32 484, metadata !77, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [parent] [line 484]
!1670 = metadata !{i32 786443, metadata !1, metadata !1277} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1671 = metadata !{i32 484, i32 0, metadata !1670, null}
!1672 = metadata !{i32 486, i32 0, metadata !1670, null}
!1673 = metadata !{i32 487, i32 0, metadata !1670, null}
!1674 = metadata !{i32 489, i32 0, metadata !1670, null}
!1675 = metadata !{i32 786688, metadata !1676, metadata !"__i", metadata !1105, i32 490, metadata !491, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [__i] [line 490]
!1676 = metadata !{i32 786443, metadata !1, metadata !1670, i32 490, i32 0, i32 114} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1677 = metadata !{i32 490, i32 0, metadata !1676, null}
!1678 = metadata !{i32 490, i32 0, metadata !1679, null}
!1679 = metadata !{i32 786443, metadata !1, metadata !1676, i32 490, i32 0, i32 115} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1680 = metadata !{i32 491, i32 0, metadata !1670, null}
!1681 = metadata !{i32 492, i32 0, metadata !1670, null}
!1682 = metadata !{i32 493, i32 0, metadata !1670, null}
!1683 = metadata !{i32 786688, metadata !1126, metadata !"set", metadata !1105, i32 755, metadata !77, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [set] [line 755]
!1684 = metadata !{i32 755, i32 0, metadata !1126, null}
!1685 = metadata !{i32 786688, metadata !1126, metadata !"error", metadata !1105, i32 756, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 756]
!1686 = metadata !{i32 756, i32 0, metadata !1126, null}
!1687 = metadata !{i32 758, i32 0, metadata !1126, null}
!1688 = metadata !{i32 760, i32 0, metadata !1126, null}
!1689 = metadata !{i32 765, i32 8, metadata !1126, null}
!1690 = metadata !{i32 766, i32 0, metadata !1126, null}
!1691 = metadata !{i32 786688, metadata !1692, metadata !"__i", metadata !1105, i32 766, metadata !491, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [__i] [line 766]
!1692 = metadata !{i32 786443, metadata !1, metadata !1126, i32 766, i32 0, i32 17} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1693 = metadata !{i32 766, i32 0, metadata !1692, null}
!1694 = metadata !{i32 766, i32 0, metadata !1695, null}
!1695 = metadata !{i32 786443, metadata !1, metadata !1692, i32 766, i32 0, i32 18} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1696 = metadata !{i32 767, i32 0, metadata !1126, null}
!1697 = metadata !{i32 767, i32 0, metadata !1698, null}
!1698 = metadata !{i32 786443, metadata !1, metadata !1126, i32 767, i32 0, i32 19} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1699 = metadata !{i32 768, i32 0, metadata !1126, null}
!1700 = metadata !{i32 768, i32 0, metadata !1701, null}
!1701 = metadata !{i32 786443, metadata !1, metadata !1126, i32 768, i32 0, i32 20} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1702 = metadata !{i32 768, i32 0, metadata !1703, null}
!1703 = metadata !{i32 786443, metadata !1, metadata !1701, i32 768, i32 0, i32 21} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1704 = metadata !{i32 769, i32 0, metadata !1126, null}
!1705 = metadata !{i32 770, i32 0, metadata !1126, null}
!1706 = metadata !{i32 771, i32 0, metadata !1126, null}
!1707 = metadata !{i32 772, i32 0, metadata !1126, null}
!1708 = metadata !{i32 776, i32 8, metadata !1126, null}
!1709 = metadata !{i32 777, i32 0, metadata !1126, null}
!1710 = metadata !{i32 778, i32 0, metadata !1126, null}
!1711 = metadata !{i32 778, i32 0, metadata !1712, null}
!1712 = metadata !{i32 786443, metadata !1, metadata !1126, i32 778, i32 0, i32 22} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1713 = metadata !{i32 782, i32 0, metadata !1126, null}
!1714 = metadata !{i32 784, i32 0, metadata !1126, null}
!1715 = metadata !{i32 786689, metadata !1268, metadata !"set", metadata !1105, i32 16777472, metadata !77, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [set] [line 256]
!1716 = metadata !{i32 256, i32 0, metadata !1268, null}
!1717 = metadata !{i32 786689, metadata !1268, metadata !"parent", metadata !1105, i32 33554688, metadata !77, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [parent] [line 256]
!1718 = metadata !{i32 786689, metadata !1268, metadata !"mask", metadata !1105, i32 50331904, metadata !1114, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [mask] [line 256]
!1719 = metadata !{i32 786689, metadata !1268, metadata !"id", metadata !1105, i32 67109121, metadata !95, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [id] [line 257]
!1720 = metadata !{i32 257, i32 0, metadata !1268, null}
!1721 = metadata !{i32 786688, metadata !1722, metadata !"__i", metadata !1105, i32 260, metadata !491, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [__i] [line 260]
!1722 = metadata !{i32 786443, metadata !1, metadata !1268, i32 260, i32 0, i32 105} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1723 = metadata !{i32 260, i32 0, metadata !1722, null}
!1724 = metadata !{i32 260, i32 0, metadata !1725, null}
!1725 = metadata !{i32 786443, metadata !1, metadata !1722, i32 260, i32 0, i32 106} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1726 = metadata !{i32 261, i32 0, metadata !1268, null}
!1727 = metadata !{i32 262, i32 0, metadata !1268, null}
!1728 = metadata !{i32 263, i32 0, metadata !1268, null}
!1729 = metadata !{i32 263, i32 0, metadata !1730, null}
!1730 = metadata !{i32 786443, metadata !1, metadata !1268, i32 263, i32 0, i32 107} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1731 = metadata !{i32 264, i32 0, metadata !1268, null}
!1732 = metadata !{i32 265, i32 0, metadata !1268, null}
!1733 = metadata !{i32 266, i32 0, metadata !1268, null}
!1734 = metadata !{i32 267, i32 0, metadata !1268, null}
!1735 = metadata !{i32 786688, metadata !1736, metadata !"__i", metadata !1105, i32 267, metadata !491, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [__i] [line 267]
!1736 = metadata !{i32 786443, metadata !1, metadata !1268, i32 267, i32 0, i32 108} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1737 = metadata !{i32 267, i32 0, metadata !1736, null}
!1738 = metadata !{i32 267, i32 0, metadata !1739, null}
!1739 = metadata !{i32 786443, metadata !1, metadata !1736, i32 267, i32 0, i32 109} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1740 = metadata !{i32 268, i32 0, metadata !1268, null}
!1741 = metadata !{i32 269, i32 0, metadata !1268, null}
!1742 = metadata !{i32 270, i32 0, metadata !1268, null}
!1743 = metadata !{i32 270, i32 0, metadata !1744, null}
!1744 = metadata !{i32 786443, metadata !1, metadata !1268, i32 270, i32 0, i32 110} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1745 = metadata !{i32 270, i32 0, metadata !1746, null}
!1746 = metadata !{i32 786443, metadata !1, metadata !1744, i32 270, i32 0, i32 111} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1747 = metadata !{i32 271, i32 0, metadata !1268, null}
!1748 = metadata !{i32 272, i32 0, metadata !1268, null}
!1749 = metadata !{i32 272, i32 0, metadata !1750, null}
!1750 = metadata !{i32 786443, metadata !1, metadata !1268, i32 272, i32 0, i32 112} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1751 = metadata !{i32 272, i32 0, metadata !1752, null}
!1752 = metadata !{i32 786443, metadata !1, metadata !1750, i32 272, i32 0, i32 113} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1753 = metadata !{i32 273, i32 0, metadata !1268, null}
!1754 = metadata !{i32 275, i32 0, metadata !1268, null}
!1755 = metadata !{i32 786689, metadata !1129, metadata !"pr", metadata !1105, i32 16778013, metadata !271, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [pr] [line 797]
!1756 = metadata !{i32 797, i32 0, metadata !1129, null}
!1757 = metadata !{i32 786689, metadata !1129, metadata !"setp", metadata !1105, i32 33555229, metadata !103, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [setp] [line 797]
!1758 = metadata !{i32 786688, metadata !1129, metadata !"set", metadata !1105, i32 799, metadata !77, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [set] [line 799]
!1759 = metadata !{i32 799, i32 0, metadata !1129, null}
!1760 = metadata !{i32 786688, metadata !1129, metadata !"error", metadata !1105, i32 800, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 800]
!1761 = metadata !{i32 800, i32 0, metadata !1129, null}
!1762 = metadata !{i32 802, i32 0, metadata !1129, null}
!1763 = metadata !{i32 802, i32 0, metadata !1764, null}
!1764 = metadata !{i32 786443, metadata !1, metadata !1129, i32 802, i32 0, i32 23} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1765 = metadata !{i32 803, i32 0, metadata !1129, null}
!1766 = metadata !{i32 803, i32 0, metadata !1767, null}
!1767 = metadata !{i32 786443, metadata !1, metadata !1129, i32 803, i32 0, i32 24} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1768 = metadata !{i32 805, i32 0, metadata !1129, null}
!1769 = metadata !{i32 806, i32 0, metadata !1129, null}
!1770 = metadata !{i32 807, i32 0, metadata !1129, null}
!1771 = metadata !{i32 809, i32 0, metadata !1129, null}
!1772 = metadata !{i32 809, i32 0, metadata !1773, null}
!1773 = metadata !{i32 786443, metadata !1, metadata !1129, i32 809, i32 0, i32 25} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1774 = metadata !{i32 813, i32 0, metadata !1129, null}
!1775 = metadata !{i32 814, i32 0, metadata !1129, null}
!1776 = metadata !{i32 816, i32 0, metadata !1129, null}
!1777 = metadata !{i32 817, i32 0, metadata !1129, null}
!1778 = metadata !{i32 786689, metadata !1265, metadata !"setp", metadata !1105, i32 16777500, metadata !103, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [setp] [line 284]
!1779 = metadata !{i32 284, i32 0, metadata !1265, null}
!1780 = metadata !{i32 786689, metadata !1265, metadata !"parent", metadata !1105, i32 33554716, metadata !77, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [parent] [line 284]
!1781 = metadata !{i32 786689, metadata !1265, metadata !"mask", metadata !1105, i32 50331932, metadata !1114, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [mask] [line 284]
!1782 = metadata !{i32 786688, metadata !1265, metadata !"set", metadata !1105, i32 286, metadata !77, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [set] [line 286]
!1783 = metadata !{i32 286, i32 0, metadata !1265, null}
!1784 = metadata !{i32 786688, metadata !1265, metadata !"id", metadata !1105, i32 287, metadata !95, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [id] [line 287]
!1785 = metadata !{i32 287, i32 0, metadata !1265, null}
!1786 = metadata !{i32 786688, metadata !1265, metadata !"error", metadata !1105, i32 288, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 288]
!1787 = metadata !{i32 288, i32 0, metadata !1265, null}
!1788 = metadata !{i32 290, i32 0, metadata !1265, null}
!1789 = metadata !{i32 291, i32 0, metadata !1265, null}
!1790 = metadata !{i32 292, i32 0, metadata !1265, null}
!1791 = metadata !{i32 293, i32 16, metadata !1265, null}
!1792 = metadata !{i32 294, i32 0, metadata !1265, null}
!1793 = metadata !{i32 295, i32 0, metadata !1265, null}
!1794 = metadata !{i32 296, i32 0, metadata !1265, null}
!1795 = metadata !{i32 297, i32 0, metadata !1265, null}
!1796 = metadata !{i32 298, i32 0, metadata !1265, null}
!1797 = metadata !{i32 300, i32 0, metadata !1265, null}
!1798 = metadata !{i32 301, i32 0, metadata !1265, null}
!1799 = metadata !{i32 786689, metadata !1132, metadata !"p", metadata !1105, i32 16778036, metadata !11, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [p] [line 820]
!1800 = metadata !{i32 820, i32 0, metadata !1132, null}
!1801 = metadata !{i32 786689, metadata !1132, metadata !"set", metadata !1105, i32 33555252, metadata !77, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [set] [line 820]
!1802 = metadata !{i32 786688, metadata !1132, metadata !"error", metadata !1105, i32 822, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 822]
!1803 = metadata !{i32 822, i32 0, metadata !1132, null}
!1804 = metadata !{i32 824, i32 0, metadata !1132, null}
!1805 = metadata !{i32 824, i32 0, metadata !1806, null}
!1806 = metadata !{i32 786443, metadata !1, metadata !1132, i32 824, i32 0, i32 26} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1807 = metadata !{i32 825, i32 0, metadata !1132, null}
!1808 = metadata !{i32 825, i32 0, metadata !1809, null}
!1809 = metadata !{i32 786443, metadata !1, metadata !1132, i32 825, i32 0, i32 27} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1810 = metadata !{i32 827, i32 0, metadata !1132, null}
!1811 = metadata !{i32 828, i32 0, metadata !1132, null}
!1812 = metadata !{i32 829, i32 0, metadata !1132, null}
!1813 = metadata !{i32 830, i32 0, metadata !1132, null}
!1814 = metadata !{i32 831, i32 0, metadata !1132, null}
!1815 = metadata !{i32 832, i32 0, metadata !1132, null}
!1816 = metadata !{i32 833, i32 0, metadata !1132, null}
!1817 = metadata !{i32 786689, metadata !1257, metadata !"pid", metadata !1105, i32 16777725, metadata !421, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [pid] [line 509]
!1818 = metadata !{i32 509, i32 0, metadata !1257, null}
!1819 = metadata !{i32 786689, metadata !1257, metadata !"set", metadata !1105, i32 33554941, metadata !77, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [set] [line 509]
!1820 = metadata !{i32 786689, metadata !1257, metadata !"mask", metadata !1105, i32 50332157, metadata !1122, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [mask] [line 509]
!1821 = metadata !{i32 786688, metadata !1257, metadata !"freelist", metadata !1105, i32 511, metadata !110, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [freelist] [line 511]
!1822 = metadata !{i32 511, i32 0, metadata !1257, null}
!1823 = metadata !{i32 786688, metadata !1257, metadata !"droplist", metadata !1105, i32 512, metadata !110, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [droplist] [line 512]
!1824 = metadata !{i32 512, i32 0, metadata !1257, null}
!1825 = metadata !{i32 786688, metadata !1257, metadata !"tdset", metadata !1105, i32 513, metadata !77, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [tdset] [line 513]
!1826 = metadata !{i32 513, i32 0, metadata !1257, null}
!1827 = metadata !{i32 786688, metadata !1257, metadata !"nset", metadata !1105, i32 514, metadata !77, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [nset] [line 514]
!1828 = metadata !{i32 514, i32 0, metadata !1257, null}
!1829 = metadata !{i32 786688, metadata !1257, metadata !"td", metadata !1105, i32 515, metadata !18, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [td] [line 515]
!1830 = metadata !{i32 515, i32 0, metadata !1257, null}
!1831 = metadata !{i32 786688, metadata !1257, metadata !"p", metadata !1105, i32 516, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 516]
!1832 = metadata !{i32 516, i32 0, metadata !1257, null}
!1833 = metadata !{i32 786688, metadata !1257, metadata !"threads", metadata !1105, i32 517, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [threads] [line 517]
!1834 = metadata !{i32 517, i32 0, metadata !1257, null}
!1835 = metadata !{i32 786688, metadata !1257, metadata !"nfree", metadata !1105, i32 518, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [nfree] [line 518]
!1836 = metadata !{i32 518, i32 0, metadata !1257, null}
!1837 = metadata !{i32 786688, metadata !1257, metadata !"error", metadata !1105, i32 519, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 519]
!1838 = metadata !{i32 519, i32 0, metadata !1257, null}
!1839 = metadata !{i32 527, i32 0, metadata !1257, null}
!1840 = metadata !{i32 527, i32 0, metadata !1841, null}
!1841 = metadata !{i32 786443, metadata !1, metadata !1257, i32 527, i32 0, i32 65} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1842 = metadata !{i32 528, i32 0, metadata !1257, null}
!1843 = metadata !{i32 528, i32 0, metadata !1844, null}
!1844 = metadata !{i32 786443, metadata !1, metadata !1257, i32 528, i32 0, i32 66} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1845 = metadata !{i32 529, i32 0, metadata !1257, null}
!1846 = metadata !{i32 530, i32 0, metadata !1847, null}
!1847 = metadata !{i32 786443, metadata !1, metadata !1257, i32 530, i32 0, i32 67} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1848 = metadata !{i32 531, i32 0, metadata !1849, null}
!1849 = metadata !{i32 786443, metadata !1, metadata !1847, i32 530, i32 0, i32 68} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1850 = metadata !{i32 532, i32 0, metadata !1849, null}
!1851 = metadata !{i32 533, i32 0, metadata !1849, null}
!1852 = metadata !{i32 534, i32 0, metadata !1849, null}
!1853 = metadata !{i32 535, i32 0, metadata !1849, null}
!1854 = metadata !{i32 536, i32 0, metadata !1849, null}
!1855 = metadata !{i32 537, i32 0, metadata !1849, null}
!1856 = metadata !{i32 538, i32 0, metadata !1857, null}
!1857 = metadata !{i32 786443, metadata !1, metadata !1849, i32 538, i32 0, i32 69} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1858 = metadata !{i32 539, i32 11, metadata !1859, null}
!1859 = metadata !{i32 786443, metadata !1, metadata !1857, i32 538, i32 0, i32 70} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1860 = metadata !{i32 540, i32 0, metadata !1859, null}
!1861 = metadata !{i32 540, i32 0, metadata !1862, null}
!1862 = metadata !{i32 786443, metadata !1, metadata !1859, i32 540, i32 0, i32 71} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1863 = metadata !{i32 540, i32 0, metadata !1864, null}
!1864 = metadata !{i32 786443, metadata !1, metadata !1862, i32 540, i32 0, i32 72} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1865 = metadata !{i32 541, i32 0, metadata !1859, null}
!1866 = metadata !{i32 542, i32 0, metadata !1849, null}
!1867 = metadata !{i32 543, i32 0, metadata !1257, null}
!1868 = metadata !{i32 549, i32 0, metadata !1257, null}
!1869 = metadata !{i32 550, i32 0, metadata !1870, null}
!1870 = metadata !{i32 786443, metadata !1, metadata !1257, i32 550, i32 0, i32 73} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1871 = metadata !{i32 551, i32 0, metadata !1872, null}
!1872 = metadata !{i32 786443, metadata !1, metadata !1870, i32 550, i32 0, i32 74} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1873 = metadata !{i32 552, i32 0, metadata !1872, null}
!1874 = metadata !{i32 557, i32 0, metadata !1872, null}
!1875 = metadata !{i32 558, i32 0, metadata !1876, null}
!1876 = metadata !{i32 786443, metadata !1, metadata !1872, i32 557, i32 0, i32 75} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1877 = metadata !{i32 559, i32 0, metadata !1876, null}
!1878 = metadata !{i32 786688, metadata !1879, metadata !"__i", metadata !1105, i32 560, metadata !491, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [__i] [line 560]
!1879 = metadata !{i32 786443, metadata !1, metadata !1876, i32 560, i32 0, i32 76} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1880 = metadata !{i32 560, i32 0, metadata !1879, null}
!1881 = metadata !{i32 560, i32 0, metadata !1882, null}
!1882 = metadata !{i32 786443, metadata !1, metadata !1879, i32 560, i32 0, i32 77} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1883 = metadata !{i32 561, i32 0, metadata !1876, null}
!1884 = metadata !{i32 567, i32 0, metadata !1876, null}
!1885 = metadata !{i32 567, i32 0, metadata !1872, null}
!1886 = metadata !{i32 786688, metadata !1887, metadata !"__i", metadata !1105, i32 568, metadata !491, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [__i] [line 568]
!1887 = metadata !{i32 786443, metadata !1, metadata !1888, i32 568, i32 0, i32 79} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1888 = metadata !{i32 786443, metadata !1, metadata !1872, i32 567, i32 0, i32 78} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1889 = metadata !{i32 568, i32 0, metadata !1887, null}
!1890 = metadata !{i32 568, i32 0, metadata !1891, null}
!1891 = metadata !{i32 786443, metadata !1, metadata !1887, i32 568, i32 0, i32 80} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1892 = metadata !{i32 569, i32 0, metadata !1888, null}
!1893 = metadata !{i32 570, i32 0, metadata !1888, null}
!1894 = metadata !{i32 571, i32 0, metadata !1872, null}
!1895 = metadata !{i32 572, i32 0, metadata !1872, null}
!1896 = metadata !{i32 573, i32 0, metadata !1872, null}
!1897 = metadata !{i32 574, i32 0, metadata !1872, null}
!1898 = metadata !{i32 580, i32 0, metadata !1899, null}
!1899 = metadata !{i32 786443, metadata !1, metadata !1257, i32 580, i32 0, i32 81} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1900 = metadata !{i32 581, i32 0, metadata !1901, null}
!1901 = metadata !{i32 786443, metadata !1, metadata !1899, i32 580, i32 0, i32 82} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1902 = metadata !{i32 590, i32 0, metadata !1901, null}
!1903 = metadata !{i32 591, i32 0, metadata !1901, null}
!1904 = metadata !{i32 592, i32 0, metadata !1905, null}
!1905 = metadata !{i32 786443, metadata !1, metadata !1901, i32 591, i32 0, i32 83} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1906 = metadata !{i32 593, i32 0, metadata !1905, null}
!1907 = metadata !{i32 593, i32 0, metadata !1908, null}
!1908 = metadata !{i32 786443, metadata !1, metadata !1905, i32 593, i32 0, i32 84} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1909 = metadata !{i32 593, i32 0, metadata !1910, null}
!1910 = metadata !{i32 786443, metadata !1, metadata !1908, i32 593, i32 0, i32 85} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1911 = metadata !{i32 593, i32 0, metadata !1912, null}
!1912 = metadata !{i32 786443, metadata !1, metadata !1908, i32 593, i32 0, i32 86} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1913 = metadata !{i32 594, i32 0, metadata !1905, null}
!1914 = metadata !{i32 595, i32 0, metadata !1905, null}
!1915 = metadata !{i32 597, i32 0, metadata !1905, null}
!1916 = metadata !{i32 599, i32 0, metadata !1905, null}
!1917 = metadata !{i32 600, i32 0, metadata !1918, null}
!1918 = metadata !{i32 786443, metadata !1, metadata !1905, i32 599, i32 0, i32 87} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1919 = metadata !{i32 600, i32 0, metadata !1920, null}
!1920 = metadata !{i32 786443, metadata !1, metadata !1918, i32 600, i32 0, i32 88} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1921 = metadata !{i32 600, i32 0, metadata !1922, null}
!1922 = metadata !{i32 786443, metadata !1, metadata !1920, i32 600, i32 0, i32 89} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1923 = metadata !{i32 601, i32 0, metadata !1918, null}
!1924 = metadata !{i32 602, i32 0, metadata !1918, null}
!1925 = metadata !{i32 604, i32 0, metadata !1905, null}
!1926 = metadata !{i32 605, i32 0, metadata !1901, null}
!1927 = metadata !{i32 606, i32 0, metadata !1901, null}
!1928 = metadata !{i32 607, i32 0, metadata !1901, null}
!1929 = metadata !{i32 608, i32 0, metadata !1901, null}
!1930 = metadata !{i32 609, i32 0, metadata !1901, null}
!1931 = metadata !{i32 610, i32 0, metadata !1901, null}
!1932 = metadata !{i32 610, i32 0, metadata !1899, null}
!1933 = metadata !{i32 612, i32 0, metadata !1257, null}
!1934 = metadata !{i32 614, i32 0, metadata !1257, null}
!1935 = metadata !{i32 615, i32 0, metadata !1257, null}
!1936 = metadata !{i32 616, i32 0, metadata !1257, null}
!1937 = metadata !{i32 617, i32 0, metadata !1938, null}
!1938 = metadata !{i32 786443, metadata !1, metadata !1257, i32 616, i32 0, i32 90} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1939 = metadata !{i32 617, i32 0, metadata !1940, null}
!1940 = metadata !{i32 786443, metadata !1, metadata !1938, i32 617, i32 0, i32 91} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1941 = metadata !{i32 617, i32 0, metadata !1942, null}
!1942 = metadata !{i32 786443, metadata !1, metadata !1940, i32 617, i32 0, i32 92} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1943 = metadata !{i32 617, i32 0, metadata !1944, null}
!1944 = metadata !{i32 786443, metadata !1, metadata !1940, i32 617, i32 0, i32 93} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1945 = metadata !{i32 618, i32 0, metadata !1938, null}
!1946 = metadata !{i32 619, i32 0, metadata !1938, null}
!1947 = metadata !{i32 620, i32 0, metadata !1257, null}
!1948 = metadata !{i32 786689, metadata !1135, metadata !"td", metadata !1105, i32 16778073, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 857]
!1949 = metadata !{i32 857, i32 0, metadata !1135, null}
!1950 = metadata !{i32 786689, metadata !1135, metadata !"uap", metadata !1105, i32 33555289, metadata !1138, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 857]
!1951 = metadata !{i32 786688, metadata !1135, metadata !"root", metadata !1105, i32 859, metadata !77, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [root] [line 859]
!1952 = metadata !{i32 859, i32 0, metadata !1135, null}
!1953 = metadata !{i32 786688, metadata !1135, metadata !"set", metadata !1105, i32 860, metadata !77, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [set] [line 860]
!1954 = metadata !{i32 860, i32 0, metadata !1135, null}
!1955 = metadata !{i32 786688, metadata !1135, metadata !"error", metadata !1105, i32 861, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 861]
!1956 = metadata !{i32 861, i32 0, metadata !1135, null}
!1957 = metadata !{i32 863, i32 0, metadata !1135, null}
!1958 = metadata !{i32 864, i32 0, metadata !1135, null}
!1959 = metadata !{i32 865, i32 0, metadata !1135, null}
!1960 = metadata !{i32 866, i32 0, metadata !1135, null}
!1961 = metadata !{i32 867, i32 0, metadata !1135, null}
!1962 = metadata !{i32 868, i32 0, metadata !1135, null}
!1963 = metadata !{i32 869, i32 0, metadata !1135, null}
!1964 = metadata !{i32 870, i32 0, metadata !1135, null}
!1965 = metadata !{i32 871, i32 0, metadata !1135, null}
!1966 = metadata !{i32 872, i32 0, metadata !1135, null}
!1967 = metadata !{i32 873, i32 0, metadata !1135, null}
!1968 = metadata !{i32 874, i32 0, metadata !1135, null}
!1969 = metadata !{i32 875, i32 0, metadata !1135, null}
!1970 = metadata !{i32 786689, metadata !1255, metadata !"set", metadata !1105, i32 16777352, metadata !77, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [set] [line 136]
!1971 = metadata !{i32 136, i32 0, metadata !1255, null}
!1972 = metadata !{i32 139, i32 0, metadata !1973, null}
!1973 = metadata !{i32 786443, metadata !1, metadata !1255, i32 139, i32 0, i32 64} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!1974 = metadata !{i32 140, i32 0, metadata !1973, null}
!1975 = metadata !{i32 141, i32 0, metadata !1973, null}
!1976 = metadata !{i32 142, i32 0, metadata !1255, null}
!1977 = metadata !{i32 144, i32 0, metadata !1255, null}
!1978 = metadata !{i32 786689, metadata !1149, metadata !"td", metadata !1105, i32 16778101, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 885]
!1979 = metadata !{i32 885, i32 0, metadata !1149, null}
!1980 = metadata !{i32 786689, metadata !1149, metadata !"uap", metadata !1105, i32 33555317, metadata !1152, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 885]
!1981 = metadata !{i32 786688, metadata !1149, metadata !"set", metadata !1105, i32 887, metadata !77, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [set] [line 887]
!1982 = metadata !{i32 887, i32 0, metadata !1149, null}
!1983 = metadata !{i32 786688, metadata !1149, metadata !"error", metadata !1105, i32 888, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 888]
!1984 = metadata !{i32 888, i32 0, metadata !1149, null}
!1985 = metadata !{i32 893, i32 0, metadata !1149, null}
!1986 = metadata !{i32 894, i32 0, metadata !1149, null}
!1987 = metadata !{i32 895, i32 0, metadata !1149, null}
!1988 = metadata !{i32 896, i32 0, metadata !1149, null}
!1989 = metadata !{i32 897, i32 0, metadata !1149, null}
!1990 = metadata !{i32 898, i32 0, metadata !1149, null}
!1991 = metadata !{i32 899, i32 0, metadata !1149, null}
!1992 = metadata !{i32 900, i32 0, metadata !1149, null}
!1993 = metadata !{i32 901, i32 0, metadata !1149, null}
!1994 = metadata !{i32 786689, metadata !1252, metadata !"setid", metadata !1105, i32 16777435, metadata !95, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [setid] [line 219]
!1995 = metadata !{i32 219, i32 0, metadata !1252, null}
!1996 = metadata !{i32 786689, metadata !1252, metadata !"td", metadata !1105, i32 33554651, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 219]
!1997 = metadata !{i32 786688, metadata !1252, metadata !"set", metadata !1105, i32 221, metadata !77, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [set] [line 221]
!1998 = metadata !{i32 221, i32 0, metadata !1252, null}
!1999 = metadata !{i32 223, i32 0, metadata !1252, null}
!2000 = metadata !{i32 224, i32 0, metadata !1252, null}
!2001 = metadata !{i32 225, i32 0, metadata !1252, null}
!2002 = metadata !{i32 226, i32 0, metadata !2003, null}
!2003 = metadata !{i32 786443, metadata !1, metadata !1252, i32 226, i32 0, i32 59} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2004 = metadata !{i32 227, i32 0, metadata !2003, null}
!2005 = metadata !{i32 228, i32 0, metadata !2003, null}
!2006 = metadata !{i32 229, i32 0, metadata !1252, null}
!2007 = metadata !{i32 230, i32 0, metadata !1252, null}
!2008 = metadata !{i32 231, i32 0, metadata !1252, null}
!2009 = metadata !{i32 233, i32 0, metadata !1252, null}
!2010 = metadata !{i32 233, i32 0, metadata !2011, null}
!2011 = metadata !{i32 786443, metadata !1, metadata !1252, i32 233, i32 0, i32 60} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2012 = metadata !{i32 234, i32 0, metadata !1252, null}
!2013 = metadata !{i32 786688, metadata !2014, metadata !"jset", metadata !1105, i32 235, metadata !77, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [jset] [line 235]
!2014 = metadata !{i32 786443, metadata !1, metadata !1252, i32 234, i32 0, i32 61} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2015 = metadata !{i32 235, i32 0, metadata !2014, null}
!2016 = metadata !{i32 786688, metadata !2014, metadata !"tset", metadata !1105, i32 235, metadata !77, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [tset] [line 235]
!2017 = metadata !{i32 237, i32 0, metadata !2014, null}
!2018 = metadata !{i32 238, i32 0, metadata !2019, null}
!2019 = metadata !{i32 786443, metadata !1, metadata !2014, i32 238, i32 0, i32 62} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2020 = metadata !{i32 239, i32 0, metadata !2019, null}
!2021 = metadata !{i32 240, i32 0, metadata !2019, null}
!2022 = metadata !{i32 241, i32 0, metadata !2014, null}
!2023 = metadata !{i32 242, i32 0, metadata !2024, null}
!2024 = metadata !{i32 786443, metadata !1, metadata !2014, i32 241, i32 0, i32 63} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2025 = metadata !{i32 243, i32 0, metadata !2024, null}
!2026 = metadata !{i32 244, i32 0, metadata !2024, null}
!2027 = metadata !{i32 245, i32 0, metadata !2014, null}
!2028 = metadata !{i32 247, i32 0, metadata !1252, null}
!2029 = metadata !{i32 248, i32 0, metadata !1252, null}
!2030 = metadata !{i32 786689, metadata !1169, metadata !"td", metadata !1105, i32 16778128, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 912]
!2031 = metadata !{i32 912, i32 0, metadata !1169, null}
!2032 = metadata !{i32 786689, metadata !1169, metadata !"uap", metadata !1105, i32 33555344, metadata !1172, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 912]
!2033 = metadata !{i32 786688, metadata !1169, metadata !"nset", metadata !1105, i32 914, metadata !77, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [nset] [line 914]
!2034 = metadata !{i32 914, i32 0, metadata !1169, null}
!2035 = metadata !{i32 786688, metadata !1169, metadata !"set", metadata !1105, i32 915, metadata !77, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [set] [line 915]
!2036 = metadata !{i32 915, i32 0, metadata !1169, null}
!2037 = metadata !{i32 786688, metadata !1169, metadata !"ttd", metadata !1105, i32 916, metadata !18, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [ttd] [line 916]
!2038 = metadata !{i32 916, i32 0, metadata !1169, null}
!2039 = metadata !{i32 786688, metadata !1169, metadata !"p", metadata !1105, i32 917, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 917]
!2040 = metadata !{i32 917, i32 0, metadata !1169, null}
!2041 = metadata !{i32 786688, metadata !1169, metadata !"id", metadata !1105, i32 918, metadata !95, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [id] [line 918]
!2042 = metadata !{i32 918, i32 0, metadata !1169, null}
!2043 = metadata !{i32 786688, metadata !1169, metadata !"error", metadata !1105, i32 919, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 919]
!2044 = metadata !{i32 919, i32 0, metadata !1169, null}
!2045 = metadata !{i32 921, i32 0, metadata !1169, null}
!2046 = metadata !{i32 922, i32 0, metadata !1169, null}
!2047 = metadata !{i32 923, i32 0, metadata !1169, null}
!2048 = metadata !{i32 924, i32 0, metadata !1169, null}
!2049 = metadata !{i32 925, i32 0, metadata !1169, null}
!2050 = metadata !{i32 926, i32 0, metadata !1169, null}
!2051 = metadata !{i32 929, i32 0, metadata !2052, null}
!2052 = metadata !{i32 786443, metadata !1, metadata !1169, i32 926, i32 0, i32 28} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2053 = metadata !{i32 930, i32 0, metadata !2052, null}
!2054 = metadata !{i32 931, i32 0, metadata !2052, null}
!2055 = metadata !{i32 932, i32 0, metadata !2052, null}
!2056 = metadata !{i32 933, i32 0, metadata !2052, null}
!2057 = metadata !{i32 936, i32 0, metadata !2052, null}
!2058 = metadata !{i32 938, i32 0, metadata !2052, null}
!2059 = metadata !{i32 940, i32 0, metadata !1169, null}
!2060 = metadata !{i32 942, i32 0, metadata !2061, null}
!2061 = metadata !{i32 786443, metadata !1, metadata !1169, i32 940, i32 0, i32 29} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2062 = metadata !{i32 943, i32 0, metadata !2061, null}
!2063 = metadata !{i32 944, i32 0, metadata !2061, null}
!2064 = metadata !{i32 945, i32 0, metadata !2061, null}
!2065 = metadata !{i32 947, i32 0, metadata !2061, null}
!2066 = metadata !{i32 949, i32 0, metadata !2061, null}
!2067 = metadata !{i32 951, i32 0, metadata !1169, null}
!2068 = metadata !{i32 952, i32 0, metadata !1169, null}
!2069 = metadata !{i32 953, i32 0, metadata !1169, null}
!2070 = metadata !{i32 954, i32 0, metadata !1169, null}
!2071 = metadata !{i32 956, i32 0, metadata !1169, null}
!2072 = metadata !{i32 957, i32 0, metadata !1169, null}
!2073 = metadata !{i32 786689, metadata !1251, metadata !"set", metadata !1105, i32 16777369, metadata !77, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [set] [line 153]
!2074 = metadata !{i32 153, i32 0, metadata !1251, null}
!2075 = metadata !{i32 156, i32 0, metadata !2076, null}
!2076 = metadata !{i32 786443, metadata !1, metadata !1251} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2077 = metadata !{i32 157, i32 0, metadata !2076, null}
!2078 = metadata !{i32 158, i32 0, metadata !2076, null}
!2079 = metadata !{i32 160, i32 0, metadata !2076, null}
!2080 = metadata !{i32 786689, metadata !1189, metadata !"td", metadata !1105, i32 16778185, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 969]
!2081 = metadata !{i32 969, i32 0, metadata !1189, null}
!2082 = metadata !{i32 786689, metadata !1189, metadata !"uap", metadata !1105, i32 33555401, metadata !1192, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 969]
!2083 = metadata !{i32 786688, metadata !1189, metadata !"ttd", metadata !1105, i32 971, metadata !18, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [ttd] [line 971]
!2084 = metadata !{i32 971, i32 0, metadata !1189, null}
!2085 = metadata !{i32 786688, metadata !1189, metadata !"nset", metadata !1105, i32 972, metadata !77, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [nset] [line 972]
!2086 = metadata !{i32 972, i32 0, metadata !1189, null}
!2087 = metadata !{i32 786688, metadata !1189, metadata !"set", metadata !1105, i32 973, metadata !77, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [set] [line 973]
!2088 = metadata !{i32 973, i32 0, metadata !1189, null}
!2089 = metadata !{i32 786688, metadata !1189, metadata !"p", metadata !1105, i32 974, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 974]
!2090 = metadata !{i32 974, i32 0, metadata !1189, null}
!2091 = metadata !{i32 786688, metadata !1189, metadata !"mask", metadata !1105, i32 975, metadata !1122, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [mask] [line 975]
!2092 = metadata !{i32 975, i32 0, metadata !1189, null}
!2093 = metadata !{i32 786688, metadata !1189, metadata !"error", metadata !1105, i32 976, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 976]
!2094 = metadata !{i32 976, i32 0, metadata !1189, null}
!2095 = metadata !{i32 786688, metadata !1189, metadata !"size", metadata !1105, i32 977, metadata !1206, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [size] [line 977]
!2096 = metadata !{i32 977, i32 0, metadata !1189, null}
!2097 = metadata !{i32 979, i32 0, metadata !1189, null}
!2098 = metadata !{i32 981, i32 0, metadata !1189, null}
!2099 = metadata !{i32 982, i32 0, metadata !1189, null}
!2100 = metadata !{i32 983, i32 0, metadata !1189, null}
!2101 = metadata !{i32 984, i32 0, metadata !1189, null}
!2102 = metadata !{i32 985, i32 0, metadata !1189, null}
!2103 = metadata !{i32 986, i32 0, metadata !1189, null}
!2104 = metadata !{i32 987, i32 0, metadata !1189, null}
!2105 = metadata !{i32 990, i32 0, metadata !2106, null}
!2106 = metadata !{i32 786443, metadata !1, metadata !1189, i32 987, i32 0, i32 30} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2107 = metadata !{i32 993, i32 0, metadata !2108, null}
!2108 = metadata !{i32 786443, metadata !1, metadata !2106, i32 990, i32 0, i32 31} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2109 = metadata !{i32 994, i32 0, metadata !2108, null}
!2110 = metadata !{i32 995, i32 0, metadata !2108, null}
!2111 = metadata !{i32 996, i32 0, metadata !2108, null}
!2112 = metadata !{i32 999, i32 0, metadata !2108, null}
!2113 = metadata !{i32 1001, i32 0, metadata !2108, null}
!2114 = metadata !{i32 1002, i32 0, metadata !2108, null}
!2115 = metadata !{i32 1004, i32 0, metadata !2106, null}
!2116 = metadata !{i32 1005, i32 0, metadata !2106, null}
!2117 = metadata !{i32 1007, i32 0, metadata !2106, null}
!2118 = metadata !{i32 1008, i32 0, metadata !2106, null}
!2119 = metadata !{i32 1009, i32 0, metadata !2106, null}
!2120 = metadata !{i32 1010, i32 0, metadata !2106, null}
!2121 = metadata !{i32 1012, i32 0, metadata !2106, null}
!2122 = metadata !{i32 1014, i32 0, metadata !2123, null}
!2123 = metadata !{i32 786443, metadata !1, metadata !2106, i32 1012, i32 0, i32 32} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2124 = metadata !{i32 1015, i32 0, metadata !2123, null}
!2125 = metadata !{i32 1016, i32 0, metadata !2123, null}
!2126 = metadata !{i32 1017, i32 0, metadata !2123, null}
!2127 = metadata !{i32 1019, i32 0, metadata !2128, null}
!2128 = metadata !{i32 786443, metadata !1, metadata !2123, i32 1019, i32 0, i32 33} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2129 = metadata !{i32 1020, i32 0, metadata !2130, null}
!2130 = metadata !{i32 786443, metadata !1, metadata !2128, i32 1019, i32 0, i32 34} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2131 = metadata !{i32 1021, i32 0, metadata !2130, null}
!2132 = metadata !{i32 786688, metadata !2133, metadata !"__i", metadata !1105, i32 1021, metadata !491, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [__i] [line 1021]
!2133 = metadata !{i32 786443, metadata !1, metadata !2130, i32 1021, i32 0, i32 35} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2134 = metadata !{i32 1021, i32 0, metadata !2133, null}
!2135 = metadata !{i32 1021, i32 0, metadata !2136, null}
!2136 = metadata !{i32 786443, metadata !1, metadata !2133, i32 1021, i32 0, i32 36} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2137 = metadata !{i32 1022, i32 0, metadata !2130, null}
!2138 = metadata !{i32 1023, i32 0, metadata !2130, null}
!2139 = metadata !{i32 1024, i32 0, metadata !2123, null}
!2140 = metadata !{i32 1027, i32 0, metadata !2123, null}
!2141 = metadata !{i32 1028, i32 0, metadata !2123, null}
!2142 = metadata !{i32 1030, i32 0, metadata !2123, null}
!2143 = metadata !{i32 1031, i32 0, metadata !2123, null}
!2144 = metadata !{i32 1033, i32 0, metadata !2106, null}
!2145 = metadata !{i32 1035, i32 0, metadata !2106, null}
!2146 = metadata !{i32 1036, i32 0, metadata !2106, null}
!2147 = metadata !{i32 1038, i32 0, metadata !1189, null}
!2148 = metadata !{i32 1039, i32 0, metadata !1189, null}
!2149 = metadata !{i32 1040, i32 0, metadata !1189, null}
!2150 = metadata !{i32 1041, i32 0, metadata !1189, null}
!2151 = metadata !{i32 1042, i32 0, metadata !1189, null}
!2152 = metadata !{i32 1043, i32 0, metadata !1189, null}
!2153 = metadata !{i32 1045, i32 0, metadata !1189, null}
!2154 = metadata !{i32 1046, i32 0, metadata !1189, null}
!2155 = metadata !{i32 1047, i32 0, metadata !1189, null}
!2156 = metadata !{i32 786689, metadata !1211, metadata !"td", metadata !1105, i32 16778275, metadata !18, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [td] [line 1059]
!2157 = metadata !{i32 1059, i32 0, metadata !1211, null}
!2158 = metadata !{i32 786689, metadata !1211, metadata !"uap", metadata !1105, i32 33555491, metadata !1214, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [uap] [line 1059]
!2159 = metadata !{i32 786688, metadata !1211, metadata !"nset", metadata !1105, i32 1061, metadata !77, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [nset] [line 1061]
!2160 = metadata !{i32 1061, i32 0, metadata !1211, null}
!2161 = metadata !{i32 786688, metadata !1211, metadata !"set", metadata !1105, i32 1062, metadata !77, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [set] [line 1062]
!2162 = metadata !{i32 1062, i32 0, metadata !1211, null}
!2163 = metadata !{i32 786688, metadata !1211, metadata !"ttd", metadata !1105, i32 1063, metadata !18, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [ttd] [line 1063]
!2164 = metadata !{i32 1063, i32 0, metadata !1211, null}
!2165 = metadata !{i32 786688, metadata !1211, metadata !"p", metadata !1105, i32 1064, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 1064]
!2166 = metadata !{i32 1064, i32 0, metadata !1211, null}
!2167 = metadata !{i32 786688, metadata !1211, metadata !"mask", metadata !1105, i32 1065, metadata !1122, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [mask] [line 1065]
!2168 = metadata !{i32 1065, i32 0, metadata !1211, null}
!2169 = metadata !{i32 786688, metadata !1211, metadata !"error", metadata !1105, i32 1066, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 1066]
!2170 = metadata !{i32 1066, i32 0, metadata !1211, null}
!2171 = metadata !{i32 1068, i32 0, metadata !1211, null}
!2172 = metadata !{i32 1070, i32 0, metadata !1211, null}
!2173 = metadata !{i32 1071, i32 0, metadata !1211, null}
!2174 = metadata !{i32 1072, i32 0, metadata !1211, null}
!2175 = metadata !{i32 1073, i32 0, metadata !1211, null}
!2176 = metadata !{i32 1074, i32 0, metadata !1211, null}
!2177 = metadata !{i32 1078, i32 0, metadata !1211, null}
!2178 = metadata !{i32 786688, metadata !2179, metadata !"end", metadata !1105, i32 1079, metadata !489, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [end] [line 1079]
!2179 = metadata !{i32 786443, metadata !1, metadata !1211, i32 1078, i32 0, i32 37} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2180 = metadata !{i32 1079, i32 0, metadata !2179, null}
!2181 = metadata !{i32 786688, metadata !2179, metadata !"cp", metadata !1105, i32 1080, metadata !489, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [cp] [line 1080]
!2182 = metadata !{i32 1080, i32 0, metadata !2179, null}
!2183 = metadata !{i32 1082, i32 0, metadata !2179, null}
!2184 = metadata !{i32 1083, i32 0, metadata !2179, null}
!2185 = metadata !{i32 1084, i32 0, metadata !2179, null}
!2186 = metadata !{i32 1085, i32 0, metadata !2179, null}
!2187 = metadata !{i32 1086, i32 0, metadata !2179, null}
!2188 = metadata !{i32 1087, i32 0, metadata !2189, null}
!2189 = metadata !{i32 786443, metadata !1, metadata !2179, i32 1086, i32 0, i32 38} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2190 = metadata !{i32 1088, i32 0, metadata !2189, null}
!2191 = metadata !{i32 1089, i32 0, metadata !2189, null}
!2192 = metadata !{i32 1091, i32 0, metadata !2179, null}
!2193 = metadata !{i32 1092, i32 0, metadata !1211, null}
!2194 = metadata !{i32 1095, i32 0, metadata !2195, null}
!2195 = metadata !{i32 786443, metadata !1, metadata !1211, i32 1092, i32 0, i32 39} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2196 = metadata !{i32 1096, i32 0, metadata !2195, null}
!2197 = metadata !{i32 1097, i32 0, metadata !2195, null}
!2198 = metadata !{i32 1098, i32 0, metadata !2195, null}
!2199 = metadata !{i32 1101, i32 0, metadata !2200, null}
!2200 = metadata !{i32 786443, metadata !1, metadata !2195, i32 1098, i32 0, i32 40} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2201 = metadata !{i32 1102, i32 0, metadata !2200, null}
!2202 = metadata !{i32 1103, i32 0, metadata !2200, null}
!2203 = metadata !{i32 1104, i32 0, metadata !2200, null}
!2204 = metadata !{i32 1105, i32 0, metadata !2200, null}
!2205 = metadata !{i32 1108, i32 0, metadata !2200, null}
!2206 = metadata !{i32 1110, i32 0, metadata !2200, null}
!2207 = metadata !{i32 1111, i32 0, metadata !2200, null}
!2208 = metadata !{i32 1113, i32 0, metadata !2195, null}
!2209 = metadata !{i32 1114, i32 0, metadata !2195, null}
!2210 = metadata !{i32 1116, i32 0, metadata !2195, null}
!2211 = metadata !{i32 1117, i32 0, metadata !2195, null}
!2212 = metadata !{i32 1118, i32 0, metadata !2195, null}
!2213 = metadata !{i32 1119, i32 0, metadata !2195, null}
!2214 = metadata !{i32 1120, i32 0, metadata !2195, null}
!2215 = metadata !{i32 1122, i32 0, metadata !2195, null}
!2216 = metadata !{i32 1124, i32 0, metadata !2217, null}
!2217 = metadata !{i32 786443, metadata !1, metadata !2195, i32 1122, i32 0, i32 41} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2218 = metadata !{i32 1125, i32 0, metadata !2217, null}
!2219 = metadata !{i32 1127, i32 0, metadata !2217, null}
!2220 = metadata !{i32 1128, i32 0, metadata !2217, null}
!2221 = metadata !{i32 1131, i32 0, metadata !2217, null}
!2222 = metadata !{i32 1133, i32 0, metadata !2217, null}
!2223 = metadata !{i32 1134, i32 0, metadata !2224, null}
!2224 = metadata !{i32 786443, metadata !1, metadata !2217, i32 1133, i32 0, i32 42} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2225 = metadata !{i32 1135, i32 0, metadata !2224, null}
!2226 = metadata !{i32 1136, i32 0, metadata !2224, null}
!2227 = metadata !{i32 1137, i32 0, metadata !2217, null}
!2228 = metadata !{i32 1139, i32 0, metadata !2217, null}
!2229 = metadata !{i32 1140, i32 0, metadata !2217, null}
!2230 = metadata !{i32 1142, i32 0, metadata !2217, null}
!2231 = metadata !{i32 1143, i32 0, metadata !2217, null}
!2232 = metadata !{i32 1145, i32 0, metadata !2195, null}
!2233 = metadata !{i32 1147, i32 0, metadata !2195, null}
!2234 = metadata !{i32 1148, i32 0, metadata !2195, null}
!2235 = metadata !{i32 1149, i32 0, metadata !2195, null}
!2236 = metadata !{i32 1151, i32 0, metadata !1211, null}
!2237 = metadata !{i32 1152, i32 0, metadata !1211, null}
!2238 = metadata !{i32 1153, i32 0, metadata !1211, null}
!2239 = metadata !{i32 786689, metadata !1240, metadata !"set", metadata !1105, i32 16777567, metadata !77, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [set] [line 351]
!2240 = metadata !{i32 351, i32 0, metadata !1240, null}
!2241 = metadata !{i32 786689, metadata !1240, metadata !"mask", metadata !1105, i32 33554783, metadata !1122, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [mask] [line 351]
!2242 = metadata !{i32 786688, metadata !1240, metadata !"root", metadata !1105, i32 353, metadata !77, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [root] [line 353]
!2243 = metadata !{i32 353, i32 0, metadata !1240, null}
!2244 = metadata !{i32 786688, metadata !1240, metadata !"error", metadata !1105, i32 354, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 354]
!2245 = metadata !{i32 354, i32 0, metadata !1240, null}
!2246 = metadata !{i32 356, i32 21, metadata !1240, null}
!2247 = metadata !{i32 357, i32 0, metadata !1240, null}
!2248 = metadata !{i32 358, i32 0, metadata !1240, null}
!2249 = metadata !{i32 365, i32 13, metadata !1240, null}
!2250 = metadata !{i32 367, i32 0, metadata !1240, null}
!2251 = metadata !{i32 372, i32 0, metadata !1240, null}
!2252 = metadata !{i32 373, i32 0, metadata !1240, null}
!2253 = metadata !{i32 786688, metadata !2254, metadata !"__i", metadata !1105, i32 373, metadata !491, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [__i] [line 373]
!2254 = metadata !{i32 786443, metadata !1, metadata !1240, i32 373, i32 0, i32 49} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2255 = metadata !{i32 373, i32 0, metadata !2254, null}
!2256 = metadata !{i32 373, i32 0, metadata !2257, null}
!2257 = metadata !{i32 786443, metadata !1, metadata !2254, i32 373, i32 0, i32 50} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2258 = metadata !{i32 374, i32 0, metadata !1240, null}
!2259 = metadata !{i32 375, i32 0, metadata !1240, null}
!2260 = metadata !{i32 376, i32 0, metadata !1240, null}
!2261 = metadata !{i32 377, i32 0, metadata !1240, null}
!2262 = metadata !{i32 378, i32 0, metadata !1240, null}
!2263 = metadata !{i32 379, i32 0, metadata !1240, null}
!2264 = metadata !{i32 380, i32 0, metadata !1240, null}
!2265 = metadata !{i32 382, i32 0, metadata !1240, null}
!2266 = metadata !{i32 384, i32 0, metadata !1240, null}
!2267 = metadata !{i32 385, i32 0, metadata !1240, null}
!2268 = metadata !{i32 786689, metadata !1232, metadata !"arg", metadata !1105, i32 16778372, metadata !178, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [arg] [line 1156]
!2269 = metadata !{i32 1156, i32 0, metadata !1232, null}
!2270 = metadata !{i32 786689, metadata !1233, metadata !"addr", metadata !1105, i32 16778372, metadata !1236, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [addr] [line 1156]
!2271 = metadata !{i32 1156, i32 0, metadata !1233, null}
!2272 = metadata !{i32 786689, metadata !1233, metadata !"have_addr", metadata !1105, i32 33555588, metadata !1238, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [have_addr] [line 1156]
!2273 = metadata !{i32 786689, metadata !1233, metadata !"count", metadata !1105, i32 50332804, metadata !1236, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [count] [line 1156]
!2274 = metadata !{i32 786689, metadata !1233, metadata !"modif", metadata !1105, i32 67110020, metadata !489, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [modif] [line 1156]
!2275 = metadata !{i32 786688, metadata !1233, metadata !"set", metadata !1105, i32 1158, metadata !77, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [set] [line 1158]
!2276 = metadata !{i32 1158, i32 0, metadata !1233, null}
!2277 = metadata !{i32 786688, metadata !1233, metadata !"cpu", metadata !1105, i32 1159, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [cpu] [line 1159]
!2278 = metadata !{i32 1159, i32 0, metadata !1233, null}
!2279 = metadata !{i32 786688, metadata !1233, metadata !"once", metadata !1105, i32 1159, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [once] [line 1159]
!2280 = metadata !{i32 1161, i32 0, metadata !2281, null}
!2281 = metadata !{i32 786443, metadata !1, metadata !1233, i32 1161, i32 0, i32 43} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2282 = metadata !{i32 1162, i32 0, metadata !2283, null}
!2283 = metadata !{i32 786443, metadata !1, metadata !2281, i32 1161, i32 0, i32 44} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2284 = metadata !{i32 1165, i32 0, metadata !2283, null}
!2285 = metadata !{i32 1166, i32 0, metadata !2286, null}
!2286 = metadata !{i32 786443, metadata !1, metadata !2283, i32 1166, i32 0, i32 45} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2287 = metadata !{i32 1167, i32 0, metadata !2288, null}
!2288 = metadata !{i32 786443, metadata !1, metadata !2286, i32 1166, i32 0, i32 46} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2289 = metadata !{i32 1168, i32 0, metadata !2290, null}
!2290 = metadata !{i32 786443, metadata !1, metadata !2288, i32 1167, i32 0, i32 47} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2291 = metadata !{i32 1169, i32 0, metadata !2292, null}
!2292 = metadata !{i32 786443, metadata !1, metadata !2290, i32 1168, i32 0, i32 48} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2293 = metadata !{i32 1170, i32 0, metadata !2292, null}
!2294 = metadata !{i32 1171, i32 0, metadata !2292, null}
!2295 = metadata !{i32 1172, i32 0, metadata !2290, null}
!2296 = metadata !{i32 1173, i32 0, metadata !2290, null}
!2297 = metadata !{i32 1174, i32 0, metadata !2288, null}
!2298 = metadata !{i32 1175, i32 0, metadata !2283, null}
!2299 = metadata !{i32 1176, i32 0, metadata !2283, null}
!2300 = metadata !{i32 1177, i32 0, metadata !2283, null}
!2301 = metadata !{i32 1178, i32 0, metadata !2283, null}
!2302 = metadata !{i32 1179, i32 0, metadata !1233, null}
!2303 = metadata !{i32 786689, metadata !1239, metadata !"arg", metadata !1105, i32 16778372, metadata !178, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [arg] [line 1156]
!2304 = metadata !{i32 1156, i32 0, metadata !1239, null}
!2305 = metadata !{i32 786688, metadata !2306, metadata !"td", metadata !1248, i32 234, metadata !18, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [td] [line 234]
!2306 = metadata !{i32 786443, metadata !526, metadata !1247} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA/./machine/pcpu.h]
!2307 = metadata !{i32 234, i32 0, metadata !2306, null}
!2308 = metadata !{i32 236, i32 0, metadata !2306, null}
!2309 = metadata !{i32 779808}
!2310 = metadata !{i32 238, i32 0, metadata !2306, null}
!2311 = metadata !{i32 786689, metadata !1246, metadata !"set", metadata !1105, i32 16777525, metadata !77, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [set] [line 309]
!2312 = metadata !{i32 309, i32 0, metadata !1246, null}
!2313 = metadata !{i32 786689, metadata !1246, metadata !"mask", metadata !1105, i32 33554741, metadata !1122, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [mask] [line 309]
!2314 = metadata !{i32 786688, metadata !1246, metadata !"nset", metadata !1105, i32 311, metadata !77, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [nset] [line 311]
!2315 = metadata !{i32 311, i32 0, metadata !1246, null}
!2316 = metadata !{i32 786688, metadata !1246, metadata !"newmask", metadata !1105, i32 312, metadata !81, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [newmask] [line 312]
!2317 = metadata !{i32 312, i32 0, metadata !1246, null}
!2318 = metadata !{i32 786688, metadata !1246, metadata !"error", metadata !1105, i32 313, metadata !93, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [error] [line 313]
!2319 = metadata !{i32 313, i32 0, metadata !1246, null}
!2320 = metadata !{i32 315, i32 0, metadata !1246, null}
!2321 = metadata !{i32 316, i32 0, metadata !1246, null}
!2322 = metadata !{i32 317, i32 0, metadata !1246, null}
!2323 = metadata !{i32 786688, metadata !2324, metadata !"__i", metadata !1105, i32 318, metadata !491, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [__i] [line 318]
!2324 = metadata !{i32 786443, metadata !1, metadata !1246, i32 318, i32 0, i32 54} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2325 = metadata !{i32 318, i32 0, metadata !2324, null}
!2326 = metadata !{i32 318, i32 0, metadata !2327, null}
!2327 = metadata !{i32 786443, metadata !1, metadata !2324, i32 318, i32 0, i32 55} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2328 = metadata !{i32 319, i32 0, metadata !1246, null}
!2329 = metadata !{i32 320, i32 0, metadata !1246, null}
!2330 = metadata !{i32 321, i32 0, metadata !1246, null}
!2331 = metadata !{i32 786688, metadata !2332, metadata !"__i", metadata !1105, i32 321, metadata !491, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [__i] [line 321]
!2332 = metadata !{i32 786443, metadata !1, metadata !1246, i32 321, i32 0, i32 56} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2333 = metadata !{i32 321, i32 0, metadata !2332, null}
!2334 = metadata !{i32 321, i32 0, metadata !2335, null}
!2335 = metadata !{i32 786443, metadata !1, metadata !2332, i32 321, i32 0, i32 57} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2336 = metadata !{i32 322, i32 0, metadata !1246, null}
!2337 = metadata !{i32 323, i32 0, metadata !2338, null}
!2338 = metadata !{i32 786443, metadata !1, metadata !1246, i32 323, i32 0, i32 58} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2339 = metadata !{i32 324, i32 0, metadata !2338, null}
!2340 = metadata !{i32 325, i32 0, metadata !2338, null}
!2341 = metadata !{i32 326, i32 0, metadata !1246, null}
!2342 = metadata !{i32 327, i32 0, metadata !1246, null}
!2343 = metadata !{i32 786689, metadata !1243, metadata !"set", metadata !1105, i32 16777549, metadata !77, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [set] [line 333]
!2344 = metadata !{i32 333, i32 0, metadata !1243, null}
!2345 = metadata !{i32 786689, metadata !1243, metadata !"mask", metadata !1105, i32 33554765, metadata !1122, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [mask] [line 333]
!2346 = metadata !{i32 786688, metadata !1243, metadata !"nset", metadata !1105, i32 335, metadata !77, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [nset] [line 335]
!2347 = metadata !{i32 335, i32 0, metadata !1243, null}
!2348 = metadata !{i32 337, i32 0, metadata !1243, null}
!2349 = metadata !{i32 338, i32 0, metadata !1243, null}
!2350 = metadata !{i32 786688, metadata !2351, metadata !"__i", metadata !1105, i32 338, metadata !491, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [__i] [line 338]
!2351 = metadata !{i32 786443, metadata !1, metadata !1243, i32 338, i32 0, i32 51} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2352 = metadata !{i32 338, i32 0, metadata !2351, null}
!2353 = metadata !{i32 338, i32 0, metadata !2354, null}
!2354 = metadata !{i32 786443, metadata !1, metadata !2351, i32 338, i32 0, i32 52} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2355 = metadata !{i32 339, i32 0, metadata !2356, null}
!2356 = metadata !{i32 786443, metadata !1, metadata !1243, i32 339, i32 0, i32 53} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2357 = metadata !{i32 340, i32 0, metadata !2356, null}
!2358 = metadata !{i32 342, i32 0, metadata !1243, null}
!2359 = metadata !{i32 786689, metadata !1256, metadata !"arg", metadata !1105, i32 16778056, metadata !178, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [arg] [line 840]
!2360 = metadata !{i32 840, i32 0, metadata !1256, null}
!2361 = metadata !{i32 786688, metadata !1256, metadata !"mask", metadata !1105, i32 842, metadata !81, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [mask] [line 842]
!2362 = metadata !{i32 842, i32 0, metadata !1256, null}
!2363 = metadata !{i32 844, i32 0, metadata !1256, null}
!2364 = metadata !{i32 845, i32 0, metadata !1256, null}
!2365 = metadata !{i32 846, i32 0, metadata !1256, null}
!2366 = metadata !{i32 847, i32 0, metadata !1256, null}
!2367 = metadata !{i32 848, i32 0, metadata !1256, null}
!2368 = metadata !{i32 786689, metadata !1261, metadata !"head", metadata !1105, i32 16777406, metadata !1264, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [head] [line 190]
!2369 = metadata !{i32 190, i32 0, metadata !1261, null}
!2370 = metadata !{i32 786689, metadata !1261, metadata !"set", metadata !1105, i32 33554622, metadata !77, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [set] [line 190]
!2371 = metadata !{i32 193, i32 6, metadata !1261, null}
!2372 = metadata !{i32 194, i32 0, metadata !1261, null}
!2373 = metadata !{i32 195, i32 0, metadata !1261, null}
!2374 = metadata !{i32 196, i32 0, metadata !1261, null}
!2375 = metadata !{i32 196, i32 0, metadata !2376, null}
!2376 = metadata !{i32 786443, metadata !1, metadata !1261, i32 196, i32 0, i32 97} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2377 = metadata !{i32 196, i32 0, metadata !2378, null}
!2378 = metadata !{i32 786443, metadata !1, metadata !2376, i32 196, i32 0, i32 98} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2379 = metadata !{i32 196, i32 0, metadata !2380, null}
!2380 = metadata !{i32 786443, metadata !1, metadata !2376, i32 196, i32 0, i32 99} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2381 = metadata !{i32 197, i32 0, metadata !1261, null}
!2382 = metadata !{i32 198, i32 0, metadata !1261, null}
!2383 = metadata !{i32 198, i32 0, metadata !2384, null}
!2384 = metadata !{i32 786443, metadata !1, metadata !1261, i32 198, i32 0, i32 100} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2385 = metadata !{i32 198, i32 0, metadata !2386, null}
!2386 = metadata !{i32 786443, metadata !1, metadata !2384, i32 198, i32 0, i32 101} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2387 = metadata !{i32 198, i32 0, metadata !2388, null}
!2388 = metadata !{i32 786443, metadata !1, metadata !2384, i32 198, i32 0, i32 102} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2389 = metadata !{i32 199, i32 0, metadata !1261, null}
!2390 = metadata !{i32 199, i32 0, metadata !2391, null}
!2391 = metadata !{i32 786443, metadata !1, metadata !1261, i32 199, i32 0, i32 103} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2392 = metadata !{i32 199, i32 0, metadata !2393, null}
!2393 = metadata !{i32 786443, metadata !1, metadata !2391, i32 199, i32 0, i32 104} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2394 = metadata !{i32 200, i32 0, metadata !1261, null}
!2395 = metadata !{i32 786689, metadata !1260, metadata !"set", metadata !1105, i32 16777424, metadata !77, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [set] [line 208]
!2396 = metadata !{i32 208, i32 0, metadata !1260, null}
!2397 = metadata !{i32 210, i32 0, metadata !1260, null}
!2398 = metadata !{i32 210, i32 0, metadata !2399, null}
!2399 = metadata !{i32 786443, metadata !1, metadata !1260, i32 210, i32 0, i32 94} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2400 = metadata !{i32 210, i32 0, metadata !2401, null}
!2401 = metadata !{i32 786443, metadata !1, metadata !2399, i32 210, i32 0, i32 95} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2402 = metadata !{i32 210, i32 0, metadata !2403, null}
!2403 = metadata !{i32 786443, metadata !1, metadata !2399, i32 210, i32 0, i32 96} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/kern/kern_cpuset.c]
!2404 = metadata !{i32 211, i32 0, metadata !1260, null}
!2405 = metadata !{i32 212, i32 0, metadata !1260, null}
!2406 = metadata !{i32 213, i32 0, metadata !1260, null}
!2407 = metadata !{i32 786689, metadata !1271, metadata !"count", metadata !1273, i32 16777261, metadata !1276, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [count] [line 45]
!2408 = metadata !{i32 45, i32 0, metadata !1271, null}
!2409 = metadata !{i32 786689, metadata !1271, metadata !"value", metadata !1273, i32 33554477, metadata !36, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [value] [line 45]
!2410 = metadata !{i32 48, i32 0, metadata !2411, null}
!2411 = metadata !{i32 786443, metadata !1272, metadata !1271} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA//home/jra40/P4/tesla/sys/sys/refcount.h]
!2412 = metadata !{i32 49, i32 0, metadata !2411, null}
!2413 = metadata !{i32 786689, metadata !1296, metadata !"mask", metadata !1293, i32 16777292, metadata !495, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [mask] [line 76]
!2414 = metadata !{i32 76, i32 0, metadata !1296, null}
!2415 = metadata !{i32 786688, metadata !1296, metadata !"result", metadata !1293, i32 78, metadata !495, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [result] [line 78]
!2416 = metadata !{i32 78, i32 0, metadata !1296, null}
!2417 = metadata !{i32 80, i32 0, metadata !1296, null}
!2418 = metadata !{i32 203831}
!2419 = metadata !{i32 81, i32 0, metadata !1296, null}
!2420 = metadata !{i32 786689, metadata !1305, metadata !"p", metadata !1307, i32 16777397, metadata !1276, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [p] [line 181]
!2421 = metadata !{i32 181, i32 0, metadata !1305, null}
!2422 = metadata !{i32 786689, metadata !1305, metadata !"v", metadata !1307, i32 33554613, metadata !36, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [v] [line 181]
!2423 = metadata !{i32 184, i32 0, metadata !2424, null}
!2424 = metadata !{i32 786443, metadata !1306, metadata !1305} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA/./machine/atomic.h]
!2425 = metadata !{i32 178088}
!2426 = metadata !{i32 192, i32 0, metadata !2424, null}
!2427 = metadata !{i32 786689, metadata !1313, metadata !"p", metadata !1307, i32 16777498, metadata !1276, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [p] [line 282]
!2428 = metadata !{i32 282, i32 0, metadata !1313, null}
!2429 = metadata !{i32 786689, metadata !1313, metadata !"v", metadata !1307, i32 33554714, metadata !36, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [v] [line 282]
!2430 = metadata !{i32 282, i32 0, metadata !2431, null}
!2431 = metadata !{i32 786443, metadata !1306, metadata !1313} ; [ DW_TAG_lexical_block ] [/pool/users/jra40/obj/home/jra40/P4/tesla/sys/TESLA/./machine/atomic.h]
!2432 = metadata !{i32 -2147288497}

