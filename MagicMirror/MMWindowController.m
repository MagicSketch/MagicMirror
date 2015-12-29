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
//    [NSApp runModalForWindow: self.window];
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
//    [NSApp stopModal];
    [self.delegate controllerDidClose:self];
}

- (void)dealloc {
    MMLog(@"MMWindowController: dealloc");
//    [_magicmirror goAway];
}

- (void)configureMagicMirror {
    if ([self.contentViewController conformsToProtocol:@protocol(MMController)]) {
        id <MMController> controller = (id <MMController>)self.contentViewController;
        controller.magicmirror = self.magicmirror;
    } else if ([self.contentViewController isKindOfClass:[NSTabViewController class]]) {
        NSTabViewController *tvc = (NSTabViewController *)self.contentViewController;
        [[tvc childViewControllers] enumerateObjectsUsingBlock:^(__kindof NSViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj conformsToProtocol:@protocol(MMController)]) {
                id <MMController> controller = (id <MMController>)obj;
                controller.magicmirror = self.magicmirror;
            }
        }];
    }
}

- (void)reloadData {
    if ([self.contentViewController conformsToProtocol:@protocol(MMController)]) {
        id <MMController> controller = (id <MMController>)self.contentViewController;
        [controller reloadData];
    }
}

- (void)close {
    [super close];
}

@end
