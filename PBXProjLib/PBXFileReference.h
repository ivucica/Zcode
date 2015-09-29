/*
 Project: Zcode
 
 Copyright (C) 2011 Ivan Vučica
 
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

#ifndef _PBXFILEREFERENCE_H_
#define _PBXFILEREFERENCE_H_

#import <Foundation/Foundation.h>
#import "ZCPathedItem.h"

@class ProjectDocument;
@class PBXGroup;
@interface PBXFileReference : ZCPathedItem
{
  NSString *name_; 
  NSInteger fileEncoding_;
  NSString *lastKnownFileType_;
  NSString *explicitFileType_;
  NSInteger includeInIndex_;
  NSInteger tabWidth_;
  NSInteger indentWidth_;
  NSString *comments_;
}

-(NSString*)description;

// TODO(ivucica): name might belong in ZCPathedItem et al
// TODO(ivucica): -description may want to use 'name'.
@property (readwrite, copy) NSString *name;
@property (readwrite, assign) NSInteger fileEncoding;
@property (readwrite, copy) NSString *lastKnownFileType;
@property (readwrite, copy) NSString *explicitFileType;
@property (readwrite, assign) NSInteger includeInIndex; // TODO(ivucica): this should default to 1
@property (readwrite, assign) NSInteger tabWidth;
@property (readwrite, assign) NSInteger indentWidth;
@property (readwrite, copy) NSString *comments;

@end

#endif // _PBXFILEREFERENCE_H_

