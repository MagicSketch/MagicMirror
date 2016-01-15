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
#import "MMVersionCheckResult.h"

@class MMVersionCheckResult;
@protocol MMVersionUpdateActor;

typedef NSInteger MMDay;

typedef void(^MMVersionCheckerCompletionHandler)();

@interface MMVersionChecker : MMController

@property (nonatomic, strong) MMManifest *remote;
@property (nonatomic, strong, readonly) MMManifest *local;
@property (nonatomic, strong) NSDate *lastChecked;
@property (nonatomic, copy) NSString *skippedVersion;
@property (nonatomic) BOOL shouldRemindLater;
@property (nonatomic, weak) id <MMVersionUpdateActor> delegate;

+ (instancetype)versionCheckerWithLocal:(MMManifest *)local remote:(MMManifest *)remote lastChecked:(NSDate *)lastChecked;
+ (instancetype)versionChecker;

- (void)checkForUpdates:(MMVersionCheckerCompletionHandler)completion;
- (BOOL)shouldCheckForUpdates;

@end
