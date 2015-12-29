//
//  MMViewController.h
//  MagicMirror2
//
//  Created by James Tang on 21/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MMController.h"
#import "MagicMirror.h"

@interface MMViewController : NSViewController <MMController>


@property (readwrite) MagicMirror *magicmirror;

- (void)reloadData; // subclass should call super
- (void)close; // This will find the proper window controller to close

@property (nonatomic) BOOL shouldObserveCombobox;
- (void)comboBoxValueDidChange:(NSComboBox *)sender;    // Override this when shouldObserveCombobox is set to YES

@end
