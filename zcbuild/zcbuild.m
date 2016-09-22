/*
 Project: Zcode
 
 Copyright (C) 2015 Ivan Vučica
 
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

#import "PBXProjLib/ZCPBXProjectReader.h"
#import "PBXProjLib/PBXProject.h"
#import "PBXProjLib/PBXNativeTarget.h"

int main (int argc, char ** argv)
{
  NSAutoreleasePool * pool = [NSAutoreleasePool new];
  if (argc < 2)
    {
      fprintf(stderr, "zcbuild: you must specify the .pbxproj file to load");
      return 1;
    }
  
  NSString * pbxProjPath = [NSString stringWithUTF8String: argv[1]];

  ZCPBXProjectReader *reader = [[[ZCPBXProjectReader alloc] initWithFile:pbxProjPath] autorelease];
  PBXProject *pbxProject = [reader.rootObject retain];
  if(reader.errorOccurred)
  {
    NSLog(@"Error: %@", reader.errorMessage);
    return NO;
  }

  pbxProject.owner = nil;

  for (PBXNativeTarget * i in pbxProject.targets)
    {
      NSLog(@"target %@", i);
      NSLog(@" product type %@", i.productType);
    }

  [pool release];
  return 0;
}
