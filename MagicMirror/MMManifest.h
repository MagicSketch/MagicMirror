//
//  MMManifestParser.h
//  MagicMirror2
//
//  Created by James Tang on 14/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMManifest;
typedef void(^MMManifestURLCompletionHandler)(MMManifest *manifest, NSError *error);

@interface MMManifest : NSObject

@property (nonatomic, copy, readonly) NSString *version;
@property (nonatomic, copy, readonly) NSString *checkURL;
@property (nonatomic, copy, readonly) NSString *downloadURL;
@property (nonatomic, copy, readonly) NSString *name;

+ (instancetype)manifestNamed:(NSString *)name inBundle:(NSBundle *)bundle;
+ (instancetype)manifestWithVersion:(NSString *)version;
+ (instancetype)manifestWithVersion:(NSString *)version
                           checkURL:(NSString *)checkURL
                        downloadURL:(NSString *)downloadURL
                               name:(NSString *)name;
+ (instancetype)manifestFromFilePath:(NSString *)path;
+ (void)manifestFromURL:(NSURL *)url completion:(MMManifestURLCompletionHandler)completion;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSComparisonResult)compare:(MMManifest *)manifest;

@end
