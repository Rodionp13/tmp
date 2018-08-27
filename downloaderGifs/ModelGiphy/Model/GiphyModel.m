//
//  Giphy.m
//  downloaderGifs
//
//  Created by Radzivon Uhrynovich on 23.08.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "GiphyModel.h"

@implementation GiphyModel

- (instancetype)initWithTitle:(NSString*)title rating:(NSString*)rating impDate:(NSString*)impDate trendDate:(NSString*)trendDate {
    self = [super init];
    
    if(self) {
        _title = title;
        _rating = rating;
        _importDate = impDate;
        _trendingDate = trendDate;
        _preview = [NSMutableDictionary dictionary];
        _fullScreenView = [NSMutableDictionary dictionary];
    }
    return  self;
}

- (NSString*)description {
    return @"";
}

@end
