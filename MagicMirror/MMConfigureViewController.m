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
@property (weak) IBOutlet NSButton *cancelButton;
@property (weak) IBOutlet NSButton *clearButton;
@property (weak) IBOutlet NSButton *applyButton;
@property (weak) IBOutlet NSSegmentedControl *actionSegmentedControl;

@property (copy) NSString *imageQuality;
@property (copy) NSString *artboard;

@end

@interface MMConfigureViewController (DataSource) <NSComboBoxDataSource>

@end

@implementation MMConfigureViewController
@synthesize magicmirror = _magicmirror;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
//    [self reloadData];
}

- (void)setMagicmirror:(MagicMirror *)magicmirror {
    if (_magicmirror != magicmirror) {
        _magicmirror = magicmirror;
        [self reloadData];
    }
}


- (void)reloadArtboardCombobox {
    NSDictionary *lookup = [_magicmirror artboardsLookup];
    MMValuesStack *stack = [[MMValuesStack alloc] init];

    [_magicmirror.selectedLayers enumerateObjectsUsingBlock:^(id <MSShapeGroup> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MMLog(@"%lu: %@", idx, obj);

        MMLayerProperties *properties = [_magicmirror layerPropertiesForLayer:obj];
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

    [_magicmirror.selectedLayers enumerateObjectsUsingBlock:^(id <MSShapeGroup> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MMLog(@"%lu: %@", idx, obj);

        MMLayerProperties *properties = [_magicmirror layerPropertiesForLayer:obj];
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

- (IBAction)applyButtonDidPress:(id)sender {


        [_magicmirror.selectedLayers enumerateObjectsUsingBlock:^(id <MSShapeGroup> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

            MMLayerProperties *original = [_magicmirror layerPropertiesForLayer:obj];
            NSString *selectedName = self.artboardsComboBox.cell.title ?: original.source;

            NSInteger index = [_imageQualityComboBox indexOfSelectedItem];

            NSNumber *imageQuality = @0;
            if (index < [_imageQualityComboBox numberOfItems]) {
                imageQuality = @(MAX(0, index));
            } else {
                imageQuality = original.imageQuality;
            }


            MMLayerProperties *properties = [MMLayerProperties propertiesWithImageQuality:imageQuality
                                                                                   source:selectedName];
            [_magicmirror setProperties:properties forLayer:obj];
        }];

        [_magicmirror mirrorPage];
}

- (IBAction)clearButtonDidPress:(id)sender {

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
}

- (IBAction)rotateButtonDidPress:(id)sender {
    MMLog(@"rotateButtonDidPress");

    [_magicmirror rotateSelection];
}

@end


@implementation MMConfigureViewController (NSComboBoxDataSource)

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
    return [_magicmirror.artboards count];
}

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index {
    return [_magicmirror.artboards[index] name];
}


- (NSUInteger)comboBox:(NSComboBox *)aComboBox indexOfItemWithStringValue:(NSString *)string {
    return [_magicmirror.artboards indexOfObject:string];
}

@end
