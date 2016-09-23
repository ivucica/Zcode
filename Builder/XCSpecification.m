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

#import "XCSpecification.h"


@implementation XCSpecification
@synthesize superSpecification;
@synthesize identifier;
@synthesize type;
@synthesize name;

+(Class)specificationTypeBaseClass
{
    return [XCSpecification class];
}
+(NSString*)specificationType
{
    return @"Generic";
}
+(NSString*)localizedSpecificationTypeName
{
    return [self specificationType];
}
+(NSSet*)specificationTypePathExtensions
{
    return [NSSet setWithObjects:@"pbspec", nil];
}

-(id) initWithPropertyListDictionary: (NSDictionary *)dict
{
  self = [super init];
  if (!self)
    return nil;

  properties = [dict retain];
  return self;
}

-(NSString*)name
{
  // TODO: use synthesized property instead
  return [properties objectForKey:@"Name"];
}


// TODO: implement class methods to register specifications and proxies
@end
