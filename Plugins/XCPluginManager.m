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

#include "XCPluginManager.h"
static XCPluginManager* pluginManager = nil;

@implementation XCPluginManager

+(XCPluginManager*)sharedPluginManager;
{
    if(!pluginManager)
        pluginManager = [XCPluginManager new];
    return pluginManager;
}
-(id)init
{
    self = [super init];
    if(!self)
        return nil;
    
    searchPaths = [[NSMutableArray alloc] initWithObjects:
                   [[NSBundle mainBundle] builtInPlugInsPath],
                   [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent],
                   nil];
    
    extensions = [[NSSet alloc] initWithObjects:@"zcplugin", nil];
    
    plugins = [[NSMutableArray alloc] init];
    return self;
}
-(void)dealloc
{
    [searchPaths release];
    [plugins release];
    [extensions release];
    [super dealloc];
}

-(void)findAndLoadPlugins;
{
    for (NSString* s in searchPaths) 
    {
        NSArray *directory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:s error:nil];
        for (NSString *item in directory) 
        {
            if ([extensions containsObject:[item pathExtension]]) 
            {
                [self loadPluginBundle:item];
            }
        }
    }
}
-(NSArray*)loadedPlugins
{
    return plugins;
}
-(BOOL)loadPluginBundle:(NSString *)path
{
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    
    if([bundle load])
    {
        [plugins addObject:bundle];
        return YES;
    }
    
    [plugins release];
    return NO;
}
@end