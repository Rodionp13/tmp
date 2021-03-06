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
    @IBOutlet weak var shareBttn: UIButton!
    
    
    var gif: GiphyModel2!
    var indexPath: IndexPath?
    var presenter: Presenter2!
    var storeType: StoreTypre!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = (UIApplication.shared.delegate as! RLAppDelegate).presenter
//        self.presenter.delegate = self
        self.gif = self.presenter.getGif(withIndexPath: self.indexPath!, storeType: self.storeType)
        
        self.downloadIndicator.isHidden = true
        self.configureButtons(downloadBttn: self.downloadBttn, shareBttn: self.shareBttn)
        
        guard let downsized_medium = self.gif.downsized_medium  else { return }
        self.configureImageView(withUrl: downsized_medium.url, and: self.mainIndicator)
        self.configureLabels(withGifData: self.gif, title: self.gifTitle, date: self.gifDate, size: self.gifSize)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter.delegate = self
    }
    
    private func configureButtons(downloadBttn:UIButton, shareBttn:UIButton) -> Void {
        downloadBttn.isHidden = true
        downloadBttn.layer.cornerRadius = 10
        downloadBttn.layer.borderColor = UIColor.white.cgColor
        downloadBttn.layer.borderWidth = 2
        
        shareBttn.isHidden = true
        shareBttn.layer.cornerRadius = 10
        shareBttn.layer.borderColor = UIColor.white.cgColor
        shareBttn.layer.borderWidth = 2
    }
    
    
    private func configureImageView(withUrl strUrl:String, and mainIndicator: UIActivityIndicatorView) -> Void {
        self.presentUiElements(isPresented: false)
        guard let originalName = self.gif.downsized_medium?.originalName else {
            self.presenter.fetchDownsizedGif(with: self.indexPath!, storeType: self.storeType) { [weak self] (data) in
                guard let data = data else { return }
                self?.gifImageView.image = UIImage.gif(data: data)
                self?.presentUiElements(isPresented: true)
            }
            return
        }
        //if gif has original Name
        let data = try! Data.init(contentsOf: RLFileManager.createDestinationUrl(originalName, andDirectory: FileManager.SearchPathDirectory.cachesDirectory))
        self.gifImageView.image = UIImage.gif(data: data)
        self.presentUiElements(isPresented: true)
    }
    
    private func presentUiElements(isPresented: Bool) -> Void {
        if(isPresented) {
            self.mainIndicator.isHidden = true
            self.mainIndicator.stopAnimating()
            self.downloadBttn.isHidden = false
            self.shareBttn.isHidden = false
        } else {
            self.mainIndicator.isHidden = false
            self.mainIndicator.startAnimating()
        }
    }
    
    private func configureLabels(withGifData gif:GiphyModel2, title: UILabel, date: UILabel, size: UILabel) -> Void {
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
        
        guard let dictWithGifModel = self.prepateGifDataToPass(with: self.gif) else { return }
        self.presenter.addNewRecordToDb(gifObj: dictWithGifModel)
    }
    
    private func prepateGifDataToPass(with gif:GiphyModel2) -> Dictionary<NSString,[NSString:Any]>? {
        guard let prev = gif.preview_gif, let down = gif.downsized_medium else { return Dictionary<NSString,[NSString:Any]>() }
        let previewGif:[NSString:Any] = ["originalName":prev.originalName!,"width":prev.width,"height":prev.height,"url":prev.url,"size":prev.size]
        let downsizedGif:[NSString:Any] = ["originalName":down.originalName!,"width":down.width,"height":down.height,"url":down.url,"size":down.size]
        let gifObj:[NSString:Any] = ["title":gif.title!, "rating":gif.rating!, "import_datetime":gif.import_datetime!, "trending_datetime":gif.trending_datetime!]
        let dictWithGifModel:[NSString:Dictionary<NSString,Any>] = ["model":gifObj,"preview":previewGif,"downsized":downsizedGif]
        
        return dictWithGifModel
    }
    
    @IBAction func shareAction(_ sender: Any) {
        guard let originalName = self.gif.downsized_medium?.originalName else { return }
        
        var data:Data!
        if let locationUrl = RLFileManager.createDestinationUrl(originalName, andDirectory: FileManager.SearchPathDirectory.cachesDirectory) {
            data = try? Data.init(contentsOf: locationUrl)
        }
        let activityVC = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    

}

extension RLDetailedViewController: PresenterDelegate {

    func willStartAddingNewRecordToDb() {
        self.downloadIndicator.startAnimating()
        self.downloadIndicator.isHidden = false
        self.downloadBttn.isHidden = true
        self.gifSize.isHidden = true
    }

    func didEndAddingNewRecordToDb() {
        DispatchQueue.global().async {
            sleep(1)
            DispatchQueue.main.async {
                self.downloadIndicator.isHidden = true
                self.downloadIndicator.stopAnimating()
                self.downloadBttn.isHidden = false
                self.gifSize.isHidden = false
            }
        }
    }
    
    func connectionDownAlert() {
        self.alert()
    }
}














