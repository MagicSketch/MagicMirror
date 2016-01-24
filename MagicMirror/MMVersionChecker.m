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
#import "MMPersister.h"

@interface MMVersionChecker ()

@property (nonatomic) BOOL isShowed;
@property (nonatomic, strong) MMManifest *local;
@property (nonatomic, strong) NSError *error;
@property (nonatomic) MMVersionCheckerStatus status;
@property (nonatomic, weak) id <MMPersister> persister;

@end

@implementation MMVersionChecker

+ (instancetype)versionCheckerWithPersister:(id<MMPersister>)persister {
    MMVersionChecker *checker = [[MMVersionChecker alloc] init];
    checker.persister = persister;
    checker.lastVersion = [persister persistedDictionaryForIdentifier:@"design.magicmirror.checker.lastversion"];
    checker.lastChecked = [persister persistedDictionaryForIdentifier:@"design.magicmirror.checker.lastchecked"];
    checker.status = (MMVersionCheckerStatus)[[persister persistedDictionaryForIdentifier:@"design.magicmirror.checker.status"] integerValue];
    return checker;
}

- (void)save {
    [self.persister persistDictionary:@(self.status) withIdentifier:@"design.magicmirror.checker.status"];
    if (self.lastVersion) {
        [self.persister persistDictionary:self.lastVersion withIdentifier:@"design.magicmirror.checker.lastversion"];
    } else {
        [self.persister removePersistedDictionaryForIdentifier:@"design.magicmirror.checker.lastversion"];
    }
    if (self.lastChecked) {
        [self.persister persistDictionary:self.lastChecked withIdentifier:@"design.magicmirror.checker.lastchecked"];
    } else {
        [self.persister removePersistedDictionaryForIdentifier:@"design.magicmirror.checker.lastchecked"];
    }
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
        _skippingDays = 1;
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
        if (completion) {
            completion();
        }
        weakSelf.lastChecked = [NSDate date];
    }];
}

- (void)checkForUpdatesIfNeeded:(MMVersionCheckerCompletionHandler)completion {
    if ([self needsAutoCheck]) {
        [self checkForUpdates:completion];
    }
}

- (BOOL)needsAutoCheck {
    NSDate *theOtherDay = [NSDate dateWithTimeInterval:(24 * 60 * 60 * _skippingDays) sinceDate:self.lastChecked];
    BOOL hasExpired = [[NSDate date] compare:theOtherDay] >= NSOrderedSame;
    return hasExpired;
}

- (void)notifyResult {
    NSDate *theOtherDay = [NSDate dateWithTimeInterval:(24 * 60 * 60 * _skippingDays) sinceDate:self.lastChecked];
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
    [self save];
}

- (void)remindLater {
    self.status = MMVersionCheckerStatusRemindLater;
    self.lastVersion = self.remote.version;
    [self save];
}

- (void)okay {
    self.status = MMVersionCheckerStatusPending;
    self.lastVersion = self.remote.version;
    [self save];
}

- (void)download {
    self.status = MMVersionCheckerStatusProceedToDownload;
    self.lastVersion = self.remote.version;

    NSURL *url = [NSURL URLWithString:self.remote.downloadURL ?: @"http://api.magicmirror.design/download/latest"];
    [self.delegate proceedToDownload:url];;
    [self save];
}

- (void)reset {
    self.status = 0;
    self.lastChecked = nil;
    self.lastVersion = nil;
    [self save];
}

@end
