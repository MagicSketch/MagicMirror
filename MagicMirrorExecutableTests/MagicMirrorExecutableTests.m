//
//  MagicMirrorExecutableTests.m
//  MagicMirrorExecutableTests
//
//  Created by James Tang on 12/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MagicMirror.h"

@interface MagicMirrorExecutableTests : XCTestCase

@end

@implementation MagicMirrorExecutableTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUnspecified {

    NSMutableSet *set = [NSMutableSet set];
    [set addObject:[NSNull null]];
    [set addObject:[NSNull null]];
    [set addObject:[NSNull null]];

    XCTAssertEqual([set count], 1);
}

- (void)testMultipleValues {

    NSMutableSet *set = [NSMutableSet set];
    [set addObject:[NSNull null]];
    [set addObject:@1];
    [set addObject:@2];

    XCTAssertEqual([set count], 3);
}

- (void)testSelectedValue {

    NSMutableSet *set = [NSMutableSet set];
    [set addObject:@1];
    [set addObject:@1];
    [set addObject:@1];

    XCTAssertEqual([set count], 1);
}

- (void)testKeepAround {
    MagicMirror *mirror = [MagicMirror sharedInstance];
    XCTAssertEqual([mirror lifeCount], 0);
    [mirror keepAround];
    XCTAssertEqual([mirror lifeCount], 1);
    [mirror keepAround];
    XCTAssertEqual([mirror lifeCount], 2);
    [mirror goAway];
    XCTAssertEqual([mirror lifeCount], 1);
    [mirror goAway];
    XCTAssertEqual([mirror lifeCount], 0);
}

@end
