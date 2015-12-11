//
//  MMValuesStackTests.m
//  MagicMirror2
//
//  Created by James Tang on 12/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MMValuesStack.h"

@interface MMValuesStackTests : XCTestCase

@property (nonatomic, strong) MMValuesStack *stack;

@end

@implementation MMValuesStackTests

- (void)setUp {
    [super setUp];

    _stack = [[MMValuesStack alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUnspecified {

    [_stack addObject:[MMValuesStack unspecifiedItem]];
    [_stack addObject:[MMValuesStack unspecifiedItem]];
    [_stack addObject:[MMValuesStack unspecifiedItem]];

    XCTAssertEqual([_stack result], MMValuesStackResultUnspecified);
}

- (void)testMultipleValues {

    [_stack addObject:[NSNull null]];
    [_stack addObject:@1];
    [_stack addObject:@2];

    XCTAssertEqual([_stack result], MMValuesStackResultMultiple);
}

- (void)testSelectedValue {

    [_stack addObject:@1];
    [_stack addObject:@1];
    [_stack addObject:@1];

    XCTAssertEqual([_stack result], MMValuesStackResultSingular);
}

- (void)testEmpty {

    XCTAssertEqual([_stack result], MMValuesStackResultEmpty);
}


@end
