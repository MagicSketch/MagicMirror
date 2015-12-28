//
//  MMArtboardComboboxItem.h
//  MagicMirror2
//
//  Created by James Tang on 28/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol MSArtboardGroup;


@interface MMArtboardComboboxItem : NSObject

@property (copy, readonly) NSString *title;
@property (weak, readonly) id <MSArtboardGroup> artboard;

+ (instancetype)itemWithArtboard:(id <MSArtboardGroup>)artboard;
+ (instancetype)nullItem;

@end
