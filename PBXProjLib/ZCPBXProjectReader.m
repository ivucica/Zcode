/*
 Project: Zcode
 
 Copyright (C) 2011 Jason Felice
 
 Author: Jason Felice
 
 Created: 2011-01-26 22:10:55 -0500 by eraserhd
 
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


#import "ZCPBXProjectReader.h"
#if !GNUSTEP
#import <objc/runtime.h>
#endif


@interface ZCPBXProjectReader ()
@property (readwrite, copy) NSString *file;
@property (readwrite, copy) NSString *errorMessage;
@property (readwrite, retain) NSDictionary *plist;

- (BOOL)isObjectKey:(id)value;
- (id)resolveObjectReferencesFor:(id)value;
- (NSArray *)resolveObjectReferencesForArray:(NSArray *)value;
@end

@implementation ZCPBXProjectReader
@synthesize file = file_;
@synthesize errorMessage = errorMessage_;
@synthesize plist = plist_;

- (id)initWithFile:(NSString *)file {
	self = [super init];
	if (!self)
		return nil;

	self.file = file;
	foundObjects_ = [[NSMutableDictionary alloc] init];

	NSString* errstr = nil;
	NSData *data = [NSData dataWithContentsOfFile:self.file];
	self.plist = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:0 format:0 errorDescription:&errstr];
	if (!self.plist)
	{
		self.errorMessage = errstr;
		return self;
	}

	NSInteger archiveVersion = [[self.plist objectForKey:@"archiveVersion"] intValue];
	if (archiveVersion != 1)
	{
		self.errorMessage = [NSString stringWithFormat:@"pbxproj archive version %d is not supported", (int)archiveVersion];
		return self;
	}

	NSInteger objectVersion = [[self.plist objectForKey:@"objectVersion"] intValue];
	if(objectVersion != 45)
	{
		NSLog(@"we are only verified to load pbxproj plists of objectVersion 45; currently loading %d", (int)objectVersion);
	}

	return self;
}

- (void)dealloc {
	self.file = nil;
	self.errorMessage = nil;
	[plist_ release];
	[foundObjects_ release];
	[super dealloc];
}

- (BOOL)errorOccurred {
	return (self.errorMessage != nil);
}

- (NSDictionary *)objects {
	NSDictionary *result = [self.plist objectForKey:@"objects"];
	if (!result)
	{
		self.errorMessage = @"No 'objects' key found in pbxproj file";
		return nil;
	}
	if (![result isKindOfClass:[NSDictionary class]])
	{
		self.errorMessage = @"'objects' key from pbxproj file was not a dictionary";
		return nil;
	}
	return result;
}

- (NSString *)rootObjectKey {
	return [self.plist objectForKey:@"rootObject"];
}

- (PBXProject *)rootObject {
	return [self objectForKey:self.rootObjectKey];
}

- (id)objectForKey:(NSString *)key {
	id instance = [foundObjects_ objectForKey:key];
	if (instance)
		return instance;

	NSDictionary *props = [self.objects objectForKey:key];
	if (!props)
	{
		//FIXME:
		return nil;
	}

	NSString *isaStr = [props objectForKey:@"isa"];
	if (!isaStr)
	{
		//FIXME:
		return nil;
	}

	Class classFromIsa;
#if GNUSTEP
	classFromIsa = objc_lookup_class([isaStr UTF8String]);
#else
	classFromIsa = objc_lookUpClass([isaStr UTF8String]);
#endif
  	if(!classFromIsa)
	{
		//FIXME:
		return nil;
	}

	instance = [[classFromIsa alloc] init];
	for (NSString *propName in props)
	{
		if ([propName isEqualToString:@"isa"])
			continue;

		id value = [self resolveObjectReferencesFor:[props objectForKey:propName]];

		NS_DURING
		{
			[instance setValue:value forKey:propName];
		}
		NS_HANDLER
		{
		}
		NS_ENDHANDLER
	}

	[foundObjects_ setObject:instance forKey:key];
	return [instance autorelease];
}

- (id)resolveObjectReferencesFor:(id)value {
	if ([self isObjectKey:value])
		return [self objectForKey:value];
	else if ([value isKindOfClass:[NSArray class]])
		return [self resolveObjectReferencesForArray:value];
	else
		return value;
}

- (NSArray *)resolveObjectReferencesForArray:(NSArray *)value {
	NSMutableArray *ar = [[NSMutableArray alloc] init];
	for (id elt in value)
	{
		id resolvedElt = [self resolveObjectReferencesFor:elt];
		if (resolvedElt)
			[ar addObject:resolvedElt];
	}
	NSArray *result = [NSArray arrayWithArray:ar];
	[ar release];
	return result;
}

- (BOOL)isObjectKey:(id)value {
	if (value == nil)
		return NO;
	if (![value isKindOfClass:[NSString class]])
		return NO;
	if ([self.objects objectForKey:value] == nil)
		return NO;
	return YES;
}

@end
