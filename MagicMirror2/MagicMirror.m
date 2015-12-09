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
#import "SketchShapeGroup.h"
#import "SketchArtboard.h"
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

- (NSImage *)imageWithLayerFlattener:(MSArtboardGroup *)artboard {
    id <MSLayerFlattener> flattener = [[NSClassFromString(@"MSLayerFlattener") alloc] init];
    id array = [NSClassFromString(@"MSLayerArray") arrayWithLayer:artboard];
    NSImage *image = [flattener imageFromLayers:array lightweightPage:artboard];
    return image;
}

- (NSImage *)imageWithExport:(id)artboard {
    id <MSExportRequest> request = [NSClassFromString(@"MSExportRequest") requestWithRect:[artboard rect] scale:2];
    id <MSExportRenderer> renderer = [NSClassFromString(@"MSExportRenderer") exportRendererForRequest:request colorSpace:[NSColorSpace genericRGBColorSpace]];
    request.page = [artboard parentPage];
    request.rootLayerID = [artboard originalObjectID];
    NSImage *image = [renderer image];
    return image;
}

- (NSImage *)imageForArtboard:(MSArtboardGroup *)artboard {
    return [self imageWithExport:artboard];
}

#pragma mark -

- (void)mirrorPage {
    MMLog(@"mirrorPage");

    NSDictionary *artboardLookup = [_context artboardsLookup];

    [_context.selectedLayers enumerateObjectsUsingBlock:^(id <MSShapeGroup> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MMLog(@"%lul: %@", (unsigned long)idx, obj);
        MSArtboardGroup *artboard = artboardLookup[obj.name];
        if (artboard) {

            NSImage *image = [self imageForArtboard:artboard];
            NSBezierPath *bezierPath = [(id)obj bezierPath];
//            id <MSShapePath> path = [[NSClassFromString(@"MSShapePath") alloc] initWithBezierPath:bezierPath inRect:[obj boundsRect]];
            image = [image imageForPath:bezierPath];

            id fill = [obj.style.fills firstObject];
            if ( ! fill) {
                fill = [obj.style.fills addNewStylePart];
            }
            [fill setFillType:4];
            [fill setPatternFillType:1];
            [fill setPatternImage:image];
        }
    }];

}

- (NSArray *)artboards {
    return [_context artboards];
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

