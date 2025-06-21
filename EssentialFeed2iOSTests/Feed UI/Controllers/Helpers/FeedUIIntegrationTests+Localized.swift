//
//  FeedViewControllerTests+Localized.swift
//  EssentialFeed2iOSTests
//
//  Created by Donatas Žitkus on 18/06/2025.
//

import XCTest

import Foundation
import EssentialFeed2

extension FeedUIIntegrationTests {
    func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        let table = "Feed"
        let bundle = Bundle(for: FeedPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
