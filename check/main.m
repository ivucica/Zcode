#import <AppKit/AppKit.h>

#define CHECK(x) extern void check_##x();
#include "index.h"
#undef CHECK

int
main(int argc, const char *argv[])
{
#define CHECK(x) check_##x();
#include "index.h"
#undef CHECK
	exit(0);
}
