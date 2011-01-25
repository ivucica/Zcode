#ifndef PBXBuildFile_h_INCLUDED
#define PBXBuildFile_h_INCLUDED

#include <Foundation/Foundation.h>

@class PBXFileReference;

@interface PBXBuildFile : NSObject {
    PBXFileReference *fileRef_;
}

@property (readwrite, retain) PBXFileReference *fileRef;

@end

#endif // ndef PBXBuildFile_h_INCLUDED

