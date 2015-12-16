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

@interface SketchPluginContext ()

@property (nonatomic, strong) MSPluginBundle *plugin;
@property (nonatomic, strong) MSPluginCommand *command;
@property (nonatomic, copy) NSArray *selection;
@property (nonatomic, strong) MSDocument *document;
@property (nonatomic, strong) id <COScript> coscript;
@property (nonatomic) BOOL observerAdded;

@end

@implementation SketchPluginContext

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
        return self;
    }
    return nil;
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
    NSArray *layers = [_selection filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if ([evaluatedObject isKindOfClass:NSClassFromString(@"MSShapeGroup")]) {
            return YES;
        }
        return NO;
    }]];
    return layers;
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"selectedLayersA"]) {
        _selection = [(id <MSLayerArray>)[_document valueForKey:@"selectedLayersA"] layers];

        if (_selectionChangeHandler) {
            _selectionChangeHandler([self selectedLayers]);
        }
    }
}

@end
