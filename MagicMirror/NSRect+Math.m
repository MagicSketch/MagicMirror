//
//  NSRect+Math.m
//  MagicMirror2
//
//  Created by James Tang on 12/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import "NSRect+Math.h"

CGRect CGRectAspectFittingSize(CGRect outside, CGSize size) {
    CGSize scaledSize = CGSizeZero;
    CGPoint origin = CGPointZero;
    CGFloat aspectWidth =  outside.size.width / size.width;
    CGFloat aspectHeight = outside.size.height / size.height;
    CGFloat aspectRatio = MIN ( aspectWidth, aspectHeight );

    scaledSize.width = size.width * aspectRatio;
    scaledSize.height = size.height * aspectRatio;
    origin.x = (outside.size.width - scaledSize.width) / 2.0f;
    origin.y = (outside.size.height - scaledSize.height) / 2.0f;
    return (CGRect){origin, scaledSize};
}
