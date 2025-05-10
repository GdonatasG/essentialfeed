//
//  RemoteFeedLoaderTests.swift
//  EssentialFeed2Tests
//
//  Created by Donatas Zitkus on 10/05/2025.
//

import XCTest

class RemoteFeedLoader {
    func load(){}
}

class HTTPClient {
    var requestedURL: String?
}

class RemoteFeedLoaderTests: XCTestCase {
    func test_init(){
        let client = HTTPClient()
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
}
