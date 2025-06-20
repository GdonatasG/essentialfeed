//
//  FeedPresenterTests.swift
//  EssentialFeed2Tests
//
//  Created by Donatas Žitkus on 20/06/2025.
//

import Foundation
import XCTest

final class FeedPresenter {
    init(view: Any) {
        
    }
}

class FeedPresenterTests: XCTestCase {
    func test_init_doesNotSendMessagesToView() {
        let view = ViewSpy()
        
        _ = FeedPresenter(view: view)
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    // MARK: - helpers
    private class ViewSpy {
        let messages = [Any]()
    }
}
