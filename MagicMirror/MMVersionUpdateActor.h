//
//  MMVersionUpdateActor.h
//  MagicMirror2
//
//  Created by James Tang on 15/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MMController.h"
#import "MagicMirror.h"

@class MMManifest;
@protocol MMVersionUpdateActor;

@protocol MMVersionUpdateActor <NSObject>

- (void)showUpdateDialog;
- (void)showErrorDialog:(NSError *)error;
- (void)showLatestDialog;
- (void)proceedToDownload:(NSURL *)url;
- (void)remainSlienceForUpdate;

@end


@interface MagicMirror (MMVersionUpdateActor) <MMVersionUpdateActor>

@end