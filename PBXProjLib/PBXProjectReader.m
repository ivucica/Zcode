#import "PBXProjectReader.h"
#if !GNUSTEP
#import <objc/runtime.h>
#endif


@interface PBXProjectReader ()
@property (readwrite, copy) NSString *file;
@property (readwrite, copy) NSString *errorMessage;
@property (readwrite, retain) NSDictionary *plist;

- (BOOL)isObjectKey:(id)value;
@end

@implementation PBXProjectReader
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
		self.errorMessage = [NSString stringWithFormat:@"pbxproj archive version %d is not supported", archiveVersion];
		return self;
	}

	NSInteger objectVersion = [[self.plist objectForKey:@"objectVersion"] intValue];
	if(objectVersion != 45)
	{
		NSLog(@"we are only verified to load pbxproj plists of objectVersion 45; currently loading %d", objectVersion);
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

- (NSDictionary *)plist {
	if (plist_)
		return plist_;

	NSString* errstr = nil;
	NSData *data = [NSData dataWithContentsOfFile:self.file];
	plist_ = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:0 format:0 errorDescription:&errstr];
	if (!plist_)
	{
		self.errorMessage = errstr;
		return nil;
	}

	return [plist_ retain];
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

		id value = [props objectForKey:propName];
		if ([self isObjectKey:value])
		{
			value = [self objectForKey:value];
		}
		else if ([value isKindOfClass:[NSArray class]])
		{
			NSMutableArray *ar = [[NSMutableArray alloc] init];
			for (id elt in value)
			{
				if ([self isObjectKey:elt])
					elt = [self objectForKey:elt];
				[ar addObject:elt];
			}
			value = [NSArray arrayWithArray:ar];
			[ar release];
		}

		@try
		{
			[instance setValue:[props objectForKey:propName] forKey:propName];
		}
		@catch (...)
		{
		}
	}

	[foundObjects_ setObject:instance forKey:key];
	return [instance autorelease];
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
