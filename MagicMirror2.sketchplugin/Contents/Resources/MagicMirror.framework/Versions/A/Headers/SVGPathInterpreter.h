//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "NSObject.h"

@interface SVGPathInterpreter : NSObject
{
    BOOL _lastCommand;
    struct CGPoint _lastPoint;
    struct CGPoint _lastControl;
}

+ (id)bezierPathFromCommands:(id)arg1 isPathClosed:(char *)arg2;
+ (id)bezierPathFromPoints:(id)arg1;
- (void)appendAComponents:(id)arg1 toBezierPath:(id)arg2;
- (void)appendCComponents:(id)arg1 toBezierPath:(id)arg2;
- (void)appendCurveQuadPoint1:(struct CGPoint)arg1 quadPoint2:(struct CGPoint)arg2 toBezierPath:(id)arg3;
- (void)appendHComponents:(id)arg1 toBezierPath:(id)arg2;
- (void)appendLComponents:(id)arg1 toBezierPath:(id)arg2;
- (void)appendMComponents:(id)arg1 toBezierPath:(id)arg2;
- (void)appendQComponents:(id)arg1 toBezierPath:(id)arg2;
- (void)appendSComponents:(id)arg1 toBezierPath:(id)arg2;
- (void)appendTComponents:(id)arg1 toBezierPath:(id)arg2;
- (void)appendVComponents:(id)arg1 toBezierPath:(id)arg2;
- (void)appendaComponents:(id)arg1 toBezierPath:(id)arg2;
- (void)appendcComponents:(id)arg1 toBezierPath:(id)arg2;
- (void)appendhComponents:(id)arg1 toBezierPath:(id)arg2;
- (void)appendlComponents:(id)arg1 toBezierPath:(id)arg2;
- (void)appendmComponents:(id)arg1 toBezierPath:(id)arg2;
- (void)appendqComponents:(id)arg1 toBezierPath:(id)arg2;
- (void)appendsComponents:(id)arg1 toBezierPath:(id)arg2;
- (void)appendtComponents:(id)arg1 toBezierPath:(id)arg2;
- (void)appendvComponents:(id)arg1 toBezierPath:(id)arg2;
- (id)bezierPathFromCommands:(id)arg1 isPathClosed:(char *)arg2;
- (id)bezierPathFromPoints:(id)arg1;
@property(nonatomic) BOOL lastCommand; // @synthesize lastCommand=_lastCommand;
@property(nonatomic) struct CGPoint lastControl; // @synthesize lastControl=_lastControl;
- (struct CGPoint)lastControlReflected;
@property(nonatomic) struct CGPoint lastPoint; // @synthesize lastPoint=_lastPoint;

@end

