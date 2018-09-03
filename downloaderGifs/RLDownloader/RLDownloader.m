//
//  RLDownloader.m
//  downloaderGifs
//
//  Created by Radzivon Uhrynovich on 24.08.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "RLDownloader.h"
#import "RLFileManager.h"

@implementation RLDownloader

- (void)fetchGifsDataWithUrl:(NSString*)strUrl andComplition:(void(^)(NSDictionary*dataDict))complition {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    [request setHTTPMethod:@"GET"];
    NSURLSession *defaultSession = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error != nil) { NSAssert(error, @"Error, look at fetchGifsDataWithUrl method"); }
        
        NSDictionary *dataDict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            complition(dataDict);
        });
        
    }];
    [dataTask resume];
}


- (void)fetchGifWithUrl:(NSString*)strUrl andComplition:(void(^)(NSData*data, NSURL *locationUrl))complition {
    NSURLSession *defaultSession = [NSURLSession sharedSession];
    
    NSURLSessionDownloadTask *downloadTask = [defaultSession downloadTaskWithURL:[NSURL URLWithString:strUrl] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error != nil) { NSAssert(error, @"Error, look at fetchGifWithUrl method"); }
        
        NSURL *destinationUrl = [RLFileManager copyElementFrom:location to:NSCachesDirectory];
        NSData *data = [NSData dataWithContentsOfURL:destinationUrl];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            complition(data, destinationUrl);
        });
        
    }];
    [downloadTask resume];
}



@end
