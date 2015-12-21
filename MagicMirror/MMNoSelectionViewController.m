//
//  MMNoSelectionViewController.m
//  MagicMirror2
//
//  Created by James Tang on 21/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "MMNoSelectionViewController.h"

@interface MMNoSelectionViewController ()

@end

@implementation MMNoSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.

    CALayer *viewLayer = [CALayer layer];
    [viewLayer setBackgroundColor:[NSColor controlColor].CGColor]; //RGB plus Alpha Channel
    [self.view setWantsLayer:YES]; // view's backing store is using a Core Animation Layer
    [self.view setLayer:viewLayer];
    self.view.acceptsTouchEvents = YES;
}

@end
