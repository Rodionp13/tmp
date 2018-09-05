//
//  ModelServiceTest.swift
//  downloaderGifsTests
//
//  Created by User on 9/4/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

import XCTest
@testable import downloaderGifs

class ModelService2Mock: ModelService2 {
    var gifs: Array<GiphyModel2> = [GiphyModel2.init(gifWith: "", "pg", "", "", preview_gif: Gif.init(with: "https://media3.giphy.com/media/yoJC2NNuYLAS58gewE/giphy-preview.gif?cid=e1bb72ff5b8ee92774765070450a36a1", width: 150, height: 200, size: 0), downsized_medium: Gif.init(with: "https://media3.giphy.com/media/yoJC2NNuYLAS58gewE/giphy.gif?cid=e1bb72ff5b8ee92774765070450a36a1", width: 290, height: 550, size: 2))]
    
    let url = "https://api.giphy.com/v1/gifs/search?api_key=dc6zaTOxFJmzC&offest=0"
    
    override init(downloader: RLDownloader, jSonParser: RLJsonParser) {
        super.init(downloader: downloader, jSonParser: jSonParser)
    }
}

class ModelServiceTest: XCTestCase {
    
    var modelService: ModelService2Mock!
    
    override func setUp() {
        super.setUp()
        self.modelService = ModelService2Mock.init(downloader: RLDownloader.init(), jSonParser: RLJsonParser.init())
    }
    
    override func tearDown() {
        self.modelService = nil
        super.tearDown()
    }
    
    func test_saveConfigToDbSeccess() {
        guard let configArr = self.modelService.getConfigArr() else { return }
        let save = self.modelService.saveConfigToDb(configArr: configArr)
        XCTAssertTrue(save, "data should be saved to Db")
    }
    
    func test_startFetchingProcc_Success() {
        let url = self.modelService.url
        self.modelService.startFetchingProcess(with: url, type: StoreTypre.trendingGifs) {}
        XCTAssertNotNil(url, "url should not be nil")
    }
    
    func test_fetchDownsizedGif_Success() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let expectation: XCTestExpectation = self.expectation(description: "Time's out!")
        self.modelService.startFetchingProcess(with: self.modelService.url, type: StoreTypre.trendingGifs) { [weak self] in
            
            self?.modelService.fetchDownsizedGif(with: indexPath, type: StoreTypre.trendingGifs) { (data) in
            XCTAssertNotNil(data, "Data should not be nil")
            }
            expectation.fulfill()
            
        }
        
        self.waitForExpectations(timeout: 3.0) { (err) in
            if let err = err {
                print("Error!!!\(err)")
            }
        }
    }

    
    func test_GetQueryStringFirstCase_Success() {
        let result = self.modelService.getQueryString(queryType: QueryType.trending, topicStr: nil)
        XCTAssertNotNil(result, "Query string should not be nil!")
    }
    
    func test_GetQueryStringSecondCase_Success() {
        let topic = "cats"
        let result = self.modelService.getQueryString(queryType: QueryType.searched, topicStr: topic)
        XCTAssertNotNil(result, "Query string should not be nil!")
    }
    
    func test_StoreGifs_Success() {
        let gifsArr = [GiphyModel2.init(),GiphyModel2.init()]
        self.modelService.storeGifs(gifsArr, in: StoreTypre.trendingGifs)
        XCTAssertGreaterThanOrEqual(gifsArr.count, 1)
    }
    
    func test_RemoveAllObjects_Success() {
        XCTAssertTrue(self.modelService.removeAllItims())
    }
    
    func test_getConfigArr_Success() {
        XCTAssertNotNil(self.modelService.getConfigArr(), "Configs should not be nil!")
    }
    
}

