/*
 * RUN: tesla analyse %s -o %t.tesla -- -std=c99 -target amd64-freebsd-10.0
 */

# 1 "/home/jra40/P4/tesla/sys/cam/cam.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 153 "<built-in>" 3
# 1 "<command line>" 1



# 1 "opt_global.h" 1
# 5 "<command line>" 2
# 1 "<built-in>" 2
# 1 "/home/jra40/P4/tesla/sys/cam/cam.c" 2
# 29 "/home/jra40/P4/tesla/sys/cam/cam.c"
# 1 "/home/jra40/P4/tesla/sys/sys/cdefs.h" 1
# 30 "/home/jra40/P4/tesla/sys/cam/cam.c" 2
__asm__(".ident\t\"" "$FreeBSD: head/sys/cam/cam.c 248922 2013-03-29 22:58:15Z smh $" "\"");


# 1 "/home/jra40/P4/tesla/sys/sys/param.h" 1
# 41 "/home/jra40/P4/tesla/sys/sys/param.h"
# 1 "/home/jra40/P4/tesla/sys/sys/_null.h" 1
# 42 "/home/jra40/P4/tesla/sys/sys/param.h" 2
# 86 "/home/jra40/P4/tesla/sys/sys/param.h"
# 1 "/home/jra40/P4/tesla/sys/sys/types.h" 1
# 44 "/home/jra40/P4/tesla/sys/sys/types.h"
# 1 "./machine/endian.h" 1





# 1 "./x86/endian.h" 1
# 37 "./x86/endian.h"
# 1 "/home/jra40/P4/tesla/sys/sys/_types.h" 1
# 33 "/home/jra40/P4/tesla/sys/sys/_types.h"
# 1 "./machine/_types.h" 1





# 1 "./x86/_types.h" 1
# 51 "./x86/_types.h"
typedef signed char __int8_t;
typedef unsigned char __uint8_t;
typedef short __int16_t;
typedef unsigned short __uint16_t;
typedef int __int32_t;
typedef unsigned int __uint32_t;

typedef long __int64_t;
typedef unsigned long __uint64_t;
# 77 "./x86/_types.h"
typedef __int32_t __clock_t;
typedef __int64_t __critical_t;
typedef double __double_t;
typedef float __float_t;
typedef __int64_t __intfptr_t;
typedef __int64_t __intptr_t;
# 91 "./x86/_types.h"
typedef __int64_t __intmax_t;
typedef __int32_t __int_fast8_t;
typedef __int32_t __int_fast16_t;
typedef __int32_t __int_fast32_t;
typedef __int64_t __int_fast64_t;
typedef __int8_t __int_least8_t;
typedef __int16_t __int_least16_t;
typedef __int32_t __int_least32_t;
typedef __int64_t __int_least64_t;

typedef __int64_t __ptrdiff_t;
typedef __int64_t __register_t;
typedef __int64_t __segsz_t;
typedef __uint64_t __size_t;
typedef __int64_t __ssize_t;
typedef __int64_t __time_t;
typedef __uint64_t __uintfptr_t;
typedef __uint64_t __uintptr_t;
# 119 "./x86/_types.h"
typedef __uint64_t __uintmax_t;
typedef __uint32_t __uint_fast8_t;
typedef __uint32_t __uint_fast16_t;
typedef __uint32_t __uint_fast32_t;
typedef __uint64_t __uint_fast64_t;
typedef __uint8_t __uint_least8_t;
typedef __uint16_t __uint_least16_t;
typedef __uint32_t __uint_least32_t;
typedef __uint64_t __uint_least64_t;

typedef __uint64_t __u_register_t;
typedef __uint64_t __vm_offset_t;
typedef __uint64_t __vm_paddr_t;
typedef __uint64_t __vm_size_t;
# 143 "./x86/_types.h"
typedef __int64_t __vm_ooffset_t;
typedef __uint64_t __vm_pindex_t;
typedef int __wchar_t;
# 154 "./x86/_types.h"
typedef __builtin_va_list __va_list;






typedef __va_list __gnuc_va_list;
# 7 "./machine/_types.h" 2
# 34 "/home/jra40/P4/tesla/sys/sys/_types.h" 2




typedef __uint32_t __blksize_t;
typedef __int64_t __blkcnt_t;
typedef __int32_t __clockid_t;
typedef __uint64_t __cap_rights_t;
typedef __uint32_t __fflags_t;
typedef __uint64_t __fsblkcnt_t;
typedef __uint64_t __fsfilcnt_t;
typedef __uint32_t __gid_t;
typedef __int64_t __id_t;
typedef __uint32_t __ino_t;
typedef long __key_t;
typedef __int32_t __lwpid_t;
typedef __uint16_t __mode_t;
typedef int __accmode_t;
typedef int __nl_item;
typedef __uint16_t __nlink_t;
typedef __int64_t __off_t;
typedef __int32_t __pid_t;
typedef __int64_t __rlim_t;


typedef __uint8_t __sa_family_t;
typedef __uint32_t __socklen_t;
typedef long __suseconds_t;
typedef struct __timer *__timer_t;
typedef struct __mq *__mqd_t;
typedef __uint32_t __uid_t;
typedef unsigned int __useconds_t;
typedef int __cpuwhich_t;
typedef int __cpulevel_t;
typedef int __cpusetid_t;
# 88 "/home/jra40/P4/tesla/sys/sys/_types.h"
typedef int __ct_rune_t;
typedef __ct_rune_t __rune_t;
typedef __ct_rune_t __wint_t;



typedef __uint_least16_t __char16_t;
typedef __uint_least32_t __char32_t;







typedef __uint32_t __dev_t;

typedef __uint32_t __fixpt_t;





typedef union {
 char __mbstate8[128];
 __int64_t _mbstateL;
} __mbstate_t;
# 38 "./x86/endian.h" 2
# 91 "./x86/endian.h"
static __inline __uint16_t
__bswap16_var(__uint16_t _x)
{

 return ((__uint16_t)((_x) << 8 | (_x) >> 8));
}

static __inline __uint32_t
__bswap32_var(__uint32_t _x)
{


 __asm("bswap %0" : "+r" (_x));
 return (_x);



}

static __inline __uint64_t
__bswap64_var(__uint64_t _x)
{


 __asm("bswap %0" : "+r" (_x));
 return (_x);







}
# 7 "./machine/endian.h" 2
# 45 "/home/jra40/P4/tesla/sys/sys/types.h" 2


# 1 "/home/jra40/P4/tesla/sys/sys/_pthreadtypes.h" 1
# 44 "/home/jra40/P4/tesla/sys/sys/_pthreadtypes.h"
struct pthread;
struct pthread_attr;
struct pthread_cond;
struct pthread_cond_attr;
struct pthread_mutex;
struct pthread_mutex_attr;
struct pthread_once;
struct pthread_rwlock;
struct pthread_rwlockattr;
struct pthread_barrier;
struct pthread_barrier_attr;
struct pthread_spinlock;
# 65 "/home/jra40/P4/tesla/sys/sys/_pthreadtypes.h"
typedef struct pthread *pthread_t;


typedef struct pthread_attr *pthread_attr_t;
typedef struct pthread_mutex *pthread_mutex_t;
typedef struct pthread_mutex_attr *pthread_mutexattr_t;
typedef struct pthread_cond *pthread_cond_t;
typedef struct pthread_cond_attr *pthread_condattr_t;
typedef int pthread_key_t;
typedef struct pthread_once pthread_once_t;
typedef struct pthread_rwlock *pthread_rwlock_t;
typedef struct pthread_rwlockattr *pthread_rwlockattr_t;
typedef struct pthread_barrier *pthread_barrier_t;
typedef struct pthread_barrierattr *pthread_barrierattr_t;
typedef struct pthread_spinlock *pthread_spinlock_t;







typedef void *pthread_addr_t;
typedef void *(*pthread_startroutine_t)(void *);




struct pthread_once {
 int state;
 pthread_mutex_t mutex;
};
# 48 "/home/jra40/P4/tesla/sys/sys/types.h" 2


typedef unsigned char u_char;
typedef unsigned short u_short;
typedef unsigned int u_int;
typedef unsigned long u_long;
# 63 "/home/jra40/P4/tesla/sys/sys/types.h"
# 1 "/home/jra40/P4/tesla/sys/sys/_stdint.h" 1
# 34 "/home/jra40/P4/tesla/sys/sys/_stdint.h"
typedef __int8_t int8_t;




typedef __int16_t int16_t;




typedef __int32_t int32_t;




typedef __int64_t int64_t;




typedef __uint8_t uint8_t;




typedef __uint16_t uint16_t;




typedef __uint32_t uint32_t;




typedef __uint64_t uint64_t;




typedef __intptr_t intptr_t;



typedef __uintptr_t uintptr_t;
# 64 "/home/jra40/P4/tesla/sys/sys/types.h" 2

typedef __uint8_t u_int8_t;
typedef __uint16_t u_int16_t;
typedef __uint32_t u_int32_t;
typedef __uint64_t u_int64_t;

typedef __uint64_t u_quad_t;
typedef __int64_t quad_t;
typedef quad_t * qaddr_t;

typedef char * caddr_t;
typedef const char * c_caddr_t;


typedef __blksize_t blksize_t;



typedef __cpuwhich_t cpuwhich_t;
typedef __cpulevel_t cpulevel_t;
typedef __cpusetid_t cpusetid_t;


typedef __blkcnt_t blkcnt_t;



typedef __cap_rights_t cap_rights_t;


typedef __clock_t clock_t;




typedef __clockid_t clockid_t;



typedef __critical_t critical_t;
typedef __int64_t daddr_t;


typedef __dev_t dev_t;




typedef __fflags_t fflags_t;



typedef __fixpt_t fixpt_t;


typedef __fsblkcnt_t fsblkcnt_t;
typedef __fsfilcnt_t fsfilcnt_t;




typedef __gid_t gid_t;




typedef __uint32_t in_addr_t;




typedef __uint16_t in_port_t;




typedef __id_t id_t;




typedef __ino_t ino_t;




typedef __key_t key_t;




typedef __lwpid_t lwpid_t;




typedef __mode_t mode_t;




typedef __accmode_t accmode_t;




typedef __nlink_t nlink_t;




typedef __off_t off_t;




typedef __pid_t pid_t;



typedef __register_t register_t;


typedef __rlim_t rlim_t;



typedef __int64_t sbintime_t;

typedef __segsz_t segsz_t;


typedef __size_t size_t;




typedef __ssize_t ssize_t;




typedef __suseconds_t suseconds_t;




typedef __time_t time_t;




typedef __timer_t timer_t;




typedef __mqd_t mqd_t;



typedef __u_register_t u_register_t;


typedef __uid_t uid_t;




typedef __useconds_t useconds_t;



typedef __vm_offset_t vm_offset_t;
typedef __vm_ooffset_t vm_ooffset_t;
typedef __vm_paddr_t vm_paddr_t;
typedef __vm_pindex_t vm_pindex_t;
typedef __vm_size_t vm_size_t;


typedef int boolean_t;
typedef struct device *device_t;
typedef __intfptr_t intfptr_t;
# 258 "/home/jra40/P4/tesla/sys/sys/types.h"
typedef __uint32_t intrmask_t;

typedef __uintfptr_t uintfptr_t;
typedef __uint64_t uoff_t;
typedef char vm_memattr_t;
typedef struct vm_page *vm_page_t;
# 272 "/home/jra40/P4/tesla/sys/sys/types.h"
typedef _Bool bool;
# 285 "/home/jra40/P4/tesla/sys/sys/types.h"
# 1 "/home/jra40/P4/tesla/sys/sys/select.h" 1
# 38 "/home/jra40/P4/tesla/sys/sys/select.h"
# 1 "/home/jra40/P4/tesla/sys/sys/_sigset.h" 1
# 51 "/home/jra40/P4/tesla/sys/sys/_sigset.h"
typedef struct __sigset {
 __uint32_t __bits[4];
} __sigset_t;
# 39 "/home/jra40/P4/tesla/sys/sys/select.h" 2
# 1 "/home/jra40/P4/tesla/sys/sys/_timeval.h" 1
# 47 "/home/jra40/P4/tesla/sys/sys/_timeval.h"
struct timeval {
 time_t tv_sec;
 suseconds_t tv_usec;
};
# 40 "/home/jra40/P4/tesla/sys/sys/select.h" 2
# 1 "/home/jra40/P4/tesla/sys/sys/timespec.h" 1
# 38 "/home/jra40/P4/tesla/sys/sys/timespec.h"
# 1 "/home/jra40/P4/tesla/sys/sys/_timespec.h" 1
# 44 "/home/jra40/P4/tesla/sys/sys/_timespec.h"
struct timespec {
 time_t tv_sec;
 long tv_nsec;
};
# 39 "/home/jra40/P4/tesla/sys/sys/timespec.h" 2
# 58 "/home/jra40/P4/tesla/sys/sys/timespec.h"
struct itimerspec {
 struct timespec it_interval;
 struct timespec it_value;
};
# 41 "/home/jra40/P4/tesla/sys/sys/select.h" 2

typedef unsigned long __fd_mask;

typedef __fd_mask fd_mask;




typedef __sigset_t sigset_t;
# 71 "/home/jra40/P4/tesla/sys/sys/select.h"
typedef struct fd_set {
 __fd_mask __fds_bits[(((1024U) + (((sizeof(__fd_mask) * 8)) - 1)) / ((sizeof(__fd_mask) * 8)))];
} fd_set;
# 286 "/home/jra40/P4/tesla/sys/sys/types.h" 2
# 87 "/home/jra40/P4/tesla/sys/sys/param.h" 2








# 1 "/home/jra40/P4/tesla/sys/sys/syslimits.h" 1
# 96 "/home/jra40/P4/tesla/sys/sys/param.h" 2
# 111 "/home/jra40/P4/tesla/sys/sys/param.h"
# 1 "/home/jra40/P4/tesla/sys/sys/errno.h" 1
# 112 "/home/jra40/P4/tesla/sys/sys/param.h" 2

# 1 "/home/jra40/P4/tesla/sys/sys/time.h" 1
# 40 "/home/jra40/P4/tesla/sys/sys/time.h"
struct timezone {
 int tz_minuteswest;
 int tz_dsttime;
};
# 53 "/home/jra40/P4/tesla/sys/sys/time.h"
struct bintime {
 time_t sec;
 uint64_t frac;
};

static __inline void
bintime_addx(struct bintime *bt, uint64_t x)
{
 uint64_t u;

 u = bt->frac;
 bt->frac += x;
 if (u > bt->frac)
  bt->sec++;
}

static __inline void
bintime_add(struct bintime *bt, const struct bintime *bt2)
{
 uint64_t u;

 u = bt->frac;
 bt->frac += bt2->frac;
 if (u > bt->frac)
  bt->sec++;
 bt->sec += bt2->sec;
}

static __inline void
bintime_sub(struct bintime *bt, const struct bintime *bt2)
{
 uint64_t u;

 u = bt->frac;
 bt->frac -= bt2->frac;
 if (u < bt->frac)
  bt->sec--;
 bt->sec -= bt2->sec;
}

static __inline void
bintime_mul(struct bintime *bt, u_int x)
{
 uint64_t p1, p2;

 p1 = (bt->frac & 0xffffffffull) * x;
 p2 = (bt->frac >> 32) * x + (p1 >> 32);
 bt->sec *= x;
 bt->sec += (p2 >> 32);
 bt->frac = (p2 << 32) | (p1 & 0xffffffffull);
}

static __inline void
bintime_shift(struct bintime *bt, int exp)
{

 if (exp > 0) {
  bt->sec <<= exp;
  bt->sec |= bt->frac >> (64 - exp);
  bt->frac <<= exp;
 } else if (exp < 0) {
  bt->frac >>= -exp;
  bt->frac |= (uint64_t)bt->sec << (64 + exp);
  bt->sec >>= -exp;
 }
}
# 133 "/home/jra40/P4/tesla/sys/sys/time.h"
static __inline int
sbintime_getsec(sbintime_t sbt)
{

 return (sbt >> 32);
}

static __inline sbintime_t
bttosbt(const struct bintime bt)
{

 return (((sbintime_t)bt.sec << 32) + (bt.frac >> 32));
}

static __inline struct bintime
sbttobt(sbintime_t sbt)
{
 struct bintime bt;

 bt.sec = sbt >> 32;
 bt.frac = sbt << 32;
 return (bt);
}
# 171 "/home/jra40/P4/tesla/sys/sys/time.h"
static __inline void
bintime2timespec(const struct bintime *bt, struct timespec *ts)
{

 ts->tv_sec = bt->sec;
 ts->tv_nsec = ((uint64_t)1000000000 * (uint32_t)(bt->frac >> 32)) >> 32;
}

static __inline void
timespec2bintime(const struct timespec *ts, struct bintime *bt)
{

 bt->sec = ts->tv_sec;

 bt->frac = ts->tv_nsec * (uint64_t)18446744073LL;
}

static __inline void
bintime2timeval(const struct bintime *bt, struct timeval *tv)
{

 tv->tv_sec = bt->sec;
 tv->tv_usec = ((uint64_t)1000000 * (uint32_t)(bt->frac >> 32)) >> 32;
}

static __inline void
timeval2bintime(const struct timeval *tv, struct bintime *bt)
{

 bt->sec = tv->tv_sec;

 bt->frac = tv->tv_usec * (uint64_t)18446744073709LL;
}

static __inline struct timespec
sbttots(sbintime_t sbt)
{
 struct timespec ts;

 ts.tv_sec = sbt >> 32;
 ts.tv_nsec = ((uint64_t)1000000000 * (uint32_t)sbt) >> 32;
 return (ts);
}

static __inline sbintime_t
tstosbt(struct timespec ts)
{

 return (((sbintime_t)ts.tv_sec << 32) +
     (ts.tv_nsec * (((uint64_t)1 << 63) / 500000000) >> 32));
}

static __inline struct timeval
sbttotv(sbintime_t sbt)
{
 struct timeval tv;

 tv.tv_sec = sbt >> 32;
 tv.tv_usec = ((uint64_t)1000000 * (uint32_t)sbt) >> 32;
 return (tv);
}

static __inline sbintime_t
tvtosbt(struct timeval tv)
{

 return (((sbintime_t)tv.tv_sec << 32) +
     (tv.tv_usec * (((uint64_t)1 << 63) / 500000) >> 32));
}
# 319 "/home/jra40/P4/tesla/sys/sys/time.h"
struct itimerval {
 struct timeval it_interval;
 struct timeval it_value;
};




struct clockinfo {
 int hz;
 int tick;
 int spare;
 int stathz;
 int profhz;
};
# 368 "/home/jra40/P4/tesla/sys/sys/time.h"
void inittodr(time_t base);
void resettodr(void);

extern volatile time_t time_second;
extern volatile time_t time_uptime;
extern struct bintime boottimebin;
extern struct timeval boottime;
extern struct bintime tc_tick_bt;
extern sbintime_t tc_tick_sbt;
extern struct bintime tick_bt;
extern sbintime_t tick_sbt;
extern int tc_precexp;
extern int tc_timepercentage;
extern struct bintime bt_timethreshold;
extern struct bintime bt_tickthreshold;
extern sbintime_t sbt_timethreshold;
extern sbintime_t sbt_tickthreshold;
# 407 "/home/jra40/P4/tesla/sys/sys/time.h"
void binuptime(struct bintime *bt);
void nanouptime(struct timespec *tsp);
void microuptime(struct timeval *tvp);

static __inline sbintime_t
sbinuptime(void)
{
 struct bintime bt;

 binuptime(&bt);
 return (bttosbt(bt));
}

void bintime(struct bintime *bt);
void nanotime(struct timespec *tsp);
void microtime(struct timeval *tvp);

void getbinuptime(struct bintime *bt);
void getnanouptime(struct timespec *tsp);
void getmicrouptime(struct timeval *tvp);

static __inline sbintime_t
getsbinuptime(void)
{
 struct bintime bt;

 getbinuptime(&bt);
 return (bttosbt(bt));
}

void getbintime(struct bintime *bt);
void getnanotime(struct timespec *tsp);
void getmicrotime(struct timeval *tvp);


int itimerdecr(struct itimerval *itp, int usec);
int itimerfix(struct timeval *tv);
int ppsratecheck(struct timeval *, int *, int);
int ratecheck(struct timeval *, const struct timeval *);
void timevaladd(struct timeval *t1, const struct timeval *t2);
void timevalsub(struct timeval *t1, const struct timeval *t2);
int tvtohz(struct timeval *tv);
# 114 "/home/jra40/P4/tesla/sys/sys/param.h" 2
# 1 "/home/jra40/P4/tesla/sys/sys/priority.h" 1
# 126 "/home/jra40/P4/tesla/sys/sys/priority.h"
struct priority {
 u_char pri_class;
 u_char pri_level;
 u_char pri_native;
 u_char pri_user;
};
# 115 "/home/jra40/P4/tesla/sys/sys/param.h" 2
# 131 "/home/jra40/P4/tesla/sys/sys/param.h"
# 1 "./machine/param.h" 1
# 46 "./machine/param.h"
# 1 "./machine/_align.h" 1





# 1 "./x86/_align.h" 1
# 7 "./machine/_align.h" 2
# 47 "./machine/param.h" 2
# 132 "/home/jra40/P4/tesla/sys/sys/param.h" 2
# 294 "/home/jra40/P4/tesla/sys/sys/param.h"
__uint32_t htonl(__uint32_t);
__uint16_t htons(__uint16_t);
__uint32_t ntohl(__uint32_t);
__uint16_t ntohs(__uint16_t);
# 33 "/home/jra40/P4/tesla/sys/cam/cam.c" 2

# 1 "/home/jra40/P4/tesla/sys/sys/systm.h" 1
# 41 "/home/jra40/P4/tesla/sys/sys/systm.h"
# 1 "./machine/atomic.h" 1
# 134 "./machine/atomic.h"
static __inline int
atomic_cmpset_int(volatile u_int *dst, u_int expect, u_int src)
{
 u_char res;

 __asm volatile(
 "	" "lock ; " "		"
 "	cmpxchgl %2,%1 ;	"
 "       sete	%0 ;		"
 "1:				"
 "# atomic_cmpset_int"
 : "=a" (res),
   "=m" (*dst)
 : "r" (src),
   "a" (expect),
   "m" (*dst)
 : "memory", "cc");

 return (res);
}

static __inline int
atomic_cmpset_long(volatile u_long *dst, u_long expect, u_long src)
{
 u_char res;

 __asm volatile(
 "	" "lock ; " "		"
 "	cmpxchgq %2,%1 ;	"
 "       sete	%0 ;		"
 "1:				"
 "# atomic_cmpset_long"
 : "=a" (res),
   "=m" (*dst)
 : "r" (src),
   "a" (expect),
   "m" (*dst)
 : "memory", "cc");

 return (res);
}





static __inline u_int
atomic_fetchadd_int(volatile u_int *p, u_int v)
{

 __asm volatile(
 "	" "lock ; " "		"
 "	xaddl	%0, %1 ;	"
 "# atomic_fetchadd_int"
 : "+r" (v),
   "=m" (*p)
 : "m" (*p)
 : "cc");
 return (v);
}





static __inline u_long
atomic_fetchadd_long(volatile u_long *p, u_long v)
{

 __asm volatile(
 "	" "lock ; " "		"
 "	xaddq	%0, %1 ;	"
 "# atomic_fetchadd_long"
 : "+r" (v),
   "=m" (*p)
 : "m" (*p)
 : "cc");
 return (v);
}
# 270 "./machine/atomic.h"
static __inline void atomic_set_char(volatile u_char *p, u_char v){ __asm volatile("lock ; " "orb %b1,%0" : "=m" (*p) : "iq" (v), "m" (*p) : "cc"); } static __inline void atomic_set_barr_char(volatile u_char *p, u_char v){ __asm volatile("lock ; " "orb %b1,%0" : "=m" (*p) : "iq" (v), "m" (*p) : "memory", "cc"); } struct __hack;
static __inline void atomic_clear_char(volatile u_char *p, u_char v){ __asm volatile("lock ; " "andb %b1,%0" : "=m" (*p) : "iq" (~v), "m" (*p) : "cc"); } static __inline void atomic_clear_barr_char(volatile u_char *p, u_char v){ __asm volatile("lock ; " "andb %b1,%0" : "=m" (*p) : "iq" (~v), "m" (*p) : "memory", "cc"); } struct __hack;
static __inline void atomic_add_char(volatile u_char *p, u_char v){ __asm volatile("lock ; " "addb %b1,%0" : "=m" (*p) : "iq" (v), "m" (*p) : "cc"); } static __inline void atomic_add_barr_char(volatile u_char *p, u_char v){ __asm volatile("lock ; " "addb %b1,%0" : "=m" (*p) : "iq" (v), "m" (*p) : "memory", "cc"); } struct __hack;
static __inline void atomic_subtract_char(volatile u_char *p, u_char v){ __asm volatile("lock ; " "subb %b1,%0" : "=m" (*p) : "iq" (v), "m" (*p) : "cc"); } static __inline void atomic_subtract_barr_char(volatile u_char *p, u_char v){ __asm volatile("lock ; " "subb %b1,%0" : "=m" (*p) : "iq" (v), "m" (*p) : "memory", "cc"); } struct __hack;

static __inline void atomic_set_short(volatile u_short *p, u_short v){ __asm volatile("lock ; " "orw %w1,%0" : "=m" (*p) : "ir" (v), "m" (*p) : "cc"); } static __inline void atomic_set_barr_short(volatile u_short *p, u_short v){ __asm volatile("lock ; " "orw %w1,%0" : "=m" (*p) : "ir" (v), "m" (*p) : "memory", "cc"); } struct __hack;
static __inline void atomic_clear_short(volatile u_short *p, u_short v){ __asm volatile("lock ; " "andw %w1,%0" : "=m" (*p) : "ir" (~v), "m" (*p) : "cc"); } static __inline void atomic_clear_barr_short(volatile u_short *p, u_short v){ __asm volatile("lock ; " "andw %w1,%0" : "=m" (*p) : "ir" (~v), "m" (*p) : "memory", "cc"); } struct __hack;
static __inline void atomic_add_short(volatile u_short *p, u_short v){ __asm volatile("lock ; " "addw %w1,%0" : "=m" (*p) : "ir" (v), "m" (*p) : "cc"); } static __inline void atomic_add_barr_short(volatile u_short *p, u_short v){ __asm volatile("lock ; " "addw %w1,%0" : "=m" (*p) : "ir" (v), "m" (*p) : "memory", "cc"); } struct __hack;
static __inline void atomic_subtract_short(volatile u_short *p, u_short v){ __asm volatile("lock ; " "subw %w1,%0" : "=m" (*p) : "ir" (v), "m" (*p) : "cc"); } static __inline void atomic_subtract_barr_short(volatile u_short *p, u_short v){ __asm volatile("lock ; " "subw %w1,%0" : "=m" (*p) : "ir" (v), "m" (*p) : "memory", "cc"); } struct __hack;

static __inline void atomic_set_int(volatile u_int *p, u_int v){ __asm volatile("lock ; " "orl %1,%0" : "=m" (*p) : "ir" (v), "m" (*p) : "cc"); } static __inline void atomic_set_barr_int(volatile u_int *p, u_int v){ __asm volatile("lock ; " "orl %1,%0" : "=m" (*p) : "ir" (v), "m" (*p) : "memory", "cc"); } struct __hack;
static __inline void atomic_clear_int(volatile u_int *p, u_int v){ __asm volatile("lock ; " "andl %1,%0" : "=m" (*p) : "ir" (~v), "m" (*p) : "cc"); } static __inline void atomic_clear_barr_int(volatile u_int *p, u_int v){ __asm volatile("lock ; " "andl %1,%0" : "=m" (*p) : "ir" (~v), "m" (*p) : "memory", "cc"); } struct __hack;
static __inline void atomic_add_int(volatile u_int *p, u_int v){ __asm volatile("lock ; " "addl %1,%0" : "=m" (*p) : "ir" (v), "m" (*p) : "cc"); } static __inline void atomic_add_barr_int(volatile u_int *p, u_int v){ __asm volatile("lock ; " "addl %1,%0" : "=m" (*p) : "ir" (v), "m" (*p) : "memory", "cc"); } struct __hack;
static __inline void atomic_subtract_int(volatile u_int *p, u_int v){ __asm volatile("lock ; " "subl %1,%0" : "=m" (*p) : "ir" (v), "m" (*p) : "cc"); } static __inline void atomic_subtract_barr_int(volatile u_int *p, u_int v){ __asm volatile("lock ; " "subl %1,%0" : "=m" (*p) : "ir" (v), "m" (*p) : "memory", "cc"); } struct __hack;

static __inline void atomic_set_long(volatile u_long *p, u_long v){ __asm volatile("lock ; " "orq %1,%0" : "=m" (*p) : "ir" (v), "m" (*p) : "cc"); } static __inline void atomic_set_barr_long(volatile u_long *p, u_long v){ __asm volatile("lock ; " "orq %1,%0" : "=m" (*p) : "ir" (v), "m" (*p) : "memory", "cc"); } struct __hack;
static __inline void atomic_clear_long(volatile u_long *p, u_long v){ __asm volatile("lock ; " "andq %1,%0" : "=m" (*p) : "ir" (~v), "m" (*p) : "cc"); } static __inline void atomic_clear_barr_long(volatile u_long *p, u_long v){ __asm volatile("lock ; " "andq %1,%0" : "=m" (*p) : "ir" (~v), "m" (*p) : "memory", "cc"); } struct __hack;
static __inline void atomic_add_long(volatile u_long *p, u_long v){ __asm volatile("lock ; " "addq %1,%0" : "=m" (*p) : "ir" (v), "m" (*p) : "cc"); } static __inline void atomic_add_barr_long(volatile u_long *p, u_long v){ __asm volatile("lock ; " "addq %1,%0" : "=m" (*p) : "ir" (v), "m" (*p) : "memory", "cc"); } struct __hack;
static __inline void atomic_subtract_long(volatile u_long *p, u_long v){ __asm volatile("lock ; " "subq %1,%0" : "=m" (*p) : "ir" (v), "m" (*p) : "cc"); } static __inline void atomic_subtract_barr_long(volatile u_long *p, u_long v){ __asm volatile("lock ; " "subq %1,%0" : "=m" (*p) : "ir" (v), "m" (*p) : "memory", "cc"); } struct __hack;

static __inline u_char atomic_load_acq_char(volatile u_char *p) { u_char res; __asm volatile("lock ; " "cmpxchgb %b0,%1" : "=a" (res), "=m" (*p) : "m" (*p) : "memory", "cc"); return (res); } struct __hack;
static __inline u_short atomic_load_acq_short(volatile u_short *p) { u_short res; __asm volatile("lock ; " "cmpxchgw %w0,%1" : "=a" (res), "=m" (*p) : "m" (*p) : "memory", "cc"); return (res); } struct __hack;
static __inline u_int atomic_load_acq_int(volatile u_int *p) { u_int res; __asm volatile("lock ; " "cmpxchgl %0,%1" : "=a" (res), "=m" (*p) : "m" (*p) : "memory", "cc"); return (res); } struct __hack;
static __inline u_long atomic_load_acq_long(volatile u_long *p) { u_long res; __asm volatile("lock ; " "cmpxchgq %0,%1" : "=a" (res), "=m" (*p) : "m" (*p) : "memory", "cc"); return (res); } struct __hack;

static __inline void atomic_store_rel_char(volatile u_char *p, u_char v){ __asm volatile(" " : : : "memory"); *p = v; } struct __hack;
static __inline void atomic_store_rel_short(volatile u_short *p, u_short v){ __asm volatile(" " : : : "memory"); *p = v; } struct __hack;
static __inline void atomic_store_rel_int(volatile u_int *p, u_int v){ __asm volatile(" " : : : "memory"); *p = v; } struct __hack;
static __inline void atomic_store_rel_long(volatile u_long *p, u_long v){ __asm volatile(" " : : : "memory"); *p = v; } struct __hack;
# 309 "./machine/atomic.h"
static __inline u_int
atomic_readandclear_int(volatile u_int *addr)
{
 u_int res;

 res = 0;
 __asm volatile(
 "	xchgl	%1,%0 ;		"
 "# atomic_readandclear_int"
 : "+r" (res),
   "=m" (*addr)
 : "m" (*addr));

 return (res);
}

static __inline u_long
atomic_readandclear_long(volatile u_long *addr)
{
 u_long res;

 res = 0;
 __asm volatile(
 "	xchgq	%1,%0 ;		"
 "# atomic_readandclear_long"
 : "+r" (res),
   "=m" (*addr)
 : "m" (*addr));

 return (res);
}
# 42 "/home/jra40/P4/tesla/sys/sys/systm.h" 2
# 1 "./machine/cpufunc.h" 1
# 46 "./machine/cpufunc.h"
struct region_descriptor;
# 60 "./machine/cpufunc.h"
static __inline void
breakpoint(void)
{
 __asm volatile("int $3");
}

static __inline u_int
bsfl(u_int mask)
{
 u_int result;

 __asm volatile("bsfl %1,%0" : "=r" (result) : "rm" (mask));
 return (result);
}

static __inline u_long
bsfq(u_long mask)
{
 u_long result;

 __asm volatile("bsfq %1,%0" : "=r" (result) : "rm" (mask));
 return (result);
}

static __inline u_int
bsrl(u_int mask)
{
 u_int result;

 __asm volatile("bsrl %1,%0" : "=r" (result) : "rm" (mask));
 return (result);
}

static __inline u_long
bsrq(u_long mask)
{
 u_long result;

 __asm volatile("bsrq %1,%0" : "=r" (result) : "rm" (mask));
 return (result);
}

static __inline void
clflush(u_long addr)
{

 __asm volatile("clflush %0" : : "m" (*(char *)addr));
}

static __inline void
clts(void)
{

 __asm volatile("clts");
}

static __inline void
disable_intr(void)
{
 __asm volatile("cli" : : : "memory");
}

static __inline void
do_cpuid(u_int ax, u_int *p)
{
 __asm volatile("cpuid"
    : "=a" (p[0]), "=b" (p[1]), "=c" (p[2]), "=d" (p[3])
    : "0" (ax));
}

static __inline void
cpuid_count(u_int ax, u_int cx, u_int *p)
{
 __asm volatile("cpuid"
    : "=a" (p[0]), "=b" (p[1]), "=c" (p[2]), "=d" (p[3])
    : "0" (ax), "c" (cx));
}

static __inline void
enable_intr(void)
{
 __asm volatile("sti");
}
# 151 "./machine/cpufunc.h"
static __inline int
ffsl(long mask)
{
 return (mask == 0 ? mask : (int)bsfq((u_long)mask) + 1);
}



static __inline int
fls(int mask)
{
 return (mask == 0 ? mask : (int)bsrl((u_int)mask) + 1);
}



static __inline int
flsl(long mask)
{
 return (mask == 0 ? mask : (int)bsrq((u_long)mask) + 1);
}



static __inline void
halt(void)
{
 __asm volatile("hlt");
}

static __inline u_char
inb(u_int port)
{
 u_char data;

 __asm volatile("inb %w1, %0" : "=a" (data) : "Nd" (port));
 return (data);
}

static __inline u_int
inl(u_int port)
{
 u_int data;

 __asm volatile("inl %w1, %0" : "=a" (data) : "Nd" (port));
 return (data);
}

static __inline void
insb(u_int port, void *addr, size_t count)
{
 __asm volatile("cld; rep; insb"
    : "+D" (addr), "+c" (count)
    : "d" (port)
    : "memory");
}

static __inline void
insw(u_int port, void *addr, size_t count)
{
 __asm volatile("cld; rep; insw"
    : "+D" (addr), "+c" (count)
    : "d" (port)
    : "memory");
}

static __inline void
insl(u_int port, void *addr, size_t count)
{
 __asm volatile("cld; rep; insl"
    : "+D" (addr), "+c" (count)
    : "d" (port)
    : "memory");
}

static __inline void
invd(void)
{
 __asm volatile("invd");
}

static __inline u_short
inw(u_int port)
{
 u_short data;

 __asm volatile("inw %w1, %0" : "=a" (data) : "Nd" (port));
 return (data);
}

static __inline void
outb(u_int port, u_char data)
{
 __asm volatile("outb %0, %w1" : : "a" (data), "Nd" (port));
}

static __inline void
outl(u_int port, u_int data)
{
 __asm volatile("outl %0, %w1" : : "a" (data), "Nd" (port));
}

static __inline void
outsb(u_int port, const void *addr, size_t count)
{
 __asm volatile("cld; rep; outsb"
    : "+S" (addr), "+c" (count)
    : "d" (port));
}

static __inline void
outsw(u_int port, const void *addr, size_t count)
{
 __asm volatile("cld; rep; outsw"
    : "+S" (addr), "+c" (count)
    : "d" (port));
}

static __inline void
outsl(u_int port, const void *addr, size_t count)
{
 __asm volatile("cld; rep; outsl"
    : "+S" (addr), "+c" (count)
    : "d" (port));
}

static __inline void
outw(u_int port, u_short data)
{
 __asm volatile("outw %0, %w1" : : "a" (data), "Nd" (port));
}

static __inline u_long
popcntq(u_long mask)
{
 u_long result;

 __asm volatile("popcntq %1,%0" : "=r" (result) : "rm" (mask));
 return (result);
}

static __inline void
lfence(void)
{

 __asm volatile("lfence" : : : "memory");
}

static __inline void
mfence(void)
{

 __asm volatile("mfence" : : : "memory");
}

static __inline void
ia32_pause(void)
{
 __asm volatile("pause");
}

static __inline u_long
read_rflags(void)
{
 u_long rf;

 __asm volatile("pushfq; popq %0" : "=r" (rf));
 return (rf);
}

static __inline uint64_t
rdmsr(u_int msr)
{
 uint32_t low, high;

 __asm volatile("rdmsr" : "=a" (low), "=d" (high) : "c" (msr));
 return (low | ((uint64_t)high << 32));
}

static __inline uint64_t
rdpmc(u_int pmc)
{
 uint32_t low, high;

 __asm volatile("rdpmc" : "=a" (low), "=d" (high) : "c" (pmc));
 return (low | ((uint64_t)high << 32));
}

static __inline uint64_t
rdtsc(void)
{
 uint32_t low, high;

 __asm volatile("rdtsc" : "=a" (low), "=d" (high));
 return (low | ((uint64_t)high << 32));
}

static __inline uint32_t
rdtsc32(void)
{
 uint32_t rv;

 __asm volatile("rdtsc" : "=a" (rv) : : "edx");
 return (rv);
}

static __inline void
wbinvd(void)
{
 __asm volatile("wbinvd");
}

static __inline void
write_rflags(u_long rf)
{
 __asm volatile("pushq %0;  popfq" : : "r" (rf));
}

static __inline void
wrmsr(u_int msr, uint64_t newval)
{
 uint32_t low, high;

 low = newval;
 high = newval >> 32;
 __asm volatile("wrmsr" : : "a" (low), "d" (high), "c" (msr));
}

static __inline void
load_cr0(u_long data)
{

 __asm volatile("movq %0,%%cr0" : : "r" (data));
}

static __inline u_long
rcr0(void)
{
 u_long data;

 __asm volatile("movq %%cr0,%0" : "=r" (data));
 return (data);
}

static __inline u_long
rcr2(void)
{
 u_long data;

 __asm volatile("movq %%cr2,%0" : "=r" (data));
 return (data);
}

static __inline void
load_cr3(u_long data)
{

 __asm volatile("movq %0,%%cr3" : : "r" (data) : "memory");
}

static __inline u_long
rcr3(void)
{
 u_long data;

 __asm volatile("movq %%cr3,%0" : "=r" (data));
 return (data);
}

static __inline void
load_cr4(u_long data)
{
 __asm volatile("movq %0,%%cr4" : : "r" (data));
}

static __inline u_long
rcr4(void)
{
 u_long data;

 __asm volatile("movq %%cr4,%0" : "=r" (data));
 return (data);
}

static __inline u_long
rxcr(u_int reg)
{
 u_int low, high;

 __asm volatile("xgetbv" : "=a" (low), "=d" (high) : "c" (reg));
 return (low | ((uint64_t)high << 32));
}

static __inline void
load_xcr(u_int reg, u_long val)
{
 u_int low, high;

 low = val;
 high = val >> 32;
 __asm volatile("xsetbv" : : "c" (reg), "a" (low), "d" (high));
}




static __inline void
invltlb(void)
{

 load_cr3(rcr3());
}





static __inline void
invlpg(u_long addr)
{

 __asm volatile("invlpg %0" : : "m" (*(char *)addr) : "memory");
}

static __inline u_short
rfs(void)
{
 u_short sel;
 __asm volatile("movw %%fs,%0" : "=rm" (sel));
 return (sel);
}

static __inline u_short
rgs(void)
{
 u_short sel;
 __asm volatile("movw %%gs,%0" : "=rm" (sel));
 return (sel);
}

static __inline u_short
rss(void)
{
 u_short sel;
 __asm volatile("movw %%ss,%0" : "=rm" (sel));
 return (sel);
}

static __inline void
load_ds(u_short sel)
{
 __asm volatile("movw %0,%%ds" : : "rm" (sel));
}

static __inline void
load_es(u_short sel)
{
 __asm volatile("movw %0,%%es" : : "rm" (sel));
}

static __inline void
cpu_monitor(const void *addr, u_long extensions, u_int hints)
{

 __asm volatile("monitor"
     : : "a" (addr), "c" (extensions), "d" (hints));
}

static __inline void
cpu_mwait(u_long extensions, u_int hints)
{

 __asm volatile("mwait" : : "a" (hints), "c" (extensions));
}






static __inline void
load_fs(u_short sel)
{

 __asm volatile("rdmsr; movw %0,%%fs; wrmsr"
     : : "rm" (sel), "c" (0xc0000100) : "eax", "edx");
}




static __inline void
load_gs(u_short sel)
{





 __asm volatile("pushfq; cli; rdmsr; movw %0,%%gs; wrmsr; popfq"
     : : "rm" (sel), "c" (0xc0000101) : "eax", "edx");
}
# 568 "./machine/cpufunc.h"
static __inline void
lidt(struct region_descriptor *addr)
{
 __asm volatile("lidt (%0)" : : "r" (addr));
}

static __inline void
lldt(u_short sel)
{
 __asm volatile("lldt %0" : : "r" (sel));
}

static __inline void
ltr(u_short sel)
{
 __asm volatile("ltr %0" : : "r" (sel));
}

static __inline uint64_t
rdr0(void)
{
 uint64_t data;
 __asm volatile("movq %%dr0,%0" : "=r" (data));
 return (data);
}

static __inline void
load_dr0(uint64_t dr0)
{
 __asm volatile("movq %0,%%dr0" : : "r" (dr0));
}

static __inline uint64_t
rdr1(void)
{
 uint64_t data;
 __asm volatile("movq %%dr1,%0" : "=r" (data));
 return (data);
}

static __inline void
load_dr1(uint64_t dr1)
{
 __asm volatile("movq %0,%%dr1" : : "r" (dr1));
}

static __inline uint64_t
rdr2(void)
{
 uint64_t data;
 __asm volatile("movq %%dr2,%0" : "=r" (data));
 return (data);
}

static __inline void
load_dr2(uint64_t dr2)
{
 __asm volatile("movq %0,%%dr2" : : "r" (dr2));
}

static __inline uint64_t
rdr3(void)
{
 uint64_t data;
 __asm volatile("movq %%dr3,%0" : "=r" (data));
 return (data);
}

static __inline void
load_dr3(uint64_t dr3)
{
 __asm volatile("movq %0,%%dr3" : : "r" (dr3));
}

static __inline uint64_t
rdr4(void)
{
 uint64_t data;
 __asm volatile("movq %%dr4,%0" : "=r" (data));
 return (data);
}

static __inline void
load_dr4(uint64_t dr4)
{
 __asm volatile("movq %0,%%dr4" : : "r" (dr4));
}

static __inline uint64_t
rdr5(void)
{
 uint64_t data;
 __asm volatile("movq %%dr5,%0" : "=r" (data));
 return (data);
}

static __inline void
load_dr5(uint64_t dr5)
{
 __asm volatile("movq %0,%%dr5" : : "r" (dr5));
}

static __inline uint64_t
rdr6(void)
{
 uint64_t data;
 __asm volatile("movq %%dr6,%0" : "=r" (data));
 return (data);
}

static __inline void
load_dr6(uint64_t dr6)
{
 __asm volatile("movq %0,%%dr6" : : "r" (dr6));
}

static __inline uint64_t
rdr7(void)
{
 uint64_t data;
 __asm volatile("movq %%dr7,%0" : "=r" (data));
 return (data);
}

static __inline void
load_dr7(uint64_t dr7)
{
 __asm volatile("movq %0,%%dr7" : : "r" (dr7));
}

static __inline register_t
intr_disable(void)
{
 register_t rflags;

 rflags = read_rflags();
 disable_intr();
 return (rflags);
}

static __inline void
intr_restore(register_t rflags)
{
 write_rflags(rflags);
}
# 784 "./machine/cpufunc.h"
void reset_dbregs(void);


int rdmsr_safe(u_int msr, uint64_t *val);
int wrmsr_safe(u_int msr, uint64_t newval);
# 43 "/home/jra40/P4/tesla/sys/sys/systm.h" 2
# 1 "/home/jra40/P4/tesla/sys/sys/callout.h" 1
# 41 "/home/jra40/P4/tesla/sys/sys/callout.h"
# 1 "/home/jra40/P4/tesla/sys/sys/_callout.h" 1
# 41 "/home/jra40/P4/tesla/sys/sys/_callout.h"
# 1 "/home/jra40/P4/tesla/sys/sys/queue.h" 1
# 42 "/home/jra40/P4/tesla/sys/sys/_callout.h" 2

struct lock_object;

struct callout_list { struct callout *lh_first; };
struct callout_slist { struct callout *slh_first; };
struct callout_tailq { struct callout *tqh_first; struct callout **tqh_last; };

struct callout {
 union {
  struct { struct callout *le_next; struct callout **le_prev; } le;
  struct { struct callout *sle_next; } sle;
  struct { struct callout *tqe_next; struct callout **tqe_prev; } tqe;
 } c_links;
 sbintime_t c_time;
 sbintime_t c_precision;
 void *c_arg;
 void (*c_func)(void *);
 struct lock_object *c_lock;
 int c_flags;
 volatile int c_cpu;
};
# 42 "/home/jra40/P4/tesla/sys/sys/callout.h" 2
# 61 "/home/jra40/P4/tesla/sys/sys/callout.h"
struct callout_handle {
 struct callout *callout;
};





void callout_init(struct callout *, int);
void _callout_init_lock(struct callout *, struct lock_object *, int);







int callout_reset_sbt_on(struct callout *, sbintime_t, sbintime_t,
     void (*)(void *), void *, int, int);
# 91 "/home/jra40/P4/tesla/sys/sys/callout.h"
int callout_schedule(struct callout *, int);
int callout_schedule_on(struct callout *, int, int);



int _callout_stop_safe(struct callout *, int);
void callout_process(sbintime_t now);
# 44 "/home/jra40/P4/tesla/sys/sys/systm.h" 2


# 1 "/home/jra40/P4/tesla/sys/sys/stdint.h" 1
# 35 "/home/jra40/P4/tesla/sys/sys/stdint.h"
# 1 "./machine/_stdint.h" 1





# 1 "./x86/_stdint.h" 1
# 7 "./machine/_stdint.h" 2
# 36 "/home/jra40/P4/tesla/sys/sys/stdint.h" 2


typedef __int_least8_t int_least8_t;
typedef __int_least16_t int_least16_t;
typedef __int_least32_t int_least32_t;
typedef __int_least64_t int_least64_t;

typedef __uint_least8_t uint_least8_t;
typedef __uint_least16_t uint_least16_t;
typedef __uint_least32_t uint_least32_t;
typedef __uint_least64_t uint_least64_t;

typedef __int_fast8_t int_fast8_t;
typedef __int_fast16_t int_fast16_t;
typedef __int_fast32_t int_fast32_t;
typedef __int_fast64_t int_fast64_t;

typedef __uint_fast8_t uint_fast8_t;
typedef __uint_fast16_t uint_fast16_t;
typedef __uint_fast32_t uint_fast32_t;
typedef __uint_fast64_t uint_fast64_t;


typedef __intmax_t intmax_t;



typedef __uintmax_t uintmax_t;
# 47 "/home/jra40/P4/tesla/sys/sys/systm.h" 2

extern int cold;
extern int rebooting;
extern const char *panicstr;
extern char version[];
extern char compiler_version[];
extern char copyright[];
extern int kstack_pages;

extern u_long pagesizes[];
extern long physmem;
extern long realmem;

extern char *rootdevnames[2];

extern int boothowto;
extern int bootverbose;

extern int maxusers;
extern int ngroups_max;
extern int vm_guest;






enum VM_GUEST { VM_GUEST_NO = 0, VM_GUEST_VM, VM_GUEST_XEN };


void kassert_panic(const char *fmt, ...);
# 134 "/home/jra40/P4/tesla/sys/sys/systm.h"
extern int osreldate;
extern int envmode;
extern int hintmode;
extern int dynamic_kenv;
extern struct mtx kenv_lock;
extern char *kern_envp;
extern char static_env[];
extern char static_hints[];

extern char **kenvp;

extern const void *zero_region;

extern int unmapped_buf_allowed;
extern int iosize_max_clamp;






struct inpcb;
struct lock_object;
struct malloc_type;
struct mtx;
struct proc;
struct socket;
struct thread;
struct tty;
struct ucred;
struct uio;
struct _jmp_buf;
struct trapframe;

int setjmp(struct _jmp_buf *) __attribute__((__returns_twice__));
void longjmp(struct _jmp_buf *, int) __attribute__((__noreturn__));
int dumpstatus(vm_offset_t addr, off_t count);
int nullop(void);
int eopnotsupp(void);
int ureadc(int, struct uio *);
void hashdestroy(void *, struct malloc_type *, u_long);
void *hashinit(int count, struct malloc_type *type, u_long *hashmask);
void *hashinit_flags(int count, struct malloc_type *type,
    u_long *hashmask, int flags);



void *phashinit(int count, struct malloc_type *type, u_long *nentries);
void g_waitidle(void);

void panic(const char *, ...) __attribute__((__noreturn__)) __attribute__((__format__ (__printf__, 1, 2)));

void cpu_boot(int);
void cpu_flush_dcache(void *, size_t);
void cpu_rootconf(void);
void critical_enter(void);
void critical_exit(void);
void init_param1(void);
void init_param2(long physpages);
void init_static_kenv(char *, size_t);
void tablefull(const char *);
int kvprintf(char const *, void (*)(int, void*), void *, int,
     __va_list) __attribute__((__format__ (__printf__, 1, 0)));
void log(int, const char *, ...) __attribute__((__format__ (__printf__, 2, 3)));
void log_console(struct uio *);
int printf(const char *, ...) __attribute__((__format__ (__printf__, 1, 2)));
int snprintf(char *, size_t, const char *, ...) __attribute__((__format__ (__printf__, 3, 4)));
int sprintf(char *buf, const char *, ...) __attribute__((__format__ (__printf__, 2, 3)));
int uprintf(const char *, ...) __attribute__((__format__ (__printf__, 1, 2)));
int vprintf(const char *, __va_list) __attribute__((__format__ (__printf__, 1, 0)));
int vsnprintf(char *, size_t, const char *, __va_list) __attribute__((__format__ (__printf__, 3, 0)));
int vsnrprintf(char *, size_t, int, const char *, __va_list) __attribute__((__format__ (__printf__, 4, 0)));
int vsprintf(char *buf, const char *, __va_list) __attribute__((__format__ (__printf__, 2, 0)));
int ttyprintf(struct tty *, const char *, ...) __attribute__((__format__ (__printf__, 2, 3)));
int sscanf(const char *, char const *, ...) __attribute__((__nonnull__(1))) __attribute__((__nonnull__(2)));
int vsscanf(const char *, char const *, __va_list) __attribute__((__nonnull__(1))) __attribute__((__nonnull__(2)));
long strtol(const char *, char **, int) __attribute__((__nonnull__(1)));
u_long strtoul(const char *, char **, int) __attribute__((__nonnull__(1)));
quad_t strtoq(const char *, char **, int) __attribute__((__nonnull__(1)));
u_quad_t strtouq(const char *, char **, int) __attribute__((__nonnull__(1)));
void tprintf(struct proc *p, int pri, const char *, ...) __attribute__((__format__ (__printf__, 3, 4)));
void hexdump(const void *ptr, int length, const char *hdr, int flags);







void bcopy(const void *from, void *to, size_t len) __attribute__((__nonnull__(1))) __attribute__((__nonnull__(2)));
void bzero(void *buf, size_t len) __attribute__((__nonnull__(1)));

void *memcpy(void *to, const void *from, size_t len) __attribute__((__nonnull__(1))) __attribute__((__nonnull__(2)));
void *memmove(void *dest, const void *src, size_t n) __attribute__((__nonnull__(1))) __attribute__((__nonnull__(2)));

int copystr(const void * restrict kfaddr, void * restrict kdaddr,
     size_t len, size_t * restrict lencopied)
     __attribute__((__nonnull__(1))) __attribute__((__nonnull__(2)));
int copyinstr(const void * restrict udaddr, void * restrict kaddr,
     size_t len, size_t * restrict lencopied)
     __attribute__((__nonnull__(1))) __attribute__((__nonnull__(2)));
int copyin(const void * restrict udaddr, void * restrict kaddr,
     size_t len) __attribute__((__nonnull__(1))) __attribute__((__nonnull__(2)));
int copyin_nofault(const void * restrict udaddr, void * restrict kaddr,
     size_t len) __attribute__((__nonnull__(1))) __attribute__((__nonnull__(2)));
int copyout(const void * restrict kaddr, void * restrict udaddr,
     size_t len) __attribute__((__nonnull__(1))) __attribute__((__nonnull__(2)));
int copyout_nofault(const void * restrict kaddr, void * restrict udaddr,
     size_t len) __attribute__((__nonnull__(1))) __attribute__((__nonnull__(2)));

int fubyte(const void *base);
long fuword(const void *base);
int fuword16(void *base);
int32_t fuword32(const void *base);
int64_t fuword64(const void *base);
int subyte(void *base, int byte);
int suword(void *base, long word);
int suword16(void *base, int word);
int suword32(void *base, int32_t word);
int suword64(void *base, int64_t word);
uint32_t casuword32(volatile uint32_t *base, uint32_t oldval, uint32_t newval);
u_long casuword(volatile u_long *p, u_long oldval, u_long newval);

void realitexpire(void *);

int sysbeep(int hertz, int period);

void hardclock(int usermode, uintfptr_t pc);
void hardclock_cnt(int cnt, int usermode);
void hardclock_cpu(int usermode);
void hardclock_sync(int cpu);
void softclock(void *);
void statclock(int usermode);
void statclock_cnt(int cnt, int usermode);
void profclock(int usermode, uintfptr_t pc);
void profclock_cnt(int cnt, int usermode, uintfptr_t pc);

int hardclockintr(void);

void startprofclock(struct proc *);
void stopprofclock(struct proc *);
void cpu_startprofclock(void);
void cpu_stopprofclock(void);
sbintime_t cpu_idleclock(void);
void cpu_activeclock(void);
void cpu_new_callout(int cpu, sbintime_t bt, sbintime_t bt_opt);
extern int cpu_can_deep_sleep;
extern int cpu_disable_deep_sleep;

int cr_cansee(struct ucred *u1, struct ucred *u2);
int cr_canseesocket(struct ucred *cred, struct socket *so);
int cr_canseeinpcb(struct ucred *cred, struct inpcb *inp);

char *getenv(const char *name);
void freeenv(char *env);
int getenv_int(const char *name, int *data);
int getenv_uint(const char *name, unsigned int *data);
int getenv_long(const char *name, long *data);
int getenv_ulong(const char *name, unsigned long *data);
int getenv_string(const char *name, char *data, int size);
int getenv_quad(const char *name, quad_t *data);
int setenv(const char *name, const char *value);
int unsetenv(const char *name);
int testenv(const char *name);

typedef uint64_t (cpu_tick_f)(void);
void set_cputicker(cpu_tick_f *func, uint64_t freq, unsigned var);
extern cpu_tick_f *cpu_ticks;
uint64_t cpu_tickrate(void);
uint64_t cputick2usec(uint64_t tick);







# 1 "/home/jra40/P4/tesla/sys/sys/libkern.h" 1
# 39 "/home/jra40/P4/tesla/sys/sys/libkern.h"
# 1 "/home/jra40/P4/tesla/sys/sys/systm.h" 1
# 40 "/home/jra40/P4/tesla/sys/sys/libkern.h" 2








extern u_char const bcd2bin_data[];
extern u_char const bin2bcd_data[];
extern char const hex2ascii_data[];





static __inline int imax(int a, int b) { return (a > b ? a : b); }
static __inline int imin(int a, int b) { return (a < b ? a : b); }
static __inline long lmax(long a, long b) { return (a > b ? a : b); }
static __inline long lmin(long a, long b) { return (a < b ? a : b); }
static __inline u_int max(u_int a, u_int b) { return (a > b ? a : b); }
static __inline u_int min(u_int a, u_int b) { return (a < b ? a : b); }
static __inline quad_t qmax(quad_t a, quad_t b) { return (a > b ? a : b); }
static __inline quad_t qmin(quad_t a, quad_t b) { return (a < b ? a : b); }
static __inline u_long ulmax(u_long a, u_long b) { return (a > b ? a : b); }
static __inline u_long ulmin(u_long a, u_long b) { return (a < b ? a : b); }
static __inline off_t omax(off_t a, off_t b) { return (a > b ? a : b); }
static __inline off_t omin(off_t a, off_t b) { return (a < b ? a : b); }

static __inline int abs(int a) { return (a < 0 ? -a : a); }
static __inline long labs(long a) { return (a < 0 ? -a : a); }
static __inline quad_t qabs(quad_t a) { return (a < 0 ? -a : a); }




extern int arc4rand_iniseed_state;


struct malloc_type;
uint32_t arc4random(void);
void arc4rand(void *ptr, u_int len, int reseed);
int bcmp(const void *, const void *, size_t);
void *bsearch(const void *, const void *, size_t,
     size_t, int (*)(const void *, const void *));
# 97 "/home/jra40/P4/tesla/sys/sys/libkern.h"
int fnmatch(const char *, const char *, int);
int locc(int, char *, u_int);
void *memchr(const void *s, int c, size_t n);
void *memcchr(const void *s, int c, size_t n);
int memcmp(const void *b1, const void *b2, size_t len);
void qsort(void *base, size_t nmemb, size_t size,
     int (*compar)(const void *, const void *));
void qsort_r(void *base, size_t nmemb, size_t size, void *thunk,
     int (*compar)(void *, const void *, const void *));
u_long random(void);
int scanc(u_int, const u_char *, const u_char *, int);
void srandom(u_long);
int strcasecmp(const char *, const char *);
char *strcat(char * restrict, const char * restrict);
char *strchr(const char *, int);
int strcmp(const char *, const char *);
char *strcpy(char * restrict, const char * restrict);
size_t strcspn(const char * restrict, const char * restrict) __attribute__((__pure__));
char *strdup(const char *restrict, struct malloc_type *);
size_t strlcat(char *, const char *, size_t);
size_t strlcpy(char *, const char *, size_t);
size_t strlen(const char *);
int strncasecmp(const char *, const char *, size_t);
int strncmp(const char *, const char *, size_t);
char *strncpy(char * restrict, const char * restrict, size_t);
size_t strnlen(const char *, size_t);
char *strrchr(const char *, int);
char *strsep(char **, const char *delim);
size_t strspn(const char *, const char *);
char *strstr(const char *, const char *);
int strvalid(const char *, size_t);

extern const uint32_t crc32_tab[];

static __inline uint32_t
crc32_raw(const void *buf, size_t size, uint32_t crc)
{
 const uint8_t *p = (const uint8_t *)buf;

 while (size--)
  crc = crc32_tab[(crc ^ *p++) & 0xFF] ^ (crc >> 8);
 return (crc);
}

static __inline uint32_t
crc32(const void *buf, size_t size)
{
 uint32_t crc;

 crc = crc32_raw(buf, size, ~0U);
 return (crc ^ ~0U);
}

uint32_t
calculate_crc32c(uint32_t crc32c, const unsigned char *buffer,
    unsigned int length);


static __inline void *memset(void *, int, size_t);

static __inline void *
memset(void *b, int c, size_t len)
{
 char *bb;

 if (c == 0)
  bzero(b, len);
 else
  for (bb = (char *)b; len--; )
   *bb++ = c;
 return (b);
}


static __inline char *
index(const char *p, int ch)
{

 return (strchr(p, ch));
}

static __inline char *
rindex(const char *p, int ch)
{

 return (strrchr(p, ch));
}
# 311 "/home/jra40/P4/tesla/sys/sys/systm.h" 2


void consinit(void);
void cpu_initclocks(void);
void cpu_initclocks_bsp(void);
void cpu_initclocks_ap(void);
void usrinfoinit(void);


void kern_reboot(int) __attribute__((__noreturn__));
void shutdown_nice(int);


typedef void timeout_t(void *);



void callout_handle_init(struct callout_handle *);
struct callout_handle timeout(timeout_t *, void *, int);
void untimeout(timeout_t *, void *, struct callout_handle);


static __inline intrmask_t splbio(void) { return 0; }
static __inline intrmask_t splcam(void) { return 0; }
static __inline intrmask_t splclock(void) { return 0; }
static __inline intrmask_t splhigh(void) { return 0; }
static __inline intrmask_t splimp(void) { return 0; }
static __inline intrmask_t splnet(void) { return 0; }
static __inline intrmask_t spltty(void) { return 0; }
static __inline intrmask_t splvm(void) { return 0; }
static __inline void splx(intrmask_t ipl __attribute__((__unused__))) { return; }





int _sleep(void *chan, struct lock_object *lock, int pri, const char *wmesg,
    sbintime_t sbt, sbintime_t pr, int flags) __attribute__((__nonnull__(1)));






int msleep_spin_sbt(void *chan, struct mtx *mtx, const char *wmesg,
     sbintime_t sbt, sbintime_t pr, int flags) __attribute__((__nonnull__(1)));



int pause_sbt(const char *wmesg, sbintime_t sbt, sbintime_t pr,
     int flags);







void wakeup(void *chan) __attribute__((__nonnull__(1)));
void wakeup_one(void *chan) __attribute__((__nonnull__(1)));





struct cdev;
dev_t dev2udev(struct cdev *x);
const char *devtoname(struct cdev *cdev);

int poll_no_poll(int events);


void DELAY(int usec);


struct root_hold_token;

struct root_hold_token *root_mount_hold(const char *identifier);
void root_mount_rel(struct root_hold_token *h);
void root_mount_wait(void);
int root_mounted(void);





struct unrhdr;
struct unrhdr *new_unrhdr(int low, int high, struct mtx *mutex);
void delete_unrhdr(struct unrhdr *uh);
void clean_unrhdr(struct unrhdr *uh);
void clean_unrhdrl(struct unrhdr *uh);
int alloc_unr(struct unrhdr *uh);
int alloc_unr_specific(struct unrhdr *uh, u_int item);
int alloc_unrl(struct unrhdr *uh);
void free_unr(struct unrhdr *uh, u_int item);





static __inline uint32_t
bitcount32(uint32_t x)
{

 x = (x & 0x55555555) + ((x & 0xaaaaaaaa) >> 1);
 x = (x & 0x33333333) + ((x & 0xcccccccc) >> 2);
 x = (x + (x >> 4)) & 0x0f0f0f0f;
 x = (x + (x >> 8));
 x = (x + (x >> 16)) & 0x000000ff;
 return (x);
}

static __inline uint16_t
bitcount16(uint32_t x)
{

 x = (x & 0x5555) + ((x & 0xaaaa) >> 1);
 x = (x & 0x3333) + ((x & 0xcccc) >> 2);
 x = (x + (x >> 4)) & 0x0f0f;
 x = (x + (x >> 8)) & 0x00ff;
 return (x);
}
# 35 "/home/jra40/P4/tesla/sys/cam/cam.c" 2
# 1 "/home/jra40/P4/tesla/sys/sys/kernel.h" 1
# 48 "/home/jra40/P4/tesla/sys/sys/kernel.h"
# 1 "/home/jra40/P4/tesla/sys/sys/linker_set.h" 1
# 49 "/home/jra40/P4/tesla/sys/sys/kernel.h" 2
# 58 "/home/jra40/P4/tesla/sys/sys/kernel.h"
extern char kernelname[1024];

extern int tick;
extern int hz;
extern int psratio;
extern int stathz;
extern int profhz;
extern int profprocs;
extern volatile int ticks;
# 88 "/home/jra40/P4/tesla/sys/sys/kernel.h"
enum sysinit_sub_id {
 SI_SUB_DUMMY = 0x0000000,
 SI_SUB_DONE = 0x0000001,
 SI_SUB_TUNABLES = 0x0700000,
 SI_SUB_COPYRIGHT = 0x0800001,
 SI_SUB_SETTINGS = 0x0880000,
 SI_SUB_MTX_POOL_STATIC = 0x0900000,
 SI_SUB_LOCKMGR = 0x0980000,
 SI_SUB_VM = 0x1000000,
 SI_SUB_KMEM = 0x1800000,
 SI_SUB_KVM_RSRC = 0x1A00000,
 SI_SUB_WITNESS = 0x1A80000,
 SI_SUB_MTX_POOL_DYNAMIC = 0x1AC0000,
 SI_SUB_LOCK = 0x1B00000,
 SI_SUB_EVENTHANDLER = 0x1C00000,
 SI_SUB_TESLA = 0x1C80000,
 SI_SUB_VNET_PRELINK = 0x1E00000,
 SI_SUB_KLD = 0x2000000,
 SI_SUB_CPU = 0x2100000,
 SI_SUB_RACCT = 0x2110000,
 SI_SUB_RANDOM = 0x2120000,
 SI_SUB_KDTRACE = 0x2140000,
 SI_SUB_MAC = 0x2180000,
 SI_SUB_MAC_POLICY = 0x21C0000,
 SI_SUB_MAC_LATE = 0x21D0000,
 SI_SUB_VNET = 0x21E0000,
 SI_SUB_INTRINSIC = 0x2200000,
 SI_SUB_VM_CONF = 0x2300000,
 SI_SUB_DDB_SERVICES = 0x2380000,
 SI_SUB_RUN_QUEUE = 0x2400000,
 SI_SUB_KTRACE = 0x2480000,
 SI_SUB_OPENSOLARIS = 0x2490000,
 SI_SUB_CYCLIC = 0x24A0000,
 SI_SUB_AUDIT = 0x24C0000,
 SI_SUB_CREATE_INIT = 0x2500000,
 SI_SUB_SCHED_IDLE = 0x2600000,
 SI_SUB_MBUF = 0x2700000,
 SI_SUB_INTR = 0x2800000,
 SI_SUB_SOFTINTR = 0x2800001,
 SI_SUB_ACL = 0x2900000,
 SI_SUB_DEVFS = 0x2F00000,
 SI_SUB_INIT_IF = 0x3000000,
 SI_SUB_NETGRAPH = 0x3010000,
 SI_SUB_DTRACE = 0x3020000,
 SI_SUB_DTRACE_PROVIDER = 0x3048000,
 SI_SUB_DTRACE_ANON = 0x308C000,
 SI_SUB_DRIVERS = 0x3100000,
 SI_SUB_CONFIGURE = 0x3800000,
 SI_SUB_VFS = 0x4000000,
 SI_SUB_CLOCKS = 0x4800000,
 SI_SUB_CLIST = 0x5800000,
 SI_SUB_SYSV_SHM = 0x6400000,
 SI_SUB_SYSV_SEM = 0x6800000,
 SI_SUB_SYSV_MSG = 0x6C00000,
 SI_SUB_P1003_1B = 0x6E00000,
 SI_SUB_PSEUDO = 0x7000000,
 SI_SUB_EXEC = 0x7400000,
 SI_SUB_PROTO_BEGIN = 0x8000000,
 SI_SUB_PROTO_IF = 0x8400000,
 SI_SUB_PROTO_DOMAININIT = 0x8600000,
 SI_SUB_PROTO_DOMAIN = 0x8800000,
 SI_SUB_PROTO_IFATTACHDOMAIN = 0x8800001,
 SI_SUB_PROTO_END = 0x8ffffff,
 SI_SUB_KPROF = 0x9000000,
 SI_SUB_KICK_SCHEDULER = 0xa000000,
 SI_SUB_INT_CONFIG_HOOKS = 0xa800000,
 SI_SUB_ROOT_CONF = 0xb000000,
 SI_SUB_DUMP_CONF = 0xb200000,
 SI_SUB_RAID = 0xb380000,
 SI_SUB_SWAP = 0xc000000,
 SI_SUB_INTRINSIC_POST = 0xd000000,
 SI_SUB_SYSCALLS = 0xd800000,
 SI_SUB_VNET_DONE = 0xdc00000,
 SI_SUB_KTHREAD_INIT = 0xe000000,
 SI_SUB_KTHREAD_PAGE = 0xe400000,
 SI_SUB_KTHREAD_VM = 0xe800000,
 SI_SUB_KTHREAD_BUF = 0xea00000,
 SI_SUB_KTHREAD_UPDATE = 0xec00000,
 SI_SUB_KTHREAD_IDLE = 0xee00000,
 SI_SUB_SMP = 0xf000000,
 SI_SUB_RACCTD = 0xf100000,
 SI_SUB_RUN_SCHEDULER = 0xfffffff
};





enum sysinit_elem_order {
 SI_ORDER_FIRST = 0x0000000,
 SI_ORDER_SECOND = 0x0000001,
 SI_ORDER_THIRD = 0x0000002,
 SI_ORDER_FOURTH = 0x0000003,
 SI_ORDER_MIDDLE = 0x1000000,
 SI_ORDER_ANY = 0xfffffff
};
# 209 "/home/jra40/P4/tesla/sys/sys/kernel.h"
typedef void (*sysinit_nfunc_t)(void *);
typedef void (*sysinit_cfunc_t)(const void *);

struct sysinit {
 enum sysinit_sub_id subsystem;
 enum sysinit_elem_order order;
 sysinit_cfunc_t func;
 const void *udata;
};
# 260 "/home/jra40/P4/tesla/sys/sys/kernel.h"
void sysinit_add(struct sysinit **set, struct sysinit **set_end);
# 275 "/home/jra40/P4/tesla/sys/sys/kernel.h"
extern void tunable_int_init(void *);
struct tunable_int {
 const char *path;
 int *var;
};
# 294 "/home/jra40/P4/tesla/sys/sys/kernel.h"
extern void tunable_long_init(void *);
struct tunable_long {
 const char *path;
 long *var;
};
# 313 "/home/jra40/P4/tesla/sys/sys/kernel.h"
extern void tunable_ulong_init(void *);
struct tunable_ulong {
 const char *path;
 unsigned long *var;
};
# 332 "/home/jra40/P4/tesla/sys/sys/kernel.h"
extern void tunable_quad_init(void *);
struct tunable_quad {
 const char *path;
 quad_t *var;
};
# 348 "/home/jra40/P4/tesla/sys/sys/kernel.h"
extern void tunable_str_init(void *);
struct tunable_str {
 const char *path;
 char *var;
 int size;
};
# 367 "/home/jra40/P4/tesla/sys/sys/kernel.h"
struct intr_config_hook {
 struct { struct intr_config_hook *tqe_next; struct intr_config_hook **tqe_prev; } ich_links;
 void (*ich_func)(void *arg);
 void *ich_arg;
};

int config_intrhook_establish(struct intr_config_hook *hook);
void config_intrhook_disestablish(struct intr_config_hook *hook);
# 36 "/home/jra40/P4/tesla/sys/cam/cam.c" 2
# 1 "/home/jra40/P4/tesla/sys/sys/sysctl.h" 1
# 41 "/home/jra40/P4/tesla/sys/sys/sysctl.h"
struct thread;
# 60 "/home/jra40/P4/tesla/sys/sys/sysctl.h"
struct ctlname {
 char *ctl_name;
 int ctl_type;
};
# 142 "/home/jra40/P4/tesla/sys/sys/sysctl.h"
struct sysctl_req {
 struct thread *td;
 int lock;
 void *oldptr;
 size_t oldlen;
 size_t oldidx;
 int (*oldfunc)(struct sysctl_req *, const void *, size_t);
 void *newptr;
 size_t newlen;
 size_t newidx;
 int (*newfunc)(struct sysctl_req *, void *, size_t);
 size_t validlen;
 int flags;
};

struct sysctl_oid_list { struct sysctl_oid *slh_first; };





struct sysctl_oid {
 struct sysctl_oid_list *oid_parent;
 struct { struct sysctl_oid *sle_next; } oid_link;
 int oid_number;
 u_int oid_kind;
 void *oid_arg1;
 intptr_t oid_arg2;
 const char *oid_name;
 int (*oid_handler)(struct sysctl_oid *oidp, void *arg1, intptr_t arg2, struct sysctl_req *req);
 const char *oid_fmt;
 int oid_refcnt;
 u_int oid_running;
 const char *oid_descr;
};




int sysctl_handle_int(struct sysctl_oid *oidp, void *arg1, intptr_t arg2, struct sysctl_req *req);
int sysctl_msec_to_ticks(struct sysctl_oid *oidp, void *arg1, intptr_t arg2, struct sysctl_req *req);
int sysctl_handle_long(struct sysctl_oid *oidp, void *arg1, intptr_t arg2, struct sysctl_req *req);
int sysctl_handle_64(struct sysctl_oid *oidp, void *arg1, intptr_t arg2, struct sysctl_req *req);
int sysctl_handle_string(struct sysctl_oid *oidp, void *arg1, intptr_t arg2, struct sysctl_req *req);
int sysctl_handle_opaque(struct sysctl_oid *oidp, void *arg1, intptr_t arg2, struct sysctl_req *req);
int sysctl_handle_counter_u64(struct sysctl_oid *oidp, void *arg1, intptr_t arg2, struct sysctl_req *req);

int sysctl_dpcpu_int(struct sysctl_oid *oidp, void *arg1, intptr_t arg2, struct sysctl_req *req);
int sysctl_dpcpu_long(struct sysctl_oid *oidp, void *arg1, intptr_t arg2, struct sysctl_req *req);
int sysctl_dpcpu_quad(struct sysctl_oid *oidp, void *arg1, intptr_t arg2, struct sysctl_req *req);




void sysctl_register_oid(struct sysctl_oid *oidp);
void sysctl_unregister_oid(struct sysctl_oid *oidp);
# 214 "/home/jra40/P4/tesla/sys/sys/sysctl.h"
struct sysctl_ctx_entry {
 struct sysctl_oid *entry;
 struct { struct sysctl_ctx_entry *tqe_next; struct sysctl_ctx_entry **tqe_prev; } link;
};

struct sysctl_ctx_list { struct sysctl_ctx_entry *tqh_first; struct sysctl_ctx_entry **tqh_last; };
# 245 "/home/jra40/P4/tesla/sys/sys/sysctl.h"
union sysctl_INT { long allow_0; int *a; } __attribute__((__transparent_union__)); static inline void * __sysctl_assert_INT(union sysctl_INT ptr) { return (ptr.a); } struct __hack;
union sysctl_UINT { long allow_0; unsigned int *a; } __attribute__((__transparent_union__)); static inline void * __sysctl_assert_UINT(union sysctl_UINT ptr) { return (ptr.a); } struct __hack;
union sysctl_LONG { long allow_0; long *a; } __attribute__((__transparent_union__)); static inline void * __sysctl_assert_LONG(union sysctl_LONG ptr) { return (ptr.a); } struct __hack;
union sysctl_ULONG { long allow_0; unsigned long *a; } __attribute__((__transparent_union__)); static inline void * __sysctl_assert_ULONG(union sysctl_ULONG ptr) { return (ptr.a); } struct __hack;
union sysctl_INT64 { long allow_0; int64_t *a; long long *b; } __attribute__((__transparent_union__)); static inline void * __sysctl_assert_INT64(union sysctl_INT64 ptr) { return (ptr.a); } struct __hack;
union sysctl_UINT64 { long allow_0; uint64_t *a; unsigned long long *b; } __attribute__((__transparent_union__)); static inline void * __sysctl_assert_UINT64(union sysctl_UINT64 ptr) { return (ptr.a); } struct __hack;
# 741 "/home/jra40/P4/tesla/sys/sys/sysctl.h"
extern struct sysctl_oid_list sysctl__children;
extern struct sysctl_oid_list sysctl__kern_children;
extern struct sysctl_oid_list sysctl__kern_features_children;
extern struct sysctl_oid_list sysctl__kern_ipc_children;
extern struct sysctl_oid_list sysctl__kern_proc_children;
extern struct sysctl_oid_list sysctl__kern_sched_children;
extern struct sysctl_oid_list sysctl__kern_sched_stats_children;
extern struct sysctl_oid_list sysctl__sysctl_children;
extern struct sysctl_oid_list sysctl__vm_children;
extern struct sysctl_oid_list sysctl__vm_stats_children;
extern struct sysctl_oid_list sysctl__vm_stats_misc_children;
extern struct sysctl_oid_list sysctl__vfs_children;
extern struct sysctl_oid_list sysctl__net_children;
extern struct sysctl_oid_list sysctl__debug_children;
extern struct sysctl_oid_list sysctl__debug_sizeof_children;
extern struct sysctl_oid_list sysctl__dev_children;
extern struct sysctl_oid_list sysctl__hw_children;
extern struct sysctl_oid_list sysctl__hw_bus_children;
extern struct sysctl_oid_list sysctl__hw_bus_devices_children;
extern struct sysctl_oid_list sysctl__hw_bus_info_children;
extern struct sysctl_oid_list sysctl__machdep_children;
extern struct sysctl_oid_list sysctl__user_children;
extern struct sysctl_oid_list sysctl__compat_children;
extern struct sysctl_oid_list sysctl__regression_children;
extern struct sysctl_oid_list sysctl__security_children;
extern struct sysctl_oid_list sysctl__security_bsd_children;

extern char machine[];
extern char osrelease[];
extern char ostype[];
extern char kern_ident[];


struct sysctl_oid *sysctl_add_oid(struct sysctl_ctx_list *clist,
  struct sysctl_oid_list *parent, int nbr, const char *name,
  int kind, void *arg1, intptr_t arg2,
  int (*handler) (struct sysctl_oid *oidp, void *arg1, intptr_t arg2, struct sysctl_req *req),
  const char *fmt, const char *descr);
int sysctl_remove_name(struct sysctl_oid *parent, const char *name, int del,
  int recurse);
void sysctl_rename_oid(struct sysctl_oid *oidp, const char *name);
int sysctl_move_oid(struct sysctl_oid *oidp,
  struct sysctl_oid_list *parent);
int sysctl_remove_oid(struct sysctl_oid *oidp, int del, int recurse);
int sysctl_ctx_init(struct sysctl_ctx_list *clist);
int sysctl_ctx_free(struct sysctl_ctx_list *clist);
struct sysctl_ctx_entry *sysctl_ctx_entry_add(struct sysctl_ctx_list *clist,
  struct sysctl_oid *oidp);
struct sysctl_ctx_entry *sysctl_ctx_entry_find(struct sysctl_ctx_list *clist,
  struct sysctl_oid *oidp);
int sysctl_ctx_entry_del(struct sysctl_ctx_list *clist,
  struct sysctl_oid *oidp);

int kernel_sysctl(struct thread *td, int *name, u_int namelen, void *old,
        size_t *oldlenp, void *new, size_t newlen,
        size_t *retval, int flags);
int kernel_sysctlbyname(struct thread *td, char *name,
  void *old, size_t *oldlenp, void *new, size_t newlen,
  size_t *retval, int flags);
int userland_sysctl(struct thread *td, int *name, u_int namelen, void *old,
   size_t *oldlenp, int inkernel, void *new, size_t newlen,
   size_t *retval, int flags);
int sysctl_find_oid(int *name, u_int namelen, struct sysctl_oid **noid,
   int *nindx, struct sysctl_req *req);
void sysctl_lock(void);
void sysctl_unlock(void);
int sysctl_wire_old_buffer(struct sysctl_req *req, size_t len);

struct sbuf;
struct sbuf *sbuf_new_for_sysctl(struct sbuf *, char *, int,
      struct sysctl_req *);
# 37 "/home/jra40/P4/tesla/sys/cam/cam.c" 2







# 1 "/home/jra40/P4/tesla/sys/cam/cam.h" 1
# 35 "/home/jra40/P4/tesla/sys/cam/cam.h"
# 1 "./opt_cam.h" 1
# 36 "/home/jra40/P4/tesla/sys/cam/cam.h" 2




typedef u_int path_id_t;
typedef u_int target_id_t;
typedef u_int lun_id_t;
# 60 "/home/jra40/P4/tesla/sys/cam/cam.h"
struct cam_periph;




typedef enum {
    CAM_RL_HOST,
    CAM_RL_BUS,
    CAM_RL_XPT,
    CAM_RL_DEV,
    CAM_RL_NORMAL,
    CAM_RL_VALUES
} cam_rl;




typedef struct {
 u_int32_t priority;







 u_int32_t generation;
 int index;



} cam_pinfo;
# 105 "/home/jra40/P4/tesla/sys/cam/cam.h"
typedef enum {
 CAM_FLAG_NONE = 0x00,
 CAM_EXPECT_INQ_CHANGE = 0x01,
 CAM_RETRY_SELTO = 0x02
} cam_flags;

enum {
 SF_RETRY_UA = 0x01,
 SF_NO_PRINT = 0x02,
 SF_QUIET_IR = 0x04,
 SF_PRINT_ALWAYS = 0x08,
 SF_NO_RECOVERY = 0x10,
 SF_NO_RETRY = 0x20
};


typedef enum {
 CAM_REQ_INPROG,
 CAM_REQ_CMP,
 CAM_REQ_ABORTED,
 CAM_UA_ABORT,
 CAM_REQ_CMP_ERR,
 CAM_BUSY,
 CAM_REQ_INVALID,
 CAM_PATH_INVALID,
 CAM_DEV_NOT_THERE,
 CAM_UA_TERMIO,
 CAM_SEL_TIMEOUT,
 CAM_CMD_TIMEOUT,
 CAM_SCSI_STATUS_ERROR,
 CAM_MSG_REJECT_REC,
 CAM_SCSI_BUS_RESET,
 CAM_UNCOR_PARITY,
 CAM_AUTOSENSE_FAIL = 0x10,
 CAM_NO_HBA,
 CAM_DATA_RUN_ERR,
 CAM_UNEXP_BUSFREE,
 CAM_SEQUENCE_FAIL,
 CAM_CCB_LEN_ERR,
 CAM_PROVIDE_FAIL,
 CAM_BDR_SENT,
 CAM_REQ_TERMIO,
 CAM_UNREC_HBA_ERROR,
 CAM_REQ_TOO_BIG,
 CAM_REQUEUE_REQ,







 CAM_ATA_STATUS_ERROR,
 CAM_SCSI_IT_NEXUS_LOST,
 CAM_SMP_STATUS_ERROR,
 CAM_IDE = 0x33,
 CAM_RESRC_UNAVAIL,
 CAM_UNACKED_EVENT,
 CAM_MESSAGE_RECV,
 CAM_INVALID_CDB,
 CAM_LUN_INVALID,
 CAM_TID_INVALID,
 CAM_FUNC_NOTAVAIL,
 CAM_NO_NEXUS,
 CAM_IID_INVALID,
 CAM_CDB_RECVD,
 CAM_LUN_ALRDY_ENA,
 CAM_SCSI_BUSY,

 CAM_DEV_QFRZN = 0x40,


 CAM_AUTOSNS_VALID = 0x80,
 CAM_RELEASE_SIMQ = 0x100,
 CAM_SIM_QUEUED = 0x200,

 CAM_STATUS_MASK = 0x3F,


 CAM_SENT_SENSE = 0x40000000
} cam_status;

typedef enum {
 CAM_ESF_NONE = 0x00,
 CAM_ESF_COMMAND = 0x01,
 CAM_ESF_CAM_STATUS = 0x02,
 CAM_ESF_PROTO_STATUS = 0x04,
 CAM_ESF_ALL = 0xff
} cam_error_string_flags;

typedef enum {
 CAM_EPF_NONE = 0x00,
 CAM_EPF_MINIMAL = 0x01,
 CAM_EPF_NORMAL = 0x02,
 CAM_EPF_ALL = 0x03,
 CAM_EPF_LEVEL_MASK = 0x0f

} cam_error_proto_flags;

typedef enum {
 CAM_ESF_PRINT_NONE = 0x00,
 CAM_ESF_PRINT_STATUS = 0x10,
 CAM_ESF_PRINT_SENSE = 0x20
} cam_error_scsi_flags;

typedef enum {
 CAM_ESMF_PRINT_NONE = 0x00,
 CAM_ESMF_PRINT_STATUS = 0x10,
 CAM_ESMF_PRINT_FULL_CMD = 0x20,
} cam_error_smp_flags;

typedef enum {
 CAM_EAF_PRINT_NONE = 0x00,
 CAM_EAF_PRINT_STATUS = 0x10,
 CAM_EAF_PRINT_RESULT = 0x20
} cam_error_ata_flags;

struct cam_status_entry
{
 cam_status status_code;
 const char *status_text;
};

extern const struct cam_status_entry cam_status_table[];
extern const int num_cam_status_entries;

extern int cam_sort_io_queues;

union ccb;


extern struct sysctl_oid_list sysctl__kern_cam_children;



typedef int (cam_quirkmatch_t)(caddr_t, caddr_t);

caddr_t cam_quirkmatch(caddr_t target, caddr_t quirk_table, int num_entries,
         int entry_size, cam_quirkmatch_t *comp_func);

void cam_strvis(u_int8_t *dst, const u_int8_t *src, int srclen, int dstlen);

int cam_strmatch(const u_int8_t *str, const u_int8_t *pattern, int str_len);
const struct cam_status_entry*
 cam_fetch_status_entry(cam_status status);

char * cam_error_string(union ccb *ccb, char *str, int str_len,
    cam_error_string_flags flags,
    cam_error_proto_flags proto_flags);
void cam_error_print(union ccb *ccb, cam_error_string_flags flags,
   cam_error_proto_flags proto_flags);
# 269 "/home/jra40/P4/tesla/sys/cam/cam.h"
static __inline void cam_init_pinfo(cam_pinfo *pinfo);

static __inline void cam_init_pinfo(cam_pinfo *pinfo)
{
 pinfo->priority = (u_int32_t)-1;
 pinfo->index = -1;
}
# 45 "/home/jra40/P4/tesla/sys/cam/cam.c" 2
# 1 "/home/jra40/P4/tesla/sys/cam/cam_ccb.h" 1
# 37 "/home/jra40/P4/tesla/sys/cam/cam_ccb.h"
# 1 "/home/jra40/P4/tesla/sys/sys/limits.h" 1
# 36 "/home/jra40/P4/tesla/sys/sys/limits.h"
# 1 "./machine/_limits.h" 1





# 1 "./x86/_limits.h" 1
# 7 "./machine/_limits.h" 2
# 37 "/home/jra40/P4/tesla/sys/sys/limits.h" 2
# 38 "/home/jra40/P4/tesla/sys/cam/cam_ccb.h" 2



# 1 "/home/jra40/P4/tesla/sys/cam/cam_debug.h" 1
# 36 "/home/jra40/P4/tesla/sys/cam/cam_debug.h"
typedef enum {
 CAM_DEBUG_NONE = 0x00,
 CAM_DEBUG_INFO = 0x01,
 CAM_DEBUG_TRACE = 0x02,
 CAM_DEBUG_SUBTRACE = 0x04,
 CAM_DEBUG_CDB = 0x08,
 CAM_DEBUG_XPT = 0x10,
 CAM_DEBUG_PERIPH = 0x20,
 CAM_DEBUG_PROBE = 0x40
} cam_debug_flags;
# 78 "/home/jra40/P4/tesla/sys/cam/cam_debug.h"
extern struct cam_path *cam_dpath;

extern u_int32_t cam_dflags;

extern u_int32_t cam_debug_delay;
# 42 "/home/jra40/P4/tesla/sys/cam/cam_ccb.h" 2
# 1 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h" 1
# 28 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
# 1 "./machine/stdarg.h" 1





# 1 "./x86/stdarg.h" 1
# 39 "./x86/stdarg.h"
typedef __va_list va_list;
# 7 "./machine/stdarg.h" 2
# 29 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h" 2






extern int scsi_delay;
# 67 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
typedef enum {
 SS_NOP = 0x000000,
 SS_RETRY = 0x010000,
 SS_FAIL = 0x020000,
 SS_START = 0x030000,


 SS_TUR = 0x040000,


 SS_MASK = 0xff0000
} scsi_sense_action;

typedef enum {
 SSQ_NONE = 0x0000,
 SSQ_DECREMENT_COUNT = 0x0100,
 SSQ_MANY = 0x0200,
 SSQ_RANGE = 0x0400,





 SSQ_PRINT_SENSE = 0x0800,
 SSQ_MASK = 0xff00
} scsi_sense_action_qualifier;
# 106 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
struct scsi_generic
{
 u_int8_t opcode;
 u_int8_t bytes[11];
};

struct scsi_request_sense
{
 u_int8_t opcode;
 u_int8_t byte2;

 u_int8_t unused[2];
 u_int8_t length;
 u_int8_t control;
};

struct scsi_test_unit_ready
{
 u_int8_t opcode;
 u_int8_t byte2;
 u_int8_t unused[3];
 u_int8_t control;
};

struct scsi_receive_diag {
 uint8_t opcode;
 uint8_t byte2;

 uint8_t page_code;
 uint8_t length[2];
 uint8_t control;
};

struct scsi_send_diag {
 uint8_t opcode;
 uint8_t byte2;
# 154 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
 uint8_t reserved;
 uint8_t length[2];
 uint8_t control;
};

struct scsi_sense
{
 u_int8_t opcode;
 u_int8_t byte2;
 u_int8_t unused[2];
 u_int8_t length;
 u_int8_t control;
};

struct scsi_inquiry
{
 u_int8_t opcode;
 u_int8_t byte2;


 u_int8_t page_code;
 u_int8_t length[2];
 u_int8_t control;
};

struct scsi_mode_sense_6
{
 u_int8_t opcode;
 u_int8_t byte2;

 u_int8_t page;
# 201 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
 u_int8_t subpage;


 u_int8_t length;
 u_int8_t control;
};

struct scsi_mode_sense_10
{
 u_int8_t opcode;
 u_int8_t byte2;

 u_int8_t page;
 u_int8_t subpage;
 u_int8_t unused[3];
 u_int8_t length[2];
 u_int8_t control;
};

struct scsi_mode_select_6
{
 u_int8_t opcode;
 u_int8_t byte2;


 u_int8_t unused[2];
 u_int8_t length;
 u_int8_t control;
};

struct scsi_mode_select_10
{
 u_int8_t opcode;
 u_int8_t byte2;
 u_int8_t unused[5];
 u_int8_t length[2];
 u_int8_t control;
};




struct scsi_mode_hdr_6
{
 u_int8_t datalen;
 u_int8_t medium_type;
 u_int8_t dev_specific;
 u_int8_t block_descr_len;
};

struct scsi_mode_hdr_10
{
 u_int8_t datalen[2];
 u_int8_t medium_type;
 u_int8_t dev_specific;
 u_int8_t reserved[2];
 u_int8_t block_descr_len[2];
};

struct scsi_mode_block_descr
{
 u_int8_t density_code;
 u_int8_t num_blocks[3];
 u_int8_t reserved;
 u_int8_t block_len[3];
};

struct scsi_per_res_in
{
 u_int8_t opcode;
 u_int8_t action;




 u_int8_t reserved[5];
 u_int8_t length[2];
 u_int8_t control;
};

struct scsi_per_res_in_header
{
 u_int8_t generation[4];
 u_int8_t length[4];
};

struct scsi_per_res_key
{
 u_int8_t key[8];
};

struct scsi_per_res_in_keys
{
 struct scsi_per_res_in_header header;
 struct scsi_per_res_key keys[0];
};

struct scsi_per_res_cap
{
 uint8_t length[2];
 uint8_t flags1;




 uint8_t flags2;


 uint8_t type_mask[2];






 uint8_t reserved[2];
};

struct scsi_per_res_in_rsrv_data
{
 uint8_t reservation[8];
 uint8_t obsolete1[4];
 uint8_t reserved;
 uint8_t scopetype;






 uint8_t obsolete2[2];
};

struct scsi_per_res_in_rsrv
{
 struct scsi_per_res_in_header header;
 struct scsi_per_res_in_rsrv_data data;
};

struct scsi_per_res_out
{
 u_int8_t opcode;
 u_int8_t action;
# 353 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
 u_int8_t scope_type;
# 363 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
 u_int8_t reserved[2];
 u_int8_t length[4];
 u_int8_t control;
};

struct scsi_per_res_out_parms
{
 struct scsi_per_res_key res_key;
 u_int8_t serv_act_res_key[8];
 u_int8_t obsolete1[4];
 u_int8_t flags;



 u_int8_t reserved1;
 u_int8_t obsolete2[2];
};


struct scsi_log_sense
{
 u_int8_t opcode;
 u_int8_t byte2;


 u_int8_t page;
# 405 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
 u_int8_t reserved[2];
 u_int8_t paramptr[2];
 u_int8_t length[2];
 u_int8_t control;
};

struct scsi_log_select
{
 u_int8_t opcode;
 u_int8_t byte2;


 u_int8_t page;





 u_int8_t reserved[4];
 u_int8_t length[2];
 u_int8_t control;
};

struct scsi_log_header
{
 u_int8_t page;
 u_int8_t reserved;
 u_int8_t datalen[2];
};

struct scsi_log_param_header {
 u_int8_t param_code[2];
 u_int8_t param_control;
# 449 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
 u_int8_t param_len;
};

struct scsi_control_page {
 u_int8_t page_code;
 u_int8_t page_length;
 u_int8_t rlec;
# 466 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
 u_int8_t queue_flags;





 u_int8_t eca_and_aen;




 u_int8_t reserved;
 u_int8_t aen_holdoff_period[2];
};

struct scsi_cache_page {
 u_int8_t page_code;

 u_int8_t page_length;
 u_int8_t cache_flags;



 u_int8_t rw_cache_policy;
 u_int8_t dis_prefetch[2];
 u_int8_t min_prefetch[2];
 u_int8_t max_prefetch[2];
 u_int8_t max_prefetch_ceil[2];
};






struct scsi_caching_page {
 uint8_t page_code;

 uint8_t page_length;
 uint8_t flags1;
# 514 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
 uint8_t ret_priority;
 uint8_t disable_pf_transfer_len[2];
 uint8_t min_prefetch[2];
 uint8_t max_prefetch[2];
 uint8_t max_pf_ceiling[2];
 uint8_t flags2;





 uint8_t cache_segments;
 uint8_t cache_seg_size[2];
 uint8_t reserved;
 uint8_t non_cache_seg_size[3];
};




struct copan_power_subpage {
 uint8_t page_code;

 uint8_t subpage;

 uint8_t page_length[2];
 uint8_t page_version;

 uint8_t total_luns;
 uint8_t max_active_luns;

 uint8_t reserved[25];
};




struct copan_aps_subpage {
 uint8_t page_code;

 uint8_t subpage;

 uint8_t page_length[2];
 uint8_t page_version;

 uint8_t lock_active;


 uint8_t reserved[26];
};




struct copan_debugconf_subpage {
 uint8_t page_code;

 uint8_t subpage;

 uint8_t page_length[2];
 uint8_t page_version;

 uint8_t ctl_time_io_secs[2];
};


struct scsi_info_exceptions_page {
 u_int8_t page_code;

 u_int8_t page_length;
 u_int8_t info_flags;







 u_int8_t mrie;
 u_int8_t interval_timer[4];
 u_int8_t report_count[4];
};

struct scsi_proto_specific_page {
 u_int8_t page_code;

 u_int8_t page_length;
 u_int8_t protocol;
# 612 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
};

struct scsi_reserve
{
 u_int8_t opcode;
 u_int8_t byte2;




 u_int8_t resv_id;
 u_int8_t length[2];
 u_int8_t control;
};

struct scsi_reserve_10 {
 uint8_t opcode;
 uint8_t byte2;



 uint8_t resv_id;
 uint8_t thirdparty_id;
 uint8_t reserved[3];
 uint8_t length[2];
 uint8_t control;
};


struct scsi_release
{
 u_int8_t opcode;
 u_int8_t byte2;
 u_int8_t resv_id;
 u_int8_t unused[1];
 u_int8_t length;
 u_int8_t control;
};

struct scsi_release_10 {
 uint8_t opcode;
 uint8_t byte2;
 uint8_t resv_id;
 uint8_t thirdparty_id;
 uint8_t reserved[3];
 uint8_t length[2];
 uint8_t control;
};

struct scsi_prevent
{
 u_int8_t opcode;
 u_int8_t byte2;
 u_int8_t unused[2];
 u_int8_t how;
 u_int8_t control;
};



struct scsi_sync_cache
{
 u_int8_t opcode;
 u_int8_t byte2;


 u_int8_t begin_lba[4];
 u_int8_t reserved;
 u_int8_t lb_count[2];
 u_int8_t control;
};

struct scsi_sync_cache_16
{
 uint8_t opcode;
 uint8_t byte2;
 uint8_t begin_lba[8];
 uint8_t lb_count[4];
 uint8_t reserved;
 uint8_t control;
};

struct scsi_format {
 uint8_t opcode;
 uint8_t byte2;
# 705 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
 uint8_t vendor;
 uint8_t interleave[2];
 uint8_t control;
};

struct scsi_format_header_short {
 uint8_t reserved;
# 720 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
 uint8_t byte2;
 uint8_t defect_list_len[2];
};

struct scsi_format_header_long {
 uint8_t reserved;
 uint8_t byte2;
 uint8_t reserved2[2];
 uint8_t defect_list_len[4];
};

struct scsi_changedef
{
 u_int8_t opcode;
 u_int8_t byte2;
 u_int8_t unused1;
 u_int8_t how;
 u_int8_t unused[4];
 u_int8_t datalen;
 u_int8_t control;
};

struct scsi_read_buffer
{
 u_int8_t opcode;
 u_int8_t byte2;






        u_int8_t buffer_id;
        u_int8_t offset[3];
        u_int8_t length[3];
        u_int8_t control;
};

struct scsi_write_buffer
{
 u_int8_t opcode;
 u_int8_t byte2;
 u_int8_t buffer_id;
 u_int8_t offset[3];
 u_int8_t length[3];
 u_int8_t control;
};

struct scsi_rw_6
{
 u_int8_t opcode;
 u_int8_t addr[3];


 u_int8_t length;
 u_int8_t control;
};

struct scsi_rw_10
{
 u_int8_t opcode;





 u_int8_t byte2;
 u_int8_t addr[4];
 u_int8_t reserved;
 u_int8_t length[2];
 u_int8_t control;
};

struct scsi_rw_12
{
 u_int8_t opcode;



 u_int8_t byte2;
 u_int8_t addr[4];
 u_int8_t length[4];
 u_int8_t reserved;
 u_int8_t control;
};

struct scsi_rw_16
{
 u_int8_t opcode;



 u_int8_t byte2;
 u_int8_t addr[8];
 u_int8_t length[4];
 u_int8_t reserved;
 u_int8_t control;
};

struct scsi_write_same_10
{
 uint8_t opcode;
 uint8_t byte2;




 uint8_t addr[4];
 uint8_t group;
 uint8_t length[2];
 uint8_t control;
};

struct scsi_write_same_16
{
 uint8_t opcode;
 uint8_t byte2;
 uint8_t addr[8];
 uint8_t length[4];
 uint8_t group;
 uint8_t control;
};

struct scsi_unmap
{
 uint8_t opcode;
 uint8_t byte2;

 uint8_t reserved[4];
 uint8_t group;
 uint8_t length[2];
 uint8_t control;
};

struct scsi_write_verify_10
{
 uint8_t opcode;
 uint8_t byte2;



 uint8_t addr[4];
 uint8_t group;
 uint8_t length[2];
 uint8_t control;
};

struct scsi_write_verify_12
{
 uint8_t opcode;
 uint8_t byte2;
 uint8_t addr[4];
 uint8_t length[4];
 uint8_t group;
 uint8_t control;
};

struct scsi_write_verify_16
{
 uint8_t opcode;
 uint8_t byte2;
 uint8_t addr[8];
 uint8_t length[4];
 uint8_t group;
 uint8_t control;
};


struct scsi_start_stop_unit
{
 u_int8_t opcode;
 u_int8_t byte2;

 u_int8_t reserved[2];
 u_int8_t how;
# 905 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
 u_int8_t control;
};

struct ata_pass_12 {
 u_int8_t opcode;
 u_int8_t protocol;
# 925 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
 u_int8_t flags;





 u_int8_t features;
 u_int8_t sector_count;
 u_int8_t lba_low;
 u_int8_t lba_mid;
 u_int8_t lba_high;
 u_int8_t device;
 u_int8_t command;
 u_int8_t reserved;
 u_int8_t control;
};

struct scsi_maintenance_in
{
        uint8_t opcode;
        uint8_t byte2;


        uint8_t reserved[4];
 uint8_t length[4];
 uint8_t reserved1;
 uint8_t control;
};

struct ata_pass_16 {
 u_int8_t opcode;
 u_int8_t protocol;

 u_int8_t flags;
# 968 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
 u_int8_t features_ext;
 u_int8_t features;
 u_int8_t sector_count_ext;
 u_int8_t sector_count;
 u_int8_t lba_low_ext;
 u_int8_t lba_low;
 u_int8_t lba_mid_ext;
 u_int8_t lba_mid;
 u_int8_t lba_high_ext;
 u_int8_t lba_high;
 u_int8_t device;
 u_int8_t command;
 u_int8_t control;
};
# 1095 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
struct scsi_inquiry_data
{
 u_int8_t device;
# 1133 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
 u_int8_t dev_qual2;


 u_int8_t version;
# 1148 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
 u_int8_t response_format;




 u_int8_t additional_length;



 u_int8_t spc3_flags;







 u_int8_t spc2_flags;
# 1177 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
 u_int8_t flags;
# 1186 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
 char vendor[8];

 char product[16];

 char revision[4];





 u_int8_t vendor_specific0[20];
# 1206 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
 u_int8_t spi3data;
 u_int8_t reserved2;



 u_int8_t version1[2];
 u_int8_t version2[2];
 u_int8_t version3[2];
 u_int8_t version4[2];
 u_int8_t version5[2];
 u_int8_t version6[2];
 u_int8_t version7[2];
 u_int8_t version8[2];

 u_int8_t reserved3[22];


 u_int8_t vendor_specific1[160];
};





struct scsi_vpd_supported_page_list
{
 u_int8_t device;
 u_int8_t page_code;


 u_int8_t reserved;
 u_int8_t length;

 u_int8_t list[251];
};





struct scsi_vpd_supported_pages
{
 u_int8_t device;
 u_int8_t page_code;
 u_int8_t reserved;

 u_int8_t length;
 u_int8_t page_list[0];
};


struct scsi_vpd_unit_serial_number
{
 u_int8_t device;
 u_int8_t page_code;

 u_int8_t reserved;
 u_int8_t length;

 u_int8_t serial_num[251];
};

struct scsi_vpd_device_id
{
 u_int8_t device;
 u_int8_t page_code;




 u_int8_t length[2];
 u_int8_t desc_list[];
};

struct scsi_vpd_id_descriptor
{
 u_int8_t proto_codeset;
# 1296 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
 u_int8_t id_type;
# 1312 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
 u_int8_t reserved;
 u_int8_t length;


 u_int8_t identifier[];
};

struct scsi_vpd_id_t10
{
 u_int8_t vendor[8];
 u_int8_t vendor_spec_id[0];
};

struct scsi_vpd_id_eui64
{
 u_int8_t ieee_company_id[3];
 u_int8_t extension_id[5];
};

struct scsi_vpd_id_naa_basic
{
 uint8_t naa;
# 1343 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
 uint8_t naa_data[];
};

struct scsi_vpd_id_naa_ieee_extended_id
{
 uint8_t naa;
 uint8_t vendor_specific_id_a;
 uint8_t ieee_company_id[3];
 uint8_t vendor_specific_id_b[4];
};

struct scsi_vpd_id_naa_local_reg
{
 uint8_t naa;
 uint8_t local_value[7];
};

struct scsi_vpd_id_naa_ieee_reg
{
 uint8_t naa;
 uint8_t reg_value[7];
# 1372 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
};

struct scsi_vpd_id_naa_ieee_reg_extended
{
 uint8_t naa;
 uint8_t reg_value[15];
# 1387 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
};

struct scsi_vpd_id_rel_trgt_port_id
{
 uint8_t obsolete[2];
 uint8_t rel_trgt_port_id[2];
};

struct scsi_vpd_id_trgt_port_grp_id
{
 uint8_t reserved[2];
 uint8_t trgt_port_grp[2];
};

struct scsi_vpd_id_lun_grp_id
{
 uint8_t reserved[2];
 uint8_t log_unit_grp[2];
};

struct scsi_vpd_id_md5_lun_id
{
 uint8_t lun_id[16];
};

struct scsi_vpd_id_scsi_name
{
 uint8_t name_string[256];
};

struct scsi_service_action_in
{
 uint8_t opcode;
 uint8_t service_action;
 uint8_t action_dependent[13];
 uint8_t control;
};

struct scsi_diag_page {
 uint8_t page_code;
 uint8_t page_specific_flags;
 uint8_t length[2];
 uint8_t params[0];
};
# 1442 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
struct scsi_vpd_block_characteristics
{
 u_int8_t device;
 u_int8_t page_code;

 u_int8_t page_length[2];
 u_int8_t medium_rotation_rate[2];


 u_int8_t reserved1;
 u_int8_t nominal_form_factor;






 u_int8_t reserved2[56];
};





struct scsi_vpd_logical_block_prov
{
 u_int8_t device;
 u_int8_t page_code;

 u_int8_t page_length[2];

 u_int8_t threshold_exponent;
 u_int8_t flags;






 u_int8_t prov_type;


 u_int8_t reserved;




};





struct scsi_vpd_block_limits
{
 u_int8_t device;
 u_int8_t page_code;

 u_int8_t page_length[2];


 u_int8_t reserved1;
 u_int8_t max_cmp_write_len;
 u_int8_t opt_txfer_len_grain[2];
 u_int8_t max_txfer_len[4];
 u_int8_t opt_txfer_len[4];
 u_int8_t max_prefetch[4];
 u_int8_t max_unmap_lba_cnt[4];
 u_int8_t max_unmap_blk_cnt[4];
 u_int8_t opt_unmap_grain[4];
 u_int8_t unmap_grain_align[4];
 u_int8_t max_write_same_length[8];
 u_int8_t reserved2[20];
};

struct scsi_read_capacity
{
 u_int8_t opcode;
 u_int8_t byte2;

 u_int8_t addr[4];
 u_int8_t unused[2];
 u_int8_t pmi;

 u_int8_t control;
};

struct scsi_read_capacity_16
{
 uint8_t opcode;

 uint8_t service_action;
 uint8_t addr[8];
 uint8_t alloc_len[4];


 uint8_t reladr;
 uint8_t control;
};

struct scsi_read_capacity_data
{
 u_int8_t addr[4];
 u_int8_t length[4];
};

struct scsi_read_capacity_data_long
{
 uint8_t addr[8];
 uint8_t length[4];





 uint8_t prot;



 uint8_t prot_lbppbe;
# 1572 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
 uint8_t lalba_lbp[2];
 uint8_t reserved[16];
};

struct scsi_report_luns
{
 uint8_t opcode;
 uint8_t reserved1;



 uint8_t select_report;
 uint8_t reserved2[3];
 uint8_t length[4];
 uint8_t reserved3;
 uint8_t control;
};

struct scsi_report_luns_lundata {
 uint8_t lundata[8];
# 1607 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
};

struct scsi_report_luns_data {
 u_int8_t length[4];
 u_int8_t reserved[4];



 struct scsi_report_luns_lundata luns[0];
};

struct scsi_target_group
{
 uint8_t opcode;
 uint8_t service_action;


 uint8_t reserved1[4];
 uint8_t length[4];
 uint8_t reserved2;
 uint8_t control;
};

struct scsi_target_port_descriptor {
 uint8_t reserved[2];
 uint8_t relative_target_port_identifier[2];
 uint8_t desc_list[];
};

struct scsi_target_port_group_descriptor {
 uint8_t pref_state;
# 1647 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
 uint8_t support;







 uint8_t target_port_group[2];
 uint8_t reserved;
 uint8_t status;



 uint8_t vendor_specific;
 uint8_t target_port_count;
 struct scsi_target_port_descriptor descriptors[];
};

struct scsi_target_group_data {
 uint8_t length[4];
 struct scsi_target_port_group_descriptor groups[];
};

struct scsi_target_group_data_extended {
 uint8_t length[4];
 uint8_t format_type;
 uint8_t implicit_transition_time;
 uint8_t reserved[2];
 struct scsi_target_port_group_descriptor groups[];
};


typedef enum {
 SSD_TYPE_NONE,
 SSD_TYPE_FIXED,
 SSD_TYPE_DESC
} scsi_sense_data_type;

typedef enum {
 SSD_ELEM_NONE,
 SSD_ELEM_SKIP,
 SSD_ELEM_DESC,
 SSD_ELEM_SKS,
 SSD_ELEM_COMMAND,
 SSD_ELEM_INFO,
 SSD_ELEM_FRU,
 SSD_ELEM_STREAM,
 SSD_ELEM_MAX
} scsi_sense_elem_type;


struct scsi_sense_data
{
 uint8_t error_code;





 uint8_t sense_buf[252 - 1];
# 1716 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
};




struct scsi_sense_data_fixed
{
 u_int8_t error_code;




 u_int8_t segment;
 u_int8_t flags;
# 1750 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
 u_int8_t info[4];
 u_int8_t extra_len;
 u_int8_t cmd_spec_info[4];
 u_int8_t add_sense_code;
 u_int8_t add_sense_code_qual;
 u_int8_t fru;
 u_int8_t sense_key_spec[3];




 u_int8_t extra_bytes[14];
# 1770 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
};





struct scsi_sense_data_desc
{
 uint8_t error_code;


 uint8_t sense_key;
 uint8_t add_sense_code;
 uint8_t add_sense_code_qual;
 uint8_t reserved[3];




 uint8_t extra_len;
 uint8_t sense_desc[0];



};

struct scsi_sense_desc_header
{
 uint8_t desc_type;
 uint8_t length;
};
# 1811 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
struct scsi_sense_info
{
 uint8_t desc_type;

 uint8_t length;
 uint8_t byte2;

 uint8_t reserved;
 uint8_t info[8];
};
# 1832 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
struct scsi_sense_command
{
 uint8_t desc_type;

 uint8_t length;
 uint8_t reserved[2];
 uint8_t command_info[8];
};







struct scsi_sense_sks
{
 uint8_t desc_type;

 uint8_t length;
 uint8_t reserved1[2];
 uint8_t sense_key_spec[3];

 uint8_t reserved2;
};




struct scsi_sense_sks_field
{
 uint8_t byte0;




 uint8_t field[2];
};






struct scsi_sense_sks_retry
{
 uint8_t byte0;

 uint8_t actual_retry_count[2];
};




struct scsi_sense_sks_progress
{
 uint8_t byte0;

 uint8_t progress[2];

};




struct scsi_sense_sks_segment
{
 uint8_t byte0;




 uint8_t field[2];
};







struct scsi_sense_sks_overflow
{
 uint8_t byte0;


 uint8_t reserved[2];
};







struct scsi_sense_fru
{
 uint8_t desc_type;

 uint8_t length;
 uint8_t reserved;
 uint8_t fru;
};







struct scsi_sense_stream
{
 uint8_t desc_type;

 uint8_t length;
 uint8_t reserved;
 uint8_t byte3;



};
# 1964 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
struct scsi_sense_block
{
 uint8_t desc_type;

 uint8_t length;
 uint8_t reserved;
 uint8_t byte3;

};






struct scsi_sense_osd_objid
{
 uint8_t desc_type;

 uint8_t length;
 uint8_t reserved[6];




 uint8_t not_init_cmds[4];
 uint8_t completed_cmds[4];
 uint8_t partition_id[8];
 uint8_t object_id[8];
};






struct scsi_sense_osd_integrity
{
 uint8_t desc_type;

 uint8_t length;
 uint8_t integ_check_val[32];
};






struct scsi_sense_osd_attr_id
{
 uint8_t desc_type;

 uint8_t length;
 uint8_t reserved[2];
 uint8_t attr_desc[0];
};






struct scsi_sense_progress
{
 uint8_t desc_type;

 uint8_t length;
 uint8_t sense_key;
 uint8_t add_sense_code;
 uint8_t add_sense_code_qual;
 uint8_t reserved;
 uint8_t progress[2];
};






struct scsi_sense_forwarded
{
 uint8_t desc_type;

 uint8_t length;
 uint8_t byte2;





};





struct scsi_sense_vendor
{
 uint8_t desc_type;


 uint8_t length;
 uint8_t data[0];
};

struct scsi_mode_header_6
{
 u_int8_t data_length;
 u_int8_t medium_type;
 u_int8_t dev_spec;
 u_int8_t blk_desc_len;
};

struct scsi_mode_header_10
{
 u_int8_t data_length[2];
 u_int8_t medium_type;
 u_int8_t dev_spec;
 u_int8_t unused[2];
 u_int8_t blk_desc_len[2];
};

struct scsi_mode_page_header
{
 u_int8_t page_code;



 u_int8_t page_length;
};

struct scsi_mode_page_header_sp
{
 uint8_t page_code;
 uint8_t subpage;
 uint8_t page_length[2];
};


struct scsi_mode_blk_desc
{
 u_int8_t density;
 u_int8_t nblocks[3];
 u_int8_t reserved;
 u_int8_t blklen[3];
};
# 2131 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
struct scsi_inquiry_pattern {
 u_int8_t type;
 u_int8_t media_type;


 const char *vendor;
 const char *product;
 const char *revision;
};

struct scsi_static_inquiry_pattern {
 u_int8_t type;
 u_int8_t media_type;
 char vendor[8 +1];
 char product[16 +1];
 char revision[4 +1];
};

struct scsi_sense_quirk_entry {
 struct scsi_inquiry_pattern inq_pat;
 int num_sense_keys;
 int num_ascs;
 struct sense_key_table_entry *sense_key_info;
 struct asc_table_entry *asc_info;
};

struct sense_key_table_entry {
 u_int8_t sense_key;
 u_int32_t action;
 const char *desc;
};

struct asc_table_entry {
 u_int8_t asc;
 u_int8_t ascq;
 u_int32_t action;
 const char *desc;
};

struct op_table_entry {
 u_int8_t opcode;
 u_int32_t opmask;
 const char *desc;
};

struct scsi_op_quirk_entry {
 struct scsi_inquiry_pattern inq_pat;
 int num_ops;
 struct op_table_entry *op_table;
};

typedef enum {
 SSS_FLAG_NONE = 0x00,
 SSS_FLAG_PRINT_COMMAND = 0x01
} scsi_sense_string_flags;

struct ccb_scsiio;
struct cam_periph;
union ccb;




extern const char *scsi_sense_key_text[];

struct sbuf;


void scsi_sense_desc(int sense_key, int asc, int ascq,
       struct scsi_inquiry_data *inq_data,
       const char **sense_key_desc, const char **asc_desc);
scsi_sense_action scsi_error_action(struct ccb_scsiio* csio,
        struct scsi_inquiry_data *inq_data,
        u_int32_t sense_flags);
const char * scsi_status_string(struct ccb_scsiio *csio);

void scsi_desc_iterate(struct scsi_sense_data_desc *sense, u_int sense_len,
         int (*iter_func)(struct scsi_sense_data_desc *sense,
     u_int, struct scsi_sense_desc_header *,
     void *), void *arg);
uint8_t *scsi_find_desc(struct scsi_sense_data_desc *sense, u_int sense_len,
   uint8_t desc_type);
void scsi_set_sense_data(struct scsi_sense_data *sense_data,
    scsi_sense_data_type sense_format, int current_error,
    int sense_key, int asc, int ascq, ...) ;
void scsi_set_sense_data_va(struct scsi_sense_data *sense_data,
       scsi_sense_data_type sense_format,
       int current_error, int sense_key, int asc,
       int ascq, va_list ap);
int scsi_get_sense_info(struct scsi_sense_data *sense_data, u_int sense_len,
   uint8_t info_type, uint64_t *info,
   int64_t *signed_info);
int scsi_get_sks(struct scsi_sense_data *sense_data, u_int sense_len,
   uint8_t *sks);
int scsi_get_block_info(struct scsi_sense_data *sense_data, u_int sense_len,
   struct scsi_inquiry_data *inq_data,
   uint8_t *block_bits);
int scsi_get_stream_info(struct scsi_sense_data *sense_data, u_int sense_len,
    struct scsi_inquiry_data *inq_data,
    uint8_t *stream_bits);
void scsi_info_sbuf(struct sbuf *sb, uint8_t *cdb, int cdb_len,
      struct scsi_inquiry_data *inq_data, uint64_t info);
void scsi_command_sbuf(struct sbuf *sb, uint8_t *cdb, int cdb_len,
         struct scsi_inquiry_data *inq_data, uint64_t csi);
void scsi_progress_sbuf(struct sbuf *sb, uint16_t progress);
int scsi_sks_sbuf(struct sbuf *sb, int sense_key, uint8_t *sks);
void scsi_fru_sbuf(struct sbuf *sb, uint64_t fru);
void scsi_stream_sbuf(struct sbuf *sb, uint8_t stream_bits, uint64_t info);
void scsi_block_sbuf(struct sbuf *sb, uint8_t block_bits, uint64_t info);
void scsi_sense_info_sbuf(struct sbuf *sb, struct scsi_sense_data *sense,
     u_int sense_len, uint8_t *cdb, int cdb_len,
     struct scsi_inquiry_data *inq_data,
     struct scsi_sense_desc_header *header);

void scsi_sense_command_sbuf(struct sbuf *sb, struct scsi_sense_data *sense,
        u_int sense_len, uint8_t *cdb, int cdb_len,
        struct scsi_inquiry_data *inq_data,
        struct scsi_sense_desc_header *header);
void scsi_sense_sks_sbuf(struct sbuf *sb, struct scsi_sense_data *sense,
    u_int sense_len, uint8_t *cdb, int cdb_len,
    struct scsi_inquiry_data *inq_data,
    struct scsi_sense_desc_header *header);
void scsi_sense_fru_sbuf(struct sbuf *sb, struct scsi_sense_data *sense,
    u_int sense_len, uint8_t *cdb, int cdb_len,
    struct scsi_inquiry_data *inq_data,
    struct scsi_sense_desc_header *header);
void scsi_sense_stream_sbuf(struct sbuf *sb, struct scsi_sense_data *sense,
       u_int sense_len, uint8_t *cdb, int cdb_len,
       struct scsi_inquiry_data *inq_data,
       struct scsi_sense_desc_header *header);
void scsi_sense_block_sbuf(struct sbuf *sb, struct scsi_sense_data *sense,
      u_int sense_len, uint8_t *cdb, int cdb_len,
      struct scsi_inquiry_data *inq_data,
      struct scsi_sense_desc_header *header);
void scsi_sense_progress_sbuf(struct sbuf *sb, struct scsi_sense_data *sense,
         u_int sense_len, uint8_t *cdb, int cdb_len,
         struct scsi_inquiry_data *inq_data,
         struct scsi_sense_desc_header *header);
void scsi_sense_generic_sbuf(struct sbuf *sb, struct scsi_sense_data *sense,
        u_int sense_len, uint8_t *cdb, int cdb_len,
        struct scsi_inquiry_data *inq_data,
        struct scsi_sense_desc_header *header);
void scsi_sense_desc_sbuf(struct sbuf *sb, struct scsi_sense_data *sense,
     u_int sense_len, uint8_t *cdb, int cdb_len,
     struct scsi_inquiry_data *inq_data,
     struct scsi_sense_desc_header *header);
scsi_sense_data_type scsi_sense_type(struct scsi_sense_data *sense_data);

void scsi_sense_only_sbuf(struct scsi_sense_data *sense, u_int sense_len,
     struct sbuf *sb, char *path_str,
     struct scsi_inquiry_data *inq_data, uint8_t *cdb,
     int cdb_len);


int scsi_command_string(struct ccb_scsiio *csio, struct sbuf *sb);
int scsi_sense_sbuf(struct ccb_scsiio *csio, struct sbuf *sb,
    scsi_sense_string_flags flags);
char * scsi_sense_string(struct ccb_scsiio *csio,
      char *str, int str_len);
void scsi_sense_print(struct ccb_scsiio *csio);
int scsi_vpd_supported_page(struct cam_periph *periph,
     uint8_t page_id);
# 2306 "/home/jra40/P4/tesla/sys/cam/scsi/scsi_all.h"
const char * scsi_op_desc(u_int16_t opcode,
        struct scsi_inquiry_data *inq_data);
char * scsi_cdb_string(u_int8_t *cdb_ptr, char *cdb_string,
    size_t len);

void scsi_print_inquiry(struct scsi_inquiry_data *inq_data);

u_int scsi_calc_syncsrate(u_int period_factor);
u_int scsi_calc_syncparam(u_int period);

typedef int (*scsi_devid_checkfn_t)(uint8_t *);
int scsi_devid_is_naa_ieee_reg(uint8_t *bufp);
int scsi_devid_is_sas_target(uint8_t *bufp);
uint8_t * scsi_get_devid(struct scsi_vpd_device_id *id, uint32_t len,
          scsi_devid_checkfn_t ck_fn);

void scsi_test_unit_ready(struct ccb_scsiio *csio, u_int32_t retries,
         void (*cbfcnp)(struct cam_periph *,
          union ccb *),
         u_int8_t tag_action,
         u_int8_t sense_len, u_int32_t timeout);

void scsi_request_sense(struct ccb_scsiio *csio, u_int32_t retries,
       void (*cbfcnp)(struct cam_periph *,
        union ccb *),
       void *data_ptr, u_int8_t dxfer_len,
       u_int8_t tag_action, u_int8_t sense_len,
       u_int32_t timeout);

void scsi_inquiry(struct ccb_scsiio *csio, u_int32_t retries,
        void (*cbfcnp)(struct cam_periph *, union ccb *),
        u_int8_t tag_action, u_int8_t *inq_buf,
        u_int32_t inq_len, int evpd, u_int8_t page_code,
        u_int8_t sense_len, u_int32_t timeout);

void scsi_mode_sense(struct ccb_scsiio *csio, u_int32_t retries,
    void (*cbfcnp)(struct cam_periph *,
            union ccb *),
    u_int8_t tag_action, int dbd,
    u_int8_t page_code, u_int8_t page,
    u_int8_t *param_buf, u_int32_t param_len,
    u_int8_t sense_len, u_int32_t timeout);

void scsi_mode_sense_len(struct ccb_scsiio *csio, u_int32_t retries,
        void (*cbfcnp)(struct cam_periph *,
         union ccb *),
        u_int8_t tag_action, int dbd,
        u_int8_t page_code, u_int8_t page,
        u_int8_t *param_buf, u_int32_t param_len,
        int minimum_cmd_size, u_int8_t sense_len,
        u_int32_t timeout);

void scsi_mode_select(struct ccb_scsiio *csio, u_int32_t retries,
     void (*cbfcnp)(struct cam_periph *,
      union ccb *),
     u_int8_t tag_action, int scsi_page_fmt,
     int save_pages, u_int8_t *param_buf,
     u_int32_t param_len, u_int8_t sense_len,
     u_int32_t timeout);

void scsi_mode_select_len(struct ccb_scsiio *csio, u_int32_t retries,
         void (*cbfcnp)(struct cam_periph *,
          union ccb *),
         u_int8_t tag_action, int scsi_page_fmt,
         int save_pages, u_int8_t *param_buf,
         u_int32_t param_len, int minimum_cmd_size,
         u_int8_t sense_len, u_int32_t timeout);

void scsi_log_sense(struct ccb_scsiio *csio, u_int32_t retries,
          void (*cbfcnp)(struct cam_periph *, union ccb *),
          u_int8_t tag_action, u_int8_t page_code,
          u_int8_t page, int save_pages, int ppc,
          u_int32_t paramptr, u_int8_t *param_buf,
          u_int32_t param_len, u_int8_t sense_len,
          u_int32_t timeout);

void scsi_log_select(struct ccb_scsiio *csio, u_int32_t retries,
    void (*cbfcnp)(struct cam_periph *,
    union ccb *), u_int8_t tag_action,
    u_int8_t page_code, int save_pages,
    int pc_reset, u_int8_t *param_buf,
    u_int32_t param_len, u_int8_t sense_len,
    u_int32_t timeout);

void scsi_prevent(struct ccb_scsiio *csio, u_int32_t retries,
        void (*cbfcnp)(struct cam_periph *, union ccb *),
        u_int8_t tag_action, u_int8_t action,
        u_int8_t sense_len, u_int32_t timeout);

void scsi_read_capacity(struct ccb_scsiio *csio, u_int32_t retries,
       void (*cbfcnp)(struct cam_periph *,
       union ccb *), u_int8_t tag_action,
       struct scsi_read_capacity_data *,
       u_int8_t sense_len, u_int32_t timeout);
void scsi_read_capacity_16(struct ccb_scsiio *csio, uint32_t retries,
          void (*cbfcnp)(struct cam_periph *,
          union ccb *), uint8_t tag_action,
          uint64_t lba, int reladr, int pmi,
          uint8_t *rcap_buf, int rcap_buf_len,
          uint8_t sense_len, uint32_t timeout);

void scsi_report_luns(struct ccb_scsiio *csio, u_int32_t retries,
     void (*cbfcnp)(struct cam_periph *,
     union ccb *), u_int8_t tag_action,
     u_int8_t select_report,
     struct scsi_report_luns_data *rpl_buf,
     u_int32_t alloc_len, u_int8_t sense_len,
     u_int32_t timeout);

void scsi_report_target_group(struct ccb_scsiio *csio, u_int32_t retries,
     void (*cbfcnp)(struct cam_periph *,
     union ccb *), u_int8_t tag_action,
     u_int8_t pdf,
     void *buf,
     u_int32_t alloc_len, u_int8_t sense_len,
     u_int32_t timeout);

void scsi_set_target_group(struct ccb_scsiio *csio, u_int32_t retries,
     void (*cbfcnp)(struct cam_periph *,
     union ccb *), u_int8_t tag_action, void *buf,
     u_int32_t alloc_len, u_int8_t sense_len,
     u_int32_t timeout);

void scsi_synchronize_cache(struct ccb_scsiio *csio,
           u_int32_t retries,
           void (*cbfcnp)(struct cam_periph *,
           union ccb *), u_int8_t tag_action,
           u_int32_t begin_lba, u_int16_t lb_count,
           u_int8_t sense_len, u_int32_t timeout);

void scsi_receive_diagnostic_results(struct ccb_scsiio *csio, u_int32_t retries,
         void (*cbfcnp)(struct cam_periph *,
          union ccb*),
         uint8_t tag_action, int pcv,
         uint8_t page_code, uint8_t *data_ptr,
         uint16_t allocation_length,
         uint8_t sense_len, uint32_t timeout);

void scsi_send_diagnostic(struct ccb_scsiio *csio, u_int32_t retries,
     void (*cbfcnp)(struct cam_periph *, union ccb *),
     uint8_t tag_action, int unit_offline,
     int device_offline, int self_test, int page_format,
     int self_test_code, uint8_t *data_ptr,
     uint16_t param_list_length, uint8_t sense_len,
     uint32_t timeout);

void scsi_read_buffer(struct ccb_scsiio *csio, u_int32_t retries,
   void (*cbfcnp)(struct cam_periph *, union ccb*),
   uint8_t tag_action, int mode,
   uint8_t buffer_id, u_int32_t offset,
   uint8_t *data_ptr, uint32_t allocation_length,
   uint8_t sense_len, uint32_t timeout);

void scsi_write_buffer(struct ccb_scsiio *csio, u_int32_t retries,
   void (*cbfcnp)(struct cam_periph *, union ccb *),
   uint8_t tag_action, int mode,
   uint8_t buffer_id, u_int32_t offset,
   uint8_t *data_ptr, uint32_t param_list_length,
   uint8_t sense_len, uint32_t timeout);





void scsi_read_write(struct ccb_scsiio *csio, u_int32_t retries,
       void (*cbfcnp)(struct cam_periph *, union ccb *),
       u_int8_t tag_action, int readop, u_int8_t byte2,
       int minimum_cmd_size, u_int64_t lba,
       u_int32_t block_count, u_int8_t *data_ptr,
       u_int32_t dxfer_len, u_int8_t sense_len,
       u_int32_t timeout);

void scsi_write_same(struct ccb_scsiio *csio, u_int32_t retries,
       void (*cbfcnp)(struct cam_periph *, union ccb *),
       u_int8_t tag_action, u_int8_t byte2,
       int minimum_cmd_size, u_int64_t lba,
       u_int32_t block_count, u_int8_t *data_ptr,
       u_int32_t dxfer_len, u_int8_t sense_len,
       u_int32_t timeout);

void scsi_ata_identify(struct ccb_scsiio *csio, u_int32_t retries,
         void (*cbfcnp)(struct cam_periph *, union ccb *),
         u_int8_t tag_action, u_int8_t *data_ptr,
         u_int16_t dxfer_len, u_int8_t sense_len,
         u_int32_t timeout);

void scsi_ata_trim(struct ccb_scsiio *csio, u_int32_t retries,
            void (*cbfcnp)(struct cam_periph *, union ccb *),
            u_int8_t tag_action, u_int16_t block_count,
            u_int8_t *data_ptr, u_int16_t dxfer_len,
            u_int8_t sense_len, u_int32_t timeout);

void scsi_ata_pass_16(struct ccb_scsiio *csio, u_int32_t retries,
        void (*cbfcnp)(struct cam_periph *, union ccb *),
        u_int32_t flags, u_int8_t tag_action,
        u_int8_t protocol, u_int8_t ata_flags, u_int16_t features,
        u_int16_t sector_count, uint64_t lba, u_int8_t command,
        u_int8_t control, u_int8_t *data_ptr, u_int16_t dxfer_len,
        u_int8_t sense_len, u_int32_t timeout);

void scsi_unmap(struct ccb_scsiio *csio, u_int32_t retries,
  void (*cbfcnp)(struct cam_periph *, union ccb *),
  u_int8_t tag_action, u_int8_t byte2,
  u_int8_t *data_ptr, u_int16_t dxfer_len,
  u_int8_t sense_len, u_int32_t timeout);

void scsi_start_stop(struct ccb_scsiio *csio, u_int32_t retries,
       void (*cbfcnp)(struct cam_periph *, union ccb *),
       u_int8_t tag_action, int start, int load_eject,
       int immediate, u_int8_t sense_len, u_int32_t timeout);

int scsi_inquiry_match(caddr_t inqbuffer, caddr_t table_entry);
int scsi_static_inquiry_match(caddr_t inqbuffer,
       caddr_t table_entry);
int scsi_devid_match(uint8_t *rhs, size_t rhs_len,
     uint8_t *lhs, size_t lhs_len);

void scsi_extract_sense(struct scsi_sense_data *sense, int *error_code,
   int *sense_key, int *asc, int *ascq);
int scsi_extract_sense_ccb(union ccb *ccb, int *error_code, int *sense_key,
      int *asc, int *ascq);
void scsi_extract_sense_len(struct scsi_sense_data *sense,
       u_int sense_len, int *error_code, int *sense_key,
       int *asc, int *ascq, int show_errors);
int scsi_get_sense_key(struct scsi_sense_data *sense, u_int sense_len,
         int show_errors);
int scsi_get_asc(struct scsi_sense_data *sense, u_int sense_len,
   int show_errors);
int scsi_get_ascq(struct scsi_sense_data *sense, u_int sense_len,
    int show_errors);
static __inline void scsi_ulto2b(u_int32_t val, u_int8_t *bytes);
static __inline void scsi_ulto3b(u_int32_t val, u_int8_t *bytes);
static __inline void scsi_ulto4b(u_int32_t val, u_int8_t *bytes);
static __inline void scsi_u64to8b(u_int64_t val, u_int8_t *bytes);
static __inline uint32_t scsi_2btoul(const uint8_t *bytes);
static __inline uint32_t scsi_3btoul(const uint8_t *bytes);
static __inline int32_t scsi_3btol(const uint8_t *bytes);
static __inline uint32_t scsi_4btoul(const uint8_t *bytes);
static __inline uint64_t scsi_8btou64(const uint8_t *bytes);
static __inline void *find_mode_page_6(struct scsi_mode_header_6 *mode_header);
static __inline void *find_mode_page_10(struct scsi_mode_header_10 *mode_header);

static __inline void
scsi_ulto2b(u_int32_t val, u_int8_t *bytes)
{

 bytes[0] = (val >> 8) & 0xff;
 bytes[1] = val & 0xff;
}

static __inline void
scsi_ulto3b(u_int32_t val, u_int8_t *bytes)
{

 bytes[0] = (val >> 16) & 0xff;
 bytes[1] = (val >> 8) & 0xff;
 bytes[2] = val & 0xff;
}

static __inline void
scsi_ulto4b(u_int32_t val, u_int8_t *bytes)
{

 bytes[0] = (val >> 24) & 0xff;
 bytes[1] = (val >> 16) & 0xff;
 bytes[2] = (val >> 8) & 0xff;
 bytes[3] = val & 0xff;
}

static __inline void
scsi_u64to8b(u_int64_t val, u_int8_t *bytes)
{

 bytes[0] = (val >> 56) & 0xff;
 bytes[1] = (val >> 48) & 0xff;
 bytes[2] = (val >> 40) & 0xff;
 bytes[3] = (val >> 32) & 0xff;
 bytes[4] = (val >> 24) & 0xff;
 bytes[5] = (val >> 16) & 0xff;
 bytes[6] = (val >> 8) & 0xff;
 bytes[7] = val & 0xff;
}

static __inline uint32_t
scsi_2btoul(const uint8_t *bytes)
{
 uint32_t rv;

 rv = (bytes[0] << 8) |
      bytes[1];
 return (rv);
}

static __inline uint32_t
scsi_3btoul(const uint8_t *bytes)
{
 uint32_t rv;

 rv = (bytes[0] << 16) |
      (bytes[1] << 8) |
      bytes[2];
 return (rv);
}

static __inline int32_t
scsi_3btol(const uint8_t *bytes)
{
 uint32_t rc = scsi_3btoul(bytes);

 if (rc & 0x00800000)
  rc |= 0xff000000;

 return (int32_t) rc;
}

static __inline uint32_t
scsi_4btoul(const uint8_t *bytes)
{
 uint32_t rv;

 rv = (bytes[0] << 24) |
      (bytes[1] << 16) |
      (bytes[2] << 8) |
      bytes[3];
 return (rv);
}

static __inline uint64_t
scsi_8btou64(const uint8_t *bytes)
{
        uint64_t rv;

 rv = (((uint64_t)bytes[0]) << 56) |
      (((uint64_t)bytes[1]) << 48) |
      (((uint64_t)bytes[2]) << 40) |
      (((uint64_t)bytes[3]) << 32) |
      (((uint64_t)bytes[4]) << 24) |
      (((uint64_t)bytes[5]) << 16) |
      (((uint64_t)bytes[6]) << 8) |
      bytes[7];
 return (rv);
}





static __inline void *
find_mode_page_6(struct scsi_mode_header_6 *mode_header)
{
 void *page_start;

 page_start = (void *)((u_int8_t *)&mode_header[1] +
         mode_header->blk_desc_len);

 return(page_start);
}

static __inline void *
find_mode_page_10(struct scsi_mode_header_10 *mode_header)
{
 void *page_start;

 page_start = (void *)((u_int8_t *)&mode_header[1] +
          scsi_2btoul(mode_header->blk_desc_len));

 return(page_start);
}
# 43 "/home/jra40/P4/tesla/sys/cam/cam_ccb.h" 2
# 1 "/home/jra40/P4/tesla/sys/cam/ata/ata_all.h" 1
# 32 "/home/jra40/P4/tesla/sys/cam/ata/ata_all.h"
# 1 "/home/jra40/P4/tesla/sys/sys/ata.h" 1
# 32 "/home/jra40/P4/tesla/sys/sys/ata.h"
# 1 "/home/jra40/P4/tesla/sys/sys/ioccom.h" 1
# 33 "/home/jra40/P4/tesla/sys/sys/ata.h" 2


struct ata_params {
        u_int16_t config;
# 53 "/home/jra40/P4/tesla/sys/sys/ata.h"
        u_int16_t cylinders;
        u_int16_t specconf;
        u_int16_t heads;
 u_int16_t obsolete4;
 u_int16_t obsolete5;
        u_int16_t sectors;
        u_int16_t vendor7[3];
        u_int8_t serial[20];
        u_int16_t retired20;
 u_int16_t retired21;
 u_int16_t obsolete22;
        u_int8_t revision[8];
        u_int8_t model[40];
        u_int16_t sectors_intr;
        u_int16_t usedmovsd;
        u_int16_t capabilities1;






        u_int16_t capabilities2;
        u_int16_t retired_piomode;


        u_int16_t retired_dmamode;


        u_int16_t atavalid;




        u_int16_t current_cylinders;
        u_int16_t current_heads;
        u_int16_t current_sectors;
        u_int16_t current_size_1;
        u_int16_t current_size_2;
        u_int16_t multi;


        u_int16_t lba_size_1;
 u_int16_t lba_size_2;
 u_int16_t obsolete62;
        u_int16_t mwdmamodes;
        u_int16_t apiomodes;

        u_int16_t mwdmamin;
        u_int16_t mwdmarec;
        u_int16_t pioblind;
        u_int16_t pioiordy;
        u_int16_t support3;


 u_int16_t reserved70;
        u_int16_t rlsovlap;
        u_int16_t rlsservice;
 u_int16_t reserved73;
 u_int16_t reserved74;
        u_int16_t queue;


        u_int16_t satacapabilities;
# 129 "/home/jra40/P4/tesla/sys/sys/ata.h"
        u_int16_t satacapabilities2;



        u_int16_t satasupport;






        u_int16_t sataenabled;


        u_int16_t version_major;
        u_int16_t version_minor;

 struct {
            u_int16_t command1;
# 163 "/home/jra40/P4/tesla/sys/sys/ata.h"
            u_int16_t command2;
# 178 "/home/jra40/P4/tesla/sys/sys/ata.h"
            u_int16_t extension;
# 189 "/home/jra40/P4/tesla/sys/sys/ata.h"
 } __attribute__((__packed__)) support, enabled;

        u_int16_t udmamodes;
        u_int16_t erase_time;
        u_int16_t enhanced_erase_time;
        u_int16_t apm_value;
        u_int16_t master_passwd_revision;
        u_int16_t hwres;


        u_int16_t acoustic;



        u_int16_t stream_min_req_size;
        u_int16_t stream_transfer_time;
        u_int16_t stream_access_latency;
        u_int32_t stream_granularity;
        u_int16_t lba_size48_1;
 u_int16_t lba_size48_2;
 u_int16_t lba_size48_3;
 u_int16_t lba_size48_4;
 u_int16_t reserved104;
        u_int16_t max_dsm_blocks;
        u_int16_t pss;



        u_int16_t isd;
        u_int16_t wwn[4];
 u_int16_t reserved112[5];
        u_int16_t lss_1;
        u_int16_t lss_2;
        u_int16_t support2;





        u_int16_t enabled2;
 u_int16_t reserved121[6];
        u_int16_t removable_status;
        u_int16_t security_status;
# 240 "/home/jra40/P4/tesla/sys/sys/ata.h"
 u_int16_t reserved129[31];
        u_int16_t cfa_powermode1;
 u_int16_t reserved161;
        u_int16_t cfa_kms_support;
        u_int16_t cfa_trueide_modes;
        u_int16_t cfa_memory_modes;
 u_int16_t reserved165[4];
        u_int16_t support_dsm;

 u_int16_t reserved170[6];
        u_int8_t media_serial[60];
        u_int16_t sct;
 u_int16_t reserved206[2];
        u_int16_t lsalign;
        u_int16_t wrv_sectors_m3_1;
 u_int16_t wrv_sectors_m3_2;
        u_int16_t wrv_sectors_m2_1;
 u_int16_t wrv_sectors_m2_2;
        u_int16_t nv_cache_caps;
        u_int16_t nv_cache_size_1;
 u_int16_t nv_cache_size_2;
        u_int16_t media_rotation_rate;
 u_int16_t reserved218;
        u_int16_t nv_cache_opt;
        u_int16_t wrv_mode;
 u_int16_t reserved221;
        u_int16_t transport_major;
        u_int16_t transport_minor;
 u_int16_t reserved224[31];
        u_int16_t integrity;
} __attribute__((__packed__));
# 476 "/home/jra40/P4/tesla/sys/sys/ata.h"
struct ata_ioc_devices {
    int channel;
    char name[2][32];
    struct ata_params params[2];
};
# 490 "/home/jra40/P4/tesla/sys/sys/ata.h"
struct atapi_sense {
    u_int8_t error;


    u_int8_t segment;
    u_int8_t key;
# 517 "/home/jra40/P4/tesla/sys/sys/ata.h"
    u_int32_t cmd_info;
    u_int8_t sense_length;
    u_int32_t cmd_specific_info;
    u_int8_t asc;
    u_int8_t ascq;
    u_int8_t replaceable_unit_code;
    u_int8_t specific;



    u_int8_t specific1;
    u_int8_t specific2;
} __attribute__((__packed__));

struct ata_ioc_request {
    union {
 struct {
     u_int8_t command;
     u_int8_t feature;
     u_int64_t lba;
     u_int16_t count;
 } ata;
 struct {
     char ccb[16];
     struct atapi_sense sense;
 } atapi;
    } u;
    caddr_t data;
    int count;
    int flags;





    int timeout;
    int error;
};

struct ata_security_password {
 u_int16_t ctrl;







 u_int8_t password[32];
 u_int16_t revision;
 u_int16_t reserved[238];
};
# 580 "/home/jra40/P4/tesla/sys/sys/ata.h"
struct ata_ioc_raid_config {
     int lun;
     int type;
# 592 "/home/jra40/P4/tesla/sys/sys/ata.h"
     int interleave;
     int status;




     int progress;
     int total_disks;
     int disks[16];
};

struct ata_ioc_raid_status {
     int lun;
     int type;
     int interleave;
     int status;
     int progress;
     int total_disks;
     struct {
      int state;



      int lun;
     } disks[16];
};
# 33 "/home/jra40/P4/tesla/sys/cam/ata/ata_all.h" 2

struct ccb_ataio;
struct cam_periph;
union ccb;





struct ata_cmd {
 u_int8_t flags;






 u_int8_t command;
 u_int8_t features;

 u_int8_t lba_low;
 u_int8_t lba_mid;
 u_int8_t lba_high;
 u_int8_t device;

 u_int8_t lba_low_exp;
 u_int8_t lba_mid_exp;
 u_int8_t lba_high_exp;
 u_int8_t features_exp;

 u_int8_t sector_count;
 u_int8_t sector_count_exp;
 u_int8_t control;
};

struct ata_res {
 u_int8_t flags;


 u_int8_t status;
 u_int8_t error;

 u_int8_t lba_low;
 u_int8_t lba_mid;
 u_int8_t lba_high;
 u_int8_t device;

 u_int8_t lba_low_exp;
 u_int8_t lba_mid_exp;
 u_int8_t lba_high_exp;

 u_int8_t sector_count;
 u_int8_t sector_count_exp;
};

struct sep_identify_data {
 uint8_t length;
 uint8_t subenc_id;
 uint8_t logical_id[8];
 uint8_t vendor_id[8];
 uint8_t product_id[16];
 uint8_t product_rev[4];
 uint8_t channel_id;
 uint8_t firmware_rev[4];
 uint8_t interface_id[6];
 uint8_t interface_rev[4];
 uint8_t vend_spec[11];
};

int ata_version(int ver);

char * ata_op_string(struct ata_cmd *cmd);
char * ata_cmd_string(struct ata_cmd *cmd, char *cmd_string, size_t len);
char * ata_res_string(struct ata_res *res, char *res_string, size_t len);
int ata_command_sbuf(struct ccb_ataio *ataio, struct sbuf *sb);
int ata_status_sbuf(struct ccb_ataio *ataio, struct sbuf *sb);
int ata_res_sbuf(struct ccb_ataio *ataio, struct sbuf *sb);

void ata_print_ident(struct ata_params *ident_data);

uint32_t ata_logical_sector_size(struct ata_params *ident_data);
uint64_t ata_physical_sector_size(struct ata_params *ident_data);
uint64_t ata_logical_sector_offset(struct ata_params *ident_data);

void ata_28bit_cmd(struct ccb_ataio *ataio, uint8_t cmd, uint8_t features,
    uint32_t lba, uint8_t sector_count);
void ata_48bit_cmd(struct ccb_ataio *ataio, uint8_t cmd, uint16_t features,
    uint64_t lba, uint16_t sector_count);
void ata_ncq_cmd(struct ccb_ataio *ataio, uint8_t cmd,
    uint64_t lba, uint16_t sector_count);
void ata_reset_cmd(struct ccb_ataio *ataio);
void ata_pm_read_cmd(struct ccb_ataio *ataio, int reg, int port);
void ata_pm_write_cmd(struct ccb_ataio *ataio, int reg, int port, uint32_t val);

void ata_bswap(int8_t *buf, int len);
void ata_btrim(int8_t *buf, int len);
void ata_bpack(int8_t *src, int8_t *dst, int len);

int ata_max_pmode(struct ata_params *ap);
int ata_max_wmode(struct ata_params *ap);
int ata_max_umode(struct ata_params *ap);
int ata_max_mode(struct ata_params *ap, int maxmode);

char * ata_mode2string(int mode);
int ata_string2mode(char *str);
u_int ata_mode2speed(int mode);
u_int ata_revision2speed(int revision);
int ata_speed2revision(u_int speed);

int ata_identify_match(caddr_t identbuffer, caddr_t table_entry);
int ata_static_identify_match(caddr_t identbuffer, caddr_t table_entry);

void semb_print_ident(struct sep_identify_data *ident_data);

void semb_receive_diagnostic_results(struct ccb_ataio *ataio,
 u_int32_t retries, void (*cbfcnp)(struct cam_periph *, union ccb*),
 uint8_t tag_action, int pcv, uint8_t page_code,
 uint8_t *data_ptr, uint16_t allocation_length, uint32_t timeout);

void semb_send_diagnostic(struct ccb_ataio *ataio,
 u_int32_t retries, void (*cbfcnp)(struct cam_periph *, union ccb *),
 uint8_t tag_action, uint8_t *data_ptr, uint16_t param_list_length,
 uint32_t timeout);

void semb_read_buffer(struct ccb_ataio *ataio,
 u_int32_t retries, void (*cbfcnp)(struct cam_periph *, union ccb*),
 uint8_t tag_action, uint8_t page_code,
 uint8_t *data_ptr, uint16_t allocation_length, uint32_t timeout);

void semb_write_buffer(struct ccb_ataio *ataio,
 u_int32_t retries, void (*cbfcnp)(struct cam_periph *, union ccb *),
 uint8_t tag_action, uint8_t *data_ptr, uint16_t param_list_length,
 uint32_t timeout);
# 44 "/home/jra40/P4/tesla/sys/cam/cam_ccb.h" 2
# 58 "/home/jra40/P4/tesla/sys/cam/cam_ccb.h"
typedef enum {
 CAM_CDB_POINTER = 0x00000001,
 CAM_QUEUE_ENABLE = 0x00000002,
 CAM_CDB_LINKED = 0x00000004,
 CAM_NEGOTIATE = 0x00000008,



 CAM_DATA_ISPHYS = 0x00000010,
 CAM_DIS_AUTOSENSE = 0x00000020,
 CAM_DIR_BOTH = 0x00000000,
 CAM_DIR_IN = 0x00000040,
 CAM_DIR_OUT = 0x00000080,
 CAM_DIR_NONE = 0x000000C0,
 CAM_DIR_MASK = 0x000000C0,
 CAM_DATA_VADDR = 0x00000000,
 CAM_DATA_PADDR = 0x00000010,
 CAM_DATA_SG = 0x00040000,
 CAM_DATA_SG_PADDR = 0x00040010,
 CAM_DATA_BIO = 0x00200000,
 CAM_DATA_MASK = 0x00240010,
 CAM_SOFT_RST_OP = 0x00000100,
 CAM_ENG_SYNC = 0x00000200,
 CAM_DEV_QFRZDIS = 0x00000400,
 CAM_DEV_QFREEZE = 0x00000800,
 CAM_HIGH_POWER = 0x00001000,
 CAM_SENSE_PTR = 0x00002000,
 CAM_SENSE_PHYS = 0x00004000,
 CAM_TAG_ACTION_VALID = 0x00008000,
 CAM_PASS_ERR_RECOVER = 0x00010000,
 CAM_DIS_DISCONNECT = 0x00020000,
 CAM_MSG_BUF_PHYS = 0x00080000,
 CAM_SNS_BUF_PHYS = 0x00100000,
 CAM_CDB_PHYS = 0x00400000,
 CAM_ENG_SGLIST = 0x00800000,


 CAM_DIS_AUTOSRP = 0x01000000,
 CAM_DIS_AUTODISC = 0x02000000,
 CAM_TGT_CCB_AVAIL = 0x04000000,
 CAM_TGT_PHASE_MODE = 0x08000000,
 CAM_MSGB_VALID = 0x10000000,
 CAM_STATUS_VALID = 0x20000000,
 CAM_DATAB_VALID = 0x40000000,


 CAM_SEND_SENSE = 0x08000000,
 CAM_TERM_IO = 0x10000000,
 CAM_DISCONNECT = 0x20000000,
 CAM_SEND_STATUS = 0x40000000
} ccb_flags;


typedef enum {

 XPT_FC_QUEUED = 0x100,

 XPT_FC_USER_CCB = 0x200,
 XPT_FC_XPT_ONLY = 0x400,

 XPT_FC_DEV_QUEUED = 0x800 | XPT_FC_QUEUED,


 XPT_NOOP = 0x00,

 XPT_SCSI_IO = 0x01 | XPT_FC_DEV_QUEUED,

 XPT_GDEV_TYPE = 0x02,

 XPT_GDEVLIST = 0x03,

 XPT_PATH_INQ = 0x04,

 XPT_REL_SIMQ = 0x05,

 XPT_SASYNC_CB = 0x06,

 XPT_SDEV_TYPE = 0x07,

 XPT_SCAN_BUS = 0x08 | XPT_FC_QUEUED | XPT_FC_USER_CCB
           | XPT_FC_XPT_ONLY,

 XPT_DEV_MATCH = 0x09 | XPT_FC_XPT_ONLY,

 XPT_DEBUG = 0x0a,

 XPT_PATH_STATS = 0x0b,

 XPT_GDEV_STATS = 0x0c,

 XPT_DEV_ADVINFO = 0x0e,


 XPT_ABORT = 0x10,

 XPT_RESET_BUS = 0x11 | XPT_FC_XPT_ONLY,

 XPT_RESET_DEV = 0x12 | XPT_FC_DEV_QUEUED,

 XPT_TERM_IO = 0x13,

 XPT_SCAN_LUN = 0x14 | XPT_FC_QUEUED | XPT_FC_USER_CCB
           | XPT_FC_XPT_ONLY,

 XPT_GET_TRAN_SETTINGS = 0x15,




 XPT_SET_TRAN_SETTINGS = 0x16,




 XPT_CALC_GEOMETRY = 0x17,





 XPT_ATA_IO = 0x18 | XPT_FC_DEV_QUEUED,


 XPT_GET_SIM_KNOB = 0x18,




 XPT_SET_SIM_KNOB = 0x19,




 XPT_SMP_IO = 0x1b | XPT_FC_DEV_QUEUED,


 XPT_SCAN_TGT = 0x1E | XPT_FC_QUEUED | XPT_FC_USER_CCB
           | XPT_FC_XPT_ONLY,



 XPT_ENG_INQ = 0x20 | XPT_FC_XPT_ONLY,

 XPT_ENG_EXEC = 0x21 | XPT_FC_DEV_QUEUED,



 XPT_EN_LUN = 0x30,

 XPT_TARGET_IO = 0x31 | XPT_FC_DEV_QUEUED,

 XPT_ACCEPT_TARGET_IO = 0x32 | XPT_FC_QUEUED | XPT_FC_USER_CCB,

 XPT_CONT_TARGET_IO = 0x33 | XPT_FC_DEV_QUEUED,

 XPT_IMMED_NOTIFY = 0x34 | XPT_FC_QUEUED | XPT_FC_USER_CCB,

 XPT_NOTIFY_ACK = 0x35,

 XPT_IMMEDIATE_NOTIFY = 0x36 | XPT_FC_QUEUED | XPT_FC_USER_CCB,

 XPT_NOTIFY_ACKNOWLEDGE = 0x37 | XPT_FC_QUEUED | XPT_FC_USER_CCB,



 XPT_VUNIQUE = 0x80
} xpt_opcode;
# 239 "/home/jra40/P4/tesla/sys/cam/cam_ccb.h"
typedef enum {
 PROTO_UNKNOWN,
 PROTO_UNSPECIFIED,
 PROTO_SCSI,
 PROTO_ATA,
 PROTO_ATAPI,
 PROTO_SATAPM,
 PROTO_SEMB,
} cam_proto;

typedef enum {
 XPORT_UNKNOWN,
 XPORT_UNSPECIFIED,
 XPORT_SPI,
 XPORT_FC,
 XPORT_SSA,
 XPORT_USB,
 XPORT_PPB,
 XPORT_ATA,
 XPORT_SAS,
 XPORT_SATA,
 XPORT_ISCSI,
} cam_xport;
# 276 "/home/jra40/P4/tesla/sys/cam/cam_ccb.h"
typedef union {
 struct { struct ccb_hdr *le_next; struct ccb_hdr **le_prev; } le;
 struct { struct ccb_hdr *sle_next; } sle;
 struct { struct ccb_hdr *tqe_next; struct ccb_hdr **tqe_prev; } tqe;
 struct { struct ccb_hdr *stqe_next; } stqe;
} camq_entry;

typedef union {
 void *ptr;
 u_long field;
 u_int8_t bytes[sizeof(uintptr_t)];
} ccb_priv_entry;

typedef union {
 ccb_priv_entry entries[2];
 u_int8_t bytes[2 * sizeof(ccb_priv_entry)];
} ccb_ppriv_area;

typedef union {
 ccb_priv_entry entries[2];
 u_int8_t bytes[2 * sizeof(ccb_priv_entry)];
} ccb_spriv_area;

struct ccb_hdr {
 cam_pinfo pinfo;
 camq_entry xpt_links;
 camq_entry sim_links;
 camq_entry periph_links;
 u_int32_t retry_count;
 void (*cbfcnp)(struct cam_periph *, union ccb *);

 xpt_opcode func_code;
 u_int32_t status;
 struct cam_path *path;
 path_id_t path_id;
 target_id_t target_id;
 lun_id_t target_lun;
 u_int32_t flags;
 ccb_ppriv_area periph_priv;
 ccb_spriv_area sim_priv;
 u_int32_t timeout;





 struct callout_handle timeout_ch;
};


struct ccb_getdev {
 struct ccb_hdr ccb_h;
 cam_proto protocol;
 struct scsi_inquiry_data inq_data;
 struct ata_params ident_data;
 u_int8_t serial_num[252];
 u_int8_t inq_flags;
 u_int8_t serial_num_len;
};


struct ccb_getdevstats {
 struct ccb_hdr ccb_h;
 int dev_openings;
 int dev_active;
 int devq_openings;
 int devq_queued;
 int held;



 int maxtags;



 int mintags;
 struct timeval last_reset;
};

typedef enum {
 CAM_GDEVLIST_LAST_DEVICE,
 CAM_GDEVLIST_LIST_CHANGED,
 CAM_GDEVLIST_MORE_DEVS,
 CAM_GDEVLIST_ERROR
} ccb_getdevlist_status_e;

struct ccb_getdevlist {
 struct ccb_hdr ccb_h;
 char periph_name[16];
 u_int32_t unit_number;
 unsigned int generation;
 u_int32_t index;
 ccb_getdevlist_status_e status;
};

typedef enum {
 PERIPH_MATCH_NONE = 0x000,
 PERIPH_MATCH_PATH = 0x001,
 PERIPH_MATCH_TARGET = 0x002,
 PERIPH_MATCH_LUN = 0x004,
 PERIPH_MATCH_NAME = 0x008,
 PERIPH_MATCH_UNIT = 0x010,
 PERIPH_MATCH_ANY = 0x01f
} periph_pattern_flags;

struct periph_match_pattern {
 char periph_name[16];
 u_int32_t unit_number;
 path_id_t path_id;
 target_id_t target_id;
 lun_id_t target_lun;
 periph_pattern_flags flags;
};

typedef enum {
 DEV_MATCH_NONE = 0x000,
 DEV_MATCH_PATH = 0x001,
 DEV_MATCH_TARGET = 0x002,
 DEV_MATCH_LUN = 0x004,
 DEV_MATCH_INQUIRY = 0x008,
 DEV_MATCH_DEVID = 0x010,
 DEV_MATCH_ANY = 0x00f
} dev_pattern_flags;

struct device_id_match_pattern {
 uint8_t id_len;
 uint8_t id[256];
};

struct device_match_pattern {
 path_id_t path_id;
 target_id_t target_id;
 lun_id_t target_lun;
 dev_pattern_flags flags;
 union {
  struct scsi_static_inquiry_pattern inq_pat;
  struct device_id_match_pattern devid_pat;
 } data;
};

typedef enum {
 BUS_MATCH_NONE = 0x000,
 BUS_MATCH_PATH = 0x001,
 BUS_MATCH_NAME = 0x002,
 BUS_MATCH_UNIT = 0x004,
 BUS_MATCH_BUS_ID = 0x008,
 BUS_MATCH_ANY = 0x00f
} bus_pattern_flags;

struct bus_match_pattern {
 path_id_t path_id;
 char dev_name[16];
 u_int32_t unit_number;
 u_int32_t bus_id;
 bus_pattern_flags flags;
};

union match_pattern {
 struct periph_match_pattern periph_pattern;
 struct device_match_pattern device_pattern;
 struct bus_match_pattern bus_pattern;
};

typedef enum {
 DEV_MATCH_PERIPH,
 DEV_MATCH_DEVICE,
 DEV_MATCH_BUS
} dev_match_type;

struct dev_match_pattern {
 dev_match_type type;
 union match_pattern pattern;
};

struct periph_match_result {
 char periph_name[16];
 u_int32_t unit_number;
 path_id_t path_id;
 target_id_t target_id;
 lun_id_t target_lun;
};

typedef enum {
 DEV_RESULT_NOFLAG = 0x00,
 DEV_RESULT_UNCONFIGURED = 0x01
} dev_result_flags;

struct device_match_result {
 path_id_t path_id;
 target_id_t target_id;
 lun_id_t target_lun;
 cam_proto protocol;
 struct scsi_inquiry_data inq_data;
 struct ata_params ident_data;
 dev_result_flags flags;
};

struct bus_match_result {
 path_id_t path_id;
 char dev_name[16];
 u_int32_t unit_number;
 u_int32_t bus_id;
};

union match_result {
 struct periph_match_result periph_result;
 struct device_match_result device_result;
 struct bus_match_result bus_result;
};

struct dev_match_result {
 dev_match_type type;
 union match_result result;
};

typedef enum {
 CAM_DEV_MATCH_LAST,
 CAM_DEV_MATCH_MORE,
 CAM_DEV_MATCH_LIST_CHANGED,
 CAM_DEV_MATCH_SIZE_ERROR,
 CAM_DEV_MATCH_ERROR
} ccb_dev_match_status;

typedef enum {
 CAM_DEV_POS_NONE = 0x000,
 CAM_DEV_POS_BUS = 0x001,
 CAM_DEV_POS_TARGET = 0x002,
 CAM_DEV_POS_DEVICE = 0x004,
 CAM_DEV_POS_PERIPH = 0x008,
 CAM_DEV_POS_PDPTR = 0x010,
 CAM_DEV_POS_TYPEMASK = 0xf00,
 CAM_DEV_POS_EDT = 0x100,
 CAM_DEV_POS_PDRV = 0x200
} dev_pos_type;

struct ccb_dm_cookie {
 void *bus;
 void *target;
 void *device;
 void *periph;
 void *pdrv;
};

struct ccb_dev_position {
 u_int generations[4];




 dev_pos_type position_type;
 struct ccb_dm_cookie cookie;
};

struct ccb_dev_match {
 struct ccb_hdr ccb_h;
 ccb_dev_match_status status;
 u_int32_t num_patterns;
 u_int32_t pattern_buf_len;
 struct dev_match_pattern *patterns;
 u_int32_t num_matches;
 u_int32_t match_buf_len;
 struct dev_match_result *matches;
 struct ccb_dev_position pos;
};






typedef enum {
 PI_MDP_ABLE = 0x80,
 PI_WIDE_32 = 0x40,
 PI_WIDE_16 = 0x20,
 PI_SDTR_ABLE = 0x10,
 PI_LINKED_CDB = 0x08,
 PI_SATAPM = 0x04,
 PI_TAG_ABLE = 0x02,
 PI_SOFT_RST = 0x01
} pi_inqflag;

typedef enum {
 PIT_PROCESSOR = 0x80,
 PIT_PHASE = 0x40,
 PIT_DISCONNECT = 0x20,
 PIT_TERM_IO = 0x10,
 PIT_GRP_6 = 0x08,
 PIT_GRP_7 = 0x04
} pi_tmflag;

typedef enum {
 PIM_SCANHILO = 0x80,
 PIM_NOREMOVE = 0x40,
 PIM_NOINITIATOR = 0x20,
 PIM_NOBUSRESET = 0x10,
 PIM_NO_6_BYTE = 0x08,
 PIM_SEQSCAN = 0x04,
 PIM_UNMAPPED = 0x02,
} pi_miscflag;


struct ccb_pathinq_settings_spi {
 u_int8_t ppr_options;
};

struct ccb_pathinq_settings_fc {
 u_int64_t wwnn;
 u_int64_t wwpn;
 u_int32_t port;
 u_int32_t bitrate;
};

struct ccb_pathinq_settings_sas {
 u_int32_t bitrate;
};


struct ccb_pathinq {
 struct ccb_hdr ccb_h;
 u_int8_t version_num;
 u_int8_t hba_inquiry;
 u_int8_t target_sprt;
 u_int8_t hba_misc;
 u_int16_t hba_eng_cnt;

 u_int8_t vuhba_flags[14];
 u_int32_t max_target;
 u_int32_t max_lun;
 u_int32_t async_flags;
 path_id_t hpath_id;
 target_id_t initiator_id;
 char sim_vid[16];
 char hba_vid[16];
 char dev_name[16];
 u_int32_t unit_number;
 u_int32_t bus_id;
 u_int32_t base_transfer_speed;
 cam_proto protocol;
 u_int protocol_version;
 cam_xport transport;
 u_int transport_version;
 union {
  struct ccb_pathinq_settings_spi spi;
  struct ccb_pathinq_settings_fc fc;
  struct ccb_pathinq_settings_sas sas;
  char ccb_pathinq_settings_opaque[128];
 } xport_specific;
 u_int maxio;
 u_int16_t hba_vendor;
 u_int16_t hba_device;
 u_int16_t hba_subvendor;
 u_int16_t hba_subdevice;
};


struct ccb_pathstats {
 struct ccb_hdr ccb_h;
 struct timeval last_reset;
};

typedef enum {
 SMP_FLAG_NONE = 0x00,
 SMP_FLAG_REQ_SG = 0x01,
 SMP_FLAG_RSP_SG = 0x02
} ccb_smp_pass_flags;
# 651 "/home/jra40/P4/tesla/sys/cam/cam_ccb.h"
struct ccb_smpio {
 struct ccb_hdr ccb_h;
 uint8_t *smp_request;
 int smp_request_len;
 uint16_t smp_request_sglist_cnt;
 uint8_t *smp_response;
 int smp_response_len;
 uint16_t smp_response_sglist_cnt;
 ccb_smp_pass_flags flags;
};

typedef union {
 u_int8_t *sense_ptr;




 struct scsi_sense_data sense_buf;
} sense_t;

typedef union {
 u_int8_t *cdb_ptr;

 u_int8_t cdb_bytes[16];
} cdb_t;





struct ccb_scsiio {
 struct ccb_hdr ccb_h;
 union ccb *next_ccb;
 u_int8_t *req_map;
 u_int8_t *data_ptr;
 u_int32_t dxfer_len;

 struct scsi_sense_data sense_data;
 u_int8_t sense_len;
 u_int8_t cdb_len;
 u_int16_t sglist_cnt;
 u_int8_t scsi_status;
 u_int8_t sense_resid;
 u_int32_t resid;
 cdb_t cdb_io;
 u_int8_t *msg_ptr;
 u_int16_t msg_len;
 u_int8_t tag_action;






 u_int tag_id;
 u_int init_id;
};




struct ccb_ataio {
 struct ccb_hdr ccb_h;
 union ccb *next_ccb;
 struct ata_cmd cmd;
 struct ata_res res;
 u_int8_t *data_ptr;
 u_int32_t dxfer_len;
 u_int32_t resid;
 u_int8_t tag_action;






 u_int tag_id;
 u_int init_id;
};

struct ccb_accept_tio {
 struct ccb_hdr ccb_h;
 cdb_t cdb_io;
 u_int8_t cdb_len;
 u_int8_t tag_action;
 u_int8_t sense_len;
 u_int tag_id;
 u_int init_id;
 struct scsi_sense_data sense_data;
};


struct ccb_relsim {
 struct ccb_hdr ccb_h;
 u_int32_t release_flags;




 u_int32_t openings;
 u_int32_t release_timeout;
 u_int32_t qfrozen_cnt;
};




typedef enum {
 AC_UNIT_ATTENTION = 0x4000,
 AC_ADVINFO_CHANGED = 0x2000,
 AC_CONTRACT = 0x1000,
 AC_GETDEV_CHANGED = 0x800,
 AC_INQ_CHANGED = 0x400,
 AC_TRANSFER_NEG = 0x200,
 AC_LOST_DEVICE = 0x100,
 AC_FOUND_DEVICE = 0x080,
 AC_PATH_DEREGISTERED = 0x040,
 AC_PATH_REGISTERED = 0x020,
 AC_SENT_BDR = 0x010,
 AC_SCSI_AEN = 0x008,
 AC_UNSOL_RESEL = 0x002,
 AC_BUS_RESET = 0x001
} ac_code;

typedef void ac_callback_t (void *softc, u_int32_t code,
       struct cam_path *path, void *args);
# 785 "/home/jra40/P4/tesla/sys/cam/cam_ccb.h"
struct ac_contract {
 u_int64_t contract_number;
 u_int8_t contract_data[(128 - sizeof (u_int64_t))];
};


struct ac_device_changed {
 u_int64_t wwpn;
 u_int32_t port;
 target_id_t target;
 u_int8_t arrived;
};


struct ccb_setasync {
 struct ccb_hdr ccb_h;
 u_int32_t event_enable;
 ac_callback_t *callback;
 void *callback_arg;
};


struct ccb_setdev {
 struct ccb_hdr ccb_h;
 u_int8_t dev_type;
};




struct ccb_abort {
 struct ccb_hdr ccb_h;
 union ccb *abort_ccb;
};


struct ccb_resetbus {
 struct ccb_hdr ccb_h;
};


struct ccb_resetdev {
 struct ccb_hdr ccb_h;
};


struct ccb_termio {
 struct ccb_hdr ccb_h;
 union ccb *termio_ccb;
};

typedef enum {
 CTS_TYPE_CURRENT_SETTINGS,
 CTS_TYPE_USER_SETTINGS
} cts_type;

struct ccb_trans_settings_scsi
{
 u_int valid;

 u_int flags;

};

struct ccb_trans_settings_ata
{
 u_int valid;

 u_int flags;

};

struct ccb_trans_settings_spi
{
 u_int valid;





 u_int flags;

 u_int sync_period;
 u_int sync_offset;
 u_int bus_width;
 u_int ppr_options;
};

struct ccb_trans_settings_fc {
 u_int valid;




 u_int64_t wwnn;
 u_int64_t wwpn;
 u_int32_t port;
 u_int32_t bitrate;
};

struct ccb_trans_settings_sas {
 u_int valid;

 u_int32_t bitrate;
};

struct ccb_trans_settings_pata {
 u_int valid;




 int mode;
 u_int bytecount;
 u_int atapi;
 u_int caps;



};

struct ccb_trans_settings_sata {
 u_int valid;







 int mode;
 u_int bytecount;
 int revision;
 u_int pm_present;
 u_int tags;
 u_int atapi;
 u_int caps;
# 930 "/home/jra40/P4/tesla/sys/cam/cam_ccb.h"
};


struct ccb_trans_settings {
 struct ccb_hdr ccb_h;
 cts_type type;
 cam_proto protocol;
 u_int protocol_version;
 cam_xport transport;
 u_int transport_version;
 union {
  u_int valid;
  struct ccb_trans_settings_ata ata;
  struct ccb_trans_settings_scsi scsi;
 } proto_specific;
 union {
  u_int valid;
  struct ccb_trans_settings_spi spi;
  struct ccb_trans_settings_fc fc;
  struct ccb_trans_settings_sas sas;
  struct ccb_trans_settings_pata ata;
  struct ccb_trans_settings_sata sata;
 } xport_specific;
};






struct ccb_calc_geometry {
 struct ccb_hdr ccb_h;
 u_int32_t block_size;
 u_int64_t volume_size;
 u_int32_t cylinders;
 u_int8_t heads;
 u_int8_t secs_per_track;
};
# 982 "/home/jra40/P4/tesla/sys/cam/cam_ccb.h"
struct ccb_sim_knob_settings_spi {
 u_int valid;
 u_int initiator_id;
 u_int role;
};

struct ccb_sim_knob_settings_fc {
 u_int valid;
 u_int64_t wwnn;
 u_int64_t wwpn;
 u_int role;
};

struct ccb_sim_knob_settings_sas {
 u_int valid;
 u_int64_t wwnn;
 u_int role;
};


struct ccb_sim_knob {
 struct ccb_hdr ccb_h;
 union {
  u_int valid;
  struct ccb_sim_knob_settings_spi spi;
  struct ccb_sim_knob_settings_fc fc;
  struct ccb_sim_knob_settings_sas sas;
  char pad[128];
 } xport_specific;
};




struct ccb_rescan {
 struct ccb_hdr ccb_h;
 cam_flags flags;
};




struct ccb_debug {
 struct ccb_hdr ccb_h;
 cam_debug_flags flags;
};



struct ccb_en_lun {
 struct ccb_hdr ccb_h;
 u_int16_t grp6_len;
 u_int16_t grp7_len;
 u_int8_t enable;
};


struct ccb_immed_notify {
 struct ccb_hdr ccb_h;
 struct scsi_sense_data sense_data;
 u_int8_t sense_len;
 u_int8_t initiator_id;
 u_int8_t message_args[7];
};

struct ccb_notify_ack {
 struct ccb_hdr ccb_h;
 u_int16_t seq_id;
 u_int8_t event;
};

struct ccb_immediate_notify {
 struct ccb_hdr ccb_h;
 u_int tag_id;
 u_int seq_id;
 u_int initiator_id;
 u_int arg;
};

struct ccb_notify_acknowledge {
 struct ccb_hdr ccb_h;
 u_int tag_id;
 u_int seq_id;
 u_int initiator_id;
 u_int arg;
};



typedef enum {
 EIT_BUFFER,
 EIT_LOSSLESS,
 EIT_LOSSY,
 EIT_ENCRYPT
} ei_type;

typedef enum {
 EAD_VUNIQUE,
 EAD_LZ1V1,
 EAD_LZ2V1,
 EAD_LZ2V2
} ei_algo;

struct ccb_eng_inq {
 struct ccb_hdr ccb_h;
 u_int16_t eng_num;
 ei_type eng_type;
 ei_algo eng_algo;
 u_int32_t eng_memeory;
};

struct ccb_eng_exec {
 struct ccb_hdr ccb_h;
 u_int8_t *pdrv_ptr;
 u_int8_t *req_map;
 u_int8_t *data_ptr;
 u_int32_t dxfer_len;
 u_int8_t *engdata_ptr;
 u_int16_t sglist_cnt;
 u_int32_t dmax_len;
 u_int32_t dest_len;
 int32_t src_resid;
 u_int32_t timeout;
 u_int16_t eng_num;
 u_int16_t vu_flags;
};
# 1129 "/home/jra40/P4/tesla/sys/cam/cam_ccb.h"
struct ccb_dev_advinfo {
 struct ccb_hdr ccb_h;
 uint32_t flags;

 uint32_t buftype;





 off_t bufsiz;

 off_t provsiz;
 uint8_t *buf;
};







union ccb {
 struct ccb_hdr ccb_h;
 struct ccb_scsiio csio;
 struct ccb_getdev cgd;
 struct ccb_getdevlist cgdl;
 struct ccb_pathinq cpi;
 struct ccb_relsim crs;
 struct ccb_setasync csa;
 struct ccb_setdev csd;
 struct ccb_pathstats cpis;
 struct ccb_getdevstats cgds;
 struct ccb_dev_match cdm;
 struct ccb_trans_settings cts;
 struct ccb_calc_geometry ccg;
 struct ccb_sim_knob knob;
 struct ccb_abort cab;
 struct ccb_resetbus crb;
 struct ccb_resetdev crd;
 struct ccb_termio tio;
 struct ccb_accept_tio atio;
 struct ccb_scsiio ctio;
 struct ccb_en_lun cel;
 struct ccb_immed_notify cin;
 struct ccb_notify_ack cna;
 struct ccb_immediate_notify cin1;
 struct ccb_notify_acknowledge cna2;
 struct ccb_eng_inq cei;
 struct ccb_eng_exec cee;
 struct ccb_smpio smpio;
 struct ccb_rescan crcn;
 struct ccb_debug cdbg;
 struct ccb_ataio ataio;
 struct ccb_dev_advinfo cdai;
};


static __inline void
cam_fill_csio(struct ccb_scsiio *csio, u_int32_t retries,
       void (*cbfcnp)(struct cam_periph *, union ccb *),
       u_int32_t flags, u_int8_t tag_action,
       u_int8_t *data_ptr, u_int32_t dxfer_len,
       u_int8_t sense_len, u_int8_t cdb_len,
       u_int32_t timeout);

static __inline void
cam_fill_ctio(struct ccb_scsiio *csio, u_int32_t retries,
       void (*cbfcnp)(struct cam_periph *, union ccb *),
       u_int32_t flags, u_int tag_action, u_int tag_id,
       u_int init_id, u_int scsi_status, u_int8_t *data_ptr,
       u_int32_t dxfer_len, u_int32_t timeout);

static __inline void
cam_fill_ataio(struct ccb_ataio *ataio, u_int32_t retries,
       void (*cbfcnp)(struct cam_periph *, union ccb *),
       u_int32_t flags, u_int tag_action,
       u_int8_t *data_ptr, u_int32_t dxfer_len,
       u_int32_t timeout);

static __inline void
cam_fill_smpio(struct ccb_smpio *smpio, uint32_t retries,
        void (*cbfcnp)(struct cam_periph *, union ccb *), uint32_t flags,
        uint8_t *smp_request, int smp_request_len,
        uint8_t *smp_response, int smp_response_len,
        uint32_t timeout);

static __inline void
cam_fill_csio(struct ccb_scsiio *csio, u_int32_t retries,
       void (*cbfcnp)(struct cam_periph *, union ccb *),
       u_int32_t flags, u_int8_t tag_action,
       u_int8_t *data_ptr, u_int32_t dxfer_len,
       u_int8_t sense_len, u_int8_t cdb_len,
       u_int32_t timeout)
{
 csio->ccb_h.func_code = XPT_SCSI_IO;
 csio->ccb_h.flags = flags;
 csio->ccb_h.retry_count = retries;
 csio->ccb_h.cbfcnp = cbfcnp;
 csio->ccb_h.timeout = timeout;
 csio->data_ptr = data_ptr;
 csio->dxfer_len = dxfer_len;
 csio->sense_len = sense_len;
 csio->cdb_len = cdb_len;
 csio->tag_action = tag_action;
}

static __inline void
cam_fill_ctio(struct ccb_scsiio *csio, u_int32_t retries,
       void (*cbfcnp)(struct cam_periph *, union ccb *),
       u_int32_t flags, u_int tag_action, u_int tag_id,
       u_int init_id, u_int scsi_status, u_int8_t *data_ptr,
       u_int32_t dxfer_len, u_int32_t timeout)
{
 csio->ccb_h.func_code = XPT_CONT_TARGET_IO;
 csio->ccb_h.flags = flags;
 csio->ccb_h.retry_count = retries;
 csio->ccb_h.cbfcnp = cbfcnp;
 csio->ccb_h.timeout = timeout;
 csio->data_ptr = data_ptr;
 csio->dxfer_len = dxfer_len;
 csio->scsi_status = scsi_status;
 csio->tag_action = tag_action;
 csio->tag_id = tag_id;
 csio->init_id = init_id;
}

static __inline void
cam_fill_ataio(struct ccb_ataio *ataio, u_int32_t retries,
       void (*cbfcnp)(struct cam_periph *, union ccb *),
       u_int32_t flags, u_int tag_action,
       u_int8_t *data_ptr, u_int32_t dxfer_len,
       u_int32_t timeout)
{
 ataio->ccb_h.func_code = XPT_ATA_IO;
 ataio->ccb_h.flags = flags;
 ataio->ccb_h.retry_count = retries;
 ataio->ccb_h.cbfcnp = cbfcnp;
 ataio->ccb_h.timeout = timeout;
 ataio->data_ptr = data_ptr;
 ataio->dxfer_len = dxfer_len;
 ataio->tag_action = tag_action;
}

static __inline void
cam_fill_smpio(struct ccb_smpio *smpio, uint32_t retries,
        void (*cbfcnp)(struct cam_periph *, union ccb *), uint32_t flags,
        uint8_t *smp_request, int smp_request_len,
        uint8_t *smp_response, int smp_response_len,
        uint32_t timeout)
{

 do { if (__builtin_expect((!((flags & CAM_DIR_MASK) == CAM_DIR_BOTH)), 0)) kassert_panic ("direction != CAM_DIR_BOTH"); } while (0);

 do { if (__builtin_expect((!((smp_request != ((void *)0)) && (smp_response != ((void *)0)))), 0)) kassert_panic ("need valid request and response buffers"); } while (0);

 do { if (__builtin_expect((!((smp_request_len != 0) && (smp_response_len != 0))), 0)) kassert_panic ("need non-zero request and response lengths"); } while (0);


 smpio->ccb_h.func_code = XPT_SMP_IO;
 smpio->ccb_h.flags = flags;
 smpio->ccb_h.retry_count = retries;
 smpio->ccb_h.cbfcnp = cbfcnp;
 smpio->ccb_h.timeout = timeout;
 smpio->smp_request = smp_request;
 smpio->smp_request_len = smp_request_len;
 smpio->smp_response = smp_response;
 smpio->smp_response_len = smp_response_len;
}

void cam_calc_geometry(struct ccb_calc_geometry *ccg, int extended);
# 46 "/home/jra40/P4/tesla/sys/cam/cam.c" 2

# 1 "/home/jra40/P4/tesla/sys/cam/scsi/smp_all.h" 1
# 129 "/home/jra40/P4/tesla/sys/cam/scsi/smp_all.h"
struct smp_report_general_request
{
 uint8_t frame_type;
 uint8_t function;
 uint8_t response_len;
 uint8_t request_len;
 uint8_t crc[4];
};

struct smp_report_general_response
{
 uint8_t frame_type;
 uint8_t function;
 uint8_t function_result;
 uint8_t response_len;

 uint8_t expander_change_count[2];
 uint8_t expander_route_indexes[2];
 uint8_t long_response;

 uint8_t num_phys;
 uint8_t config_bits0;
# 159 "/home/jra40/P4/tesla/sys/cam/scsi/smp_all.h"
 uint8_t reserved0;
 uint8_t encl_logical_id[8];
 uint8_t reserved1[8];
 uint8_t reserved2[2];
 uint8_t stp_bus_inact_time_limit[2];
 uint8_t stp_max_conn_time_limit[2];
 uint8_t stp_smp_it_nexus_loss_time[2];
 uint8_t config_bits1;







 uint8_t config_bits2;





 uint8_t max_num_routed_addrs[2];
 uint8_t active_zm_address[8];
 uint8_t zone_lock_inact_time_limit[2];
 uint8_t reserved3[2];
 uint8_t reserved4;
 uint8_t first_encl_conn_el_index;
 uint8_t num_encl_conn_el_indexes;
 uint8_t reserved5;
 uint8_t reduced_functionality;

 uint8_t time_to_reduced_func;
 uint8_t initial_time_to_reduced_func;
 uint8_t max_reduced_func_time;
 uint8_t last_sc_stat_desc_index[2];
 uint8_t max_sc_stat_descs[2];
 uint8_t last_phy_evl_desc_index[2];
 uint8_t max_stored_pel_descs[2];
 uint8_t stp_reject_to_open_limit[2];
 uint8_t reserved6[2];
 uint8_t crc[4];
};





struct smp_report_manuf_info_request
{
 uint8_t frame_type;
 uint8_t function;
 uint8_t response_len;
 uint8_t request_len;

 uint8_t crc[4];
};

struct smp_report_manuf_info_response
{
 uint8_t frame_type;
 uint8_t function;
 uint8_t function_result;
 uint8_t response_len;

 uint8_t expander_change_count[2];
 uint8_t reserved0[2];
 uint8_t sas_11_format;

 uint8_t reserved1[3];
 uint8_t vendor[8];
 uint8_t product[16];
 uint8_t revision[4];
 uint8_t comp_vendor[8];
 uint8_t comp_id[2];
 uint8_t comp_revision;
 uint8_t reserved2;
 uint8_t vendor_specific[8];
 uint8_t crc[4];
};




struct smp_discover_request
{
 uint8_t frame_type;
 uint8_t function;
 uint8_t response_len;
 uint8_t request_len;

 uint8_t reserved0[4];
 uint8_t ignore_zone_group;

 uint8_t phy;
 uint8_t reserved1[2];
 uint8_t crc[4];
};

struct smp_discover_response
{
 uint8_t frame_type;
 uint8_t function;
 uint8_t function_result;
 uint8_t response_len;

 uint8_t expander_change_count[2];
 uint8_t reserved0[3];
 uint8_t phy;
 uint8_t reserved1[2];
 uint8_t attached_device;






 uint8_t neg_logical_link_rate;
# 286 "/home/jra40/P4/tesla/sys/cam/scsi/smp_all.h"
 uint8_t config_bits0;




 uint8_t config_bits1;






 uint8_t sas_address[8];
 uint8_t attached_sas_address[8];
 uint8_t attached_phy_id;
 uint8_t config_bits2;





 uint8_t reserved2[6];
 uint8_t link_rate0;



 uint8_t link_rate1;



 uint8_t phy_change_count;
 uint8_t pp_timeout;


 uint8_t routing_attr;
 uint8_t conn_type;
 uint8_t conn_el_index;
 uint8_t conn_phys_link;
 uint8_t config_bits3;






 uint8_t config_bits4;




 uint8_t vendor_spec[2];
 uint8_t attached_dev_name[8];
 uint8_t config_bits5;






 uint8_t reserved3[2];
 uint8_t zone_group;
 uint8_t self_config_status;
 uint8_t self_config_levels_comp;
 uint8_t reserved4[2];
 uint8_t self_config_sas_addr[8];
 uint8_t prog_phy_cap[4];
 uint8_t current_phy_cap[4];
 uint8_t attached_phy_cap[4];
 uint8_t reserved5[6];
 uint8_t neg_phys_link_rate;



 uint8_t config_bits6;



 uint8_t config_bits7;




 uint8_t reserved6;
 uint8_t reserved7;
 uint8_t default_zone_group;
 uint8_t config_bits8;




 uint8_t reserved8;
 uint8_t reserved9;
 uint8_t saved_zone_group;
 uint8_t config_bits9;



 uint8_t reserved10;
 uint8_t reserved11;
 uint8_t shadow_zone_group;
 uint8_t device_slot_num;
 uint8_t device_slot_group_num;
 uint8_t device_slot_group_out_conn[6];
 uint8_t stp_buffer_size[2];
 uint8_t reserved12;
 uint8_t reserved13;
 uint8_t crc[4];
};




struct smp_phy_control_request
{
 uint8_t frame_type;
 uint8_t function;
 uint8_t response_len;

 uint8_t request_len;

 uint8_t expected_exp_chg_cnt[2];
 uint8_t reserved0[3];
 uint8_t phy;
 uint8_t phy_operation;
# 419 "/home/jra40/P4/tesla/sys/cam/scsi/smp_all.h"
 uint8_t update_pp_timeout;

 uint8_t reserved1[12];
 uint8_t attached_device_name[8];
 uint8_t prog_min_phys_link_rate;


 uint8_t prog_max_phys_link_rate;


 uint8_t config_bits0;
# 453 "/home/jra40/P4/tesla/sys/cam/scsi/smp_all.h"
 uint8_t reserved2;
 uint8_t pp_timeout_value;

 uint8_t reserved3[3];
 uint8_t crc[4];
};

struct smp_phy_control_response
{
 uint8_t frame_type;
 uint8_t function;
 uint8_t function_result;
 uint8_t response_len;

 uint8_t crc[4];
};



const char *smp_error_desc(int function_result);
const char *smp_command_desc(uint8_t cmd_num);
void smp_command_decode(uint8_t *smp_request, int request_len, struct sbuf *sb,
   char *line_prefix, int first_line_len, int line_len);
void smp_command_sbuf(struct ccb_smpio *smpio, struct sbuf *sb,
        char *line_prefix, int first_line_len, int line_len);


void smp_error_sbuf(struct ccb_smpio *smpio, struct sbuf *sb);





void smp_report_general_sbuf(struct smp_report_general_response *response,
        int response_len, struct sbuf *sb);

void smp_report_manuf_info_sbuf(struct smp_report_manuf_info_response *response,
    int response_len, struct sbuf *sb);

void smp_report_general(struct ccb_smpio *smpio, uint32_t retries,
   void (*cbfcnp)(struct cam_periph *, union ccb *),
   struct smp_report_general_request *request,
   int request_len, uint8_t *response, int response_len,
   int long_response, uint32_t timeout);

void smp_discover(struct ccb_smpio *smpio, uint32_t retries,
    void (*cbfcnp)(struct cam_periph *, union ccb *),
    struct smp_discover_request *request, int request_len,
    uint8_t *response, int response_len, int long_response,
    int ignore_zone_group, int phy, uint32_t timeout);

void smp_report_manuf_info(struct ccb_smpio *smpio, uint32_t retries,
      void (*cbfcnp)(struct cam_periph *, union ccb *),
      struct smp_report_manuf_info_request *request,
      int request_len, uint8_t *response, int response_len,
      int long_response, uint32_t timeout);

void smp_phy_control(struct ccb_smpio *smpio, uint32_t retries,
       void (*cbfcnp)(struct cam_periph *, union ccb *),
       struct smp_phy_control_request *request, int request_len,
       uint8_t *response, int response_len, int long_response,
       uint32_t expected_exp_change_count, int phy, int phy_op,
       int update_pp_timeout_val, uint64_t attached_device_name,
       int prog_min_prl, int prog_max_prl, int slumber_partial,
       int pp_timeout_value, uint32_t timeout);
# 48 "/home/jra40/P4/tesla/sys/cam/cam.c" 2
# 1 "/home/jra40/P4/tesla/sys/sys/sbuf.h" 1
# 36 "/home/jra40/P4/tesla/sys/sys/sbuf.h"
struct sbuf;
typedef int (sbuf_drain_func)(void *, const char *, int);




struct sbuf {
 char *s_buf;
 sbuf_drain_func *s_drain_func;
 void *s_drain_arg;
 int s_error;
 ssize_t s_size;
 ssize_t s_len;







 int s_flags;
 ssize_t s_sect_len;
};





struct sbuf *sbuf_new(struct sbuf *, char *, int, int);


void sbuf_clear(struct sbuf *);
int sbuf_setpos(struct sbuf *, ssize_t);
int sbuf_bcat(struct sbuf *, const void *, size_t);
int sbuf_bcpy(struct sbuf *, const void *, size_t);
int sbuf_cat(struct sbuf *, const char *);
int sbuf_cpy(struct sbuf *, const char *);
int sbuf_printf(struct sbuf *, const char *, ...)
 __attribute__((__format__ (__printf__, 2, 3)));
int sbuf_vprintf(struct sbuf *, const char *, __va_list)
 __attribute__((__format__ (__printf__, 2, 0)));
int sbuf_putc(struct sbuf *, int);
void sbuf_set_drain(struct sbuf *, sbuf_drain_func *, void *);
int sbuf_trim(struct sbuf *);
int sbuf_error(const struct sbuf *);
int sbuf_finish(struct sbuf *);
char *sbuf_data(struct sbuf *);
ssize_t sbuf_len(struct sbuf *);
int sbuf_done(const struct sbuf *);
void sbuf_delete(struct sbuf *);
void sbuf_start_section(struct sbuf *, ssize_t *);
ssize_t sbuf_end_section(struct sbuf *, ssize_t, size_t, int);


struct uio;
struct sbuf *sbuf_uionew(struct sbuf *, struct uio *, int *);
int sbuf_bcopyin(struct sbuf *, const void *, size_t);
int sbuf_copyin(struct sbuf *, const void *, size_t);
# 49 "/home/jra40/P4/tesla/sys/cam/cam.c" 2



# 1 "/home/jra40/P4/tesla/sys/cam/cam_queue.h" 1
# 46 "/home/jra40/P4/tesla/sys/cam/cam_queue.h"
struct camq {
 cam_pinfo **queue_array;
 int array_size;
 int entries;
 u_int32_t generation;
 u_int32_t qfrozen_cnt;
};

struct ccb_hdr_tailq { struct ccb_hdr *tqh_first; struct ccb_hdr **tqh_last; };
struct ccb_hdr_list { struct ccb_hdr *lh_first; };
struct ccb_hdr_slist { struct ccb_hdr *slh_first; };

struct cam_ccbq {
 struct camq queue;
 int devq_openings;
 int devq_allocating;
 int dev_openings;
 int dev_active;
 int held;
};

struct cam_ed;

struct cam_devq {
 struct camq send_queue;
 int send_openings;
 int send_active;
};


struct cam_devq *cam_devq_alloc(int devices, int openings);

int cam_devq_init(struct cam_devq *devq, int devices,
          int openings);

void cam_devq_free(struct cam_devq *devq);

u_int32_t cam_devq_resize(struct cam_devq *camq, int openings);




struct cam_ccbq *cam_ccbq_alloc(int openings);

u_int32_t cam_ccbq_resize(struct cam_ccbq *ccbq, int devices);

int cam_ccbq_init(struct cam_ccbq *ccbq, int openings);

void cam_ccbq_free(struct cam_ccbq *ccbq);

void cam_ccbq_fini(struct cam_ccbq *ccbq);




struct camq *camq_alloc(int size);




u_int32_t camq_resize(struct camq *queue, int new_size);




int camq_init(struct camq *camq, int size);






void camq_free(struct camq *queue);




void camq_fini(struct camq *queue);





void camq_insert(struct camq *queue, cam_pinfo *new_entry);





cam_pinfo *camq_remove(struct camq *queue, int index);
# 149 "/home/jra40/P4/tesla/sys/cam/cam_queue.h"
void camq_change_priority(struct camq *queue, int index,
         u_int32_t new_priority);

static __inline int
cam_ccbq_pending_ccb_count(struct cam_ccbq *ccbq);

static __inline void
cam_ccbq_take_opening(struct cam_ccbq *ccbq);

static __inline void
cam_ccbq_insert_ccb(struct cam_ccbq *ccbq, union ccb *new_ccb);

static __inline void
cam_ccbq_remove_ccb(struct cam_ccbq *ccbq, union ccb *ccb);

static __inline union ccb *
cam_ccbq_peek_ccb(struct cam_ccbq *ccbq, int index);

static __inline void
cam_ccbq_send_ccb(struct cam_ccbq *queue, union ccb *send_ccb);

static __inline void
cam_ccbq_ccb_done(struct cam_ccbq *ccbq, union ccb *done_ccb);

static __inline void
cam_ccbq_release_opening(struct cam_ccbq *ccbq);


static __inline int
cam_ccbq_pending_ccb_count(struct cam_ccbq *ccbq)
{
 return (ccbq->queue.entries);
}

static __inline void
cam_ccbq_take_opening(struct cam_ccbq *ccbq)
{
 ccbq->devq_openings--;
 ccbq->held++;
}

static __inline void
cam_ccbq_insert_ccb(struct cam_ccbq *ccbq, union ccb *new_ccb)
{
 ccbq->held--;
 camq_insert(&ccbq->queue, &new_ccb->ccb_h.pinfo);
}

static __inline void
cam_ccbq_remove_ccb(struct cam_ccbq *ccbq, union ccb *ccb)
{
 camq_remove(&ccbq->queue, ccb->ccb_h.pinfo.index);
}

static __inline union ccb *
cam_ccbq_peek_ccb(struct cam_ccbq *ccbq, int index)
{
 return((union ccb *)ccbq->queue.queue_array[index]);
}

static __inline void
cam_ccbq_send_ccb(struct cam_ccbq *ccbq, union ccb *send_ccb)
{

 send_ccb->ccb_h.pinfo.index = -2;
 ccbq->dev_active++;
 ccbq->dev_openings--;
}

static __inline void
cam_ccbq_ccb_done(struct cam_ccbq *ccbq, union ccb *done_ccb)
{

 ccbq->dev_active--;
 ccbq->dev_openings++;
 ccbq->held++;
}

static __inline void
cam_ccbq_release_opening(struct cam_ccbq *ccbq)
{
 ccbq->held--;
 ccbq->devq_openings++;
}
# 53 "/home/jra40/P4/tesla/sys/cam/cam.c" 2
# 1 "/home/jra40/P4/tesla/sys/cam/cam_xpt.h" 1
# 36 "/home/jra40/P4/tesla/sys/cam/cam_xpt.h"
union ccb;
struct cam_periph;
struct cam_sim;






struct cam_path;
# 55 "/home/jra40/P4/tesla/sys/cam/cam_xpt.h"
struct async_node {
 struct { struct async_node *sle_next; } links;
 u_int32_t event_enable;
 void (*callback)(void *arg, u_int32_t code,
        struct cam_path *path, void *args);
 void *callback_arg;
};

struct async_list { struct async_node *slh_first; };
struct periph_list { struct cam_periph *slh_first; };

void xpt_action(union ccb *new_ccb);
void xpt_action_default(union ccb *new_ccb);
union ccb *xpt_alloc_ccb(void);
union ccb *xpt_alloc_ccb_nowait(void);
void xpt_free_ccb(union ccb *free_ccb);
void xpt_setup_ccb(struct ccb_hdr *ccb_h,
          struct cam_path *path,
          u_int32_t priority);
void xpt_merge_ccb(union ccb *master_ccb,
          union ccb *slave_ccb);
cam_status xpt_create_path(struct cam_path **new_path_ptr,
     struct cam_periph *perph,
     path_id_t path_id,
     target_id_t target_id, lun_id_t lun_id);
cam_status xpt_create_path_unlocked(struct cam_path **new_path_ptr,
     struct cam_periph *perph,
     path_id_t path_id,
     target_id_t target_id, lun_id_t lun_id);
int xpt_getattr(char *buf, size_t len, const char *attr,
        struct cam_path *path);
void xpt_free_path(struct cam_path *path);
void xpt_path_counts(struct cam_path *path, uint32_t *bus_ref,
     uint32_t *periph_ref, uint32_t *target_ref,
     uint32_t *device_ref);
int xpt_path_comp(struct cam_path *path1,
          struct cam_path *path2);
void xpt_print_path(struct cam_path *path);
void xpt_print(struct cam_path *path, const char *fmt, ...);
int xpt_path_string(struct cam_path *path, char *str,
     size_t str_len);
path_id_t xpt_path_path_id(struct cam_path *path);
target_id_t xpt_path_target_id(struct cam_path *path);
lun_id_t xpt_path_lun_id(struct cam_path *path);
int xpt_path_legacy_ata_id(struct cam_path *path);
struct cam_sim *xpt_path_sim(struct cam_path *path);
struct cam_periph *xpt_path_periph(struct cam_path *path);
void xpt_async(u_int32_t async_code, struct cam_path *path,
      void *async_arg);
void xpt_rescan(union ccb *ccb);
void xpt_hold_boot(void);
void xpt_release_boot(void);
void xpt_lock_buses(void);
void xpt_unlock_buses(void);
cam_status xpt_register_async(int event, ac_callback_t *cbfunc,
        void *cbarg, struct cam_path *path);
cam_status xpt_compile_path(struct cam_path *new_path,
      struct cam_periph *perph,
      path_id_t path_id,
      target_id_t target_id,
      lun_id_t lun_id);

void xpt_release_path(struct cam_path *path);
# 54 "/home/jra40/P4/tesla/sys/cam/cam.c" 2

; static struct sysctl_oid sysctl___kern_features_scbus = { &sysctl__kern_features_children, { ((void *)0) }, (-1), 2 | 0x00040000 | (0x80000000 | 0x00008000), 0, 1, "scbus", sysctl_handle_int, "I", 0, 0, "SCSI devices support" }; __asm__(".globl " "__start_set_sysctl_set"); __asm__(".globl " "__stop_set_sysctl_set"); static void const * const __set_sysctl_set_sym_sysctl___kern_features_scbus __attribute__((__section__("set_" "sysctl_set"))) __attribute__((__used__)) = &sysctl___kern_features_scbus;



static int camstatusentrycomp(const void *key, const void *member);

const struct cam_status_entry cam_status_table[] = {
 { CAM_REQ_INPROG, "CCB request is in progress" },
 { CAM_REQ_CMP, "CCB request completed without error" },
 { CAM_REQ_ABORTED, "CCB request aborted by the host" },
 { CAM_UA_ABORT, "Unable to abort CCB request" },
 { CAM_REQ_CMP_ERR, "CCB request completed with an error" },
 { CAM_BUSY, "CAM subsystem is busy" },
 { CAM_REQ_INVALID, "CCB request was invalid" },
 { CAM_PATH_INVALID, "Supplied Path ID is invalid" },
 { CAM_DEV_NOT_THERE, "Device Not Present" },
 { CAM_UA_TERMIO, "Unable to terminate I/O CCB request" },
 { CAM_SEL_TIMEOUT, "Selection Timeout" },
 { CAM_CMD_TIMEOUT, "Command timeout" },
 { CAM_SCSI_STATUS_ERROR, "SCSI Status Error" },
 { CAM_MSG_REJECT_REC, "Message Reject Reveived" },
 { CAM_SCSI_BUS_RESET, "SCSI Bus Reset Sent/Received" },
 { CAM_UNCOR_PARITY, "Uncorrectable parity/CRC error" },
 { CAM_AUTOSENSE_FAIL, "Auto-Sense Retrieval Failed" },
 { CAM_NO_HBA, "No HBA Detected" },
 { CAM_DATA_RUN_ERR, "Data Overrun error" },
 { CAM_UNEXP_BUSFREE, "Unexpected Bus Free" },
 { CAM_SEQUENCE_FAIL, "Target Bus Phase Sequence Failure" },
 { CAM_CCB_LEN_ERR, "CCB length supplied is inadequate" },
 { CAM_PROVIDE_FAIL, "Unable to provide requested capability" },
 { CAM_BDR_SENT, "SCSI BDR Message Sent" },
 { CAM_REQ_TERMIO, "CCB request terminated by the host" },
 { CAM_UNREC_HBA_ERROR, "Unrecoverable Host Bus Adapter Error" },
 { CAM_REQ_TOO_BIG, "The request was too large for this host" },
 { CAM_REQUEUE_REQ, "Unconditionally Re-queue Request", },
 { CAM_ATA_STATUS_ERROR, "ATA Status Error" },
 { CAM_SCSI_IT_NEXUS_LOST,"Initiator/Target Nexus Lost" },
 { CAM_SMP_STATUS_ERROR, "SMP Status Error" },
 { CAM_IDE, "Initiator Detected Error Message Received" },
 { CAM_RESRC_UNAVAIL, "Resource Unavailable" },
 { CAM_UNACKED_EVENT, "Unacknowledged Event by Host" },
 { CAM_MESSAGE_RECV, "Message Received in Host Target Mode" },
 { CAM_INVALID_CDB, "Invalid CDB received in Host Target Mode" },
 { CAM_LUN_INVALID, "Invalid Lun" },
 { CAM_TID_INVALID, "Invalid Target ID" },
 { CAM_FUNC_NOTAVAIL, "Function Not Available" },
 { CAM_NO_NEXUS, "Nexus Not Established" },
 { CAM_IID_INVALID, "Invalid Initiator ID" },
 { CAM_CDB_RECVD, "CDB Received" },
 { CAM_LUN_ALRDY_ENA, "LUN Already Enabled for Target Mode" },
 { CAM_SCSI_BUSY, "SCSI Bus Busy" },
};

const int num_cam_status_entries =
    sizeof(cam_status_table)/sizeof(*cam_status_table);


struct sysctl_oid_list sysctl__kern_cam_children; static struct sysctl_oid sysctl___kern_cam = { &sysctl__kern_children, { ((void *)0) }, (-1), 1|(0x80000000), (void*)&sysctl__kern_cam_children, 0, "cam", 0, "N", 0, 0, "CAM Subsystem" }; __asm__(".globl " "__start_set_sysctl_set"); __asm__(".globl " "__stop_set_sysctl_set"); static void const * const __set_sysctl_set_sym_sysctl___kern_cam __attribute__((__section__("set_" "sysctl_set"))) __attribute__((__used__)) = &sysctl___kern_cam;





int cam_sort_io_queues = 1;
static struct tunable_int __tunable_int_119 = { ("kern.cam.sort_io_queues"), (&cam_sort_io_queues), }; static struct sysinit __Tunable_init_119_sys_init = { SI_SUB_TUNABLES, SI_ORDER_MIDDLE, (sysinit_cfunc_t)(sysinit_nfunc_t)tunable_int_init, ((void *)(&__tunable_int_119)) }; __asm__(".globl " "__start_set_sysinit_set"); __asm__(".globl " "__stop_set_sysinit_set"); static void const * const __set_sysinit_set_sym___Tunable_init_119_sys_init __attribute__((__section__("set_" "sysinit_set"))) __attribute__((__used__)) = &__Tunable_init_119_sys_init;
; static struct sysctl_oid sysctl___kern_cam_sort_io_queues = { &sysctl__kern_cam_children, { ((void *)0) }, (-1), 2 | 0x00040000 | (((0x80000000|0x40000000)|0x00080000)), &cam_sort_io_queues, 0, "sort_io_queues", sysctl_handle_int, "I", 0, 0, "Sort IO queues to try and optimise disk access patterns" }; __asm__(".globl " "__start_set_sysctl_set"); __asm__(".globl " "__stop_set_sysctl_set"); static void const * const __set_sysctl_set_sym_sysctl___kern_cam_sort_io_queues __attribute__((__section__("set_" "sysctl_set"))) __attribute__((__used__)) = &sysctl___kern_cam_sort_io_queues;



void
cam_strvis(u_int8_t *dst, const u_int8_t *src, int srclen, int dstlen)
{


 while (srclen > 0 && src[0] == ' ')
  src++, srclen--;
 while (srclen > 0
     && (src[srclen-1] == ' ' || src[srclen-1] == '\0'))
  srclen--;

 while (srclen > 0 && dstlen > 1) {
  u_int8_t *cur_pos = dst;

  if (*src < 0x20 || *src >= 0x80) {


   if (dstlen > 4) {
    *cur_pos++ = '\\';
    *cur_pos++ = ((*src & 0300) >> 6) + '0';
    *cur_pos++ = ((*src & 0070) >> 3) + '0';
    *cur_pos++ = ((*src & 0007) >> 0) + '0';
   } else {
    *cur_pos++ = '?';
   }
  } else {

   *cur_pos++ = *src;
  }
  src++;
  srclen--;
  dstlen -= cur_pos - dst;
  dst = cur_pos;
 }
 *dst = '\0';
}







int
cam_strmatch(const u_int8_t *str, const u_int8_t *pattern, int str_len)
{

 while (*pattern != '\0'&& str_len > 0) {

  if (*pattern == '*') {
   return (0);
  }
  if ((*pattern != *str)
   && (*pattern != '?' || *str == ' ')) {
   return (1);
  }
  pattern++;
  str++;
  str_len--;
 }
 while (str_len > 0 && *str == ' ') {
  str++;
  str_len--;
 }
 if (str_len > 0 && *str == 0)
  str_len = 0;

 return (str_len);
}

caddr_t
cam_quirkmatch(caddr_t target, caddr_t quirk_table, int num_entries,
        int entry_size, cam_quirkmatch_t *comp_func)
{
 for (; num_entries > 0; num_entries--, quirk_table += entry_size) {
  if ((*comp_func)(target, quirk_table) == 0)
   return (quirk_table);
 }
 return (((void *)0));
}

const struct cam_status_entry*
cam_fetch_status_entry(cam_status status)
{
 status &= CAM_STATUS_MASK;
 return (bsearch(&status, &cam_status_table,
   num_cam_status_entries,
   sizeof(*cam_status_table),
   camstatusentrycomp));
}

static int
camstatusentrycomp(const void *key, const void *member)
{
 cam_status status;
 const struct cam_status_entry *table_entry;

 status = *(const cam_status *)key;
 table_entry = (const struct cam_status_entry *)member;

 return (status - table_entry->status_code);
}



char *
cam_error_string(union ccb *ccb, char *str, int str_len,
   cam_error_string_flags flags,
   cam_error_proto_flags proto_flags)






{
 char path_str[64];
 struct sbuf sb;

 if ((ccb == ((void *)0))
  || (str == ((void *)0))
  || (str_len <= 0))
  return(((void *)0));

 if (flags == CAM_ESF_NONE)
  return(((void *)0));

 switch (ccb->ccb_h.func_code) {
  case XPT_ATA_IO:
   switch (proto_flags & CAM_EPF_LEVEL_MASK) {
   case CAM_EPF_NONE:
    break;
   case CAM_EPF_ALL:
   case CAM_EPF_NORMAL:
    proto_flags |= CAM_EAF_PRINT_RESULT;

   case CAM_EPF_MINIMAL:
    proto_flags |= CAM_EAF_PRINT_STATUS;

   default:
    break;
   }
   break;
  case XPT_SCSI_IO:
   switch (proto_flags & CAM_EPF_LEVEL_MASK) {
   case CAM_EPF_NONE:
    break;
   case CAM_EPF_ALL:
   case CAM_EPF_NORMAL:
    proto_flags |= CAM_ESF_PRINT_SENSE;

   case CAM_EPF_MINIMAL:
    proto_flags |= CAM_ESF_PRINT_STATUS;

   default:
    break;
   }
   break;
  case XPT_SMP_IO:
   switch (proto_flags & CAM_EPF_LEVEL_MASK) {
   case CAM_EPF_NONE:
    break;
   case CAM_EPF_ALL:
    proto_flags |= CAM_ESMF_PRINT_FULL_CMD;

   case CAM_EPF_NORMAL:
   case CAM_EPF_MINIMAL:
    proto_flags |= CAM_ESMF_PRINT_STATUS;

   default:
    break;
   }
   break;
  default:
   break;
 }

 xpt_path_string(ccb->csio.ccb_h.path, path_str, sizeof(path_str));




 sbuf_new(&sb, str, str_len, 0);

 if (flags & CAM_ESF_COMMAND) {
  sbuf_cat(&sb, path_str);
  switch (ccb->ccb_h.func_code) {
  case XPT_ATA_IO:
   ata_command_sbuf(&ccb->ataio, &sb);
   sbuf_printf(&sb, "\n");
   break;
  case XPT_SCSI_IO:

   scsi_command_string(&ccb->csio, &sb);



   sbuf_printf(&sb, "\n");
   break;
  case XPT_SMP_IO:
   smp_command_sbuf(&ccb->smpio, &sb, path_str, 79 -
      strlen(path_str), (proto_flags &
      CAM_ESMF_PRINT_FULL_CMD) ? 79 : 0);
   sbuf_printf(&sb, "\n");
   break;
  default:
   break;
  }
 }

 if (flags & CAM_ESF_CAM_STATUS) {
  cam_status status;
  const struct cam_status_entry *entry;

  sbuf_cat(&sb, path_str);

  status = ccb->ccb_h.status & CAM_STATUS_MASK;

  entry = cam_fetch_status_entry(status);

  if (entry == ((void *)0))
   sbuf_printf(&sb, "CAM status: Unknown (%#x)\n",
        ccb->ccb_h.status);
  else
   sbuf_printf(&sb, "CAM status: %s\n",
        entry->status_text);
 }

 if (flags & CAM_ESF_PROTO_STATUS) {

  switch (ccb->ccb_h.func_code) {
  case XPT_ATA_IO:
   if ((ccb->ccb_h.status & CAM_STATUS_MASK) !=
        CAM_ATA_STATUS_ERROR)
    break;
   if (proto_flags & CAM_EAF_PRINT_STATUS) {
    sbuf_cat(&sb, path_str);
    ata_status_sbuf(&ccb->ataio, &sb);
    sbuf_printf(&sb, "\n");
   }
   if (proto_flags & CAM_EAF_PRINT_RESULT) {
    sbuf_cat(&sb, path_str);
    ata_res_sbuf(&ccb->ataio, &sb);
    sbuf_printf(&sb, "\n");
   }

   break;
  case XPT_SCSI_IO:
   if ((ccb->ccb_h.status & CAM_STATUS_MASK) !=
        CAM_SCSI_STATUS_ERROR)
    break;

   if (proto_flags & CAM_ESF_PRINT_STATUS) {
    sbuf_cat(&sb, path_str);
    sbuf_printf(&sb, "SCSI status: %s\n",
         scsi_status_string(&ccb->csio));
   }

   if ((proto_flags & CAM_ESF_PRINT_SENSE)
    && (ccb->csio.scsi_status == 0x02)
    && (ccb->ccb_h.status & CAM_AUTOSNS_VALID)) {


    scsi_sense_sbuf(&ccb->csio, &sb,
      SSS_FLAG_NONE);




   }
   break;
  case XPT_SMP_IO:
   if ((ccb->ccb_h.status & CAM_STATUS_MASK) !=
        CAM_SMP_STATUS_ERROR)
    break;

   if (proto_flags & CAM_ESF_PRINT_STATUS) {
    sbuf_cat(&sb, path_str);
    sbuf_printf(&sb, "SMP status: %s (%#x)\n",
        smp_error_desc(ccb->smpio.smp_response[2]),
         ccb->smpio.smp_response[2]);
   }

   break;
  default:
   break;
  }
 }

 sbuf_finish(&sb);

 return(sbuf_data(&sb));
}



void
cam_error_print(union ccb *ccb, cam_error_string_flags flags,
  cam_error_proto_flags proto_flags)
{
 char str[512];

 printf("%s", cam_error_string(ccb, str, sizeof(str), flags,
        proto_flags));
}
# 455 "/home/jra40/P4/tesla/sys/cam/cam.c"
void
cam_calc_geometry(struct ccb_calc_geometry *ccg, int extended)
{
 uint32_t size_mb, secs_per_cylinder;

 if (ccg->block_size == 0) {
  ccg->ccb_h.status = CAM_REQ_CMP_ERR;
  return;
 }
 size_mb = (1024L * 1024L) / ccg->block_size;
 if (size_mb == 0) {
  ccg->ccb_h.status = CAM_REQ_CMP_ERR;
  return;
 }
 size_mb = ccg->volume_size / size_mb;
 if (size_mb > 1024 && extended) {
  ccg->heads = 255;
  ccg->secs_per_track = 63;
 } else {
  ccg->heads = 64;
  ccg->secs_per_track = 32;
 }
 secs_per_cylinder = ccg->heads * ccg->secs_per_track;
 if (secs_per_cylinder == 0) {
  ccg->ccb_h.status = CAM_REQ_CMP_ERR;
  return;
 }
 ccg->cylinders = ccg->volume_size / secs_per_cylinder;
 ccg->ccb_h.status = CAM_REQ_CMP;
}
