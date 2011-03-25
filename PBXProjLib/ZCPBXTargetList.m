/*
 Project: Zcode
 
 Copyright (C) 2011 Ivan Vucica
 
 Author: Ivan Vucica
 
 Created: 2011-02-10 17:08:55 +0100 by ivucica
 
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

#import "ZCPBXTargetList.h"


@implementation ZCPBXTargetList

@synthesize targetsArray = targets;

#if !GNUSTEP
-(id)copyWithZone:(NSZone*)zone
{
  return [self retain]; // faking because Cocoa NSOutlineView is for some reason copyWithZone'ing its items
}
#endif

-(id)initWithTargets:(NSMutableArray*)array
{
  if((self=[super init]))
  {
    targets = [array retain];
    NSLog(@"Targetlist");
  }
  return self;
}
-(void)addObject:(id)anObject
{
  [targets addObject:anObject];
}
-(int)count
{
  return targets.count;
}
-(id)objectAtIndex:(int)index
{
  return [targets objectAtIndex:index];
}
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len
{
  return [targets countByEnumeratingWithState:state objects:stackbuf count:len];
}
-(NSString*)description
{
  return @"Targets";
}

@end
