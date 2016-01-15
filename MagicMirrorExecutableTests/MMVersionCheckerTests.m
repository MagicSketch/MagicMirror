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
}

- (void)testNoUpdates {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Prompting No Update"];

    self.checker.remote = [MMManifest manifestWithVersion:@"2.0"];

    __weak __typeof (self) weakSelf = self;
    [self.checker checkForUpdates:^{
        XCTAssertTrue(weakSelf.actor.hasShowLatestDialog);
        XCTAssertNotNil([weakSelf.checker lastChecked]);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:1
                                 handler:^(NSError * _Nullable error) {
                                     XCTAssertNil(error);
                                 }];
}

- (void)testLastChecked {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Version Checked"];

    __weak __typeof (self) weakSelf = self;
    [self.checker checkForUpdates:^{
        XCTAssertEqual(weakSelf.actor.showedUpdateDialogCount, 1);
        XCTAssertNotNil([weakSelf.checker lastChecked]);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:1
                                 handler:^(NSError * _Nullable error) {
                                     XCTAssertNil(error);
                                 }];
}

- (void)testSkipThisVersion {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Version Skipped"];
    self.checker.skippedVersion = @"2.0.1";

    __weak __typeof (self) weakSelf = self;
    [self.checker checkForUpdates:^{
        XCTAssertTrue(weakSelf.actor.hasRemainedSlience);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1
                                 handler:^(NSError * _Nullable error) {
                                     XCTAssertNil(error);
                                 }];
}

- (void)testSkipButNextVersionAvailable {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Version Skipped"];
    self.checker.skippedVersion = @"2.0.1";
    self.checker.remote = [MMManifest manifestWithVersion:@"2.1"];

    __weak __typeof (self) weakSelf = self;
    [self.checker checkForUpdates:^{
        XCTAssertEqual(weakSelf.actor.showedUpdateDialogCount, 1);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1
                                 handler:^(NSError * _Nullable error) {
                                     XCTAssertNil(error);
                                 }];
}

- (void)testRemindLater {

    XCTestExpectation *expectation = [self expectationWithDescription:@"Version Remind Later"];

    self.checker.shouldRemindLater = YES;
    self.checker.lastChecked = [NSDate date];
    __weak __typeof (self) weakSelf = self;
    [self.checker checkForUpdates:^{
        XCTAssertTrue(weakSelf.actor.hasRemainedSlience);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1
                                 handler:^(NSError * _Nullable error) {
                                     XCTAssertNil(error);
                                 }];
}

- (void)testRemindLaterButVersionUpdated {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Version Skipped"];
    self.checker.shouldRemindLater = YES;
    self.checker.lastChecked = [NSDate date];
    self.checker.remote = [MMManifest manifestWithVersion:@"2.2"];

    __weak __typeof (self) weakSelf = self;
    [self.checker checkForUpdates:^{
        XCTAssertEqual(weakSelf.actor.showedUpdateDialogCount, 1);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:1
                                 handler:^(NSError * _Nullable error) {
                                     XCTAssertNil(error);
                                 }];

}

- (void)testRemindLaterWithinSkippingDayPeriod {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Version Skipped"];
    self.checker.shouldRemindLater = YES;
    self.checker.lastChecked = [NSDate date];

    __weak __typeof (self) weakSelf = self;
    [self.checker checkForUpdates:^{
        XCTAssertTrue(weakSelf.actor.hasRemainedSlience);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:1
                                 handler:^(NSError * _Nullable error) {
                                     XCTAssertNil(error);
                                 }];
}


- (void)testRemindLaterWhenSkippingIsOver {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Version Skipped"];
    self.checker.shouldRemindLater = YES;
    self.checker.lastChecked = [NSDate dateWithTimeInterval:-(60 * 60 * 24 + 1) sinceDate:[NSDate date]];

    __weak __typeof (self) weakSelf = self;
    [self.checker checkForUpdates:^{
        XCTAssertEqual(weakSelf.actor.showedUpdateDialogCount, 1);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:1
                                 handler:^(NSError * _Nullable error) {
                                     XCTAssertNil(error);
                                 }];
}

@end
