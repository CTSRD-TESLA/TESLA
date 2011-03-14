#include <stdio.h>

#include "tesla.h"
#include "types.h"

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

 
void __tesla_event_struct_assign_struct_Name(name, index, new_value)
	struct Name *name;
	int index;
	void *new_value;
{
	printf("Name(0x%016lx)", (unsigned long) name);

	switch (index)
	{
		case 0:
			printf(".first       =>  '%s'\n", (char*) new_value);
			break;

		case 1:
			printf(".initial     =>  '%c'\n", (char) new_value);
			break;

		case 2:
			printf(".last        =>  '%s'\n", (char*) new_value);
			break;
	}
}

void __tesla_event_struct_assign_struct_User(user, index, new_value)
	struct User *user;
	int index;
	void *new_value;
{
	printf("User(0x%016lx)", (unsigned long) user);

	switch (index)
	{
		case 0:
			printf(".name        =>  0x%016lx\n", (unsigned long) new_value);
			break;

		case 1:
			printf(".id          =>  %d\n", (int) new_value);
			break;

		case 2:
			printf(".generation  =>  %d\n", (int) new_value);
			break;
	}
}

