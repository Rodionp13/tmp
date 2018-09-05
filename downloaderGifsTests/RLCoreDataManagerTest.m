//
//  RLCoreDataManagerTest.m
//  downloaderGifsTests
//
//  Created by User on 9/5/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RLCoreDataManager.h"
#import <CoreData/CoreData.h>

@interface RLCoreDataManager()

- (void)loadDataFromDBWithPredicate:(nullable NSPredicate*)predicate andDescriptor:(nullable NSArray<NSSortDescriptor*>*)sortDescriptors andComplition:(void(^)(NSArray*))complition;
- (void)addNewRecordsToDB:(NSDictionary *)gifObjrctDict complition:(void(^)(void))complition;
- (void)transformRecordsInToGifObjects:(NSArray<NSManagedObject*>*)records complition:(void(^)(NSArray*))complition;
- (id)getGif:(id)obj;

@end

@interface RLCoreDataManagerTest : XCTestCase
@property(strong, nonatomic) RLCoreDataManager *cdManager;

@end

@implementation RLCoreDataManagerTest

- (void)setUp {
    [super setUp];
    self.cdManager = [[RLCoreDataManager alloc] init];
    
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_LoadDataFromDb_Success {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Time's out"];
    [[self cdManager] loadDataFromDBWithPredicate:nil andDescriptor:nil andComplition:^(NSArray *result) {
        XCTAssertNotNil(result, @"Result array should not be nil!");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:2.f handler:^(NSError * _Nullable error) {
        if(error != nil) { NSLog(@"Error while getting data from Db"); }
    }];
}


- (void)test_addNewRecordsToDB_Success {
    NSDictionary *dict = [NSDictionary dictionary];
    [self.cdManager addNewRecordsToDB:dict complition:^{}];
    XCTAssertNotNil(dict,@"Argument dict should not be nil");
}

- (void)test_transformRecordsInToGifObjects_Success {
    NSArray <NSManagedObject*> *inputArr = [NSArray array];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Time's out"];
    [[self cdManager] transformRecordsInToGifObjects:inputArr complition:^(NSArray *result) {
        XCTAssertNotNil(result, @"Result array should not be nil!");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:2.f handler:^(NSError * _Nullable error) {
        if(error != nil) { NSLog(@"Error while getting data from Db"); }
    }];
}

- (void)test_getGif_Success {
    id gif;
    id result = [[self cdManager] getGif:gif];
    XCTAssertNotNil(result, @"Result should no be nil");
}






















@end
