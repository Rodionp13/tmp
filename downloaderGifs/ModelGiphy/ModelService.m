//
//  ModelService.m
//  downloaderGifs
//
//  Created by Radzivon Uhrynovich on 24.08.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "ModelService.h"
#import "RLDownloader.h"
#import "RLJsonParser.h"
#import "ConstantsForParsing.h"

@interface ModelService()
@property(nonatomic, strong) RLDownloader *downloader;
@property(nonatomic, strong) RLJsonParser *jSonParser;

@end

@implementation ModelService

- (instancetype)init {
    self = [super init];
    
    if(self) {
        _downloader = [[RLDownloader alloc] init];
        _jSonParser = [[RLJsonParser alloc] init];
    }
    return self;
}

//- (NSArray*)createGifObjectsWithTransformedData:(NSArray*)transformedData andComplition:(void(^)(NSArray*gifS))complition {
//    [self startFetchingProcessWithComplition:^(NSArray *transformedData) {
//        NSMutableArray *gifS = [NSMutableArray arrayWithCapacity:transformedData.count];
//        
//        [transformedData enumerateObjectsUsingBlock:^(NSMutableDictionary *obj, NSUInteger idx, BOOL *stop) {
////            GiphyModel *gif = [[GiphyModel alloc] init]
//        }];
//        
//    }];
//    
//    return @[];
//}

- (void)startFetchingProcessWithComplition:(void (^)(NSArray*))complition {
    [self.downloader fetchGifsDataWithComplition:^(NSDictionary *dataDict) {
        
        ModelService *__weak weakS = self;
        
        [weakS.jSonParser parseFetchedJsonDataWithDict:dataDict withComplition:^(NSArray *transformedData) {
            
            //Backgorund queue
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
                complition(transformedData);
            });
        }];
        
    }];
}

@end
