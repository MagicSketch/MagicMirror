//
//  MagicMirror+MMTracker.m
//  MagicMirror2
//
//  Created by James Tang on 11/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import "MagicMirror+MMTracker.h"
#import "MagicMirror-Private.h"

@implementation MagicMirror (MMTracker)

- (void)track:(NSString *)event {
    [self.tracker track:event];
}

@end
