//
//  MMContainerViewController.m
//  MagicMirror2
//
//  Created by James Tang on 21/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "MMContainerViewController.h"
#import "MMToolbarViewController.h"
#import "MMNoSelectionViewController.h"

@interface MMContainerViewController ()
@property (nonatomic, strong) MMToolbarViewController *configureVC;
@property (nonatomic, strong) MMNoSelectionViewController *noSelectionVC;
@end

@implementation MMContainerViewController
@synthesize magicmirror = _magicmirror;

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SI_ConfigureVC"]) {
        self.configureVC = segue.destinationController;
    } else if ([segue.identifier isEqualToString:@"SI_NoSelectionVC"]) {
        self.noSelectionVC = segue.destinationController;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)reloadData {
    [super reloadData];

    BOOL showConfigureVC = ! [[self.magicmirror selectedLayers] count] > 0;
    BOOL showNoSelectionVC = ! [[self.magicmirror selectedLayers] count] == 0;

    self.configureVC.view.hidden = showConfigureVC;
    self.noSelectionVC.view.hidden = showNoSelectionVC;
}

- (NSResponder *)nextResponder {
    return self.view.window.windowController;
}

@end
