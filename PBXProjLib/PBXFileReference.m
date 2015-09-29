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

#import "PBXFileReference.h"
#import "ProjectDocument.h"
#import <AppKit/NSImage.h>
@implementation PBXFileReference
@synthesize name = name_;
@synthesize fileEncoding = fileEncoding_;
@synthesize lastKnownFileType = lastKnownFileType_;
@synthesize explicitFileType = explicitFileType_;
@synthesize includeInIndex = includeInIndex_;
@synthesize tabWidth = tabWidth_;
@synthesize indentWidth = indentWidth_;
@synthesize comments = comments_;

#if !GNUSTEP
-(id)copyWithZone:(NSZone*)zone
{
  return [self retain]; // faking because Cocoa NSOutlineView is for some reason copyWithZone'ing its items
}
#endif

-(void)dealloc
{
  self.name = nil;
  self.path = nil;
  self.sourceTree = nil;
  self.lastKnownFileType = nil;
  self.explicitFileType = nil;
  self.comments = nil;
  [super dealloc];
}

/*
-(NSString*)path
{
  if([self.sourceTree isEqualToString:@"<absolute>"])
  {
    return path_;
  }
  if([self.sourceTree isEqualToString:@"<group>"])
  {
    return [[owner_ path] stringByAppendingPathComponent:path_];
  }

  return path_;
}
*/

-(NSString*)description
{
  if (name_)
    return self.name;

  return [self.path lastPathComponent];
}

-(NSString*)desiredEditor
{
  NSString *fileType = nil;
  if(self.explicitFileType)
    fileType = self.explicitFileType;
  else if(self.lastKnownFileType)
    fileType = self.lastKnownFileType;
  
  if([fileType isEqualToString:@"sourcecode.c.objc"])
    return @"ZCTextEditorViewController";
    
  if([fileType length] >= 10 && [[fileType substringToIndex:10] isEqualToString:@"sourcecode"]) // strlen("sourcecode")
    return @"ZCTextEditorViewController";
    
  return @"ZCEditorViewController";
}

@end

