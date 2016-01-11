//
//  MMTracker.m
//  MagicMirror2
//
//  Created by James Tang on 11/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import "MMTracker.h"
#import "MagicMirror.h"
#import "Mixpanel.h"
#import "MMLicenseInfo.h"

@interface MMTracker ()

@property (nonatomic, strong) Mixpanel *mixpanel;

@end

@implementation MMTracker

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mixpanel = [Mixpanel sharedInstanceWithToken:@"5efc9a36b4256b59de860982791e2db5"];
        [self register];
        [self registerUser];
    }
    return self;
}

- (void)track:(NSString *)event {
    [self.mixpanel track:event];
}

- (void)track:(NSString *)event properties:(NSDictionary *)properties {
    [self.mixpanel track:event properties:properties];
}

- (void)register {
    [self.mixpanel registerSuperProperties:@{
                                             @"MMVersion":[self.magicmirror version],
                                             @"MMBuild":[self.magicmirror build],
                                             @"MMEnvironment":NSStringFromMMEnv([self.magicmirror env]),
                                             }];
}

- (void)registerUser {
    MMLicenseInfo *info = [self.magicmirror licensedTo];
    if (info) {
        [self.mixpanel identify:[info license]];
        [[self.mixpanel people] set:@{
                                      @"$first_name":[info firstName],
                                      @"$last_name":[info lastName],
                                      @"$email":[info email],
                                      @"MMLicense":[info license],
                                      }];
    }
}

- (void)registerProperties:(NSDictionary *)properties {
    [self.mixpanel registerSuperProperties:properties];
}

#pragma mark - MMController

- (void)magicmirrorLicenseDetached:(MagicMirror *)magicmirror {
}

- (void)magicmirrorLicenseUnlocked:(MagicMirror *)magicmirror {
    [self registerUser];
}

@end
