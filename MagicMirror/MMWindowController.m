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

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [MagicMirror addObserver:self];
    [self.magicmirror keepAround];
}

- (void)showWindow:(nullable id)sender {
    [super showWindow:sender];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    MMLog(@"MMWindowController did loaded");
    self.window.delegate = self;
    self.window.level = NSMainMenuWindowLevel;
    self.window.hidesOnDeactivate = YES;
    [self.delegate controllerDidShow:self];
    self.window.movableByWindowBackground = YES;
}

- (void)windowWillClose:(NSNotification *)notification {
    [self.delegate controllerDidClose:self];
}

- (void)dealloc {
    [_magicmirror goAway];
    MMLog(@"MMWindowController: dealloc");
}

@end
