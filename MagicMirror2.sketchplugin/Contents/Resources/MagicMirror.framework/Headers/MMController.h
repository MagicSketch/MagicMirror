//
//  MMController.h
//  MagicMirror2
//
//  Created by James Tang on 11/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SketchEventsController.h"
@protocol MMController;
@class MagicMirror;


@interface MMController : NSObject <MMController>

@property (weak) MagicMirror *magicmirror;

@end


@protocol MMController <NSObject, SketchEventsController>

@property MagicMirror *magicmirror;

@optional

- (void)magicmirrorLicenseUnlocked:(MagicMirror *)magicmirror;
- (void)magicmirrorLicenseDetached:(MagicMirror *)magicmirror;

@end
