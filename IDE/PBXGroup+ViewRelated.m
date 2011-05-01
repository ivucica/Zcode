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

#import "PBXGroup+ViewRelated.h"
#import <AppKit/AppKit.h>
#import "PBXProject.h"

@implementation PBXGroup (ViewRelated)

-(NSImage *)img
{
  NSImage *img;
  
  if([self.owner isKindOfClass:[PBXProject class]])
  {
    img = [[NSWorkspace sharedWorkspace] iconForFile:[(PBXProject*)self.owner fileName]];
    //[(PBXProject*)self.owner img];
  }
  else
  {
    #if GNUSTEP || _WIN32
    img = [NSImage imageNamed:@"common_Folder"];
    #else
    img = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kGenericFolderIcon)];
    #endif
  }
  [img setScalesWhenResized:YES];
  [img setSize:NSMakeSize(16,16)];
  return img;
}

#pragma mark -
#pragma mark For outline view


-(NSInteger)numberOfChildrenForOutlineView:(NSOutlineView*)outlineView
{
  return [self.children count];
}
-(id)child:(NSInteger)index forOutlineView:(NSOutlineView*)outlineView
{
  return [self.children objectAtIndex:index];
}
-(BOOL)isExpandableForOutlineView:(NSOutlineView*)outlineView
{
  return YES;
}
-(void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn
{
// FIXME check if 'object' is string, etc
  self.name = object;
}
- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(NSCell*)cell forTableColumn:(NSTableColumn*)tableColumn
{
  //[[cell image] release]; // FIXME xcode static analysis says we should not do this
  [cell setImage:[[self img] retain]];
}

#pragma mark -
#pragma mark For table view


// FIXME Why needed? This should never be displayed in table view!
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
  for(id child in self.children)
  {
    [child addLeafsToArray:leafs];
  }
}

@end

