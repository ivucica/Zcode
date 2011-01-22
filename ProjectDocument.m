/*
   Project: Zcode

   Copyright (C) 2010 Ivan Vucica

   Author: Ivan Vucica,,,

   Created: 2010-12-05 22:36:24 +0100 by ivucica

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
#import "NSDictionary+SmartUnpack.h"
#import "ProjectDetailListDataSource.h"
#import "ZCEditorViewController.h"

#if !GNUSTEP
#import <objc/runtime.h>
#endif

@implementation ProjectDocument

@synthesize groupsAndFilesView;

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
      [self setFileName:file];
      editorViewController = [[ZCEditorViewController alloc] initWithNibName:@"ZCEditorViewController" bundle:nil];
    }
    else
    {
      if(!error)
        error = [NSError errorWithDomain:NSOSStatusErrorDomain 
                                    code:0 // FIXME use correct key
                                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Unknown error loading pbxproj", NSLocalizedDescriptionKey,
                                                                                    file, NSFilePathErrorKey,
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
  toolbar = [[NSToolbar alloc] initWithIdentifier:@"toolbar"]; // FIXME toolbar must be inited only once.
  NSWindow* w = [self windowForSheet]; // FIXME is the right way to get NSWindow for this NSDocument?
  //[toolbar insertItemWithItemIdentifier:@"tb_build" atIndex:[[toolbar items] count]];
  [toolbar setDelegate:self];
  [w setToolbar:toolbar];
  //[window toggleToolbarShown:self];
  [toolbar setVisible:YES];

  CGRect editorRect = CGRectZero;
  editorRect.size = editorViewContainer.frame.size;
  editorViewController.view.frame = editorRect;

  [editorViewContainer addSubview:editorViewController.view];
}


// an NSDocument must specify which nib file it uses
-(NSString*)windowNibName
{
  return @"ProjectDocument";
}

-(void)dealloc
{
  [toolbar release];
#if GNUSTEP
  for(id container in gafContainers)
  {
    [container release];
  }
#endif
  [editorViewController release];
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
                                                                                   [self fileName], NSFilePathErrorKey,
                                                                                   @"Check that project's project.pbxproj is generated by a supported version of Zcode and Xcode.", NSLocalizedRecoverySuggestionErrorKey,
                                                                                   nil]];
    }
}

-(BOOL)readFromURL:(NSURL*)url ofType:(NSString*)type error:(NSError**)error
{
  NSString *path = [url path];
  NSString *pbxProjPath = [path stringByAppendingPathComponent:@"project.pbxproj"];

  [self setFileName:pbxProjPath];
/*
// This doesnt work on GNUstep.
// TODO check why

  NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:pbxProjPath];
  NSLog(@"Dict %@ from file %@", dict, pbxProjPath);
  
          NSData *data = [NSData dataWithContentsOfFile:pbxProjPath];
        NSKeyedUnarchiver *kua;
        @try {
                kua = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        }
        @catch (NSException * e) {
                return NO;
        }
        @finally {
                
        }
        if(!kua)
                return NO;
        
        id obj = [kua decodeObject];
        
        NSLog(@"obj: %@", obj);
  */    
    
  NSString* errstr = nil;
  NSData *data = [NSData dataWithContentsOfFile:pbxProjPath];

  id plist = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:0 format:0 errorDescription:&errstr];

  if(!plist)
  {
    // errstr is already filled
    [self _handleIOError:error errorString:errstr];

    return NO;
  }
  
  //////////////////////
  NSInteger archiveVersion = [[plist objectForKey:@"archiveVersion"] intValue];
  if(archiveVersion != 1)
  {  
    [self _handleIOError:error errorString:[NSString stringWithFormat:@"Unsupported archive version: %d", archiveVersion]];

    return NO;
  }
  
  ////////////////////////
  NSInteger objectVersion = [[plist objectForKey:@"objectVersion"] intValue];
  if(objectVersion != 45)
  {
    NSLog(@"Zcode is only verified to load pbxproj plists of objectVersion 45; currently loading %d", objectVersion);
  }
  
  /////////////////////////
  NSDictionary* objects = [plist objectForKey:@"objects"];
  errstr = nil;
  if(!objects)
    errstr = @"'objects' is nil";
  else if (![objects isKindOfClass:[NSDictionary class]])
    errstr = @"'objects' is not a dictionary";
  if(errstr)
  {
    [self _handleIOError:error errorString:errstr];

    return NO;
  }
  
  ///////////////////
  NSString* rootObject = [plist objectForKey:@"rootObject"];
  errstr = nil;
  if(!rootObject)
    errstr = @"'rootObject' specifier is nil";
  else if (![rootObject isKindOfClass:[NSString class]])
    errstr = @"'rootObject' specifier is not a string";
  if(errstr)
  {
    [self _handleIOError:error errorString:errstr];
    return NO;
  }  
  
  //////////////////////////
  if(pbxProject)
    [pbxProject release];
  pbxProject = [self newObjectSpecifiedByISAWithPBXDictionary:objects withKey:rootObject required:YES error:error];
  if(! pbxProject)
  {
    if(error && *error)
      return NO; // return immediately, dont overwrite error string since it probably contains more useful info already
    else
      errstr = @"Root object is nil";
  }
  else if (![pbxProject isKindOfClass:[PBXProject class]])
    errstr = @"Root object is not a PBXProject";
  if(errstr)
  {
    [self _handleIOError:error errorString:errstr];
    return NO;
  }
    
  [gafContainers release];
  gafContainers = [[NSArray alloc] initWithObjects:[pbxProject.mainGroup retain], nil];
  return YES;
}

-(id)newObjectSpecifiedByISAWithPBXDictionary:(NSDictionary*)objects withKey:(NSString*)key required:(BOOL)required error:(NSError**)error
{
  NSString *filename = [self fileName];
  NSDictionary *dict = [objects objectForKey:key];
  NSString *errstr = nil;

  if(!dict)
    errstr = [NSString stringWithFormat:@"'%@' dict is nil", key];
  else if (![dict isKindOfClass:[NSDictionary class]])
    errstr = [NSString stringWithFormat:@"'%@' is not a dictionary", key];
      
  if(errstr)
  {
    if(required)
    {
      [self _handleIOError:error errorString:errstr];
    }
    return nil;
  }  

  //////////
  errstr = nil;
  NSString *isaStr = [dict objectForKey:@"isa"];
  if(!isaStr)
    errstr = [NSString stringWithFormat:@"%@'s 'isa' is nil", key];
  else if (![isaStr isKindOfClass:[NSString class]])
    errstr = [NSString stringWithFormat:@"%@'s 'isa' is not a string", key];
  
  if(errstr)
  {
    if(required)
    {
      [self _handleIOError:error errorString:errstr];
    }
    return nil;
  }  
  ////////////
  Class classFromIsa;
#if GNUSTEP
  classFromIsa = objc_lookup_class([isaStr UTF8String]);
#else
  classFromIsa = objc_lookUpClass([isaStr UTF8String]);
#endif
  if(!classFromIsa)
    errstr = [NSString stringWithFormat:@"Zcode's internal class '%@' does not exist", isaStr];
  if(errstr)
  {
    if(required)
    {
      [self _handleIOError:error errorString:errstr];  
    }
    return nil;
  }  
  
  
  //////////////
  id instanceFromIsa = [classFromIsa alloc];
  if(![instanceFromIsa respondsToSelector:@selector(initWithObjects:ownKey:ownerDocument:error:)])
    errstr = [NSString stringWithFormat:@"Zcode's internal class '%@' does not respond to initialization selector", isaStr];
  if(errstr)
  {
    if(required)
    {
      [self _handleIOError:error errorString:errstr]; 
    }
    [instanceFromIsa release];
    return nil;
  }  
    
    
  return [instanceFromIsa initWithObjects:objects ownKey:key ownerDocument:self error:error];
  
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
  NSToolbarItem* ti = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier] autorelease];
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
    [item outlineView:outlineView setObjectValue:objectValue forTableColumn:tableColumn];
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
}


#pragma mark -
#pragma mark Editor management
- (void)switchEditor:(id)item
{
  [editorViewController.view removeFromSuperview];
  [editorViewController release];
  NSString *editorType = [item desiredEditor];
  
  Class classFromIsa;
#if GNUSTEP
  classFromIsa = objc_lookup_class([editorType UTF8String]);
#else
  classFromIsa = objc_lookUpClass([editorType UTF8String]);
#endif

  editorViewController = [[classFromIsa alloc] initWithNibName:editorType bundle:nil];
  [editorViewContainer addSubview:editorViewController.view];
  
  CGRect editorRect = CGRectZero;
  editorRect.size = editorViewContainer.frame.size;
  editorViewController.view.frame = editorRect;

}
@end
