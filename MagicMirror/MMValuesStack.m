//
//  MMValuesStack.m
//  MagicMirror2
//
//  Created by James Tang on 12/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "MMValuesStack.h"

@interface MMValuesStack ()

@property (nonatomic, strong) NSMutableSet *set;

@end

@implementation MMValuesStack

- (instancetype)init
{
    self = [super init];
    if (self) {
        _set = [[NSMutableSet alloc] init];
    }
    return self;
}

- (id)anyObject {
    return [_set anyObject];
}

- (NSUInteger)count {
    return [_set count];
}

- (void)addObject:(id)object {
    [_set addObject:object];
}

- (MMValuesStackResult)result {
    if ([_set count] == 1) {
        if ([_set anyObject] == [[self class] unspecifiedItem]) {
            return MMValuesStackResultUnspecified;
        }
        return MMValuesStackResultSingular;
    } else if ([_set count] == 0) {
        return MMValuesStackResultEmpty;
    }
    return MMValuesStackResultMultiple;
}

+ (id)unspecifiedItem {
    return [NSNull null];
}

@end
