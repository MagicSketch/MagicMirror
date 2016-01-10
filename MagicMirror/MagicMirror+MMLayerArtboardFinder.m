//
//  MagicMirror+MMLayerArtboardFinder.m
//  MagicMirror2
//
//  Created by James Tang on 11/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import "MagicMirror+MMLayerArtboardFinder.h"
#import "SketchPluginContext.h"

@implementation MagicMirror (MMLayerArtboardFinder)

- (NSDictionary *)artboardsLookup {
    return [self.context artboardsLookup];
}

@end
