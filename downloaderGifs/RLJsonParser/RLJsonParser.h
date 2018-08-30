//
//  RLJsonParser.h
//  downloaderGifs
//
//  Created by Radzivon Uhrynovich on 24.08.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RLJsonParser : NSObject

- (void)parseFetchedJsonDataWithDict:(NSDictionary *)fetchedJsonData withComplition:(void(^)(NSArray*gifObjects))complition;
@end
