#ifndef TESLA_H
#define TESLA_H

#ifndef int32_t
#define int32_t __int32_t
#endif

struct __tesla_data {
	int32_t ids[10];
	int32_t len;
};


#define __tesla_assert

int __tesla_previously(int cond);
#define previously(x) __tesla_previously(x)

int __tesla_eventually(int cond);
#define eventually(x) __tesla_eventually(x)

int __tesla_assigned(void* where, void* what);
#define assigned(x, y) __tesla_assigned((void*) x, (void*) y)

int __tesla_returned(int retval, int expected);
#define returned(x, y) __tesla_returned(x, y)

#endif  /* TESLA_H */
