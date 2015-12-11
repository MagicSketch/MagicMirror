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

@interface MagicMirror ()

@property (nonatomic, strong) MMWindowController *controller;
@property (nonatomic, strong) SketchPluginContext *context;

@end

@interface MagicMirror (MMWindowControllerDelegate) <MMWindowControllerDelegate>

@end

@implementation MagicMirror

- (id)initWithContext:(SketchPluginContext *)context {
    if (self = [super init]) {
        _context = context;
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

- (NSImage *)flattenedImageWithArtboard:(id)artboard {
    ImageRenderer *renderer = [[ImageRenderer alloc] init];
    renderer.layer = artboard;
    return [renderer flattenedImage];
}

- (NSImage *)exportedImageWithArtboard:(id)artboard {
    ImageRenderer *renderer = [[ImageRenderer alloc] init];
    renderer.layer = artboard;
    return [renderer exportedImage];
}

- (NSImage *)imageForArtboard:(MSArtboardGroup *)artboard {
    return [self exportedImageWithArtboard:artboard];
}


#pragma mark -

- (void)configureSelection {
    MMLog(@"configureSelection");
    [self showWindow];
}

- (void)mirrorPage {
    MMLog(@"mirrorPage");

    NSDictionary *artboardLookup = [_context artboardsLookup];

    ImageRenderer *renderer = [[ImageRenderer alloc] init];

    [_context.selectedLayers enumerateObjectsUsingBlock:^(id <MSShapeGroup> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MMLog(@"%lul: %@", (unsigned long)idx, obj);
        id <MSArtboardGroup> artboard = artboardLookup[obj.name];
        if (artboard) {

            renderer.layer = artboard;
            renderer.bezierPath = [obj bezierPathInBounds];
            NSImage *image = renderer.exportedImage;

            MSStyleFill *fill = [obj.style.fills firstObject];
            if ( ! fill) {
                fill = [obj.style.fills addNewStylePart];
            }
            [fill setFillType:4];
            [fill setPatternFillType:1];
            [fill setIsEnabled:true];
            [fill setPatternImage:image];
        }
    }];
}


- (void)mirrorPageScale:(NSUInteger)scale
             colorSpace:(ImageRendererColorSpaceIdentifier)colorSpaceIdentifier
            perspective:(BOOL)perspective {

    MMLog(@"mirrorPageScale:%lu colorSpace:%u", (unsigned long)scale, colorSpaceIdentifier);

    NSDictionary *artboardLookup = [_context artboardsLookup];

    ImageRenderer *renderer = [[ImageRenderer alloc] init];

    [_context.selectedLayers enumerateObjectsUsingBlock:^(id <MSShapeGroup> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MMLog(@"%lul: %@", (unsigned long)idx, obj);
        id <MSArtboardGroup> artboard = artboardLookup[obj.name];
        if (artboard) {

            renderer.layer = artboard;
            renderer.scale = scale;
            renderer.colorSpaceIdentifier = colorSpaceIdentifier;
            renderer.disablePerspective = ! perspective;
            renderer.bezierPath = [obj bezierPathInBounds];
            NSImage *image = renderer.exportedImage;

            MSStyleFill *fill = [obj.style.fills firstObject];
            if ( ! fill) {
                fill = [obj.style.fills addNewStylePart];
            }
            [fill setFillType:4];
            [fill setPatternFillType:1];
            [fill setIsEnabled:true];
            [fill setPatternImage:image];
        }
    }];
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

@end


@implementation MagicMirror (MMWindowControllerDelegate)

- (void)controllerDidShow:(MMWindowController *)controller {

}

- (void)controllerDidClose:(MMWindowController *)controller {
    _controller = nil;
}

@end

