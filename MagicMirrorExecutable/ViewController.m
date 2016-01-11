//
//  ViewController.m
//  MagicMirrorExecutable
//
//  Created by James Tang on 7/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "ViewController.h"
#import "MagicMirror.h"

@interface ViewController ()

@property (weak) IBOutlet NSButton *buttonDidClick;
@property (strong) MagicMirror *magicmirror;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)buttonDidClick:(id)sender {
    self.magicmirror = [[MagicMirror alloc] init];
    [self.magicmirror showToolbar];
}

- (IBAction)licenseButtonDidPress:(id)sender {
    self.magicmirror = [[MagicMirror alloc] init];
    [self.magicmirror showLicenseInfo];
}

@end
