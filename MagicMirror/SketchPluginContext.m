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
#import "MSLayerGroup.h"

@interface SketchPluginContext ()

@property (nonatomic, strong) MSPluginBundle *plugin;
@property (nonatomic, strong) MSPluginCommand *command;
@property (nonatomic, copy) NSArray *selection;
@property (nonatomic, strong) MSDocument *document;
@property (nonatomic, strong) id <COScript> coscript;

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

- (NSArray *)selectedLayers {
    NSArray *layers = [_selection filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if ([evaluatedObject isKindOfClass:NSClassFromString(@"MSShapeGroup")]) {
            return YES;
        }
        return NO;
    }]];
    return layers;
}

@end
