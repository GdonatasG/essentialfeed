//
//  FeedUIIntegrationTests+Localized.swift
//  EssentialAppTests
//
//  Created by Donatas Žitkus on 29/06/2025.
//

import XCTest

import Foundation
import EssentialFeed2
import EssentialFeed2Presentation

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
