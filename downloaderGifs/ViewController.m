//
//  ViewController.m
//  downloaderGifs
//
//  Created by Radzivon Uhrynovich on 23.08.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "ViewController.h"
#import "GiphyModel.h"
#import "PresenterTemp.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Hellow");
    PresenterTemp *presenter = [[PresenterTemp alloc] init];
    
    [presenter startWithComplition:^(NSArray *resultArr) {
        
        NSLog(@"%lu", resultArr.count);
        NSLog(@"%@",resultArr);

    }];
    
    NSLog(@"OK?");
    
}


@end


//@property(strong, nonatomic) NSArray *transformedDataForGiphyObjects;
//@property(nonatomic) NSArray *arr;
//@property(copy, nonatomic) myBlock jsonArray;
//typedef void (^myBlock)(NSDictionary*dataArray);

//    [self downloadGifs];
//
//    ViewController *__weak weakS = self;
//    self.jsonArray = ^(NSDictionary *fetchedData) {
//        NSArray *tempData;
//        if([fetchedData objectForKey:@"data"]) {tempData = [fetchedData objectForKey:@"data"];}
//        NSMutableArray *transformedData = [NSMutableArray array];
//
//        for(NSDictionary* dataDict in tempData) {
//            NSMutableDictionary *dataForGiphyObj =  (NSMutableDictionary*)[weakS transformFetchedDataDictionary:dataDict.mutableCopy withBlock:^BOOL(NSArray *twoKeysToCompare) {
//                return [twoKeysToCompare.firstObject isEqualToString:twoKeysToCompare.lastObject];
//            }];
//            [transformedData addObject:dataForGiphyObj];
//        }
//        [weakS parseImageDictionary:transformedData];
//
////        [weakS.transformedDataForGiphyObjects addObjectsFromArray:transformedData.copy];
//        weakS.transformedDataForGiphyObjects = [NSArray arrayWithArray:transformedData.copy];
//        NSLog(@"%@", weakS.transformedDataForGiphyObjects);
//    };


//
//- (NSMutableDictionary*)transformFetchedDataDictionary:(NSMutableDictionary*)dataDict withBlock:(BOOL(^)(NSArray *twoKeysToCompare))checkBlock {
//    NSArray *keys = @[kRating, kImport_datetime, kTrending_datetime, kImages, kTitle];
//    NSMutableDictionary *temp = [NSMutableDictionary dictionary];
//
//    for(NSString *dictKey in dataDict.allKeys) {
//        for(NSString *key in keys) {
//
//            if([dictKey isEqualToString:kImages]) {
//                NSMutableDictionary *imagesDict = [[NSMutableDictionary alloc] initWithDictionary:dataDict[kImages]];
//                [temp setValue:imagesDict forKey:kImages];
//            }
//
//            if(checkBlock(@[dictKey, key])) {
//                [temp setValue:[dataDict valueForKey:key] forKey:key];
//            }
//        }
//    }
//    return temp;
//}
//
//
////return image Dictionary with only 2 image sizes
//- (void)parseImageDictionary:(NSMutableArray*)transformedData {
//
//    for(NSMutableDictionary *mutDict in transformedData) {
//        NSMutableDictionary *imagesDict = [mutDict valueForKey:kImages];
//        for(NSString *key in imagesDict.allKeys) {
//            if(![key isEqualToString:kFixed_width_small] && ![key isEqualToString:kDownsized_medium]) {
//                [imagesDict removeObjectForKey:key];
//            }
//        }
//    }
//}
//
//- (void)downloadGifs {
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC"]];
//    [request setHTTPMethod:@"GET"];
//    NSURLSession *defaultSession = [NSURLSession sharedSession];
//    ViewController *__weak weakSelf = self;
//    NSURLSessionDownloadTask *download = [defaultSession downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSData *data = [NSData dataWithContentsOfURL:location];
//        NSDictionary *d = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        weakSelf.jsonArray(d);
//    }];
//    [download resume];
//}






//- (void)downloadGifs:(void(^)(NSDictionary*destinationUrl))complitionBlock {
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC"]];
//    [request setHTTPMethod:@"GET"];
//
//    NSURLSession *defaultSession = [NSURLSession sharedSession];
//
//    NSURLSessionDownloadTask *download = [defaultSession downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSData *data = [NSData dataWithContentsOfURL:location];
//        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        complitionBlock(d);
//    }];
//    [download resume];
//}

