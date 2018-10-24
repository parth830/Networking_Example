//
//  Networking_ExampleTests.swift
//  Networking_ExampleTests
//
//  Created by Ayaan Ruhi on 10/24/18.
//  Copyright © 2018 parth. All rights reserved.
//

import XCTest
@testable import Networking_Example

class Networking_ExampleTests: XCTestCase {
    
    var sessionUnderTest: URLSession!
    
    override func setUp() {
        super.setUp()
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    override func tearDown() {
        sessionUnderTest = nil
        super.tearDown()
    }
    
    func testCallToiTunesCompletes() {

        let url = URL(string: "https://data.cityofnewyork.us/resource/97mf-9njv.json")

        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error

            promise.fulfill()
        }
        dataTask.resume()
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
}
