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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.imgView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureImgView(with location: URL) -> Void {
            do {
                let data: Data = try! Data.init(contentsOf: location)
                self.imgView.image = UIImage.gif(data: data)
            }
    }
    
}
