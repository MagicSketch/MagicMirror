//
//  MMVersionCheckResult.m
//  MagicMirror2
//
//  Created by James Tang on 15/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import "MMVersionCheckResult.h"
#import "MMVersionChecker-Private.h"

@interface MMVersionCheckResult ()

@property (nonatomic, strong) NSError *error;
@property (nonatomic) MMVersionCheckStatus status;
@property (nonatomic, strong) MMVersionChecker *checker;

@end

@implementation MMVersionCheckResult

+ (instancetype)resultWithChecker:(MMVersionChecker *)checker
                           status:(MMVersionCheckStatus)status
                            error:(NSError *)error {
    MMVersionCheckResult *result = [[MMVersionCheckResult alloc] init];
    result.error = error;
    result.status = status;
    result.checker = checker;
    return result;
}

- (void)skipThisVersion {
    [self.checker skipThisVersion];
}

- (void)remindLater {
    [self.checker remindLater];
}

@end
