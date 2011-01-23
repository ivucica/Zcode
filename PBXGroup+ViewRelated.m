#import "PBXGroup+ViewRelated.h"
#import <AppKit/AppKit.h>

@implementation PBXGroup (ViewRelated)

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

