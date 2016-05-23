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

#import "MMImageRenderer.h"
@protocol COScript;
@protocol MSLayer;
@protocol MSArtboardGroup;
@protocol MSShapeGroup;
@protocol MMController;
@protocol SketchEventsController;

@class MMLayerProperties;
@class SketchPluginContext;
@class MMLicenseInfo;

typedef enum : NSUInteger {
    MMEnvDevelopment,
    MMEnvProduction,
} MMEnv;

extern NSString *NSStringFromMMEnv(MMEnv env);
extern NSString *NSStringFromMMImageRenderQuality(MMImageRenderQuality quality);

@interface MagicMirror : NSObject

@property (nonatomic, readonly) NSUInteger lifeCount;
@property (nonatomic, copy, readonly) NSString *version;
@property (nonatomic, copy, readonly) NSString *build;
@property (nonatomic, readonly) MMEnv env;
@property (nonatomic, copy, readonly) NSString *baseURLString;

+ (instancetype)sharedInstance;
+ (instancetype)sharedInstanceWithContext:(SketchPluginContext *)context;
+ (void)setSharedInstance:(MagicMirror *)sharedInstance;
+ (void)addObserver:(id <MMController>)observer;

- (void)closeToolbar;
- (void)showToolbar;
- (void)showLicenseInfo;
- (void)keepAround;
- (void)goAway;
- (void)openURL:(NSString *)urlString;

// Per Layer
//- (void)refreshArtboard:(id <MSArtboardGroup>)artboard;
//- (void)refreshLayer:(id <MSShapeGroup>)layer;
//- (void)clearLayer:(id <MSShapeGroup>)layer;
//- (void)setArtboard:(id <MSArtboardGroup>)artboard forLayer:(id <MSShapeGroup>)layer;
//- (void)setImageQuality:(NSNumber *)imageQuality forLayer:(id <MSShapeGroup>)layer;
//- (void)flipLayer:(id <MSShapeGroup>)layer;
//- (void)rotateLayer:(id <MSShapeGroup>)layer;
- (void)mirrorLayer:(id <MSShapeGroup>)layer fromArtboard:(id <MSArtboardGroup>)artboard imageQuality:(MMImageRenderQuality)imageQuality perspective:(BOOL)perspective;

// Others
//- (void)jumpToArtboard:(NSString *)artboardName;

// All Selection
- (void)setArtboard:(id <MSArtboardGroup>)artboard;
- (void)setImageQuality:(NSNumber *)imageQuality;
- (void)setEnablePerspective:(NSNumber *)enablePerspective;
- (void)setClear;

// Entry Points
- (void)configureSelection;
- (void)licenseInfo;
- (void)flipSelection;
- (void)jumpSelection;
- (void)refreshPageOrSelection;
- (void)refreshSelection;
- (void)refreshPage;
- (void)rotateSelection;
- (void)checkForUpdates;

//- (NSArray *)artboards;
//- (NSDictionary *)artboardsLookup;
- (NSArray *)selectedLayers;
- (NSArray *)allLayers;

- (NSString *)manifestFilePath;


@end



#pragma mark -

typedef void(^MMLicenseUnlockHandler)(MMLicenseInfo *info, NSError *error);

@interface MagicMirror (API)

- (void)unlockLicense:(NSString *)license completion:(MMLicenseUnlockHandler)completion;
- (MMLicenseInfo *)licensedTo;
- (void)deregister;
- (BOOL)isRegistered;

@end
