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
@property (weak) IBOutlet NSButton *refreshPageButton;

@end

@implementation MMNoSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)closeButtonDidPress:(id)sender {
    [self.magicmirror closeToolbar];
}

- (IBAction)refreshPageButtonDidPress:(id)sender {
    [self.magicmirror refreshPage];
}

@end
