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

#ifndef _PROJECTDOCUMENT_H_
#define _PROJECTDOCUMENT_H_

#import <AppKit/AppKit.h>
#import <AppKit/NSOutlineView.h>
#import "PBXProjLib/ZCPathedItem.h"

@class PBXProject;
@class ProjectDetailListDataSource;
@class ZCEditorViewController;

@interface ProjectDocument : NSDocument <ZCPathedItem>
//<NSToolbarDelegate> // GNUstep does not define this as a protocol
//<NSOutlineViewDataSource> // GNUstep does not define this as a protocol
{
  ///////////////////////////////////////
  ////
  //// GUI AND GUI HELPERS ////
  ////
  IBOutlet NSOutlineView *groupsAndFilesView; // gui list of all project objects
  IBOutlet ProjectDetailListDataSource *projectDetailListDataSource;
  IBOutlet NSView *editorViewContainer;
  NSArray *gafContainers;
  ZCEditorViewController *editorViewController;

  // gorm does not support toolbar design. too bad. we'll build our own toolbar
  NSToolbar* toolbar; 
  
  
  //////////////////////////////
  ////
  //// MODEL ////
  ////
  
  PBXProject* pbxProject;
}

@property (assign, nonatomic) IBOutlet NSOutlineView *groupsAndFilesView;

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item;

@end

#endif // _PBXPROJECT_H_

