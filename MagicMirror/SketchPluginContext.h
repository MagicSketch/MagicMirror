//
//  SketchContext.h
//  MagicMirror2
//
//  Created by James Tang on 8/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDUnknownBlockType.h"
#import "Sketch.h"
@protocol MSShapeGroup;

typedef void(^MSDocumentLayerDidChangeSelectionHandler)(NSArray *array);

@interface SketchPluginContext : NSObject

@property (nonatomic, strong, readonly) MSPluginBundle *plugin;
@property (nonatomic, strong, readonly) MSPluginCommand *command;
@property (nonatomic, copy, readonly) NSArray *selection;
@property (nonatomic, strong, readonly) MSDocument *document;
@property (nonatomic, strong, readonly) id <COScript> coscript;

@property (nonatomic) BOOL shouldKeepAround;

- (id)initWithPlugin:(MSPluginBundle *)plugin
            document:(MSDocument *)document
           selection:(NSArray *)selection
             command:(MSPluginCommand *)command;

- (NSArray *)pages;
- (NSArray *)artboards;
- (NSDictionary *)artboardsLookup;
- (NSArray *)selectedLayers;

@end


