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

#import "XCConfigurationList+ViewRelated.h"


@implementation XCConfigurationList (ViewRelated)

-(NSInteger)numberOfItemsInMenu:(NSMenu*)menu
{
    return buildConfigurations.count;
}

- (BOOL)menu:(NSMenu *)menu updateItem:(NSMenuItem *)item atIndex:(NSInteger)index shouldCancel:(BOOL)shouldCancel
{
    item.title = [[buildConfigurations objectAtIndex:index] description];
    item.target = self;
    item.tag = index;
    item.action = @selector(configurationSelected:);
    return YES;
}

- (void)configurationSelected:(id)sender
{
    NSLog(@"Selected %@", [buildConfigurations objectAtIndex:[sender tag]]);
}

@end
