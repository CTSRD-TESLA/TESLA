/**
 * @file update.c
 * Tests automata-updating behaviour.
 *
 * When an event is fired, it must be delivered to all automata instances that
 * care about it, even if they don't exist yet.
 *
 * We support this use case by forking automata: an automaton with a
 * non-specific name like (x,y,ANY) can be forked off into a more specific
 * automaton named (x,y,z).
 *
 * This test ensures that automata forking works correctly.
 *
 * Commands for llvm-lit:
 * RUN: clang %cflags %ldflags %s -o %t
 * RUN: %t > %t.out
 * RUN: FileCheck --input-file=%t.out %s
 */

#include "tesla_internal.h"

#include <assert.h>
#include <err.h>
#include <stdio.h>

#include "helpers.h"

int	count(struct tesla_store*, const struct tesla_key*);

const int id = 0;
const char name[] = "demo class";
const char descrip[] = "a demonstration class of automata";

#define PRINT(...) DEBUG(libtesla.test.update, __VA_ARGS__)

int
main(int argc, char **argv)
{
	install_default_signal_handler();

	const int32_t scope = TESLA_SCOPE_GLOBAL;
	const int32_t instances_in_class = 10;

	struct tesla_store *store;
	check(tesla_store_get(scope, 1, instances_in_class, &store));

	// Test the following sequence of automata update events:
	//
	// (X,X,X,X): 0->1       init   (X,X,X,X):0 -> (X,X,X,X):1
	// (1,X,X,X): 1->2       fork   (X,X,X,X):1 -> (1,X,X,X):2
	// (1,2,X,X): 2->3       fork   (1,X,X,X):2 -> (1,2,X,X):3
	// (1,2,X,X): 3->4       update (1,2,X,X):3 -> (1,2,X,X):4
	// (2,X,X,X): 1->5       fork   (X,X,X,X):1 -> (2,X,X,X):5
	// (2,X,X,3): 5->6       fork   (2,X,X,X):5 -> (2,X,X,3):6
	// (2,X,X,4): 1->7       fork   (X,X,X,X):1 -> (2,X,X,4):7
	// (X,X,X,X): 1->8       fork   (X,X,X,X):1 -> (3,X,X,X):8

	struct tesla_key key;

	struct tesla_transition t[2];
	struct tesla_transitions trans = {
		.length = 1,
		.transitions = t
	};

	const struct tesla_key
		any = { .tk_mask = 0 },
		one = { .tk_mask = 1, .tk_keys[0] = 1 },
		two = { .tk_mask = 1, .tk_keys[0] = 2 }
		;

	PRINT("(X,X,X,X): 0->1       new    (X,X,X,X):1\n");

	key.tk_mask = 0;
	t[0].from = 0;
	t[0].mask = 0x0;
	t[0].to = 1;
	t[0].flags = TESLA_TRANS_INIT;
	/*
	 * CHECK: ====
	 * CHECK: tesla_update_state()
	 * CHECK:   context:        global
	 * CHECK:   transitions:    [ (0:0x0 -> 1 <init>) ]
	 * CHECK: ----
	 * CHECK: [[GLOBAL_STORE:store: 0x[0-9a-f]+]]
	 * CHECK: ----
	 * CHECK: 0/{{[0-9]+}} instances
	 * CHECK: ----
	 * CHECK: new  0: 1
	 * CHECK: ----
	 * CHECK: 1/{{[0-9]+}} instances
	 * CHECK:   0: state 1, 0x0 [ X X X X ]
	 * CHECK: ====
	 */
	check(tesla_update_state(scope, id, &key, name, descrip, &trans));
	assert(count(store, &any) == 1);
	assert(count(store, &one) == 0);
	assert(count(store, &two) == 0);

	PRINT("(1,X,X,X): 1->2       fork   (X,X,X,X):1 -> (1,X,X,X):2\n");
	key.tk_mask = 1;
	key.tk_keys[0] = 1;
	t[0].from = 1;
	t[0].mask = 0x0;
	t[0].to = 2;
	t[0].flags = 0;
	/*
	 * CHECK: ====
	 * CHECK: tesla_update_state()
	 * CHECK:   context:        global
	 * CHECK:   transitions:    [ (1:0x0 -> 2) ]
	 * CHECK: ----
	 * CHECK: [[GLOBAL_STORE:store: 0x[0-9a-f]+]]
	 * CHECK: ----
	 * CHECK: 1/{{[0-9]+}} instances
	 * CHECK: ----
	 * CHECK: clone  0:1 -> 1:2
	 * CHECK: ----
	 * CHECK: 2/{{[0-9]+}} instances
	 * CHECK: ====
	 */
	check(tesla_update_state(scope, id, &key, name, descrip, &trans));

	assert(count(store, &any) == 2);
	assert(count(store, &one) == 1);
	assert(count(store, &two) == 0);

	PRINT("(1,2,X,X): 2->3       fork   (1,X,X,X):2 -> (1,2,X,X):3\n");
	key.tk_mask = 3;
	key.tk_keys[0] = 1;
	key.tk_keys[1] = 2;
	t[0].from = 2;
	t[0].mask = 0x1;
	t[0].to = 3;
	t[0].flags = 0;
	/*
	 * CHECK: ====
	 * CHECK: tesla_update_state()
	 * CHECK:   context:        global
	 * CHECK:   transitions:    [ (2:0x1 -> 3) ]
	 * CHECK: ----
	 * CHECK: [[GLOBAL_STORE:store: 0x[0-9a-f]+]]
	 * CHECK: ----
	 * CHECK: 2/{{[0-9]+}} instances
	 * CHECK: ----
	 * CHECK: clone  1:2 -> 2:3
	 * CHECK: ----
	 * CHECK: 3/{{[0-9]+}} instances
	 * CHECK: ====
	 */
	check(tesla_update_state(scope, id, &key, name, descrip, &trans));

	assert(count(store, &any) == 3);
	assert(count(store, &one) == 2);
	assert(count(store, &two) == 0);

	PRINT("(1,2,X,X): 3->4       update (1,2,X,X):3 -> (1,2,X,X):4\n");
	key.tk_mask = 3;
	key.tk_keys[0] = 1;
	key.tk_keys[1] = 2;
	t[0].from = 3;
	t[0].mask = 0x3;
	t[0].to = 4;
	t[0].flags = 0;
	/*
	 * CHECK: ====
	 * CHECK: tesla_update_state()
	 * CHECK:   context:        global
	 * CHECK:   transitions:    [ (3:0x3 -> 4) ]
	 * CHECK: ----
	 * CHECK: [[GLOBAL_STORE:store: 0x[0-9a-f]+]]
	 * CHECK: ----
	 * CHECK: 3/{{[0-9]+}} instances
	 * CHECK: ----
	 * CHECK: update  2: 3->4
	 * CHECK: ----
	 * CHECK: 3/{{[0-9]+}} instances
	 * CHECK: ====
	 */
	check(tesla_update_state(scope, id, &key, name, descrip, &trans));

	assert(count(store, &any) == 3);
	assert(count(store, &one) == 2);
	assert(count(store, &two) == 0);

	PRINT("(2,X,X,X): 1->5       fork   (X,X,X,X):1 -> (2,X,X,X):5\n");
	key.tk_mask = 1;
	key.tk_keys[0] = 2;
	t[0].from = 1;
	t[0].mask = 0;
	t[0].to = 5;
	t[0].flags = 0;
	/*
	 * CHECK: ====
	 * CHECK: tesla_update_state()
	 * CHECK:   context:        global
	 * CHECK:   transitions:    [ (1:0x0 -> 5) ]
	 * CHECK: ----
	 * CHECK: [[GLOBAL_STORE:store: 0x[0-9a-f]+]]
	 * CHECK: ----
	 * CHECK: 3/{{[0-9]+}} instances
	 * CHECK: ----
	 * CHECK: clone  0:1 -> 3:5
	 * CHECK: ----
	 * CHECK: 4/{{[0-9]+}} instances
	 * CHECK: ====
	 */
	check(tesla_update_state(scope, id, &key, name, descrip, &trans));

	assert(count(store, &any) == 4);
	assert(count(store, &one) == 2);
	assert(count(store, &two) == 1);

	PRINT("(2,X,X,3): 5->6       fork   (2,X,X,X):5 -> (2,X,X,3):6\n");
	key.tk_mask = 9;
	key.tk_keys[0] = 2;
	key.tk_keys[3] = 3;
	t[0].from = 5;
	t[0].mask = 0x1;
	t[0].to = 6;
	t[0].flags = 0;
	/*
	 * CHECK: ====
	 * CHECK: tesla_update_state()
	 * CHECK:   context:        global
	 * CHECK:   transitions:    [ (5:0x1 -> 6) ]
	 * CHECK: ----
	 * CHECK: [[GLOBAL_STORE:store: 0x[0-9a-f]+]]
	 * CHECK: ----
	 * CHECK: 4/{{[0-9]+}} instances
	 * CHECK: ----
	 * CHECK: clone  3:5 -> 4:6
	 * CHECK: ----
	 * CHECK: 5/{{[0-9]+}} instances
	 * CHECK: ====
	 */
	check(tesla_update_state(scope, id, &key, name, descrip, &trans));

	assert(count(store, &any) == 5);
	assert(count(store, &one) == 2);
	assert(count(store, &two) == 2);

	PRINT("(2,X,X,4): 1->7       fork   (X,X,X,X):1 -> (2,X,X,4):7\n");
	key.tk_mask = 9;
	key.tk_keys[0] = 2;
	key.tk_keys[3] = 4;
	t[0].from = 1;
	t[0].mask = 0x0;
	t[0].to = 7;
	t[0].flags = 0;
	/*
	 * CHECK: ====
	 * CHECK: tesla_update_state()
	 * CHECK:   context:        global
	 * CHECK:   transitions:    [ (1:0x0 -> 7) ]
	 * CHECK: ----
	 * CHECK: [[GLOBAL_STORE:store: 0x[0-9a-f]+]]
	 * CHECK: ----
	 * CHECK: 5/{{[0-9]+}} instances
	 * CHECK: ----
	 * CHECK: clone  0:1 -> 5:7
	 * CHECK: ----
	 * CHECK: 6/{{[0-9]+}} instances
	 * CHECK: ====
	 */
	check(tesla_update_state(scope, id, &key, name, descrip, &trans));

	assert(count(store, &any) == 6);
	assert(count(store, &one) == 2);
	assert(count(store, &two) == 3);

	// (X,X,X,X): 0->8       fork   (X,X,X,X):0 -> (X,X,X,X):8
	PRINT("(X,X,X,X): 0->8       fork   (X,X,X,X):0 -> (X,X,X,X):8\n");
	key.tk_mask = 0;
	t[0].from = 0;
	t[0].mask = 0x0;
	t[0].to = 100;
	t[0].flags = TESLA_TRANS_FORK;
	t[1].from = 1;
	t[1].mask = 0x0;
	t[1].to = 8;
	t[1].flags = 0;
	trans.length = 2;
	/*
	 * CHECK: ====
	 * CHECK: tesla_update_state()
	 * CHECK:   context:        global
	 * CHECK:   transitions:    [ (0:0x0 -> 100 <fork>) (1:0x0 -> 8) ]
	 * CHECK: ----
	 * CHECK: [[GLOBAL_STORE:store: 0x[0-9a-f]+]]
	 * CHECK: ----
	 * CHECK: 6/{{[0-9]+}} instances
	 * CHECK: ----
	 * CHECK: update 0: 1->8
	 * CHECK: ----
	 * CHECK: 6/{{[0-9]+}} instances
	 */
	check(tesla_update_state(scope, id, &key, name, descrip, &trans));

	assert(count(store, &any) == 6);
	assert(count(store, &one) == 2);
	assert(count(store, &two) == 3);

	/*
	 * After all that, we should be left with the following automata:
	 *
	 * CHECK: 0: state 8, 0x0 [ X X X X ]
	 * CHECK: 1: state 2, 0x1 [ 1 X X X ]
	 * CHECK: 2: state 4, 0x3 [ 1 2 X X ]
	 * CHECK: 3: state 5, 0x1 [ 2 X X X ]
	 * CHECK: 4: state 6, 0x9 [ 2 X X 3 ]
	 * CHECK: 5: state 7, 0x9 [ 2 X X 4 ]
	 * CHECK: ====
	 */

	return 0;
}


int
count(struct tesla_store *store, const struct tesla_key *key)
{
	uint32_t len = 20;
	struct tesla_instance* matches[len];
	struct tesla_class *class;

	check(tesla_class_get(store, id, &class, name, descrip));

	check(tesla_match(class, key, matches, &len));

	tesla_class_put(class);

	return len;
}

