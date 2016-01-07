//
//  MMLayerProperty.m
//  MagicMirror2
//
//  Created by James Tang on 11/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "MMLayerProperties.h"


@interface MMLayerProperties ()

@property (nonatomic, copy) NSNumber *imageQuality;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *version;

@end

@implementation MMLayerProperties

+ (instancetype)propertiesWithImageQuality:(NSNumber *)imageQuality source:(NSString *)source version:(NSString *)version {
    MMLayerProperties *properties = [[self alloc] init];
    properties.imageQuality = imageQuality;
    properties.source = source;
    properties.version = version;
    return properties;
}

- (void)clear {
    MMLayerProperties *properties = self;
    properties.imageQuality = nil;
    properties.source = nil;
}

- (NSString *)description {
    return [[self dictionaryWithValuesForKeys:@[
                                                @"imageQuality",
                                                @"source",
                                                @"version",
                                               ]] description];
}

@end
