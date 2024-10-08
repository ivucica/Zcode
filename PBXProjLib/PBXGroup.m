/*
 Project: Zcode
 
 Copyright (C) 2011 Ivan Vučica
 
 Author: Ivan Vučica
 
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
#import "PBXProject.h"
#import <unistd.h> // get_current_dir_name()
@implementation PBXGroup
@synthesize name = name_;

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

-(NSMutableArray *)children
{
  return children_;
}

-(void)setChildren:(NSMutableArray *)children
{
  [children_ autorelease];
  children_ = [children retain];
  for (id child in children_)
  {
    if ([child respondsToSelector:@selector(setOwner:)])
      [child setOwner:self];
  }
}


-(NSString*)description
{
  if([self.owner isKindOfClass:[PBXProject class]])
    return [[[self.owner fileName] lastPathComponent] stringByDeletingPathExtension];
  if (self.name)
    return self.name;
  return [[self path] lastPathComponent];
}

@end

