//
//  RLDownsizedGifMO+CoreDataProperties.m
//  downloaderGifs
//
//  Created by User on 8/30/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//
//

#import "RLDownsizedGifMO+CoreDataProperties.h"

@implementation RLDownsizedGifMO (CoreDataProperties)

+ (NSFetchRequest<RLDownsizedGifMO *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"RLDownsizedGifEnt"];
}

@dynamic locationUrl;
@dynamic url;
@dynamic width;
@dynamic height;
@dynamic size;
@dynamic gifModel;

@end
