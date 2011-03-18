/* manual mock-up of what event handlers (machine-generated) could look like */

#include <stdio.h>

#include <tesla/tesla.h>

#include "types.h"

#include "syscalls.c-tesla.h"


void __tesla_event_assertion_helper_0(struct User *user, const char *filename)
{
	printf("assertion 0 in helper(): 0x%016lx, '%s'\n",
			 (unsigned long) user, filename);
}


void __tesla_event_function_prologue_audit_submit(void **tesla_data, int event, const void *data) {
	printf("enter audit_submit(%d, 0x%016lx)\n", event, (unsigned long) data);
}
void __tesla_event_function_return_audit_submit(void **tesla_data) {
	printf("leave audit_submit()\n");
}

void __tesla_event_function_prologue_check_auth(void **tesla_data, struct User *u, const char *filename) {
	printf("enter check_auth('%s', '%s')\n", u->name->first, filename);
}
void __tesla_event_function_return_check_auth(void **tesla_data, int retval) {
	printf("leave check_auth(returned %d)\n", retval);
}

void __tesla_event_function_prologue_foo(void **tesla_data, struct User *user, const char *filename) {
	printf("enter foo('%s', '%s')\n", user->name->first, filename);
}
void __tesla_event_function_return_foo(void **tesla_data, int retval) { printf("leave foo(%d)\n", retval); }

void __tesla_event_function_prologue_helper(void **tesla_data, struct User *user, const char *filename) {
	printf("enter helper('%s', '%s')\n", user->name->first, filename);
}
void __tesla_event_function_return_helper(void **tesla_data, int retval) {
	printf("leave helper(returned %d)\n", retval);
}

void __tesla_event_function_prologue_syscall(void **tesla_data, int id, const void *args) {
	printf("enter syscall(%d, 0x%016lx)\n", id, (unsigned long) args);
}
void __tesla_event_function_return_syscall(void **tesla_data, int retval) {
	printf("leave syscall(returned %d)\n", retval);
}


void __tesla_event_field_assign_struct_Name_first(name, new_value)
	struct Name *name;
	char *new_value;
{
	printf("Name(0x%016lx).first = '%s'\n", (unsigned long) name, new_value);
}
 
void __tesla_event_field_assign_struct_Name_initial(
		struct Name *name, char new_value)
{
	printf("Name(0x%016lx).initial = '%c'\n", (unsigned long) name, new_value);
}
 
void __tesla_event_field_assign_struct_Name_last(name, new_value)
	struct Name *name;
	char *new_value;
{
	printf("Name(0x%016lx).last = '%s'\n", (unsigned long) name, new_value);
}
 

void __tesla_event_field_assign_struct_User_id(user, new_value)
	struct User *user;
	unsigned int new_value;
{
	printf("User(0x%016lx).id = %d\n", (unsigned long) user, new_value);
}
 
