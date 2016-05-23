//
//  NSObject+SketchEventsController.h
//  MagicMirror2
//
//  Created by James Tang on 4/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol MSShapeGroup;
@protocol MSLayerGroup;
@protocol MSArtboardGroup;
@protocol MSDocument;

@protocol SketchEventsController <NSObject>

@optional
- (void)layerSelectionDidChange:(NSArray *)layers;
- (void)layerDidUpdate:(id <MSShapeGroup>)layer;
- (void)artboardDidUpdate:(id <MSArtboardGroup>)artboard;
- (void)documentDidChange:(id <MSDocument>)document;

@end
