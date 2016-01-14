//
//  MMManifestParser.h
//  MagicMirror2
//
//  Created by James Tang on 14/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMManifest : NSObject

@property (nonatomic, copy, readonly) NSString *version;
@property (nonatomic, copy, readonly) NSString *checkURL;
@property (nonatomic, copy, readonly) NSString *name;

+ (instancetype)manifestNamed:(NSString *)name inBundle:(NSBundle *)bundle;
+ (instancetype)manifestWithVersion:(NSString *)version;
+ (instancetype)manifestFromFilePath:(NSString *)path;
- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSComparisonResult)compare:(MMManifest *)manifest;

@end
