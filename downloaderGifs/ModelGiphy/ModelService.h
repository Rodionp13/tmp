//
//  ModelService.h
//  downloaderGifs
//
//  Created by Radzivon Uhrynovich on 24.08.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import <Foundation/Foundation.h>

//protocol to Presenter
//@protocol ModelServiceDelegate
//- (void)pushDataArrForGifs:(NSArray*)transformedData;
//@end

//typedef void(^Complition)(NSArray*arr);

@interface ModelService : NSObject

//@property(nonatomic, weak) id <ModelServiceDelegate> delegate;
//@property(nonatomic, copy)  Complition complition;

- (void)startFetchingProcessWithComplition:(void(^)(NSArray*))complition;
@end
