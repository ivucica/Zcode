#import "PBXProjLib/PBXProjectReader.h"
#import "check.h"

CHECK(PBXProjectReader_loads_plist_dictionary)
{
	PBXProjectReader *r = [[PBXProjectReader alloc] initWithFile:@"simple.pbxproj"];
	assert(!r.errorOccurred);
	assert(r.plist != nil);
	assert([r.plist isKindOfClass:[NSDictionary class]]);
	[r release];
}

CHECK(PBXProjectReader_signals_error_if_plist_cant_be_loaded)
{
	PBXProjectReader *r = [[PBXProjectReader alloc] initWithFile:@"does_not_exist.pbxproj"];
	assert(!r.errorOccurred);
	(void) r.plist;
	assert(r.errorOccurred);
	[r release];
}

CHECK(PBXProjectReader_returns_error_message)
{
	PBXProjectReader *r = [[PBXProjectReader alloc] initWithFile:@"does_not_exist.pbxproj"];
	(void) r.plist;
	assert(r.errorMessage != nil);
	[r release];
}
