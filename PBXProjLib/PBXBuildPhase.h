/*
   Project: Zcode

   Copyright (C) 2011 Ivan Vučica

   Author: Ivan Vucica

   Created: 2011-03-24 15:11:10 +0100 by ivucica

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

#import <Foundation/Foundation.h>

@interface PBXBuildPhase : NSObject
{  
  NSInteger buildActionMask; 
  NSMutableArray *files;
  NSMutableArray *inputPaths;
  NSMutableArray *outputPaths;
  NSString *name;
  NSInteger runOnlyForDeploymentPostProcessing;
}

-(NSString*)description;

@property (readwrite, assign) NSInteger buildActionMask; 
@property (readwrite, copy) NSMutableArray *files;
@property (readwrite, copy) NSMutableArray *inputPaths;
@property (readwrite, copy) NSMutableArray *outputPaths;
@property (readwrite, retain) NSString *name;
@property (readwrite, assign) NSInteger runOnlyForDeploymentPostProcessing;

@end


