//
//  MMManifestParser.m
//  MagicMirror2
//
//  Created by James Tang on 14/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import "MMManifest.h"

@interface MMManifest ()

@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *checkURL;
@property (nonatomic, copy) NSString *downloadURL;
@property (nonatomic, copy) NSString *name;

@end

@implementation MMManifest

+ (instancetype)manifestNamed:(NSString *)name inBundle:(NSBundle *)bundle {
    NSString *path = [bundle pathForResource:name ofType:@"json"];
    return [self manifestFromFilePath:path];
}

+ (instancetype)manifestWithVersion:(NSString *)version {
    return [self manifestWithVersion:version
                            checkURL:nil
                         downloadURL:nil
                                name:nil];
}

+ (instancetype)manifestWithVersion:(NSString *)version checkURL:(NSString *)checkURL downloadURL:(NSString *)downloadURL name:(NSString *)name {
    MMManifest *manifest = [[self alloc] init];
    manifest.version = version;
    manifest.name = name;
    manifest.downloadURL = downloadURL;
    manifest.checkURL = checkURL;
    return manifest;
}

+ (instancetype)manifestFromFilePath:(NSString *)path {
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    MMManifest *manifest = [[MMManifest alloc] initWithDictionary:dictionary];
    return manifest;
}

+ (void)manifestFromURL:(NSURL *)url completion:(MMManifestURLCompletionHandler)completion {
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url
                                                         completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

                                                             NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                             MMManifest *manifest = [[MMManifest alloc] initWithDictionary:dictionary];
                                                             if (completion) {
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                     completion(manifest, error);
                                                                 });
                                                             }
                                                         }];
    [task resume];
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.version = dictionary[@"version"];
        self.checkURL = dictionary[@"checkURL"];
        self.downloadURL = dictionary[@"downloadURL"];
    }
    return self;
}

- (NSComparisonResult)compare:(MMManifest *)manifest {
    return [self.version compare:manifest.version];
}

@end
