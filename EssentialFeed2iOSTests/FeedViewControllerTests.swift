//
//  FeedViewControllerTests.swift
//  EssentialFeed2iOSTests
//
//  Created by Donatas Zitkus on 08/06/2025.
//

import XCTest
import UIKit
import EssentialFeed2iOS

final class FeedViewControllerTests: XCTestCase {
    func test_loadFeedActions_requestFeedFromLoader() {
        let (sut, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadCallCount, 1, "Expected a loading request once view is loaded")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadCallCount, 2, "Expected another loading request once user initiates a loading")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadCallCount, 3, "Expected a third loading request once user initiates another loading")
    }
    
    func test_mainLoadingIndicator_isShownCorrectly() {
        let (sut, loader) = makeSUT()
            
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingMainLoadingIndicator, "Expected main loading indicator once view is loaded")
        XCTAssertFalse(sut.isShowingPullToRefreshIndicator, "Expected no pull to refresh indicator once view is loaded")
        
        loader.completeFeedLoading(at: 0)
        XCTAssertFalse(sut.isShowingMainLoadingIndicator, "Expected no loading indicator once loading is completed")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertFalse(sut.isShowingMainLoadingIndicator, "Expected no loading indicator once user initiates a reload")
    }
    
    func test_pullToRefreshIndicator_isShownCorrectly() {
        let (sut, loader) = makeSUT()
            
        sut.loadViewIfNeeded()
        XCTAssertFalse(sut.isShowingPullToRefreshIndicator, "Expected no pull to refresh indicator once view is loaded")
        loader.completeFeedLoading(at: 0)
        
//        sut.simulateUserInitiatedFeedReload()
//        XCTAssertTrue(sut.isShowingPullToRefreshIndicator, "Expected pull to refresh indicator once user initiates a reload")
//        
//        loader.completeFeedLoading(at: 1)
//        XCTAssertFalse(sut.isShowingPullToRefreshIndicator, "expected no pull to refresh indicator once user initiated loading is completed")
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        trackForMemoryLeak(loader, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        return (sut, loader)
    }
    
    class LoaderSpy: FeedLoader {
        private var completions = [(FeedLoader.Result) -> Void]()
        var loadCallCount: Int {
            return completions.count
        }
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            completions.append(completion)
        }
        
        func completeFeedLoading(at index: Int) {
            completions[index](.success([]))
        }
    }
}

private extension FeedViewController {
    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    var isShowingPullToRefreshIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
    
    var isShowingMainLoadingIndicator: Bool {
        return mainLoadingIndicator.isAnimating
    }
}

private extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
