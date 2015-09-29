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

#ifndef PBXNativeTarget_H_INCLUDED
#define PBXNativeTarget_H_INCLUDED

#import <Foundation/Foundation.h>

@class PBXProject;
@class XCConfigurationList;
@class ZCPBXBuildPhaseList;
@class PBXFileReference;

@interface PBXNativeTarget : NSObject 
{
  XCConfigurationList* buildConfigurationList;
  NSMutableArray* buildPhases;
  NSMutableArray* buildRules;
  NSMutableArray* dependencies;
  
  NSString* name;
  NSString* productInstallPath;
  NSString* productName;
  PBXFileReference *productReference;
  NSString* productType;

  PBXProject* owner;
}

@property (readwrite, retain) XCConfigurationList *buildConfigurationList; // TODO(ivucica): possibly copy semantics?
@property (readwrite, copy) NSMutableArray *buildPhases;
@property (readwrite, copy) NSMutableArray *buildRules;
@property (readwrite, copy) NSMutableArray *dependencies;
@property (readwrite, copy) NSString *name;
@property (readwrite, copy) NSString *productInstallPath;
@property (readwrite, copy) NSString *productName;
@property (readwrite, copy) NSString *productType;
@property (readwrite, retain) PBXFileReference *productReference; // TODO(ivucica): possibly copy semantics?

@property (readwrite, assign) PBXProject *owner;

@end

#endif
