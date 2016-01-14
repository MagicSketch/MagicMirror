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

@interface MMVersionChecker : MMController

@property (nonatomic, strong, readonly) MMManifest *remote;
@property (nonatomic, strong, readonly) MMManifest *local;

- (void)checkForUpdates;

@end
