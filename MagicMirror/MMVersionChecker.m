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
#import "MMVersionUpdateActor.h"

@interface MMVersionChecker ()

@property (nonatomic) BOOL isShowed;
@property (nonatomic, strong) MMManifest *local;
@property (nonatomic, strong) NSError *error;
@property (nonatomic) MMDay skippingDays;
@property (nonatomic) MMVersionCheckerStatus status;
@property (nonatomic, copy) NSString *lastVersion;

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
    checker.lastVersion = remote.version;
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
        weakSelf.remote = manifest;
        weakSelf.error = error;
        [weakSelf notifyResult];
        completion();
        weakSelf.lastChecked = [NSDate date];
    }];
}

- (void)notifyResult {
    NSDate *theOtherDay = [NSDate dateWithTimeInterval:(24 * 60 * 60) sinceDate:self.lastChecked];
    BOOL hasUpdate = [self.local compare:self.remote];
    NSString *latestVersion = self.lastVersion ?: self.local.version;
    BOOL hasNewerThanSeenVersion = [latestVersion compare:self.remote.version];
    BOOL hasExpired = [[NSDate date] compare:theOtherDay] >= NSOrderedSame;
    BOOL isSkipped = [self.lastVersion isEqualToString:self.remote.version] && self.status == MMVersionCheckerStatusSkipped;

    if (hasNewerThanSeenVersion) {
        [self.delegate showUpdateDialog];
    } else if (hasUpdate) {
        if (hasExpired && ! isSkipped) {
            [self.delegate showUpdateDialog];
        } else {
            [self.delegate remainSlienceForUpdate];
        }
    } else {
        [self.delegate showLatestDialog];
    }
}

- (void)skipThisVersion {
    self.status = MMVersionCheckerStatusSkipped;
    self.lastVersion = self.remote.version;
}

- (void)remindLater {
    self.status = MMVersionCheckerStatusRemindLater;
    self.lastVersion = self.remote.version;
}

- (void)okay {
    self.status = MMVersionCheckerStatusPending;
    self.lastVersion = self.remote.version;
}

- (void)download {
    self.status = MMVersionCheckerStatusProceedToDownload;
    self.lastVersion = self.remote.version;

    NSURL *url = [NSURL URLWithString:self.remote.downloadURL ?: @"http://magicmirror.design/download/latest"];
    [self.delegate proceedToDownload:url];;
}

@end
