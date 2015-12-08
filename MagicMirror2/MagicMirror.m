//
//  MMViewController.m
//  MagicMirror2
//
//  Created by James Tang on 7/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "MagicMirror.h"
#import "MMWindowController.h"
#import "COScript.h"
@import AppKit;

@interface MagicMirror ()

@property (nonatomic, strong) MMWindowController *controller;

@end

@implementation MagicMirror

- (void)showWindow {
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle bundleForClass:[MMWindowController class]]];
    _controller = [storyboard instantiateInitialController];
    [_controller showWindow:self];
}

- (void)log {
    [self showWindow];
    NSLog(@"something");
}

- (NSString *)something {
    [self showWindow];
    return @"someeee";
}

- (void)showWindowCoscript:(id <COScript>)coscript {
    NSLog(@"coscript %@", coscript);
    [coscript setShouldKeepAround:YES];
    [self showWindow];
}

@end
