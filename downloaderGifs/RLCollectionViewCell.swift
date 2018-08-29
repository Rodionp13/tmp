//
//  RLCollectionViewCell.swift
//  downloaderGifs
//
//  Created by Radzivon Uhrynovich on 27.08.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

import Foundation
import UIKit

class RLCollectionViewCell: UICollectionViewCell {
    
    var imgView: UIImageView = {
        let imgV = UIImageView.init(frame: .zero)
        return imgV
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.imgView)
        self.addSubview(self.activityIndicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
