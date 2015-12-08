//
//  MMWindowController.m
//  MagicMirror2
//
//  Created by James Tang on 7/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "MMWindowController.h"
#import "MagicMirror.h"

@interface MMWindowController ()

@end

@implementation MMWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    MMLog(@"MMWindowController did loaded");

    self.window.delegate = self;
}

- (void)windowWillClose:(NSNotification *)notification {
    [_magicmirror goAway];
}

- (void)dealloc {
    MMLog(@"MMWindowController: dealloc");
    [_magicmirror goAway];
}

@end
