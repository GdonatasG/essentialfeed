//
//  CacheFeedUseCase.swift
//  EssentialFeed2Tests
//
//  Created by Donatas Zitkus on 21/05/2025.
//

import XCTest
import EssentialFeed2

class FeedStore {
    var deleteCachedFeedCallCount = 0
}

class LocalFeedLoader {
    private let store: FeedStore
    
    init(store: FeedStore) {
        self.store = store
    }
}

class CacheFeedUseCase: XCTestCase {
    func test_init_doesNotDeleteCacheUponCreation() {
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)
        
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }
}
