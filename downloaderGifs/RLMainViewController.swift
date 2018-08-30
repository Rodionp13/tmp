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
    
    let presenter: Presenter2 = Presenter2.init()
    var collectionView: UICollectionView!
    let cellID = "mainCell"
    var offset: Int = 0
    
    let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let insetLeft: CGFloat = 5.0
        let insetRight: CGFloat = 5.0
        layout.sectionInset = UIEdgeInsets(top: 10, left: insetLeft, bottom: 5, right: insetRight)
        layout.minimumLineSpacing = 5.0
        layout.minimumInteritemSpacing = 10.0
        return layout
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.setUpSearchBar()
        
        self.presenter.delegate = self
        self.presenter.startFetchingProcess(with: kTrendingGifsUrl) { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func setUpSearchBar() {
        let searchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height / 7))
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: self.layout)
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RLCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        self.view.addSubview(collectionView)
    }
    
}

extension RLMainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.presenter.modelService.gifsCount()
        return count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RLCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! RLCollectionViewCell
        cell.imgView.image = nil
        cell.activityIndicator.startAnimating()
        
        self.presenter.fetchSmallGif(with: indexPath) { (data) in
            cell.activityIndicator.stopAnimating()
            cell.imgView.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height)
            cell.imgView.image = UIImage.gif(data: data)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailedVC = RLDetailedViewController.init(nibName: "RLDetailedViewController", bundle: nil)
        detailedVC.indexPath = indexPath
        detailedVC.gif = self.presenter.modelService.getGif(withIndexPath: indexPath)
        navigationController?.pushViewController(detailedVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let gif = self.presenter.modelService.getGif(withIndexPath: indexPath) {
            let height: Double = {
                let h = (gif.preview_gif?.height)!
                if(h > 180) {
                    return 180
                }
                return h
            }()
            
            return CGSize.init(width: Double(self.view.frame.size.width / 2 - 10), height: height)
        }
        return CGSize.init(width: 0, height: 0)
    }
    
}

extension RLMainViewController: PresenterDelegate {
    
    func updateCollectionAfterLoading(indisesToUpdate indises: Array<IndexPath>) {
        self.collectionView.insertItems(at: indises)
    }
    
    func connectionDownAlert() {print("Connection is Down")}
}

extension RLMainViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidBeginEditing")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidEndEditing")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchBar///textDidChange")
    }
}



