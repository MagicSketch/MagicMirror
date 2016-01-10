//
//  MagicMirror+MMPropertyController.m
//  MagicMirror2
//
//  Created by James Tang on 11/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import "MagicMirror+MMPropertyController.h"
#import "SketchPluginContext.h"

@implementation MagicMirror (MMPropertyController)

- (void)setValue:(id)value forKey:(NSString *)key onLayer:(MMLayer *)layer {
    [self.context.command setValue:value forKey:key onLayer:[layer layer]];
}

- (id)valueForKey:(NSString *)key onLayer:(MMLayer *)layer {
    return [self.context.command valueForKey:key onLayer:[layer layer]];
}

- (void)setVersionOnLayer:(MMLayer *)layer {
    [self setValue:self.version forKey:@"version" onLayer:layer];
}

@end
