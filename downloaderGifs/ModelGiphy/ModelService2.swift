//
//  ModelService2.swift
//  downloaderGifs
//
//  Created by Radzivon Uhrynovich on 24.08.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

import Foundation
import UIKit

enum QueryType: Int {
    case trending = 0
    case searched
}

enum StoreTypre: Int {
    case trendingGifs = 0
    case searchedGifs
}

class ModelService2 {
    private let downloader: RLDownloader
    private let jSonParser: RLJsonParser
    private var gifs = Array<GiphyModel2>()
    private var searchedGifs = Array<GiphyModel2>()
    private var offset: Int = 0
    private var configObjArr = Array<ConfigModel>()
    
    let itemArchiveUrl: NSURL = {
        let directories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var docDirectory = directories.first!
        let locationUrl: NSURL = docDirectory.appendingPathComponent("items.archive") as NSURL
        return locationUrl
    }()
    
    init(downloader: RLDownloader, jSonParser: RLJsonParser) {
        self.downloader = downloader
        self.jSonParser = jSonParser
        
        if let archiveItems = NSKeyedUnarchiver.unarchiveObject(withFile: itemArchiveUrl.path!) as? [ConfigModel] {
                self.configObjArr.append(contentsOf: archiveItems)
            print(self.configObjArr)
            print(self.configObjArr.count)
        } else {
            configObjArr = [ConfigModel.init(rating: "y"), ConfigModel.init(rating: "p"), ConfigModel.init(rating: "pg")]
            print(self.configObjArr)
        }
    }
    
    public func startFetchingProcess(with url:String, type:StoreTypre, and complition:@escaping()->Void) -> Void {
        let connection = Connectivity.isNetworkAvailable()
        if(connection) {
            self.downloader.fetchGifsData(withUrl: url) { (dataDict:[AnyHashable:Any]?) in
                
                self.jSonParser.parseFetchedJsonData(withDict: dataDict!, withComplition: { [weak self] (gifObjects:[Any]?) in
                    let gifs = gifObjects as! [GiphyModel2]
                    if(type == .trendingGifs) {
                        self?.storeGifs(gifs)
                    } else {
                        self?.storeGifsInSearchArr(gifs)
                    }
                    complition();
                })
            }
        }
    }
    
    //.........................................................................................................................//
    //.......................................................TEST..................................................................//
    //.........................................................................................................................//
    
    public func fetchDownsizedGif(with indexPath: IndexPath, type:StoreTypre, complitionBlock:@escaping (Data)->Void)   -> Void {
           let temp = self.getGif(withIndexPath: indexPath, withType: type)
        guard let gif = temp, let downsized_gif = gif.downsized_medium else { return }
        let connection = Connectivity.isNetworkAvailable()
        if(connection) {
            self.startFetchingGif(with: downsized_gif.url) { (data, locationUrl) in
//                print(locationUrl);
                downsized_gif.originalName = locationUrl.lastPathComponent
                complitionBlock(data);//                print(locationUrl);
            }
        }
    }
    
    public func fetchSmallGif(with indexPath: IndexPath, queryTypre: QueryType?, storeType: StoreTypre, topic: String?, complitionBlock:@escaping (Data?)->Void, second complition2:@escaping ((Array<IndexPath>)->Void))  -> Void {
        
        let temp: GiphyModel2? = self.getGif(withIndexPath: indexPath, withType: storeType)
        var count: Int
        if(storeType == .trendingGifs) {
            count = self.gifsCount() - 1
        } else {
            count = self.searchedGifsCount() - 1
        }
        
        let connection: Bool = Connectivity.isNetworkAvailable()
        guard let gif = temp, let preview_gif = gif.preview_gif else { return }
        
        if(connection) {
            if(indexPath.row != count) {
                if let originalName = preview_gif.originalName {
                    let locationUrl = RLFileManager.createDestinationUrl(originalName, andDirectory: FileManager.SearchPathDirectory.cachesDirectory)
                    let data:Data = try! Data.init(contentsOf: locationUrl!)
                    complitionBlock(data);
                } else {
                    self.startFetchingGif(with: preview_gif.url) { (data, locationUrl) in
                        preview_gif.originalName = locationUrl.lastPathComponent
                        complitionBlock(data);
                    }
                }
            } else {
                self.loadAdditionalSmallGifs2(with: indexPath, queryType: queryTypre, storeType: storeType, topic: topic) { (indises) in
                    complition2(indises);
                }
            }
        } else { complitionBlock(nil) }
    }
    
    
    private func startFetchingGif(with url: String, and complition:@escaping (Data, URL)->Void) -> Void {
        self.downloader.fetchGif(withUrl: url) { (data: Data?, locationUrl: URL?) in
            guard let data = data, let locationUrl = locationUrl else { return }
            complition(data,locationUrl);
        }
    }
    
    private func loadAdditionalSmallGifs2(with indexPath: IndexPath, queryType:QueryType?, storeType:StoreTypre , topic: String?, and complition:@escaping (([IndexPath])->Void)) -> Void {
        
        let url: String = self.getQueryString(queryType: queryType, topicStr: topic)
        self.startFetchingProcess(with: url, type: storeType) { [weak self] in
                var indises = [IndexPath]()
            var count: Int
            if(storeType == .trendingGifs) {
                count = (self?.gifsCount())!
            } else {
                count = (self?.searchedGifsCount())!
            }
                for idx in count-25..<count {
                    indises.append(IndexPath(item: idx, section: 0))
            }
                complition(indises);
        }
    }
    
    func getQueryString(queryType :QueryType?, topicStr: String?) -> String {
        guard let queryType = queryType else { return "" }
        switch queryType.rawValue {
        case 0:
            self.offset += 25
            return "\(kAdditionalGifsUrl)"+String(self.offset)
        case 1:
            self.offset += 25
            let resultStr = self.handleTopicString(topic: topicStr!)
            return "https://api.giphy.com/v1/gifs/search?api_key=dc6zaTOxFJmzC&q="+String(resultStr)+"&offset="+String(self.offset)
        default:
            return ""
        }
    }
    
    public func handleTopicString(topic: String) -> String {
        return String(topic.map({$0 == " " ? "+" : $0})).lowercased()
    }
    
    
    //Accessory methods to Sourse gifs
    public func getGif(withIndexPath indexPath: IndexPath, withType: StoreTypre) -> GiphyModel2? {
        switch withType.rawValue {
        case 0:
            return self.gifs[indexPath.row]
        case 1:
            return self.searchedGifs[indexPath.row]
        default:
            return nil
        }
    }
    
    public func storeGifs(_ gifs: Array<GiphyModel2>) {
        self.gifs.append(contentsOf: gifs)
    }
    
    public func gifsCount() -> Int {
        return self.gifs.count
    }
   
    
    public func getSearchedGif(withIndexPath indexPath: IndexPath) -> GiphyModel2? {
        return searchedGifs[indexPath.row]
    }
    
    public func storeGifsInSearchArr(_ gifs: Array<GiphyModel2>) {
        self.searchedGifs.append(contentsOf: gifs)
    }
    
    public func searchedGifsCount() -> Int {
        return self.searchedGifs.count
    }
    
    
    
    public func removeAllItims() -> Void {
        self.searchedGifs.removeAll()
    }
    
    public func getConfigObj(with indexPath: IndexPath) -> ConfigModel? {
        return self.configObjArr[indexPath.row]
    }
    
    public func getConfigArr() -> [ConfigModel] {
        return self.configObjArr
    }
    
    public func configArrCount() -> Int {
        return self.configObjArr.count
    }
    
    func saveConfigToDb() -> Void {
        let success = NSKeyedArchiver.archiveRootObject(self.configObjArr, toFile: itemArchiveUrl.path!)
        if(success) {
            print("Saved data Successfuly")
        } else {
            print("Something's wrong!!! data are not saved")
        }
    }
    
    
}


















