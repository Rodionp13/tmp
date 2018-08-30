//
//  RLPreviewGifMO+CoreDataProperties.m
//  downloaderGifs
//
//  Created by User on 8/30/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//
//

#import "RLPreviewGifMO+CoreDataProperties.h"

@implementation RLPreviewGifMO (CoreDataProperties)

+ (NSFetchRequest<RLPreviewGifMO *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"RLPreviewGifEnt"];
}

@dynamic locationUrl;
@dynamic url;
@dynamic width;
@dynamic height;
@dynamic size;
@dynamic gifModel;

@end
