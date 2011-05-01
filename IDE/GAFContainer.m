/*
 Project: Zcode
 
 Copyright (C) 2010 Ivan Vučica
 
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

// Groups and Files list has numerous groups in the outline view.
// Let's implement a class that will allow us to represent them.

#import <AppKit/AppKit.h>
#import "GAFContainer.h"

@implementation GAFContainer

-(id)initWithTitle:(NSString*)_title
{
  if((self=[super init]))
  {
    title = [_title retain];
  }
  return self;
}
-(void)dealloc
{
  [title release];
  [super dealloc];
}
-(NSString*)description
{
  return title;
}

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
  return YES;
}
@end
