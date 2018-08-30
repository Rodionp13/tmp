//
//  ModelService2.swift
//  downloaderGifs
//
//  Created by Radzivon Uhrynovich on 24.08.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

import Foundation

class ModelService2 {
    private let downloader: RLDownloader = RLDownloader.init()
    private let jSonParser: RLJsonParser = RLJsonParser.init()
    private var gifs = Array<GiphyModel2>()
    private var offset: Int = 0
    
    
    public func startFetchingProcess(with url:String, and complition:@escaping()->Void) -> Void {
        self.downloader.fetchGifsData(withUrl: url) { (dataDict:[AnyHashable:Any]?) in
            
            self.jSonParser.parseFetchedJsonData(withDict: dataDict!, withComplition: { [weak self] (gifObjects:[Any]?) in
                let gifs = gifObjects as! [GiphyModel2]
                self?.storeGifs(gifs)
                complition();
            })
        }
    }
    
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
    
    //.........................................................................................................................//
    //.......................................................TEST..................................................................//
    //.........................................................................................................................//
    
    public func fetchSmallGif(with indexPath: IndexPath, complitionBlock:@escaping (Data)->Void, second complition2:@escaping ((Array<IndexPath>)->Void))  -> Void {
        guard let gif = self.getGif(withIndexPath: indexPath), let preview_gif = gif.preview_gif else {return}
        let count = self.gifsCount() - 3
        
        if(indexPath.row != count) {
            if let locationUrl = preview_gif.locationUrl {
                let data:Data = try! Data.init(contentsOf: locationUrl)
                complitionBlock(data);
            } else {
                self.startFetchingGif(with: preview_gif.url) { (data:Data?, locationUrl:URL?) in
                    guard let locationUrl = locationUrl, let data = data else {return}
                    preview_gif.locationUrl = locationUrl
                    complitionBlock(data);
                }
            }
        } else {
            self.loadAdditionalSmallGifs2(indexPath) { (indises) in
                complition2(indises);
            }
            
        }
    }
    
    private func startFetchingGif(with url: String, and complition:@escaping (Data, URL)->Void) -> Void {
        self.downloader.fetchGif(withUrl: url) { (data: Data?, locationUrl: URL?) in
            guard let data = data, let locationUrl = locationUrl else {
                return
            }
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
    
}
