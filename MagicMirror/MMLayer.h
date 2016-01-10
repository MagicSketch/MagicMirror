//
//  MMLayerController.h
//  MagicMirror2
//
//  Created by James Tang on 9/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MagicMirror.h"
@class MMImageRenderer;
@class MMLayer;

@protocol MMLayerPropertySetter <NSObject>

- (void)setVersionOnLayer:(MMLayer *)layer;
- (void)setValue:(id)value forKey:(NSString *)key onLayer:(MMLayer *)layer;
- (id)valueForKey:(NSString *)key onLayer:(MMLayer *)layer;

@end

@protocol MMLayerArtboardFinder <NSObject>

- (NSDictionary *)artboardsLookup;

@end


@protocol MMLayer <NSObject>

- (void)clear;
- (void)disableFill;
- (void)fillWithImage:(NSImage *)image;
- (void)flip;
- (void)mirrorWithArtboard:(id<MSArtboardGroup>)artboard
              imageQuality:(MMImageRenderQuality)imageQuality
      colorSpaceIdentifier:(ImageRendererColorSpaceIdentifier)colorSpaceIdentifier
               perspective:(BOOL)perspective;
- (void)refresh;
- (void)rotate;
- (void)setArtboard:(id <MSArtboardGroup>)artboard;

@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSNumber *imageQuality;
@property (nonatomic, copy, readonly) NSString *version;

- (void)configureVersion;

@end

@interface MMLayer : NSObject <MMLayer>

@property (nonatomic, strong) id <MSShapeGroup> layer;
+ (instancetype)layerWithLayer:(id <MSShapeGroup>)layer;
+ (instancetype)layerWithLayer:(id <MSShapeGroup>)layer
                        finder:(id <MMLayerArtboardFinder>)finder
                propertySetter:(id <MMLayerPropertySetter>)setter;

@end
