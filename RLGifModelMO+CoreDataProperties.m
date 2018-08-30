//
//  RLGifModelMO+CoreDataProperties.m
//  downloaderGifs
//
//  Created by User on 8/30/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//
//

#import "RLGifModelMO+CoreDataProperties.h"

@implementation RLGifModelMO (CoreDataProperties)

+ (NSFetchRequest<RLGifModelMO *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"RLGifModelEnt"];
}

@dynamic title;
@dynamic rating;
@dynamic import_datetime;
@dynamic trending_datetime;
@dynamic previewGif;
@dynamic downsizedGif;

@end
