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
	check_##x(); \
	[p release]; 
#include "index.h"
#undef CHECK
	exit(0);
}
