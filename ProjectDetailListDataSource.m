/*
   Project: Zcode

   Copyright (C) 2011 Ivan Vucica

   Author: Ivan Vucica,,,

   Created: 2011-01-21 14:04:00 +0100 by ivucica

   This application is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This application is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111 USA.
*/

#import "ProjectDetailListDataSource.h"


@implementation ProjectDetailListDataSource
@synthesize items;

-(void)dealloc
{
  [items release];
  [super dealloc];
}
-(void)setItems:(NSArray *)_items
{
  [items release];
  items = [_items retain];
  NSLog(@"Now handling %d items", items.count);
  
  [ownerTableView reloadData];
}
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
  return items.count;
}
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
  id item = [items objectAtIndex:row];
  return [item tableView:tableView objectValueForTableColumn:tableColumn];
}

@end
