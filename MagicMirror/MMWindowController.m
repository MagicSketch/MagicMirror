//
//  MMWindowController.m
//  MagicMirror2
//
//  Created by James Tang on 7/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "MMWindowController.h"
#import "MMToolbarViewController.h"
#import "MagicMirror.h"

@interface MMWindowController ()

@end

@implementation MMWindowController
@synthesize magicmirror = _magicmirror;

- (void)setMagicmirror:(MagicMirror *)magicmirror {
    _magicmirror = magicmirror;
    [self configureMagicMirror];
}

- (void)showWindow:(nullable id)sender {
    [_magicmirror keepAround];
    [super showWindow:sender];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    MMLog(@"MMWindowController did loaded");
    self.window.delegate = self;
    self.window.level = NSMainMenuWindowLevel;
    self.window.hidesOnDeactivate = YES;
    [self.delegate controllerDidShow:self];
    [self configureMagicMirror];
    self.window.movableByWindowBackground = YES;
}

- (void)windowWillClose:(NSNotification *)notification {
    [_magicmirror goAway];
    [self.delegate controllerDidClose:self];
}

- (void)dealloc {
    MMLog(@"MMWindowController: dealloc");
}

- (void)configureMagicMirror {
    [MagicMirror setSharedInstance:self.magicmirror];
}

@end
