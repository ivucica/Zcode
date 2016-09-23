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

#import "PBXTarget.h"


@implementation PBXTarget

@synthesize name;
@synthesize productInstallPath;
@synthesize productName;
@synthesize productType;
@synthesize productReference;
@synthesize owner;
@synthesize buildConfigurationList;
@synthesize buildPhases;
@synthesize buildRules;
@synthesize dependencies;

#if !GNUSTEP
-(id)copyWithZone:(NSZone*)zone
{
  return [self retain]; // faking because Cocoa NSOutlineView is for some reason copyWithZone'ing its items
}
#endif

-(void)dealloc
{
  [name release];
  [productInstallPath release];
  [productName release];
  [productType release];
  [productReference release];
  [dependencies release];
  [buildPhases release];
  [buildConfigurationList release];
  [buildRules release];
  [super dealloc];
}

-(NSString*)description
{
  return name;
}
@end
