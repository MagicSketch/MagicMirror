//
//  MMController.m
//  MagicMirror2
//
//  Created by James Tang on 6/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import "MMController.h"
#import "MagicMirror.h"

@implementation MMController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [MagicMirror addObserver:self];

    }
    return self;
}

@end