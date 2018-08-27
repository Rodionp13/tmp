//
//  RLDownloader.h
//  downloaderGifs
//
//  Created by Radzivon Uhrynovich on 24.08.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^InitiateParsingProcess)(NSDictionary*dataArray);
//typedef void(^Complition)(NSDictionary*dataDict);

@interface RLDownloader : NSObject

- (void)fetchGifsDataWithComplition:(void(^)(NSDictionary*dataDict))complition;
- (void)fetchGifWithUrl:(NSString*)strUrl andComplition:(void(^)(NSURL*location))complition;
@end
