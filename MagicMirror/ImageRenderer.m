//
//  ImageRenderer.m
//  MagicMirror2
//
//  Created by James Tang on 10/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "ImageRenderer.h"
#import "NSImage+Transform.h"
#import "MSLayer.h"
#import "MSLayerFlattener.h"
#import "MSLayerArray.h"
#import "MSExportRequest.h"
#import "MSExportRenderer.h"
#import "MSShapePath.h"

@interface ImageRenderer ()

@property (nonatomic, strong) id <MSLayerFlattener> flattener;

@end

@implementation ImageRenderer

- (id)init {
    if (self = [super init]) {
        _colorSpaceIdentifier = ImageRendererColorSpaceDeviceRGB;
    }
    return self;
}

- (NSImage *)flattenedImage {
    id <MSLayerFlattener> flattener = self.flattener;

    if ( ! flattener) {
        flattener = [[NSClassFromString(@"MSLayerFlattener") alloc] init];
        self.flattener = flattener;
    }
    id array = [NSClassFromString(@"MSLayerArray") arrayWithLayer:self.layer];
    NSImage *image = [flattener imageFromLayers:array lightweightPage:self.layer];

    if ( ! self.disablePerspective) {
        image = [image imageForPath:self.bezierPath];
    }
    return image;
}

- (NSImage *)exportedImage {
    id <MSExportRequest> request = [NSClassFromString(@"MSExportRequest") requestWithRect:[self.layer rect] scale:self.scale];
    id <MSExportRenderer> renderer = [NSClassFromString(@"MSExportRenderer") exportRendererForRequest:request colorSpace:self.colorSpace];
    request.page = [self.layer parentPage];
    request.rootLayerID = [self.layer objectID];
    NSImage *image = [renderer image];

    if ( ! self.disablePerspective) {
        image = [image imageForPath:self.bezierPath];
    }
    return image;
}

- (NSColorSpace *)colorSpace {
    return @[
             [NSColorSpace genericRGBColorSpace],
             [NSColorSpace genericGrayColorSpace],
             [NSColorSpace genericCMYKColorSpace],
             [NSColorSpace deviceRGBColorSpace],
             [NSColorSpace deviceGrayColorSpace],
             [NSColorSpace deviceCMYKColorSpace],
             [NSColorSpace sRGBColorSpace],
             [NSColorSpace genericGamma22GrayColorSpace],
             [NSColorSpace adobeRGB1998ColorSpace],
        ][self.colorSpaceIdentifier];
}

@end
