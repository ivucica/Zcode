#import "PBXProjectReader.h"

@interface PBXProjectReader ()
@property (readwrite, copy) NSString *file;
@end

@implementation PBXProjectReader
@synthesize file = file_;

- (id)initWithFile:(NSString *)file {
	self = [super init];
	if (!self)
		return nil;

	self.file = file;

	return self;
}

- (void)dealloc {
	self.file = nil;
	[super dealloc];
}

@end
