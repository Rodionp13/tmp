//
//  RLDownloader.h
//  downloaderGifs
//
//  Created by Radzivon Uhrynovich on 24.08.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kTrendingGifsUrl = @"https://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC";
static NSString *const kAdditionalGifsUrl = @"https://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC&offset=";
//static NSString *const kK = @"https://api.giphy.com/v1/gifs/search?q=\(query)&api_key=dc6zaTOxFJmzC";

@interface RLDownloader : NSObject

- (void)fetchGifsDataWithUrl:(NSString*)strUrl andComplition:(void(^)(NSDictionary*dataDict))complition;
- (void)fetchGifWithUrl:(NSString*)strUrl andComplition:(void(^)(NSData*data, NSURL *locationUrl))complition;
@end
