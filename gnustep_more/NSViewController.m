/* 
 NSViewController.m
 
 Copyright (C) 2010 Free Software Foundation, Inc.
 
 This file is part of the GNUstep GUI Library.
 
 This library is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 2 of the License, or (at your option) any later version.
 
 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU
 Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public
 License along with this library; see the file COPYING.LIB.
 If not, see <http://www.gnu.org/licenses/> or write to the 
 Free Software Foundation, 51 Franklin Street, Fifth Floor, 
 Boston, MA 02110-1301, USA.
 */ 

#import "AppKit/NSViewController.h"
#import "AppKit/NSNib.h"
#import "config.h"
#if !HAVE_NSNIBOWNER
static NSString *NSNibOwner = @"NSOwner";
#endif

@implementation NSViewController

- (void) dealloc
{
  DESTROY(_nibName);
  DESTROY(_nibBundle);
  DESTROY(_representedObject);
  DESTROY(_title);
  DESTROY(_topLevelObjects);
  DESTROY(_editors);
  DESTROY(_autounbinder);
  DESTROY(_designNibBundleIdentifier);
  
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil
{
  [super init];
  
  ASSIGN(_nibName, nibNameOrNil);
  ASSIGN(_nibBundle, nibBundleOrNil);
  
  return self;
}

- (void)setRepresentedObject:(id)representedObject
{
  ASSIGN(_representedObject, representedObject);
}

- (id)representedObject
{
  return _representedObject;
}

- (void)setTitle:(NSString *)title
{
  ASSIGN(_title, title);
}

- (NSString *)title
{
  return _title;
}

- (NSView *)view
{
  if(!view)
    {
      // FIXME we should loadView only once
      [self loadView];
    }
  return view;
}

- (void)setView:(NSView *)aView
{
  view = aView;
}

- (NSString *)nibName
{
  return _nibName;
}

- (NSBundle *)nibBundle
{
  return _nibBundle;
}


- (void)commitEditingWithDelegate:(id)delegate 
                didCommitSelector:(SEL)didCommitSelector 
                      contextInfo:(void *)contextInfo
{
  [self notImplemented: _cmd];
}

- (BOOL)commitEditing
{
  [self notImplemented: _cmd];

  return NO;
}

- (void)discardEditing
{
  [self notImplemented: _cmd];
}

- (void)loadView
{
  NSDictionary *table;
  NSString *nibPath;

  // FIXME NSWindowController uses a flag "nib_is_loaded".
  // However, short of making use of one of the reserved slots,
  // I see no way to add a flags structure while maintaining 
  // compatibility.

  // For purposes of this early, quick and dirty patch, 
  // let's conclude that nib isn't loaded if view controller's
  // view is nil. While not right, it'll do for the purposes
  // of getting initWithNibName to work.

  if(view) // TODO if we use a flag to record that nib is loaded, 
            // use flag here
    {
      // nib is loaded
      return;
    }
  
  // FIXME this only supports nibs in main bundle
  nibPath = [[NSBundle mainBundle] pathForNibResource: _nibName];

  table = [NSDictionary dictionaryWithObject: self forKey: NSNibOwner];
  if ([NSBundle loadNibFile: nibPath
		externalNameTable: table
		withZone: [self zone]])
    {
      // TODO if we use a flag to record that nib is loaded, set it to true here
	  
      // success!
    }
  else
    {
      if (_nibName != nil)
        {
	  NSLog (@"%@: could not load nib named %@.nib", 
		 [self class], _nibName);
	}
    }



}

@end
