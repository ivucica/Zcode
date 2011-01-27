#ifndef ZCPBXProjectReader_h_INCLUDED
#define ZCPBXProjectReader_h_INCLUDED

#import <Foundation/Foundation.h>

@class PBXProject;

@interface ZCPBXProjectReader : NSObject {
    NSString *file_;
    
    NSString *errorMessage_;
    NSDictionary *plist_;
    NSMutableDictionary *foundObjects_;
}

@property (readonly, copy) NSString *file;

@property (readonly, assign) BOOL errorOccurred;
@property (readonly, copy) NSString *errorMessage;
@property (readonly, retain) NSDictionary *plist;
@property (readonly, retain) NSDictionary *objects;
@property (readonly, retain) NSString *rootObjectKey;
@property (readonly, retain) PBXProject *rootObject;

- (id)initWithFile:(NSString *)file;

- (id)objectForKey:(NSString *)key;

@end

#endif // ndef ZCPBXProjectReader_h_INCLUDED

