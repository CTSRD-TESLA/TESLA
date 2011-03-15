#include <stdio.h>

#include "tesla.h"
#include "types.h"



void __tesla_event_assertion_helper_0(user, filename, super_error)
	struct User *user;
	const char *filename;
	int super_error;
{
	printf("assertion 0 in helper(): 0x%016lx, '%s', %d\n",
			 (unsigned long) user, filename, super_error);
}

// int check_auth(struct User *u, const char *filename);
void __tesla_event_function_prologue_check_auth(
		struct __tesla_data *tesla_data, struct User *u, const char *filename);

void __tesla_event_function_return_check_auth(struct __tesla_data*, int retval);

// void audit_submit(int event, const void *data);
void __tesla_event_function_prologue_audit_submit(
		struct __tesla_data *tesla_data, int event, const void *data);

void __tesla_event_function_return_audit_submit(
		struct __tesla_data *tesla_data);




void __tesla_event_function_prologue_audit_submit(struct __tesla_data *tesla_data, int event, const void *data) {
	printf("enter audit_submit(%d, 0x%016lx)\n", event, (unsigned long) data);
}
void __tesla_event_function_return_audit_submit(struct __tesla_data *tesla_data) {
	printf("leave audit_submit()\n");
}

void __tesla_event_function_prologue_check_auth(struct __tesla_data *tesla_data, struct User *u, const char *filename) {
	printf("enter check_auth('%s', '%s')\n", u->name->first, filename);
}
void __tesla_event_function_return_check_auth(struct __tesla_data *tesla_data, int retval) {
	printf("leave check_auth(returned %d)\n", retval);
}

void __tesla_event_function_prologue_foo(struct __tesla_data *tesla_data, struct User *user, const char *filename) {
	printf("enter foo('%s', '%s')\n", user->name->first, filename);
}
void __tesla_event_function_return_foo(struct __tesla_data *tesla_data, int retval) { printf("leave foo(%d)\n", retval); }

void __tesla_event_function_prologue_helper(struct __tesla_data *tesla_data, struct User *user, const char *filename) {
	printf("enter helper('%s', '%s')\n", user->name->first, filename);
}
void __tesla_event_function_return_helper(struct __tesla_data *tesla_data, int retval) {
	printf("leave helper(returned %d)\n", retval);
}

void __tesla_event_function_prologue_syscall(struct __tesla_data *tesla_data, int id, const void *args) {
	printf("enter syscall(%d, 0x%016lx)\n", id, (unsigned long) args);
}
void __tesla_event_function_return_syscall(struct __tesla_data *tesla_data, int retval) {
	printf("leave syscall(returned %d)\n", retval);
}


void __tesla_event_field_assign_struct_Name_first(name, new_value)
	struct Name *name;
	const char *new_value;
{
	printf("Name(0x%016lx).first = '%s'\n", (unsigned long) name, new_value);
}
 
void __tesla_event_field_assign_struct_Name_initial(name, new_value)
	struct Name *name;
	char new_value;
{
	printf("Name(0x%016lx).initial = '%c'\n", (unsigned long) name, new_value);
}
 
void __tesla_event_field_assign_struct_Name_last(name, new_value)
	struct Name *name;
	const char *new_value;
{
	printf("Name(0x%016lx).last = '%s'\n", (unsigned long) name, new_value);
}
 

void __tesla_event_field_assign_struct_User_id(user, new_value)
	struct User *user;
	unsigned int new_value;
{
	printf("User(0x%016lx).id = %d\n", (unsigned long) user, new_value);
}
 
