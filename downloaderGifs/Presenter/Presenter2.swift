//
//  Presenter2.swift
//  downloaderGifs
//
//  Created by Radzivon Uhrynovich on 24.08.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

import Foundation


@objc protocol PresenterDelegate: class {
    @objc optional func loadingDidStart(_ indexPath: IndexPath) -> Void;
    @objc optional func loadingDidEnd(_ indexPath: IndexPath) -> Void;
    @objc optional func updateCollectionAfterLoading(indisesToUpdate indises:Array<IndexPath>) -> Void;
    @objc optional func connectionDownAlert() -> Void;
}

protocol DetailedPresenterDelegate: class {
    func willStartAddingNewRecordToDb() -> Void;
    func didEndAddingNewRecordToDb() -> Void;
}


class Presenter2 {
    let modelService: ModelService2 = ModelService2.init()
    private let cdManager: RLCoreDataManager = RLCoreDataManager.init();
    weak var delegate: PresenterDelegate?
    weak var delegate2: DetailedPresenterDelegate?
    
    public func startFetchingProcess(with url:String, and complition:@escaping(Array<Any>?)->Void)   -> Void {
        
        let connection = Connectivity.isNetworkAvailable()
        
        if(connection) {
            self.modelService.startFetchingProcess(with: url) {
                complition(nil);
            }
        } else {
            self.delegate?.connectionDownAlert!()
            self.cdManager.loadDataFromDB(with: nil, andDescriptor: nil) { [weak self] (queryRes) in
                guard let queryRes = queryRes else { return }
                
                self?.modelService.storeGifs(queryRes as! Array<GiphyModel2>)
                complition(queryRes);
            }
        }
    }
    
    
    public func fetchSmallGif(with indexPath: IndexPath, and complition:@escaping(Data?)->Void) -> Void {
        self.modelService.fetchSmallGif(with: indexPath, complitionBlock: { (data: Data?) in
                    complition(data);
                }) { [weak self] (indises)  in
                    self?.delegate?.updateCollectionAfterLoading!(indisesToUpdate: indises);
            }
        }
    
    
    public func fetchDownsizedGif(with indexPath: IndexPath, complitionBlock:@escaping (Data)->Void)  -> Void {
        let connection = Connectivity.isNetworkAvailable()
        if(connection) {
            self.modelService.fetchDownsizedGif(with: indexPath) {(data) in
                complitionBlock(data);
            }
        } else {
            self.queryToDb(with: indexPath)
        }
//        else {
//            guard let gif = self.modelService.getGif(withIndexPath: indexPath), let originalName = gif.downsized_medium?.originalName else { return }
//
//            let locationUrl = RLFileManager.createDestinationUrl(originalName, andDirectory: FileManager.SearchPathDirectory.cachesDirectory)
//            let data = try! Data.init(contentsOf: locationUrl!)
//            complitionBlock(data);
//        }
    }
    
    public func addNewRecordToDb(gifObj: [NSString:Any])  -> Void {
        self.delegate2?.willStartAddingNewRecordToDb()
        
        self.cdManager.addNewRecords(toDB: gifObj) { [weak self] in
            self?.delegate2?.didEndAddingNewRecordToDb()
        }
    }
    
    private func queryToDb(with indexPath: IndexPath, with complition) -> Void {
        guard let gif = self.modelService.getGif(withIndexPath: indexPath), let title = gif.title, let rating = gif.rating else { return }
        
        let predicate: NSPredicate = NSPredicate(format: "title = %@ AND rating = %@", argumentArray: [title, rating])
        self.cdManager.loadDataFromDB(with: predicate, andDescriptor: nil) { (dbResult:[Any]?) in
            guard let dbResult = dbResult else { return }
            if(dbResult.count != 0) {
                
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //                    for gif in queryRes {
    //                        let g = gif as! GiphyModel2
    //                        guard let prev = g.preview_gif, let locationUrl = RLFileManager.createDestinationUrl(prev.originalName, andDirectory: FileManager.SearchPathDirectory.cachesDirectory) else {return}
    //                        print("Duoble preint\n\(locationUrl)")
    //                    }
    
    
    
    
    
    
    
    
    
}
