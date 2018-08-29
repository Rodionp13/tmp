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
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var gifTitle: UILabel!
    @IBOutlet weak var gifDate: UILabel!
    @IBOutlet weak var gifSize: UILabel!
    @IBOutlet weak var downloadBttn: UIButton!
    @IBOutlet weak var mainIndicator: UIActivityIndicatorView!
    @IBOutlet weak var downloadIndicator: UIActivityIndicatorView!
    
    
    var gif: GiphyModel2!
    var indexPath: IndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let downsized_medium = self.gif.downsized_medium  else {return}
        
        self.configureImageView(withUrl: downsized_medium.url, and: self.mainIndicator)
        self.configureLabels(withGifData: self.gif, title: self.gifTitle, date: self.gifDate, size: self.gifSize)
        
    }
    
    
    func configureImageView(withUrl strUrl:String, and mainIndicator: UIActivityIndicatorView) -> Void {
        mainIndicator.startAnimating()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            let data = try? Data.init(contentsOf: URL.init(string: strUrl)!)
            if let data = data {
                DispatchQueue.main.async {
                    mainIndicator.stopAnimating()
                    self.gifImageView.image = UIImage.gif(data: data)
                }
            }
        }
    }
    
    func configureLabels(withGifData gif:GiphyModel2, title: UILabel, date: UILabel, size: UILabel) -> Void {
        guard let titleText = gif.title, let dateText = gif.import_datetime, let sizeInfo = gif.downsized_medium?.size else {return}
        title.text = titleText
        date.text = dateText
        
        switch sizeInfo {
        case 0:
            size.text = "less than 1 Mb"
            break;
        default:
            size.text = "\(sizeInfo) Mb"
        }
    }
    
    @IBAction func download(_ sender: Any) {
        self.downloadIndicator.isHidden = false
        self.downloadBttn.isHidden = true
        self.gifSize.isHidden = true
        self.downloadIndicator.startAnimating()
        DispatchQueue.global().async {
            sleep(10)
            DispatchQueue.main.async {
                self.downloadIndicator.isHidden = true
                self.downloadBttn.isHidden = false
                self.gifSize.isHidden = false
                self.downloadIndicator.stopAnimating()
            }
        }
    }
    

}
