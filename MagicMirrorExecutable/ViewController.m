//
//  ViewController.m
//  MagicMirrorExecutable
//
//  Created by James Tang on 7/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "ViewController.h"
#import "MMViewController.h"

@interface ViewController ()

@property (weak) IBOutlet NSButton *buttonDidClick;

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
    MMViewController *controller = [[MMViewController alloc] init];
    [controller log];
}

@end
