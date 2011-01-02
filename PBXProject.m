/*
   Project: Zcode

   Copyright (C) 2011 Free Software Foundation

   Author: Ivan Vucica,,,

   Created: 2011-01-01 18:20:47 +0100 by ivucica

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

#import "PBXProject.h"
#import "ProjectDocument.h"
#import "NSDictionary+SmartUnpack.h"
#import "PBXGroup.h"

@implementation PBXProject

@synthesize mainGroup;

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
    
    /*buildConfigurationsList = [dict unpackObjectWithKey:@"buildConfigurationsList" forDocument:ownerDocument pbxDictionary:objects required:YES error:error];
    if(!buildConfigurationsList || ![buildConfigurationsList isKindOfClass:[XCConfigurationList class]])
    {
    // FIXME set error text here
      [self release];
      return nil;
    }*/
    
    compatibilityVersion = [dict unpackObjectWithKey:@"compatibilityVersion" forDocument:ownerDocument pbxDictionary:objects required:NO error:error];
    if(!compatibilityVersion)
    {
      compatibilityVersion = @"Xcode 3.1";
    }
    [compatibilityVersion retain];
    
    developmentRegion = [dict unpackObjectWithKey:@"developmentRegion" forDocument:ownerDocument pbxDictionary:objects required:NO error:error];
    if(!developmentRegion)
    {
      developmentRegion = @"English";
    }
    [developmentRegion retain];
    
    hasScannedForEncodings = [[dict unpackObjectWithKey:@"hasScannedForEncodings" forDocument:ownerDocument pbxDictionary:objects required:NO error:error] integerValue] == 1;
    
    knownRegions = [dict unpackObjectWithKey:@"knownRegions" forDocument:ownerDocument pbxDictionary:objects required:NO error:error];
    if(!knownRegions)
    {
      knownRegions = [NSArray arrayWithObjects:@"English", nil];
    }
    [knownRegions retain];
    
    mainGroup = [dict unpackObjectWithKey:@"mainGroup" forDocument:ownerDocument pbxDictionary:objects required:YES error:error];
    if(!mainGroup || ![mainGroup isKindOfClass:[PBXGroup class]])
    {
    // FIXME set error text here
      [self release];
      return nil;
    }
    [mainGroup retain];
    
    projectDirPath = [dict unpackObjectWithKey:@"projectDirPath" forDocument:ownerDocument pbxDictionary:objects required:NO error:error];
    if(!projectDirPath)
    {
      projectDirPath = @"";
    }
    [projectDirPath retain];
    
    projectRoot = [dict unpackObjectWithKey:@"projectRoot" forDocument:ownerDocument pbxDictionary:objects required:NO error:error];
    if(!projectRoot)
    {
      projectRoot = @"";
    }
    [projectRoot retain];
    
    
    /*
    objects to decode:
    
  //XCConfigurationList *buildConfigurationList;
  NSString *compatibilityVersion;
  NSString *developmentRegion;
  BOOL hasScannedForEncodings;
  NSArray *knownRegions;
  //PBXGroup *mainGroup;
  NSString *projectDirPath;
  NSString *projectRoot;
  NSArray *targets; // contains PBXNativeTarget objects (possibly PBXTarget -- and PBXNativeTarget derived from that)
*/
    
  }
  return self;
}

-(void)dealloc
{
  //[buildConfigurationList release];
  [compatibilityVersion release];
  [developmentRegion release];
  [knownRegions release];
  [mainGroup release];
  [projectDirPath release];
  [projectRoot release];
  [targets release];
  [super dealloc ];
}

-(NSString*)description
{
  return [NSString stringWithFormat:
  @"\n"
  "PBXProject at 0x%p:\n"
  //"- buildConfigurationList: %@\n"
  "- compatibilityVersion: %@\n"
  "- developmentRegion: %@\n"
  "- hasScannedForEncodings: %s\n"
  "- knownRegions: (count: %d)\n",
  self, 
  //buildConfigurationList, 
  compatibilityVersion, 
  developmentRegion,
  hasScannedForEncodings ? "YES" : "NO",
  [knownRegions count]];
}


@end
