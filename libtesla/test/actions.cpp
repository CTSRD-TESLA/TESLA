/**
 * @file actions.cpp
 * Tests @ref tesla_action.
 *
 * @ref tesla_action decides what we should do to a @ref tesla_instance in a
 * situation described by a @ref tesla_key and a @ref tesla_transition.
 *
 * Commands for llvm-lit:
 * RUN: clang++ %cxxflags %ldflags %s -o %t
 * RUN: %t > %t.out
 * RUN: %filecheck -input-file %t.out %s
 */

#include "tesla_internal.h"
#include "test_helpers.h"

#include <stdio.h>

#define DEBUG_NAME "libtesla.test.actions"
#define PRINT(...) DEBUG(libtesla.test.actions, __VA_ARGS__)

void	log_action(tesla_instance, tesla_key, tesla_transitions);
const char *action_str(enum tesla_action_t);

int
main(int argc, char **argv)
{
	install_default_signal_handler();

	tesla_instance inst;
	tesla_key event_data;
	tesla_transition t_storage[10];
	tesla_transitions t;
	t.transitions = t_storage;

	uint32_t x = 42;
	uint32_t y = 86;
	//uint32_t z = 99;

	bzero(&t_storage, sizeof(t_storage));

	/*
	 * For the first round of tests, use the name (x,*) and the transitions:
	 * [ (1:0x0 -> 2:0x1), (3:0x1 -> 4:0x1), (5:0x3 -> 6:0x3) ]
	 */
	event_data.tk_mask = 1;
	event_data.tk_keys[0] = x;
	event_data.tk_freemask = 0;

	t.length = 3;

	t.transitions[0].from       = 1;
	t.transitions[0].from_mask  = 0;
	t.transitions[0].to         = 2;
	t.transitions[0].to_mask    = 1;
	t.transitions[0].flags      = 0;

	t.transitions[1].from       = 3;
	t.transitions[1].from_mask  = 1;
	t.transitions[1].to         = 4;
	t.transitions[1].to_mask    = 1;
	t.transitions[1].flags      = 0;

	t.transitions[2].from       = 5;
	t.transitions[2].from_mask  = 3;
	t.transitions[2].to         = 6;
	t.transitions[2].to_mask    = 3;
	t.transitions[2].flags      = 0;

	print_key(DEBUG_NAME, &event_data);
	PRINT(" : ");
	print_transitions(DEBUG_NAME, &t);
	PRINT("\n");

	/*
	 * Instance: (*,*):1
	 * CHECK: FORK (1:0x0 -> 2:0x1)
	 */
	inst.ti_key.tk_mask = 0;
	inst.ti_state = 1;
	log_action(inst, event_data, t);

	/*
	 * Instance: (y,*):2
	 * CHECK: IGNORE
	 */
	inst.ti_key.tk_mask = 1;
	inst.ti_key.tk_keys[0] = y;
	inst.ti_state = 2;
	log_action(inst, event_data, t);

	/*
	 * Instance: (x,*):2
	 * CHECK: FAIL
	 */
	inst.ti_key.tk_mask = 1;
	inst.ti_key.tk_keys[0] = x;
	inst.ti_state = 2;
	log_action(inst, event_data, t);

	/*
	 * Instance: (x,y):5
	 * CHECK: UPDATE
	 */
	inst.ti_key.tk_mask = 3;
	inst.ti_key.tk_keys[0] = x;
	inst.ti_key.tk_keys[1] = y;
	inst.ti_state = 5;
	log_action(inst, event_data, t);

	/*
	 * Instance: (y,*):3
	 * CHECK: IGNORE
	 */
	inst.ti_key.tk_mask = 1;
	inst.ti_key.tk_keys[0] = y;
	inst.ti_state = 3;
	log_action(inst, event_data, t);

	/*
	 * For the second round, use the name (*,*) and the transitions:
	 * [ (1:0x1 -> 9:0x1), (6:0x3 -> 9:0x3) ]
	 */
	event_data.tk_keys[0] = 0xBEEF;
	event_data.tk_keys[1] = 0xF00D;
	event_data.tk_mask = 0;

	t.length = 2;

	t.transitions[0].from       = 1;
	t.transitions[0].from_mask  = 1;
	t.transitions[0].to         = 9;
	t.transitions[0].to_mask    = 1;
	t.transitions[0].flags      = 0;

	t.transitions[1].from       = 6;
	t.transitions[1].from_mask  = 3;
	t.transitions[1].to         = 9;
	t.transitions[1].to_mask    = 3;
	t.transitions[1].flags      = 0;

	PRINT("\n");
	print_key(DEBUG_NAME, &event_data);
	PRINT(" : ");
	print_transitions(DEBUG_NAME, &t);
	PRINT("\n");

	/*
	 * Instance: (x,*):1
	 * CHECK: UPDATE
	 */
	inst.ti_key.tk_mask = 1;
	inst.ti_key.tk_keys[0] = x;
	inst.ti_state = 1;
	log_action(inst, event_data, t);

	/*
	 * Instance: (y,*):1
	 * CHECK: UPDATE
	 */
	inst.ti_key.tk_mask = 1;
	inst.ti_key.tk_keys[0] = y;
	inst.ti_state = 1;
	log_action(inst, event_data, t);

	/*
	 * Instance: (*,*):4
	 * CHECK: FAIL
	 */
	inst.ti_key.tk_mask = 0;
	inst.ti_state = 4;
	log_action(inst, event_data, t);

	/*
	 * Instance: (y,*):3
	 * CHECK: UPDATE
	 */
	inst.ti_key.tk_mask = 3;
	inst.ti_key.tk_keys[0] = x;
	inst.ti_key.tk_keys[1] = y;
	inst.ti_state = 6;
	log_action(inst, event_data, t);

	/*
	 * Next, we use the name (x,y) and the transitions:
	 * [ (1:0x0 -> 2:0x1), (2:0x0 -> 3:0x0) ]
	 */
	event_data.tk_mask = 3;
	event_data.tk_keys[0] = x;
	event_data.tk_keys[1] = y;

	t.length = 2;

	t.transitions[0].from       = 1;
	t.transitions[0].from_mask  = 0;
	t.transitions[0].to         = 2;
	t.transitions[0].to_mask    = 1;
	t.transitions[0].flags      = 0;

	t.transitions[1].from       = 2;
	t.transitions[1].from_mask  = 0;
	t.transitions[1].to         = 3;
	t.transitions[1].to_mask    = 0;
	t.transitions[1].flags      = 0;

	PRINT("\n");
	print_key(DEBUG_NAME, &event_data);
	PRINT(" : ");
	print_transitions(DEBUG_NAME, &t);
	PRINT("\n");

	/*
	 * Instance: (*,*):1
	 * CHECK: FORK (1:0x0 -> 2:0x1)
	 */
	inst.ti_key.tk_mask = 0;
	inst.ti_state = 1;
	log_action(inst, event_data, t);

	/*
	 * Instance: (*,*):2
	 * CHECK: UPDATE (2:0x0 -> 3:0x0)
	 */
	inst.ti_key.tk_mask = 0;
	inst.ti_state = 2;
	log_action(inst, event_data, t);

	/*
	 * Instance: (x,y):99
	 * CHECK: FAIL
	 */
	inst.ti_key.tk_mask = 3;
	inst.ti_key.tk_keys[0] = x;
	inst.ti_key.tk_keys[1] = y;
	inst.ti_state = 99;
	log_action(inst, event_data, t);

	/*
	 * If we ever try to lose information (as can happen during automata
	 * cleanup), it should result in UPDATE:
	 */
	event_data.tk_mask = 1;
	event_data.tk_keys[0] = x;

	t.length = 2;

	t.transitions[0].from       = 1;
	t.transitions[0].from_mask  = 1;
	t.transitions[0].to         = 2;
	t.transitions[0].to_mask    = 0;
	t.transitions[0].flags      = TESLA_TRANS_CLEANUP;

	t.transitions[1].from       = 3;
	t.transitions[1].from_mask  = 1;
	t.transitions[1].to         = 1;
	t.transitions[1].to_mask    = 0;
	t.transitions[1].flags      = 0;

	PRINT("\n");
	print_key(DEBUG_NAME, &event_data);
	PRINT(" : ");
	print_transitions(DEBUG_NAME, &t);
	PRINT("\n");

	/*
	 * Instance: (x):1
	 * CHECK: UPDATE (1:0x1 -> 2:0x0 <clean>)
	 */
	inst.ti_key.tk_mask = 1;
	inst.ti_key.tk_keys[0] = x;
	inst.ti_state = 1;
	log_action(inst, event_data, t);

	/*
	 * Instance: (x):3
	 * CHECK: JOIN (3:0x1 -> 1:0x0)
	 */
	inst.ti_key.tk_mask = 1;
	inst.ti_key.tk_keys[0] = x;
	inst.ti_state = 3;
	log_action(inst, event_data, t);

	return 0;
}

const char*
action_str(enum tesla_action_t action)
{
	switch (action) {
	case UPDATE:  return "UPDATE";
	case FORK:    return "FORK";
	case JOIN:    return "JOIN";
	case IGNORE:  return "IGNORE";
	case FAIL:    return "FAIL";
	default:      return "<<invalid action>>";
	}
}

void
log_action(tesla_instance inst, tesla_key event_data, tesla_transitions t)
{
	const tesla_transition *trigger = NULL;
	enum tesla_action_t action =
		tesla_action(&inst, &event_data, &t, &trigger);

	PRINT("%d:", inst.ti_state);
	print_key(DEBUG_NAME, &inst.ti_key);

	PRINT(" -> %s ", action_str(action));

	if (trigger != NULL)
		print_transition(DEBUG_NAME, trigger);

	PRINT("\n");
}

