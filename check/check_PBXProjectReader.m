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

CHECK(PBXProjectReader_rejects_files_with_archiveVersion_ne_1)
{
	PBXProjectReader *r = [[PBXProjectReader alloc] initWithFile:@"version97.pbxproj"];
	assert([r.errorMessage isEqualToString:@"pbxproj archive version 97 is not supported"]);
	[r release];
}
