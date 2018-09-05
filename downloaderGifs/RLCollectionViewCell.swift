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
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.imgView)
        self.addSubview(self.activityIndicator)
        self.setUpConstraints(to: self.activityIndicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UICollectionViewCell {
    func setUpConstraints(to indicator: UIActivityIndicatorView) {
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        indicator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        indicator.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        indicator.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
}
