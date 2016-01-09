//
//  ImageRenderer.m
//  MagicMirror2
//
//  Created by James Tang on 10/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "MMImageRenderer.h"
#import "NSImage+Transform.h"
#import "MSLayer.h"
#import "MSLayerFlattener.h"
#import "MSLayerArray.h"
#import "MSExportRequest.h"
#import "MSExportRenderer.h"
#import "MSShapePath.h"
#import "MMMath.h"
#import "MagicMirror.h"

@interface MMImageRenderer ()

@property (nonatomic, strong) id <MSLayerFlattener> flattener;
@property (nonatomic) BOOL addWatermarks;
@property (nonatomic) CGFloat defaultScale;


@end

@interface MMImageRenderer (MMController) <MMController>

@end

@implementation MMImageRenderer

- (id)init {
    if (self = [super init]) {
        _colorSpaceIdentifier = ImageRendererColorSpaceDeviceRGB;
        [self setRegistered:[self.magicmirror isRegistered]];
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
        image = [image imageForPath:self.bezierPath scale:self.imageQuality ?: self.defaultScale];
    }

    [self addWatermarkOnImageIfNeeded:image];

    return image;
}

- (NSImage *)exportedImage {
    id <MSExportRequest> request = [NSClassFromString(@"MSExportRequest") requestWithRect:[self.layer rect] scale:[self currentScale]];
    id <MSExportRenderer> renderer = [NSClassFromString(@"MSExportRenderer") exportRendererForRequest:request colorSpace:self.colorSpace];
    request.page = [self.layer parentPage];
    request.rootLayerID = [self.layer objectID];
    NSImage *image = [renderer image];
    NSImage *newImage = nil;

    if ( ! self.disablePerspective) {
        newImage = [image imageForPath:self.bezierPath scale:self.imageQuality ?: self.defaultScale];
    }
    MMLog(@"image %@", NSStringFromSize(image.size));
    MMLog(@"newImage %@", NSStringFromSize(newImage.size));

    [self addWatermarkOnImageIfNeeded:newImage];

    return newImage;
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

- (void)addWatermarkOnImageIfNeeded:(NSImage *)image {
    if (self.addWatermarks && self.imageQuality >= MMImageRenderQuality2x) {
        [image lockFocus];
        CGFloat padding = 10;
        [self drawWatermarksWithFrame:CGRectMake(padding, padding, image.size.width - padding * 2, image.size.height - padding * 2)];
        [image unlockFocus];
    }
}

- (CGFloat)currentScale {

    CGFloat scale = 0;
//    scale = CGSizeAspectFillRatio(_layer.rect.size, CGSizeApplyAffineTransform(_layer.rect.size, CGAffineTransformMakeScale(self.imageQuality, self.imageQuality)));
    switch (self.imageQuality) {
        case MMImageRenderQualityAuto:
            scale = self.defaultScale;
            break;
        case MMImageRenderQuality2x:
            scale = 2;
            break;
        case MMImageRenderQualityMax:
            scale = CGSizeAspectFillRatio(_layer.rect.size, CGSizeApplyAffineTransform(_bezierPath.bounds.size, CGAffineTransformMakeScale(self.imageQuality, self.imageQuality)));
            break;
        default:
            scale = 1;
            break;
    }
    return scale;
}

- (void)drawWatermarksWithFrame: (NSRect)frame
{

    //// Text Drawing
    NSRect textRect = frame;
    {

        CGFloat scale = [self currentScale];
        NSString* textContent = nil;

        switch (self.imageQuality) {
            case MMImageRenderQuality2x:
                textContent = @"Retina @2x image quality avaliable in Magic Mirror Pro Version";
                break;
            case MMImageRenderQualityMax:
                textContent = @"Max image quality avaliable in Magic Mirror Pro Version";
                break;
            case MMImageRenderQualityAuto:
            default:
                break;
        }

        NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        textStyle.alignment = NSCenterTextAlignment;

        NSDictionary* textFontAttributes = @{NSFontAttributeName: [NSFont systemFontOfSize: NSFont.systemFontSize * scale], NSForegroundColorAttributeName: NSColor.greenColor, NSParagraphStyleAttributeName: textStyle};

        NSRect textInset = NSInsetRect(textRect, 10  * scale, 10 * scale);
        CGFloat textTextHeight = NSHeight([textContent boundingRectWithSize: textInset.size options: NSStringDrawingUsesLineFragmentOrigin attributes: textFontAttributes]);
        NSRect textTextRect = NSMakeRect(NSMinX(textInset), NSMinY(textInset) + (NSHeight(textInset) - textTextHeight) / 2, NSWidth(textInset), textTextHeight);
        [NSGraphicsContext saveGraphicsState];
        NSRectClip(textInset);
        [textContent drawInRect: NSOffsetRect(textTextRect, 0, 1) withAttributes: textFontAttributes];
        [NSGraphicsContext restoreGraphicsState];
    }
}

- (void)setRegistered:(BOOL)isRegistered {
    if (isRegistered) {
        self.addWatermarks = NO;
        self.defaultScale = 2;
    } else {
        self.addWatermarks = YES;
        self.defaultScale = 1;
    }
}


- (void)magicmirrorLicenseUnlocked:(MagicMirror *)magicmirror {
    [self setRegistered:YES];
}

- (void)magicmirrorLicenseDetached:(MagicMirror *)magicmirror {
    [self setRegistered:NO];
}

@end

