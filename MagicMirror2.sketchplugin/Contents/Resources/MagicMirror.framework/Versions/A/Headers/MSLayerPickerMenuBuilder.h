//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "MSMenuBuilder.h"

@interface MSLayerPickerMenuBuilder : MSMenuBuilder
{
}

- (void)addChildrenOfGroup:(id)arg1 underPoint:(struct CGPoint)arg2 toMenu:(id)arg3 withInset:(id)arg4;
- (void)addLayerItem:(id)arg1 toMenu:(id)arg2 withInset:(id)arg3;
- (BOOL)shouldShowSubLayersForGroupInLayerPickerMenu:(id)arg1;
- (void)updatePickerMenuItem:(id)arg1 forPage:(id)arg2 atPoint:(struct CGPoint)arg3;

@end

