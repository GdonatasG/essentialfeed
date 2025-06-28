//
//  FeedImageDataLoaderCacheDecorator.swift
//  EssentialAppTests
//
//  Created by Donatas Žitkus on 28/06/2025.
//

import XCTest
import EssentialFeed2
import EssentialApp

class FeedImageDataLoaderCacheDecoratorTests: XCTestCase, FeedImageDataLoaderTestCase {
    func test_loadImageData_deliversImageDataOnLoaderSuccess() {
        let imageData = Data("data".utf8)
        let sut = makeSUT(loaderResult: .success(imageData))
        
        expect(sut, toCompleteWith: .success(imageData))
    }
    
    func test_loadImageData_deliversErrorOnLoaderFailure() {
        let sut = makeSUT(loaderResult: .failure(anyNSError()))
        
        expect(sut, toCompleteWith: .failure(anyNSError()))
    }
    
    func test_loadImageData_cachesLoadedImageDataOnLoaderSuccess() {
        let cache = CacheSpy()
        let imageData = Data("data".utf8)
        let sut = makeSUT(loaderResult: .success(imageData), cache: cache)
        
        _ = sut.loadImageData(from: anyURL()) { _ in }
        
        XCTAssertEqual(cache.messages, [.save(imageData)], "Expected to cache loaded image data on success")
    }
    
    func test_loadImageData_doesNotCacheOnLoaderFailure() {
        let cache = CacheSpy()
        let sut = makeSUT(loaderResult: .failure(anyNSError()), cache: cache)
        
        _ = sut.loadImageData(from: anyURL()) { _ in }
        
        XCTAssertTrue(cache.messages.isEmpty, "Expected no cache on loader failure")
    }
    
    // MARK: - Helpers
    private func makeSUT(loaderResult: FeedImageDataLoader.Result, cache: CacheSpy = .init(), file: StaticString = #file, line: UInt = #line) -> FeedImageDataLoader {
        let loader = FeedImageDataLoaderStub(result: loaderResult)
        let sut = FeedImageDataLoaderCacheDecorator(decoratee: loader, cache: cache)
        trackForMemoryLeak(loader, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }
    
    private class CacheSpy: FeedImageDataCache {
        private(set) var messages = [Message]()
        
        enum Message: Equatable {
            case save(Data)
        }
        
        func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void) {
            messages.append(.save(data))
            completion(.success(()))
        }
    }
}
