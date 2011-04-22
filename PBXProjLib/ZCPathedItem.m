#import "ZCPathedItem.h"


@implementation ZCPathedItem

@synthesize owner = owner_;
@synthesize path = path_;
@synthesize sourceTree = sourceTree_;

// FIXME consider renaming "path" into "fullPath"
// this should be done to leave "path" as a relative path,
// and nothing else.
-(NSString*)path
{
  // FIXME this also needs to decode certain build-time environment variables
  // sourceTree can contain environment variable name, e.g. "BUILT_PRODUCTS_DIR"
  if([self.sourceTree isEqualToString:@"<absolute>"])
  {
    return path_;
  }
  
  if([self.sourceTree isEqualToString:@"<group>"] && self.owner.path)
  {
    if (path_)
    {
      return [[self.owner path] stringByAppendingPathComponent:path_];
    }
    else
    {
      return self.owner.path;
    }
  }
  return path_;
}

@end
