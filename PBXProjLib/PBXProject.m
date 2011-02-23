/*
   Project: Zcode

   Copyright (C) 2011 Ivan Vučica

   Author: Ivan Vucica

   Created: 2011-01-01 18:20:47 +0100 by ivucica

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

#import <AppKit/NSOutlineView.h>
#import "PBXProject.h"
#import "ProjectDocument.h"
#import "PBXGroup.h"
#import "ZCPBXTargetList.h"

@implementation PBXProject

@synthesize buildConfigurationList;

-(PBXGroup *)mainGroup
{
  return mainGroup_;
}

-(void)setMainGroup:(PBXGroup *)mainGroup
{
  [mainGroup_ autorelease];
  mainGroup_ = [mainGroup retain];
  [mainGroup_ setOwner:self];
}


-(NSMutableArray *)targets
{
  return targets_;
}

-(void)setTargets:(NSMutableArray *)targets
{
  NSLog(@"Targets");
  [targets_ autorelease];
  NSLog(@"initWithArray %@", [targets class]);
  
  // I couldn't get this to work:
  /*
  NS_DURING
  {
    targets_ = [[ZCPBXTargetList alloc] initWithArray:targets copyItems:NO];
  }
  NS_HANDLER
  {
    NSLog(@":( %@", [localException name]);
    return;
  }
  NS_ENDHANDLER
  */
  
  // So let's try it somewhat different:
  targets_ = [[ZCPBXTargetList alloc] initWithTargets:targets];
  /*for(id i in targets)
  {
    [targets_ addObject:i];
  }*/
  // Ok, let's move on.
  
  
  for (id target in targets_)
  {
    if ([target respondsToSelector:@selector(setOwner:)])
      [target setOwner:self];
  }
}



#if !GNUSTEP
-(id)copyWithZone:(NSZone*)zone
{
  return [self retain]; // faking because Cocoa NSOutlineView is for some reason copyWithZone'ing its items
}
#endif

-(void)dealloc
{
  //[buildConfigurationList release];
  [compatibilityVersion release];
  [developmentRegion release];
  [knownRegions release];
  self.mainGroup = nil;
  [projectDirPath release];
  [projectRoot release];
  [targets_ release];
  [super dealloc ];
}

-(NSString*)description
{
  return [NSString stringWithFormat:
  @"\n"
  "PBXProject at 0x%p:\n"
  //"- buildConfigurationList: %@\n"
  "- compatibilityVersion: %@\n"
  "- developmentRegion: %@\n"
  "- hasScannedForEncodings: %s\n"
  "- knownRegions: (count: %d)\n",
  self, 
  //buildConfigurationList, 
  compatibilityVersion, 
  developmentRegion,
  hasScannedForEncodings ? "YES" : "NO",
  [knownRegions count]];
}

- (NSString *)path
{
  return [self.owner path];
}

@end
