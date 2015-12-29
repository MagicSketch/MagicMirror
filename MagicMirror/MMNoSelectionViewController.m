//
//  MMNoSelectionViewController.m
//  MagicMirror2
//
//  Created by James Tang on 21/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "MMNoSelectionViewController.h"

@interface MMNoSelectionViewController ()
@property (weak) IBOutlet NSButton *closeButton;

@end

@implementation MMNoSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self becomeFirstResponder];
}

- (IBAction)closeButtonDidPress:(id)sender {
    [[NSApplication sharedApplication] sendAction:@selector(close) to:self.nextResponder from:self];
}

- (NSResponder *)nextResponder {
    return self.parentViewController;
}

@end
