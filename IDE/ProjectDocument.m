/*
 Project: Zcode
 
 Copyright (C) 2010 Ivan Vučica
 
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

#import "ProjectDocument.h"
#import "GAFContainer.h"
#import "PBXProject.h"
#import "ProjectDetailListDataSource.h"
#import "ZCEditorViewController.h"
#import "ZCInspectorViewController.h"
#import "PBXProjLib/ZCPBXProjectReader.h"

#import "XCConfigurationList+ViewRelated.h"

#if !GNUSTEP 
#import <objc/runtime.h>
#endif

#if HAVE_NSTEXTUREDROUNDBEZELSTYLE
// older GNUstep have incorrectly named this enum member
#define NSTexturedRoundedBezelStyle NSTexturedRoundBezelStyle
#endif

@implementation ProjectDocument

@synthesize groupsAndFilesView;
@synthesize editorViewContainer;
@synthesize inspectorViewContainer;
@synthesize inspectorPanel;
@dynamic fileName_undeprecated;
#pragma mark -
#pragma mark Init and deinit

- (id)init
{
  if((self=[super init]))
  {
    pbxProject = [[PBXProject alloc] init];
    gafContainers = [[NSArray alloc] initWithObjects:[pbxProject mainGroup],
                                                     nil];
    editorViewController = [[ZCEditorViewController alloc] initWithNibName:@"ZCEditorViewController" bundle:nil];
    inspectorViewController = [[ZCInspectorViewController alloc] initWithNibName:@"ZCInspectorViewController" bundle:nil];
  }
  return self;
}

-(id)initWithContentsOfFile:(NSString*)file ofType:(NSString*)type
{
  // overriding this function solely so it doesn't call [self init]; we want
  // it to call [super init] so in case of creation of new document, we can
  // just initialize stuff in init without worrying loaded documents will have
  // to free stuff while loading in readFromURL:ofType:error:.
  //
  // that's the sole reason.
  
  if((self=[super init]))
  {
    NSError *error = nil;

    if([self readFromURL:[NSURL fileURLWithPath:file] ofType:type error:&error])
    {
      [self setFileName_undeprecated:file]; 
      editorViewController = [[ZCEditorViewController alloc] initWithNibName:@"ZCEditorViewController" bundle:nil];
      inspectorViewController = [[ZCInspectorViewController alloc] initWithNibName:@"ZCInspectorViewController" bundle:nil];
    }
    else
    {
      if(!error)
        error = [NSError errorWithDomain:NSOSStatusErrorDomain 
                                    code:0 // FIXME use correct key
                                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Unknown error loading pbxproj", NSLocalizedDescriptionKey,
#if !_WIN32
                                                                                    file, NSFilePathErrorKey,
#endif
                                                                                    @"Check that project's project.pbxproj exists, that it is not corrupted, and that it is generated by a supported version of Zcode and Xcode.", NSLocalizedRecoverySuggestionErrorKey,
                                                                                    nil]];
      [self presentError:error];
      
      [self release];
      return nil;
    }
    
  }
  
  return self;
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
  
  // FIXME is the right way to get NSWindow for this NSDocument?
  // it should be, at the moment. we probably have only one window controller at the moment.
  NSWindowController *wc = [[self windowControllers] objectAtIndex:0];
  NSWindow* w = [wc window]; 
  
  /////// WINDOW SETUP /////
  w.delegate = self;
  
  ////// TOOLBAR SETUP /////
  
  toolbar = [[NSToolbar alloc] initWithIdentifier:@"toolbar"]; // FIXME toolbar must be inited only once.
  //[toolbar insertItemWithItemIdentifier:@"tb_build" atIndex:[[toolbar items] count]];
  [toolbar setDelegate:self];
  [w setToolbar:toolbar];
  //[window toggleToolbarShown:self];
  [toolbar setVisible:YES];

  ////// INSPECTOR SETUP /////
  [inspectorPanel setFloatingPanel:YES];
  [inspectorPanel orderFront:nil];
  NSRect inspectorRect = NSZeroRect;
  if(inspectorViewContainer)
  {
    inspectorRect.size = inspectorViewContainer.frame.size;
    if(inspectorViewController)
    {
      if(inspectorViewController.view)
      {
        inspectorViewController.view.frame = inspectorRect;
        
        [inspectorViewContainer addSubview:inspectorViewController.view];
      }
      else
      {
        NSLog(@"Inspector view does not exist!");
      }
    }
    else
    {
      NSLog(@"Inspector view controller failed to load!");
    }
  }
  else
  {
    NSLog(@"Inspector panel does not exist!");
  }


  ////// EDITOR SETUP /////

  NSRect editorRect = NSZeroRect;
  if(editorViewContainer)
  {
    editorRect.size = editorViewContainer.frame.size;
    if(editorViewController)
    {
      if(editorViewController.view)
      {
        editorViewController.view.frame = editorRect;

        [editorViewContainer addSubview:editorViewController.view];
      }
      else
      {
        NSLog(@"Editor view does not exist!");
      }
    }
    else
    {
      NSLog(@"Editor view controller failed to load!");
    }
  }
  else
  {
    NSLog(@"Editor view container does not exist!");
  }
}

// an NSDocument must specify which nib file it uses
-(NSString*)windowNibName
{
  return @"ProjectDocument";
}

-(void)dealloc
{
  NSLog(@"PD dealloc");
  [toolbar release];
/*
#if GNUSTEP
  for(id container in gafContainers)
  {
    [container release];
  }
#endif
*/
  self.inspectorPanel = nil;
  self.inspectorViewContainer = nil;
  self.editorViewContainer = nil;
  [gafContainers release];
  [pbxProject release];
  [super dealloc];
}

#pragma mark -
#pragma mark Loading and saving

-(void)_handleIOError:(NSError**)error errorString:(NSString*)errStr
{

    if(error)
    {
      *error = [NSError errorWithDomain:NSOSStatusErrorDomain
                                   code:0 // FIXME use correct key
                               userInfo:[NSDictionary dictionaryWithObjectsAndKeys:errStr, NSLocalizedDescriptionKey,
#if !_WIN32
                                                                                   [self fileName_undeprecated], NSFilePathErrorKey,
#endif
                                                                                   @"Check that project's project.pbxproj is generated by a supported version of Zcode and Xcode.", NSLocalizedRecoverySuggestionErrorKey,
                                                                                   nil]];
    }
}

-(BOOL)readFromURL:(NSURL*)url ofType:(NSString*)type error:(NSError**)error
{
  NSString *path = [url path];
  NSString *pbxProjPath = [path stringByAppendingPathComponent:@"project.pbxproj"];

  [self setFileName_undeprecated:pbxProjPath];


  if(pbxProject)
    [pbxProject release];

  ZCPBXProjectReader *reader = [[[ZCPBXProjectReader alloc] initWithFile:pbxProjPath] autorelease];
  pbxProject = [reader.rootObject retain];
  if(reader.errorOccurred)
  {
    [self _handleIOError:error errorString:reader.errorMessage];
    return NO;
  }

  pbxProject.owner = self;

  [gafContainers release];
  gafContainers = [[NSArray alloc] initWithObjects:[pbxProject.mainGroup retain], 
                                                   [pbxProject.targetList retain], nil];

  return YES;
}

#pragma mark -
#pragma mark Project-related commands
-(IBAction)build:(id)sender
{
  NSLog(@"build");
}

#pragma mark -
#pragma mark Window delegate
- (void)windowDidBecomeMain:(NSNotification *)notification
{
  [inspectorPanel orderFront:nil];
}
-(void)windowDidResignMain:(NSNotification*)notification
{
  [inspectorPanel orderOut:nil];
}

#pragma mark -
#pragma mark Toolbar delegate
- (NSToolbarItem*)toolbar: (NSToolbar*)toolbar
    itemForItemIdentifier: (NSString*)itemIdentifier
willBeInsertedIntoToolbar: (BOOL)flag
{
  if([itemIdentifier isEqualToString:@"overview"])
  {
    NSToolbarItem* ti = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier] autorelease];
    [ti setLabel:@"Overview"];
    [ti setPaletteLabel:@"Overview"];  
    [ti setToolTip:@"Overview"];
/*
 // TODO this doesn't work and fails an assertion in Apple Cocoa
 // why?
    NSMenuItem *toolbarItemMenu = [[[NSMenuItem alloc] initWithTitle:@"Dummy" action:nil keyEquivalent:nil] autorelease];
    NSMenu* overviewMenu = [[[NSMenu alloc] initWithTitle:@"Menu"] autorelease];
    NSArray *configurations = [[[NSArray alloc] initWithObjects:@"Dummy 1", @"Dummy 2", nil] autorelease];
    for(id configuration in configurations)
    {
      [overviewMenu addItemWithTitle:configuration action:nil keyEquivalent:nil];
    }
    
    [ti setMenuFormRepresentation:toolbarItemMenu];
 */
    NSPopUpButton *pub = [[[NSPopUpButton alloc] initWithFrame:NSMakeRect(0, 0, 250, 24)] autorelease];
    [pub addItemsWithTitles:[NSArray arrayWithObjects:@"Overview", @"Active Configuration", nil]]; 
    [pub setBezelStyle:NSTexturedRoundedBezelStyle];
    [pub setPullsDown:YES];
    if ([[pub cell] respondsToSelector:@selector(setArrowPosition:)]) 
    {
      [[pub cell] setArrowPosition:NSPopUpArrowAtBottom];
    }
    else
    {
      NSLog(@"Warning! Overview popup's cell (in toolbar) does not respond to setArrowPosition");
    }
    
    NSMenu *activeConfigurationsMenu = [[[NSMenu alloc] initWithTitle:@"Active Configuration"] autorelease];
    if ([activeConfigurationsMenu respondsToSelector:@selector(setDelegate:)])
    {
      [activeConfigurationsMenu setDelegate:pbxProject.buildConfigurationList];
    }
    else
    {
      NSLog(@"Warning! activeConfigurationsMenu does not respond to setDelegate:");
    }
    [[[[pub cell] menu] itemAtIndex:1] setSubmenu:activeConfigurationsMenu];

    [ti setView:pub];
    
    return ti;
  }
  else if([itemIdentifier isEqualToString:@"build"])
  {
    NSToolbarItem* ti = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier] autorelease];
    [ti setLabel:@"Build"];
    [ti setPaletteLabel:@"Build"];
    [ti setToolTip:@"Build"];
    [ti setTarget:self];
    [ti setAction:@selector(build:)];
    NSSize sz = {48,48};
    [ti setMinSize:sz];  
    NSString *path = [[NSBundle mainBundle] pathForResource:@"build" ofType:@"png"];
    [ti setImage:[[[NSImage alloc] initWithContentsOfFile:path] autorelease]];
  
    return ti;
  }
  return nil;
}
// required method
- (NSArray*) toolbarAllowedItemIdentifiers: (NSToolbar*)toolbar
{
  return [NSArray arrayWithObjects:@"overview", @"build", nil];

}
// required method
- (NSArray*) toolbarDefaultItemIdentifiers: (NSToolbar*)toolbar
{
  return [NSArray arrayWithObjects:@"overview", @"build", nil];

}

#pragma mark -
#pragma mark Outline view

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
  if(item == nil)
  {
    return [gafContainers count];
  }
  if([item respondsToSelector:@selector(numberOfChildrenForOutlineView:)])
  {
    return [item numberOfChildrenForOutlineView:outlineView];
  }
  return 0;
}
- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
  return item;
}
- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
  if([item respondsToSelector:@selector(isExpandableForOutlineView:)])
  {
    return [item isExpandableForOutlineView:outlineView];
  }
  return NO;
}
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
  if(item == nil)
  {
    return [gafContainers objectAtIndex:index];
  }
  if([item respondsToSelector:@selector(child:forOutlineView:)])
  {
    return [item child:index forOutlineView:outlineView];
  }
  return nil;
}

- (void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)objectValue forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
  if(item == nil)
    return;
  if([item respondsToSelector:@selector(outlineView:setObjectValue:forTableColumn:)])
  {
    [(id
#if !GNUSTEP && !_WIN32
		    <NSOutlineViewDelegate>
#endif
		    )item outlineView:outlineView setObjectValue:objectValue forTableColumn:tableColumn];
  }
}


- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn*)tableColumn item:(id)item
{
  // FIXME some stuff should be queried if it wants editing right now
  // just asking if it responds to "update" function is not enough
  if(item == nil)
    return NO;
  return ([item respondsToSelector:@selector(outlineView:setObjectValue:forTableColumn:)]);
  
}

- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(NSCell*)cell forTableColumn:(NSTableColumn*)tableColumn item:(id)item
{

  if(item == nil)
    return;
    
  if([item respondsToSelector:@selector(outlineView:willDisplayCell:forTableColumn:)])
    [item outlineView:outlineView willDisplayCell:cell forTableColumn:tableColumn];
}
  
- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
  NSMutableArray *leafs = [[NSMutableArray alloc] init];
  id item = [groupsAndFilesView itemAtRow:[groupsAndFilesView selectedRow]];
  [item addLeafsToArray:leafs];
  projectDetailListDataSource.items = leafs;
  
  if (leafs.count == 1) {
	  [self switchEditor:item];
  }

  [self switchInspector:item];
}


#pragma mark -
#pragma mark Editor management
- (void)switchEditor:(id)item
{
  if(!editorViewContainer)
  {
    NSLog(@"Cannot switch editor, editor view container does not exist!");
    return;
  }
  [editorViewController.view removeFromSuperview];
  [editorViewController release];
  NSString *editorType = nil;
  if ([item respondsToSelector:@selector(desiredEditor)]) 
  {
    editorType = [item desiredEditor];
  }
  else
  {
    editorType = @"ZCEditorViewController";
  }
  
  Class classFromIsa;
  classFromIsa = NSClassFromString(editorType);

  editorViewController = [[classFromIsa alloc] initWithNibName:editorType bundle:nil];
  if(editorViewController)
  {
    [editorViewController setFileName:[item path]];
    [editorViewContainer addSubview:editorViewController.view];
    NSRect editorRect = NSZeroRect;
    editorRect.size = editorViewContainer.frame.size;
    editorViewController.view.frame = editorRect;
  }
  else
  {
    NSLog(@"Editor view controller %@ failed to load", editorType);
  }
}

#pragma mark -
#pragma mark Inspector management
- (void)switchInspector:(id)item
{
  if(!inspectorViewContainer)
  {
    NSLog(@"Cannot switch inspector, inspector panel does not exist!");
    return;
  }
  [inspectorViewController.view removeFromSuperview];
  [inspectorViewController release];
  NSString *inspectorType = nil;
  if ([item respondsToSelector:@selector(desiredInspector)]) 
  {
    inspectorType = [item desiredInspector];
  }
  else
  {
    inspectorType = @"ZCInspectorViewController";
  }

  Class classFromIsa;
  classFromIsa = NSClassFromString(inspectorType);
  
  inspectorViewController = [[classFromIsa alloc] initWithNibName:inspectorType bundle:nil];
  if(inspectorViewController)
  {
    [inspectorViewContainer addSubview:inspectorViewController.view];
    NSRect inspectorRect = NSZeroRect;
    inspectorRect.size = inspectorViewContainer.frame.size;
    inspectorViewController.view.frame = inspectorRect;
    
    inspectorViewController.item = item;
  }
  else
  {
    NSLog(@"Inspector view controller %@ failed to load", inspectorType);
  }
}



#pragma mark -
#pragma mark PBXPathedItem

- (NSString *)path
{
  return [[self fileName_undeprecated] stringByDeletingLastPathComponent];
}

#pragma mark -
#pragma mark Differences Cocoa/GNUstep (deprecations et al)

- (void)setFileName_undeprecated:(NSString *)fileName_undeprecated
{
#if GNUSTEP
  [self setFileName:fileName_undeprecated];
#else
  [self setFileURL:[NSURL fileURLWithPath:fileName_undeprecated]];
#endif
}

- (NSString*)fileName_undeprecated
{
#if GNUSTEP
  return [self fileName];
#else
  return [[self fileURL] path];
#endif
}

@end

