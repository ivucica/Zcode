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

#ifndef _PROJECTDOCUMENT_H_
#define _PROJECTDOCUMENT_H_

#import <AppKit/AppKit.h>
#import <AppKit/NSOutlineView.h>
#import "PBXProjLib/ZCPathedItem.h"

@class PBXProject;
@class ProjectDetailListDataSource;
@class ZCEditorViewController;
@class ZCInspectorViewController;

@interface ProjectDocument : NSDocument
#if !GNUSTEP
<NSToolbarDelegate, NSOutlineViewDelegate, NSWindowDelegate> // GNUstep does not define these as a protocol
#endif
{
  ///////////////////////////////////////
  ////
  //// GUI AND GUI HELPERS ////
  ////
  IBOutlet NSOutlineView *groupsAndFilesView; // gui list of all project objects
  IBOutlet ProjectDetailListDataSource *projectDetailListDataSource;
  IBOutlet NSView *editorViewContainer;
  IBOutlet NSView *inspectorViewContainer;
  IBOutlet NSPanel *inspectorPanel;

  NSArray *gafContainers;
  ZCEditorViewController *editorViewController;
  ZCInspectorViewController *inspectorViewController;

  // gorm does not support toolbar design. too bad. we'll build our own toolbar
  NSToolbar* toolbar; 
  
  
  //////////////////////////////
  ////
  //// MODEL ////
  ////
  
  PBXProject* pbxProject;
}

@property (assign, nonatomic) IBOutlet NSOutlineView *groupsAndFilesView;
@property (assign, nonatomic) IBOutlet NSView *editorViewContainer;
@property (assign, nonatomic) IBOutlet NSView *inspectorViewContainer;
@property (assign, nonatomic) IBOutlet NSPanel *inspectorPanel;
@property (retain, nonatomic) NSString *fileName_undeprecated;
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item;

- (void)switchEditor:(id)item;
- (void)switchInspector:(id)item;
@end

#endif // _PBXPROJECT_H_

