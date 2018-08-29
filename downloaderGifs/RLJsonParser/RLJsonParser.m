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

- (void)parseFetchedJsonDataWithDict:(NSDictionary *)fetchedJsonData withComplition:(void(^)(NSArray*gifObjects))complition {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        NSArray *tempData;
        if([fetchedJsonData objectForKey:@"data"] != nil) {tempData = [fetchedJsonData objectForKey:@"data"];} else {NSLog(@"Wrong, see parseFetchedJsonDataWithDict:");}
        NSMutableArray *gifObjects = [NSMutableArray array];
        
        for(NSDictionary* dataDict in tempData) {
            GiphyModel2 *gif = [[GiphyModel2 alloc] init];
            
            for(NSString *dictKey in dataDict.allKeys) {
                
                if([gif respondsToSelector:NSSelectorFromString(dictKey)]) {
                    [gif setValue:dataDict[dictKey] forKey:dictKey];
                }
                if([dictKey isEqualToString:kImages]) {
                    NSDictionary *fixWidthImg = dataDict[dictKey][kPreview_gif];
                    NSDictionary *downSisizedImg = dataDict[dictKey][kDownsized_medium];
                    [gif setPreview_gif:[[Gif alloc] initWith:fixWidthImg[kImageUrl] width:[fixWidthImg[kImageWidth] doubleValue] height:[fixWidthImg[kImageHeight] doubleValue] size:0]];
                    [gif setDownsized_medium:[[Gif alloc] initWith:downSisizedImg[kImageUrl] width:[downSisizedImg[kImageWidth] doubleValue] height:[downSisizedImg[kImageHeight] doubleValue] size:([downSisizedImg[kImageSize] doubleValue]/1000000)]];
                }
            }
            [gifObjects addObject:gif];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            complition(gifObjects.copy);
        });
    });
    
}



//        for(GiphyModel2 *gif in gifObjects) {
//            NSLog(@"===%@\n%@\n%@\n%@\n%@\n%f\n%f", gif.title,gif.rating,gif.import_datetime,gif.trending_datetime,gif.fixed_width_small.url,gif.fixed_width_small.width,gif.fixed_width_small.height);
//        }




@end
