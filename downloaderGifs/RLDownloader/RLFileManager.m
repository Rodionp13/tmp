//
//  RLFileManager.m
//  downloaderGifs
//
//  Created by User on 8/30/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "RLFileManager.h"

@implementation RLFileManager

+ (NSURL *)copyElementFrom:(id)location to:(NSSearchPathDirectory)destination {
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    
    if(location == nil) { return [NSURL URLWithString:@""]; }
    
    NSURL *locationUrl = (NSURL*)location;
    
    NSArray *urls = [defaultManager URLsForDirectory:destination inDomains:NSUserDomainMask];
    NSURL *cacheDirectory = [urls objectAtIndex:0];
    NSURL *originalUrl = [NSURL URLWithString:[locationUrl lastPathComponent]];
    if(originalUrl == nil) { return [NSURL URLWithString:@""]; }
    NSURL *desctinationUrl = [cacheDirectory URLByAppendingPathComponent:[originalUrl lastPathComponent]];
    NSError *error;
    [defaultManager copyItemAtURL:location toURL:desctinationUrl error:&error];
    [RLFileManager printError:error];
    
    [self deleteItemFrom:location];
    
    return desctinationUrl;
}

+ (NSURL*)createDestinationUrl:(NSString*)originalName andDirectory:(NSSearchPathDirectory)directory {
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    NSArray *urls = [defaultManager URLsForDirectory:directory inDomains:NSUserDomainMask];
    NSURL *documentDirectory = [urls objectAtIndex:0];
    NSURL *originalUrl = [NSURL URLWithString:[originalName lastPathComponent]];
    NSURL *desctinationUrl = [documentDirectory URLByAppendingPathComponent:[originalUrl lastPathComponent]];
    
    return desctinationUrl;
}


+ (void)deleteItemFrom:(id)directory {
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    NSURL *directoryUrl = (NSURL*)directory;
    NSError *error;
    
    [defaultManager removeItemAtURL:directoryUrl error:&error];
    [RLFileManager printError:error];
}

+ (void)printError:(NSError*)error {
    if(error != nil) {NSAssert(error, @"Failed to remove items");}
}

@end
