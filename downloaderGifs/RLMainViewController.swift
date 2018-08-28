//
//  RLMainViewController.swift
//  downloaderGifs
//
//  Created by Radzivon Uhrynovich on 24.08.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

import Foundation
import UIKit

class RLMainViewController: UIViewController {
    var giphyObjects: [GiphyModel2]?
    let presenter: Presenter2 = Presenter2.init()
    var collectionView: UICollectionView!
    let cellID = "mainCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("sgdf")
        self.setupCollectionView()
        
        self.presenter.startWithComplition(complition: { [weak self] (res:[Any]) in
            self?.giphyObjects = res as? [GiphyModel2]
            self?.collectionView.reloadData()
        })
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RLCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        self.view.addSubview(collectionView)
    }
    
    let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let insetLeft: CGFloat = 5.0
        let insetRight: CGFloat = 5.0
        layout.sectionInset = UIEdgeInsets(top: 10, left: insetLeft, bottom: 5, right: insetRight)
        layout.minimumLineSpacing = 5.0
        layout.minimumInteritemSpacing = 10.0
//        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width / 2 - (insetLeft + insetRight), height: 140)
        return layout
    }()
    
}

extension RLMainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let giphyObjects = self.giphyObjects {
            return giphyObjects.count
        }
        return 25
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RLCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! RLCollectionViewCell
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = UIColor.black.cgColor
        
        guard var giphyObjects = self.giphyObjects else {
            return cell
        }
        
        let gif:GiphyModel2 = giphyObjects[indexPath.row]
        
        if let locationUrl = gif.preview_gif?.locationUrl {
            do {
                let data:Data = try! Data.init(contentsOf: locationUrl)
                cell.imgView.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height)
                cell.imgView.image = UIImage.gif(data: data)
            }
        } else {
            self.presenter.modelService.downloader.fetchGif(withUrl: gif.preview_gif?.url) { (locationUrl: URL?) in
                gif.preview_gif?.locationUrl = locationUrl
                do {
                    let data:Data = try! Data.init(contentsOf: gif.preview_gif!.locationUrl!)
                        cell.imgView.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height)
                        cell.imgView.image = UIImage.gif(data: data)
                }
            }
        }
        //======//
        if(indexPath.row == giphyObjects.count - 1) {
            self.presenter.startWithComplition { [weak self] (res:[Any]) in
                let arrToAdd: [GiphyModel2] = res as! [GiphyModel2]
                self?.giphyObjects?.append(contentsOf: arrToAdd)
                self?.collectionView.reloadData()
                }
            }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let giphyObjects = self.giphyObjects {
            let height: Double = giphyObjects[indexPath.row].preview_gif!.height
            return CGSize.init(width: Double(self.view.frame.size.width / 2 - 10), height: height)
        }
        return CGSize.init(width: self.view.frame.size.width / 2 - 10, height: 80)
    }



}
