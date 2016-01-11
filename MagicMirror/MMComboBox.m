//
//  MMComboBox.m
//  MagicMirror2
//
//  Created by James Tang on 12/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import "MMComboBox.h"

@interface MMComboBox () <NSComboBoxDelegate>

@property (nonatomic, weak) id <NSComboBoxDelegate> delegateRef;
@property (nonatomic) BOOL isPoppedUp;

@end

@implementation MMComboBox

- (void)setDelegate:(id<NSComboBoxDelegate>)anObject {
    [super setDelegate:self];
    _delegateRef = anObject;
}

//- (void)selectItemAtIndex:(NSInteger)index {
//    _delegateRef = _delegate;
//    _delegate = nil;    // So that notification don't fire when item is selected programmatically
//    [super selectItemAtIndex:index];
//    _delegate = _delegateRef;
//}

- (void)comboBoxWillPopUp:(NSNotification *)notification {
    _isPoppedUp = YES;
    if ([self.delegateRef respondsToSelector:@selector(comboBoxWillPopUp:)]) {
        [self.delegateRef comboBoxWillPopUp:notification];
    }
}

- (void)comboBoxWillDismiss:(NSNotification *)notification {
    _isPoppedUp = NO;
    if ([self.delegateRef respondsToSelector:@selector(comboBoxWillDismiss:)]) {
        [self.delegateRef comboBoxWillDismiss:notification];
    }
}

- (void)comboBoxSelectionDidChange:(NSNotification *)notification {
    if (_isPoppedUp) {
        if ([self.delegateRef respondsToSelector:@selector(comboBoxSelectionDidChange:)]) {
            [self.delegateRef comboBoxSelectionDidChange:notification];
        }
    }

}

@end
