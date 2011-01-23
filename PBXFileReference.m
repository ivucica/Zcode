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

#import "PBXFileReference.h"
#import "ProjectDocument.h"
#import "NSDictionary+SmartUnpack.h"
#import <AppKit/NSImage.h>
@implementation PBXFileReference
@synthesize ownerGroup;

-(id)initWithOwnerDocument:(ProjectDocument*)_ownerDocument
{
  if((self=[super init]))
  {
    ownerDocument = _ownerDocument;
  }
  return self;
}
-(id)initWithObjects:(NSDictionary*)objects ownKey:(NSString*)ownKey ownerDocument:(ProjectDocument*)_ownerDocument error:(NSError**)error
{
  if((self=[super init]))
  {
    ownerDocument = _ownerDocument;
    
    NSDictionary *dict = [objects objectForKey:ownKey];
    
    
    path = [dict unpackObjectWithKey:@"path" forDocument:ownerDocument pbxDictionary:objects required:YES error:error];
    if(! path || ![path isKindOfClass:[NSString class]])
    {
      [self release];
      return nil;
    }
    [path retain];
    
    sourceTree = [dict unpackObjectWithKey:@"sourceTree" forDocument:ownerDocument pbxDictionary:objects required:YES error:error];
    if(! sourceTree || ![sourceTree isKindOfClass:[NSString class]])
    {
      [self release];
      return nil;
    }
    [sourceTree retain];
    
    lastKnownFileType = [dict unpackObjectWithKey:@"lastKnownFileType" forDocument:ownerDocument pbxDictionary:objects required:NO error:error];
    if(! lastKnownFileType || ![lastKnownFileType isKindOfClass:[NSString class]])
    {
      NSLog(@"Guessing lastKnownFileType for %@", self);
      lastKnownFileType = @"sourcecode.c.objc";
    }
    [lastKnownFileType retain];
    
    
  }
  return self;
}

#if !GNUSTEP
-(id)copyWithZone:(NSZone*)zone
{
  return [self retain]; // faking because Cocoa NSOutlineView is for some reason copyWithZone'ing its items
}
#endif

-(void)dealloc
{
  [path release];
  [sourceTree release];
  [lastKnownFileType release];
  [super dealloc];
}


-(NSString*)fullPath
{
  if([sourceTree isEqualToString:@"<absolute>"])
  {
    return path;
  }
  if([sourceTree isEqualToString:@"<group>"])
  {
    return [[ownerGroup fullPath] stringByAppendingPathComponent:path];
  }

  return path;
}

-(NSString*)description
{
  return [path lastPathComponent];
}

-(NSString*)desiredEditor
{
  if([lastKnownFileType isEqualToString:@"sourcecode.c.objc"])
  {
    return @"ZCTextEditorViewController";
  }
  return @"ZCEditorViewController";
}

@end

