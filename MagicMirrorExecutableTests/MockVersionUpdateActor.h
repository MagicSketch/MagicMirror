//
//  MockVersionUpdateActor.h
//  MagicMirror2
//
//  Created by James Tang on 15/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMVersionUpdateActor.h"
#import "MMManifest.h"

@interface MockVersionUpdateActor : NSObject <MMVersionUpdateActor>

@property (nonatomic) NSUInteger showedUpdateDialogCount;
@property (nonatomic) NSUInteger proceedDownloadCount;
@property (nonatomic) BOOL hasShowErrorDialog;
@property (nonatomic) BOOL hasShowLatestDialog;
@property (nonatomic) BOOL hasRemainedSlience;

@property (nonatomic, strong) MMManifest *remote;
@property (nonatomic, strong) NSDate *lastChecked;

@property (nonatomic, copy, readonly) NSURL *downloadURL;

@end

