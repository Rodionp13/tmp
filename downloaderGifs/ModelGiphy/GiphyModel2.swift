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
    
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(title, forKey: "title")
//        aCoder.encode(rating, forKey: "rating")
//        aCoder.encode(import_datetime, forKey: "import_datetime")
//        aCoder.encode(trending_datetime, forKey: "trending_datetime")
//        aCoder.encode(preview_gif, forKey: "preview_gif")
//        aCoder.encode(downsized_medium, forKey: "downsized_medium")
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        title = aDecoder.decodeObject(forKey: "title") as? String
//        rating = aDecoder.decodeObject(forKey: "rating") as? String
//        import_datetime = aDecoder.decodeObject(forKey: "import_datetime") as? String
//        trending_datetime = aDecoder.decodeObject(forKey: "trending_datetime") as? String
//        preview_gif = aDecoder.decodeObject(forKey: "preview_gif") as? Gif
//        downsized_medium = aDecoder.decodeObject(forKey: "downsized_medium") as? Gif
    //super.ini()
//    }
    
}

@objcMembers class Gif: NSObject {
    
    var originalName: String?
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
//
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(originalName, forKey: "originalName")
//        aCoder.encode(url, forKey: "url")
//        aCoder.encode
//        aCoder.encode(originalName, forKey: "originalName")
//        aCoder.encode(originalName, forKey: "originalName")
    
//    }
//
//    required init?(coder aDecoder: NSCoder) {
    //super.ini()
//        <#code#>
//    }
}



