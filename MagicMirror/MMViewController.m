//
//  MMViewController.m
//  MagicMirror2
//
//  Created by James Tang on 21/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "MMViewController.h"

@interface MMViewController ()

@property (nonatomic, strong) id comboboxObserver;

@end

@implementation MMViewController
@synthesize magicmirror = _magicmirror;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (MagicMirror *)magicmirror {
    return _magicmirror;
}

- (void)setMagicmirror:(MagicMirror *)magicmirror {
    if (_magicmirror != magicmirror) {
        _magicmirror = magicmirror;
        [self reloadData];
    }
}

- (void)dealloc {
    self.shouldObserveCombobox = NO;
}

- (void)reloadData {
    [[self childViewControllers] enumerateObjectsUsingBlock:^(__kindof NSViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj conformsToProtocol:@protocol(MMController)]) {
            id <MMController> controller = (id <MMController>)obj;
            controller.magicmirror = self.magicmirror;
            [controller reloadData];
        }
    }];
}

#pragma - ComboBox

- (void)setShouldObserveCombobox:(BOOL)shouldObserveCombobox {
    if (_shouldObserveCombobox != shouldObserveCombobox) {
        if (shouldObserveCombobox) {
            [self observeComboBox];
        } else {
            [self unobserveCombobox];
        }
        _shouldObserveCombobox = shouldObserveCombobox;
    }
}

- (void)observeComboBox {
    __weak __typeof (self) weakSelf = self;
    self.comboboxObserver = [[NSNotificationCenter defaultCenter] addObserverForName:NSComboBoxSelectionDidChangeNotification
                                                                              object:nil
                                                                               queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {

                                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                                       [weakSelf comboBoxValueDidChange:note.object];
                                                                                   });
                                                                               }];
}

- (void)unobserveCombobox {
    [[NSNotificationCenter defaultCenter] removeObserver:self.comboboxObserver];
}

- (void)comboBoxValueDidChange:(NSComboBox *)sender {
}

@end
