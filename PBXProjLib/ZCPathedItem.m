#import "ZCPathedItem.h"


@implementation ZCPathedItem

@synthesize owner = owner_;
@synthesize path = path_;
@synthesize sourceTree = sourceTree_;

-(NSString*)path
{
  // FIXME this also needs to decode certain build-time environment variables
  // sourceTree can contain environment variable name, e.g. "BUILT_PRODUCTS_DIR"
  if([self.sourceTree isEqualToString:@"<absolute>"])
    return path_;
  if([self.sourceTree isEqualToString:@"<group>"])
  {
    if (path_)
      return [[self.owner path] stringByAppendingPathComponent:path_];
    else
      return self.owner.path;
  }
  return self.owner.path;
}


@end
