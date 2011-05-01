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


#import "ZCPBXShellScriptBuildPhaseInspectorViewController.h"

@implementation ZCPBXShellScriptBuildPhaseInspectorViewController
@synthesize shellScriptBuildPhase;

-(void)itemWasSwitched
{
    if(!item)
        return;
    
    self.shellScriptBuildPhase = (PBXShellScriptBuildPhase*)item;
    
    NSAttributedString *shellScriptText = 
        [[[NSAttributedString alloc] initWithString:shellScriptBuildPhase.shellScript 
                                         attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                     [NSFont fontWithName:@"Andale Mono"
                                                                     size:10], NSFontAttributeName, 
                                                     nil]] autorelease];
    [[shellScript textStorage] setAttributedString:shellScriptText];
}

-(void)dealloc
{
    self.shellScriptBuildPhase = nil;
    [super dealloc];
}

@end
