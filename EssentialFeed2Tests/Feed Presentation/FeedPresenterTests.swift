//
//  FeedPresenterTests.swift
//  EssentialFeed2Tests
//
//  Created by Donatas Žitkus on 20/06/2025.
//

import Foundation
import XCTest

struct FeedLoadingViewModel {
    let isLoading: Bool
}

protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

final class FeedPresenter {
    private let loadingView: FeedLoadingView
    
    init(loadingView: FeedLoadingView) {
        self.loadingView = loadingView
    }
    
    func didStartLoadingFeed() {
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }
}

class FeedPresenterTests: XCTestCase {
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    // Join no-error and loading checks into same test
    func test_didStartLoadingFeed_displaysLoadingMessage() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoadingFeed()
        
        XCTAssertEqual(view.messages, [.display(loading: true)])
    }
    
    // MARK: - helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedPresenter(loadingView: view)
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(view, file: file, line: line)
        return (sut, view)
    }
    
    private class ViewSpy: FeedLoadingView {
        enum Message: Equatable {
            case display(loading: Bool)
        }
        
        var messages = [Message]()
        
        func display(_ viewModel: FeedLoadingViewModel) {
            messages.append(.display(loading: viewModel.isLoading))
        }
    }
}
