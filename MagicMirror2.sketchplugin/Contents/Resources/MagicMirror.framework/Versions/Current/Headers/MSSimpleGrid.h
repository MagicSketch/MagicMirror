//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "_MSSimpleGrid.h"

@class NSColor;

@interface MSSimpleGrid : _MSSimpleGrid
{
    NSColor *lightColor;
    NSColor *darkColor;
    double zoom;
}


- (void)drawHorizontalLine:(id)arg1 atY:(double)arg2;
- (void)drawHorizontalLinesInRect:(struct CGRect)arg1 baseY:(double)arg2;
- (void)drawInRect:(struct CGRect)arg1 baseLine:(struct CGPoint)arg2 atZoom:(double)arg3;
- (void)drawVerticalLine:(id)arg1 atX:(double)arg2;
- (void)drawVerticalLinesInRect:(struct CGRect)arg1 baseX:(double)arg2;
- (void)from:(double)arg1 doWhile:(CDUnknownBlockType)arg2 incrementBy:(double)arg3 run:(CDUnknownBlockType)arg4;
- (id)horizontalGuidesForRulerData:(id)arg1 inRect:(struct CGRect)arg2;
- (id)verticalGuidesForRulerData:(id)arg1 inRect:(struct CGRect)arg2;

@end

