//
//  MMContainerViewController.m
//  MagicMirror2
//
//  Created by James Tang on 21/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "MMContainerViewController.h"

@interface MMContainerViewController ()

@end

@implementation MMContainerViewController
@synthesize magicmirror = _magicmirror;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)reloadData {
    [[self childViewControllers] enumerateObjectsUsingBlock:^(__kindof NSViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj conformsToProtocol:@protocol(MMController)]) {
            id <MMController> controller = (id <MMController>)obj;
            controller.magicmirror = self.magicmirror;
        }
    }];
}

@end
