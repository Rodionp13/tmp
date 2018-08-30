//
//  RLPreviewGifMO+CoreDataProperties.h
//  downloaderGifs
//
//  Created by User on 8/30/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//
//

#import "RLPreviewGifMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface RLPreviewGifMO (CoreDataProperties)

+ (NSFetchRequest<RLPreviewGifMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *locationUrl;
@property (nullable, nonatomic, copy) NSString *url;
@property (nonatomic) double width;
@property (nonatomic) double height;
@property (nonatomic) int64_t size;
@property (nullable, nonatomic, retain) RLGifModelMO *gifModel;

@end

NS_ASSUME_NONNULL_END
