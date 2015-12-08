//
//  MMWindowController.m
//  MagicMirror2
//
//  Created by James Tang on 7/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "MMWindowController.h"

@interface MMWindowController ()

@end

@implementation MMWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.

    NSLog(@"MMWindowController did loaded");
}

- (void)dealloc {
    NSLog(@"MMWindowController: dealloc");
}

@end
