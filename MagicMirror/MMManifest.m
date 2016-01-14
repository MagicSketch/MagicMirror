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
@property (nonatomic, copy) NSString *name;

@end

@implementation MMManifest

+ (instancetype)manifestNamed:(NSString *)name inBundle:(NSBundle *)bundle {
    NSString *path = [bundle pathForResource:name ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    MMManifest *manifest = [[MMManifest alloc] initWithDictionary:dictionary];
    return manifest;
}

+ (instancetype)manifestWithVersion:(NSString *)version {
    MMManifest *manifest = [[self alloc] init];
    manifest.version = version;
    return manifest;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.version = dictionary[@"version"];
        self.checkURL = dictionary[@"checkURL"];
    }
    return self;
}

- (NSComparisonResult)compare:(MMManifest *)manifest {
    return [self.version compare:manifest.version];
}

@end
