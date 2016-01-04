//
//  NSObject+SketchEventsController.m
//  MagicMirror2
//
//  Created by James Tang on 4/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import "NSObject+SketchEventsController.h"

NSString *const SketchLayerSelectionDidChangeNotification = @"SketchLayerSelectionDidChangeNotification";
NSString *const SketchLayerDidUpdateNotification = @"SketchLayerDidUpdateNotification";



@implementation NSObject (Sketch)

+ (NSDictionary *)sketchSelectorMappings {
    NSDictionary *mapping = @{
                              NSStringFromSelector(@selector(layerSelectionDidChange:)) : SketchLayerSelectionDidChangeNotification,
                              NSStringFromSelector(@selector(layerDidUpdate:)) : SketchLayerDidUpdateNotification,
                              };
    return mapping;
}

- (void)observeSketch:(SEL)selector {
    NSString *notificationName = [NSObject sketchSelectorMappings][NSStringFromSelector(selector)];
    if (notificationName && [self respondsToSelector:selector]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sketchNotification:)
                                                     name:notificationName
                                                   object:nil];
    }
}

- (void)unobserveSketch:(SEL)selector {
    NSString *notificationName = [NSObject sketchSelectorMappings][NSStringFromSelector(selector)];
    if (notificationName && [self respondsToSelector:selector]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:notificationName object:nil];
    }
}

- (void)sketchNotification:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    SEL selector = NSSelectorFromString(userInfo[@"selector"]);
    void (^Handler)(NSObject *) = userInfo[@"block"];
    if ([self respondsToSelector:selector]) {
        Handler(self);
    }
}

@end