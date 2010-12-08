/*
   Project: Zcode

   Copyright (C) 2010 Ivan Vucica

   Author: Ivan Vucica,,,

   Created: 2010-12-05 22:36:24 +0100 by ivucica

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

#import "ProjectDocument.h"
@implementation ProjectDocument

@synthesize groupsAndFilesView;

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
  toolbar = [[NSToolbar alloc] initWithIdentifier:@"toolbar"]; // FIXME toolbar must be inited only once.
  NSWindow* w = [self windowForSheet]; // FIXME is the right way to get NSWindow for this NSDocument?
  //[toolbar insertItemWithItemIdentifier:@"tb_build" atIndex:[[toolbar items] count]];
  [toolbar setDelegate:self];
  [w setToolbar:toolbar];
  //[window toggleToolbarShown:self];
  [toolbar setVisible:YES];
}


// an NSDocument must specify which nib file it uses
-(NSString*)windowNibName
{
  return @"ProjectDocument";
}

#pragma mark -
#pragma mark Project-related commands
-(IBAction)build:(id)sender
{
  NSLog(@"build");
}

#pragma mark -
#pragma mark Toolbar delegate
- (NSToolbarItem*)toolbar: (NSToolbar*)toolbar
    itemForItemIdentifier: (NSString*)itemIdentifier
willBeInsertedIntoToolbar: (BOOL)flag
{
  NSToolbarItem* ti = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
  [ti setLabel:@"Build"];
  [ti setPaletteLabel:@"Build"];
  [ti setToolTip:@"Build"];
  [ti setTarget:self];
  [ti setAction:@selector(build:)];
  NSSize sz = {48,48};
  [ti setMinSize:sz];
  [ti setImage:[[[NSImage alloc] initWithContentsOfFile:@"/usr/share/icons/gnome/48x48/actions/system-run.png"] autorelease]];

  return ti;
}
// required method
- (NSArray*) toolbarAllowedItemIdentifiers: (NSToolbar*)toolbar
{
  return [NSArray arrayWithObjects:@"build", nil];

}
// required method
- (NSArray*) toolbarDefaultItemIdentifiers: (NSToolbar*)toolbar
{
  return [NSArray arrayWithObjects:@"build", nil];

}


#pragma mark -
#pragma mark Outline view

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
  return 1;
}
- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
  NSLog(@"%s", __PRETTY_FUNCTION__);
  return @"Nerd";
}
- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
  NSLog(@"%s", __PRETTY_FUNCTION__);
  return NO;
}
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
  NSLog(@"%s", __PRETTY_FUNCTION__);
  return @"Herd";
}
- (void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
  // 
}

@end
