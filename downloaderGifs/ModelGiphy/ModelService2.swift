//
//  ModelService2.swift
//  downloaderGifs
//
//  Created by Radzivon Uhrynovich on 24.08.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

import Foundation

protocol ModelService2Delegate: class {
    
}

class ModelService2 {
    private let downloader: RLDownloader = RLDownloader.init()
    private let jSonParser: RLJsonParser = RLJsonParser.init()
    private var gifs = Array<GiphyModel2>()
    
    
    func startFetchingProcess(with url:String, and complition:@escaping()->Void) -> Void {
        self.downloader.fetchGifsData(withUrl: url) { (dataDict:[AnyHashable:Any]?) in
            
            self.jSonParser.parseFetchedJsonData(withDict: dataDict!, withComplition: { [weak self] (gifObjects:[Any]?) in
                let gifs = gifObjects as! [GiphyModel2]
                self?.storeGifs(gifs)
                complition();
            })
        }
    }
    
    func startFetchingGif(with url: String, and complition:@escaping (Data, URL)->Void) -> Void {
        self.downloader.fetchGif(withUrl: url) { (data: Data?, locationUrl: URL?) in
            guard let data = data, let locationUrl = locationUrl else {
                return
            }
            complition(data,locationUrl);
        }
    }
    
    func getGif(withIndexPath indexPath: IndexPath) -> GiphyModel2? {
        print(gifs.count)
        return gifs[indexPath.row]
    }
    
    public func storeGifs(_ gifs: Array<GiphyModel2>) {
        self.gifs.append(contentsOf: gifs)
    }
    
    func gifsCount() -> Int {
        return self.gifs.count
    }
    
}
