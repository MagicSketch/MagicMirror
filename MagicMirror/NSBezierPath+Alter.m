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

@interface NSBezierPath (Private)

- (NSPoint)pointAtIndex:(NSUInteger)index;

@end

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

- (BOOL)isClockwise {
    return ! [self direction];
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

- (NSBezierPath *)clockwisePoints {
    NSPoint point0 = [self pointAtIndex:0];
    NSPoint point1 = [self pointAtIndex:1];
    NSPoint point2 = [self pointAtIndex:2];
    NSPoint point3 = [self pointAtIndex:3];
    NSPoint array[4];

    array[0] = point3;
    array[1] = point0;
    array[2] = point1;
    array[3] = point2;

    NSBezierPath *newPath = [NSBezierPath fromPoints:array
                                               count:4
                                           closePath:[self isClosed]];
    return newPath;
}

- (NSBezierPath *)antiClockwisePoints {

    NSPoint point0 = [self pointAtIndex:0];
    NSPoint point1 = [self pointAtIndex:1];
    NSPoint point2 = [self pointAtIndex:2];
    NSPoint point3 = [self pointAtIndex:3];
    NSPoint array[4];

    array[0] = point1;
    array[1] = point2;
    array[2] = point3;
    array[3] = point0;

    NSBezierPath *newPath = [NSBezierPath fromPoints:array
                                               count:4
                                           closePath:[self isClosed]];
    return newPath;
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
