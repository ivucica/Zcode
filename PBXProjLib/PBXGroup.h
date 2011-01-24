/*
   Project: Zcode

   Copyright (C) 2011 Free Software Foundation

   Author: Ivan Vucica,,,

   Created: 2011-01-01 20:31:02 +0100 by ivucica

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

#ifndef _PBXGROUP_H_
#define _PBXGROUP_H_

@class ProjectDocument;

#import <Foundation/Foundation.h>
@interface PBXGroup : NSObject
{
  ProjectDocument *ownerDocument;
  PBXGroup *ownerGroup;
  
  // children can be:
  // * PBXGroup
  // * PBXFileReference
  
  NSMutableArray *children_;
  NSString *name;
  NSString *sourceTree;
  
}

@property (assign) PBXGroup *ownerGroup;
@property (readwrite, retain) NSMutableArray *children;

-(NSString*)description;

@end

#endif // _PBXGROUP_H_

