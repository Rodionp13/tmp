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
    let gifImageView: UIImageView = UIImageView.init(frame: .zero)
    var gif: GiphyModel2?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Hellow VC2!"
        self.title = "At last VC2"
    }
}
