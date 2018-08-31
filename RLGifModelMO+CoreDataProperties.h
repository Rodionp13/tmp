//
//  RLGifModelMO+CoreDataProperties.h
//  downloaderGifs
//
//  Created by User on 8/31/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//
//

#import "RLGifModelMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface RLGifModelMO (CoreDataProperties)

+ (NSFetchRequest<RLGifModelMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *import_datetime;
@property (nullable, nonatomic, copy) NSString *rating;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *trending_datetime;
@property (nullable, nonatomic, retain) RLDownsizedGifMO *downsizedGif;
@property (nullable, nonatomic, retain) RLPreviewGifMO *previewGif;

@end

NS_ASSUME_NONNULL_END
