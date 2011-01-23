#import "PBXProjectReader.h"

@interface PBXProjectReader ()
@property (readwrite, copy) NSString *file;
@property (readwrite, copy) NSString *errorMessage;
@property (readwrite, retain) NSDictionary *plist;
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

@end
