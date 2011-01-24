#import "PBXProjLib/PBXBuildFile.h"
#import "PBXProjLib/PBXProjectReader.h"
#import "PBXProjLib/PBXFileReference.h"
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

CHECK(PBXProjectReader_can_get_objects_hash)
{
	PBXProjectReader *r = [[PBXProjectReader alloc] initWithFile:@"simple.pbxproj"];
	assert(r.objects != nil);
	assert(!r.errorOccurred);
	assert([r.objects isKindOfClass:[NSDictionary class]]);
	[r release];
}

CHECK(PBXProjectReader_signals_error_when_objects_missing)
{
	PBXProjectReader *r = [[PBXProjectReader alloc] initWithFile:@"no_objects.pbxproj"];
	assert(r.objects == nil);
	assert(r.errorOccurred);
	assert([r.errorMessage isEqualToString:@"No 'objects' key found in pbxproj file"]);
	[r release];
}

CHECK(PBXProjectReader_singals_error_when_objects_not_dictionary)
{
	PBXProjectReader *r = [[PBXProjectReader alloc] initWithFile:@"objects_not_dictionary.pbxproj"];
	assert(r.objects == nil);
	assert(r.errorOccurred);
	assert([r.errorMessage isEqualToString:@"'objects' key from pbxproj file was not a dictionary"]);
	[r release];
}

CHECK(PBXProjectReader_can_retrieve_rootObjectKey)
{
	PBXProjectReader *r = [[PBXProjectReader alloc] initWithFile:@"simple.pbxproj"];
	assert([r.rootObjectKey isEqualToString:@"2A37F4A9FDCFA73011CA2CEA"]);
	[r release];
}

CHECK(PBXProjectReader_can_reconstitute_simple_object)
{
	PBXProjectReader *r = [[PBXProjectReader alloc] initWithFile:@"simple.pbxproj"];
	id a = [r objectForKey:@"7F6ACADE12E9A15500536F3D"];
	assert(a != nil);
	assert([a isKindOfClass:[PBXFileReference class]]);
	[r release];
}

CHECK(PBXProjectReader_preserves_references)
{
	PBXProjectReader *r = [[PBXProjectReader alloc] initWithFile:@"simple.pbxproj"];
	id a = [r objectForKey:@"7F6ACADE12E9A15500536F3D"];
	id b = [r objectForKey:@"7F6ACADE12E9A15500536F3D"];
	assert(a != nil);
	assert(b != nil);
	assert(a == b);
	[r release];
}

CHECK(PBXProjectReader_sets_property_values)
{
	PBXProjectReader *r = [[PBXProjectReader alloc] initWithFile:@"simple.pbxproj"];
	PBXFileReference *fr = [r objectForKey:@"7F6ACADE12E9A15500536F3D"];
	assert(fr.fileEncoding == 4);
	assert([fr.lastKnownFileType isEqualToString:@"sourcecode.c.h"]);
	assert([fr.path isEqualToString:@"PBXFileReference.h"]);
	assert([fr.sourceTree isEqualToString:@"<group>"]);
	[r release];
}

CHECK(PBXProjectReader_sets_object_references)
{
	PBXProjectReader *r = [[PBXProjectReader alloc] initWithFile:@"simple.pbxproj"];
	PBXBuildFile *bf = [r objectForKey:@"7F6ACAC312E99F5C00536F3D"];
	assert([bf isKindOfClass:[PBXBuildFile class]]);
	assert(bf.fileRef != nil);
	assert([bf.fileRef isKindOfClass:[PBXFileReference class]]);
	assert([bf.fileRef.lastKnownFileType isEqualToString:@"sourcecode.c.objc"]);
	[r release];
}
