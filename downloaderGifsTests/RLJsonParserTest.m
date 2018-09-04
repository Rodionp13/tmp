//
//  RLJsonParserTest.m
//  downloaderGifsTests
//
//  Created by User on 9/4/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RLJsonParser.h"

@interface RLJsonParserTest : XCTestCase
@property(nonatomic,strong) RLJsonParser *parser;
@end

@implementation RLJsonParserTest

- (void)setUp {
    [super setUp];
    self.parser = [[RLJsonParser alloc] init];
}

- (void)tearDown {
    self.parser = nil;
    [super tearDown];
}

- (void)testExample {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Time's out"];
    NSDictionary *dictToPass = [NSDictionary dictionaryWithObject:@[] forKey:@"data"];
    [self.parser parseFetchedJsonDataWithDict:dictToPass withComplition:^(NSArray *gifObjects) {
        XCTAssertNotNil(gifObjects,@"Rsult array shoud not be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:2.f handler:^(NSError * _Nullable error) {
        if(error != nil) {
            NSLog(@"There's an error!");
        }
    }];
}

@end
