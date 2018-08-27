//
//  PresenterTemp.h
//  downloaderGifs
//
//  Created by Radzivon Uhrynovich on 24.08.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelService.h"

@interface PresenterTemp : NSObject

- (void)startWithComplition:(void(^)(NSArray*))complition;
@end
