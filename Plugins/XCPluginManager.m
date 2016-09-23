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
#include "Builder/XCSpecification.h"

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

    /* n.b. searchPaths might be empty at this point if mainBundle is nil.
       this can happen if XCPluginManager's user is a tool and not an
       application. */
    // TODO(ivucica): consider replacing with [[NSFileManager defaultManager] URLsForDirectory:inDomains:].
    // TODO(ivucica): is this best way to obtain .../Library/Bundles?
    // TODO(ivucica): how about Library/Application Support/Zcode/PlugIns?
    // TODO(ivucica): prioritize out-of-app dirs?
    for (NSString * path in NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSAllDomainsMask, YES))
      {
	[searchPaths addObject: [path stringByAppendingPathComponent: @"Bundles"]];
      }

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
        NSArray *directory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:s error:NULL];
        for (NSString *item in directory)
	  {
            if ([extensions containsObject:[item pathExtension]])
	      {
		if (![self loadPluginBundle: [s stringByAppendingPathComponent: item]])
		  {
		    NSLog(@"failed to load %@", item);
		  }
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
  NSLog(@"Loading plugin %@", path);

  NSBundle *bundle = [NSBundle bundleWithPath:path];

  if(![bundle load])
    {
      NSLog(@"failed to load bundle %@", path);
      return NO;
    }

  // TODO: use +[XCSpecification specificationTypePathExtensions]?
  for (NSString* file in [bundle pathsForResourcesOfType:@"xcspec" inDirectory:nil])
    {
      // TODO: load specifications found in the bundle

      NSArray * allSpecs = [NSArray arrayWithContentsOfFile: file];
      if (![self _loadSpecsInArray: allSpecs])
	{
	  NSLog(@"Failed to load spec %@", file);
	  return NO;
	}
    }

  [plugins addObject:bundle];
  return YES;
}


-(BOOL) _loadSpecsInArray: (NSArray*) specs
{
  for (NSDictionary * spec in specs)
    {
      NSString * class_str = [spec objectForKey: @"Class"];
      if (!class_str)
	{
	  NSLog(@"no class property in spec");
	  return NO; /* abort loading any remaining spec */
	}
      /* TODO(ivucica): clean up already loaded specs? */

      Class cls = NSClassFromString(class_str);
      if (!cls)
	{
	  NSLog(@"no class %@", class_str);
	  return NO;
	}

      XCSpecification * specInstance = [[[cls alloc] initWithPropertyListDictionary: spec] autorelease];
      NSLog(@"loaded %@", specInstance.name);
    }
  return YES;
}
@end
