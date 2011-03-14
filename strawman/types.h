struct Name
{
	char *first;
	char initial;
	char *last;
}
__attribute__((tesla));  /* instrument assignments to ALL fields */

struct User
{
	struct Name *name;
	unsigned int id;
	unsigned int generation;
};
