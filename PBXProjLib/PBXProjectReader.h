#ifndef PBXProjectReader_h_INCLUDED
#define PBXProjectReader_h_INCLUDED

#import <Foundation/Foundation.h>

@interface PBXProjectReader : NSObject {
    NSString *file_;
}

@property (readonly, copy) NSString *file;

- (id)initWithFile:(NSString *)file;

@end

#endif // ndef PBXProjectReader_h_INCLUDED

