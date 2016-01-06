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

@interface MMImageRenderer ()

@property (nonatomic, strong) id <MSLayerFlattener> flattener;
@property (nonatomic) BOOL addWatermarks;

@end

@implementation MMImageRenderer

- (id)init {
    if (self = [super init]) {
        _colorSpaceIdentifier = ImageRendererColorSpaceDeviceRGB;
        _addWatermarks = YES;
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
        image = [image imageForPath:self.bezierPath scale:self.scale];
    }

    [self addWatermarkOnImageIfNeeded:image];

    return image;
}

- (NSImage *)exportedImage {
    id <MSExportRequest> request = [NSClassFromString(@"MSExportRequest") requestWithRect:[self.layer rect] scale:self.scale];
    id <MSExportRenderer> renderer = [NSClassFromString(@"MSExportRenderer") exportRendererForRequest:request colorSpace:self.colorSpace];
    request.page = [self.layer parentPage];
    request.rootLayerID = [self.layer objectID];
    NSImage *image = [renderer image];

    if ( ! self.disablePerspective) {
        image = [image imageForPath:self.bezierPath scale:self.scale];
    }

    [self addWatermarkOnImageIfNeeded:image];

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

- (void)addWatermarkOnImageIfNeeded:(NSImage *)image {
    if (self.addWatermarks && self.scale >= 2) {
        [image lockFocus];
        CGFloat padding = 10;
        [self drawWatermarksWithFrame:CGRectMake(padding, padding, image.size.width - padding * 2, image.size.height - padding * 2)];
        [image unlockFocus];
    }
}

- (void)drawWatermarksWithFrame: (NSRect)frame
{

    //// Text Drawing
    NSRect textRect = frame;
    {
        NSString* textContent = self.scale == 2 ? @"Retina @2x image quality avaliable in Magic Mirror Pro Version" : @"Adaptive + @3x image quality avaliable in Magic Mirror Pro Version" ;
        NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        textStyle.alignment = NSCenterTextAlignment;

        NSDictionary* textFontAttributes = @{NSFontAttributeName: [NSFont systemFontOfSize: NSFont.systemFontSize * (CGFloat)self.scale], NSForegroundColorAttributeName: NSColor.greenColor, NSParagraphStyleAttributeName: textStyle};

        NSRect textInset = NSInsetRect(textRect, 10  * (CGFloat)self.scale, 10 * (CGFloat)self.scale);
        CGFloat textTextHeight = NSHeight([textContent boundingRectWithSize: textInset.size options: NSStringDrawingUsesLineFragmentOrigin attributes: textFontAttributes]);
        NSRect textTextRect = NSMakeRect(NSMinX(textInset), NSMinY(textInset) + (NSHeight(textInset) - textTextHeight) / 2, NSWidth(textInset), textTextHeight);
        [NSGraphicsContext saveGraphicsState];
        NSRectClip(textInset);
        [textContent drawInRect: NSOffsetRect(textTextRect, 0, 1) withAttributes: textFontAttributes];
        [NSGraphicsContext restoreGraphicsState];
    }
}

@end
