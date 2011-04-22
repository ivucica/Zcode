#import <AppKit/AppKit.h>

#define CHECK(x) extern void check_##x();
#include "index.h"
#undef CHECK

int
main(int argc, const char *argv[])
{
	NSAutoreleasePool *p;
#define CHECK(x) \
	p = [[NSAutoreleasePool alloc] init]; \
	NS_DURING \
	{ \
		fprintf(stderr, "%s ... ", #x); \
		fflush(stderr); \
		check_##x(); \
		fprintf(stderr, "done\n"); \
	} \
	NS_HANDLER \
	{ \
		fprintf(stderr, "failed with error: %s\n", \
				[[localException description] UTF8String]); \
		exit(1); \
	} \
	NS_ENDHANDLER \
	[p release]; 
#include "index.h"
#undef CHECK

        fprintf(stderr, "-- check complete without failures --\n");
	exit(0);
}
