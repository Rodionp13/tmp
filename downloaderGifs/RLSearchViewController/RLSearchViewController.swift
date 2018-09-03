//
//  RLSearchViewController.swift
//  downloaderGifs
//
//  Created by User on 9/2/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

import UIKit

class RLSearchViewController: UIViewController {
    
    var presenter: Presenter2!
    var topicString: String!
    var collectionView: UICollectionView!
    var searchBar: UISearchBar!
    let cellID = "searchCell"
    
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
        self.setUpSearchBar()
        self.setupCollectionView()
        self.title = self.topicString
        self.presenter.delegate3 = self
        //self.presenter.getQueryString(topic: self.topicString)
        self.presenter.startFetchingProcess(with: "https://api.giphy.com/v1/gifs/search?api_key=dc6zaTOxFJmzC&q="+(self.topicString)+"&offset=0", storeType: .searchedGifs) { [weak self] (nil) in
            self?.collectionView.reloadData()
        }
    }
    
    
    private func setUpSearchBar() {
        self.searchBar = UISearchBar(frame: .zero)
        self.searchBar.delegate = self
        self.view.addSubview(self.searchBar)
//        self.navigationItem.titleView = searchBar
        self.setUpConstarints(to: self.searchBar)
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: self.layout)
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RLCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        self.view.addSubview(collectionView)
        self.setUpConstraints(to: collectionView, and: self.searchBar)
    }
    
    fileprivate func prepareCellForPresentation(with cell: RLCollectionViewCell, and indexPath: IndexPath, on collectionView: UICollectionView) -> Void {
        
        cell.imgView.image = nil
        
        cell.activityIndicator.startAnimating();
        cell.activityIndicator.isHidden = false
        let connection = Connectivity.isNetworkAvailable()
        
        self.presenter.fetchSmallGif(with: indexPath, queryTypre: QueryType.searched, storeType: .searchedGifs, topic: self.topicString) { [weak self] (data:Data?) in
            if(connection) {
                cell.activityIndicator.stopAnimating()
                cell.activityIndicator.isHidden = true
            }
            guard let data = data else {
                guard let originalName = self?.presenter.modelService.getSearchedGif(withIndexPath: indexPath)?.preview_gif?.originalName else { return }
                let locationUrl = RLFileManager.createDestinationUrl(originalName, andDirectory: FileManager.SearchPathDirectory.cachesDirectory)
                let data = try? Data.init(contentsOf: locationUrl!)
                cell.imgView.image = UIImage.gif(data: data!)
                cell.imgView.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height)
                cell.activityIndicator.stopAnimating()
                cell.activityIndicator.isHidden = true
                return
            }
            cell.imgView.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height)
            cell.imgView.image = UIImage.gif(data: data)
        }
    }
    
    
    
}

extension RLSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.presenter.modelService.searchedGifsCount()
        return count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RLCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! RLCollectionViewCell
        self.prepareCellForPresentation(with: cell, and: indexPath, on: collectionView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailedVC = RLDetailedViewController.init(nibName: "RLDetailedViewController", bundle: nil)
        detailedVC.indexPath = indexPath
        //        detailedVC.gif = self.presenter.modelService.getGif(withIndexPath: indexPath)
        detailedVC.presenter = self.presenter
        detailedVC.storeType = StoreTypre.searchedGifs
        if(self.presenter.modelService.getSearchedGif(withIndexPath: indexPath) != nil) { navigationController?.pushViewController(detailedVC, animated: true) }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let gif = self.presenter.modelService.getSearchedGif(withIndexPath: indexPath) {
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

extension RLSearchViewController: SearchPresenterDelegate {
    func updateCollectionAfterLoading(indisesToUpdate indises: Array<IndexPath>) {
        self.collectionView.reloadData()
    }
}

extension RLSearchViewController: UISearchBarDelegate {
    
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
        searchBar.resignFirstResponder()
        self.presenter.startFetchingProcess(with: "https://api.giphy.com/v1/gifs/search?api_key=dc6zaTOxFJmzC&q="+(self.topicString)+"&offset=0", storeType: .searchedGifs) { [weak self] (nil) in
            self?.collectionView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.topicString = searchText
        print("searchBar///textDidChange")
    }
}





