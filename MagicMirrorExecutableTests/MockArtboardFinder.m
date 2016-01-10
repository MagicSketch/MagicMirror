//
//  MockArtboardFinder.m
//  MagicMirror2
//
//  Created by James Tang on 11/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import "MockArtboardFinder.h"
#import "MSArtboardGroup.h"

@interface MockArtboardFinder ()

@property (nonatomic, strong) NSMutableDictionary *lookup;

@end

@implementation MockArtboardFinder

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lookup = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addArtboard:(id<MSArtboardGroup>)artboard {
    self.lookup[artboard.name] = artboard;
}

- (NSDictionary *)artboardsLookup {
    return [self.lookup copy];
}
@end
