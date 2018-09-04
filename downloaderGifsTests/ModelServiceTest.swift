//
//  ModelServiceTest.swift
//  downloaderGifsTests
//
//  Created by User on 9/4/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

import XCTest
@testable import downloaderGifs

class ModelServiceTest: XCTestCase {
    
    var modelService: ModelService2!
    
    override func setUp() {
        super.setUp()
        self.modelService = ModelService2.init(downloader: RLDownloader.init(), jSonParser: RLJsonParser.init())
    }
    
    override func tearDown() {
        self.modelService = nil
        super.tearDown()
    }
    
    func test_saveConfigToDbSeccess() {
        let configArr = self.modelService.getConfigArr()
        let save = self.modelService.saveConfigToDb(configArr: configArr)
        XCTAssertTrue(save, "data should be saved to Db")
    }
    
    func test_startFetchingProcc_Success() {
        let url = "https://api.giphy.com/v1/gifs/search?api_key=dc6zaTOxFJmzC&q=warcraft&offset=25&rating=pg"
        self.modelService.startFetchingProcess(with: url, type: StoreTypre.trendingGifs) {}
        XCTAssertNotNil(url, "url should not be nil")
    }
    
//    func test_fetchDownsizedGif_Success() {
//        let expectation: XCTestExpectation = self.expectation(description: "Time's out!")
//        let url = "https://api.giphy.com/v1/gifs/search?api_key=dc6zaTOxFJmzC&q=warcraft&offset=25&rating=pg"
//        let indexPath = IndexPath.init(row: 0, section: 0)
//        self.modelService.fetchDownsizedGif(with: indexPath, type: StoreTypre.trendingGifs) { (data) in
//            XCTAssertNotNil(data, "Data should not be nil")
//            expectation.fulfill()
//        }
//        self.waitForExpectations(timeout: 2.0) { (err) in
//            if let err = err {
//                print("Error!!!\(err)")
//            }
//        }
//    }
    
//    func test_loadAdditionalSmallGifs2() {
//        let url = "https://api.giphy.com/v1/gifs/search?api_key=dc6zaTOxFJmzC&offset=0"
//        self.modelService.startFetchingProcess(with: url, type: StoreTypre.trendingGifs) {}
//
//        let expectation: XCTestExpectation = self.expectation(description: "Time's out!")
//        let indexPath = IndexPath.init(row: 0, section: 0)
//        self.modelService.fetchSmallGif(with: indexPath, queryTypre: QueryType.trending, storeType: StoreTypre.trendingGifs, topic: "Warcraft", complitionBlock: { (data) in
//            XCTAssertNotNil(data, "Data should not be nil")
//            expectation.fulfill()
//        }) { (indises) in
//            XCTAssertNotNil(indises, "Array should not be nil")
//        }
//    }
    
    func test_GetQueryStringFirst_Success() {
        let result = self.modelService.getQueryString(queryType: QueryType.trending, topicStr: nil)
        XCTAssertNotNil(result, "Query string should not be nil!")
    }
    
    func test_GetQueryStringSecond_Success() {
        let result = self.modelService.getQueryString(queryType: QueryType.searched, topicStr: "warcraft")
        XCTAssertNotNil(result, "Query string should not be nil!")
    }
    
    func test_getGif_Success() {
        guard let gif = self.modelService.getGif(withIndexPath: IndexPath(row: 0, section: 0), withType: StoreTypre.trendingGifs) else { return }
        XCTAssertNotNil(gif, "Gif should not be nil")
    }
    
//    func test_storeGifs_Success() {
//        self.modelService.storeGifs
//    }
    
    
    
    
    
    
    
    
    
    
    
    
}
