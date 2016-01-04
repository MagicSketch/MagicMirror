//
//  Weak.m
//  MagicMirror2
//
//  Created by James Tang on 4/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import "Weak.h"

@implementation Weak

+ (instancetype)weakWithObject:(id)object {
    Weak *weak = [[Weak alloc] init];
    weak.object = object;
    return weak;
}

@end
