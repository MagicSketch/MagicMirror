//
//  MMViewController.m
//  MagicMirror2
//
//  Created by James Tang on 21/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "MMViewController.h"
#import "NSObject+SketchEventsController.h"

@interface MMViewController ()

@property (nonatomic, strong) id comboboxObserver;

@end

@implementation MMViewController
@synthesize magicmirror = _magicmirror;

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
    MMViewController *controller = segue.destinationController;
    if ([controller conformsToProtocol:@protocol(MMController)]) {
        controller.magicmirror = self.magicmirror;
        [controller reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self observeSketch:@selector(layerSelectionDidChange:)];
    [self observeSketch:@selector(layerDidUpdate:)];
}

- (void)dealloc {
    [self unobserveSketch:@selector(layerDidUpdate:)];
    [self unobserveSketch:@selector(layerSelectionDidChange:)];
    self.shouldObserveCombobox = NO;
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

- (void)reloadData {
    [[self childViewControllers] enumerateObjectsUsingBlock:^(__kindof NSViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj conformsToProtocol:@protocol(MMController)]) {
            id <MMController> controller = (id <MMController>)obj;
            controller.magicmirror = self.magicmirror;
            [controller reloadData];
        }
    }];
}

#pragma - Close

- (IBAction)closeButtonDidPress:(id)sender {
    [self close];
}

- (void)close {
    [self.view.window.windowController close];
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
