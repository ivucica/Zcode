#ifndef PBXProjectReader_h_INCLUDED
#define PBXProjectReader_h_INCLUDED

#import <Foundation/Foundation.h>

@interface PBXProjectReader : NSObject {
    NSString *file_;
    
    NSString *errorMessage_;
    NSDictionary *plist_;
}

@property (readonly, copy) NSString *file;

@property (readonly, assign) BOOL errorOccurred;
@property (readonly, copy) NSString *errorMessage;
@property (readonly, retain) NSDictionary *plist;
@property (readonly, retain) NSDictionary *objects;

- (id)initWithFile:(NSString *)file;

@end

#endif // ndef PBXProjectReader_h_INCLUDED

