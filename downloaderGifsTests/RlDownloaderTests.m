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
    self.sessionMock = [[URLSessionMock alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_fetchGifsDataWithUrl_Success {
    unsigned char bytes[] = { 0x0F };
    NSData *data = [NSData dataWithBytes:bytes length:1];
    NSDictionary *dict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    self.sessionMock.data = data;
    [self.downloader fetchGifsDataWithUrl:@"" andComplition:^(NSDictionary *dataDict) {
        XCTAssertNil(dataDict, @"Data dict should not be nil");
    }];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

@end
































