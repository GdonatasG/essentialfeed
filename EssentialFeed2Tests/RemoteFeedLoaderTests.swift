//
//  RemoteFeedLoaderTests.swift
//  EssentialFeed2Tests
//
//  Created by Donatas Zitkus on 10/05/2025.
//

import XCTest

class RemoteFeedLoader {
    func load(){
        HTTPClient.shared.requestedURL = URL(string: "https://url.com")
    }
}

class HTTPClient {
    static let shared = HTTPClient()
    
    private init() {}
    
    var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {
    func test_init(){
        let client = HTTPClient.shared
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL(){
        let client = HTTPClient.shared
        let sut = RemoteFeedLoader()
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
}
