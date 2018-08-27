//
//  Giphy.h
//  downloaderGifs
//
//  Created by Radzivon Uhrynovich on 23.08.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiphyModel : NSObject
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *rating;
@property(nonatomic, copy) NSString *importDate;
@property(nonatomic, copy) NSString *trendingDate;
@property(nonatomic, strong) NSMutableDictionary *preview;
@property(nonatomic, strong) NSMutableDictionary *fullScreenView;

- (instancetype)initWithTitle:(NSString*)title rating:(NSString*)rating impDate:(NSString*)impDate trendDate:(NSString*)trendDate;

@end
