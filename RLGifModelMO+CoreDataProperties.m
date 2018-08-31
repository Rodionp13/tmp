//
//  RLGifModelMO+CoreDataProperties.m
//  downloaderGifs
//
//  Created by User on 8/31/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//
//

#import "RLGifModelMO+CoreDataProperties.h"

@implementation RLGifModelMO (CoreDataProperties)

+ (NSFetchRequest<RLGifModelMO *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"RLGifModelEnt"];
}

@dynamic import_datetime;
@dynamic rating;
@dynamic title;
@dynamic trending_datetime;
@dynamic downsizedGif;
@dynamic previewGif;

@end
