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
    
    fileprivate var presenter: Presenter2!
    fileprivate var collectionView: UICollectionView!
    fileprivate var topicStringToPass: String!
    fileprivate let cellID = "mainCell"
    fileprivate var searchBar: UISearchBar!
    
    fileprivate let layout: UICollectionViewFlowLayout = {
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
        self.presenter = (UIApplication.shared.delegate as! RLAppDelegate).presenter
        self.presenter.delegate = self
        self.title = "Gify search"
        self.setUpSearchBar()
        self.setupCollectionView()
        self.setUpConfigBttn()
        
        self.presenter.startFetchingProcess(with: kTrendingGifsUrl, storeType: .trendingGifs) { [weak self] (nil) in
            self?.collectionView.reloadData()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchBar.text = ""
    }
    
    private func setUpSearchBar() {
        self.searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = self
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
        self.setUpConstraints(to: self.collectionView, and: self.searchBar)
    }
    
    private func setUpConfigBttn() {
        let rightBttn = UIButton.init(type: UIButtonType.custom)
        rightBttn.setTitle("Config", for: UIControlState.normal)
        rightBttn.setTitleColor(UIColor.red, for: UIControlState.normal)
        rightBttn.addTarget(self, action: #selector(configAction), for: UIControlEvents.touchUpInside)
        
        let rightBarBttnItem: UIBarButtonItem = UIBarButtonItem(customView: rightBttn)
        self.navigationItem.rightBarButtonItem = rightBarBttnItem
    }
    
    @objc func configAction(_ sender: UIButton) {
        let configVC = RLConfigViewController.init()
        self.navigationController?.pushViewController(configVC, animated: true)
    }
    
    fileprivate func prepareCellForPresentation(with cell: RLCollectionViewCell, and indexPath: IndexPath, on collectionView: UICollectionView) -> Void {
        
        cell.imgView.image = nil
        
        cell.activityIndicator.startAnimating();
        cell.activityIndicator.isHidden = false
        let connection = Connectivity.isNetworkAvailable()
        
        self.presenter.fetchSmallGif(with: indexPath, queryTypre: QueryType.trending, storeType: .trendingGifs, topic: nil) { (data:Data?) in
            if(connection) {
            cell.activityIndicator.stopAnimating()
            cell.activityIndicator.isHidden = true
            }
            guard let data = data else { return }
//                guard let originalName = self?.presenter.modelService.getGif(withIndexPath: indexPath, withType: .trendingGifs)?.preview_gif?.originalName else { return }
//                let locationUrl = RLFileManager.createDestinationUrl(originalName, andDirectory: FileManager.SearchPathDirectory.cachesDirectory)
//                let data = try? Data.init(contentsOf: locationUrl!)
//                cell.imgView.image = UIImage.gif(data: data!)
//                cell.imgView.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height)
//                cell.activityIndicator.stopAnimating()
//                cell.activityIndicator.isHidden = true
//                return
//            }
            cell.imgView.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height)
            cell.imgView.image = UIImage.gif(data: data)
        }
    }
    
}

extension RLMainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.presenter.modelService.gifsCount()
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
        detailedVC.storeType = StoreTypre.trendingGifs
        if(self.presenter.modelService.getGif(withIndexPath: indexPath, withType: .trendingGifs) != nil) { navigationController?.pushViewController(detailedVC, animated: true) }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let gif = self.presenter.modelService.getGif(withIndexPath: indexPath, withType: .trendingGifs) {
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
        self.collectionView.reloadItems(at: indises)
    }
    
    func loadingDidStart(_ indexPath: IndexPath) {}
    func loadingDidEnd(_ indexPath: IndexPath) {}
    
    func connectionDownAlert() {
        let alert: UIAlertController = UIAlertController(title: "Warning", message: "There'is no internet connection and no data in store!!!\nPlease switch on connection\nGIFs took from local store", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Okey", style: UIAlertActionStyle.default) { (action) in }
        alert.addAction(action)
        self.present(alert, animated: true) { print("alert became") }
    }
        
}

extension RLMainViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidBeginEditing")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        print("searchBarTextDidEndEditing")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        print("searchBarCancelButtonClicked")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            self.searchBar.resignFirstResponder()
            let searchVC = RLSearchViewController.init()
            searchVC.topicString = self.topicStringToPass
            searchVC.presenter = self.presenter
            self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.topicStringToPass = searchText
        print("searchBar///textDidChange")
    }
}

extension UIViewController {
    
    func setUpConstraints(to collection:UICollectionView, and searchBar: UISearchBar) {
        collection.translatesAutoresizingMaskIntoConstraints = false
        let safe = self.view.safeAreaLayoutGuide
        collection.topAnchor.constraint(equalTo: searchBar.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        collection.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 0).isActive = true
        collection.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: 0).isActive = true
        collection.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: 0).isActive = true
    }
    
    func setUpConstarints(to searchBar: UISearchBar) {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        let safe = self.view.safeAreaLayoutGuide
        searchBar.topAnchor.constraint(equalTo: safe.topAnchor, constant: 0).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 0).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: 0).isActive = true
        searchBar.heightAnchor.constraint(equalTo: safe.heightAnchor, multiplier: 0.1).isActive = true
    }
    
    func setUpConstraints(to tableView: UITableView) {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let safe = self.view.safeAreaLayoutGuide
        tableView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: 0).isActive = true
    }

}



