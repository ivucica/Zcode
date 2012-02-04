/*
 Project: Zcode
 
 Copyright (C) 2011 Ivan Vučica
 
 Author: Ivan Vučica
 
 This application is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 2.1 of the License, or (at your option) any later version.
 
 This application is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public
 License along with this application; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 */

#import "ZCTextEditorViewController.h"


@implementation ZCTextEditorViewController
@synthesize textView;
@synthesize codeCompletionIndex;
@synthesize codeCompletionTranslationUnit;
-(void)loadView
{
    [super loadView];
    [textView setDelegate:self];
#if HAVE_LIBCLANG
    self.codeCompletionIndex = clang_createIndex(0, 0);
    
    struct CXUnsavedFile unsavedFile;
    unsavedFile.Contents = [[self.textView.textStorage string] UTF8String];
    unsavedFile.Filename = [self.fileName UTF8String];
    unsavedFile.Length = [[self.textView.textStorage string] length];
    self.codeCompletionTranslationUnit = clang_parseTranslationUnit(self.codeCompletionIndex, [self.fileName UTF8String], (const char*[]){"codecompletion", "-x","objective-c","-isysroot","/Xcode4/SDKs/MacOSX10.6.sdk","-mmacosx-version-min=10.6","-I",[self.fileName stringByDeletingLastPathComponent].UTF8String}, 8, &unsavedFile, 1, clang_defaultEditingTranslationUnitOptions());
    
#endif
}
#if HAVE_LIBCLANG
-(int)reparseTranslationUnit
{
    struct CXUnsavedFile unsavedFile;
    unsavedFile.Contents = [[self.textView.textStorage string] UTF8String];
    unsavedFile.Filename = [self.fileName UTF8String];
    unsavedFile.Length = [[self.textView.textStorage string] length];
    return clang_reparseTranslationUnit(self.codeCompletionTranslationUnit, 1, &unsavedFile, clang_defaultReparseOptions(self.codeCompletionTranslationUnit) | CXTranslationUnit_CacheCompletionResults);
}
#endif
-(void)dealloc
{
    clang_disposeIndex(self.codeCompletionIndex);
    clang_disposeTranslationUnit(self.codeCompletionTranslationUnit);
    [super dealloc];
}
-(void)_loadFile
{
    NSString *fileContents = [NSString stringWithContentsOfFile:fileName];
    
    if(!fileContents)
        return;
    
    NSAttributedString *fileText = 
    [[[NSAttributedString alloc] initWithString:fileContents 
                                     attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 [NSFont fontWithName:@"Andale Mono"
                                                                 size:12], NSFontAttributeName, 
                                                 nil]] autorelease];
    
    [[textView textStorage] setAttributedString:fileText];
}
#if HAVE_LIBCLANG
-(NSArray*)textView:(NSTextView *)textView completions:(NSArray *)words forPartialWordRange:(NSRange)charRange indexOfSelectedItem:(NSInteger *)index
{
    if(!self.codeCompletionTranslationUnit)
    {
        return words;
    }
    [self reparseTranslationUnit];
    
    CXFile file = clang_getFile(self.codeCompletionTranslationUnit, [self.fileName UTF8String]);
    CXSourceLocation location = clang_getLocationForOffset(self.codeCompletionTranslationUnit, file, charRange.location + charRange.length);
    
    unsigned int line;
    unsigned int column;
    unsigned int offset;
    
    clang_getSpellingLocation(location, &file, &line, &column, &offset);
    
    struct CXUnsavedFile unsavedFile;
    unsavedFile.Contents = [[self.textView.textStorage string] UTF8String];
    unsavedFile.Filename = [self.fileName UTF8String];
    unsavedFile.Length = [[self.textView.textStorage string] length];
    NSLog(@"Working on %d %d", line, column);
    CXCodeCompleteResults *results = clang_codeCompleteAt(self.codeCompletionTranslationUnit,
                                                         [self.fileName UTF8String], 
                                                         line, column,
                                                         &unsavedFile, 1, 
                                                         0);
    
    NSMutableArray * ma = [NSMutableArray arrayWithCapacity:results->NumResults];
    int bestIndex = 0;
    int bestPriority = 9000;
    
    for(int i = 0; i < results->NumResults; i++)
    {
        CXCompletionResult result = results->Results[i];
        CXCompletionString completion = result.CompletionString;
        
        NSMutableString * ms = [NSMutableString string];
        for(int j = 0; j < clang_getNumCompletionChunks(completion); j++)
        {
            if(clang_getCompletionChunkKind(completion, j) != CXCompletionChunk_TypedText)
                continue;
            CXString string = clang_getCompletionChunkText(completion, j);
            [ms appendString:[NSString stringWithUTF8String:clang_getCString(string)]];
            clang_disposeString(string);
        }
        
        unsigned priority = clang_getCompletionPriority(completion);
        //NSLog(@"Priority %d for %@", priority, ms);
        NSDictionary * priorityAndString = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:priority], @"priority", ms, @"string", nil];
        [ma addObject:priorityAndString];
    }
    
    if(!ma.count)
    {
        
        clang_disposeCodeCompleteResults(results);
        
        *index = bestIndex;
        return [NSArray array];

    }
    
    [ma sortUsingDescriptors:[NSArray arrayWithObject:
                                   [NSSortDescriptor sortDescriptorWithKey:@"priority" ascending:YES]]];
    
    bestPriority = [[[ma objectAtIndex:0] valueForKey:@"priority"] intValue];
    NSMutableArray * ourWords = [NSMutableArray arrayWithCapacity:ma.count];
    
    for(int i = 0 ; i < ma.count; i++)
    {
        int priority = [[[ma objectAtIndex:i] valueForKey:@"priority"] intValue];
        NSString * word = [[ma objectAtIndex:i] valueForKey:@"string"];

        if(((word.length >= charRange.length && [[word substringToIndex:charRange.length] isEqualToString:[self.textView.textStorage.string substringWithRange:charRange]]) || charRange.length == 0))
        {
            if(ourWords.count && word.length <= [[ourWords objectAtIndex:bestIndex] length])
                bestIndex = ourWords.count;
            [ourWords addObject:word];
        }
    }
    
    if(ourWords.count == 0)
    {        
        for(int i = 0 ; i < ma.count; i++)
        {
            int priority = [[[ma objectAtIndex:i] valueForKey:@"priority"] intValue];
            NSString * word = [[ma objectAtIndex:i] valueForKey:@"string"];
            
            if(priority >= bestPriority)
            {
                [ourWords addObject:word];
            }
        }
        bestIndex = 0;
    }
    
    clang_disposeCodeCompleteResults(results);
    
    *index = bestIndex;
    return ourWords;
}
-(void)textDidChange:(NSNotification *)notification
{
    //[self reparseTranslationUnit];
}
#endif
@end
