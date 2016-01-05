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
        return self;
    }
    return nil;
}

- (void)dealloc {
    MMLog(@"SketchPluginContext dealloc")
    [self unobserveSelection];
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

#pragma mark - Notifications

- (void)layerSelectionDidChange:(NSArray *)layers {
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
    NSArray *layers = [self selectedLayers];
    MMLog(@"observing %lu", (unsigned long)[layers count]);

    [layers enumerateObjectsUsingBlock:^(id <MSShapeGroup> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(NSObject *)obj addObserver:self
                          forKeyPath:@"rect"
                             options:NSKeyValueObservingOptionNew
                             context:nil];
        [_layerChangeObservers addObject:obj];
    }];
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"selectedLayersA"]) {
        _selection = [(id <MSLayerArray>)[_document valueForKey:@"selectedLayersA"] layers];
        [self layerSelectionDidChange:[self selectedLayers]];
    } else if ([keyPath isEqualToString:@"rect"]) {
        id <MSShapeGroup> shape = object;
        MMLog(@"%@ object.rect: %@", object, NSStringFromRect([shape rect]));
        if ([shape isEditingChild]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self layerDidUpdate:object];
            });
        }
    }
}

@end


