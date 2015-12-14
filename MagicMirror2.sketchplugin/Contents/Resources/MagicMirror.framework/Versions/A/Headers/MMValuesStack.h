//
//  MMValuesStack.h
//  MagicMirror2
//
//  Created by James Tang on 12/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MMValuesStackResultEmpty,
    MMValuesStackResultUnspecified,
    MMValuesStackResultSingular,
    MMValuesStackResultMultiple,
} MMValuesStackResult;


@interface MMValuesStack : NSObject

- (void)addObject:(id)object;
- (id)anyObject;
- (NSUInteger)count;
- (MMValuesStackResult)result;
+ (id)unspecifiedItem;

@end
