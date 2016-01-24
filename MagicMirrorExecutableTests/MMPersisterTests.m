//
//  MMPersisterTests.m
//  MagicMirror2
//
//  Created by James Tang on 25/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MMPersister.h"
#import "MMVersionChecker.h"

@interface MockPersister : NSObject <MMPersister>

@property (nonatomic, strong) NSMutableDictionary *dict;
@end

@implementation MockPersister

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)persistDictionary:(id)object withIdentifier:(NSString *)identifier {
    [_dict setObject:object forKey:identifier];
}

- (id)persistedDictionaryForIdentifier:(NSString *)identifier {
    return [_dict objectForKey:identifier];
}

- (void)removePersistedDictionaryForIdentifier:(NSString *)identifier {
    [_dict removeObjectForKey:identifier];
}

@end

@interface MMPersisterTests : XCTestCase

@property (nonatomic, strong) id <MMPersister> persister;
@property (nonatomic, strong) MMVersionChecker *checker;
@end

@implementation MMPersisterTests

- (void)setUp {
    [super setUp];
    self.persister = [[MockPersister alloc] init];
    self.checker = [MMVersionChecker versionCheckerWithPersister:self.persister];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitial {
    XCTAssertEqual(_checker.status, MMVersionCheckerStatusPending);
    XCTAssertNil(_checker.lastChecked);
    XCTAssertNil(_checker.lastVersion);
}

- (void)testSaved {
    _checker.lastChecked = [NSDate date];
    _checker.lastVersion = @"2.0.1";
    [_checker skipThisVersion];
    [_checker save];


    MMVersionChecker *savedChecker = [MMVersionChecker versionCheckerWithPersister:_persister];
    XCTAssertEqual(savedChecker.status, MMVersionCheckerStatusSkipped);
    XCTAssertEqualObjects(savedChecker.lastVersion, _checker.lastVersion);
    XCTAssertEqualObjects(savedChecker.lastChecked, _checker.lastChecked);
}

@end
