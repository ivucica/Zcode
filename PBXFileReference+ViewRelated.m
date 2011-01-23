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

