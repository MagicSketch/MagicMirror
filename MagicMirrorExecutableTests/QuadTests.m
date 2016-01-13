//
//  QuadTests.m
//  MagicMirror2
//
//  Created by James Tang on 9/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Quad.h"
#import "MMTestHelper.h"

@interface QuadTests : XCTestCase

@end


@implementation QuadTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTransform {
    Quad *quad = [Quad quadWithTopLeft:CGPointMake(1, 0)
                              topRight:CGPointMake(10, 1)
                            bottomLeft:CGPointMake(1, 9)
                           bottomRight:CGPointMake(9, 10)];

    Quad *newQuad = [quad scaledQuad:3];
    XCTAssertEqualPoint(newQuad.tl, CGPointMake(3, 0));
    XCTAssertEqualPoint(newQuad.tr, CGPointMake(30, 3));
    XCTAssertEqualPoint(newQuad.bl, CGPointMake(3, 27));
    XCTAssertEqualPoint(newQuad.br, CGPointMake(27, 30));
}


@end
