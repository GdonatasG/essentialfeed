//
//  FeedViewControllerTests.swift
//  EssentialFeed2iOSTests
//
//  Created by Donatas Zitkus on 08/06/2025.
//

import XCTest

final class FeedViewController {
    init(loader: FeedViewControllerTests.LoaderSpy) {
        
    }
}

final class FeedViewControllerTests: XCTestCase {
    func test_init_doesNotLoadFeed() {
        let loader = LoaderSpy()
        _ = FeedViewController(loader: loader)
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    // MARK: - Helpers
    class LoaderSpy {
        private(set) var loadCallCount: Int = 0
    }
}
