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
