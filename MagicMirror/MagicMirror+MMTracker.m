//
//  MagicMirror+MMTracker.m
//  MagicMirror2
//
//  Created by James Tang on 11/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import "MagicMirror+MMTracker.h"
#import "MagicMirror-Private.h"
#import "MMLayer.h"

@implementation MagicMirror (MMTracker)

- (void)track:(NSString *)event {
    [self.tracker track:event];
}

- (void)track:(NSString *)event
   properties:(NSDictionary *)properties {
    [self.tracker track:event
             properties:properties];
}

- (void)trackSelectionEvent:(NSString *)event {

    NSMutableDictionary *info = [@{} mutableCopy];
    [self.selectedLayers enumerateObjectsUsingBlock:^(id <MSShapeGroup> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MMLayer *l = [MMLayer layerWithLayer:obj];
        NSString *key = [NSString stringWithFormat:@"Image Quality %@", NSStringFromMMImageRenderQuality((MMImageRenderQuality)[l.imageQuality unsignedIntegerValue])];
        info[key] = @([info[key] integerValue] + 1);
    }];

    info[@"Selected Layers"] = @([self.selectedLayers count]);

    [self.tracker track:event properties:info];
}

@end
