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

@property (nonatomic, strong) NSUserDefaults *persister;

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
    self.persister = [NSUserDefaults standardUserDefaults];
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

    NSString *windowsFrame = [self.persister objectForKey:@"design.magicmirror.window.frame"];
    [self setShouldCascadeWindows:NO];
    if (windowsFrame) {
        if (CGRectContainsRect([[NSScreen mainScreen] frame], NSRectFromString(windowsFrame))) {
            // Make sure rect is visible
            NSRect rect = NSRectFromString(windowsFrame);
            [self.window setFrame:rect display:YES];
            MMLog(@"opening frame: %@ (visible)", NSStringFromRect(self.window.frame));
        } else {
            MMLog(@"opening frame: %@ (not visible, resetting frame)", NSStringFromRect(self.window.frame));
        }
    }
}

- (void)windowWillClose:(NSNotification *)notification {
    [self.persister setObject:NSStringFromRect(self.window.frame) forKey:@"design.magicmirror.window.frame"];
    [self.persister synchronize];
    [self.delegate controllerDidClose:self];

    MMLog(@"closing frame: %@", NSStringFromRect(self.window.frame));
}

- (void)dealloc {
    [_magicmirror goAway];
    MMLog(@"MMWindowController: dealloc");
}

@end
