//
//  MMConfigureViewController.m
//  MagicMirror2
//
//  Created by James Tang on 11/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "MMToolbarViewController.h"
#import "MSShapeGroup.h"
#import "MagicMirror.h"
#import "MSArtboardGroup.h"
#import "MMLayerProperties.h"
#import "MMValuesStack.h"
#import "MMArtboardComboboxItem.h"
#import "SketchEventsController.h"

@interface MMToolbarViewController ()

@property (weak) IBOutlet NSComboBox *artboardsComboBox;
@property (weak) IBOutlet NSComboBox *imageQualityComboBox;
@property (weak) IBOutlet NSButton *jumpButton;
@property (weak) IBOutlet NSButton *closeButton;
@property (weak) IBOutlet NSButton *applyButton;
@property (weak) IBOutlet NSButtonCell *refreshButton;
@property (weak) IBOutlet NSSegmentedControl *actionSegmentedControl;

@property (copy) NSNumber *imageQuality;
@property (copy) id <MSArtboardGroup> artboard;
@property (copy) NSArray <MMArtboardComboboxItem *> *artboardItems;

@end

@interface MMToolbarViewController (DataSource) <NSComboBoxDataSource>

@end

@implementation MMToolbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldObserveCombobox = YES;
}

- (void)reloadArtboardCombobox {
    NSDictionary *lookup = [self.magicmirror artboardsLookup];
    MMValuesStack *stack = [[MMValuesStack alloc] init];

    NSMutableArray *artboardItems = [NSMutableArray array];
    [artboardItems addObject:[MMArtboardComboboxItem nullItem]];

    [lookup enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [artboardItems addObject:[MMArtboardComboboxItem itemWithArtboard:obj]];
    }];

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

    self.artboardItems = [artboardItems copy];
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

- (NSResponder *)nextResponder {
    return self.parentViewController;
}

#pragma mark IBAction

- (void)comboBoxValueDidChange:(NSComboBox *)sender {
    if (sender == self.artboardsComboBox) {
        NSInteger index = [self.artboardsComboBox indexOfSelectedItem];
        if (index >= 0 && index < [self.artboardItems count]) {
            MMArtboardComboboxItem *item = self.artboardItems[index];
            self.artboard = item.artboard;
        } else {
            self.artboard = nil;
        }
        if (self.artboard) {
            [self.magicmirror setArtboard:self.artboard];
        } else {
            [self.magicmirror setClear];
        }
        [self reloadData];
    } else if (sender == self.imageQualityComboBox) {
        self.imageQuality = @([self.imageQualityComboBox indexOfSelectedItem]);
        [self.magicmirror setImageQuality:self.imageQuality];
    }
}

- (IBAction)clearButtonDidPress:(id)sender {
    [self.magicmirror setClear];
    [self reloadData];
}

- (IBAction)jumpButtonDidPress:(id)sender {
    [self.magicmirror jumpSelection];
    [self reloadData];
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

- (IBAction)refreshButtonDidPress:(id)sender {
    [self.magicmirror refreshSelection];
}

@end


@implementation MMToolbarViewController (NSComboBoxDataSource)

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
    return [self.artboardItems count];
}

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index {
    return [self.artboardItems[index] title];
}

- (NSUInteger)comboBox:(NSComboBox *)aComboBox indexOfItemWithStringValue:(NSString *)string {
    return [[self.artboardItems valueForKey:@"title"] indexOfObject:string];
}

@end

@implementation MMToolbarViewController (Sketch)

- (void)layerSelectionDidChange:(NSArray *)layers {
    [self reloadData];
}

@end
