//
//  RLDetailedViewController.swift
//  downloaderGifs
//
//  Created by User on 8/29/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

import Foundation
import UIKit

/*
 var title: String?
 var rating: String?
 var import_datetime: String?
 var trending_datetime: String?
 var preview_gif: Gif?
 var downsized_medium: Gif?
 */

class RLDetailedViewController: UIViewController {
    var gif: GiphyModel2!
    var indexPath: IndexPath?
    var gifImageView: UIImageView!
    let modelService = ModelService2.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Hellow"
        self.configureImageView()
    }
    
    func configureImageView() -> Void {
//        let strUrl: String = (self.gif.downsized_medium?.url)!
//        guard let url = URL.init(string: strUrl) else {
//            return
//        }
//            let data: Data = try! Data.init(contentsOf: url)
//            let imgView = UIImageView.init(frame: .zero)
//            imgView.image = UIImage.gif(data: data)
//            self.view.addSubview(imgView)
//            self.gifImageView = imgView
//            self.setConstraintsToImageView()
        
        
        
        let url: String = (self.gif.downsized_medium?.url)!
        self.modelService.startFetchingGif(with: url) { [weak self] (data, url) in
            let imgView = UIImageView.init(frame: .zero)
            imgView.image = UIImage.gif(data: data)
            self?.view.addSubview(imgView)
            self?.gifImageView = imgView
            self?.setConstraintsToImageView()
        }
        
    }
    
    func setConstraintsToImageView() {
//        guard let gifImageView = self.gifImageView else {
//            return
//        }
        self.gifImageView.translatesAutoresizingMaskIntoConstraints = false
        let safe: UILayoutGuide = self.view.safeAreaLayoutGuide
        self.gifImageView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 8).isActive = true
        self.gifImageView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 20).isActive = true
        self.gifImageView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -20).isActive = true
        self.gifImageView.heightAnchor.constraint(equalTo: safe.heightAnchor, multiplier: 0.4).isActive = true
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
