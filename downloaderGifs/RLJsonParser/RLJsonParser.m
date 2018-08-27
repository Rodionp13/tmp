//
//  RLJsonParser.m
//  downloaderGifs
//
//  Created by Radzivon Uhrynovich on 24.08.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "RLJsonParser.h"
#import "ConstantsForParsing.h"
#import "downloaderGifs-Swift.h"
#import "GiphyModel.h"


typedef BOOL(^CheckBlock)(NSArray*);

@implementation RLJsonParser

- (void)parseFetchedJsonDataWithDict:(NSDictionary *)fetchedJsonData withComplition:(void(^)(NSArray*transformedData))complition {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        NSArray *tempData;
        if([fetchedJsonData objectForKey:@"data"] != nil) {tempData = [fetchedJsonData objectForKey:@"data"];} else {NSLog(@"Wrong, see parseFetchedJsonDataWithDict:");}
        NSMutableArray *transformedData = [NSMutableArray array];
        
        for(NSDictionary* dataDict in tempData) {
            NSMutableDictionary *dataForGiphyObj =  (NSMutableDictionary*)[self transformFetchedDataDictionary:dataDict.mutableCopy withBlock:^BOOL(NSArray *twoKeysToCompare) {
                return [twoKeysToCompare.firstObject isEqualToString:twoKeysToCompare.lastObject];
            }];
            [transformedData addObject:dataForGiphyObj];
        }
        [self parseImageDictionary:transformedData];
        NSArray *transformedDataForGiphyObjects = [[NSArray alloc] initWithArray:transformedData.copy];
        
        //    NSLog(@"%@", transformedDataForGiphyObjects);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            complition(transformedDataForGiphyObjects);
        });
    });
    
}

- (NSMutableDictionary*)transformFetchedDataDictionary:(NSMutableDictionary*)dataDict withBlock:(CheckBlock)checkBlock {
    NSArray *keys = @[kRating, kImport_datetime, kTrending_datetime, kImages, kTitle];
    NSMutableDictionary *temp = [NSMutableDictionary dictionary];
    
    for(NSString *dictKey in dataDict.allKeys) {
        
        for(NSString *key in keys) {
            
            if([dictKey isEqualToString:kImages]) {
                NSMutableDictionary *imagesDict = [[NSMutableDictionary alloc] initWithDictionary:dataDict[kImages]];
                [temp setValue:imagesDict forKey:kImages];
            }
            
            if(checkBlock(@[dictKey, key])) {
                [temp setValue:[dataDict valueForKey:key] forKey:key];
            }
        }
    }
    return temp;
}

- (NSMutableArray*)transformFetchedData:(NSMutableDictionary*)dataDict withBlock:(CheckBlock)checkBlock {
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:dataDict.count];
    
    for(NSString *dictKey in dataDict.allKeys) {
        GiphyModel2 *gif = [[GiphyModel2 alloc] init];
        
        if([gif respondsToSelector:NSSelectorFromString(dictKey)]) {
            [gif setValue:dataDict[dictKey] forKey:dictKey];
            [temp addObject:gif];
        }
    }
    NSLog(@"%@", temp);
    
    
    return temp;
}


//return image Dictionary with only 2 image sizes
- (void)parseImageDictionary:(NSMutableArray*)transformedData {
    for(NSMutableDictionary *mutDict in transformedData) {
        NSMutableDictionary *imagesDict = [mutDict valueForKey:kImages];
        
        for(NSString *key in imagesDict.allKeys) {
            
            if(![key isEqualToString:kFixed_width_small] && ![key isEqualToString:kDownsized_medium]) {
                [imagesDict removeObjectForKey:key];
            }
        }
    }
}





@end
