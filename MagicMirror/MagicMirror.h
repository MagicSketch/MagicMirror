//
//  MagicMirror.h
//  MagicMirror
//
//  Created by James Tang on 7/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CDUnknownBlockType.h"
#import "Sketch.h"

//! Project version number for MagicMirror.
FOUNDATION_EXPORT double MagicMirrorVersionNumber;

//! Project version string for MagicMirror.
FOUNDATION_EXPORT const unsigned char MagicMirrorVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <MagicMirror/PublicHeader.h>

#define MMLog(fmt, ...) NSLog((@"MagicMirror: %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

@protocol COScript;

@interface MagicMirror : NSObject

- (id)initWithPlugin:(MSPluginBundle *)plugin
            document:(MSDocument *)document
           selection:(NSArray *)selection
             command:(MSPluginCommand *)command;

- (void)log;
- (void)showWindow;

- (void)keepAround;
- (void)goAway;

@end
