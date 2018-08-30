//
//  CDManager.h
//  rss_reader_tut.by
//
//  Created by User on 7/30/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "downloaderGifs-Swift.h"

//entities
//static NSString *const kArticleEnt = @"ArticleEnt";

//typedef NS_ENUM(NSInteger, EntityType) {
//    ChannelEnt = 0,
//    ArticleEnt,
//    ImageContentURLAndNameEnt,
//    VideoContentURLAndNameEnt
//};


@interface RLCoreDataManager : NSObject

- (void)addNewRecordsToDB:(NSDictionary *)channelGroups;
- (NSDictionary *)parseMOinToObjects:(NSArray*)managedObjects;
//- (NSArray *)loadDataFromDBWithPredicate:(nullable NSPredicate*)predicate andDescriptor:(nullable NSArray<NSSortDescriptor*>*)sortDescriptors forEntity:(EntityType)entityName;
//- (void)convertArticlesMOinToArticlesObjects:(NSArray<ArticleMO*>*)articlesMO withComplitionBlock:(void(^)(NSMutableArray<Article*>*articlesArr))complition;
//- (void)addNewArticlesToChannel:(ChannelMO*)targetChannelMO articlesToAdd:(NSArray<Article*>*)articlse channelSetIsEmpty:(BOOL)isEmpty;



- (NSUInteger) deleteAllObjects; //Utility method







@end
