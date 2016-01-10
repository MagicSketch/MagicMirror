//
//  SketchContext.m
//  MagicMirror2
//
//  Created by James Tang on 8/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "SketchPluginContext.h"
#import "COScript.h"
#import "MSPage.h"
#import "MSArtboardGroup.h"
#import "MSDocument.h"
#import "MSLayerArray.h"
#import "MSShapePathLayer.h"
#import "SketchEventsController.h"
#import "Weak.h"
#import "MSShapeGroup.h"
#import "MagicMirror.h"
#import "MSArray.h"
#import "MSLayer.h"
#import "MMLayerProperties.h"
#import "MSLayerGroup.h"
#import "MSLayerArray.h"

@interface SketchPluginContext ()

@property (nonatomic, strong) MSPluginBundle *plugin;
@property (nonatomic, strong) MSPluginCommand *command;
@property (nonatomic, copy) NSArray *selection;
@property (nonatomic, strong) MSDocument *document;
@property (nonatomic, strong) id <COScript> coscript;
@property (nonatomic) BOOL observerAdded;
@property (nonatomic, copy) NSMutableArray *layerChangeObservers;


@end

@implementation SketchPluginContext

static NSMutableArray <Weak *> *_observers = nil;

+ (void)load {
    _observers = [NSMutableArray array];
}

+ (void)addObserver:(id<SketchEventsController>)observer {
    [_observers addObject:[Weak weakWithObject:observer]];
}

- (id)initWithPlugin:(MSPluginBundle *)plugin
            document:(MSDocument *)document
           selection:(NSArray *)selection
             command:(MSPluginCommand *)command {
    if (self = [super init]) {
        _plugin = plugin;
        _command = command;
        _selection = [selection copy];
        _document = document;
        _coscript = (id <COScript>)command.session;
        _layerChangeObservers = [NSMutableArray array];
        [self observeSelection];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(windowDidBecomeMain:)
                                                     name:NSWindowDidBecomeMainNotification
                                                   object:nil];

        return self;
    }
    return nil;
}


- (void)windowDidBecomeMain:(NSNotification *)notification {
    MMLog(@"windowDidBecomeMain");
    [self notifyDocumentDidChange];
}

- (void)dealloc {
    MMLog(@"SketchPluginContext dealloc")

    self.shouldKeepAround = NO;
    [self unobserveSelection];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setShouldKeepAround:(BOOL)shouldKeepAround {
    _shouldKeepAround = shouldKeepAround;
    _coscript.shouldKeepAround = shouldKeepAround;

    if (shouldKeepAround) {
        if (_observerAdded == NO) {
            _observerAdded = YES;
            [_document addObserver:self forKeyPath:@"selectedLayersA" options:NSKeyValueObservingOptionNew context:nil];
        }
    } else {
        if (_observerAdded) {
            [_document removeObserver:self forKeyPath:@"selectedLayersA"];
            _observerAdded = NO;
        }
    }
}
- (void)setDocument:(MSDocument *)document {
    if (_observerAdded == YES) {
        [_document removeObserver:self forKeyPath:@"selectedLayersA"];
        _observerAdded = NO;
    }

    _document = document;

    if (_shouldKeepAround) {
        [_document addObserver:self forKeyPath:@"selectedLayersA" options:NSKeyValueObservingOptionNew context:nil];
        _observerAdded = YES;
    }
}

- (NSArray *)pages {
    return _document.pages;
}

- (NSArray *)artboards {
    NSMutableArray *artboards = [NSMutableArray array];
    [[self pages] enumerateObjectsUsingBlock:^(MSPage* page, NSUInteger idx, BOOL * _Nonnull stop) {
        [artboards addObjectsFromArray:[page artboards]];
    }];
    return artboards;
}

- (NSDictionary *)artboardsLookup {
    NSMutableDictionary *lookup = [NSMutableDictionary dictionary];
    [[self artboards] enumerateObjectsUsingBlock:^(id <MSArtboardGroup> artboard, NSUInteger idx, BOOL * _Nonnull stop) {
        lookup[[artboard name]] = artboard;
    }];
    return [lookup copy];
}

- (NSArray *)selectedLayers {
    NSMutableArray *layers = [[NSMutableArray alloc] init];

    [_selection enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"MSShapeGroup")]) {
            [layers addObject:obj];
        } else if ([obj isKindOfClass:NSClassFromString(@"MSShapePathLayer")]) {
            MSShapePathLayer *pPath = obj;
            [layers addObject:pPath.parentForInsertingLayers];
        }
    }];

    return [layers copy];
}

- (NSArray *)selectedLayersAndAll {
    NSMutableArray *layers = [[NSMutableArray alloc] init];

    [_selection enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"MSShapePathLayer")]) {
            MSShapePathLayer *pPath = obj;
            [layers addObject:pPath.parentForInsertingLayers];
        } else if ([obj isKindOfClass:NSClassFromString(@"MSLayer")]) {
            [layers addObject:obj];
        }
    }];

    return [layers copy];
}

- (NSArray *)allMagicLayersInPage {
    NSMutableArray *layers = [[NSMutableArray alloc] init];
    [[self.document.currentPage children] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"MSShapeGroup")]) {
            [layers addObject:obj];
        }
    }];

    return [layers copy];
}

- (NSArray <id <MSShapeGroup>> *)layersAffectedByArtboard:(id <MSArtboardGroup>)artboard {
    NSArray <id <MSLayer>> *array = [[_document currentPage] children];

    __block NSMutableArray <id <MSShapeGroup>> *shapesAffected = [NSMutableArray array];
    __weak __typeof (self) weakSelf = self;

    [array enumerateObjectsUsingBlock:^(id <MSLayer> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"MSShapeGroup")]) {
            MMLayerProperties *properties = [weakSelf layerPropertiesForLayer:obj];
            if ([[artboard name] isEqualToString:properties.source]) {
                [shapesAffected addObject:(id <MSShapeGroup>)obj];
            }
        }
    }];

    return [shapesAffected copy];
}

#pragma mark - Notifications

- (void)layerSelectionDidChange:(NSArray *)layers {
    MMLog(@"layerSelectionDidChange: %@", layers);
    [self unobserveSelection];
    [self observeSelection];
    [_observers enumerateObjectsUsingBlock:^(Weak * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id <SketchEventsController> controller = [obj object];
        if ([controller respondsToSelector:@selector(layerSelectionDidChange:)]) {
            [controller layerSelectionDidChange:layers];
        }
    }];
}

- (void)layerDidUpdate:(id<MSShapeGroup>)layer {
    MMLog(@"layerDidUpdate: %@", layer);
    [_observers enumerateObjectsUsingBlock:^(Weak * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id <SketchEventsController> controller = [obj object];
        if ([controller respondsToSelector:@selector(layerDidUpdate:)]) {
            [controller layerDidUpdate:layer];
        }
    }];
}

- (void)unobserveSelection {
    MMLog(@"Unobserving %lu", (unsigned long)[_layerChangeObservers count]);
    [_layerChangeObservers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeObserver:self forKeyPath:@"rect"];
    }];
    [_layerChangeObservers removeAllObjects];
}

- (void)observeSelection {
    NSArray *layers = [self selectedLayersAndAll];
    MMLog(@"observing %lu", (unsigned long)[layers count]);

    [layers enumerateObjectsUsingBlock:^(id <MSLayer> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(NSObject *)obj addObserver:self
                          forKeyPath:@"rect"
                             options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                             context:nil];
        [_layerChangeObservers addObject:obj];
    }];
}

- (void)notifyDocumentDidChange {
    [self unobserveSelection];

    dispatch_async(dispatch_get_main_queue(), ^{

        self.document = [NSClassFromString(@"MSDocument") currentDocument];
        self.selection = [[self.document selectedLayersA] layers];

        [_observers enumerateObjectsUsingBlock:^(Weak * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            id <SketchEventsController> controller = [obj object];
            if ([controller respondsToSelector:@selector(documentDidChange:)]) {
                [controller documentDidChange:[NSClassFromString(@"MSDocument") currentDocument]];
            }
        }];

        [self layerSelectionDidChange:nil];
    });
}

- (void)artboardDidUpdate:(id <MSArtboardGroup>)artboard {
    MMLog(@"artboardDidUpdate: %@", artboard);
    [_observers enumerateObjectsUsingBlock:^(Weak * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id <SketchEventsController> controller = [obj object];
        if ([controller respondsToSelector:@selector(artboardDidUpdate:)]) {
            [controller artboardDidUpdate:artboard];
        }
    }];
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"selectedLayersA"]) {
        _selection = [(id <MSLayerArray>)[_document valueForKey:@"selectedLayersA"] layers];
        [self layerSelectionDidChange:[self selectedLayers]];
    } else if ([keyPath isEqualToString:@"rect"]) {
        id <MSLayer> layer = object;
        NSRect oldRect = [change[NSKeyValueChangeOldKey] rectValue];
        NSRect newRect = [change[NSKeyValueChangeNewKey] rectValue];
        BOOL sizeChanged = ! CGSizeEqualToSize(oldRect.size, newRect.size);
        if (sizeChanged || ([layer respondsToSelector:@selector(isEditingChild)] && [(id <MSShapeGroup>)layer isEditingChild])) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(layerDidUpdate:) object:object];
                [self performSelector:@selector(layerDidUpdate:) withObject:object afterDelay:0.1];
            });
        }

        if ([layer isKindOfClass:NSClassFromString(@"MSLayer")] && [layer respondsToSelector:@selector(parentArtboard)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                id <MSArtboardGroup> artboard = [object parentArtboard];
                if (artboard) {
                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(artboardDidUpdate:) object:artboard];
                    [self performSelector:@selector(artboardDidUpdate:) withObject:artboard afterDelay:0.5];
                }
            });
        }
    }
}

#pragma mark - Helper

- (MMLayerProperties *)layerPropertiesForLayer:(id<MSLayer>)layer {
    NSString *source = [self.command valueForKey:@"source" onLayer:layer];
    NSString *version = [self.command valueForKey:@"version" onLayer:layer];
    if ([version hasPrefix:@"2"] && ( ! source || [source length] == 0)) {
        source = [layer name];
    }
    NSNumber *imageQuality = [self.command valueForKey:@"imageQuality" onLayer:layer];
    MMLayerProperties *properties = [MMLayerProperties propertiesWithImageQuality:imageQuality
                                                                           source:source
                                                                          version:version
                                     ];
    return properties;
}

@end


