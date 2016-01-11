//
//  MMViewController.m
//  MagicMirror2
//
//  Created by James Tang on 21/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "MMViewController.h"
#import "SketchEventsController.h"

@interface MMViewController ()

@end

@implementation MMViewController
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadData];
}

- (void)dealloc {
}

- (MagicMirror *)magicmirror {
    return _magicmirror;
}

- (void)setMagicmirror:(MagicMirror *)magicmirror {
    if (_magicmirror != magicmirror) {
        _magicmirror = magicmirror;
        [self reloadData];
    }
}

- (void)reloadData {
}

#pragma - Close

- (IBAction)closeButtonDidPress:(id)sender {
    [self close];
}

- (void)close {
    [self.view.window.windowController close];
}

@end
