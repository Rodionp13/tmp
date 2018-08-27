//
//  GiphyModel.swift
//  downloaderGifs
//
//  Created by Radzivon Uhrynovich on 24.08.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

import Foundation

@objcMembers class GiphyModel2: NSObject {
    let title: String
    let rating: String
    let import_datetime: String
    let trending_datetime: String
    var kFixed_width_small: [String:Any]
    var kDownsized_medium: [String:Any]
    
    init(gifWith title:String, _ rating: String, _ import_datetime: String, _ trending_datetime: String, kFixed_width_small: [String:Any], kDownsized_medium: [String:Any]) {
        self.title = title
        self.rating = rating
        self.import_datetime = import_datetime
        self.trending_datetime = trending_datetime
        self.kFixed_width_small = kFixed_width_small
        self.kDownsized_medium = kDownsized_medium
    }
    
    convenience override init() {
        self.init()
    }
}

struct Gif {
    var locationUrl: URL?
    let url: String
    let width: String
    let height: String
    
    init(with url: String, width: String, height: String) {
        self.url = url
        self.width = width
        self.height = height
    }
}



