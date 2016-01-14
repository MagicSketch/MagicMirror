//
//  MagicMirror-Private.h
//  MagicMirror2
//
//  Created by James Tang on 11/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#ifndef MagicMirror_Private_h
#define MagicMirror_Private_h
#import "MagicMirror.h"
#import "MMImageRenderer.h"
#import "MMTracker.h"
#import "SketchPluginContext.h"
#import "MMImageLoader.h"
#import "MMVersionChecker.h"
//@class MMImageLoader;
//@class MMVersionChecker;

@interface MagicMirror (Private)

@property (nonatomic, readonly, strong) MMImageRenderer *imageRenderer;
@property (nonatomic, readonly, strong) MMTracker *tracker;
@property (nonatomic, readonly, strong) SketchPluginContext *context;
@property (nonatomic, readonly, strong) MMImageLoader *loader;
@property (nonatomic, readonly, strong) MMVersionChecker *checker;

@end

#endif /* MagicMirror_Private_h */
