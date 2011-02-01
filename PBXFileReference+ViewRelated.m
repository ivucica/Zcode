/*
 Project: Zcode
 
 Copyright (C) 2011 Ivan Vučica
 
 Author: Ivan Vucica,,,
 
 Created: 2011-01-23 12:17:25 -0500 by eraserhd
 
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

#import <AppKit/AppKit.h>
#import "PBXFileReference.h"
#import "PBXFileReference+ViewRelated.h"

@implementation PBXFileReference (ViewRelated)

-(NSImage *)img
{
  NSImage *img = [[NSWorkspace sharedWorkspace] iconForFile:[self fullPath]];
  [img setScalesWhenResized:YES];
  [img setSize:NSMakeSize(16,16)];
  return img;
}

#pragma mark -
#pragma mark For outline view

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
  [[cell image] release]; // FIXME xcode's static analysis warns that we are releasing object which we don't own
  
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
  [leafs addObject:self];
}

@end

