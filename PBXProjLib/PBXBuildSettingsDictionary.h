/*
   Project: Zcode

   Copyright (C) 2011 Ivan Vučica

   Author: Ivan Vucica

   Created: 2011-04-07 10:39:10 +0100 by ivucica

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

// This class is partially inspired by looking at the
// class dump produced by Google as part of GMT.

// I'm somewhat confused by what Apple was doing by
// deriving this from NSMutableDictionary; I really see
// no reason to do this when buildSettings ivar is
// an NSMutableDictionary and seems to store the
// build settings themselves.

// My implementation tries to sync the contents of
// self and self->buildSettings. However, if I don't
// figure out why this is done this way, I'll be changing
// PBXBuildSettingsDictionary to derive from NSObject.


#import <Foundation/Foundation.h>

@interface PBXBuildSettingsDictionary : NSMutableDictionary 
{
    NSMutableDictionary *buildSettings;
    
}

#pragma mark nsmutabledictionary methods to pass through
-(id)initWithDictionary:(NSDictionary *)otherDictionary;
-(id)objectForKey:(id)aKey;
-(void)setObject:(id)anObject forKey:(id)aKey;
-(void)removeObjectForKey:(id)aKey;
-(NSArray *)allKeys;
-(NSArray *)allValues;
-(NSEnumerator *)keyEnumerator;
-(NSUInteger)count;
-(NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len;

#pragma mark xc stuff
/**
 Oddly, this function is a class method, not an instance method.
 
 Current understanding of this function:
 
 - 'string' is the unexpanded build setting value (as opposed to being a key)
 - 'expansionDictionaries' are various PBXBuildSettingsDictionary instances, 
 in order of priority. Object at index 0 is of "closest" priority; that is,
 in context of a target, it is the target-level setting. Object at index
 1 is in that case project-level setting. 
 
 If this does not match what Xcode is doing, this function should probably
 be corrected.
 **/
+(NSString*)expandedBuildSettingForString:(NSString*)string withExpansionDictionaries:(NSArray*)expansionDictionaries;

#pragma mark added stuff
-(id)copyWithZone:(NSZone *)zone;
-(id)mutableCopyWithZone:(NSZone *)zone;


@end
