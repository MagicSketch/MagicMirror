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
#import "MMImageLoader.h"
#import "NSRect+Math.h"
#import "NSImage+Transform.h"
#import "Sketch.h"

typedef enum : NSUInteger {
    MMImageRendererWatermarkStyleCenter,
    MMImageRendereriWatermarkStylePattern,
} MMImageRendererWatermarkStyle;

@interface MMImageRenderer ()

@property (nonatomic, strong) id <MSLayerFlattener> flattener;
@property (nonatomic, strong) MMImageLoader *loader;
@property (nonatomic) BOOL addWatermarks;
@property (nonatomic) MMImageRendererWatermarkStyle watermarkStyle;
@property (nonatomic) CGFloat defaultScale;


@end

@interface MMImageRenderer (MMController) <MMController>

@end

@implementation MMImageRenderer

- (id)init {
    if (self = [super init]) {
        _colorSpaceIdentifier = ImageRendererColorSpaceDeviceRGB;
        _loader = [[MMImageLoader alloc] init];
        [self setRegistered:[self.magicmirror isRegistered]];
    }
    return self;
}

- (NSImage *)flattenedImage {
    MMLog(@"flattening image");
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

    MMLog(@"exporting image");
    id <MSExportRequest> request = [Sketch requestWithRect:[self.layer rect] scale:[self currentScale]];
    id <MSExportRenderer> renderer = [Sketch exportRendererForRequest:request colorSpace:self.colorSpace];
    [Sketch setPage:self.layer.parentPage forRequest:request];
    request.rootLayerID = [self.layer objectID];
    NSImage *image = [renderer image];
    NSImage *newImage = nil;

    if ( ! self.disablePerspective) {
        newImage = [image imageForPath:self.bezierPath scale:self.imageQuality ?: self.defaultScale];
    } else {
        newImage = image;
    }
    MMLog(@"request %@", request);
    MMLog(@"renderer %@", renderer);
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
    NSImage *image = [self.loader imageNamed:@"watermark"];
    NSRect contentRect = CGRectAspectFittingSize(frame, image.size);
    {
        if (self.watermarkStyle == MMImageRendererWatermarkStyleCenter) {
            [image drawInRect:contentRect
                     fromRect:NSZeroRect
                    operation:NSCompositeSourceOver
                     fraction:1.0
               respectFlipped:YES
                        hints:nil];
        } else {
            NSImage *scaledImage = [[NSImage alloc] initWithCGImage:[image CGImage] size:contentRect.size];
            NSGraphicsContext *context = [NSGraphicsContext currentContext];
            CGContextDrawTiledImage(context.CGContext, CGRectMake(0, 0, scaledImage.size.width, scaledImage.size.height), [scaledImage CGImage]);
        }

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

//        NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
//        textStyle.alignment = NSCenterTextAlignment;
//
//        NSDictionary* textFontAttributes = @{NSFontAttributeName: [NSFont systemFontOfSize: NSFont.systemFontSize * scale], NSForegroundColorAttributeName: NSColor.greenColor, NSParagraphStyleAttributeName: textStyle};
//
//        NSRect textInset = NSInsetRect(textRect, 10  * scale, 10 * scale);
//        CGFloat textTextHeight = NSHeight([textContent boundingRectWithSize: textInset.size options: NSStringDrawingUsesLineFragmentOrigin attributes: textFontAttributes]);
//        NSRect textTextRect = NSMakeRect(NSMinX(textInset), NSMinY(textInset) + (NSHeight(textInset) - textTextHeight) / 2, NSWidth(textInset), textTextHeight);
//        [NSGraphicsContext saveGraphicsState];
//        NSRectClip(textInset);
//        [textContent drawInRect: NSOffsetRect(textTextRect, 0, 1) withAttributes: textFontAttributes];
//        [NSGraphicsContext restoreGraphicsState];
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

