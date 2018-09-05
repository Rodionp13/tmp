//
//  ConfigModel.swift
//  downloaderGifs
//
//  Created by User on 9/3/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

import Foundation

class ConfigModel: NSObject, NSCoding {
    
    let rating: String
    var isSelected: Bool
    
    
    init(rating: String, isSelected: Bool) {
        self.rating = rating
        self.isSelected = isSelected
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(rating, forKey: "rating")
        aCoder.encode(isSelected, forKey: "isSelected")
    }
    
    required init?(coder aDecoder: NSCoder) {
        rating = aDecoder.decodeObject(forKey: "rating") as! String
        isSelected = aDecoder.decodeBool(forKey: "isSelected")
    }
}
