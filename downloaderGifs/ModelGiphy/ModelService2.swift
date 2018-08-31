//
//  ModelService2.swift
//  downloaderGifs
//
//  Created by Radzivon Uhrynovich on 24.08.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

import Foundation

enum GifTypre: Int {
    case preview = 0
    case downsized
}

class ModelService2 {
    private let downloader: RLDownloader = RLDownloader.init()
    private let jSonParser: RLJsonParser = RLJsonParser.init()
    private var gifs = Array<GiphyModel2>()
    private var offset: Int = 0
    
    
    public func startFetchingProcess(with url:String, and complition:@escaping()->Void) -> Void {
        let connection = Connectivity.isNetworkAvailable()
        if(connection) {
            self.downloader.fetchGifsData(withUrl: url) { (dataDict:[AnyHashable:Any]?) in
                
                self.jSonParser.parseFetchedJsonData(withDict: dataDict!, withComplition: { [weak self] (gifObjects:[Any]?) in
                    let gifs = gifObjects as! [GiphyModel2]
                    self?.storeGifs(gifs)
                    complition();
                })
            }
        }
    }
    
    //.........................................................................................................................//
    //.......................................................TEST..................................................................//
    //.........................................................................................................................//
    
    public func fetchDownsizedGif(with indexPath: IndexPath, complitionBlock:@escaping (Data)->Void)   -> Void {
        
        guard let gif = self.getGif(withIndexPath: indexPath), let downsized_gif = gif.downsized_medium else { return }
        let connection = Connectivity.isNetworkAvailable()
        if(connection) {
            self.startFetchingGif(with: downsized_gif.url) { (data, locationUrl) in
                print(locationUrl);
                downsized_gif.originalName = locationUrl.lastPathComponent
                complitionBlock(data);//                print(locationUrl);
            }
        }
    }
    
    public func fetchSmallGif(with indexPath: IndexPath, complitionBlock:@escaping (Data?)->Void, second complition2:@escaping ((Array<IndexPath>)->Void))  -> Void {
        
        let connection: Bool = Connectivity.isNetworkAvailable()
        guard let gif = self.getGif(withIndexPath: indexPath), let preview_gif = gif.preview_gif else { return }
        let count = self.gifsCount() - 1
        
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
                self.loadAdditionalSmallGifs2(indexPath) { (indises) in
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
    
    private func loadAdditionalSmallGifs2(_ indexPath: IndexPath, complition:@escaping (([IndexPath])->Void)) -> Void {
            self.offset += 25
            let url: String = "\(kAdditionalGifsUrl)"+String(self.offset)
            self.startFetchingProcess(with: url) { [weak self] in
                var indises = [IndexPath]()
                
                for idx in (self?.gifsCount())!-25..<(self?.gifsCount())! {
                    indises.append(IndexPath(item: idx, section: 0))
            }
                complition(indises);
        }
    }
    
    
    //Accessory methods to Sourse gifs
    public func getGif(withIndexPath indexPath: IndexPath) -> GiphyModel2? {
        print(gifs.count)
        return gifs[indexPath.row]
    }
    
    public func storeGifs(_ gifs: Array<GiphyModel2>) {
        self.gifs.append(contentsOf: gifs)
    }
    
    public func gifsCount() -> Int {
        return self.gifs.count
    }
    
    
    
    
}
