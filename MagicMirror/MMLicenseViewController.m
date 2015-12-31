//
//  MMLicenseViewController.m
//  MagicMirror2
//
//  Created by James Tang on 29/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "MMLicenseViewController.h"
#import "NSView+Animate.h"

@interface MMLicenseViewController ()

@property (weak) IBOutlet NSTextField *licenseTextField;
@property (weak) IBOutlet NSTextField *errorTextField;
@property (weak) IBOutlet NSButton *purchaseButton;
@property (weak) IBOutlet NSButton *laterButton;
@property (weak) IBOutlet NSButton *enterButton;
@property (weak) IBOutlet NSProgressIndicator *loadingIndicator;

@end


@implementation MMLicenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.errorTextField.stringValue = @"";
}

- (IBAction)purchaseButtonDidPress:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://magicmirror.design/purchase"]];
}

- (IBAction)laterButtonDidPress:(id)sender {
    [self close];
}

- (IBAction)enterButtonDidPress:(id)sender {
    NSString *string = self.licenseTextField.stringValue;

    if ( ! [string length]) {
        [self displayIncorrectLicenseWithMessage:@"Enter Your Key"];
        return;
    }

    [self startLoading];
    __weak __typeof (self) weakSelf = self;
    
    [self.magicmirror unlockLicense:string
                         completion:^(MMLicenseInfo *info, NSError *error) {
                             MMLog(@"response: %@ %@", info, error);
                             if (error) {
                                 [weakSelf displayIncorrectLicenseWithMessage:error.localizedDescription];
                             } else {
                                 [weakSelf displayCorrectLicenseInfo:info];
                             }
                             [weakSelf stopLoading];
                         }];
}

- (void)startLoading {
    self.errorTextField.stringValue = @"";
    self.licenseTextField.editable = NO;
    self.enterButton.enabled = NO;
    [self.loadingIndicator startAnimation:nil];
}

- (void)stopLoading {
    self.licenseTextField.editable = YES;
    self.enterButton.enabled = YES;
    [self.loadingIndicator stopAnimation:nil];
}

- (void)shakeLicenseBox {
    [self.licenseTextField shake];
}

- (void)displayIncorrectLicenseWithMessage:(NSString *)message {
    [self shakeLicenseBox];
    [self.errorTextField setStringValue:message];
}

- (void)displayCorrectLicenseInfo:(MMLicenseInfo *)licenseInfo {
    [self performSegueWithIdentifier:@"RegisteredView" sender:self];
    [self close];
}

@end
