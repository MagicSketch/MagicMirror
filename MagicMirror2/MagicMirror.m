//
//  MMViewController.m
//  MagicMirror2
//
//  Created by James Tang on 7/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

@import AppKit;
#import "MagicMirror.h"
#import "MMWindowController.h"
#import "SketchPluginContext.h"
#import "MSLayerFlattener.h"
#import "MSLayerArray.h"
#import "MSArtboardGroup.h"
#import "MSShapeGroup.h"
#import "MSStyle.h"
#import "MSStyleFill.h"
#import "MSFillStyleCollection.h"
#import "MSExportRequest.h"
#import "MSExportRenderer.h"
#import "NSImage+Transform.h"
#import "MSShapePath.h"
#import "ImageRenderer.h"
#import "MMConfigureViewController.h"
#import "MMLayerProperties.h"
#import "MSArray.h"
#import "MSShapePathLayer.h"
#import "MSShapePath.h"
#import "NSBezierPath-Clockwise.h"
#import "NSBezierPath+Alter.h"
#import "MSCurvePoint.h"
#import "MMMath.h"

@interface MagicMirror ()

@property (nonatomic, strong) MMWindowController *controller;
@property (nonatomic, strong) SketchPluginContext *context;
@property (nonatomic, copy) NSString *version;

@property (nonatomic) NSUInteger imageQuality;
@property (nonatomic) ImageRendererColorSpaceIdentifier colorSpaceIdentifier;
@property (nonatomic) BOOL perspective;
@property (nonatomic, copy) NSMutableArray *layerChangeObservers;

@end

@interface MagicMirror (MMWindowControllerDelegate) <MMWindowControllerDelegate>

@end

@implementation MagicMirror

- (id)initWithContext:(SketchPluginContext *)context {
    if (self = [super init]) {
        _context = context;
        _imageQuality = 2;
        _colorSpaceIdentifier = ImageRendererColorSpaceDeviceRGB;
        _perspective = YES;
        _layerChangeObservers = [NSMutableArray array];
        _version = @"2.0";

        __weak __typeof (self) weakSelf = self;
        [_context setSelectionChangeHandler:^(NSArray *layers) {
            [weakSelf layerSelectionDidChange:layers];
        }];
        return self;
    }
    return nil;
}

- (void)log {
    MMLog(@"logged something");
}

- (void)showWindow {
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle bundleForClass:[MMWindowController class]]];
    _controller = [storyboard instantiateInitialController];
    _controller.magicmirror = self;
    _controller.delegate = self;
    [_controller showWindow:self];
    [self reloadData];
}

- (void)keepAround {
    _context.shouldKeepAround = YES;
    MMLog(@"keepAround");
}

- (void)goAway {
    _context.shouldKeepAround = NO;
    MMLog(@"goAway");
}

- (id)valueForKey:(NSString *)key onLayer:(id)layer {
    return [_context.command valueForKey:key onLayer:layer];
}

- (void)setValue:(id)value forKey:(NSString *)key onLayer:(id)layer {
    [_context.command setValue:value forKey:key onLayer:layer];
}

- (void)layerSelectionDidChange:(NSArray *)layers {
    MMLog(@"layers %@", layers);
    [self reloadData];
    [_controller reloadData];
}

- (void)reloadData {
    [_controller reloadData];

    [self unobserveSelection];
    [self observeSelection];
}

- (void)dealloc {
    [self unobserveSelection];
}

#pragma mark KVO

- (void)unobserveSelection {
    [_layerChangeObservers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeObserver:self forKeyPath:@"rect"];
    }];
    [_layerChangeObservers removeAllObjects];
}

- (void)observeSelection {
    NSArray *layers = [_context selectedLayers];
    [layers enumerateObjectsUsingBlock:^(id <MSShapeGroup> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(NSObject *)obj addObserver:self
                          forKeyPath:@"rect"
                             options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                             context:nil];
        [_layerChangeObservers addObject:obj];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"rect"]) {

//        NSRect oldRect = [change[NSKeyValueChangeOldKey] rectValue];
//        NSRect newRect = [change[NSKeyValueChangeNewKey] rectValue];
//        MMLog(@"rect did change %@", NSStringFromRect(newRect));
//
//        BOOL isMoveOperation = (! CGPointEqualToPoint(oldRect.origin, newRect.origin)) && CGSizeEqualToSize(oldRect.size, newRect.size);
//
//        if ( ! isMoveOperation) {
            NSDictionary *artboardLookup = [_context artboardsLookup];
            ImageRenderer *renderer = [[ImageRenderer alloc] init];

            [self mirrorLayer:object
                        index:0
                     renderer:renderer
               artboardLookup:artboardLookup];
//        }
    }
}

#pragma mark -

- (void)configureSelection {
    MMLog(@"configureSelection");
    [self showWindow];
}

- (NSArray *)artboards {
    return [_context artboards];
}

- (NSDictionary *)artboardsLookup {
    return [_context artboardsLookup];
}

- (NSArray *)selectedLayers {
    return [_context selectedLayers];
}

- (void)licenseInfo {
    NSLog(@"licenseInfo");
}

#pragma mark Apply

- (void)applySource:(NSString *)source imageQuality:(NSNumber *)imageQuality {

    __weak typeof (self) weakSelf = self;
    [self.selectedLayers enumerateObjectsUsingBlock:^(id <MSShapeGroup> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        MMLayerProperties *original = [weakSelf layerPropertiesForLayer:obj];
        NSString *selectedName = source ?: original.source;

        NSInteger index = [imageQuality integerValue];

        NSNumber *imageQuality = @0;
        if (index <= 3) {
            imageQuality = @(MAX(0, index));
        } else {
            imageQuality = original.imageQuality;
        }

        MMLayerProperties *properties = [MMLayerProperties propertiesWithImageQuality:imageQuality
                                                                               source:selectedName
                                                                              version:_version
                                         ];
        [weakSelf setProperties:properties forLayer:obj];
    }];

    [self mirrorPage];
}

#pragma mark Mirror Page

- (void)mirrorLayer:(id <MSShapeGroup>)obj
              index:(NSUInteger)idx
           renderer:(ImageRenderer *)renderer
     artboardLookup:(NSDictionary *)artboardLookup {

    MMLayerProperties *properties = [self layerPropertiesForLayer:obj];
    CGFloat scale = [properties.imageQuality floatValue] ?: 2;

    NSString *name = properties.source;

    MMLog(@"%lul: %@, %@, %fl", (unsigned long)idx, obj, name, scale);

    id <MSArtboardGroup> artboard = artboardLookup[name];
    if (artboard) {
        renderer.layer = artboard;

        if (scale == 3) {
            scale = CGSizeAspectFillRatio(artboard.rect.size, obj.rect.size) * 3;
        }
        renderer.scale = scale;
        renderer.colorSpaceIdentifier = _colorSpaceIdentifier;
        renderer.disablePerspective = ! _perspective;
        renderer.bezierPath = [obj bezierPathInBounds];
        NSImage *image = renderer.exportedImage;

        [self fillLayer:obj withImage:image];
    }
}

- (void)fillLayer:(id <MSShapeGroup>)layer withImage:(NSImage *)image {
    MSStyleFill *fill = [layer.style.fills firstObject];
    if ( ! fill) {
        fill = [layer.style.fills addNewStylePart];
    }
    [fill setFillType:4];
    [fill setPatternFillType:1];
    [fill setIsEnabled:true];
    [fill setPatternImage:image];
}

- (void)disableFillLayer:(id <MSShapeGroup>)layer {
    MSStyleFill *fill = [layer.style.fills firstObject];
    [fill setIsEnabled:NO];
}

- (void)mirrorPage {
    MMLog(@"mirrorPage");
    [self mirrorPageScale:2 colorSpace:3 perspective:YES];
}

- (void)mirrorPageScale:(NSUInteger)scale
             colorSpace:(ImageRendererColorSpaceIdentifier)colorSpaceIdentifier
            perspective:(BOOL)perspective {

    MMLog(@"mirrorPageScale:%lu colorSpace:%u", (unsigned long)scale, colorSpaceIdentifier);

    NSDictionary *artboardLookup = [_context artboardsLookup];

    ImageRenderer *renderer = [[ImageRenderer alloc] init];

    __weak __typeof (self) weakSelf = self;
    [_context.selectedLayers enumerateObjectsUsingBlock:^(id <MSShapeGroup> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf mirrorLayer:obj
                        index:idx
                     renderer:renderer
               artboardLookup:artboardLookup];
    }];
}

#pragma mark Rotate

- (void)rotatePoints:(id <MSShapeGroup>)layer {
    MSArray *array = [layer layers];
    MSShapePathLayer *shape = [array firstObject];
    id <MSShapePath> path = [shape path];
    id point = [path lastPoint];
    [path removeLastPoint];
    [path insertPoint:point atIndex:0];
}

- (void)rotateSelection {
    MMLog(@"rotateSelection");

    NSDictionary *artboardLookup = [_context artboardsLookup];
    ImageRenderer *renderer = [[ImageRenderer alloc] init];

    __weak __typeof (self) weakSelf = self;
    [_context.selectedLayers enumerateObjectsUsingBlock:^(id <MSShapeGroup> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf rotatePoints:obj];
        [weakSelf mirrorLayer:obj
                        index:idx
                     renderer:renderer
               artboardLookup:artboardLookup];
    }];
}

#pragma mark Flip Selection

- (void)flipPoints:(id <MSShapeGroup>)layer {
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

- (void)flipSelection {
    MMLog(@"flipSelection");

    NSDictionary *artboardLookup = [_context artboardsLookup];
    ImageRenderer *renderer = [[ImageRenderer alloc] init];

    __weak __typeof (self) weakSelf = self;
    [_context.selectedLayers enumerateObjectsUsingBlock:^(id <MSShapeGroup> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf flipPoints:obj];
        [weakSelf mirrorLayer:obj
                        index:idx
                     renderer:renderer
               artboardLookup:artboardLookup];
    }];
}

@end


@implementation MagicMirror (MMWindowControllerDelegate)

- (void)controllerDidShow:(MMWindowController *)controller {

}

- (void)controllerDidClose:(MMWindowController *)controller {
    _controller = nil;
}

@end


@implementation MagicMirror (MSShapeGroup)

- (void)clearPropertiesForLayer:(id <MSShapeGroup>)layer {

    MMLayerProperties *properties = [self layerPropertiesForLayer:layer];
    if (properties.source) {
        NSDictionary *artboardLookup = [_context artboardsLookup];
        if (artboardLookup[properties.source]) {
            [layer setName:[[layer name] stringByAppendingString:@"_detached"]];
            [self disableFillLayer:layer];
        }
    }

    [self setValue:nil forKey:@"source" onLayer:layer];
    [self setValue:nil forKey:@"imageQuality" onLayer:layer];
    [self setValue:nil forKey:@"version" onLayer:layer];
}

- (void)setProperties:(MMLayerProperties *)properties forLayer:(id<MSShapeGroup>)layer {
    NSString *name = properties.source;
    [layer setName:name];
    [self setValue:properties.source forKey:@"source" onLayer:layer];
    if (properties.imageQuality) {
        [self setValue:properties.imageQuality forKey:@"imageQuality" onLayer:layer];
    }
}

- (MMLayerProperties *)layerPropertiesForLayer:(id<MSShapeGroup>)layer {
    NSString *source = [self valueForKey:@"source" onLayer:layer];
    NSString *version = [self valueForKey:@"version" onLayer:layer];
    if ([version hasPrefix:@"2"] && ( ! source || [source length] == 0)) {
        source = [layer name];
    }
    NSNumber *imageQuality = [self valueForKey:@"imageQuality" onLayer:layer];
    MMLayerProperties *properties = [MMLayerProperties propertiesWithImageQuality:imageQuality
                                                                           source:source
                                                                          version:version
                                     ];
    return properties;
}

@end
