/*
 Project: Zcode
 
 Copyright (C) 2011 Ivan Vučica
 
 Author: Ivan Vucica
 
 Created: 2011-01-23 12:17:25 -0500 by eraserhd
 
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

#ifndef PBXFileReference_ViewRelated_h_INCLUDED
#define PBXFileReference_ViewRelated_h_INCLUDED

@class NSOutlineView;
@class NSTableColumn;
@class NSTableView;
@class NSCell;

@interface PBXFileReference (ViewRelated)

// For outline view
-(NSInteger)numberOfChildrenForOutlineView:(NSOutlineView*)outlineView;
-(id)child:(NSInteger)index forOutlineView:(NSOutlineView*)outlineView;
-(BOOL)isExpandableForOutlineView:(NSOutlineView*)outlineView;
-(void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(NSCell*)cell forTableColumn:(NSTableColumn*)tableColumn;

// For table view
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn;

@end


#endif // ndef PBXFileReference_ViewRelated_h_INCLUDED

