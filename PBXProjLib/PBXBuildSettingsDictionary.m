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

#import "PBXBuildSettingsDictionary.h"


@implementation PBXBuildSettingsDictionary

#pragma mark nsmutabledictionary methods to pass through
-(id)init
{
    if ((self=[super init]))
    {
        buildSettings = [[NSMutableDictionary alloc] init];
    }
    return self;
}
-(id)initWithDictionary:(NSDictionary *)otherDictionary
{
    if ((self=[super initWithDictionary:otherDictionary])) 
    {
        buildSettings = [[NSMutableDictionary alloc] initWithDictionary:otherDictionary];
    }
    return self;
}
-(id)objectForKey:(id)aKey
{
    return [buildSettings objectForKey:aKey];
}
-(void)setObject:(id)anObject forKey:(id)aKey
{
    [buildSettings setObject:anObject forKey:aKey];
}
-(void)removeObjectForKey:(id)aKey
{
    [super removeObjectForKey:aKey];
    [buildSettings removeObjectForKey:aKey];
}
-(NSArray *)allKeys
{
    return [buildSettings allKeys];
}
-(NSArray *)allValues
{
    return [buildSettings allValues];
}
-(NSEnumerator *)keyEnumerator
{
    return [buildSettings keyEnumerator];
}
-(NSUInteger)count
{
    return [buildSettings count];
}
-(NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len
{
    return [buildSettings countByEnumeratingWithState:state objects:stackbuf count:len];
}

#pragma mark xc stuff
+(NSString*)expandedBuildSettingForString:(NSString*)string withExpansionDictionaries:(NSArray*)expansionDictionaries
{
    NSString *currentString = string;
    
    int currentDictionaryIndex = 0;
    PBXBuildSettingsDictionary *currentDictionary = [expansionDictionaries objectAtIndex:currentDictionaryIndex];
    
    for (int i = 0; i < [currentString length]-2; i++) 
    {
        NSString *variableOpening = [currentString substringWithRange:NSMakeRange(i, 2)];
        NSRange locationOfVariableCloser = [currentString rangeOfString:@")" options:0 range:NSMakeRange(i+1, [currentString length]-i-1)];
        
        if ([variableOpening isEqualToString:@"$("] &&
            locationOfVariableCloser.location != NSNotFound) 
        {
            NSString *variableName = [currentString substringWithRange:NSMakeRange(i+2, locationOfVariableCloser.location - (i+2))];
            NSString *variableValue = [currentDictionary objectForKey:variableName];
            if ([currentDictionary objectForKey:variableName]) 
            {
                
                NSString *newString = [currentString substringToIndex:i];
            
                newString = [newString stringByAppendingString:variableValue];
                newString = [newString stringByAppendingString:[currentString substringFromIndex:locationOfVariableCloser.location+1]];
                
                currentString = newString;
                
                i--; // repeat the comparison in case we inserted something that is, again, a variable
            }
            // FIXME break evaluation in case variable is already evaluated in
            // this pass over the dictionary!
        }
    }
    
    return currentString;
}

#pragma mark added stuff
-(id)copyWithZone:(NSZone *)zone
{
    PBXBuildSettingsDictionary *ret;
    
    ret = [super copyWithZone:zone];
    ret->buildSettings = [buildSettings copyWithZone:zone];
    
    return ret;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    PBXBuildSettingsDictionary *ret;
    
    ret = [super mutableCopyWithZone:zone];
    ret->buildSettings = [buildSettings mutableCopyWithZone:zone];
    
    return ret;
}

@end
