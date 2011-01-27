#import "PBXProjLib/PBXBuildFile.h"
#import "PBXProjLib/PBXGroup.h"
#import "PBXProjLib/PBXProject.h"
#import "PBXProjLib/ZCPBXProjectReader.h"
#import "PBXProjLib/PBXFileReference.h"
#import "check.h"

CHECK(ZCPBXProjectReader_loads_plist_dictionary)
{
	ZCPBXProjectReader *r = [[ZCPBXProjectReader alloc] initWithFile:@"simple.pbxproj"];
	assert(!r.errorOccurred);
	assert(r.plist != nil);
	assert([r.plist isKindOfClass:[NSDictionary class]]);
	[r release];
}

CHECK(ZCPBXProjectReader_signals_error_if_plist_cant_be_loaded)
{
	ZCPBXProjectReader *r = [[ZCPBXProjectReader alloc] initWithFile:@"does_not_exist.pbxproj"];
	(void) r.plist;
	assert(r.errorOccurred);
	[r release];
}

CHECK(ZCPBXProjectReader_returns_error_message)
{
	ZCPBXProjectReader *r = [[ZCPBXProjectReader alloc] initWithFile:@"does_not_exist.pbxproj"];
	(void) r.plist;
	assert(r.errorMessage != nil);
	[r release];
}

CHECK(ZCPBXProjectReader_rejects_files_with_archiveVersion_ne_1)
{
	ZCPBXProjectReader *r = [[ZCPBXProjectReader alloc] initWithFile:@"version97.pbxproj"];
	assert([r.errorMessage isEqualToString:@"pbxproj archive version 97 is not supported"]);
	[r release];
}

CHECK(ZCPBXProjectReader_can_get_objects_hash)
{
	ZCPBXProjectReader *r = [[ZCPBXProjectReader alloc] initWithFile:@"simple.pbxproj"];
	assert(r.objects != nil);
	assert(!r.errorOccurred);
	assert([r.objects isKindOfClass:[NSDictionary class]]);
	[r release];
}

CHECK(ZCPBXProjectReader_signals_error_when_objects_missing)
{
	ZCPBXProjectReader *r = [[ZCPBXProjectReader alloc] initWithFile:@"no_objects.pbxproj"];
	assert(r.objects == nil);
	assert(r.errorOccurred);
	assert([r.errorMessage isEqualToString:@"No 'objects' key found in pbxproj file"]);
	[r release];
}

CHECK(ZCPBXProjectReader_singals_error_when_objects_not_dictionary)
{
	ZCPBXProjectReader *r = [[ZCPBXProjectReader alloc] initWithFile:@"objects_not_dictionary.pbxproj"];
	assert(r.objects == nil);
	assert(r.errorOccurred);
	assert([r.errorMessage isEqualToString:@"'objects' key from pbxproj file was not a dictionary"]);
	[r release];
}

CHECK(ZCPBXProjectReader_can_retrieve_rootObjectKey)
{
	ZCPBXProjectReader *r = [[ZCPBXProjectReader alloc] initWithFile:@"simple.pbxproj"];
	assert([r.rootObjectKey isEqualToString:@"2A37F4A9FDCFA73011CA2CEA"]);
	[r release];
}

CHECK(ZCPBXProjectReader_can_reconstitute_simple_object)
{
	ZCPBXProjectReader *r = [[ZCPBXProjectReader alloc] initWithFile:@"simple.pbxproj"];
	id a = [r objectForKey:@"7F6ACADE12E9A15500536F3D"];
	assert(a != nil);
	assert([a isKindOfClass:[PBXFileReference class]]);
	[r release];
}

CHECK(ZCPBXProjectReader_preserves_references)
{
	ZCPBXProjectReader *r = [[ZCPBXProjectReader alloc] initWithFile:@"simple.pbxproj"];
	id a = [r objectForKey:@"7F6ACADE12E9A15500536F3D"];
	id b = [r objectForKey:@"7F6ACADE12E9A15500536F3D"];
	assert(a != nil);
	assert(b != nil);
	assert(a == b);
	[r release];
}

CHECK(ZCPBXProjectReader_sets_property_values)
{
	ZCPBXProjectReader *r = [[ZCPBXProjectReader alloc] initWithFile:@"simple.pbxproj"];
	PBXFileReference *fr = [r objectForKey:@"7F6ACADE12E9A15500536F3D"];
	assert(fr.fileEncoding == 4);
	assert([fr.lastKnownFileType isEqualToString:@"sourcecode.c.h"]);
	assert([fr.path isEqualToString:@"PBXFileReference.h"]);
	assert([fr.sourceTree isEqualToString:@"<group>"]);
	[r release];
}

CHECK(ZCPBXProjectReader_sets_object_references)
{
	ZCPBXProjectReader *r = [[ZCPBXProjectReader alloc] initWithFile:@"simple.pbxproj"];
	PBXBuildFile *bf = [r objectForKey:@"7F6ACAC312E99F5C00536F3D"];
	assert([bf isKindOfClass:[PBXBuildFile class]]);
	assert(bf.fileRef != nil);
	assert([bf.fileRef isKindOfClass:[PBXFileReference class]]);
	assert([bf.fileRef.lastKnownFileType isEqualToString:@"sourcecode.c.objc"]);
	[r release];
}

CHECK(ZCPBXProjectReader_sets_array_of_object_references)
{
	ZCPBXProjectReader *r = [[ZCPBXProjectReader alloc] initWithFile:@"simple.pbxproj"];
	PBXGroup *g = [r objectForKey:@"1058C7A8FEA54F5311CA2CBB"]; // Other Frameworks
	assert([g isKindOfClass:[PBXGroup class]]);
	assert(g.children != nil);
	assert([g.children count] == 3);
	for (id child in g.children)
	{
		assert([child isKindOfClass:[PBXFileReference class]]);
		assert([[child sourceTree] isEqualToString:@"<absolute>"]);
	}
	[r release];
}

CHECK(ZCPBXProjectReader_retrieves_root_object)
{
	ZCPBXProjectReader *r = [[ZCPBXProjectReader alloc] initWithFile:@"simple.pbxproj"];
	PBXProject *p = r.rootObject;
	assert([p isKindOfClass:[PBXProject class]]);
	[r release];
}
