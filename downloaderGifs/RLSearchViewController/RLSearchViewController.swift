//
//  RLSearchViewController.swift
//  downloaderGifs
//
//  Created by User on 9/2/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

import UIKit

class RLSearchViewController: UIViewController {
    
    let presenter: Presenter2 = {
        let pr = (UIApplication.shared.delegate as! RLAppDelegate).presenter
        return pr!
    }()
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
//        self.presenter.delegate = self
        self.setUpSearchBar()
        self.setupCollectionView()
        self.presenter.removeAllItims()
        self.title = self.topicString
        self.presenter.startFetchingProcess(with: self.presenter.getQueryString(queryType: QueryType.searched, topicStr: self.topicString), storeType: .searchedGifs) { [weak self] (nil) in
            self?.collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter.delegate = self
    }
    
    private func setUpSearchBar() {
        self.searchBar = UISearchBar(frame: .zero)
        self.searchBar.delegate = self
        self.view.addSubview(self.searchBar)
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
        
        self.presenter.fetchSmallGif(with: indexPath, queryTypre: QueryType.searched, storeType: .searchedGifs, topic: self.topicString) { (data:Data?) in
            if(connection) {
                cell.activityIndicator.stopAnimating()
                cell.activityIndicator.isHidden = true
            }
            guard let data = data else { return }
                cell.imgView.image = UIImage.gif(data: data)
                cell.imgView.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height)
            }
    }
    
}

extension RLSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.presenter.gifsCount(in: StoreTypre.searchedGifs)
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
        detailedVC.presenter = self.presenter
        detailedVC.storeType = StoreTypre.searchedGifs
        
        if(self.presenter.getGif(withIndexPath: indexPath, storeType: StoreTypre.searchedGifs) != nil) { navigationController?.pushViewController(detailedVC, animated: true) }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let gif = self.presenter.getGif(withIndexPath: indexPath, storeType: StoreTypre.searchedGifs) {
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

extension RLSearchViewController: PresenterDelegate {
    func updateCollectionAfterLoading(indisesToUpdate indises: Array<IndexPath>) {
        self.collectionView.reloadData()
    }
}

extension RLSearchViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.title = self.topicString
        self.collectionView.reloadData()
        self.presenter.removeAllItims()
        
        self.presenter.startFetchingProcess(with: self.presenter.getQueryString(queryType: QueryType.searched, topicStr: self.topicString), storeType: .searchedGifs) { [weak self] (nil) in
            self?.collectionView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.topicString = searchText
    }
}





