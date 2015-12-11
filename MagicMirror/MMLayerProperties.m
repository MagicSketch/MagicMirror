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

@end

@implementation MMLayerProperties

+ (instancetype)propertiesWithImageQuality:(NSNumber *)imageQuality
                                    source:(NSString *)source {
    MMLayerProperties *properties = [[self alloc] init];
    properties.imageQuality = imageQuality;
    properties.source = source;
    return properties;
}

@end
