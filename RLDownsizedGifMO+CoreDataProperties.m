//
//  RLDownsizedGifMO+CoreDataProperties.m
//  downloaderGifs
//
//  Created by User on 8/31/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//
//

#import "RLDownsizedGifMO+CoreDataProperties.h"

@implementation RLDownsizedGifMO (CoreDataProperties)

+ (NSFetchRequest<RLDownsizedGifMO *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"RLDownsizedGifEnt"];
}

@dynamic height;
@dynamic originalName;
@dynamic size;
@dynamic url;
@dynamic width;
@dynamic gifModel;

@end
