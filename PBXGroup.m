/*
   Project: Zcode

   Copyright (C) 2011 Free Software Foundation

   Author: Ivan Vucica,,,

   Created: 2011-01-01 20:31:02 +0100 by ivucica

   This application is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This application is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111 USA.
*/

#import "PBXGroup.h"
#import "ProjectDocument.h"
#import "NSDictionary+SmartUnpack.h"
#import <unistd.h> // get_current_dir_name()

@implementation PBXGroup
@synthesize ownerGroup;

-(id)initWithOwnerDocument:(ProjectDocument*)_ownerDocument
{
  if((self=[super init]))
  {
    ownerDocument = _ownerDocument;
  }
  return self;
}
-(id)initWithObjects:(NSDictionary*)objects ownKey:(NSString*)ownKey ownerDocument:(ProjectDocument*)_ownerDocument error:(NSError**)error
{
  if((self=[super init]))
  {
    ownerDocument = _ownerDocument;
    
    NSDictionary *dict = [objects objectForKey:ownKey];
    
    // FIXME not required! if it doesnt exist, extract from path
    name = [dict unpackObjectWithKey:@"name" forDocument:ownerDocument pbxDictionary:objects required:NO error:error];
    if(!name || ![name isKindOfClass:[NSString class]])
    {
      [name release]; // ensure it's nill, and fill out below
      name = nil;
	  
    }
    [name retain];
    
    
    
    children = [dict unpackObjectWithKey:@"children" forDocument:ownerDocument pbxDictionary:objects required:YES error:error];
    if(! children || ![children isKindOfClass:[NSArray class]])
    {
      [self release];
      return nil;
    }
    NSMutableArray *unpackedChildren = [[NSMutableArray alloc] init];
    for(NSString* childId in children)
    {
      if([childId isKindOfClass:[NSString class]])
      {
        id child = [[ownerDocument newObjectSpecifiedByISAWithPBXDictionary:objects withKey:childId required:YES error:error] autorelease];

        //[dict unpackObjectWithKey:childId forDocument:ownerDocument pbxDictionary:objects required:YES error:error];
        if(child)
        {
          [child setOwnerGroup:self];
          [unpackedChildren addObject:child];
        } else 
        {
          [unpackedChildren release];
          
          [self release];
          return nil;
        }
      }
      else
      {
        [unpackedChildren release];
        [self release];
        return nil;
      }
    }
    children = unpackedChildren;
    
    
    
    sourceTree = [dict unpackObjectWithKey:@"sourceTree" forDocument:ownerDocument pbxDictionary:objects required:NO error:error];
    if(!sourceTree || ![sourceTree isKindOfClass:[NSString class]])
    {
      NSLog(@"in a pbxgroup, no sourcetree specified, setting default <group>");
      sourceTree = @"<group>";
    }
    [sourceTree retain];
    
	
	
    // with sourceTree, we have enough info to fill out 'name'
    if(!name)
    {
      name = [[[self fullPath] lastPathComponent] retain];
    }
  }
  return self;
}

#if !GNUSTEP
-(id)copyWithZone:(NSZone*)zone
{
  return [self retain]; // faking because Cocoa NSOutlineView is for some reason copyWithZone'ing its items
}
#endif

-(void)dealloc
{
  [children release];
  [name release];
  [sourceTree release];
  [super dealloc];

}


-(NSString*)fullPath
{
// FIXME sourceTree decoding should be a global utility function
// FIXME sourceTree can contain environment variable name, e.g. "BUILT_PRODUCTS_DIR"
  if([sourceTree isEqualToString:@"<absolute>"])
    return nil; // group cannot have an absolute path specified... hopefully
  if([sourceTree isEqualToString:@"<group>"])
    if(ownerGroup)
      return [ownerGroup fullPath];
    else
    { // mainGroup does not have an owner
      return [[ownerDocument fileName] stringByDeletingLastPathComponent];
      //return [cwd stringByAppendingPathComponent];
    }
  return sourceTree;
}

-(NSString*)description
{
  return name;
}
-(NSImage *)img
{
  NSImage *img;
  #if GNUSTEP
  img = [NSImage imageNamed:@"common_Folder"];
  #else
  img = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kGenericFolderIcon)];
  #endif
  [img setScalesWhenResized:YES];
  [img setSize:NSMakeSize(16,16)];
  return img;
}

#pragma mark -
#pragma mark For outline view


-(NSInteger)numberOfChildrenForOutlineView:(NSOutlineView*)outlineView
{
  return [children count];
}
-(id)child:(NSInteger)index forOutlineView:(NSOutlineView*)outlineView
{
  return [children objectAtIndex:index];
}
-(BOOL)isExpandableForOutlineView:(NSOutlineView*)outlineView
{
  return YES;
}
-(void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn
{
// FIXME check if 'object' is string, etc
  [name release];
  name = [object retain];
}
- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(NSCell*)cell forTableColumn:(NSTableColumn*)tableColumn
{
  [[cell image] release]; // FIXME xcode static analysis says we should not do this
  [cell setImage:[[self img] retain]];
}

#pragma mark -
#pragma mark For table view
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn
{
  if([[tableColumn identifier] isEqualToString:@"Icon"])
  {
    return [[self img] retain];
  }
  
  if([[tableColumn identifier] isEqualToString:@"File Name"])
  {
    return [self description];
  }
  
  return nil;
}

- (void)addLeafsToArray:(NSMutableArray*)leafs
{
  for(id child in children)
  {
    [child addLeafsToArray:leafs];
  }
}

@end
