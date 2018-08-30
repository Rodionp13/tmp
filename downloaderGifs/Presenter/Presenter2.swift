//
//  Presenter2.swift
//  downloaderGifs
//
//  Created by Radzivon Uhrynovich on 24.08.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

import Foundation


protocol PresenterDelegate: class {
    //    func loadingDidStart(_ indexPath: IndexPath) -> Void;
    //    func loadingDidEnd(_ indexPath: IndexPath) -> Void;
    func updateCollectionAfterLoading(indisesToUpdate indises:Array<IndexPath>) -> Void;
    func connectionDownAlert() -> Void;
}


class Presenter2 {
    let modelService: ModelService2 = ModelService2.init()
    weak var delegate: PresenterDelegate?
    
    public func startFetchingProcess(with url:String, and complition:@escaping()->Void)   -> Void {
        
        let connection = Connectivity.isNetworkAvailable()
            if(!connection) {
                //Core Data query && delegate Call BACK
            } else {
                self.modelService.startFetchingProcess(with: url) {
                    complition();
                }
            }
        }
    
    
    public func fetchSmallGif(with indexPath: IndexPath, and complition:@escaping(Data)->Void) -> Void {
        
        let connection = Connectivity.isNetworkAvailable()
        
            if(connection) {
                self.modelService.fetchSmallGif(with: indexPath, complitionBlock: { (data) in
                    complition(data);
                }) { [weak self] (indises)  in
                    self?.delegate?.updateCollectionAfterLoading(indisesToUpdate: indises);
                }
            }
    }
    
    
}
