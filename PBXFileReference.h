/*
   Project: Zcode

   Copyright (C) 2011 Free Software Foundation

   Author: Ivan Vucica,,,

   Created: 2011-01-01 20:37:37 +0100 by ivucica

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

#ifndef _PBXFILEREFERENCE_H_
#define _PBXFILEREFERENCE_H_

#import <Foundation/Foundation.h>

@class ProjectDocument;
@interface PBXFileReference : NSObject
{
  ProjectDocument *ownerDocument;
  
  NSInteger fileEncoding;
  NSString *lastKnownFileType;
  NSString *path;
  NSString *sourceTree;
}

@end

#endif // _PBXFILEREFERENCE_H_

