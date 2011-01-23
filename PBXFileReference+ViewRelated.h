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

