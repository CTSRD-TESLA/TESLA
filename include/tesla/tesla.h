#ifndef	TESLA_H
#define	TESLA_H

/*
 * This file provides pretty ifdefs around Tesla primitives, allowing us to
 * write reasonable readable assertions like:
 *
 * TESLA_ASSERT(syscall) {
 * 	previously(returned(0, check_auth(user, file)))
 * 	|| previously(returned(0, give_override_permission(user))
 * 	|| eventually(invoked(audit_submit(user, file)))
 * }
 *
 * If 'T' has already been defined, the pretty shorthand above will not be
 * available; rather you'll need to refer to:
 *
 * __tesla_start_of_assertion(
 * 	__tesla_storage_perthread(),
 * 	__tesla_invoked(syscall),
 * 	__tesla_returned(__tesla_dont_care, syscall));
 *
 * {
 * 	__tesla_previously(__tesla_returned( ... ))
 * 	...
 * }
 */

#ifdef	T
#warning Not defining Tesla shorthand notation; 'T' already defined
#else
#define	TESLA_PROVIDE_SHORTHAND
#endif

struct __tesla_event;

/* Temporal qualifiers */
int __tesla_now(struct __tesla_event *event);
int __tesla_previously(struct __tesla_event *event);
int __tesla_eventually(struct __tesla_event *event);

/* Point expressions */
typedef int __tesla_result; /* TODO: more flexibility (want C++ templates) */
__tesla_result __tesla_dont_care;

struct __tesla_event* __tesla_invoked(void *fn);
struct __tesla_event* __tesla_returned(__tesla_result ret, void *fn);
struct __tesla_event* __tesla_field_assigned(void *base, void *ptr, void *val);

void __tesla_automata(void *);
#define	automata(x) __tesla_automata(x)

/* Tesla storage: global or per-thread */
struct __tesla_storage_specifier;
struct __tesla_storage_specifier* __tesla_storage_global();
struct __tesla_storage_specifier* __tesla_storage_perthread();

/* Markers for the beginning of instrumentation. */
void __tesla_start_of_assertion(
	struct __tesla_storage_specifier *storage,
	struct __tesla_event *scope_begin,
	struct __tesla_event *scope_end);


#ifdef	TESLA_PROVIDE_SHORTHAND

#define	T(x) __tesla_##x

#define	now(x)			T(now(x))
#define	previously(x)		T(previously(x))
#define	eventually(x)		T(eventually(x))

#define	invoked(fn)		T(invoked((void *)fn))
#define	returned(ret, fn)	T(returned(ret, (void *)fn))
#define	assigned(base, member, value) \
	T(field_assigned((void*) base, (void*) &(base->member), (void*) value))

#define	dont_care	T(dont_care)

#define TESLA_ASSERT(scope) \
	__tesla_start_of_assertion( \
		T(storage_perthread()), \
		invoked(scope), \
		returned(dont_care, scope));

#define TESLA_ASSERT_GLOBAL(scope) \
	__tesla_start_of_assertion( \
		T(storage_global()), \
		invoked(scope), \
		returned(dont_care, scope));

#endif


#endif  /* TESLA_H */
