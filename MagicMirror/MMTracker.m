//
//  MMTracker.m
//  MagicMirror2
//
//  Created by James Tang on 11/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import "MMTracker.h"
#import "Mixpanel.h"

@interface MMTracker ()

@property (nonatomic, strong) Mixpanel *mixpanel;

@end

@implementation MMTracker

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mixpanel = [Mixpanel sharedInstanceWithToken:@"5efc9a36b4256b59de860982791e2db5"];
    }
    return self;
}

- (void)track:(NSString *)event {
    [self.mixpanel track:event];
}

@end
