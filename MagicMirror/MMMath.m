//
//  Math.m
//  MagicMirror2
//
//  Created by James Tang on 18/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "MMMath.h"

@implementation MMMath

CGFloat CGSizeAspectFillRatio(CGSize from, CGSize to) {
    return MAX(to.width / from.width, to.height / from.height);
}

@end
