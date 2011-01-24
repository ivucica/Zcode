#import "PBXBuildFile.h"

@implementation PBXBuildFile
@synthesize fileRef = fileRef_;

- (void)dealloc {
	self.fileRef = nil;
	[super dealloc];
}
@end
