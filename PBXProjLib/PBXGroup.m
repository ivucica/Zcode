/*
   Project: Zcode

   Copyright (C) 2011 Ivan Vučica

   Author: Ivan Vucica,,,

   Created: 2011-01-01 20:31:02 +0100 by ivucica

   This application is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   This application is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with this application; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
*/

#import "PBXGroup.h"
#import "ProjectDocument.h"
#import <unistd.h> // get_current_dir_name()

@implementation PBXGroup
@synthesize owner = owner_;
@synthesize children = children_;
@synthesize name = name_;
@synthesize sourceTree = sourceTree_;

#if !GNUSTEP
-(id)copyWithZone:(NSZone*)zone
{
  return [self retain]; // faking because Cocoa NSOutlineView is for some reason copyWithZone'ing its items
}
#endif

-(void)dealloc
{
  self.children = nil;
  self.name = nil;
  self.sourceTree = nil;
  [super dealloc];

}

-(void)setChildren:(NSMutableArray *)children
{
  [children_ autorelease];
  children_ = [children retain];
  for (id child in children_)
  {
    if ([child respondsToSelector:@selector(setOwner:)])
    {
      NSLog(@"Setting %p owner to %p", child, self);
      [child setOwner:self];
    }
  }
}

-(NSString*)path
{
// FIXME sourceTree decoding should be a global utility function
// FIXME sourceTree can contain environment variable name, e.g. "BUILT_PRODUCTS_DIR"
  if([self.sourceTree isEqualToString:@"<absolute>"])
    return nil; // group cannot have an absolute path specified... hopefully
  if([self.sourceTree isEqualToString:@"<group>"])
    return [self.owner path];
  return self.sourceTree;
}

-(NSString*)description
{
  if (self.name)
    return self.name;
  return [[self path] lastPathComponent];
}

@end

