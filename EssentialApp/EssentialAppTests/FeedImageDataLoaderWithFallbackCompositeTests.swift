//
//  FeedImageDataLoaderWithFallbackCompositeTests.swift
//  EssentialAppTests
//
//  Created by Donatas Žitkus on 25/06/2025.
//

import XCTest
import EssentialFeed2
import EssentialApp

class FeedImageDataLoaderWithFallbackCompositeTests: XCTestCase, FeedImageDataLoaderTestCase {
    func test_loadImageData_deliversPrimaryDataWithPrimaryLoaderSuccess() {
        let primaryData = Data("primary".utf8)
        let fallbackData = Data("fallback".utf8)
        let sut = makeSUT(primaryResult: .success(primaryData), fallbackResult: .success(fallbackData))
        
        expect(sut, toCompleteWith: .success(primaryData))
    }
    
    func test_loadImageData_deliversFallbackDataOnPrimaryFailure() {
        let fallbackData = Data("fallback".utf8)
        let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .success(fallbackData))
        
        expect(sut, toCompleteWith: .success(fallbackData))
    }
    
    func test_loadImageData_deliversErrorOnBothPrimaryAndFallbackLoaderFailure() {
        let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .failure(anyNSError()))

        expect(sut, toCompleteWith: .failure(anyNSError()))
    }
    
    // MARK: - Helpers
    private func makeSUT(primaryResult: FeedImageDataLoader.Result, fallbackResult: FeedImageDataLoader.Result, file: StaticString = #file, line: UInt = #line) -> FeedImageDataLoader {
        let primaryLoader = FeedImageDataLoaderStub(result: primaryResult)
        let fallbackLoader = FeedImageDataLoaderStub(result: fallbackResult)
        let sut = FeedImageDataLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        trackForMemoryLeak(primaryLoader, file: file, line: line)
        trackForMemoryLeak(fallbackLoader, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }
}
