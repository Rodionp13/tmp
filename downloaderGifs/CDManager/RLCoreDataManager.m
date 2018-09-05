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





@end
