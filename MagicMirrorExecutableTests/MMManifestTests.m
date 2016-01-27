//
//  MMManifestTests.m
//  MagicMirror2
//
//  Created by James Tang on 14/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MMManifest.h"

@interface MMManifestTests : XCTestCase

@property (nonatomic, strong) MMManifest *manifest;

@end

@implementation MMManifestTests

- (void)setUp {
    [super setUp];

    self.manifest = [MMManifest manifestNamed:@"local" inBundle:[NSBundle bundleForClass:[self class]]];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNotNil {
    XCTAssertNotNil(self.manifest);
    XCTAssertNotNil([MMManifest manifestWithVersion:@"1.0"]);
}

- (void)testParse {
    MMManifest *m = self.manifest;
    XCTAssertEqualObjects(m.name, @"✨ Magic Mirror 2");
    XCTAssertEqualObjects(m.version, @"2.0");
    XCTAssertEqualObjects(m.checkURL, @"https://raw.githubusercontent.com/jamztang/MagicMirror/master/MagicMirror2.sketchplugin/Contents/Sketch/manifest.json");
    XCTAssertEqualObjects(m.downloadURL, @"http://magicmirror.design/");
}

- (void)testCompare {
    MMManifest *development = [MMManifest manifestWithVersion:@"2.1"];
    XCTAssertEqual([self.manifest compare:development], NSOrderedAscending);

    MMManifest *archived = [MMManifest manifestWithVersion:@"1.9"];
    XCTAssertEqual([self.manifest compare:archived], NSOrderedDescending);

    MMManifest *current = [MMManifest manifestWithVersion:@"2.0"];
    XCTAssertEqual([self.manifest compare:current], NSOrderedSame);

    MMManifest *hotfix = [MMManifest manifestWithVersion:@"2.0.1"];
    XCTAssertEqual([self.manifest compare:hotfix], NSOrderedAscending);
}

@end
