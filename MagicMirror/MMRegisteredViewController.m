//
//  MMRegisteredViewController.m
//  MagicMirror2
//
//  Created by James Tang on 31/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "MMRegisteredViewController.h"
#import "MMLicenseInfo.h"

@interface MMRegisteredViewController ()

@property (weak) IBOutlet NSTextField *contentTextField;
@property (weak) IBOutlet NSButton *deregisterButton;
@property (weak) IBOutlet NSButton *OKButton;
@property (copy) NSString *content;
@property (strong) MMLicenseInfo *licenseInfo;

@end

@implementation MMRegisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.

    self.content = self.contentTextField.stringValue;
    [self reloadData];
}

- (void)reloadData {
    [super reloadData];
    if ( ! self.isViewLoaded) {
        return;
    }

    self.licenseInfo = self.magicmirror.licensedTo;
    self.contentTextField.stringValue = [NSString stringWithFormat:self.content,
                                         self.licenseInfo.firstName,
                                         self.licenseInfo.lastName,
                                         self.licenseInfo.email,
                                         self.licenseInfo.license
                                         ];
}

#pragma mark - Action

- (IBAction)deregisterButtonDidPress:(id)sender {
    [self.magicmirror deregister];
    [self close];
}

- (IBAction)okButtonDidPress:(id)sender {
    [self close];
}

@end
