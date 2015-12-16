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

@end
