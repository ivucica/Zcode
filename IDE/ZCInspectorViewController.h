//
//  ZCInspectorViewController.h
//  Zcode
//
//  Created by Ivan Vučica on 25.03.2011..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#if GNUSTEP
#import "config.h"
#else
#define HAVE_NSVIEWCONTROLLER_H 1
#endif

#import <AppKit/AppKit.h>
#if !(HAVE_NSVIEWCONTROLLER_H)
#import "gnustep_more/AppKit/NSViewController.h"
#endif

@interface ZCInspectorViewController : NSViewController 
{
    
}

@end
