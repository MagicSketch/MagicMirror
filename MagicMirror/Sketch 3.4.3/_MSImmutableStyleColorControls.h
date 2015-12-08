//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "MSImmutableStylePart.h"

@interface _MSImmutableStyleColorControls : MSImmutableStylePart
{
    double _brightness;
    double _contrast;
    double _hue;
    double _saturation;
}

@property(nonatomic) double brightness; // @synthesize brightness=_brightness;
@property(nonatomic) double contrast; // @synthesize contrast=_contrast;
- (void)decodePropertiesWithCoder:(id)arg1;
- (void)encodePropertiesWithCoder:(id)arg1;
- (void)enumerateChildProperties:(CDUnknownBlockType)arg1;
- (void)enumerateProperties:(CDUnknownBlockType)arg1;
- (BOOL)hasDefaultValues;
@property(nonatomic) double hue; // @synthesize hue=_hue;
- (id)initWithMutableModelObject:(id)arg1;
@property(nonatomic) double saturation; // @synthesize saturation=_saturation;

@end

