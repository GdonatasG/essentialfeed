//
//  XCTestCase+FeedStoreSpecs.swift
//  EssentialFeed2CacheTests
//
//  Created by Donatas Zitkus on 29/05/2025.
//

import XCTest
import EssentialFeed2
import EssentialFeed2Cache

extension FeedStoreSpecs where Self: XCTestCase {
    func expect(_ sut: FeedStore, toRetrieve expectedResult: FeedStore.RetrievalResult, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.success(.none), .success(.none)),
                (.failure, .failure):
                break
            case let (.success(.some(expectedCache)), .success(.some(retrievedCache))):
                XCTAssertEqual(expectedCache.feed, retrievedCache.feed, file: file, line: line)
                XCTAssertEqual(expectedCache.timestamp, retrievedCache.timestamp, file: file, line: line)
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 3.0)
    }
    
    func expect(_ sut: FeedStore, toRetrieveTwice expectedResult: FeedStore.RetrievalResult, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult)
        expect(sut, toRetrieve: expectedResult)
    }
    
    @discardableResult
    func insert(_ cache: (feed: [LocalFeedImage], timestamp: Date), to sut: FeedStore) -> Error? {
        let exp = expectation(description: "Wait for insert completion")
        
        var insertionError: Error?
        sut.insert(cache.feed, timestamp: cache.timestamp) { insertionResult in
            switch insertionResult {
            case let .failure(error):
                insertionError = error
            case .success:
                break
            }
            
            exp.fulfill()
        }
        wait(for: [exp], timeout: 3.0)
        return insertionError
    }
    
    func deleteCache(from sut: FeedStore) -> Error? {
        let exp = expectation(description: "Wait for deletion completion")

        var deletionError: Error?
        
        sut.deleteCachedFeed { deletionResult in
            switch deletionResult {
            case let .failure(error):
                deletionError = error
            case .success:
                break
            }
            
            exp.fulfill()
        }
        wait(for: [exp], timeout: 3.0)
        return deletionError
    }
}
