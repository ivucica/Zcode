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

#ifndef _PROJECTDOCUMENT_H_
#define _PROJECTDOCUMENT_H_

#import <AppKit/AppKit.h>
#import <AppKit/NSOutlineView.h>

@class PBXProject;
@class ProjectDetailListDataSource;

@interface ProjectDocument : NSDocument <NSToolbarDelegate>
//<NSOutlineViewDataSource> // GNUstep does not define this as a protocol
{
  ///////////////////////////////////////
  ////
  //// GUI AND GUI HELPERS ////
  ////
  IBOutlet NSOutlineView *groupsAndFilesView; // gui list of all project objects
  IBOutlet ProjectDetailListDataSource *projectDetailListDataSource;
  NSArray *gafContainers;

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
-(id)newObjectSpecifiedByISAWithPBXDictionary:(NSDictionary*)objects withKey:(NSString*)key required:(BOOL)required error:(NSError**)error;

@end

#endif // _PBXPROJECT_H_

