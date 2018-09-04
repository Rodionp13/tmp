//
//  RlDownloaderTests.m
//  downloaderGifsTests
//
//  Created by User on 9/3/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RLDownloader.h"

typedef void(^Closure)(void);

@interface URLSessionDataTaskMock: NSURLSessionDataTask
@property(nonatomic, copy) Closure closure;

- (id)initWithClosure:(void(^)(void))closure;
@end

@implementation URLSessionDataTaskMock

- (id)initWithClosure:(Closure)closure {
    self = [super init];
    
    if(self) {
        self.closure = closure;
    }
    return  self;
}

- (void)resume {
    [super resume];
    self.closure();
}
@end

typedef void (^Complition)(NSData*, NSURLResponse*, NSError*);

@interface URLSessionMock: NSURLSession

@property(nonatomic,strong) NSData *data;
@property(nonatomic, strong) NSError *error;

- (id)initWith:(NSData*)data;
@end

@implementation URLSessionMock

- (id)initWith:(NSData *)data {
    self = [super init];
    
    if(self) {
        self.data = data;
    }
    return  self;
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler {
    NSData *data = self.data;
    NSError *error = self.error;
    return [[URLSessionDataTaskMock alloc] initWithClosure:^{
        completionHandler(data, nil, error);
    }];
}
@end

@interface RlDownloaderTests : XCTestCase
@property(nonatomic, strong) RLDownloader *downloader;
@property(nonatomic, strong) URLSessionMock *sessionMock;

@end

@implementation RlDownloaderTests

- (void)setUp {
    [super setUp];
    self.downloader = [[RLDownloader alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_fetchGifsDataWithUrl_Success {
    XCTestExpectation *expactation = [self expectationWithDescription:@"Time out"];

    [self.downloader fetchGifsDataWithUrl:@"https://api.giphy.com/v1/gifs/search?api_key=dc6zaTOxFJmzC&q=Life&offset=0&rating=y" andComplition:^(NSDictionary *dataDict) {
        XCTAssertNotNil(dataDict, @"Data dict should not be nil");
        [expactation fulfill];
    }];

    [self waitForExpectationsWithTimeout:3.f handler:^(NSError * _Nullable error) {
        if(error != nil) {
            NSLog(@"There is an error!");
        }
    }];
}

- (void)test_fetchGifWithUrl_Success {
    XCTestExpectation *expactation = [self expectationWithDescription:@"Time out"];
    
    [self.downloader fetchGifWithUrl:@"https://api.giphy.com/v1/gifs/search?api_key=dc6zaTOxFJmzC&q=Life&offset=0&rating=y" andComplition:^(NSData *data, NSURL *locationUrl) {
        XCTAssertNotNil(data, @"Data should not be nil");
        XCTAssertNotNil(locationUrl, @"Location should not be nil");
        [expactation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1.5f handler:^(NSError * _Nullable error) {
        if(error != nil) {
            NSLog(@"There is an error!");
        }
    }];
}

@end
































