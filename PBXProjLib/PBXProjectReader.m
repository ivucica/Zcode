#import "PBXProjectReader.h"

@interface PBXProjectReader ()
@property (readwrite, copy) NSString *file;
@property (readwrite, copy) NSString *errorMessage;
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
	plist_ = [[NSPropertyListSerialization propertyListFromData:data mutabilityOption:0 format:0 errorDescription:&errstr] retain];
	if (!plist_)
	{
		self.errorMessage = errstr;
	}
	return plist_;
}

@end
