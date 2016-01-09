//
//  Quad.m
//  MagicMirror2
//
//  Created by James Tang on 9/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "Quad.h"
#import "NSBezierPath+Alter.h"

@implementation Quad

+ (instancetype)quadWithShapePath:(NSBezierPath *)path {
    Quad *quad = [[self alloc] init];

    if ([path isClockwise]) {
        quad.tl = NSPointFromString([path points][0]);
        quad.tr = NSPointFromString([path points][1]);
        quad.br = NSPointFromString([path points][2]);
        quad.bl = NSPointFromString([path points][3]);
    } else {
        quad.tl = NSPointFromString([path points][0]);
        quad.bl = NSPointFromString([path points][1]);
        quad.br = NSPointFromString([path points][2]);
        quad.tr = NSPointFromString([path points][3]);
    }
    return quad;
}

- (instancetype)scaledQuad:(CGFloat)scale {
    Quad *newQuad = [[Quad alloc] init];

    CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
    CGPoint topLeft = CGPointApplyAffineTransform(self.tl, transform);
    CGPoint topRight = CGPointApplyAffineTransform(self.tr, transform);
    CGPoint bottomLeft = CGPointApplyAffineTransform(self.bl, transform);
    CGPoint bottomRight = CGPointApplyAffineTransform(self.br, transform);

    newQuad.tl = topLeft;
    newQuad.tr = topRight;
    newQuad.bl = bottomLeft;
    newQuad.br = bottomRight;

    return newQuad;
}

+ (instancetype)quadWithTopLeft:(CGPoint)topLeft topRight:(CGPoint)topRight bottomLeft:(CGPoint)bottomLeft bottomRight:(CGPoint)bottomRight {
    Quad *newQuad = [[Quad alloc] init];
    newQuad.tl = topLeft;
    newQuad.tr = topRight;
    newQuad.bl = bottomLeft;
    newQuad.br = bottomRight;
    return newQuad;
}

@end

