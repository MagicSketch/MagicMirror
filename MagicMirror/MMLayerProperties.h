//
//  MMLayerProperty.h
//  MagicMirror2
//
//  Created by James Tang on 11/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMLayerProperties : NSObject

@property (nonatomic, copy, readonly) NSNumber *imageQuality;
@property (nonatomic, copy, readonly) NSString *source;
@property (nonatomic, copy, readonly) NSString *version;

+ (instancetype)propertiesWithImageQuality:(NSNumber *)imageQuality
                                    source:(NSString *)source
                                   version:(NSString *)version;

- (void)clear;

@end
