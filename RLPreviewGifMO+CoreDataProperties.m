//
//  RLPreviewGifMO+CoreDataProperties.m
//  downloaderGifs
//
//  Created by User on 8/31/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//
//

#import "RLPreviewGifMO+CoreDataProperties.h"

@implementation RLPreviewGifMO (CoreDataProperties)

+ (NSFetchRequest<RLPreviewGifMO *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"RLPreviewGifEnt"];
}

@dynamic height;
@dynamic originalName;
@dynamic size;
@dynamic url;
@dynamic width;
@dynamic gifModel;

@end
