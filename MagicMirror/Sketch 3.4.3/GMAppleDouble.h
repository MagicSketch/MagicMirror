//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "NSObject.h"

@class NSMutableArray;

@interface GMAppleDouble : NSObject
{
    NSMutableArray *entries_;
}

+ (id)appleDouble;
+ (id)appleDoubleWithData:(id)arg1;
+ (id)zk_appleDoubleDataForPath:(id)arg1;
+ (void)zk_restoreAppleDoubleData:(id)arg1 toPath:(id)arg2;

- (BOOL)addEntriesFromAppleDoubleData:(id)arg1;
- (void)addEntry:(id)arg1;
- (void)addEntryWithID:(int)arg1 data:(id)arg2;
- (id)data;
- (id)entries;
- (id)init;

@end

