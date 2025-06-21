//
//  FeedPresenterTests.swift
//  EssentialFeed2Tests
//
//  Created by Donatas Žitkus on 20/06/2025.
//

import Foundation
import XCTest
import EssentialFeed2

class FeedPresenterTests: XCTestCase {
    func test_title_isLocalized() {
        XCTAssertEqual(FeedPresenter.title, localized("FEED_VIEW_TITLE"))
    }
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    // Join no-error and loading checks into same test
    func test_didStartLoadingFeed_startsLoading() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoadingFeed()
        
        XCTAssertEqual(view.messages, [.display(loading: true)])
    }
    
    func test_didFinishLoadingFeed_displaysFeedAndStopsLoading() {
        let (sut, view) = makeSUT()
        let feed = uniqueImageFeed().models
        
        sut.didFinishLoadingFeed(with: feed)
        
        XCTAssertEqual(view.messages, [
            .display(feed: feed),
            .display(loading: false)
        ])
    }
    
    func test_didFinishLoadingFeedWithError_stopsLoading() {
        let (sut, view) = makeSUT()
        
        sut.didFinishLoadingFeedWithError(with: anyNSError())
        
        XCTAssertEqual(view.messages, [.display(loading: false)])
    }
        
    // MARK: - helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedPresenter(feedView: view, loadingView: view)
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(view, file: file, line: line)
        return (sut, view)
    }
    
    private func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        let table = "Feed"
        let bundle = Bundle(for: FeedPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)")
        }
        return value
    }
    
    private class ViewSpy: FeedView, FeedLoadingView {
        enum Message: Hashable {
            case display(feed: [FeedImage])
            case display(loading: Bool)
        }
        
        var messages = Set<Message>()
        
        func display(_ viewModel: FeedLoadingViewModel) {
            messages.insert(.display(loading: viewModel.isLoading))
        }
        
        func display(_ viewModel: FeedViewModel) {
            messages.insert(.display(feed: viewModel.feed))
        }
    }
}
