//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "_MSSharedLayerStyleContainer.h"

@interface MSSharedLayerStyleContainer : _MSSharedLayerStyleContainer
{
}

- (id)addSharedStyleWithName:(id)arg1 firstInstance:(id)arg2;
- (void)enumeratePotentialInstancesInContainer:(id)arg1 block:(CDUnknownBlockType)arg2;
- (long long)indexOfSharedStyle:(id)arg1;
- (BOOL)isSharedStyleForInstance:(id)arg1;
- (id)mergeSharedStyleWithName:(id)arg1 sharedStyleID:(id)arg2 instance:(id)arg3;
- (unsigned long long)numberOfSharedStyles;
- (void)registerInstance:(id)arg1 withSharedStyle:(id)arg2;
- (void)removeSharedStyle:(id)arg1;
- (Class)sharedObjectClass;
- (id)sharedStyleAtIndex:(unsigned long long)arg1;
- (id)sharedStyleForInstance:(id)arg1;
- (id)sharedStyleWithID:(id)arg1;
- (unsigned long long)validStyleType;

@end

