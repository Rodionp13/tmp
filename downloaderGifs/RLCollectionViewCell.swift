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
        self.addSubview(imgView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addView() -> Void {
        self.imgView.frame = CGRect.init(x: 0, y: 0, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
        self.contentView.addSubview(self.imgView)
        self.imgView.translatesAutoresizingMaskIntoConstraints = false
    }
}
