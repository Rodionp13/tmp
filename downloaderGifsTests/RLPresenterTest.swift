//
//  RLPresenterTest.swift
//  downloaderGifsTests
//
//  Created by User on 9/5/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

import XCTest
@testable import downloaderGifs

class RLPresenterTest: XCTestCase {

    let presenter = Presenter2.init()
    let url = "https://api.giphy.com/v1/gifs/search?api_key=dc6zaTOxFJmzC&offest=0"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
}
