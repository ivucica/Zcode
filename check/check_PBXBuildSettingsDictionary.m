#import "PBXProjLib/PBXBuildSettingsDictionary.h"
#import "check.h"

CHECK(PBXBuildSettingsDictionary_correctly_expands_simple_string_with_one_dictionary)
{
	PBXBuildSettingsDictionary *queenlySettings = [[PBXBuildSettingsDictionary alloc] init];
	[queenlySettings setObject:@"bite" forKey:@"ACTION"];
	[queenlySettings setObject:@"dust" forKey:@"SUBSTANCE"];
	
	NSArray *expansionDictionaries = [NSArray arrayWithObjects: 
		queenlySettings,
		nil];

	NSString *checkString = @"another one $(ACTION)s the $(SUBSTANCE)";
	NSString *expectedString = @"another one bites the dust";
	NSString *expandedString = [PBXBuildSettingsDictionary expandedBuildSettingForString:checkString withExpansionDictionaries:expansionDictionaries]; 

	assert([expandedString isEqualToString:expectedString]);

	[queenlySettings release];
}
