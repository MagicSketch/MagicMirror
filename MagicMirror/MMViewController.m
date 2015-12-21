//
//  MMViewController.m
//  MagicMirror2
//
//  Created by James Tang on 21/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "MMViewController.h"

@interface MMViewController ()

@end

@implementation MMViewController
@synthesize magicmirror = _magicmirror;

- (MagicMirror *)magicmirror {
    return _magicmirror;
}

- (void)setMagicmirror:(MagicMirror *)magicmirror {
    if (_magicmirror != magicmirror) {
        _magicmirror = magicmirror;
        [self reloadData];
    }
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
