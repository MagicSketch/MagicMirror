//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "NSObject.h"

@class FBBezierContour, NSMutableArray;

@interface FBContourOverlap : NSObject
{
    NSMutableArray *_runs;
}

+ (id)contourOverlap;

- (void)addOverlap:(id)arg1 forEdge1:(id)arg2 edge2:(id)arg3;
@property(readonly, nonatomic) FBBezierContour *contour1;
@property(readonly, nonatomic) FBBezierContour *contour2;
- (id)description;
- (BOOL)doesContainCrossing:(id)arg1;
- (BOOL)doesContainParameter:(double)arg1 onEdge:(id)arg2;
- (BOOL)isBetweenContour:(id)arg1 andContour:(id)arg2;
- (BOOL)isComplete;
- (BOOL)isEmpty;
- (void)reset;
- (void)runsWithBlock:(CDUnknownBlockType)arg1;
@property(readonly, nonatomic) NSMutableArray *runs_;

@end

