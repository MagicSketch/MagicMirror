//
//  QuadTests.m
//  MagicMirror2
//
//  Created by James Tang on 9/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Quad.h"

@interface QuadTests : XCTestCase

@end

#define XCTPointsEqual( point1,  point2) XCTAssertEqualObjects(NSStringFromPoint(point1), NSStringFromPoint(point2))

@implementation QuadTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)equalPoints:(NSPoint)point1 point2:(NSPoint)point2 {
    //    XCTAssertEqualObjects(NSStringFromPoint(point1), NSStringFromPoint(point2));
}

- (void)testTransform {
    Quad *quad = [Quad quadWithTopLeft:CGPointMake(1, 0)
                              topRight:CGPointMake(10, 1)
                            bottomLeft:CGPointMake(1, 9)
                           bottomRight:CGPointMake(9, 10)];

    Quad *newQuad = [quad scaledQuad:3];
    XCTPointsEqual(newQuad.tl, CGPointMake(3, 0));
    XCTPointsEqual(newQuad.tr, CGPointMake(30, 3));
    XCTPointsEqual(newQuad.bl, CGPointMake(3, 27));
    XCTPointsEqual(newQuad.br, CGPointMake(27, 30));
}


@end
