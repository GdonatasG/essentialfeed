//
//  FeedImagePresenterTests.swift
//  EssentialFeed2Tests
//
//  Created by Donatas Žitkus on 21/06/2025.
//

import Foundation
import EssentialFeed2
import XCTest

class FeedImagePresenterTests: XCTestCase {
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (FeedImagePresenter<ViewSpy, Data>, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedImagePresenter(view: view) { data in data }
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(view, file: file, line: line)
        return (sut, view)
    }
    
    private class ViewSpy: FeedImageView {
        typealias Image = Data
        
        enum Message: Hashable {
            case display(FeedImageViewModelStruct<Data>)
        }
        
        var messages = Set<Message>()
        
        func display(_ model: FeedImageViewModelStruct<Data>) {
            messages.insert(.display(model))
        }
    }
}
