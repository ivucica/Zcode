/*
   Project: Zcode

   Copyright (C) 2010 Free Software Foundation

   Author: Ivan Vucica,,,

   Created: 2010-12-31 19:00:09 +0100 by ivucica

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

#ifndef _GAFCONTAINER_H_
#define _GAFCONTAINER_H_

#import <Foundation/Foundation.h>

@interface GAFContainer : NSObject
{
  NSString* title;
}
-(id)initWithTitle:(NSString*)title;
-(NSString*)description;
-(NSInteger)numberOfChildrenForOutlineView:(NSOutlineView*)outlineView;
-(id)child:(NSInteger)index forOutlineView:(NSOutlineView*)outlineView;
-(BOOL)isExpandableForOutlineView:(NSOutlineView*)outlineView;
@end

#endif // _GAFCONTAINER_H_

