//
//  MMImageLoader.m
//  MagicMirror2
//
//  Created by James Tang on 12/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import "MMImageLoader.h"
#import <Cocoa/Cocoa.h>

@implementation MMImageLoader

- (NSImage *)imageNamed:(NSString *)name {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSImage *image = [bundle imageForResource:name];
    return image;
}

@end
