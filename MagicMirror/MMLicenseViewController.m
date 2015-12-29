//
//  MMLicenseViewController.m
//  MagicMirror2
//
//  Created by James Tang on 29/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "MMLicenseViewController.h"

@interface MMLicenseViewController ()

@property (weak) IBOutlet NSTextField *licenseTextField;
@property (weak) IBOutlet NSButton *purchaseButton;
@property (weak) IBOutlet NSButton *laterButton;
@property (weak) IBOutlet NSButton *enterButton;

@end


@implementation MMLicenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (IBAction)purchaseButtonDidPress:(id)sender {

}

- (IBAction)laterButtonDidPress:(id)sender {
    [self close];
}

- (IBAction)enterButtonDidPress:(id)sender {

}

- (void)close {
//    [super close];
    MMLog(@"self.view.window.windowController %@", self.view.window.windowController);
    MMLog(@"self.view.window %@", self.view.window);
    MMLog(@"self.view %@", self.view);

//    [[NSApplication sharedApplication] sendAction:@selector(close) to:self.view.window.windowController from:self];

    [self.view.window.windowController close];

}

@end
