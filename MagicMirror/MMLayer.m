//
//  MMLayerController.m
//  MagicMirror2
//
//  Created by James Tang on 9/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import "MMLayer.h"
#import "MSShapeGroup.h"
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
#import "MagicMirror+MMPropertyController.h"
#import "MagicMirror+MMLayerArtboardFinder.h"
#import "MagicMirror-Private.h"


@interface MMLayer ()

@property (weak) MagicMirror *magicmirror;
@property (readonly) SketchPluginContext *context;
@property (nonatomic, strong) id <MMLayerPropertySetter> setter;
@property (nonatomic, strong) id <MMLayerArtboardFinder> finder;
@property (strong) MMImageRenderer *renderer;

@end

@implementation MMLayer

+ (instancetype)layerWithLayer:(id<MSShapeGroup>)layer {
    MMLayer *l = [[MMLayer alloc] init];
    l.layer = layer;
    l.magicmirror = [MagicMirror sharedInstance];
    l.renderer = [MagicMirror sharedInstance].imageRenderer;
    l.setter = [MagicMirror sharedInstance];
    l.finder = [MagicMirror sharedInstance];
    return l;
}

+ (instancetype)layerWithLayer:(id <MSShapeGroup>)layer
                        finder:(id <MMLayerArtboardFinder>)finder
                propertySetter:(id <MMLayerPropertySetter>)setter {
    MMLayer *l = [[MMLayer alloc] init];
    l.layer = layer;
    l.finder = finder;
    l.magicmirror = nil;
    l.setter = setter;
    l.renderer = nil;
    return l;
}

- (SketchPluginContext *)context {
    return self.magicmirror.context;
}

-(void)clear {
    if (self.source) {
        NSDictionary *artboardLookup = [self.finder artboardsLookup];
        if (artboardLookup[self.source]) {
            [_layer setName:[[_layer name] stringByAppendingString:@"_detached"]];
            [self disableFill];
        }
    }

    [self configureVersion];
    self.imageQuality = nil;
    self.source = nil;
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

    [self configureVersion];
}

- (void)mirrorWithArtboard:(id<MSArtboardGroup>)artboard
              imageQuality:(MMImageRenderQuality)imageQuality
      colorSpaceIdentifier:(ImageRendererColorSpaceIdentifier)colorSpaceIdentifier
               perspective:(BOOL)perspective
    {
    MMImageRenderer *renderer = self.renderer;
    if (artboard) {
        renderer.layer = artboard;
        renderer.imageQuality = imageQuality;
        renderer.colorSpaceIdentifier = colorSpaceIdentifier;
        renderer.disablePerspective = ! perspective;
        renderer.bezierPath = [_layer bezierPathInBounds];
//        NSTimeInterval timeElasped = CACurrentMediaTime();
        NSImage *image = renderer.exportedImage;
        [self fillWithImage:image];
//        [self setValue:@(imageQuality) forKey:@"scale" onLayer:layer];
//        [self setValue:NSStringFromSize(image.size) forKey:@"imageSize" onLayer:layer];
//        [self setValue:@(CACurrentMediaTime() - timeElasped) forKey:@"timeElapsed" onLayer:layer];
    }
        [self configureVersion];
        self.source = [artboard name];
        self.imageQuality = @(imageQuality);
}

- (void)refresh {
    NSString *selectedName = self.source;
    id <MSArtboardGroup> artboard = [self.magicmirror artboardsLookup][selectedName];
    if ( ! selectedName) {
        [self clear];
    } else {
        CGFloat ratio = CGSizeAspectFillRatio(artboard.rect.size, _layer.rect.size);
        MMImageRenderQuality quality = (MMImageRenderQuality)[self.imageQuality unsignedIntegerValue];
        MMLog(@"ratio: %@, quality: %@", @(ratio), @(quality));
        [self.magicmirror mirrorLayer:_layer fromArtboard:artboard imageQuality:quality];
    }
    [self configureVersion];
}

- (void)rotate {
    id <MSShapeGroup> layer = _layer;
    MSArray *array = [layer layers];
    MSShapePathLayer *shape = [array firstObject];
    id <MSShapePath> path = [shape path];
    id point = [path lastPoint];
    [path removeLastPoint];
    [path insertPoint:point atIndex:0];
    [self configureVersion];
}

- (void)setArtboard:(id<MSArtboardGroup>)artboard {
    if (artboard != nil) {
        self.source = [artboard name];
    }
    [self refresh];
}

#pragma mark -

- (void)configureVersion {
    [self.setter setVersionOnLayer:self];
}
- (NSString *)version {
    return [self.setter valueForKey:@"version" onLayer:self];
}

-(void)setImageQuality:(NSNumber *)imageQuality {
    MMLog(@"setImageQuality %@", imageQuality);
    if (self.imageQuality == imageQuality || [self.imageQuality isEqual:imageQuality]) {
        return;
    }
    if ( ! imageQuality || [imageQuality integerValue] >= 0) {
        [self.setter setValue:imageQuality forKey:@"imageQuality" onLayer:self];
        [self refresh];
    }
}
- (NSNumber *)imageQuality {
    return [self.setter valueForKey:@"imageQuality" onLayer:self];
}

- (void)setSource:(NSString *)source {
    [self.setter setValue:source forKey:@"source" onLayer:self];
}
- (NSString *)source {
    NSString *source = [self.setter valueForKey:@"source" onLayer:self];
    if ( ! source && ! self.version) {
        id <MSArtboardGroup> artboard = [self.finder artboardsLookup][self.layer.name];
        if (artboard) {
            return [artboard name];
        }
    }
    return source;
}

@end
