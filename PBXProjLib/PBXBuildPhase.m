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

#import "PBXBuildPhase.h"
#import "ProjectDocument.h"
@implementation PBXBuildPhase
@synthesize buildActionMask;
@synthesize files;
@synthesize inputPaths;
@synthesize outputPaths;
@synthesize name;
@synthesize runOnlyForDeploymentPostProcessing;

#if !GNUSTEP
-(id)copyWithZone:(NSZone*)zone
{
  return [self retain]; // faking because Cocoa NSOutlineView is for some reason copyWithZone'ing its items
}
#endif

-(void)dealloc
{
  self.buildActionMask = 0;
  self.files = nil;
  self.inputPaths = nil;
  self.outputPaths = nil;
  self.name = nil;
  self.runOnlyForDeploymentPostProcessing = 0;
  [super dealloc];
}

-(NSString*)description
{
  return self.name;
}

@end

