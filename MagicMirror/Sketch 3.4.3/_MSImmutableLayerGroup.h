//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "MSImmutableStyledLayer.h"

@class MSImmutableArray, NSString;

@interface _MSImmutableLayerGroup : MSImmutableStyledLayer
{
    BOOL _hasClickThrough;
    MSImmutableArray *_layers;
    NSString *_sharedObjectID;
}


- (void)decodePropertiesWithCoder:(id)arg1;
- (void)encodePropertiesWithCoder:(id)arg1;
- (void)enumerateChildProperties:(CDUnknownBlockType)arg1;
- (void)enumerateProperties:(CDUnknownBlockType)arg1;
@property(nonatomic) BOOL hasClickThrough; // @synthesize hasClickThrough=_hasClickThrough;
- (BOOL)hasDefaultValues;
- (id)initWithMutableModelObject:(id)arg1;
@property(retain, nonatomic) MSImmutableArray *layers; // @synthesize layers=_layers;
@property(retain, nonatomic) NSString *sharedObjectID; // @synthesize sharedObjectID=_sharedObjectID;

@end

