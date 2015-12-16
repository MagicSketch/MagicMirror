//
//  NSBezierPathTests.m
//  MagicMirror2
//
//  Created by James Tang on 16/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSBezierPath+Alter.h"

@interface NSBezierPathTests : XCTestCase

@property (nonatomic) NSPointArray array;
@property (nonatomic, strong) NSBezierPath *closed;
@property (nonatomic, strong) NSBezierPath *open;

@end

@implementation NSBezierPathTests

- (void)setUp {
    [super setUp];

    NSPoint array[5];
    array[0] = NSPointFromCGPoint(CGPointMake(20, 0));
    array[1] = NSPointFromCGPoint(CGPointMake(100, 20));
    array[2] = NSPointFromCGPoint(CGPointMake(80, 100));
    array[3] = NSPointFromCGPoint(CGPointMake(0, 80));
    array[4] = NSPointFromCGPoint(CGPointMake(0, 40));
    _array = array;
    _closed = [NSBezierPath fromPoints:array count:4];
    _open = [NSBezierPath fromPoints:array count:5 closePath:NO];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testElementsCount {
    XCTAssertEqual([_closed elementCount], 6);
    XCTAssertEqual([_open elementCount], 5);
}

- (void)testFlipped {
    NSBezierPath *closedFlipped = [_closed flipPoints];
    NSArray *points = [closedFlipped points];
    XCTAssertEqualObjects(points[0], @"{80, 0}");
    XCTAssertEqualObjects(points[1], @"{0, 20}");
    XCTAssertEqualObjects(points[2], @"{20, 100}");
    XCTAssertEqualObjects(points[3], @"{100, 80}");

    NSBezierPath *openPath = [_open flipPoints];
    NSArray *openPoints = [openPath points];
    XCTAssertEqualObjects(openPoints[0], @"{80, 0}");
    XCTAssertEqualObjects(openPoints[1], @"{0, 20}");
    XCTAssertEqualObjects(openPoints[2], @"{20, 100}");
    XCTAssertEqualObjects(openPoints[3], @"{100, 80}");
    XCTAssertEqualObjects(openPoints[4], @"{100, 40}");
}

- (void)testCount {
    XCTAssertEqual([_closed count], 4);
    XCTAssertEqual([_open count], 5);
}

- (void)testIsClosed {
    XCTAssertEqual([_closed isClosed], YES);
    XCTAssertEqual([_open isClosed], NO);
}

- (void)testPoints {
    NSArray *openPoints = [_open points];

    XCTAssertEqualObjects(openPoints[0], @"{20, 0}");
    XCTAssertEqualObjects(openPoints[1], @"{100, 20}");
    XCTAssertEqualObjects(openPoints[2], @"{80, 100}");
    XCTAssertEqualObjects(openPoints[3], @"{0, 80}");
    XCTAssertEqualObjects(openPoints[4], @"{0, 40}");

    NSArray *closedPoints = [_closed points];

    XCTAssertEqualObjects(closedPoints[0], @"{20, 0}");
    XCTAssertEqualObjects(closedPoints[1], @"{100, 20}");
    XCTAssertEqualObjects(closedPoints[2], @"{80, 100}");
    XCTAssertEqualObjects(closedPoints[3], @"{0, 80}");
}

- (void)testClockwiseDetermine {
    XCTAssertEqual([_open isClockwiseOSX], NO);
    XCTAssertEqual([_open isClockwise], YES);
    XCTAssertEqual([_closed isClockwiseOSX], NO);
    XCTAssertEqual([_closed isClockwise], YES);
}

- (void)testClockwise {
    NSBezierPath *path = [_open clockwisePoints];

    NSArray *points = [path points];
    XCTAssertEqualObjects(points[0], @"{100, 20}");
    XCTAssertEqualObjects(points[1], @"{80, 100}");
    XCTAssertEqualObjects(points[2], @"{0, 80}");
    XCTAssertEqualObjects(points[3], @"{0, 40}");
    XCTAssertEqualObjects(points[4], @"{20, 0}");

    XCTAssertEqual([path isClosed], NO);
    XCTAssertEqual([path count], 5);
}

- (void)testAntiClockwise {
    NSBezierPath *path = [_open antiClockwisePoints];

    NSArray *points = [path points];
    XCTAssertEqualObjects(points[0], @"{0, 40}");
    XCTAssertEqualObjects(points[1], @"{20, 0}");
    XCTAssertEqualObjects(points[2], @"{100, 20}");
    XCTAssertEqualObjects(points[3], @"{80, 100}");
    XCTAssertEqualObjects(points[4], @"{0, 80}");

    XCTAssertEqual([path isClosed], NO);
    XCTAssertEqual([path count], 5);
}

- (void)testClockwiseClosed {
    NSBezierPath *path = [_closed clockwisePoints];

    NSArray *points = [path points];
    XCTAssertEqualObjects(points[0], @"{100, 20}");
    XCTAssertEqualObjects(points[1], @"{80, 100}");
    XCTAssertEqualObjects(points[2], @"{0, 80}");
    XCTAssertEqualObjects(points[3], @"{20, 0}");

    XCTAssertEqual([path isClosed], YES);
    XCTAssertEqual([path count], 4);
}

- (void)testAntiClockwiseClosed {
    NSBezierPath *path = [_closed antiClockwisePoints];

    NSArray *points = [path points];
    XCTAssertEqualObjects(points[0], @"{0, 80}");
    XCTAssertEqualObjects(points[1], @"{20, 0}");
    XCTAssertEqualObjects(points[2], @"{100, 20}");
    XCTAssertEqualObjects(points[3], @"{80, 100}");

    XCTAssertEqual([path isClosed], YES);
    XCTAssertEqual([path count], 4);
}

- (void)testReversePath {
    NSBezierPath *reversePath = [_open reversePath];

    NSArray *openPoints = [reversePath points];
    XCTAssertEqualObjects(openPoints[4], @"{20, 0}");
    XCTAssertEqualObjects(openPoints[3], @"{100, 20}");
    XCTAssertEqualObjects(openPoints[2], @"{80, 100}");
    XCTAssertEqualObjects(openPoints[1], @"{0, 80}");
    XCTAssertEqualObjects(openPoints[0], @"{0, 40}");
}

@end
