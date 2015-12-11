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


@interface MMConfigureViewController ()

@property (weak) IBOutlet NSComboBox *artboardsComboBox;
@property (weak) IBOutlet NSComboBox *imageQualityComboBox;
@property (weak) IBOutlet NSButton *cancelButton;
@property (weak) IBOutlet NSButton *clearButton;
@property (weak) IBOutlet NSButton *applyButton;

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

    [self reloadData];
}

- (void)setMagicmirror:(MagicMirror *)magicmirror {
    if (_magicmirror != magicmirror) {
        _magicmirror = magicmirror;
        [self reloadData];
    }
}


- (void)reloadArtboardCombobox {
    __block NSString *selectedName = [[_magicmirror.selectedLayers firstObject] name];
    NSDictionary *lookup = [_magicmirror artboardsLookup];

    [_magicmirror.selectedLayers enumerateObjectsUsingBlock:^(id <MSShapeGroup> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MMLog(@"%lu: %@", idx, obj);

        NSString *artboardName = [obj name];

        id <MSArtboardGroup> artboard = lookup[artboardName];
        if (artboard && ! [selectedName isEqualToString:artboardName]) {
            selectedName = nil;
        }
    }];

    [self.artboardsComboBox.cell setTitle:selectedName ?: @""];
    if ( ! selectedName) {
        [(NSTextFieldCell *)self.artboardsComboBox.cell setPlaceholderString:@"multiple values"];
    }

    [self.artboardsComboBox reloadData];
}

- (void)reloadImageQualityCombobox {
//    __block NSNumber *imageQuality = nil;
//    NSDictionary *lookup = [_magicmirror artboardsLookup];
//
//    [_magicmirror.selectedLayers enumerateObjectsUsingBlock:^(id <MSShapeGroup> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        MMLog(@"%lu: %@", idx, obj);
//
//        MMLayerProperties *properties = [_magicmirror layerPropertiesForLayer:obj];
//        NSNumber *quality = [properties imageQuality];
//
//        id <MSArtboardGroup> artboard = lookup[artboardName];
//        if (artboard && ! [quality isEqualToNumber:imageQuality]) {
//            imageQuality = nil;
//        }
//    }];
//
//    [self.artboardsComboBox.cell setTitle:imageQuality ?: @""];
//    if ( ! imageQuality) {
//        [(NSTextFieldCell *)self.artboardsComboBox.cell setPlaceholderString:@"multiple values"];
//    }
//
//    [self.artboardsComboBox reloadData];
//
}

- (void)reloadData {
    [self reloadArtboardCombobox];
}

#pragma mark IBAction

- (IBAction)applyButtonDidPress:(id)sender {
    NSString *selectedName = self.artboardsComboBox.cell.title;
    if (selectedName) {

        NSInteger index = [_imageQualityComboBox indexOfSelectedItem];
        NSNumber *imageQuality = @(index);

        [_magicmirror.selectedLayers enumerateObjectsUsingBlock:^(id <MSShapeGroup> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MMLayerProperties *properties = [MMLayerProperties propertiesWithImageQuality:imageQuality
                                                                                   source:selectedName];
            [_magicmirror layer:obj setProperties:properties];
        }];
    }
}

- (IBAction)clearButtonDidPress:(id)sender {

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
