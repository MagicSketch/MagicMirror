//
//  MockPropertySetter.m
//  MagicMirror2
//
//  Created by James Tang on 11/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import "MockPropertySetter.h"

@interface MockPropertySetter ()

@property (nonatomic, strong) NSMutableDictionary *storage;

@end

@implementation MockPropertySetter

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.storage = [@{} mutableCopy];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key onLayer:(MMLayer *)layer {
    [self.storage setValue:value forKey:[NSString stringWithFormat:@"%@%@", key, layer]];
}

- (id)valueForKey:(NSString *)key onLayer:(MMLayer *)layer {
    return [self.storage valueForKey:[NSString stringWithFormat:@"%@%@", key, layer]];
}

- (void)setVersionOnLayer:(MMLayer *)layer {
    [self setValue:@"2.0" forKey:@"version" onLayer:layer];
}

@end
