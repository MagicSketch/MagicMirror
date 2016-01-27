//
//  MMVersionCheckerTests.m
//  MagicMirror2
//
//  Created by James Tang on 14/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MMVersionChecker.h"
#import "MockVersionUpdateActor.h"

@interface MMVersionCheckerTests : XCTestCase

@property (nonatomic, strong) MMManifest *local;
@property (nonatomic, strong) MockVersionUpdateActor *actor;
@property (nonatomic, strong) MMVersionChecker *checker;

@end

@implementation MMVersionCheckerTests

- (void)setUp {
    [super setUp];

    self.local = [MMManifest manifestWithVersion:@"2.0"];
    self.actor = [[MockVersionUpdateActor alloc] init];

    MMManifest *current = [MMManifest manifestWithVersion:@"2.0"];
    MMManifest *development = [MMManifest manifestWithVersion:@"2.0.1"];
    self.checker = [MMVersionChecker versionCheckerWithLocal:current
                                                      remote:development
                                                 lastChecked:nil];
    self.checker.delegate = self.actor;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitialState {
    XCTAssertNil(self.checker.lastChecked);
    XCTAssertNotNil(self.checker.local);
    XCTAssertNotNil(self.checker.remote);
    XCTAssertEqualObjects(self.checker.lastVersion, self.checker.remote.version);
    XCTAssertEqual(self.actor.proceedDownloadCount, 0);
    XCTAssertEqual(self.actor.showedUpdateDialogCount, 0);
}

- (void)testCheckForUpdates {
    __weak __typeof (self) weakSelf = self;
    XCTestExpectation *expectation = [self expectationWithDescription:@"Prompting No Update"];
    [self.checker checkForUpdates:^{
        XCTAssertEqualObjects(weakSelf.checker.lastVersion, @"2.0.1");
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:1 handler:^(NSError * _Nullable error) { XCTAssertNil(error); }];
}

- (void)testNeedsAutoCheck {
    XCTAssertTrue([self.checker needsAutoCheck]);
    self.checker.lastChecked = [NSDate date];
    XCTAssertFalse([self.checker needsAutoCheck]);
    self.checker.lastChecked = [NSDate dateWithTimeInterval:-24 * 60 * 60 * self.checker.skippingDays - 1 sinceDate:[NSDate date]];
    XCTAssertTrue([self.checker needsAutoCheck]);
}

- (void)testNoUpdates {
    XCTestExpectation *expectation = [self expectationWithDescription:@"No Updates"];
    self.checker.remote = [MMManifest manifestWithVersion:@"2.0"];
    [self.checker okay];
    __weak __typeof (self) weakSelf = self;
    [self.checker checkForUpdates:^{
        XCTAssertEqualObjects(weakSelf.checker.lastVersion, @"2.0");
        XCTAssertTrue(weakSelf.actor.hasShowLatestDialog);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:1 handler:^(NSError * _Nullable error) { XCTAssertNil(error); }];
}

- (void)testSkipThisVersion {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Version Skipped"];
    self.checker.remote = [MMManifest manifestWithVersion:@"2.0"];
    [self.checker skipThisVersion];
    __weak __typeof (self) weakSelf = self;
    [self.checker checkForUpdates:^{
        XCTAssertTrue(weakSelf.actor.hasRemainedSlience);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1 handler:^(NSError * _Nullable error) { XCTAssertNil(error); }];
}

- (void)testSkipButNextVersionAvailable {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Version Remind Later"];
    
    [self.checker skipThisVersion];
    self.checker.remote = [MMManifest manifestWithVersion:@"2.1"];
    __weak __typeof (self) weakSelf = self;
    [self.checker checkForUpdates:^{
        XCTAssertEqual(weakSelf.actor.showedUpdateDialogCount, 1);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:1 handler:^(NSError * _Nullable error) { XCTAssertNil(error); }];
}

- (void)testRemindLater {

    XCTestExpectation *expectation = [self expectationWithDescription:@"Version Remind Later"];
    self.checker.remote = [MMManifest manifestWithVersion:@"3.0"];
    [self.checker remindLater];
    self.checker.lastChecked = [NSDate date];
    __weak __typeof (self) weakSelf = self;
    [self.checker checkForUpdates:^{
        XCTAssertTrue(weakSelf.actor.hasRemainedSlience);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:1 handler:^(NSError * _Nullable error) { XCTAssertNil(error); }];
}

- (void)testRemindLaterButVersionUpdated {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Version Skipped"];
    [self.checker remindLater];
    self.checker.lastChecked = [NSDate date];
    self.checker.remote = [MMManifest manifestWithVersion:@"2.2"];

    __weak __typeof (self) weakSelf = self;
    [self.checker checkForUpdates:^{
        XCTAssertEqual(weakSelf.actor.showedUpdateDialogCount, 1);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:1 handler:^(NSError * _Nullable error) { XCTAssertNil(error); }];
}

- (void)testRemindLaterWithinSkippingDayPeriod {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Version Skipped"];
    self.checker.remote = [MMManifest manifestWithVersion:@"3.0"];
    [self.checker remindLater];
    self.checker.lastChecked = [NSDate date];

    __weak __typeof (self) weakSelf = self;
    [self.checker checkForUpdates:^{
        XCTAssertTrue(weakSelf.actor.hasRemainedSlience);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:1 handler:^(NSError * _Nullable error) { XCTAssertNil(error); }];
}

- (void)testRemindLaterWhenSkippingIsOver {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Version Skipped"];
    self.checker.remote = [MMManifest manifestWithVersion:@"3.0"];
    [self.checker remindLater];
    self.checker.lastChecked = [NSDate dateWithTimeInterval:-(60 * 60 * 24 * self.checker.skippingDays + 1) sinceDate:[NSDate date]];

    __weak __typeof (self) weakSelf = self;
    [self.checker checkForUpdates:^{
        XCTAssertEqual(weakSelf.actor.showedUpdateDialogCount, 1);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:1 handler:^(NSError * _Nullable error) { XCTAssertNil(error); }];
}

#pragma mark - Proceed To Download

- (void)testDownload {
    [self.checker download];
    XCTAssertEqualObjects(self.actor.downloadURL, [NSURL URLWithString:@"http://api.magicmirror.design/download/latest"]);
    XCTAssertEqual(self.actor.proceedDownloadCount, 1);
}

- (void)testDownloadAlternativeLink {
    self.checker.remote = [MMManifest manifestWithVersion:@"2.1"
                                                 checkURL:nil
                                              downloadURL:@"http://github.com/jamztang/magicmirror/v2.zip"
                                                     name:nil];
    [self.checker download];
    XCTAssertEqualObjects(self.actor.downloadURL, [NSURL URLWithString:@"http://github.com/jamztang/magicmirror/v2.zip"]);
}

- (void)testProceedToDownload {

    XCTestExpectation *expectation = [self expectationWithDescription:@"Version Remind Later"];
    self.checker.remote = [MMManifest manifestWithVersion:@"3.0"];
    [self.checker download];
    self.checker.lastChecked = [NSDate date];
    __weak __typeof (self) weakSelf = self;
    [self.checker checkForUpdates:^{
        XCTAssertTrue(weakSelf.actor.hasRemainedSlience);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:1 handler:^(NSError * _Nullable error) { XCTAssertNil(error); }];
}

- (void)testProceedToDownloadButVersionUpdated {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Version Skipped"];
    [self.checker download];
    self.checker.lastChecked = [NSDate date];
    self.checker.remote = [MMManifest manifestWithVersion:@"2.2"];

    __weak __typeof (self) weakSelf = self;
    [self.checker checkForUpdates:^{
        XCTAssertEqual(weakSelf.actor.showedUpdateDialogCount, 1);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:1 handler:^(NSError * _Nullable error) { XCTAssertNil(error); }];
}

- (void)testProceedToDownloadWithinSkippingDayPeriod {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Version Skipped"];
    self.checker.remote = [MMManifest manifestWithVersion:@"3.0"];
    [self.checker download];
    self.checker.lastChecked = [NSDate date];

    __weak __typeof (self) weakSelf = self;
    [self.checker checkForUpdates:^{
        XCTAssertTrue(weakSelf.actor.hasRemainedSlience);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:1 handler:^(NSError * _Nullable error) { XCTAssertNil(error); }];
}

- (void)testProceedToDownloadWhenSkippingIsOver {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Version Skipped"];
    self.checker.remote = [MMManifest manifestWithVersion:@"3.0"];
    [self.checker download];
    self.checker.lastChecked = [NSDate dateWithTimeInterval:-(60 * 60 * 24 * self.checker.skippingDays + 1) sinceDate:[NSDate date]];

    __weak __typeof (self) weakSelf = self;
    [self.checker checkForUpdates:^{
        XCTAssertEqual(weakSelf.actor.showedUpdateDialogCount, 1);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:1 handler:^(NSError * _Nullable error) { XCTAssertNil(error); }];
}


@end
