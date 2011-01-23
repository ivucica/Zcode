/*
This file pulls the implementations of files missing from currently
installed GNUstep, but which we separately ship in gnustep_more/
directory.
*/

#import "config.h"

#if !HAVE_NSVIEWCONTROLLER_H
#import "gnustep_more/NSViewController.m"
#endif

