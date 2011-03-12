struct __tesla_data {
	void *data;
};


#define __tesla_assert

int __tesla_previously(int cond) { return true; }
#define previously(x) __tesla_previously(x)

int __tesla_eventually(int cond) { return true; }
#define eventually(x) __tesla_eventually(x)

int __tesla_assigned(void* where, void* what) { return true; }
#define assigned(x, y) __tesla_assigned((void*) x, (void*) y)

int __tesla_returned(int retval, int expected) { return retval; }
#define returned(x, y) __tesla_returned(x, y)

