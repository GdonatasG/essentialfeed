//
//  FeedViewControllerTests.swift
//  EssentialFeed2iOSTests
//
//  Created by Donatas Zitkus on 08/06/2025.
//

import XCTest
import UIKit
import EssentialFeed2
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
        XCTAssertFalse(sut.isShowingMainLoadingIndicator, "Expected no main loading indicator once loading is completed")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertFalse(sut.isShowingMainLoadingIndicator, "Expected no main loading indicator once user initiates a reload")

    }
    
    func test_pullToRefreshIndicator_isShownCorrectly() {
        let (sut, loader) = makeSUT()
            
        sut.loadViewIfNeeded()
        XCTAssertFalse(sut.isShowingPullToRefreshIndicator, "Expected no pull to refresh indicator once view is loaded")
        loader.completeFeedLoading(at: 0)
        
//        sut.simulateUserInitiatedFeedReload()
//        XCTAssertTrue(sut.isShowingPullToRefreshIndicator, "Expected pull to refresh indicator once user initiates a reload")
      
//        loader.completeFeedLoading(at: 1)
//        XCTAssertFalse(sut.isShowingPullToRefreshIndicator, "expected no pull to refresh indicator once user initiated loading is completed successfully")
        
//        sut.simulateUserInitiatedFeedReload()
//        XCTAssertTrue(sut.isShowingPullToRefreshIndicator, "Expected pull to refresh indicator once user initiates a reload")
        
//        loader.completeFeedLoadingWithError(at: 2)
//        XCTAssertFalse(sut.isShowingPullToRefreshIndicator, "Expected no pull to refresh indicator once user initiated loading is completed was completed with error")
    }
    
    func test_loadFeedCompletion_rendersSuccessfullyLoadedFeed() {
        let image0 = makeImage(description: "a description", location: "a location")
        let image1 = makeImage(description: nil, location: "an another location")
        let image2 = makeImage(description: "some another description", location: nil)
        let image3 = makeImage(description: nil, location: nil)
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        
        loader.completeFeedLoading(with: [image0], at: 0)
        assertThat(sut, isRendering: [image0])
        
        sut.simulateUserInitiatedFeedReload()
        loader.completeFeedLoading(with: [image0, image1, image2, image3], at: 1)
        assertThat(sut, isRendering: [image0, image1, image2, image3])
    }
    
    func test_loadFeedCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let image0 = makeImage()
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeFeedLoading(with: [image0], at: 0)
        assertThat(sut, isRendering: [image0])
        
        sut.simulateUserInitiatedFeedReload()
        loader.completeFeedLoadingWithError(at: 1)
        assertThat(sut, isRendering: [image0])
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        trackForMemoryLeak(loader, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private func makeImage(description: String? = nil, location: String? = nil, url: URL = URL(string: "http://any-url.com")!) -> FeedImage {
        return FeedImage(id: UUID(), description: description, location: location, url: url)
    }
    
    private func assertThat(_ sut: FeedViewController, isRendering feed: [FeedImage], file: StaticString = #filePath, line: UInt = #line) {
        guard sut.numberOfRenderedFeedImageViews() == feed.count else {
            return XCTFail("Expected \(feed.count) rendered images, got \(sut.numberOfRenderedFeedImageViews()) instead", file: file, line: line)
        }
        
        feed.enumerated().forEach { index, image in
            assertThat(sut, hasViewConfiguredFor: image, at: index, file: file, line: line)
        }
    }
    
    private func assertThat(_ sut: FeedViewController, hasViewConfiguredFor image: FeedImage, at index: Int, file: StaticString = #filePath, line: UInt = #line) {
        let view = sut.feedImageView(at: index) as? FeedImageCell
        
        guard let cell: FeedImageCell = view else {
            return XCTFail("Expected \(FeedImageCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }
        
        let shouldLocationBeVisible = (image.location != nil)
        XCTAssertEqual(cell.isShowingLocation, shouldLocationBeVisible, "Expected 'isShowingLocation' to be \(shouldLocationBeVisible) for image view at index \(index)", file: file, line: line)
        
        XCTAssertEqual(cell.locationText, image.location, "Expected location text to be \(String(describing: image.location)) for image view at index \(index)", file: file, line: line)
        
        XCTAssertEqual(cell.descriptionText, image.description, "Expected description text to be \(String(describing: image.description)) for image view at index \(index)", file: file, line: line)
    }
    
    class LoaderSpy: FeedLoader {
        private var completions = [(FeedLoader.Result) -> Void]()
        var loadCallCount: Int {
            return completions.count
        }
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            completions.append(completion)
        }
        
        func completeFeedLoading(with feed: [FeedImage] = [], at index: Int) {
            completions[index](.success(feed))
        }
        
        func completeFeedLoadingWithError(at index: Int) {
            completions[index](.failure(NSError(domain: "", code: 0)))
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
    
    func numberOfRenderedFeedImageViews() -> Int {
        return tableView.numberOfRows(inSection: feedImageSection)
    }
    
    func feedImageView(at row: Int) -> UITableViewCell? {
        let dataSource = tableView.dataSource
        let index = IndexPath(row: row, section: feedImageSection)
        return dataSource?.tableView(tableView, cellForRowAt: index)
    }
    
    private var feedImageSection: Int {
        return 0
    }
}

private extension FeedImageCell {
    var isShowingLocation: Bool {
        return !locationContainer.isHidden
    }
    
    var locationText: String? {
        return locationLabel.text
    }
    
    var descriptionText: String? {
        return descriptionLabel.text
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
