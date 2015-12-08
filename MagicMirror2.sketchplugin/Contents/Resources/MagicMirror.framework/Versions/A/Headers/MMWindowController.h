//
//  MMWindowController.h
//  MagicMirror2
//
//  Created by James Tang on 7/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MagicMirror;
@class MMWindowController;

@protocol MMWindowControllerDelegate <NSObject>

- (void)controllerDidShow:(MMWindowController *)controller;
- (void)controllerDidClose:(MMWindowController *)controller;

@end

@interface MMWindowController : NSWindowController <NSWindowDelegate>

@property (nonatomic, weak) MagicMirror *magicmirror;
@property (nonatomic, weak) id <MMWindowControllerDelegate> delegate;

@end
