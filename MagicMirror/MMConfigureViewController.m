//
//  MMConfigureViewController.m
//  MagicMirror2
//
//  Created by James Tang on 11/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "MMConfigureViewController.h"
#import "MSShapeGroup.h"
#import "MagicMirror.h"
#import "MSArtboardGroup.h"
#import "MMLayerProperties.h"
#import "MMValuesStack.h"


@interface MMConfigureViewController ()

@property (weak) IBOutlet NSComboBox *artboardsComboBox;
@property (weak) IBOutlet NSComboBox *imageQualityComboBox;
@property (weak) IBOutlet NSButton *jumpButton;
@property (weak) IBOutlet NSButton *cancelButton;
@property (weak) IBOutlet NSButton *clearButton;
@property (weak) IBOutlet NSButton *applyButton;
@property (weak) IBOutlet NSSegmentedControl *actionSegmentedControl;

@property (copy) NSNumber *imageQuality;
@property (copy) NSString *artboard;

@end

@interface MMConfigureViewController (DataSource) <NSComboBoxDataSource>

@end

@implementation MMConfigureViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    __weak __typeof (self) weakSelf = self;

    [[NSNotificationCenter defaultCenter] addObserverForName:NSComboBoxSelectionDidChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {

                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               [weakSelf apply];
                                                           });
                                                       }];
    // Do view setup here.
//    [self reloadData];
}

- (void)reloadArtboardCombobox {
    NSDictionary *lookup = [self.magicmirror artboardsLookup];
    MMValuesStack *stack = [[MMValuesStack alloc] init];

    [self.magicmirror.selectedLayers enumerateObjectsUsingBlock:^(id <MSShapeGroup> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MMLog(@"%lu: %@", idx, obj);

        MMLayerProperties *properties = [self.magicmirror layerPropertiesForLayer:obj];
        NSString *artboardName = [properties source];
        if (lookup[artboardName]) {
            [stack addObject:artboardName];
        }
    }];

    NSComboBox *combobox = self.artboardsComboBox;
    NSTextFieldCell *cell = (NSTextFieldCell *)combobox.cell;

    switch ([stack result]) {
        case MMValuesStackResultEmpty:
        case MMValuesStackResultUnspecified:
            [cell setTitle:@""];
            [cell setPlaceholderString:@"Select an artboard"];
            break;
        case MMValuesStackResultSingular: {
            id object = [stack anyObject];
            [cell setTitle:object];
            break;
        }
        case MMValuesStackResultMultiple:
            [cell setTitle:@""];
            [cell setPlaceholderString:@"multiple values"];
            break;
    }
    [combobox reloadData];
}

- (void)reloadImageQualityCombobox {
    MMValuesStack *stack = [[MMValuesStack alloc] init];

    [self.magicmirror.selectedLayers enumerateObjectsUsingBlock:^(id <MSShapeGroup> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MMLog(@"%lu: %@", idx, obj);

        MMLayerProperties *properties = [self.magicmirror layerPropertiesForLayer:obj];
        NSNumber *imageQuality = [properties imageQuality];
        if (imageQuality) {
            [stack addObject:imageQuality];
        }
    }];

    NSComboBox *combobox = self.imageQualityComboBox;
    NSTextFieldCell *cell = (NSTextFieldCell *)combobox.cell;

    NSLog(@"stack count: %lu", [stack count]);
    switch ([stack result]) {
        case MMValuesStackResultEmpty:
        case MMValuesStackResultUnspecified:
            [cell setTitle:@""];
            [cell setPlaceholderString:@"Default (Auto)"];
            break;
        case MMValuesStackResultSingular: {
            id object = [stack anyObject];
            NSUInteger index = [object integerValue];
            if (index < [combobox numberOfItems]) {
                [combobox selectItemAtIndex:index];
            }
            break;
        }
        case MMValuesStackResultMultiple:
            [cell setTitle:@""];
            [cell setPlaceholderString:@"multiple values"];
            break;
    }
    [combobox reloadData];
}

- (void)reloadData {
    [self reloadArtboardCombobox];
    [self reloadImageQualityCombobox];
}

#pragma mark IBAction

- (void)apply {
    self.artboard = self.artboardsComboBox.cell.title;
    self.imageQuality = @([self.imageQualityComboBox indexOfSelectedItem]);
    [self.magicmirror applySource:self.artboard imageQuality:self.imageQuality];
}

- (IBAction)applyButtonDidPress:(id)sender {
    [self apply];
}

- (IBAction)clearButtonDidPress:(id)sender {
    __weak typeof (self) weakSelf = self;
    [self.magicmirror.selectedLayers enumerateObjectsUsingBlock:^(id <MSShapeGroup> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf.magicmirror clearPropertiesForLayer:obj];
    }];
    [self reloadData];
}

- (IBAction)jumpButtonDidPress:(id)sender {
    id <MSShapeGroup> layer = [self.magicmirror.selectedLayers firstObject];

    NSString *source = [self.magicmirror sourceForLayer:layer];
    [self.magicmirror jumpToArtboard:source];
}

- (IBAction)actionSegmentValueDidChange:(NSSegmentedControl *)sender {
    switch (sender.selectedSegment) {
        case 0:
            [self flipButtonDidPress:sender];
            break;
        default:
            [self rotateButtonDidPress:sender];
            break;
    }
}

- (IBAction)flipButtonDidPress:(id)sender {
    MMLog(@"flipButtonDidPress");
    [self.magicmirror flipSelection];
}

- (IBAction)rotateButtonDidPress:(id)sender {
    MMLog(@"rotateButtonDidPress");
    [self.magicmirror rotateSelection];
}

@end


@implementation MMConfigureViewController (NSComboBoxDataSource)

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
    return [self.magicmirror.artboards count];
}

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index {
    return [self.magicmirror.artboards[index] name];
}


- (NSUInteger)comboBox:(NSComboBox *)aComboBox indexOfItemWithStringValue:(NSString *)string {
    return [self.magicmirror.artboards indexOfObject:string];
}

@end
