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

@property (nonatomic, copy) NSBundle *bundle;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSData *data;
@property (nonatomic, copy) NSDictionary *dictionary;
@property (nonatomic, strong) MMManifest *manifest;

@end

@implementation MMManifestTests

- (void)setUp {
    [super setUp];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"local" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    MMManifest *manifest = [[MMManifest alloc] initWithDictionary:dictionary];

    XCTAssertNotNil(bundle);
    XCTAssertNotNil(path);
    XCTAssertNotNil(data);
    XCTAssertNotNil(dictionary);
    self.manifest = manifest;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNotNil {
    XCTAssertNotNil(self.manifest);
}

- (void)testParse {
    MMManifest *m = self.manifest;
    XCTAssertEqualObjects(m.name, @"✨ Magic Mirror 2");
    XCTAssertEqualObjects(m.version, @"2.0");
    XCTAssertEqualObjects(m.checkURL, @"https://raw.githubusercontent.com/jamztang/MagicMirror/master/Magic%20Mirror.sketchplugin/Contents/Sketch/manifest.json");
}

@end
