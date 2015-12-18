//
//  MagicMirrorTests.m
//  MagicMirror2
//
//  Created by James Tang on 15/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MagicMirror.h"
#import "Math.h"

@interface MathTests : XCTestCase

@property (nonatomic, strong) MagicMirror *magicmirror;

@end

@implementation MathTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.

    _magicmirror = [[MagicMirror alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRectPorportion {
    CGSize size1 = CGSizeMake(1, 1);
    CGSize size2 = CGSizeMake(2, 3);

    XCTAssertEqual(CGSizeAspectFillRatio(size1, size2), 3);
    XCTAssertEqual(CGSizeAspectFillRatio(size2, size1), 1.f/2.f);
}

@end
