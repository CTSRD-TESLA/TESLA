#ifndef TESLA_H
#define TESLA_H

void __tesla_start_of_assertion();
#define TESLA_ASSERT __tesla_start_of_assertion();

int __tesla_previously(int cond);
#define previously(x) __tesla_previously(x)

int __tesla_eventually(int cond);
#define eventually(x) __tesla_eventually(x)

int __tesla_assigned(void* where, void* what);
#define assigned(x, y) __tesla_assigned((void*) x, (void*) y)

int __tesla_returned(int retval, int expected);
#define returned(x, y) __tesla_returned(x, y)

#endif  /* TESLA_H */
