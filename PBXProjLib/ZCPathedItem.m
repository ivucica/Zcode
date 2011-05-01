/*
 Project: Zcode
 
 Copyright (C) 2011 Jason Felice
 Copyright (C) 2011 Ivan Vučica
 
 Author: Jason Felice, Ivan Vučica
 
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

#import "ZCPathedItem.h"

@implementation ZCPathedItem

@synthesize owner = owner_;
@synthesize path = path_;
@synthesize sourceTree = sourceTree_;

// FIXME consider renaming "path" into "fullPath"
// this should be done to leave "path" as a relative path,
// and nothing else.
-(NSString*)path
{
  // FIXME this also needs to decode certain build-time environment variables
  // sourceTree can contain environment variable name, e.g. "BUILT_PRODUCTS_DIR"
  if([self.sourceTree isEqualToString:@"<absolute>"])
  {
    return path_;
  }
  
  if([self.sourceTree isEqualToString:@"<group>"] && self.owner.path)
  {
    if (path_)
    {
      return [[self.owner path] stringByAppendingPathComponent:path_];
    }
    else
    {
      return self.owner.path;
    }
  }
  return path_;
}

@end
