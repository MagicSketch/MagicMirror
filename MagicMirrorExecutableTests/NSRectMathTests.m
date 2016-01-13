//
//  NSRectMathTests.m
//  MagicMirror2
//
//  Created by James Tang on 12/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreGraphics/CoreGraphics.h>
#import "NSRect+Math.h"


#define XCTAssertEqualPoint(point1, point2) XCTAssertEqualObjects(NSStringFromPoint(point1), NSStringFromPoint(point2))
#define XCTAssertEqualSize(size1, size2) XCTAssertEqualObjects(NSStringFromSize(size1), NSStringFromSize(size2))

@interface NSRectMathTests : XCTestCase

@end

@implementation NSRectMathTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAspectFit {
    CGRect outside = CGRectMake(0, 0, 9, 9);
    CGSize size = CGSizeMake(3, 1);

    CGRect rect = CGRectAspectFittingSize(outside, size);

    XCTAssertEqualPoint(rect.origin, CGPointMake(0, 3));
    XCTAssertEqualSize(rect.size, CGSizeMake(9, 3));
}

- (void)testAspectFitVertical {
    CGRect outside = CGRectMake(0, 0, 9, 9);
    CGSize size = CGSizeMake(1, 3);

    CGRect rect = CGRectAspectFittingSize(outside, size);

    XCTAssertEqualPoint(rect.origin, CGPointMake(3, 0));
    XCTAssertEqualSize(rect.size, CGSizeMake(3, 9));
}

@end
