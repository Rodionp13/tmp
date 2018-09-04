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
    
    @objc optional func willStartAddingNewRecordToDb() -> Void;
    @objc optional func didEndAddingNewRecordToDb() -> Void;
}


class Presenter2 {
    let modelService: ModelService2 = ModelService2.init(downloader: RLDownloader.init(), jSonParser: RLJsonParser.init())
    private let cdManager: RLCoreDataManager = RLCoreDataManager.init();
    weak var delegate: PresenterDelegate?
    
    
    public func startFetchingProcess(with url:String, storeType: StoreTypre, and complition:@escaping(Array<Any>?)->Void)   -> Void {
        
        Connectivity.networkConditionIsConnected({[weak self] in
            self?.modelService.startFetchingProcess(with: url, type: storeType) {
                complition(nil);}
            }, isDisconnected: {[weak self] in
                self?.delegate?.connectionDownAlert!()
                self?.cdManager.loadDataFromDB(with: nil, andDescriptor: nil) { [weak self] (queryRes) in
                    guard let queryRes = queryRes else { return }
                    
                    self?.modelService.storeGifs(queryRes as! Array<GiphyModel2>, in: StoreTypre.trendingGifs)
                    complition(queryRes);
                }
        })
    }
    
    
    public func fetchSmallGif(with indexPath: IndexPath, queryTypre: QueryType?, storeType: StoreTypre, topic: String?, and complition:@escaping(Data?)->Void) -> Void {
        self.modelService.fetchSmallGif(with: indexPath, queryTypre: queryTypre, storeType: storeType, topic: topic, complitionBlock: { (data: Data?) in
                    complition(data);
                }) { [weak self] (indises)  in
                    if(storeType == .trendingGifs) {
                    self?.delegate?.updateCollectionAfterLoading!(indisesToUpdate: indises);
                    } else {
                        self?.delegate?.updateCollectionAfterLoading!(indisesToUpdate: indises);
                    }
            }
        }
    
    
    public func fetchDownsizedGif(with indexPath: IndexPath, storeType: StoreTypre, complitionBlock:@escaping (Data?)->Void)  -> Void {
        let connection = Connectivity.isNetworkAvailable()
        if(connection) {
            self.modelService.fetchDownsizedGif(with: indexPath, type: storeType) {(data) in
                complitionBlock(data);
            }
        } else {
            
            complitionBlock(nil)
                self.delegate?.connectionDownAlert!()
        }
        
    }
    
    
    public func getQueryString(topic: String) -> String {
       return self.modelService.getQueryString(queryType: QueryType.searched, topicStr: topic)
    }
    
    
    //Core data methods
    public func addNewRecordToDb(gifObj: [NSString:Any])  -> Void {
        self.delegate?.willStartAddingNewRecordToDb!()
        
        self.cdManager.addNewRecords(toDB: gifObj) { [weak self] in
            self?.delegate?.didEndAddingNewRecordToDb!()
        }
    }
}






