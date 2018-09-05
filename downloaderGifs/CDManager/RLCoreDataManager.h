//
//  CDManager.h
//  rss_reader_tut.by
//
//  Created by User on 7/30/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RLCoreDataManager : NSObject

- (void)loadDataFromDBWithPredicate:(nullable NSPredicate*)predicate andDescriptor:(nullable NSArray<NSSortDescriptor*>*)sortDescriptors andComplition:(void(^)(NSArray*))complition;
- (void)addNewRecordsToDB:(NSDictionary *)gifObjrctDict complition:(void(^)(void))complition;

@end
