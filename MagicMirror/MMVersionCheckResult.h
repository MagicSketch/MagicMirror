//
//  MMVersionCheckStatus.h
//  MagicMirror2
//
//  Created by James Tang on 15/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMVersionChecker;

typedef enum {
    MMVersionCheckStatusSame,
    MMVersionCheckStatusHasUpdate,
    MMVersionCheckStatusNewerThanMaster,
    MMVersionCheckStatusSkipped,
    MMVersionCheckStatusError,
} MMVersionCheckStatus;

@interface MMVersionCheckResult : NSObject

@property (nonatomic, strong, readonly) NSError *error;
@property (nonatomic, readonly) MMVersionCheckStatus status;

+ (instancetype)resultWithChecker:(MMVersionChecker *)checker status:(MMVersionCheckStatus)status error:(NSError *)error;

- (void)skipThisVersion;
- (void)remindLater;
- (void)download;

@end
