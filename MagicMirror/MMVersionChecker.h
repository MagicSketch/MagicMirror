//
//  MMVersionChecker.h
//  MagicMirror2
//
//  Created by James Tang on 14/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMController.h"
#import "MMManifest.h"

typedef enum {
    MMVersionCheckerStatusPending,
    MMVersionCheckerStatusRemindLater,
    MMVersionCheckerStatusSkipped,
    MMVersionCheckerStatusProceedToDownload = MMVersionCheckerStatusRemindLater,
} MMVersionCheckerStatus;

@protocol MMVersionUpdateActor;

typedef NSInteger MMDay;

typedef void(^MMVersionCheckerCompletionHandler)();

@interface MMVersionChecker : MMController

@property (nonatomic, strong) MMManifest *remote;
@property (nonatomic, strong, readonly) MMManifest *local;
@property (nonatomic, copy) NSDate *lastChecked;
@property (nonatomic, readonly) MMVersionCheckerStatus status;
@property (nonatomic, copy, readonly) NSString *lastVersion;
@property (nonatomic, weak) id <MMVersionUpdateActor> delegate;
@property (nonatomic) MMDay skippingDays;

+ (instancetype)versionCheckerWithLocal:(MMManifest *)local remote:(MMManifest *)remote lastChecked:(NSDate *)lastChecked;
+ (instancetype)versionChecker;

- (void)checkForUpdates:(MMVersionCheckerCompletionHandler)completion;
- (void)skipThisVersion;
- (void)remindLater;
- (void)okay;
- (void)download;

@end
