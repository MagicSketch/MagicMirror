//
//  MMArtboardComboboxItem.m
//  MagicMirror2
//
//  Created by James Tang on 28/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "MMArtboardComboboxItem.h"
#import "MSArtboardGroup.h"

@interface MMArtboardComboboxItem ()

@property (copy) NSString *title;
@property (weak) id <MSArtboardGroup> artboard;

@end


@implementation MMArtboardComboboxItem

+ (instancetype)itemWithArtboard:(id<MSArtboardGroup>)artboard {
    MMArtboardComboboxItem *item = [[self alloc] init];
    item.title = [artboard name];
    item.artboard = artboard;
    return item;
}

+ (instancetype)nullItem {
    MMArtboardComboboxItem *item = [[self alloc] init];
    item.title = @"-- None --";
    return item;
}

@end
