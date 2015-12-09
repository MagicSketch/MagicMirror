//
//  MagicMirror.h
//  MagicMirror
//
//  Created by James Tang on 7/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//! Project version number for MagicMirror.
FOUNDATION_EXPORT double MagicMirrorVersionNumber;

//! Project version string for MagicMirror.
FOUNDATION_EXPORT const unsigned char MagicMirrorVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <MagicMirror/PublicHeader.h>

#define MMLog(fmt, ...) NSLog((@"MagicMirror: %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

@protocol COScript;
@class SketchPluginContext;

@interface MagicMirror : NSObject

- (id)initWithContext:(SketchPluginContext *)context;

- (void)log;
- (void)showWindow;
- (void)keepAround;
- (void)goAway;

- (void)mirrorPage;
- (NSArray *)artboards;
- (NSArray *)selectedLayers;
- (void)licenseInfo;

@end
