//
//  NSObject+SketchEventsController.h
//  MagicMirror2
//
//  Created by James Tang on 4/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol MSShapeGroup;



@protocol SketchEventsController <NSObject>

// Sketch Events Selector
// Use -[NSObject observeSketch:@selector(layerSelectionDidChange:)]
@optional
- (void)layerSelectionDidChange:(NSArray *)layers;
- (void)layerDidUpdate:(id <MSShapeGroup>)layer;

@end


@interface NSObject (Sketch) <SketchEventsController>

- (void)observeSketch:(SEL)selector;    // e.g. [self observeSketch:@selector(layerSelectionDidChange:)];
- (void)unobserveSketch:(SEL)selector;

@end


extern NSString *const SketchLayerSelectionDidChangeNotification;
extern NSString *const SketchLayerDidUpdateNotification;
