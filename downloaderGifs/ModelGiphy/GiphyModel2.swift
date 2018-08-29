//
//  GiphyModel.swift
//  downloaderGifs
//
//  Created by Radzivon Uhrynovich on 24.08.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

import Foundation

@objcMembers class GiphyModel2: NSObject {
    var title: String?
    var rating: String?
    var import_datetime: String?
    var trending_datetime: String?
    var preview_gif: Gif?
    var downsized_medium: Gif?
    
    init(gifWith title:String, _ rating: String, _ import_datetime: String, _ trending_datetime: String, preview_gif: Gif, downsized_medium: Gif) {
        self.title = title
        self.rating = rating
        self.import_datetime = import_datetime
        self.trending_datetime = trending_datetime
        self.preview_gif = preview_gif
        self.downsized_medium = downsized_medium
    }
    
    override init() {
        super.init()
    }
}

@objcMembers class Gif: NSObject {
    var locationUrl: URL?
    let url: String
    let width: Double
    let height: Double
    let size: Int
    
    init(with url: String, width: Double, height: Double, size: Int) {
        self.url = url
        self.width = width
        self.height = height
        self.size = size
    }
}



