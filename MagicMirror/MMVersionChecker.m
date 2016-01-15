//
//  MMVersionChecker.m
//  MagicMirror2
//
//  Created by James Tang on 14/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import "MMVersionChecker.h"
#import "MMManifest.h"
#import "MagicMirror.h"
#import "MMVersionChecker-Private.h"
#import "MMVersionUpdateActor.h"

@interface MMVersionChecker ()

@property (nonatomic) BOOL isShowed;
@property (nonatomic, strong) MMManifest *local;

@property (nonatomic) MMDay skippingDays;

@end

@implementation MMVersionChecker

+ (instancetype)versionChecker {
    MMVersionChecker *checker = [[MMVersionChecker alloc] init];
    return checker;
}

+ (instancetype)versionCheckerWithLocal:(MMManifest *)local remote:(MMManifest *)remote lastChecked:(NSDate *)lastChecked {
    MMVersionChecker *checker = [[MMVersionChecker alloc] init];
    checker.local = local;
    checker.remote = remote;
    checker.lastChecked = lastChecked;
    return checker;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _skippingDays = 7;
    }
    return self;
}

- (void)fetchLocal {
    NSString *path = [self.magicmirror manifestFilePath];
    self.local = [MMManifest manifestFromFilePath:path];

    MMLog(@"magicmirror %@", self.magicmirror);
    MMLog(@"path %@", path);
    MMLog(@"self.local %@", self.local);
    MMLog(@"self.local.checkULR %@", self.local.checkURL);
    MMLog(@"self.local.version %@", self.local.version);
}

- (void)fetchRemoteCompletion:(MMManifestURLCompletionHandler)completion {

    if (self.remote) {
        completion(self.remote, nil);
        return;
    }

    NSURL *url = [NSURL URLWithString:@"https://raw.githubusercontent.com/jamztang/MagicMirror/master/Magic%20Mirror.sketchplugin/Contents/Sketch/manifest.json"];
     __weak __typeof (self) weakSelf = self;
    [MMManifest manifestFromURL:url
                     completion:^(MMManifest *manifest, NSError *error) {
                         if ( ! error) {
                             weakSelf.remote = manifest;
                         }
                         completion(manifest, error);
                     }];

}

- (void)checkForUpdates:(MMVersionCheckerCompletionHandler)completion {
    __weak __typeof (self) weakSelf = self;
    [self fetchLocal];
    [self fetchRemoteCompletion:^(MMManifest *manifest, NSError *error) {
        weakSelf.lastChecked = [NSDate date];
        weakSelf.remote = manifest;
        NSComparisonResult comparison = [weakSelf.local compare:weakSelf.remote];
        MMVersionCheckResult *result;
        if (error) {
            result = [MMVersionCheckResult resultWithChecker:self
                                                      status:MMVersionCheckStatusError
                                                       error:error];
        } else {
            switch (comparison) {
                case NSOrderedSame:
                    result = [MMVersionCheckResult resultWithChecker:self
                                                              status:MMVersionCheckStatusSame
                                                               error:nil];
                    break;
                case NSOrderedAscending:
                    result = [MMVersionCheckResult resultWithChecker:self
                                                              status:MMVersionCheckStatusHasUpdate
                                                               error:nil];
                    break;
                case NSOrderedDescending:
                    result = [MMVersionCheckResult resultWithChecker:self
                                                              status:MMVersionCheckStatusNewerThanMaster
                                                               error:nil];
                    break;
                default:
                    break;
            }
        }

        [weakSelf notifyResult:result];
        completion();
    }];
}

- (BOOL)shouldCheckForUpdates {
    return YES;
}

- (void)notifyResult:(MMVersionCheckResult *)result {
    NSDate *theOtherDay = [NSDate dateWithTimeInterval:(24 * 60 * 60) sinceDate:self.lastChecked];

    BOOL hasUpdate = [self.local compare:self.remote];
    BOOL isSkipped = self.skippedVersion && [self.remote.version isEqualToString:self.skippedVersion];
    BOOL hasNewVersion = ! [self.remote.version isEqualToString:self.skippedVersion];
    BOOL hasExpired = [[NSDate date] compare:theOtherDay] >= NSOrderedSame;
    BOOL shouldRemind = self.shouldRemindLater;

    if (hasUpdate) {
        if (isSkipped) {
            [self.delegate remainSlienceForUpdate];
        } else if (shouldRemind) {
            if ( ! hasExpired) {
//                if ( ! hasNewVersion && ! isSkipped) {
//                    [self.delegate showUpdateDialog];
//                } else if ( ! hasNewVersion || isSkipped) {
//                    [self.delegate remainSlienceForUpdate];
//                } else
                if (hasNewVersion) {
                    if (isSkipped) {
                        [self.delegate remainSlienceForUpdate];
                    } else {
                        if (self.skippedVersion) {
                            [self.delegate showUpdateDialog];
                        } else {
                            [self.delegate remainSlienceForUpdate];
                        }
                    }
                }
                else {
                    [self.delegate remainSlienceForUpdate];
                }
//
//                } else {
//                    [self.delegate showUpdateDialog];
//                }
            } else {
                [self.delegate showUpdateDialog];
            }
        } else if ( ! self.isShowed){
            [self.delegate showUpdateDialog];
            self.isShowed = YES;
        } else {
            [self.delegate remainSlienceForUpdate];
        }
    } else {
        [self.delegate showLatestDialog];
    }
}

@end

@implementation MMVersionChecker (Private)

- (void)skipThisVersion {
    self.skippedVersion = self.remote.version;
}

- (void)remindLater {

}

@end
