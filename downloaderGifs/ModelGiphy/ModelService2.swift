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
    
    
//    func createGifObjects(complition:@escaping (Array<GiphyModel2>) -> Void) -> Void {
//
//        self.startFetchingProcessWithComplition { [weak self] (fetchedArr) in
//            var result: Array<GiphyModel2> = Array()
////
////            DispatchQueue.global().async {
////                for dict in fetchedArr {
////                    let dictData = dict as! [String:AnyObject]
////
////                    let gif: GiphyModel2 = (self?.prepareContext(dictData: dictData))!
////                    result.append(gif)
////
////                    if(result.count == fetchedArr.count) {
////                        DispatchQueue.main.async {
////                            complition(result)
////                        }
////                    }
////                }
////            }
//        }
//    }
    

    
    func startFetchingProcessWithComplition(complition:@escaping ([Any])->Void) -> Void {
        self.downloader.fetchGifsData { (dataDict:[AnyHashable:Any]?) in
            
            self.jSonParser.parseFetchedJsonData(withDict: dataDict!, withComplition: { (gifObjects:[Any]?) in
                complition(gifObjects! as [Any])
            })
        }
    }
}
