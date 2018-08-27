//
//  Presenter2.swift
//  downloaderGifs
//
//  Created by Radzivon Uhrynovich on 24.08.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

import Foundation

class Presenter2 {
    let modelService: ModelService2 = ModelService2.init()
    
    func startWithComplition(complition:@escaping([Any])->Void) -> Void {
        self.modelService.createGifObjects { (res) in
            complition(res)
        }
    }
    
}
