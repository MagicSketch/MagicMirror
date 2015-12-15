//
//  MagicMirrorTests.m
//  MagicMirror2
//
//  Created by James Tang on 15/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MagicMirror.h"
#import "MSShapePath.h"

@interface MagicMirrorTests : XCTestCase

@property (nonatomic, strong) MagicMirror *magicmirror;

@end

@implementation MagicMirrorTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.

    _magicmirror = [[MagicMirror alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

@end
