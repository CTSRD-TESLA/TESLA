struct Name
{
	char *first;
	char initial;
	char *last;
}
__attribute__((tesla));

struct User
{
	struct Name *name;
	unsigned int id;
	unsigned int generation;
}
__attribute__((tesla));
