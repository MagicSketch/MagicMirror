//
//  MMImageLoaderTests.m
//  MagicMirror2
//
//  Created by James Tang on 12/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MMImageLoader.h"

@interface MMImageLoaderTests : XCTestCase

@property (nonatomic, strong) MMImageLoader *loader;

@end

@implementation MMImageLoaderTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.loader = [[MMImageLoader alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testProperties {
    XCTAssertNotNil(self.loader);
}

- (void)testNormalLoadImage {
    NSImage *image = [NSImage imageNamed:@"watermark.png"];
    XCTAssertNil(image, @"Because the image is not in the main bundle");
}

- (void)testLoadImage {
    NSImage *image = [self.loader imageNamed:@"watermark"];
    XCTAssertNotNil(image);
}

@end
