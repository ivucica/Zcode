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

#import <Foundation/Foundation.h>

@interface XCSpecification : NSObject {
    NSDictionary *properties;
    NSString *identifier;

    XCSpecification *superSpecification;
}

@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) XCSpecification *superSpecification;
@property (nonatomic, readonly) NSString *type;
@property (nonatomic, readonly) NSString *name;

+(Class)specificationTypeBaseClass;
+(NSString*)specificationType;
+(NSString*)localizedSpecificationTypeName;
+(NSSet*)specificationTypePathExtensions;
@end
