//
//  ModelService2.swift
//  downloaderGifs
//
//  Created by Radzivon Uhrynovich on 24.08.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

import Foundation

protocol ModelService2Delegate: class {
    func loadingDidStart(_ indexPath: IndexPath) -> Void;
    func loadingDidEnd(_ indexPath: IndexPath) -> Void;
    func updateCollectionAfterLoading(indisesToUpdate indises:Array<IndexPath>) -> Void;
}

class ModelService2 {
    private let downloader: RLDownloader = RLDownloader.init()
    private let jSonParser: RLJsonParser = RLJsonParser.init()
    private var gifs = Array<GiphyModel2>()
    private var offset: Int = 0
    weak var delegate: ModelService2Delegate?;
    
    
    func startFetchingProcess(with url:String, and complition:@escaping()->Void) -> Void {
        self.downloader.fetchGifsData(withUrl: url) { (dataDict:[AnyHashable:Any]?) in
            
            self.jSonParser.parseFetchedJsonData(withDict: dataDict!, withComplition: { [weak self] (gifObjects:[Any]?) in
                let gifs = gifObjects as! [GiphyModel2]
                self?.storeGifs(gifs)
                complition();
            })
        }
    }
    
    func startFetchingGif(with url: String, index:IndexPath, and complition:@escaping (Data, URL)->Void) -> Void {
        self.delegate?.loadingDidStart(index)
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
    
    //.........................................................................................................................//
    //.......................................................TEST..................................................................//
    //.........................................................................................................................//
    
    func fetchSmallGif(with indexPath: IndexPath, complitionBlock:@escaping (Data)->Void)  -> Void {
        guard let gif = self.getGif(withIndexPath: indexPath), let preview_gif = gif.preview_gif else {return}
        let count = self.gifsCount() - 3
        
        if(indexPath.row != count) {
            if let locationUrl = preview_gif.locationUrl {
                let data:Data = try! Data.init(contentsOf: locationUrl)
                complitionBlock(data);
            } else {
                self.startFetchingGif(with: preview_gif.url, index: indexPath) { (data:Data?, locationUrl:URL?) in
                    guard let locationUrl = locationUrl, let data = data else {return}
                    preview_gif.locationUrl = locationUrl
                    complitionBlock(data);
                    self.delegate?.loadingDidEnd(indexPath)
                }
            }
        } else {
            self.loadAdditionalSmallGifs2(indexPath)
        }
    }
    
    func loadAdditionalSmallGifs2(_ indexPath: IndexPath) -> Void {
        guard let delegate = self.delegate else {return}
            self.offset += 25
            let url: String = "https://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC&offset=\(String(self.offset))"
            self.startFetchingProcess(with: url) { [weak self] in
                var indises = [IndexPath]()
                
                for idx in (self?.gifsCount())!-25..<(self?.gifsCount())! {
                    indises.append(IndexPath(item: idx, section: 0))
                }
                delegate.updateCollectionAfterLoading(indisesToUpdate: indises)
//                self?.collectionView.insertItems(at: indises)//Instead shoud be delegate CallBACK
        }
    }
}
