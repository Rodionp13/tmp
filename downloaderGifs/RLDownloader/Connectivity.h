//
//  Connectivity.h
//  downloaderGifs
//
//  Created by User on 8/30/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NetworkCondition)(void);

@interface Connectivity : NSObject

+ (BOOL)isNetworkAvailable;
+ (void)networkConditionIsConnected:(NetworkCondition)isConnected isDisconnected:(NetworkCondition)isDisconnected;
@end
