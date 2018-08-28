//
//  RLDownloader.m
//  downloaderGifs
//
//  Created by Radzivon Uhrynovich on 24.08.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "RLDownloader.h"

@implementation RLDownloader

- (void)fetchGifsDataWithUrl:(NSString*)strUrl andComplition:(void(^)(NSDictionary*dataDict))complition {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    [request setHTTPMethod:@"GET"];
    NSURLSession *defaultSession = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
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
        
        NSFileManager *defaultManager = [NSFileManager defaultManager];
        NSArray *urls = [defaultManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
        NSURL *cacheDirectory = [urls objectAtIndex:0];
        NSURL *originalUrl = [NSURL URLWithString:[location lastPathComponent]];
        NSURL *desctinationUrl = [cacheDirectory URLByAppendingPathComponent:[originalUrl lastPathComponent]];
        [defaultManager copyItemAtURL:location toURL:desctinationUrl error:nil];
        NSData *data = [NSData dataWithContentsOfURL:desctinationUrl];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            complition(data, desctinationUrl);
        });
        
    }];
    [downloadTask resume];
}



@end
