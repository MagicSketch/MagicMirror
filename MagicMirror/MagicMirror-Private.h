//
//  MagicMirror-Private.h
//  MagicMirror2
//
//  Created by James Tang on 11/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#ifndef MagicMirror_Private_h
#define MagicMirror_Private_h
#import "MMImageRenderer.h"
#import "MMTracker.h"
#import "SketchPluginContext.h"


@interface MagicMirror (Private)

@property (nonatomic, readonly, strong) MMImageRenderer *imageRenderer;
@property (nonatomic, readonly, strong) MMTracker *tracker;
@property (nonatomic, readonly, strong) SketchPluginContext *context;

@end

#endif /* MagicMirror_Private_h */
