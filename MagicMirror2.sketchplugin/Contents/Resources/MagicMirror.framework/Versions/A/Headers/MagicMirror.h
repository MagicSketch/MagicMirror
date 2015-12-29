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

#import "ImageRenderer.h"
@protocol COScript;
@protocol MSLayer;
@protocol MSArtboardGroup;
@protocol MSShapeGroup;
@class MMLayerProperties;
@class SketchPluginContext;

@interface MagicMirror : NSObject

- (id)initWithContext:(SketchPluginContext *)context;

- (void)showWindow;
- (void)showLicenseInfo;
- (void)keepAround;
- (void)goAway;

// Per Layer
//- (void)refreshLayer:(id <MSShapeGroup>)layer;
//- (void)clearLayer:(id <MSShapeGroup>)layer;
//- (void)setArtboard:(id <MSArtboardGroup>)artboard forLayer:(id <MSShapeGroup>)layer;
//- (void)setImageQuality:(NSNumber *)imageQuality forLayer:(id <MSShapeGroup>)layer;
//- (void)flipLayer:(id <MSShapeGroup>)layer;
//- (void)rotateLayer:(id <MSShapeGroup>)layer;

// Others
//- (void)jumpToArtboard:(NSString *)artboardName;

// All Selection
- (void)setArtboard:(id <MSArtboardGroup>)artboard;
- (void)setImageQuality:(NSNumber *)imageQuality;
- (void)setClear;

// Entry Points
- (void)licenseInfo;
- (void)mirrorPage;
- (void)rotateSelection;
- (void)flipSelection;
- (void)jumpSelection;
- (void)configureSelection;

//- (NSArray *)artboards;
- (NSDictionary *)artboardsLookup;
- (NSArray *)selectedLayers;


@end


@interface MagicMirror (MSShapeGroup)

- (NSString *)sourceForLayer:(id <MSShapeGroup>)layer;
- (void)setProperties:(MMLayerProperties *)properties forLayer:(id<MSShapeGroup>)layer;
- (MMLayerProperties *)layerPropertiesForLayer:(id <MSShapeGroup>)layer;

@end

#pragma mark -

typedef void(^MMLicenseUnlockHandler)(NSDictionary *result, NSError *error);

@interface MagicMirror (API)

- (void)unlockLicense:(MMLicenseUnlockHandler)completion;

@end
