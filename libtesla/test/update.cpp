/**
 * @file update.cpp
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
 * RUN: clang++ %cxxflags %ldflags %s -o %t
 * RUN: %t
 */

#include "TestHarness.h"

#include "tesla_internal.h"
#include "test_helpers.h"

#include <memory>

#include <assert.h>
#include <err.h>
#include <stdio.h>

int	count(struct tesla_store*, const struct tesla_key*);

const int id = 0;
const char name[] = "demo class";
const char descrip[] = "a demonstration class of automata";

#define PRINT(...) DEBUG(libtesla.test.update, __VA_ARGS__)

const char *event_descriptions[] = { "foo" };

class UpdateTest : public LibTeslaTest
{
public:
	void run();

private:
	int count(struct tesla_store *store, const struct tesla_key *key);

	struct tesla_transition t[3];
	struct tesla_transitions trans = {
		.length = 1,
		.transitions = t
	};

	struct tesla_automaton automaton = {
		.ta_name = "unique_name",
		.ta_description = "update.cpp: generate(automaton)",
		.ta_alphabet_size = 1,
		.ta_symbol_names = event_descriptions,
		.ta_transitions = &trans,
	};
};


int
main(int argc, char **argv)
{
	install_default_signal_handler();

	UpdateTest Test;
	Test.run();

	return 0;
}


void UpdateTest::run()
{
	const enum tesla_context context = TESLA_CONTEXT_GLOBAL;
	const int32_t instances_in_class = 10;

	struct tesla_store *store;
	check(tesla_store_get(context, 1, instances_in_class, &store));

	// Test the following sequence of automata update events:
	//
	// (X,X,X,X): 0->1       init   (X,X,X,X):0 -> (X,X,X,X):1
	// (1,X,X,X): 1->2       fork   (X,X,X,X):1 -> (1,X,X,X):2
	// (1,2,X,X): 2->3       fork   (1,X,X,X):2 -> (1,2,X,X):3
	// (1,2,X,X): 3->4       update (1,2,X,X):3 -> (1,2,X,X):4
	// (2,X,X,X): 1->5       fork   (X,X,X,X):1 -> (2,X,X,X):5
	// (2,X,X,3): 5->6       fork   (2,X,X,X):5 -> (2,X,X,3):6
	// (2,X,X,4): 1->7       fork   (X,X,X,X):1 -> (2,X,X,4):7

	struct tesla_key key;


	const struct tesla_key
		any = { .tk_mask = 0 },
		one = { .tk_mask = 1, .tk_keys[0] = 1 },
		two = { .tk_mask = 1, .tk_keys[0] = 2 }
		;


	// (X,X,X,X): 0->1       init   (X,X,X,X):0 -> (X,X,X,X):1
	key.tk_mask = 0;
	t[0].from = 0;
	t[0].from_mask = 0x0;
	t[0].to = 1;
	t[0].to_mask = 0x0;
	t[0].flags = TESLA_TRANS_INIT;

	expectedEvents.push(NewInstance);
	tesla_update_state(context, &automaton, 0, &key);
	// TODO: pass transition through event handler
	//assert(lastEvent->transition == t);
	assert(lastEvent.get());
	assert(lastEvent->inst->ti_state == 1);
	assert(lastEvent->inst->ti_key.tk_mask == 0);

	assert(count(store, &any) == 1);
	assert(count(store, &one) == 0);
	assert(count(store, &two) == 0);


	// (1,X,X,X): 1->2       fork   (X,X,X,X):1 -> (1,X,X,X):2
	key.tk_mask = 1;
	key.tk_keys[0] = 1;
	t[0].from = 1;
	t[0].from_mask = 0x0;
	t[0].to = 2;
	t[0].to_mask = 0x1;
	t[0].flags = 0;

	expectedEvents.push(Clone);
	tesla_update_state(context, &automaton, 0, &key);
	assert(lastEvent->transition == t);
	assert(lastEvent->inst->ti_state == 1);
	assert(lastEvent->inst->ti_key.tk_mask == 0);
	assert(lastEvent->copy->ti_state == 2);
	assert(lastEvent->copy->ti_key.tk_mask == 0x1);

	assert(count(store, &any) == 2);
	assert(count(store, &one) == 1);
	assert(count(store, &two) == 0);


	// (1,2,X,X): 2->3       fork   (1,X,X,X):2 -> (1,2,X,X):3
	key.tk_mask = 3;
	key.tk_keys[0] = 1;
	key.tk_keys[1] = 2;
	t[0].from = 2;
	t[0].from_mask = 0x1;
	t[0].to = 3;
	t[0].to_mask = 0x3;
	t[0].flags = 0;

	expectedEvents.push(Clone);
	tesla_update_state(context, &automaton, 0, &key);
	assert(lastEvent->transition == t);
	assert(lastEvent->inst->ti_state == 2);
	assert(lastEvent->inst->ti_key.tk_mask == 0x1);
	assert(lastEvent->copy->ti_state == 3);
	assert(lastEvent->copy->ti_key.tk_mask == 0x3);

	assert(count(store, &any) == 3);
	assert(count(store, &one) == 2);
	assert(count(store, &two) == 0);


	// (1,2,X,X): 3->4       update (1,2,X,X):3 -> (1,2,X,X):4
	key.tk_mask = 3;
	key.tk_keys[0] = 1;
	key.tk_keys[1] = 2;
	t[0].from = 3;
	t[0].from_mask = 0x3;
	t[0].to = 4;
	t[0].to_mask = 0x3;
	t[0].flags = 0;

	expectedEvents.push(Transition);
	tesla_update_state(context, &automaton, 0, &key);
	assert(lastEvent->transition == t);
	assert(lastEvent->inst->ti_state == 4);
	assert(lastEvent->inst->ti_key.tk_mask == 0x3);

	assert(count(store, &any) == 3);
	assert(count(store, &one) == 2);
	assert(count(store, &two) == 0);


	// (2,X,X,X): 1->5       fork   (X,X,X,X):1 -> (2,X,X,X):5
	key.tk_mask = 1;
	key.tk_keys[0] = 2;
	t[0].from = 1;
	t[0].from_mask = 0;
	t[0].to = 5;
	t[0].to_mask = 0x1;
	t[0].flags = 0;

	expectedEvents.push(Clone);
	tesla_update_state(context, &automaton, 0, &key);
	assert(lastEvent->transition == t);
	assert(lastEvent->inst->ti_state == 1);
	assert(lastEvent->inst->ti_key.tk_mask == 0);
	assert(lastEvent->copy->ti_state == 5);
	assert(lastEvent->copy->ti_key.tk_mask == 0x1);

	assert(count(store, &any) == 4);
	assert(count(store, &one) == 2);
	assert(count(store, &two) == 1);


	// (2,X,X,3): 5->6       fork   (2,X,X,X):5 -> (2,X,X,3):6
	key.tk_mask = 9;
	key.tk_keys[0] = 2;
	key.tk_keys[3] = 3;
	t[0].from = 5;
	t[0].from_mask = 0x1;
	t[0].to = 6;
	t[0].to_mask = 0x9;
	t[0].flags = 0;

	expectedEvents.push(Clone);
	tesla_update_state(context, &automaton, 0, &key);
	assert(lastEvent->transition == t);
	assert(lastEvent->inst->ti_state == 5);
	assert(lastEvent->inst->ti_key.tk_mask == 0x1);
	assert(lastEvent->copy->ti_state == 6);
	assert(lastEvent->copy->ti_key.tk_mask == 0x9);

	assert(count(store, &any) == 5);
	assert(count(store, &one) == 2);
	assert(count(store, &two) == 2);


	// (2,X,X,4): 1->7       fork   (X,X,X,X):1 -> (2,X,X,4):7
	key.tk_mask = 9;
	key.tk_keys[0] = 2;
	key.tk_keys[3] = 4;
	t[0].from = 1;
	t[0].from_mask = 0x0;
	t[0].to = 7;
	t[0].to_mask = 0x9;
	t[0].flags = 0;

	expectedEvents.push(Clone);
	tesla_update_state(context, &automaton, 0, &key);
	assert(lastEvent->inst->ti_state == 1);
	assert(lastEvent->inst->ti_key.tk_mask == 0);
	assert(lastEvent->copy->ti_state == 7);
	assert(lastEvent->copy->ti_key.tk_mask == 0x9);

	assert(count(store, &any) == 6);
	assert(count(store, &one) == 2);
	assert(count(store, &two) == 3);
}


int
UpdateTest::count(struct tesla_store *store, const struct tesla_key *key)
{
	uint32_t len = 20;
	struct tesla_instance* matches[len];
	struct tesla_class *cls;

	check(tesla_class_get(store, &automaton, &cls));

	check(tesla_match(cls, key, matches, &len));

	tesla_class_put(cls);

	return len;
}
