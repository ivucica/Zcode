/*
   Project: Zcode

   Copyright (C) 2011 Free Software Foundation

   Author: Ivan Vucica,,,

   Created: 2011-01-01 20:37:37 +0100 by ivucica

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

#import "PBXFileReference.h"
#import "ProjectDocument.h"
#import "NSDictionary+SmartUnpack.h"
#import <AppKit/NSImage.h>
@implementation PBXFileReference
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
    
    
    path = [dict unpackObjectWithKey:@"path" forDocument:ownerDocument pbxDictionary:objects required:YES error:error];
    if(! path || ![path isKindOfClass:[NSString class]])
    {
      [self release];
      return nil;
    }
    [path retain];
    
    sourceTree = [dict unpackObjectWithKey:@"sourceTree" forDocument:ownerDocument pbxDictionary:objects required:YES error:error];
    if(! sourceTree || ![sourceTree isKindOfClass:[NSString class]])
    {
      [self release];
      return nil;
    }
    [sourceTree retain];
    
    
  }
  return self;
}


-(void)dealloc
{
  [path release];
  [super dealloc];
}


-(NSString*)fullPath
{
  if([sourceTree isEqualToString:@"<absolute>"])
    return path;
  if([sourceTree isEqualToString:@"<group>"])
  {
    return [[ownerGroup fullPath] stringByAppendingPathComponent:path];
  }

  return path;
}

#pragma mark -
#pragma mark For outline view
-(NSString*)description
{
  return path;
}

-(NSInteger)numberOfChildrenForOutlineView:(NSOutlineView*)outlineView
{
  return 0;
}
-(id)child:(NSInteger)index forOutlineView:(NSOutlineView*)outlineView
{
  return nil;
}
-(BOOL)isExpandableForOutlineView:(NSOutlineView*)outlineView
{
  return NO;
}


- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(NSCell*)cell forTableColumn:(NSTableColumn*)tableColumn
{
  [[cell image] release];
  //NSImage *img = [[NSImage alloc] initWithContentsOfFile:@"/usr/share/icons/gnome/48x48/actions/system-run.png"];
  
  NSLog(@"Fullpath: %@", [self fullPath]);
  NSImage *img = [[[NSWorkspace sharedWorkspace] iconForFile:[self fullPath]] retain];

  [img setScalesWhenResized:YES];
  [img setSize:NSMakeSize(16,16)];
  [cell setImage:img];
}
@end
