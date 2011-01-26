/*
   Project: Zcode

   Copyright (C) 2011 Free Software Foundation

   Author: Ivan Vucica,,,

   Created: 2011-01-01 20:37:37 +0100 by ivucica

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

#ifndef _PBXFILEREFERENCE_H_
#define _PBXFILEREFERENCE_H_

#import <Foundation/Foundation.h>

@class ProjectDocument;
@class PBXGroup;
@interface PBXFileReference : NSObject
{
  PBXGroup *ownerGroup;
  
  NSInteger fileEncoding_;
  NSString *lastKnownFileType_;
  NSString *path_;
  NSString *sourceTree_;
}

-(NSString*)description;

@property (assign) PBXGroup *ownerGroup;
@property (readwrite, assign) NSInteger fileEncoding;
@property (readwrite, copy) NSString *lastKnownFileType;
@property (readwrite, copy) NSString *path;
@property (readwrite, copy) NSString *sourceTree;

- (NSString *)fullPath;

@end

#endif // _PBXFILEREFERENCE_H_

