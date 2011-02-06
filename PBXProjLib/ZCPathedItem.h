/*
   Project: Zcode

   Copyright (C) 2011 Jason Felice
   Copyright (C) 2011 Ivan Vučica

   Author: Jason Felice, Ivan Vučica

   Created: 2011-01-26 20:39:47 -0500 by eraserhd

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

#ifndef ZCPathedItem_h_INCLUDED
#define ZCPathedItem_h_INCLUDED

#import <Foundation/Foundation.h>

@interface ZCPathedItem : NSObject
{
  ZCPathedItem* owner_; // weak reference

  NSString *path_;
  NSString *sourceTree_;
}

@property (readwrite, assign) ZCPathedItem* owner;
@property (readwrite, copy) NSString *path;
@property (readwrite, copy) NSString *sourceTree;


@end

#endif // ndef ZCPathedItem_h_INCLUDED

