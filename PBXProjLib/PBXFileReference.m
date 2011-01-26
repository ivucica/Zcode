/*
   Project: Zcode

   Copyright (C) 2011 Ivan Vučica

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

#import "PBXFileReference.h"
#import "ProjectDocument.h"
#import <AppKit/NSImage.h>
@implementation PBXFileReference
@synthesize ownerGroup;
@synthesize fileEncoding = fileEncoding_;
@synthesize lastKnownFileType = lastKnownFileType_;
@synthesize path = path_;
@synthesize sourceTree = sourceTree_;

#if !GNUSTEP
-(id)copyWithZone:(NSZone*)zone
{
  return [self retain]; // faking because Cocoa NSOutlineView is for some reason copyWithZone'ing its items
}
#endif

-(void)dealloc
{
  self.path = nil;
  self.sourceTree = nil;
  self.lastKnownFileType = nil;
  [super dealloc];
}


-(NSString*)fullPath
{
  if([self.sourceTree isEqualToString:@"<absolute>"])
  {
    return self.path;
  }
  if([self.sourceTree isEqualToString:@"<group>"])
  {
    return [[ownerGroup fullPath] stringByAppendingPathComponent:self.path];
  }

  return self.path;
}

-(NSString*)description
{
  return [self.path lastPathComponent];
}

-(NSString*)desiredEditor
{
  if([self.lastKnownFileType isEqualToString:@"sourcecode.c.objc"])
  {
    return @"ZCTextEditorViewController";
  }
  return @"ZCEditorViewController";
}

@end

