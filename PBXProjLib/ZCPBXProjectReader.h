/*
 Project: Zcode
 
 Copyright (C) 2011 Jason Felice
 
 Author: Jason Felice 
 
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

#ifndef ZCPBXProjectReader_h_INCLUDED
#define ZCPBXProjectReader_h_INCLUDED

#import <Foundation/Foundation.h>

@class PBXProject;

@interface ZCPBXProjectReader : NSObject {
    NSString *file_;
    
    NSString *errorMessage_;
    NSDictionary *plist_;
    NSMutableDictionary *foundObjects_;
}

@property (readonly, copy) NSString *file;

@property (readonly, assign) BOOL errorOccurred;
@property (readonly, copy) NSString *errorMessage;
@property (readonly, retain) NSDictionary *plist;
@property (readonly, retain) NSDictionary *objects;
@property (readonly, retain) NSString *rootObjectKey;
@property (readonly, retain) PBXProject *rootObject;

- (id)initWithFile:(NSString *)file;

- (id)objectForKey:(NSString *)key;

@end

#endif // ndef ZCPBXProjectReader_h_INCLUDED

