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

+ (instancetype)propertiesWithImageQuality:(NSNumber *)imageQuality
                                    source:(NSString *)source;

@end
