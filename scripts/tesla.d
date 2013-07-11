enum tesla_context {
	TESLA_CONTEXT_GLOBAL,
	TESLA_CONTEXT_THREAD
};

struct tesla_class {
	const char		*tc_name;	/* Name of the assertion. */
	const char		*tc_description;/* Automaton representation. */
	enum tesla_context	 tc_context;	/* Global, thread... */
	uint32_t		 tc_limit;	/* Maximum instances. */

	struct tesla_instance	*tc_instances;	/* Instances of this class. */
	uint32_t		tc_free;	/* Unused instances. */

	struct mtx		tc_lock;	/* Synchronise tc_table. */
};

struct tesla_key {
	/** The keys / event parameters that name this automata instance. */
	uintptr_t	tk_keys[4];

	/** A bitmask of the keys that are actually set. */
	uint32_t	tk_mask;
};

struct tesla_instance {
	struct tesla_key	ti_key;
	uint32_t		ti_state;
};

/** A single allowable transition in a TESLA automaton. */
struct tesla_transition {
	/** The state we are moving from. */
	uint32_t	from;

	/** The mask of the state we're moving from. */
	uint32_t	from_mask;

	/** The state we are moving to. */
	uint32_t	to;

	/** A mask of the keys that the 'to' state should have set. */
	uint32_t	to_mask;

	/** Things we may need to do on this transition. */
	int		flags;
};


tesla::event:state-transition
{
	cls = args[0];
	instance = args[1];
	trans = args[2];

	@transitions[stringof(cls->tc_name), trans->from, trans->to] = count();
}

tesla::fail:bad-transition
{
	cls = args[0];
	inst = args[1];

	@fail[execname, stringof(cls->tc_name),
	      inst->ti_key.tk_mask, inst->ti_state] = count();
}

tesla::success:
{
	c = (struct tesla_class*) args[0];
	@successes[stringof(c->tc_name)] = count();
}

END
{
	printf("\n");
	printf("==================================");
	printf("==================================\n");
	printf("Accepted TESLA automata:\n");
	printf("----------------------------------");
	printf("----------------------------------\n");
	printf("%-55s   %10s\n", "automaton", "successes");
	printf("----------------------------------");
	printf("----------------------------------\n");
	printa("%-55s   %@10u\n", @successes);
	printf("==================================");
	printf("==================================\n");

	printf("\n");
	printf("========================================");
	printf("========================================\n");
	printf("Transitions taken:\n");
	printf("----------------------------------------");
	printf("----------------------------------------\n");
	printf("%-55s  %10s       %6s\n", "automaton", "transition", "count");
	printf("----------------------------------------");
	printf("----------------------------------------\n");
	printa("%-55s  (%u->%u)   %@14u\n", @transitions);
	printf("========================================");
	printf("========================================\n");

	printf("\n===============================================");
	printf("==============================================\n");
	printf("Bad transitions:\n");
	printf("-----------------------------------------------");
	printf("----------------------------------------------\n");
	printf("  execname                                           ");
	printf("       automaton    mask  state   count\n");
	printf("-----------------------------------------------");
	printf("----------------------------------------------\n");
	printa("%10s    %55s    0x%x   %6u  %@u\n", @fail);
	printf("===============================================");
	printf("==============================================\n");
}
