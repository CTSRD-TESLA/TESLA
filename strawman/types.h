struct Name
{
	char *first;
	char initial;
	char *last;
}
#ifdef TESLA_ATTRIBUTE_ANNOTATIONS
__attribute__((tesla));  /* instrument assignments to ALL fields */
#else
;
#endif

struct User
{
	struct Name *name;
	unsigned int id;
	unsigned int generation;
};
