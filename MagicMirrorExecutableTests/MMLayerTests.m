//
//  MMLayerTests.m
//  MagicMirror2
//
//  Created by James Tang on 11/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MMLayer.h"
#import "MockPropertySetter.h"
#import "MockArtboardGroup.h"
#import "MockShapeGroup.h"
#import "MockArtboardFinder.h"

@interface MMLayerTests : XCTestCase

@property (nonatomic, strong) MagicMirror *magicmirror;
@property (nonatomic, strong) id <MMLayer> layer;
@property (nonatomic, strong) MockPropertySetter *setter;
@property (nonatomic, strong) MockArtboardGroup *artboard;
@property (nonatomic, strong) MockShapeGroup *shape;
@property (nonatomic, strong) MockArtboardFinder *finder;

@end

@implementation MMLayerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.

    self.setter = [[MockPropertySetter alloc] init];
    self.finder = [[MockArtboardFinder alloc] init];
    self.shape = [[MockShapeGroup alloc] init];
    self.shape.name = @"testArtboard";

    self.layer = [MMLayer layerWithLayer:_shape
                                  finder:_finder
                          propertySetter:_setter];
    self.artboard = [[MockArtboardGroup alloc] init];
    self.artboard.name = @"testArtboard";
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testEmpty {
    XCTAssertNil(self.layer.version);
    XCTAssertNil(self.layer.source);
    XCTAssertNil(self.layer.imageQuality);
}

- (void)testSetter {
    self.layer.source = @"something";
    self.layer.imageQuality = @1;
    [self.layer configureVersion];
    XCTAssertEqualObjects(self.layer.source, @"something");
    XCTAssertEqualObjects(self.layer.imageQuality, @1);
    XCTAssertEqualObjects(self.layer.version, @"2.0");
}

- (void)testRefresh {
    [self.layer refresh];
    XCTAssertEqualObjects(self.layer.version, @"2.0");
}

- (void)testFilp {
    [self.layer flip];
    XCTAssertEqualObjects(self.layer.version, @"2.0");
}

- (void)testMirrorAuto {
    [self.layer mirrorWithArtboard:self.artboard
                      imageQuality:MMImageRenderQualityAuto
              colorSpaceIdentifier:ImageRendererColorSpaceSRGB
                       perspective:YES];
    XCTAssertEqualObjects(self.layer.version, @"2.0");
    XCTAssertEqualObjects(self.layer.imageQuality, @0);
    XCTAssertEqualObjects(self.layer.source, @"testArtboard");
}

- (void)testMirror1x {
    [self.layer mirrorWithArtboard:self.artboard
                      imageQuality:MMImageRenderQuality1x
              colorSpaceIdentifier:ImageRendererColorSpaceSRGB
                       perspective:YES];
    XCTAssertEqualObjects(self.layer.version, @"2.0");
    XCTAssertEqualObjects(self.layer.imageQuality, @1);
    XCTAssertEqualObjects(self.layer.source, @"testArtboard");
}
- (void)testMirror2x {
    [self.layer mirrorWithArtboard:self.artboard
                      imageQuality:MMImageRenderQuality2x
              colorSpaceIdentifier:ImageRendererColorSpaceSRGB
                       perspective:YES];
    XCTAssertEqualObjects(self.layer.version, @"2.0");
    XCTAssertEqualObjects(self.layer.imageQuality, @2);
    XCTAssertEqualObjects(self.layer.source, @"testArtboard");
}
- (void)testMirrorMax {
    [self.layer mirrorWithArtboard:self.artboard
                      imageQuality:MMImageRenderQualityMax
              colorSpaceIdentifier:ImageRendererColorSpaceSRGB
                       perspective:YES];
    XCTAssertEqualObjects(self.layer.version, @"2.0");
    XCTAssertEqualObjects(self.layer.imageQuality, @3);
    XCTAssertEqualObjects(self.layer.source, @"testArtboard");
}

- (void)testRotate {
    [self.layer rotate];
    XCTAssertEqualObjects(self.layer.version, @"2.0");
}

- (void)testClear {
    self.layer.source = @"something";
    self.layer.imageQuality = @1;
    [self.layer configureVersion];
    [self.layer clear];
    XCTAssertEqualObjects(self.layer.version, @"2.0");
    XCTAssertNil(self.layer.source);
    XCTAssertNil(self.layer.imageQuality);
}

- (void)testBackwardsArtboardLookup {
    [self.finder addArtboard:self.artboard];
    XCTAssertEqualObjects(self.layer.source, @"testArtboard");
}

@end
