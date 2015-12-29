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
@property (weak) IBOutlet NSProgressIndicator *loadingIndicator;

@end


@implementation MMLicenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (IBAction)purchaseButtonDidPress:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://magicmirror.design/purchase"]];
}

- (IBAction)laterButtonDidPress:(id)sender {
    [self close];
}

- (IBAction)enterButtonDidPress:(id)sender {
    [self startLoading];

    __weak __typeof (self) weakSelf = self;
    [self.magicmirror unlockLicense:^(NSDictionary *result, NSError *error) {
        [weakSelf stopLoading];
    }];
}

- (void)startLoading {
    self.licenseTextField.enabled = NO;
    self.enterButton.enabled = NO;
    [self.loadingIndicator startAnimation:nil];
}

- (void)stopLoading {
    self.licenseTextField.enabled = YES;
    self.enterButton.enabled = YES;
    [self.loadingIndicator stopAnimation:nil];
}

@end
