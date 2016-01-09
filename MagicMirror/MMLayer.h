//
//  MMLayerController.h
//  MagicMirror2
//
//  Created by James Tang on 9/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSShapeGroup.h"
#import "MagicMirror.h"

@protocol MMLayer <NSObject>

- (void)clear;
- (void)disableFill;
- (void)fillWithImage:(NSImage *)image;
- (void)flip;
- (void)refresh;
- (void)rotate;

@property (nonatomic) NSSize size;
@property (nonatomic) CGFloat scale;
@property (nonatomic) NSTimeInterval timeElapsed;

@end

@interface MMLayer : NSObject <MMLayer>

+ (instancetype)layerWithLayer:(id <MSShapeGroup>)layer;

@end
