/*
 Project: Zcode
 
 Copyright (C) 2011 Ivan Vučica
 
 Author: Ivan Vucica
 
 Created: 2011-02-23 23:11:52 +0100 by ivucica
 
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

#import "XCConfigurationList.h"
#import "XCBuildConfiguration.h"

@implementation XCConfigurationList

@synthesize buildConfigurations;
@synthesize defaultConfigurationName;
@synthesize defaultConfigurationIsVisible;

@synthesize owner;

#if !GNUSTEP
-(id)copyWithZone:(NSZone*)zone
{
    return [self retain]; // faking because Cocoa NSMenu is for some reason copyWithZone'ing its items
}
#endif

-(NSString*)description
{
    return @"Configuration List";
}

-(void)setBuildConfigurations:(NSMutableArray *)_buildConfigurations
{
    [buildConfigurations autorelease];
    buildConfigurations = [_buildConfigurations retain];
    
    for (XCBuildConfiguration* bc in buildConfigurations)
    {
      [bc setOwner:self];
    }
}

@end
