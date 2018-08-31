//
//  RLFileManager.h
//  downloaderGifs
//
//  Created by User on 8/30/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RLFileManager : NSObject


+ (NSURL *)copyElementFrom:(id)location to:(NSSearchPathDirectory)destination;
+ (void)deleteItemFrom:(id)directory;
+ (NSURL*)createDestinationUrl:(NSString*)originalName andDirectory:(NSSearchPathDirectory)directory;
@end
