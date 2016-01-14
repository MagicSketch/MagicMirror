//
//  MMManifestParser.m
//  MagicMirror2
//
//  Created by James Tang on 14/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import "MMManifest.h"

@implementation MMManifest

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.version = dictionary[@"version"];
        self.checkURL = dictionary[@"checkURL"];
    }
    return self;
}

@end
