//
//  CDManager.h
//  rss_reader_tut.by
//
//  Created by User on 7/30/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef void(^Complition)(NSArray*);

@interface RLCoreDataManager : NSObject
//@property(nonatomic, copy) Complition complition;

- (void)loadDataFromDBWithPredicate:(nullable NSPredicate*)predicate andDescriptor:(nullable NSArray<NSSortDescriptor*>*)sortDescriptors andComplition:(void(^)(NSArray*))complition;
- (void)addNewRecordsToDB:(NSDictionary *)gifObjrctDict complition:(void(^)(void))complition;
//- (void)addNewRecordsToDB:(NSDictionary *)channelGroups;
//- (NSDictionary *)parseMOinToObjects:(NSArray*)managedObjects;
//- (NSArray *)loadDataFromDBWithPredicate:(nullable NSPredicate*)predicate andDescriptor:(nullable NSArray<NSSortDescriptor*>*)sortDescriptors forEntity:(EntityType)entityName;
//- (void)convertArticlesMOinToArticlesObjects:(NSArray<ArticleMO*>*)articlesMO withComplitionBlock:(void(^)(NSMutableArray<Article*>*articlesArr))complition;
//- (void)addNewArticlesToChannel:(ChannelMO*)targetChannelMO articlesToAdd:(NSArray<Article*>*)articlse channelSetIsEmpty:(BOOL)isEmpty;



- (NSUInteger) deleteAllObjects; //Utility method







@end
