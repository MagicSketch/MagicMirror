//
//  NSBezierPath+Alter.h
//  MagicMirror2
//
//  Created by James Tang on 15/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSBezierPath (Alter)

+ (NSBezierPath *)bezierPathWithArray:(NSArray *)points closePath:(BOOL)closePath;
+ (NSBezierPath *)fromPoints:(NSPointArray)points count:(NSInteger)count;
+ (NSBezierPath *)fromPoints:(NSPointArray)points count:(NSInteger)count closePath:(BOOL)closePath;

- (NSBezierPath *)clockwisePoints;
- (NSBezierPath *)antiClockwisePoints;
- (NSBezierPath *)flipPoints;
- (NSBezierPath *)flipShiftX;
- (NSBezierPath *)reversePath;

- (NSUInteger)count;
- (BOOL)isClockwise;
- (BOOL)isClockwiseOSX;
- (BOOL)isClosed;
- (NSArray *)points;

@end
