//
//  RLDownloader.m
//  downloaderGifs
//
//  Created by Radzivon Uhrynovich on 24.08.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "RLDownloader.h"
#import <UIKit/UIKit.h>

static NSString *const kTrendingGifsUrl = @"https://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC";

@implementation RLDownloader

- (void)fetchGifsDataWithComplition:(void(^)(NSDictionary*dataDict))complition {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kTrendingGifsUrl]];
    [request setHTTPMethod:@"GET"];
    NSURLSession *defaultSession = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *dataDict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        complition(dataDict);
    }];
    [dataTask resume];
}


- (void)fetchGifWithUrl:(NSString*)strUrl andComplition:(void(^)(NSURL*location))complition {
    NSURLSession *defaultSession = [NSURLSession sharedSession];
    
    NSURLSessionDownloadTask *downloadTask = [defaultSession downloadTaskWithURL:[NSURL URLWithString:strUrl] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSFileManager *defaultManager = [NSFileManager defaultManager];
        NSArray *urls = [defaultManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
        NSURL *cacheDirectory = [urls objectAtIndex:0];
        NSURL *originalUrl = [NSURL URLWithString:[location lastPathComponent]];
        NSURL *desctinationUrl = [cacheDirectory URLByAppendingPathComponent:[originalUrl lastPathComponent]];
        [defaultManager copyItemAtURL:location toURL:desctinationUrl error:nil];
        
        complition(desctinationUrl);
    }];
    [downloadTask resume];
}



@end
