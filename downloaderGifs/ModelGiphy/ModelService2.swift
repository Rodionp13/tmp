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
        } else {
            configObjArr = [ConfigModel.init(rating: "y"), ConfigModel.init(rating: "g"), ConfigModel.init(rating: "pg")]
        }
    }
    
    public func saveConfigToDb(configArr: Array<ConfigModel>) -> Bool {
        let success = NSKeyedArchiver.archiveRootObject(configArr, toFile: self.itemArchiveUrl.path!)
        return success
    }
    
    //=======================================================================================================================//
    
    public func startFetchingProcess(with url:String, type:StoreTypre, and complition:@escaping()->Void) -> Void {
        let connection = Connectivity.isNetworkAvailable()
        if(connection) {
            self.downloader.fetchGifsData(withUrl: url) { [weak self] (dataDict:[AnyHashable:Any]?) in
                
                self?.jSonParser.parseFetchedJsonData(withDict: dataDict!, withComplition: { [weak self] (gifObjects:[Any]?) in
                    let gifs = gifObjects as! [GiphyModel2]
                    if(type == .trendingGifs) {
                        self?.storeGifs(gifs, in: StoreTypre.trendingGifs)
                    } else {
                        self?.storeGifs(gifs, in: StoreTypre.searchedGifs)
                    }
                    complition();
                })
            }
        }
    }
    
    
    public func fetchDownsizedGif(with indexPath: IndexPath, type:StoreTypre, complitionBlock:@escaping (Data)->Void)   -> Void {
           let temp = self.getGif(withIndexPath: indexPath, withType: type)
        guard let gif = temp, let downsized_gif = gif.downsized_medium else { return }
        let connection = Connectivity.isNetworkAvailable()
        if(connection) {
            self.startFetchingGif(with: downsized_gif.url) { (data, locationUrl) in
                downsized_gif.originalName = locationUrl.lastPathComponent
                complitionBlock(data);
            }
        }
    }
    
    public func fetchSmallGif(with indexPath: IndexPath, queryTypre: QueryType?, storeType: StoreTypre, topic: String?, complitionBlock:@escaping (Data?)->Void, second complition2:@escaping ((Array<IndexPath>)->Void))  -> Void {
        
        let temp: GiphyModel2? = self.getGif(withIndexPath: indexPath, withType: storeType)
        let count: Int = self.gifsCount(in: storeType) - 3
        
        guard let gif = temp, let preview_gif = gif.preview_gif else { return }
        let connection: Bool = Connectivity.isNetworkAvailable()
        
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
                print("ROW == \(indexPath.row)\nCOUNT == \(count)\nRATING == \(gif.rating!)")
                self.loadAdditionalSmallGifs2(with: indexPath, queryType: queryTypre, storeType: storeType, topic: topic) { (indises) in
                    complition2(indises);
                }
            }
        }
        else { complitionBlock(nil) }
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
            let count: Int = (self?.gifsCount(in: storeType))!
            
                for idx in count-25..<count {
                    indises.append(IndexPath(item: idx, section: 0))
            }
                complition(indises);
        }
    }
    
    public func getQueryString(queryType :QueryType?, topicStr: String?) -> String {
        guard let queryType = queryType else { return "" }
        switch queryType.rawValue {
        case 0:
            self.offset += 25
            print("\(kAdditionalGifsUrl)\(self.offset)")
            return "\(kAdditionalGifsUrl)\(self.offset)"
        case 1:
            self.offset += 25
            let rating = self.configObjArr.filter { (config) in
                return config.isSelected == true
                }.first?.rating
            let resultStr = self.handleTopicString(topic: topicStr!)
            
            guard let rate = rating else { return "https://api.giphy.com/v1/gifs/search?api_key=dc6zaTOxFJmzC&q=\(resultStr)&offset=\(self.offset)" }
            
            return "https://api.giphy.com/v1/gifs/search?api_key=dc6zaTOxFJmzC&q=\(resultStr)&offset=\(self.offset)&rating=\(rate)"
            
        default:
            return ""
        }
    }
    
    private func handleTopicString(topic: String) -> String {
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
    
    public func storeGifs(_ gifs: Array<GiphyModel2>, in store: StoreTypre) -> Void {
        switch store.rawValue {
        case 0:
            self.gifs.append(contentsOf: gifs)
            break;
        case 1:
            self.searchedGifs.append(contentsOf: gifs)
            break;
        default: break
        }
        
    }
    
    public func gifsCount(in store: StoreTypre) -> Int {
        switch store.rawValue {
        case 0:
            return self.gifs.count
        case 1:
            return self.searchedGifs.count
        default:
            return 0;
        }
    }
    
    public func removeAllItims() -> Void {
        self.searchedGifs.removeAll()
    }
    
    public func getConfigObj(with indexPath: IndexPath) -> ConfigModel? {
        return self.configObjArr[indexPath.row]
    }
    
    public func getConfigArr() -> Array<ConfigModel>? {
        return self.configObjArr
    }
    
    public func getConfigArrCount() -> Int {
        return self.configObjArr.count
    }
    
    
}


















