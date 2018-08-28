//
//  RLMainView.swift
//  downloaderGifs
//
//  Created by User on 8/28/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

import Foundation
import UIKit

class RLMainView: UIView {
    var collectionView: UICollectionView!
    var searchBar: UISearchBar!
    let cellID = "mainCell"
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .green
        collectionView.register(RLCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        self.addSubview(collectionView)
    }
    
    let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let insetLeft: CGFloat = 5.0
        let insetRight: CGFloat = 5.0
        layout.sectionInset = UIEdgeInsets(top: 10, left: insetLeft, bottom: 5, right: insetRight)
        layout.minimumLineSpacing = 5.0
        layout.minimumInteritemSpacing = 10.0
        return layout
    }()
    
    func setUpSearchBar() {
        self.searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height / 7))
        self.addSubview(searchBar)
    }
}
