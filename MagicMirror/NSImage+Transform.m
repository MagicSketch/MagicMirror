//
//  NSImage+Transform.m
//  MagicMirror2
//
//  Created by James Tang on 9/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "NSImage+Transform.h"
@import CoreGraphics;
@import CoreImage;
#import "Quad.h"
#import "MSShapePath.h"
#import "MagicMirror.h"

@implementation NSImage (Transform)

- (CIImage *)getCIImageFromNSImage:(NSImage *)nsimage {
    NSData *tiffData = [nsimage TIFFRepresentation];
    NSBitmapImageRep *bitmap = [NSBitmapImageRep imageRepWithData:tiffData];
    CIImage *ciImage = [[CIImage alloc] initWithBitmapImageRep:bitmap];
    return ciImage;
}

- (CGImageRef)getCGImage:(NSImage *)image {
    NSSize size = image.size;
    CGContextRef bitmapCtx = CGBitmapContextCreate(nil,
                                                 size.width,
                                                 size.height,
                                                 8,
                                                 0,
                                                 [[NSColorSpace genericRGBColorSpace] CGColorSpace],
                                                 kCGBitmapByteOrder32Host|kCGImageAlphaPremultipliedFirst);
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithGraphicsPort:bitmapCtx flipped:false]];
    [image drawInRect:NSMakeRect(0,0, size.width, size.height) fromRect:NSZeroRect operation:NSCompositeCopy fraction:2.0];
    [NSGraphicsContext restoreGraphicsState];
    CGImageRef imageRef = CGBitmapContextCreateImage(bitmapCtx);
    CGContextRelease(bitmapCtx);
    return imageRef;
}

- (NSImage *)getNSImage:(CIImage *)ciimage {
    NSCIImageRep *rep = [NSCIImageRep imageRepWithCIImage: ciimage];
    NSImage *image = [[NSImage alloc] initWithSize:[ciimage extent].size];
    [image addRepresentation:rep];
    return image;
}

- (NSImage *)imageForPath:(id <MSShapePath>)path scale:(CGFloat)scale {
    CGFloat targetedScale = scale;
    CIImage *ciimage = [self getCIImageFromNSImage:self];


    Quad *quad = [Quad quadWithShapePath:path];
    Quad *newQuad = [quad scaledQuad:targetedScale];
    CGPoint topLeft = newQuad.tl;
    CGPoint topRight = newQuad.tr;
    CGPoint bottomLeft = newQuad.bl;
    CGPoint bottomRight = newQuad.br;
    CGFloat y = MAX(topLeft.y, MAX(bottomLeft.y, MAX(bottomRight.y, topRight.y)));

    CIFilter *filter = [CIFilter filterWithName:@"CIPerspectiveTransform"];
    [filter setValue:ciimage forKey:@"inputImage"];
    [filter setValue:[CIVector vectorWithX:topLeft.x Y:y - topLeft.y] forKey:@"inputTopLeft"];
    [filter setValue:[CIVector vectorWithX:topRight.x Y:y - topRight.y] forKey:@"inputTopRight"];
    [filter setValue:[CIVector vectorWithX:bottomRight.x Y:y - bottomRight.y] forKey:@"inputBottomRight"];
    [filter setValue:[CIVector vectorWithX:bottomLeft.x Y:y - bottomLeft.y] forKey:@"inputBottomLeft"];
    CIImage *output = [filter outputImage]; // CIImage

    NSImage *nsimage = [self getNSImage:output];
    NSSize size = nsimage.size;
    MMLog(@"size %@", NSStringFromSize(size));
    return nsimage;
}

@end
