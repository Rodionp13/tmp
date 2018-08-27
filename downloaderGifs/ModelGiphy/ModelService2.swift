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
    let downloader: RLDownloader = RLDownloader.init()
    let jSonParser: RLJsonParser = RLJsonParser.init()
    
    
    func createGifObjects(complition:@escaping (Array<GiphyModel2>) -> Void) -> Void {
        
        self.startFetchingProcessWithComplition { [weak self] (fetchedArr) in
            var result: Array<GiphyModel2> = Array()
//            
//            DispatchQueue.global().async {
//                for dict in fetchedArr {
//                    let dictData = dict as! [String:AnyObject]
//                    
//                    let gif: GiphyModel2 = (self?.prepareContext(dictData: dictData))!
//                    result.append(gif)
//                    
//                    if(result.count == fetchedArr.count) {
//                        DispatchQueue.main.async {
//                            complition(result)
//                        }
//                    }
//                }
//            }
        }
    }
    
//    func prepareContext(dictData:[String:AnyObject]) -> GiphyModel2 {
//        let title = dictData[kTitle] as! String
//        let rating = dictData[kRating] as! String
//        let importDate = dictData[kImport_datetime] as! String
//        let trendingDate = dictData[kTrending_datetime] as! String
//        let imagesDict = dictData[kImages] as! [String:[String:String]]
//        let previewDictAttr = imagesDict[kFixed_width_small]  as! [String:String]
//        let prUrl = previewDictAttr[kImageUrl]
//        let prWidth = previewDictAttr[kImageWidth]
//        let prHeight = previewDictAttr[kImageHeight]
//        let fullScrDictAttr = imagesDict[kDownsized_medium] as! [String:String]
//        let fullUrl = fullScrDictAttr[kImageUrl]
//        let fullWidth = fullScrDictAttr[kImageWidth]
//        let fullHeight = fullScrDictAttr[kImageHeight]
//
//        let preview = Gif.init(with: prUrl!, width: prWidth!, height: prHeight!)
//        let fullScr = Gif.init(with: fullUrl!, width: fullWidth!, height: fullHeight!)
//        let giphy: GiphyModel2 = GiphyModel2.init(gifWith: title, rating, importDate, trendingDate, preview: preview, fullScreen: fullScr);
//
//        return giphy
//    }
    
    func startFetchingProcessWithComplition(complition:@escaping ([AnyObject])->Void) -> Void {
        self.downloader.fetchGifsData { (dataDict:[AnyHashable:Any]?) in
            
            self.jSonParser.parseFetchedJsonData(withDict: dataDict!, withComplition: { (transformedData:[Any]?) in
                complition(transformedData! as [AnyObject])
            })
        }
    }
}
