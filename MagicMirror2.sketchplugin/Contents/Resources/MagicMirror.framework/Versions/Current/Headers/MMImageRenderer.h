//
//  ImageRenderer.h
//  MagicMirror2
//
//  Created by James Tang on 10/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

@import AppKit;

#import "MMController.h"
@protocol MSLayer;

typedef enum {
    MMImageRenderQualityAuto = 0,
    MMImageRenderQuality1x = 1,
    MMImageRenderQuality2x = 2,
    MMImageRenderQualityMax = 3,
} MMImageRenderQuality;

typedef enum {
    ImageRendererColorSpaceGenericRGB = 0,
    ImageRendererColorSpaceGenericGray = 1,
    ImageRendererColorSpaceGenericCMYK = 2,
    ImageRendererColorSpaceDeviceRGB = 3,
    ImageRendererColorSpaceDeviceGray = 4,
    ImageRendererColorSpaceDeviceCMYK = 5,
    ImageRendererColorSpaceSRGB = 6,
    ImageRendererColorSpaceGenericGamma22GrayColorSpace = 7,
    ImageRendererColorSpaceAdobeRGB1998 = 8,
} ImageRendererColorSpaceIdentifier;

@interface MMImageRenderer : MMController

@property (nonatomic, strong) id <MSLayer> layer;
@property (nonatomic, strong) NSBezierPath *bezierPath;
@property (nonatomic) ImageRendererColorSpaceIdentifier colorSpaceIdentifier;
@property (nonatomic) MMImageRenderQuality imageQuality;      // 0 is auto
@property (nonatomic) BOOL disablePerspective;
@property (nonatomic) NSUInteger rotation;
@property (nonatomic) BOOL flipped;

- (NSImage *)flattenedImage;
- (NSImage *)exportedImage;


@end
