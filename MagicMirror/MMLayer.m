//
//  MMLayerController.m
//  MagicMirror2
//
//  Created by James Tang on 9/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import "MMLayer.h"
#import "MSStyle.h"
#import "MSStyleFill.h"
#import "MSFillStyleCollection.h"
#import "MMLayerProperties.h"
#import "SketchPluginContext.h"
#import "MSShapePathLayer.h"
#import "NSBezierPath+Alter.h"
#import "MSShapePath.h"
#import "MMMath.h"
#import "MSArtboardGroup.h"
#import "MagicMirror.h"


@interface MMLayer ()

@property (strong) id <MSShapeGroup> layer;
@property (weak) MagicMirror *magicmirror;
@property (readonly) SketchPluginContext *context;
@property (strong) MMImageRenderer *renderer;

@end

@implementation MMLayer

+ (instancetype)layerWithLayer:(id<MSShapeGroup>)layer {
    MMLayer *l = [[MMLayer alloc] init];
    l.layer = layer;
    l.magicmirror = [MagicMirror sharedInstance];
    return l;
}

- (SketchPluginContext *)context {
    return self.magicmirror.context;
}

-(void)clear {
    MMLayerProperties *properties = [self.magicmirror layerPropertiesForLayer:_layer];
    if (properties.source) {
        NSDictionary *artboardLookup = [self.context artboardsLookup];
        if (artboardLookup[properties.source]) {
            [_layer setName:[[_layer name] stringByAppendingString:@"_detached"]];
            [self disableFill];
        }
    }

    [self.magicmirror setValue:nil forKey:@"source" onLayer:_layer];
    [self.magicmirror setValue:nil forKey:@"imageQuality" onLayer:_layer];
    [self.magicmirror setValue:self.magicmirror.version forKey:@"version" onLayer:_layer];
}

- (void)disableFill {
    MSStyleFill *fill = [_layer.style.fills firstObject];
    [fill setIsEnabled:NO];
}

- (void)fillWithImage:(NSImage *)image {
    MSStyleFill *fill = [_layer.style.fills firstObject];
    if ( ! fill) {
        fill = [_layer.style.fills addNewStylePart];
    }
    [fill setFillType:4];
    [fill setPatternFillType:1];
    [fill setIsEnabled:true];
    [fill setPatternImage:image];
}

- (void)flip {
    id <MSShapeGroup> layer = _layer;
    MSArray *array = [layer layers];
    MSShapePathLayer *shape = [array firstObject];
    NSBezierPath *bezierPath = [layer bezierPathInBounds];
    MMLog(@"bezierPath: %lu", [bezierPath count]);
    CGRect rect = [layer bounds];

    NSBezierPath *fixedDirection;
    NSBezierPath *flipped = [bezierPath flipPoints];
    MMLog(@"flipped: %lu", [flipped count]);

    fixedDirection = [flipped antiClockwisePoints];
    MMLog(@"fixedDirection: %lu", [fixedDirection count]);

    id <MSShapePath> newPath = [NSClassFromString(@"MSShapePath") pathWithBezierPath:fixedDirection inRect:rect];
    MMLog(@"newPath before close: %llu", [newPath numberOfPoints]);

    //    if ([bezierPath isClosed] && [newPath numberOfPoints] > 4) {
    //        [newPath removeLastPoint];
    //    }
    [newPath setIsClosed:[bezierPath isClosed]];

    MMLog(@"newPath before: %llu", [newPath numberOfPoints]);
    [shape setPath:newPath];

    MMLog(@"newPath after: %llu", [[shape path] numberOfPoints]);

    layer.isFlippedHorizontal = ![layer isFlippedHorizontal];
    //[shape closeLastPath:[bezierPath isClosed]];
}

- (void)refresh {
    id <MSShapeGroup> layer = _layer;
    MMLayerProperties *original = [self.magicmirror layerPropertiesForLayer:layer];
    NSString *selectedName = original.source;
    id <MSArtboardGroup> artboard = [self.magicmirror artboardsLookup][selectedName];
    if ( ! selectedName) {
        [self clear];
    } else {
        CGFloat ratio = CGSizeAspectFillRatio(artboard.rect.size, layer.rect.size);
        MMImageRenderQuality quality = (MMImageRenderQuality)[original.imageQuality integerValue];
        MMLog(@"ratio: %@, quality: %@", @(ratio), @(quality));
        [self.magicmirror mirrorLayer:layer fromArtboard:artboard imageQuality:quality];
    }
    [self.magicmirror setVersionForLayer:layer];
}

- (void)rotate {
    id <MSShapeGroup> layer = _layer;
    MSArray *array = [layer layers];
    MSShapePathLayer *shape = [array firstObject];
    id <MSShapePath> path = [shape path];
    id point = [path lastPoint];
    [path removeLastPoint];
    [path insertPoint:point atIndex:0];
}

@end
