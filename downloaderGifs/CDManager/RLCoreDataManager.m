//
//  CDManager.m
//  rss_reader_tut.by
//
//  Created by User on 7/30/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "RLCoreDataManager.h"
#import <CoreData/CoreData.h>
#import "downloaderGifs-Swift.h"
#import "RLGifModelMO+CoreDataClass.h"
#import "RLDownsizedGifMO+CoreDataClass.h"
#import "RLPreviewGifMO+CoreDataClass.h"

//static NSString *const kHeaders = @"headers";

@interface RLCoreDataManager() <PresenterDelegate>
@property(strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation RLCoreDataManager

- (NSManagedObjectContext *)context {
    if(_context != nil) {
        return _context;
    }
    return [[(RLAppDelegate*)[UIApplication sharedApplication].delegate persistentContainer] viewContext];
}

- (void)loadDataFromDBWithPredicate:(nullable NSPredicate*)predicate andDescriptor:(nullable NSArray<NSSortDescriptor*>*)sortDescriptors andComplition:(void(^)(NSArray*))complition {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"RLGifModelEnt"];
    [request setReturnsObjectsAsFaults:NO];
    if(predicate != nil) {[request setPredicate:predicate];}
    if(sortDescriptors != nil) {[request setSortDescriptors:sortDescriptors];}

    NSError *err;
    NSArray *result;
        result = [self.context executeFetchRequest:request error:&err];
        if(err != nil) {
            NSLog(@"1.Failed to load data from CD with predicate\n%@\n%@", err, [err localizedDescription]);
        } else {
            NSLog(@"1.Success load data from CD with predicate, element count=%lu", [result count]);
//            for(RLGifModelMO *mo in result) {
//                RLPreviewGifMO *pr = mo.previewGif;
//                NSLog(@"PREV %@\n%f\n%f\n%lld\n%@\n", pr.url, pr.width,pr.height,pr.size,pr.originalName);
//            }
        }
    
    [self transformRecordsInToGifObjects:result complition:^(NSArray<GiphyModel2 *> *gifObjects) {
        complition(gifObjects);
    }];
    
}

- (void)transformRecordsInToGifObjects:(NSArray<NSManagedObject*>*)records complition:(void(^)(NSArray<GiphyModel2*>*))complition {
    NSMutableArray<GiphyModel2*> *gifObjects = [NSMutableArray arrayWithCapacity:[records count]];
    if(records.count != 0) {
        for(NSManagedObject* obj in records) {
            [gifObjects addObject:[self getGif:(RLGifModelMO*)obj]];
        }
    }
    complition(gifObjects.copy);
}

- (GiphyModel2*)getGif:(RLGifModelMO*)obj {
    
    RLGifModelMO *model = (RLGifModelMO*)obj; RLPreviewGifMO *prev = model.previewGif; RLDownsizedGifMO *down = model.downsizedGif;
    Gif *preview = [[Gif alloc] initWith:prev.url width:prev.width height:prev.height size:prev.size];
    preview.originalName = prev.originalName;
    Gif *downsized = [[Gif alloc] initWith:prev.url width:prev.width height:prev.height size:down.size];
    downsized.originalName = down.originalName;
    GiphyModel2 *gif = [[GiphyModel2 alloc] initWithGifWith:model.title :model.rating :model.import_datetime :model.trending_datetime preview_gif:preview downsized_medium:downsized];
    
    return gif;
}

- (void)addNewRecordsToDB:(NSDictionary *)gifObjrctDict complition:(void(^)(void))complition {
    RLAppDelegate *appDelegate = (RLAppDelegate*)[UIApplication sharedApplication].delegate;
    RLGifModelMO *gifModelMO = [[RLGifModelMO alloc] initWithEntity:[NSEntityDescription entityForName:@"RLGifModelEnt" inManagedObjectContext:self.context] insertIntoManagedObjectContext:self.context];
    RLPreviewGifMO *prev = [[RLPreviewGifMO alloc] initWithEntity:[NSEntityDescription entityForName:@"RLPreviewGifEnt" inManagedObjectContext:self.context] insertIntoManagedObjectContext:self.context];
    RLDownsizedGifMO *downs = [[RLDownsizedGifMO alloc] initWithEntity:[NSEntityDescription entityForName:@"RLDownsizedGifEnt" inManagedObjectContext:self.context] insertIntoManagedObjectContext:self.context];
    [prev setValuesForKeysWithDictionary:gifObjrctDict[@"preview"]];
    [downs setValuesForKeysWithDictionary:gifObjrctDict[@"downsized"]];
    [gifModelMO setValuesForKeysWithDictionary:gifObjrctDict[@"model"]];
    gifModelMO.previewGif = prev;
    gifModelMO.downsizedGif = downs;
    [appDelegate saveContext];
    complition();
    
    [self loadDataFromDBWithPredicate:nil andDescriptor:nil andComplition:^(NSArray *res) {}];
}
//
//- (NSDictionary *)parseMOinToObjects:(NSArray*)managedObjects {
//    NSMutableOrderedSet *headers = [NSMutableOrderedSet orderedSet];
//    NSMutableArray *gorupOfChannels = [NSMutableArray array];
//    NSMutableArray *subChannels = [NSMutableArray array];
//    NSArray *channelsSortedByGroup = managedObjects;
//
//    for(int i = 0; i < channelsSortedByGroup.count; i++) {
//        NSString *sortedChannelGroupProperty = [[channelsSortedByGroup objectAtIndex:i] channelGroup];
//        NSString *secondSortedChannelGroupProperty;
//        [headers addObject:sortedChannelGroupProperty];
//
//        if((i+1) != channelsSortedByGroup.count) {
//        secondSortedChannelGroupProperty = [[channelsSortedByGroup objectAtIndex:i + 1] channelGroup];
//        } else {
//            secondSortedChannelGroupProperty = sortedChannelGroupProperty.copy;
//        }
//        Channel *newChannel = [self convertMOinToObj:[channelsSortedByGroup objectAtIndex:i]];
//        [subChannels addObject:newChannel];
//        if(![sortedChannelGroupProperty isEqualToString:secondSortedChannelGroupProperty]) {
//            [gorupOfChannels addObject:[subChannels copy]];
//            [subChannels removeAllObjects];
//        } else if((i+1) == channelsSortedByGroup.count) {
//            [gorupOfChannels addObject:[subChannels copy]];
//            [subChannels removeAllObjects];
//        }
//    }
//
//    return @{kHeaders:headers,kChannels:gorupOfChannels};
//}
//
//
//- (Channel*)convertMOinToObj:(ChannelMO*)managedObj {
//    ChannelMO *channelMO = managedObj;
//    Channel *channel = [[Channel alloc] initWithName:channelMO.name url:channelMO.url];
//    return channel;
//}
//
//- (ChannelMO*)convertChannelinToMO:(Channel*)object channelGroup:(NSString*)channelGroup {
//    Channel *channel = (Channel*)object;
//    ChannelMO *channelMO = [[ChannelMO alloc] initWithEntity:[NSEntityDescription entityForName:kChannelEnt inManagedObjectContext:self.context] insertIntoManagedObjectContext:self.context];
//    channelMO.name = channel.name;
//    channelMO.url = channel.url;
//    channelMO.channelGroup = channelGroup;
//    NSLog(@"name %@, %@", channel.name, channelMO.name);
//    return channelMO;
//}
//
//- (void)convertArticlesMOinToArticlesObjects:(NSArray<ArticleMO*>*)articlesMO withComplitionBlock:(void(^)(NSMutableArray<Article*>*articlesArr))complition {
//    NSMutableArray *articles = [NSMutableArray array];
//    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
//        for(int i = 0; i < articlesMO.count; i++) {
//            ArticleMO *artMO = articlesMO[i];
//
//            NSArray<ImageContentURLAndNameMO*> *imageContent = [artMO.imageContentURLsAndNames allObjects];
//            NSArray<VideoContentURLAndNameMO*> *videoContent = [artMO.videoContentURLsAndNames allObjects];
//            Article *article = [self getArticle:artMO images:imageContent videoContent:videoContent];
//            [articles addObject:article];
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            complition(articles);
//        });
//    });
//}
//
//- (Article*)getArticle:(ArticleMO*)articleMO images:(NSArray*)images videoContent:(NSArray*)videoContent  {
//    NSFileManager *fm  = [NSFileManager defaultManager];
//    NSURL *documentDirectory = [[fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] objectAtIndex:0];
//    NSString *iconUrlStr = [articleMO.iconUrl lastPathComponent];
//    NSURL *iconURL = [documentDirectory URLByAppendingPathComponent:iconUrlStr];
//    //=======================================================================================================================//
//    NSMutableArray *imageURLs = [NSMutableArray array]; NSMutableArray *videoURLs = [NSMutableArray array];
//    [images enumerateObjectsUsingBlock:^(ImageContentURLAndNameMO *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [imageURLs addObject:[NSString stringWithFormat:@"%@",obj.imageUrl.copy]];
//    }];
//    [videoContent enumerateObjectsUsingBlock:^(VideoContentURLAndNameMO *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [videoURLs addObject:[NSString stringWithFormat:@"%@", obj.videoUrl.copy]];
//    }];
//    //=======================================================================================================================//
//    Article *article = [[Article alloc] initWithTitle:articleMO.title iconUrl:iconURL date:articleMO.date description:articleMO.articleDescr link:articleMO.articleLink images:imageURLs.mutableCopy];
//    return article;
//}
//
//- (ArticleMO*)convertArticleInToMO:(Article*)article {
//    ArticleMO *articleMO = [[ArticleMO alloc] initWithEntity:[NSEntityDescription entityForName:kArticleEnt inManagedObjectContext:self.context] insertIntoManagedObjectContext:self.context];
//    NSArray *imageContent = [self getImageContentOfArticle:article];
//
//
//    articleMO.title = article.title;
//    articleMO.iconUrl = article.iconUrl.absoluteString;
//    articleMO.date = article.date;
//    articleMO.articleLink = article.articleLink.absoluteString;
//    articleMO.articleDescr = article.articleDescr;
//    articleMO.imageContentURLsAndNames = [NSSet setWithArray:imageContent];
//
//    return articleMO;
//}
//
//- (NSArray<ImageContentURLAndNameMO *>*)getImageContentOfArticle:(Article*)article {
//    NSMutableArray *imageContentArr = [NSMutableArray array];
//    for(int i = 0; i < article.imageContentURLsAndNames.count; i++) {
//        NSString *stringUrlForImage = article.imageContentURLsAndNames[i];
//        ImageContentURLAndNameMO *imageContentMO = [[ImageContentURLAndNameMO alloc] initWithEntity:[NSEntityDescription entityForName:kImageContentURLAndNameEnt inManagedObjectContext:self.context] insertIntoManagedObjectContext:self.context];
//        imageContentMO.imageUrl = stringUrlForImage;
//        [imageContentArr addObject:imageContentMO];
//    }
//    return imageContentArr.copy;
//}
//
//- (NSUInteger) deleteAllObjects {
//    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    NSArray *arrToDelete = [self loadDataFromDBWithPredicate:nil andDescriptor:nil forEntity:ChannelEnt];
//    for(ChannelMO *mo in arrToDelete) {
//        [self.context deleteObject:mo];
//        [appDelegate saveContext];
//    }
//    NSUInteger count = [[self loadDataFromDBWithPredicate:nil andDescriptor:nil forEntity:ChannelEnt] count];
//    return count;
//}




@end
