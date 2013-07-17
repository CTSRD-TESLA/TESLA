profile:::profile-1001hz
{
	@pc[arg0] = count();
}

END
{
	printa("%a %@d\n", @pc);
}
