/*
 * TODO: remove these hacks!
 * (Clang should prune calls to these pseudo-functions rights out of the AST)
 */
int __tesla_previously(int cond) { return 1; }
int __tesla_eventually(int cond) { return 1; }
int __tesla_assigned(void* where, void* what) { return 1; }
int __tesla_returned(int retval, int expected) { return (retval == expected); }
