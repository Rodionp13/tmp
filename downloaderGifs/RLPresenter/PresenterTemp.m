//
//  PresenterTemp.m
//  downloaderGifs
//
//  Created by Radzivon Uhrynovich on 24.08.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "PresenterTemp.h"
#import <UIKit/UIKit.h>

@interface PresenterTemp()
@property(nonatomic, strong) ModelService *modelService;

@end

@implementation PresenterTemp

- (instancetype)init {
    self = [super init];
    
    if(self) {
        _modelService = [[ModelService alloc] init];
    }
    return self;
}

- (void)startWithComplition:(void(^)(NSArray*))complition {
    //Main Thread
    [self.modelService startFetchingProcessWithComplition:^(NSArray *resultArr) {
        complition(resultArr);
    }];
}

//- (void)pushDataArrForGifs:(NSArray *)transformedData {
//    <#code#>
//}

@end
