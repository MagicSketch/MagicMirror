//
//  NSBezierPath+Alter.m
//  MagicMirror2
//
//  Created by James Tang on 15/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "NSBezierPath+Alter.h"
#import "NSBezierPath-Clockwise.h"
#import "NSBezierPath-NSPrivate.h"
#import "MagicMirror.h"

@implementation NSBezierPath (Alter)

- (BOOL)isClosed {
    NSBezierPath *originalPath = self;
    NSBezierPath *flatPath = [originalPath bezierPathByFlatteningPath];
    NSInteger count = [flatPath elementCount];
    NSPoint prev, curr;
    NSInteger i;
    BOOL isClosed = NO;
    for(i = 0; i < count; ++i) {
        // Since we are using a flattened path, no element will contain more than one point
        NSBezierPathElement type = [flatPath elementAtIndex:i associatedPoints:&curr];
        if(type == NSLineToBezierPathElement) {
            NSLog(@"Line from %@ to %@",NSStringFromPoint(prev),NSStringFromPoint(curr));
        } else if(type == NSClosePathBezierPathElement) {
            // Get the first point in the path as the line's end. The first element in a path is a move to operation
            [flatPath elementAtIndex:0 associatedPoints:&curr];
            NSLog(@"Close line from %@ to %@",NSStringFromPoint(prev),NSStringFromPoint(curr));

            isClosed = YES;
            break;
        } else if(type == NSMoveToBezierPathElement) {
            // Get the first point in the path as the line's end. The first element in a path is a move to operation
            [flatPath elementAtIndex:0 associatedPoints:&curr];
            NSLog(@"Move line from %@ to %@",NSStringFromPoint(prev),NSStringFromPoint(curr));
        }
    }
    return isClosed;
}

+ (NSBezierPath *)bezierPathWithArray:(NSArray *)points closePath:(BOOL)closePath {
    NSUInteger count = [points count];
    NSPoint array[10];
    for (NSUInteger i = 0; i < count; i++) {
        array[i] = NSPointFromString(points[i]);
    }
    return [self fromPoints:array count:count closePath:closePath];
}

+ (NSBezierPath *)fromPoints:(NSPointArray)points count:(NSInteger)count {
    return [self fromPoints:points count:count closePath:YES];
}

+ (NSBezierPath *)fromPoints:(NSPointArray)points count:(NSInteger)count closePath:(BOOL)closePath {
    NSBezierPath *newPath = [NSBezierPath bezierPath];
    [newPath appendBezierPathWithPoints:points count:count];
    if (closePath) {
        [newPath closePath];
    }
    return newPath;
}

- (BOOL)isClockwiseOSX {
    return [self isClockwiseFlippedCoordinates:NO];
}

- (BOOL)isClockwise {
    return [self isClockwiseFlippedCoordinates:YES];
}

- (CGFloat)edgesLengthPoint1:(NSPoint)point1 point2:(NSPoint)point2 {
    return (point2.x - point1.x) * (point2.y + point1.y);
}

- (CGFloat)sumPoints:(NSArray *)array {

    CGFloat value = 0;
    for (NSUInteger i = 0; i < [array count]; i++) {
        NSPoint point1;
        NSPoint point2;
        if (i == [array count] - 1) {
            point1 = NSPointFromString(array[i]);
            point2 = NSPointFromString(array[0]);
        } else {
            point1 = NSPointFromString(array[i]);
            point2 = NSPointFromString(array[i + 1]);
        }

        value += [self edgesLengthPoint1:point1 point2:point2];
    }
    return value;
}

- (BOOL)isClockwiseFlippedCoordinates:(BOOL)flippedCoordinates {
    BOOL isClockwised = [self sumPoints:[self points]] > 0;
    if (flippedCoordinates) {
        return ! isClockwised;
    }
    return isClockwised;
}

- (NSBezierPath *)flipPoints {
    NSAffineTransform *transform = [NSAffineTransform transform];
    [transform translateXBy:CGRectGetMidX([self bounds]) yBy:0];
    [transform scaleXBy:-1 yBy:1];
    [transform translateXBy:-CGRectGetMidX([self bounds]) yBy:0];
    return [transform transformBezierPath:self];
}

- (NSBezierPath *)flipShiftX {
    MMLog(@"[self elementCount] %lu", [self elementCount]);
    NSBezierPath *path = [self flipPoints];

    MMLog(@"[path elementCount] %lu", [path elementCount]);
    return path;
}

- (NSBezierPath *)putFirstToLast {
    NSArray *points = [self points];

    NSMutableArray *clockwisedPoints = [points mutableCopy];
    [clockwisedPoints insertObject:clockwisedPoints[0] atIndex:[points count]];
    [clockwisedPoints removeObjectAtIndex:0];
    return [[self class] bezierPathWithArray:[clockwisedPoints copy]closePath:[self isClosed]];
}

- (NSBezierPath *)putLastToFirst {
    NSArray *points = [self points];
    NSMutableArray *mutablePoints = [points mutableCopy];
    [mutablePoints insertObject:[mutablePoints lastObject] atIndex:0];
    [mutablePoints removeLastObject];
    return [[self class] bezierPathWithArray:[mutablePoints copy] closePath:[self isClosed]];
}

- (NSBezierPath *)clockwisePoints {
    if (self.isClockwise) {
        return [self putFirstToLast];
    } else {
        return [self putLastToFirst];
    }
}

- (NSBezierPath *)antiClockwisePoints {
    if (self.isClockwise) {
        return [self putLastToFirst];
    } else {
        return [self putFirstToLast];
    }
}

- (NSUInteger)count {
    return [[self points] count];
}

- (NSArray *)points {
    NSBezierPath *originalPath = self;
    NSBezierPath *flatPath = [originalPath bezierPathByFlatteningPath];
    NSInteger count = [flatPath elementCount];
    NSPoint prev, curr;
    NSInteger i;
    NSMutableArray *points = [NSMutableArray array];
    for(i = 0; i < count; ++i) {
        // Since we are using a flattened path, no element will contain more than one point
        NSBezierPathElement type = [flatPath elementAtIndex:i associatedPoints:&curr];
        if(type == NSLineToBezierPathElement) {
            NSLog(@"Line from %@ to %@",NSStringFromPoint(prev),NSStringFromPoint(curr));
            [points addObject:NSStringFromPoint(curr)];
            prev = curr;
        } else if(type == NSClosePathBezierPathElement) {
            // Get the first point in the path as the line's end. The first element in a path is a move to operation
            [flatPath elementAtIndex:0 associatedPoints:&curr];
            NSLog(@"Close line from %@ to %@",NSStringFromPoint(prev),NSStringFromPoint(curr));
            break;
        } else if(type == NSMoveToBezierPathElement) {
            // Get the first point in the path as the line's end. The first element in a path is a move to operation
            [flatPath elementAtIndex:0 associatedPoints:&curr];
            [points addObject:NSStringFromPoint(curr)];

            NSLog(@"Move line from %@ to %@",NSStringFromPoint(prev),NSStringFromPoint(curr));
            prev = curr;
        }
    }
    return points;
}

@end
