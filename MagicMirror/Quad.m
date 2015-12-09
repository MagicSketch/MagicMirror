//
//  Quad.m
//  MagicMirror2
//
//  Created by James Tang on 9/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "Quad.h"
#import "MSShapePath.h"

@implementation Quad

+ (instancetype)quadWithShapePath:(id <MSShapePath>)path {
    Quad *quad = [[self alloc] init];
    quad.tl = (CGPoint)[path pointAtIndex:0];
    quad.tr = (CGPoint)[path pointAtIndex:1];
    quad.br = (CGPoint)[path pointAtIndex:2];
    quad.bl = (CGPoint)[path pointAtIndex:3];
    return quad;
}

@end
