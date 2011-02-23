/*
 Project: Zcode
 
 Copyright (C) 2011 Ivan Vučica
 
 Author: Ivan Vucica
 
 Created: 2011-02-23 23:05:25 +0100 by ivucica
 
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

#import "PBXNativeTarget+ViewRelated.h"


@implementation PBXNativeTarget (ViewRelated)


-(NSImage *)img
{
    NSImage *img;
    
    // FIXME file should reflect the type of target
    NSString *path = [[NSBundle mainBundle] pathForResource:@"app" ofType:@"png"];
    img = [[[NSImage alloc] initWithContentsOfFile:path] autorelease];
    [img setScalesWhenResized:YES];
    [img setSize:NSMakeSize(16,16)];
    return img;
}

#pragma mark -
#pragma mark For outline view


-(NSInteger)numberOfChildrenForOutlineView:(NSOutlineView*)outlineView
{
    return 0;
}
-(id)child:(NSInteger)index forOutlineView:(NSOutlineView*)outlineView
{
    return nil;
}
-(BOOL)isExpandableForOutlineView:(NSOutlineView*)outlineView
{
    return NO;
}
/*
 // TODO we should perhaps allow rename?
 -(void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn
 {
 // FIXME check if 'object' is string, etc
 self.name = object;
 }
 */
- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(NSCell*)cell forTableColumn:(NSTableColumn*)tableColumn
{
    //[[cell image] release]; // FIXME xcode static analysis says we should not do this
    [cell setImage:[[self img] retain]];
}

#pragma mark -
#pragma mark For table view
// never displayed in table view!

- (void)addLeafsToArray:(NSMutableArray*)leafs
{
    // nothing!
}  


@end
